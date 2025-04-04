import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';
import '../../../widgets/protected_text.dart';

class MatchIntroScreen extends StatefulWidget {
  final AppUser curUser;
  final AppUser match;

  const MatchIntroScreen({Key? key, required this.curUser, required this.match})
      : super(key: key);

  @override
  State<MatchIntroScreen> createState() => _MatchIntroScreenState();
}

class _MatchIntroScreenState extends State<MatchIntroScreen> {
  int _pageIndex = 0;

  void _nextPage() {
    setState(() {
      if (_pageIndex < 2) _pageIndex++;
    });
  }

  Widget _buildPhotoItem(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return Align(
                    child: Padding (
                        padding: EdgeInsets.all(20),
                        child: Hero(
                                tag: "zoom",
                                child: Image.network(url)
                        )
                    )
                  );
                }
            )
        );
      },
      child: Image.network(url),
    );
  }

  List<Widget> _buildPages() {
    return [
      // First page: introduce match
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Get to Know Them",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(
              child: Center(
                  child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundImage: widget.match.profilePictureURL.isEmpty ?
                                    NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                    : NetworkImage(widget.match.profilePictureURL),
                                radius: MediaQuery.of(context).size.width * 0.15,
                                backgroundColor: const Color(0xFFCDFCFF),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                  children: [
                                    ProtectedText(widget.match.firstName + " " + widget.match.lastName,  style: TextStyle(fontSize: 20)),
                                    Text("Age: " + widget.match.age.toString(), style: TextStyle(color: Colors.grey, fontSize: 20),),
                                    ProtectedText("Bio: " + widget.match.bio, style: TextStyle(color: Colors.grey, fontSize: 20),)
                                  ]
                              )
                            ]
                        ),
                        const SizedBox(height: 20),
                        widget.match.photosURL.isEmpty
                            ? Text(
                          widget.match.firstName + " has no photos uploaded.",
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        )
                            : SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GridView.count(
                            crossAxisCount: (widget.match.photosURL.length < 3) ? 1 : 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: widget.match.photosURL.map(
                                  (photoURL) {
                                    return _buildPhotoItem(photoURL);
                                  }
                            ).toList(),
                          ),
                        ),
                      ]
                  )
              ))
        ],
      ),

      // Second page: Common traits
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What You Have in Common",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...widget.curUser
              .getSharedTraits(widget.match)
              .map((trait) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child:
                        Text("• $trait", style: const TextStyle(fontSize: 16)),
                  )),
        ],
      ),

      // Third page: Match Reason
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your compatibility",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(widget.curUser.getMatchReason(widget.match),
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("You're Matched!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context), // Return Bond screen
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: pages[_pageIndex],
      ),
      bottomNavigationBar: (_pageIndex < pages.length - 1)
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C519C)),
                child: const Text("Next",
                  style: TextStyle(
                    color: const Color(0xFFf2f7ff)
                  )),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C519C)),
                child: const Text("Done",
                    style: TextStyle(
                        color: const Color(0xFFf2f7ff)
                    )),
              ),
            ),
    );
  }
}
