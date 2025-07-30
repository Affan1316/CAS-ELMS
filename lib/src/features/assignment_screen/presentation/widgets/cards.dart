import 'package:flutter_cas_app_main/src/features/assignment_screen/presentation/pages/assignments_detail_page.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class StageCard extends StatefulWidget {
  final String title;
  final String extraDetail;

  const StageCard({super.key, required this.title, required this.extraDetail});

  @override
  State<StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<StageCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 10,
        intensity: 0.85,
        surfaceIntensity: 0.35,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/if_else_assign_image.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: NeumorphicButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InboxPage(),
                        ),
                      );
                    },
                    style: const NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 1,
                      intensity: 0.5,
                      shape: NeumorphicShape.flat,
                      shadowLightColor: Colors.white,
                      shadowDarkColor: Colors.black45,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.arrow_outward,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.extraDetail,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                    NeumorphicButton(
                      onPressed: () {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                      },
                      style: NeumorphicStyle(
                        boxShape: const NeumorphicBoxShape.circle(),
                        depth: isBookmarked ? -6 : 6,
                        intensity: 0.9,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            isBookmarked ? Colors.deepPurple : Colors.black87,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
