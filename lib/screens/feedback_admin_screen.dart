import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class FeedbackAdminScreen extends StatelessWidget {
  const FeedbackAdminScreen({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:AdminService.feedback(),builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    final rows=s.data!;
    final useful=rows.where((r)=>r['useful']==true).length;
    return ListView(padding:const EdgeInsets.all(30),children:[
      const Text('Feedback de contenidos',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),
      Text(rows.isEmpty?'Aún no hay valoraciones.':'$useful de ${rows.length} valoraciones consideran útil el contenido.'),
      const SizedBox(height:18),
      ...rows.map((r)=>Card(child:ListTile(
        leading:Icon(r['useful']==true?Icons.thumb_up_alt_outlined:Icons.thumb_down_alt_outlined,color:r['useful']==true?Colors.green:Colors.orange),
        title:Text('${r['content_type']??'contenido'} #${r['content_id']??''}',style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${r['profiles']?['full_name']??'Usuario'}${(r['comment']??'').toString().isEmpty?'':' · ${r['comment']}'}'),
      ))),
    ]);
  }));
}
