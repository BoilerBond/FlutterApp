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

class ProtectedText extends StatefulWidget {
  final String content;
  final TextStyle? style;
  final TextAlign? textAlign;

  const ProtectedText(this.content, {this.style, this.textAlign});

  @override
  _ProtectedTextState createState() => _ProtectedTextState();
}

class _ProtectedTextState extends State<ProtectedText> {
  bool _isHidden = true;
  bool _loading = true;
  SafetyCacheListNode? _head;
  SafetyCacheListNode? _tail;
  static final Lock _lock = Lock();
  static final Map<String, SafetyCacheListNode> _cache = {};
  static final int _cacheCapacity = 10;

  @override
  void initState() {
    super.initState();
    checkIfSensitive();
  }

  void insertStringInCacheList(SafetyCacheListNode item) {
    if (_head == null) {
      _head = item;
      _tail = _head;
    } else {
      item.next = _head;
      _head!.prev = item;
      _head = item;
    }
  }

  Future<void> checkIfSensitive() async {
    bool sensitive;
    if (_cache.containsKey(widget.content)) {
      sensitive = _cache[widget.content]!.sensitive;

      // Updates item recency
      await _lock.synchronized(() {
        if (_cache[widget.content]! == _tail) {
          _cache[widget.content]!.prev!.next = null;
          _tail = _cache[widget.content]!.prev;
        } else if (_cache[widget.content]! != _head) {
          _cache[widget.content]!.prev?.next = _cache[widget.content]!.next;
          _cache[widget.content]!.next?.prev = _cache[widget.content]!.prev;
        }
      });
    } else {
      sensitive = await SafeText.containsBadWord(text: widget.content);
      _cache[widget.content] = SafetyCacheListNode(widget.content, sensitive);

      // Adds item to cache
      await _lock.synchronized(() {
        insertStringInCacheList(_cache[widget.content]!);

        // Removes least recently used item from cache if cache exceeds capacity
        if (_cache.length > _cacheCapacity) {
          if (_tail != null) {
            if (_head == _tail) {
              _head = null;
            }
            _cache.remove(_tail!.str);
            _tail = _tail!.prev;
            _tail?.next = null;
          }
        }
      });
    }

    try {
      setState(() {
        _isHidden = sensitive;
        _loading = false;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  MainAxisAlignment _getTextAlignment() {
    switch (widget.textAlign) {
      case TextAlign.center:
        return MainAxisAlignment.center;
      case TextAlign.right:
        return MainAxisAlignment.end;
      case TextAlign.left:
      default:
        return MainAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _getTextAlignment(),
      children: [
        Text(
          _loading
              ? "Loading..."
              : _isHidden
                  ? "Sensitive Text Detected"
                  : widget.content,
          style: widget.style ?? TextStyle(fontStyle: _isHidden || _loading ? FontStyle.italic : FontStyle.normal),
        ),
        if (_isHidden && !_loading) TextButton(onPressed: _toggleVisibility, child: Text("Reveal", style: TextStyle(fontSize: widget.style?.fontSize)))
      ],
    );
  }
}
