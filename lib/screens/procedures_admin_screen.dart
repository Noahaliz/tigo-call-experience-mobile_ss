import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class ProceduresAdminScreen extends StatefulWidget {
  const ProceduresAdminScreen({super.key});
  @override State<ProceduresAdminScreen> createState()=>_State();
}

class _State extends State<ProceduresAdminScreen>{
  late Future<List<Map<String,dynamic>>> future;
  @override void initState(){super.initState();future=AdminService.procedures();}
  void reload()=>setState(()=>future=AdminService.procedures());

  Future<void> form([Map<String,dynamic>? p])async{
    final t=TextEditingController(text:p?['title']??'');
    final d=TextEditingController(text:p?['description']??'');
    final c=TextEditingController(text:p?['category']??'');
    var pub=p?['published']??true;
    final ok=await showDialog<bool>(context:context,builder:(_)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(
      title:Text(p==null?'Nuevo procedimiento':'Editar procedimiento'),
      content:SizedBox(width:560,child:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:t,decoration:const InputDecoration(labelText:'Título')),const SizedBox(height:10),
        TextField(controller:d,maxLines:4,decoration:const InputDecoration(labelText:'Descripción')),const SizedBox(height:10),
        TextField(controller:c,decoration:const InputDecoration(labelText:'Categoría')),
        SwitchListTile(value:pub,onChanged:(v)=>setLocal(()=>pub=v),title:const Text('Publicado')),
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Guardar'))],
    )));
    if(ok==true){await AdminService.saveProcedure({'title':t.text,'description':d.text,'category':c.text,'published':pub},id:p==null?null:(p['id']as num).toInt());reload();}
  }

  Future<void> steps(Map<String,dynamic> procedure) async {
    final id=(procedure['id'] as num).toInt();
    if(!mounted)return;
    await showDialog(context:context,builder:(context)=>StatefulBuilder(builder:(context,setLocal){
      Future<List<Map<String,dynamic>>> load()=>AdminService.procedureSteps(id);
      return AlertDialog(
        title:Text('Pasos · ${procedure['title']}'),
        content:SizedBox(width:700,height:480,child:FutureBuilder<List<Map<String,dynamic>>>(
          future:load(),
          builder:(context,s){
            if(!s.hasData)return const Center(child:CircularProgressIndicator());
            final rows=s.data!;
            return ListView(children:[
              FilledButton.icon(onPressed:()async{
                final title=TextEditingController(); final desc=TextEditingController(); final pos=TextEditingController(text:'${rows.length+1}');
                final ok=await showDialog<bool>(context:context,builder:(c)=>AlertDialog(title:const Text('Nuevo paso'),content:SizedBox(width:500,child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:title,decoration:const InputDecoration(labelText:'Título')),const SizedBox(height:10),TextField(controller:desc,maxLines:4,decoration:const InputDecoration(labelText:'Descripción')),const SizedBox(height:10),TextField(controller:pos,decoration:const InputDecoration(labelText:'Orden'))])),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('Agregar'))]));
                if(ok==true){await AdminService.saveProcedureStep(id,title.text,desc.text,int.tryParse(pos.text)??rows.length+1);setLocal((){});}
              },icon:const Icon(Icons.add),label:const Text('Agregar paso')),
              const SizedBox(height:12),
              ...rows.map((r)=>Card(child:ListTile(leading:CircleAvatar(child:Text('${r['position']??''}')),title:Text(r['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(r['description']??''),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:()async{await AdminService.deleteProcedureStep((r['id']as num).toInt());setLocal((){});})))),
            ]);
          },
        )),
        actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cerrar'))],
      );
    }));
  }

  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    return ListView(padding:const EdgeInsets.all(30),children:[
      Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Procedimientos',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Crea guías y administra sus pasos.') ])),FilledButton.icon(onPressed:()=>form(),icon:const Icon(Icons.add),label:const Text('Nuevo'))]),
      const SizedBox(height:18),
      ...s.data!.map((p)=>Card(child:ListTile(
        title:Text(p['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${p['category']??'General'} · ${p['published']==true?'Publicado':'Oculto'}'),
        trailing:Wrap(spacing:4,children:[IconButton(tooltip:'Pasos',icon:const Icon(Icons.format_list_numbered),onPressed:()=>steps(p)),IconButton(tooltip:'Editar',icon:const Icon(Icons.edit),onPressed:()=>form(p))]),
      ))),
    ]);
  }));
}
