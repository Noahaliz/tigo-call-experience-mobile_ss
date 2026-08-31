import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class QuestionsAdminScreen extends StatefulWidget {
  const QuestionsAdminScreen({super.key});
  @override State<QuestionsAdminScreen> createState() => _QuestionsAdminScreenState();
}

class _QuestionsAdminScreenState extends State<QuestionsAdminScreen> {
  late Future<List<Map<String,dynamic>>> future;
  @override void initState(){ super.initState(); future = AdminService.questions(); }
  void reload()=>setState(()=>future=AdminService.questions());

  Future<void> form([Map<String,dynamic>? item]) async {
    final lessons = await AdminService.lessons();
    if (!mounted || lessons.isEmpty) return;
    int lessonId = item == null ? (lessons.first['id'] as num).toInt() : (item['lesson_id'] as num).toInt();
    final q = TextEditingController(text:item?['question_text']?.toString() ?? '');
    final opts = List.generate(4, (_) => TextEditingController());
    int correct = 0;
    if (item != null) {
      final old = await AdminService.questionOptions((item['id'] as num).toInt());
      for (var i=0; i<old.length && i<4; i++) {
        opts[i].text = old[i]['option_text']?.toString() ?? '';
        if (old[i]['is_correct'] == true) correct = i;
      }
    }
    if (!mounted) return;
    final ok = await showDialog<bool>(context:context,builder:(_)=>StatefulBuilder(builder:(context,setLocal)=>AlertDialog(
      title:Text(item==null?'Nueva pregunta':'Editar pregunta'),
      content:SizedBox(width:650,child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        DropdownButtonFormField<int>(initialValue:lessonId,items:lessons.map((l)=>DropdownMenuItem(value:(l['id'] as num).toInt(),child:Text('${l['courses']?['title'] ?? ''} · ${l['title'] ?? ''}'))).toList(),onChanged:(v){if(v!=null)setLocal(()=>lessonId=v);},decoration:const InputDecoration(labelText:'Lección')),
        const SizedBox(height:12),
        TextField(controller:q,maxLines:3,decoration:const InputDecoration(labelText:'Pregunta')),
        const SizedBox(height:12),
        ...List.generate(4,(i)=>Padding(padding:const EdgeInsets.only(bottom:10),child:Row(children:[
          Radio<int>(value:i,groupValue:correct,onChanged:(v){if(v!=null)setLocal(()=>correct=v);}),
          Expanded(child:TextField(controller:opts[i],decoration:InputDecoration(labelText:'Opción ${String.fromCharCode(65+i)}'))),
        ]))),
        const Align(alignment:Alignment.centerLeft,child:Text('Selecciona con el círculo la respuesta correcta.')),
      ]))),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancelar')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Guardar'))],
    )));
    if(ok==true){
      await AdminService.saveQuestion(
        id:item==null?null:(item['id'] as num).toInt(),
        lessonId:lessonId,
        questionText:q.text.trim(),
        options:List.generate(4,(i)=>{'text':opts[i].text.trim(),'correct':i==correct}),
      );
      reload();
    }
  }

  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    return ListView(padding:const EdgeInsets.all(30),children:[
      Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Banco de preguntas',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Administra preguntas únicas por lección.') ])),FilledButton.icon(onPressed:()=>form(),icon:const Icon(Icons.add),label:const Text('Nueva pregunta'))]),
      const SizedBox(height:18),
      ...s.data!.map((q)=>Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.quiz_outlined)),
        title:Text(q['question_text']?.toString()??'',style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${q['lessons']?['courses']?['title'] ?? ''} · ${q['lessons']?['title'] ?? ''}'),
        trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>form(q)),
      ))),
    ]);
  }));
}
