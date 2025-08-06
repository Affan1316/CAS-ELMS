import 'package:flutter_inquery_page/inquiry_page/presentation/widgets/model/inquiry.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.inquiry});
  final Inquiry inquiry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: NeumorphicIcon(
        Icons.arrow_drop_down_circle,
        size: 32,
        style: NeumorphicStyle(color: Colors.grey[600], intensity: 0.4),
      ),
      title: Text(
        inquiry.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(inquiry.isConfirmed ? 'Confirmed' : 'Not Confirmed'),
      trailing: Text(
        '${inquiry.date.day}/${inquiry.date.month}/${inquiry.date.year}.',
      ),
    );
  }
}
