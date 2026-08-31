import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../core/admin_theme.dart';
import '../services/admin_service.dart';

class ReportsAdminScreen extends StatefulWidget {
  const ReportsAdminScreen({super.key});
  @override State<ReportsAdminScreen> createState()=>_ReportsAdminScreenState();
}

class _ReportsAdminScreenState extends State<ReportsAdminScreen>{
  late Future<List<Map<String,dynamic>>> future;
  @override void initState(){super.initState();future=AdminService.reportRows();}

  void exportCsv(List<Map<String,dynamic>> rows){
    final b=StringBuffer('Asesor,Area,Promedio,Evaluaciones,Simulaciones,Ultima actividad\n');
    String esc(Object? v)=>'"${(v??'').toString().replaceAll('"','""')}"';
    for(final r in rows){b.writeln([esc(r['full_name']),esc(r['area']),esc(r['average_score']),esc(r['evaluations']),esc(r['simulations']),esc(r['last_activity'])].join(','));}
    final bytes=utf8.encode('\uFEFF${b.toString()}');
    final blob=html.Blob([bytes],'text/csv;charset=utf-8');
    final url=html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href:url)..setAttribute('download','reporte_tigo_aprende.csv')..click();
    html.Url.revokeObjectUrl(url);
  }

  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){
    if(!s.hasData)return const Center(child:CircularProgressIndicator()); final rows=s.data!;
    return ListView(padding:const EdgeInsets.all(30),children:[
      Row(children:[
        const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Reportes',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),Text('Seguimiento resumido por asesor.',style:TextStyle(color:AdminColors.muted))])),
        OutlinedButton.icon(onPressed:()=>html.window.print(),icon:const Icon(Icons.picture_as_pdf_outlined),label:const Text('Imprimir / PDF')),
        const SizedBox(width:10),
        FilledButton.icon(onPressed:()=>exportCsv(rows),icon:const Icon(Icons.table_view_outlined),label:const Text('Exportar Excel/CSV')),
      ]),
      const SizedBox(height:18),
      SingleChildScrollView(scrollDirection:Axis.horizontal,child:DataTable(columns:const [
        DataColumn(label:Text('Asesor')),DataColumn(label:Text('Área')),DataColumn(label:Text('Promedio')),DataColumn(label:Text('Evaluaciones')),DataColumn(label:Text('Simulaciones')),DataColumn(label:Text('Última actividad')),
      ],rows:rows.map((r)=>DataRow(cells:[
        DataCell(Text(r['full_name']?.toString()??'')),DataCell(Text(r['area']?.toString()??'Sin área')),DataCell(Text('${((r['average_score']??0)as num).toDouble().toStringAsFixed(1)}%')),DataCell(Text('${r['evaluations']??0}')),DataCell(Text('${r['simulations']??0}')),DataCell(Text(r['last_activity']?.toString()??'-')),
      ])).toList())),
    ]);
  }));
}
