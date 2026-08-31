import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class AuditAdminScreen extends StatelessWidget {
  const AuditAdminScreen({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:AdminService.audit(),builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    return ListView(padding:const EdgeInsets.all(30),children:[
      const Text('Auditoría',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),
      const Text('Registro de cambios administrativos sobre contenidos y usuarios.'),const SizedBox(height:18),
      ...s.data!.map((a)=>Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.history)),
        title:Text('${a['action']??'Acción'} · ${a['entity_type']??''}',style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${a['profiles']?['full_name']??'Sistema'} · ${a['created_at']??''}'),
        trailing:Text('#${a['entity_id']??'-'}'),
      ))),
    ]);
  }));
}
