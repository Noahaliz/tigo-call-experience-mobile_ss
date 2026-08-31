import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class NotificationsAdminScreen extends StatefulWidget { const NotificationsAdminScreen({super.key}); @override State<NotificationsAdminScreen> createState()=>_State(); }
class _State extends State<NotificationsAdminScreen>{
  late Future<List<Map<String,dynamic>>> future;
  @override void initState(){super.initState();future=AdminService.notifications();}
  void reload()=>setState(()=>future=AdminService.notifications());
  Future<void> create()async{
    final title=TextEditingController(); final message=TextEditingController(); String role='todos'; bool published=true;
    final ok=await showDialog<bool>(context:context,builder:(_)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(
      title:const Text('Nueva notificación'),
      content:SizedBox(width:560,child:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:title,decoration:const InputDecoration(labelText:'Título')),const SizedBox(height:10),
        TextField(controller:message,maxLines:4,decoration:const InputDecoration(labelText:'Mensaje')),const SizedBox(height:10),
        DropdownButtonFormField<String>(initialValue:role,items:const [DropdownMenuItem(value:'todos',child:Text('Todos')),DropdownMenuItem(value:'asesor',child:Text('Asesores')),DropdownMenuItem(value:'capacitador',child:Text('Capacitadores')),DropdownMenuItem(value:'team_leader',child:Text('Team Leaders'))],onChanged:(v){if(v!=null)setLocal(()=>role=v);},decoration:const InputDecoration(labelText:'Audiencia')),
        SwitchListTile(value:published,onChanged:(v)=>setLocal(()=>published=v),title:const Text('Publicar ahora')),
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Enviar'))],
    )));
    if(ok==true){await AdminService.saveNotification({'title':title.text.trim(),'message':message.text.trim(),'audience_role':role=='todos'?null:role,'published':published});reload();}
  }
  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(padding:const EdgeInsets.all(30),children:[
    Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Notificaciones',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Comunica novedades, cursos y evaluaciones.') ])),FilledButton.icon(onPressed:create,icon:const Icon(Icons.add_alert),label:const Text('Nueva'))]),const SizedBox(height:18),
    ...s.data!.map((n)=>Card(child:ListTile(leading:const CircleAvatar(child:Icon(Icons.notifications_none)),title:Text(n['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${n['message']??''}\nAudiencia: ${n['audience_role']??'todos'}'),isThreeLine:true,trailing:Chip(label:Text(n['published']==true?'Publicada':'Borrador'))))),
  ]);}));
}
