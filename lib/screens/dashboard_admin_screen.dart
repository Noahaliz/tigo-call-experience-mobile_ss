import 'package:flutter/material.dart';
import '../core/admin_theme.dart';
import '../services/admin_service.dart';
import '../widgets/tigi_mascot.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: FutureBuilder(
    future: Future.wait([AdminService.dashboardCounts(), AdminService.criticalAreas()]),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final d = snapshot.data![0] as Map<String, num>;
      final critical = snapshot.data![1] as List<Map<String, dynamic>>;
      return ListView(padding: const EdgeInsets.all(30), children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dashboard', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
            SizedBox(height: 4),
            Text('Resumen general de aprendizaje, contenido y desempeño.', style: TextStyle(color: AdminColors.muted)),
          ])),
          const AdminTigiMascot(size: 86, mood: AdminTigiMood.happy),
        ]),
        const SizedBox(height: 20),
        Wrap(spacing: 16, runSpacing: 16, children: [
          _Metric('Cursos', '${d['courses']}', Icons.menu_book),
          _Metric('Lecciones', '${d['lessons']}', Icons.article),
          _Metric('Asesores', '${d['advisors']}', Icons.people),
          _Metric('Evaluaciones', '${d['evaluations']}', Icons.quiz),
          _Metric('Simulaciones', '${d['simulations']}', Icons.headset_mic),
          _Metric('Promedio', '${(d['average'] ?? 0).toStringAsFixed(1)}%', Icons.analytics_outlined),
        ]),
        const SizedBox(height: 28),
        const Text('Áreas que requieren atención', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        if (critical.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(20), child: Row(children:[AdminTigiMascot(size:72,mood:AdminTigiMood.celebrate),SizedBox(width:12),Expanded(child:Text('No hay áreas críticas con suficiente información todavía.'))]))),
        ...critical.take(6).map((r) => Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFFF4E5), child: Icon(Icons.warning_amber_rounded, color: Colors.orange)),
          title: Text(r['title']?.toString() ?? 'Área', style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${r['attempts'] ?? 0} intentos analizados'),
          trailing: Text('${((r['average_score'] ?? 0) as num).toDouble().toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w900)),
        ))),
      ]);
    },
  ));
}

class _Metric extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _Metric(this.label, this.value, this.icon);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 210,
    child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AdminColors.primary),
      const SizedBox(height: 14),
      Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(color: AdminColors.muted)),
    ]))),
  );
}
