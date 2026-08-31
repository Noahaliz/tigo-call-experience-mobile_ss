import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class LessonsAdminScreen extends StatefulWidget {
  const LessonsAdminScreen({super.key});
  @override State<LessonsAdminScreen> createState()=>_LessonsAdminScreenState();
}

class _LessonsAdminScreenState extends State<LessonsAdminScreen>{
  late Future<List<Map<String,dynamic>>> future;
  @override void initState(){super.initState();future=AdminService.lessons();}
  void reload()=>setState(()=>future=AdminService.lessons());

  Future<void> form([Map<String,dynamic>? item]) async{
    final courses=await AdminService.courses(); if(!mounted||courses.isEmpty)return;
    int? courseId=item==null?(courses.first['id'] as num).toInt():(item['course_id'] as num).toInt();
    final title=TextEditingController(text:item?['title']??'');
    final intro=TextEditingController(text:item?['introduction']??'');
    final content=TextEditingController(text:item?['content']??'');
    final summary=TextEditingController(text:item?['summary']??'');
    final video=TextEditingController(text:item?['video_url']??'');
    final image=TextEditingController(text:item?['image_url']??'');
    final audio=TextEditingController(text:item?['audio_url']??'');
    final document=TextEditingController(text:item?['document_url']??'');
    final pos=TextEditingController(text:'${item?['position']??0}');
    var published=item?['published']??true;
    final ok=await showDialog<bool>(context:context,builder:(_)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(
      title:Text(item==null?'Nueva lección':'Editar lección'),
      content:SizedBox(width:720,child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        DropdownButtonFormField<int>(initialValue:courseId,items:courses.map((c)=>DropdownMenuItem(value:(c['id'] as num).toInt(),child:Text(c['title']??''))).toList(),onChanged:(v)=>setLocal(()=>courseId=v),decoration:const InputDecoration(labelText:'Curso')),
        const SizedBox(height:10),TextField(controller:title,decoration:const InputDecoration(labelText:'Título')),
        const SizedBox(height:10),TextField(controller:intro,maxLines:2,decoration:const InputDecoration(labelText:'Introducción')),
        const SizedBox(height:10),TextField(controller:content,maxLines:7,decoration:const InputDecoration(labelText:'Contenido')),
        const SizedBox(height:10),TextField(controller:summary,maxLines:3,decoration:const InputDecoration(labelText:'Resumen')),
        const SizedBox(height:10),TextField(controller:video,decoration:const InputDecoration(labelText:'URL de video')),
        const SizedBox(height:10),TextField(controller:image,decoration:const InputDecoration(labelText:'URL de imagen')),
        const SizedBox(height:10),TextField(controller:audio,decoration:const InputDecoration(labelText:'URL de audio')),
        const SizedBox(height:10),TextField(controller:document,decoration:const InputDecoration(labelText:'URL de PDF / documento')),
        const SizedBox(height:10),TextField(controller:pos,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Orden')),
        SwitchListTile(value:published,onChanged:(v)=>setLocal(()=>published=v),title:const Text('Publicada')),
      ]))),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Guardar'))],
    )));
    if(ok==true&&courseId!=null){
      await AdminService.saveLesson({
        'course_id':courseId,'title':title.text.trim(),'introduction':intro.text.trim(),'content':content.text.trim(),'summary':summary.text.trim(),
        'video_url':video.text.trim(),'image_url':image.text.trim(),'audio_url':audio.text.trim(),'document_url':document.text.trim(),
        'position':int.tryParse(pos.text)??0,'published':published,
      },id:item==null?null:(item['id'] as num).toInt());
      reload();
    }
  }

  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    return ListView(padding:const EdgeInsets.all(30),children:[
      Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Lecciones',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Texto, resumen y recursos multimedia por curso.') ])),FilledButton.icon(onPressed:()=>form(),icon:const Icon(Icons.add),label:const Text('Nueva lección'))]),
      const SizedBox(height:18),
      ...s.data!.map((l)=>Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.article_outlined)),
        title:Text(l['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${l['courses']?['title']??'Sin curso'} · ${l['published']==true?'Publicada':'Oculta'}'),
        trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>form(l)),
      ))),
    ]);
  }));
}
