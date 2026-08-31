import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../widgets/tigi_mascot.dart';
import 'admin_login_screen.dart';
import 'dashboard_admin_screen.dart';
import 'courses_admin_screen.dart';
import 'lessons_admin_screen.dart';
import 'questions_admin_screen.dart';
import 'procedures_admin_screen.dart';
import 'simulations_admin_screen.dart';
import 'notifications_admin_screen.dart';
import 'assignments_admin_screen.dart';
import 'advisors_admin_screen.dart';
import 'ranking_admin_screen.dart';
import 'reports_admin_screen.dart';
import 'feedback_admin_screen.dart';
import 'audit_admin_screen.dart';

class AdminShell extends StatefulWidget { const AdminShell({super.key}); @override State<AdminShell> createState()=>_AdminShellState(); }
class _AdminShellState extends State<AdminShell>{
  int selected=0;
  final pages=const [DashboardAdminScreen(),CoursesAdminScreen(),LessonsAdminScreen(),QuestionsAdminScreen(),ProceduresAdminScreen(),SimulationsAdminScreen(),AssignmentsAdminScreen(),NotificationsAdminScreen(),AdvisorsAdminScreen(),RankingAdminScreen(),ReportsAdminScreen(),FeedbackAdminScreen(),AuditAdminScreen()];
  final labels=const ['Dashboard','Cursos','Lecciones','Preguntas','Procedimientos','Simulaciones','Plan','Notificaciones','Usuarios','Ranking','Reportes','Feedback','Auditoría'];
  final icons=const [Icons.dashboard,Icons.menu_book,Icons.article,Icons.quiz,Icons.rule_folder,Icons.headset_mic,Icons.assignment_turned_in,Icons.notifications,Icons.people,Icons.emoji_events,Icons.analytics,Icons.feedback_outlined,Icons.history];

  Widget menu({required bool compact})=>Container(width:compact?82:250,color:const Color(0xFF003C71),child:SafeArea(child:Column(children:[
    Padding(padding:const EdgeInsets.all(18),child:compact?const AdminTigiMascot(size:48):const Row(children:[AdminTigiMascot(size:54),SizedBox(width:10),Expanded(child:Text('Tigo Aprende\nAdmin',style:TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.w900)))])),
    Expanded(child:ListView.builder(itemCount:labels.length,itemBuilder:(_,i)=>Tooltip(message:labels[i],child:ListTile(selected:selected==i,selectedTileColor:Colors.white12,leading:Icon(icons[i],color:Colors.white),title:compact?null:Text(labels[i],style:const TextStyle(color:Colors.white)),onTap:()=>setState(()=>selected=i))))),
    ListTile(leading:const Icon(Icons.logout,color:Colors.white),title:compact?null:const Text('Cerrar sesión',style:TextStyle(color:Colors.white)),onTap:()async{await AdminService.logout();if(!mounted)return;Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const AdminLoginScreen()),(_)=>false);}),const SizedBox(height:10),
  ])));

  @override Widget build(BuildContext context)=>LayoutBuilder(builder:(context,c)=>Scaffold(body:Row(children:[menu(compact:c.maxWidth<1100),Expanded(child:pages[selected])])));
}
