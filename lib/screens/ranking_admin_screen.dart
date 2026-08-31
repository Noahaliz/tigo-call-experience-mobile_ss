import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../widgets/tigi_mascot.dart';

class RankingAdminScreen extends StatelessWidget{
  const RankingAdminScreen({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(
    future:AdminService.ranking(),
    builder:(context,s){
      if(!s.hasData)return const Center(child:CircularProgressIndicator());
      final rows=s.data!;
      return ListView(padding:const EdgeInsets.all(30),children:[
        const Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Ranking de asesores',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Puntaje ponderado por evaluaciones, simulaciones y actividad.') ])),AdminTigiMascot(size:80,mood:AdminTigiMood.celebrate)]),
        const SizedBox(height:18),
        ...List.generate(rows.length,(i){
          final r=rows[i];
          final score=((r['ranking_score']??r['average_score']??0)as num).toDouble();
          return Card(child:ListTile(
            leading:CircleAvatar(child:Text('${i+1}')),
            title:Text(r['full_name']??'Asesor',style:const TextStyle(fontWeight:FontWeight.w800)),
            subtitle:Text('${r['completed_lessons']??0} evaluaciones · promedio ${((r['average_score']??0)as num).toDouble().toStringAsFixed(1)}%'),
            trailing:Text('${score.toStringAsFixed(1)} pts',style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900)),
          ));
        }),
      ]);
    },
  ));
}
