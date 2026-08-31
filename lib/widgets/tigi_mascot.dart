import 'package:flutter/material.dart';
import '../core/admin_theme.dart';

enum AdminTigiMood { happy, thinking, celebrate }

class AdminTigiMascot extends StatelessWidget {
  final double size;
  final AdminTigiMood mood;
  const AdminTigiMascot({super.key, this.size = 90, this.mood = AdminTigiMood.happy});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _Painter(mood)),
  );
}

class _Painter extends CustomPainter {
  final AdminTigiMood mood;
  _Painter(this.mood);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final blue = Paint()..color = AdminColors.primary;
    final white = Paint()..color = Colors.white;
    final navy = Paint()..color = AdminColors.navy;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*.17,h*.18,w*.66,h*.66), Radius.circular(w*.28)),
      blue,
    );
    canvas.drawCircle(Offset(w*.29,h*.20), w*.12, blue);
    canvas.drawCircle(Offset(w*.71,h*.20), w*.12, blue);
    canvas.drawCircle(Offset(w*.37,h*.43), w*.065, white);
    canvas.drawCircle(Offset(w*.63,h*.43), w*.065, white);
    canvas.drawCircle(Offset(w*.37,h*.44), w*.027, navy);
    canvas.drawCircle(Offset(w*.63,h*.44), w*.027, navy);
    final mouth = Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=w*.025..strokeCap=StrokeCap.round;
    if (mood == AdminTigiMood.thinking) {
      canvas.drawLine(Offset(w*.43,h*.61), Offset(w*.57,h*.61), mouth);
    } else {
      canvas.drawArc(Rect.fromCenter(center:Offset(w*.5,h*.56),width:w*.28,height:h*.18),.2,2.7,false,mouth);
    }
    if (mood == AdminTigiMood.celebrate) {
      final p = Paint()..strokeWidth=w*.025..strokeCap=StrokeCap.round;
      p.color=const Color(0xFF00AEEF); canvas.drawLine(Offset(w*.06,h*.2),Offset(w*.13,h*.12),p);
      p.color=const Color(0xFFF59E0B); canvas.drawLine(Offset(w*.87,h*.13),Offset(w*.94,h*.2),p);
    }
  }
  @override bool shouldRepaint(covariant _Painter oldDelegate) => oldDelegate.mood != mood;
}
