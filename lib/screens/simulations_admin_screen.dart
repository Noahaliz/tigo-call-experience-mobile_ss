import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class SimulationsAdminScreen extends StatefulWidget{const SimulationsAdminScreen({super.key});@override State<SimulationsAdminScreen> createState()=>_State();}
class _State extends State<SimulationsAdminScreen>{
  late Future<List<Map<String,dynamic>>> future;@override void initState(){super.initState();future=AdminService.simulations();}void reload()=>setState(()=>future=AdminService.simulations());
  Future<void> form([Map<String,dynamic>? p])async{
    final t=TextEditingController(text:p?['title']??'');final c=TextEditingController(text:p?['category']??'');final diff=TextEditingController(text:p?['difficulty']??'Básico');final sc=TextEditingController(text:p?['scenario']??'');var pub=p?['published']??true;
    final ok=await showDialog<bool>(context:context,builder:(_)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(title:Text(p==null?'Nueva simulación':'Editar simulación'),content:SizedBox(width:600,child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:t,decoration:const InputDecoration(labelText:'Título')),const SizedBox(height:10),TextField(controller:c,decoration:const InputDecoration(labelText:'Categoría')),const SizedBox(height:10),TextField(controller:diff,decoration:const InputDecoration(labelText:'Dificultad')),const SizedBox(height:10),TextField(controller:sc,maxLines:5,decoration:const InputDecoration(labelText:'Escenario')),SwitchListTile(value:pub,onChanged:(v)=>setLocal(()=>pub=v),title:const Text('Publicada'))])),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Guardar'))])));
    if(ok==true){await AdminService.saveSimulation({'title':t.text,'category':c.text,'difficulty':diff.text,'scenario':sc.text,'published':pub},id:p==null?null:(p['id']as num).toInt());reload();}
  }

  Future<void> options(Map<String,dynamic> sim)async{
    final id=(sim['id']as num).toInt();
    await showDialog(context:context,builder:(context)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(
      title:Text('Opciones · ${sim['title']}'),
      content:SizedBox(width:720,height:500,child:FutureBuilder<List<Map<String,dynamic>>>(future:AdminService.simulationOptions(id),builder:(context,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());final rows=s.data!;return ListView(children:[
        FilledButton.icon(onPressed:()async{
          final text=TextEditingController();final feedback=TextEditingController();bool correct=false;final pos=TextEditingController(text:'${rows.length+1}');
          final ok=await showDialog<bool>(context:context,builder:(c)=>StatefulBuilder(builder:(c,setOpt)=>AlertDialog(title:const Text('Nueva opción'),content:SizedBox(width:520,child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:text,maxLines:2,decoration:const InputDecoration(labelText:'Respuesta')),const SizedBox(height:10),TextField(controller:feedback,maxLines:3,decoration:const InputDecoration(labelText:'Retroalimentación')),const SizedBox(height:10),TextField(controller:pos,decoration:const InputDecoration(labelText:'Orden')),SwitchListTile(value:correct,onChanged:(v)=>setOpt(()=>correct=v),title:const Text('Respuesta correcta'))])),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('Agregar'))])));
          if(ok==true){await AdminService.saveSimulationOption(id,text.text,correct,feedback.text,int.tryParse(pos.text)??rows.length+1);setLocal((){});}
        },icon:const Icon(Icons.add),label:const Text('Agregar opción')),
        const SizedBox(height:12),
        ...rows.map((r)=>Card(child:ListTile(leading:Icon(r['is_correct']==true?Icons.check_circle:Icons.radio_button_unchecked,color:r['is_correct']==true?Colors.green:null),title:Text(r['option_text']??'',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(r['feedback']??''),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:()async{await AdminService.deleteSimulationOption((r['id']as num).toInt());setLocal((){});})))),
      ]);})),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cerrar'))],
    )));
  }

  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(padding:const EdgeInsets.all(30),children:[
    Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Simulaciones',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Configura escenarios, respuestas y retroalimentación.') ])),FilledButton.icon(onPressed:()=>form(),icon:const Icon(Icons.add),label:const Text('Nueva'))]),const SizedBox(height:18),
    ...s.data!.map((p)=>Card(child:ListTile(title:Text(p['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${p['category']??''} · ${p['difficulty']??''}'),trailing:Wrap(spacing:4,children:[IconButton(tooltip:'Opciones',icon:const Icon(Icons.alt_route),onPressed:()=>options(p)),IconButton(tooltip:'Editar',icon:const Icon(Icons.edit),onPressed:()=>form(p))])))),
  ]);}));
}
