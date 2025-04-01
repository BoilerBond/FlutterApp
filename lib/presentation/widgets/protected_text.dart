import 'package:datingapp/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:safe_text/safe_text.dart';
import 'package:synchronized/synchronized.dart';

// Simple LRU cache for storing whether a string is sensitive
class SafetyCacheListNode {
  String str;
  bool sensitive;
  SafetyCacheListNode? prev;
  SafetyCacheListNode? next;

  SafetyCacheListNode(this.str, this.sensitive);
}

class SafetyCache {
  static final Map<String, SafetyCacheListNode> _cache = {};
  static final Lock _lock = Lock();
  static SafetyCacheListNode? _head;
  static SafetyCacheListNode? _tail;
  static const int _cacheCapacity = 50;

  static void _insertAtHead(SafetyCacheListNode node) {
    if (_head == null) {
      _head = node;
      _tail = _head;
    } else {
      node.next = _head;
      _head!.prev = node;
      _head = node;
    }
  }

  static Future<bool> isSensitive(String text) async {
    bool sensitive = false;

    await _lock.synchronized(() async {
      if (_cache.containsKey(text)) {
        final node = _cache[text]!;
        sensitive = node.sensitive;

        // Move to head if not already there
        if (node != _head) {
          // Remove from current position
          if (node.prev != null) node.prev!.next = node.next;
          if (node.next != null) node.next!.prev = node.prev;
          if (node == _tail) _tail = node.prev;

          // Insert at head
          _insertAtHead(node);
        }
      } else {
        sensitive = await SafeText.containsBadWord(
          text: text,
          useDefaultWords: false,
          extraWords: Constants.offensiveWords
        );
        final newNode = SafetyCacheListNode(text, sensitive);
        _cache[text] = newNode;
        _insertAtHead(newNode);

        // Evict LRU if capacity exceeded
        if (_cache.length > _cacheCapacity && _tail != null) {
          _cache.remove(_tail!.str);
          _tail = _tail!.prev;
          if (_tail != null) _tail!.next = null;
          else _head = null;
        }
      }
    });

    return sensitive;
  }
}

class ProtectedText extends StatefulWidget {
  final String content;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? revealButtonSpacing;

  const ProtectedText(
    this.content, {
    this.style,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.textAlign,
    this.revealButtonSpacing = 8.0,
  });

  @override
  _ProtectedTextState createState() => _ProtectedTextState();
}

class _ProtectedTextState extends State<ProtectedText> {
  bool _isHidden = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkSensitivity();
  }

  Future<void> _checkSensitivity() async {
    final sensitive = await SafetyCache.isSensitive(widget.content);
    if (mounted) {
      setState(() {
        _isHidden = sensitive;
        _loading = false;
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (widget.textAlign) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.right:
        return CrossAxisAlignment.end;
      case TextAlign.left:
      default:
        return CrossAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: _getCrossAxisAlignment(),
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                child: Text(
                  _loading
                      ? "Loading..."
                      : _isHidden
                          ? "Sensitive Text Detected"
                          : widget.content,
                  overflow: widget.overflow,
                  maxLines: widget.maxLines,
                  textAlign: widget.textAlign,
                  style: widget.style ??
                      TextStyle(
                        fontStyle: _isHidden || _loading
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                ),
              ),
              if (_isHidden && !_loading)
                Padding(
                  padding: EdgeInsets.only(top: widget.revealButtonSpacing!),
                  child: TextButton(
                    onPressed: _toggleVisibility,
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Reveal",
                      style: TextStyle(
                        fontSize: widget.style?.fontSize,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}