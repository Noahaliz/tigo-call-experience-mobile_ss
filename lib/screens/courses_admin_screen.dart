import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class CoursesAdminScreen extends StatefulWidget {
  const CoursesAdminScreen({super.key});
  @override State<CoursesAdminScreen> createState() => _CoursesAdminScreenState();
}
class _CoursesAdminScreenState extends State<CoursesAdminScreen> {
  late Future<List<Map<String, dynamic>>> future;
  @override void initState(){ super.initState(); future = AdminService.courses(); }
  void reload() => setState(() => future = AdminService.courses());

  Future<void> form([Map<String,dynamic>? item]) async {
    final title = TextEditingController(text: item?['title'] ?? '');
    final desc = TextEditingController(text: item?['description'] ?? '');
    final cat = TextEditingController(text: item?['category'] ?? '');
    final image = TextEditingController(text: item?['image_url'] ?? '');
    final pos = TextEditingController(text: '${item?['position'] ?? 0}');
    var published = item?['published'] ?? true;
    final ok = await showDialog<bool>(context: context, builder: (_) => StatefulBuilder(builder: (context, setLocal) => AlertDialog(
      title: Text(item == null ? 'Nuevo curso' : 'Editar curso'),
      content: SizedBox(width: 520, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, decoration: const InputDecoration(labelText: 'Título')), const SizedBox(height: 10),
        TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Descripción')), const SizedBox(height: 10),
        TextField(controller: cat, decoration: const InputDecoration(labelText: 'Categoría')), const SizedBox(height: 10),
        TextField(controller: image, decoration: const InputDecoration(labelText: 'URL de imagen / portada')), const SizedBox(height: 10),
        TextField(controller: pos, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Orden')),
        SwitchListTile(value: published, onChanged: (v) => setLocal(() => published = v), title: const Text('Publicado')),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar'))],
    )));
    if (ok == true) {
      await AdminService.saveCourse({'title':title.text.trim(),'description':desc.text.trim(),'category':cat.text.trim(),'image_url':image.text.trim(),'position':int.tryParse(pos.text)??0,'published':published}, id: item == null ? null : (item['id'] as num).toInt());
      reload();
    }
  }

  @override Widget build(BuildContext context) => SafeArea(child: FutureBuilder<List<Map<String,dynamic>>>(future: future, builder: (context,snapshot){
    if(!snapshot.hasData) return const Center(child:CircularProgressIndicator());
    return ListView(padding: const EdgeInsets.all(30), children:[
      Row(children:[const Expanded(child: Text('Cursos', style: TextStyle(fontSize:30,fontWeight:FontWeight.w900))), FilledButton.icon(onPressed:()=>form(), icon:const Icon(Icons.add), label:const Text('Nuevo curso'))]),
      const SizedBox(height:18),
      ...snapshot.data!.map((c)=>Card(child:ListTile(title:Text(c['title']??'',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${c['category']??'General'} · ${c['published']==true?'Publicado':'Oculto'}'),trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>form(c))))),
    ]);
  }));
}
