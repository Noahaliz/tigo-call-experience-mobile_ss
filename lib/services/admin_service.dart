import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static SupabaseClient get db => Supabase.instance.client;

  static Future<Map<String, dynamic>?> currentProfile() async {
    final user = db.auth.currentUser;
    if (user == null) return null;
    return db.from('profiles').select().eq('id', user.id).maybeSingle();
  }

  static Future<bool> login(String email, String password) async {
    await db.auth.signInWithPassword(email: email, password: password);
    final profile = await currentProfile();
    final role = profile?['role'];
    final allowed = role == 'admin' || role == 'capacitador' || role == 'team_leader';
    if (!allowed) await db.auth.signOut();
    return allowed;
  }

  static Future<void> logout() => db.auth.signOut();

  static Future<List<Map<String, dynamic>>> courses() async => List<Map<String, dynamic>>.from(await db.from('courses').select().order('position'));
  static Future<void> saveCourse(Map<String, dynamic> data, {int? id}) async {
    if (id == null) { await db.from('courses').insert(data); } else { await db.from('courses').update(data).eq('id', id); }
  }

  static Future<List<Map<String, dynamic>>> lessons([int? courseId]) async {
    var q = db.from('lessons').select('*, courses(title)');
    if (courseId != null) q = q.eq('course_id', courseId);
    return List<Map<String, dynamic>>.from(await q.order('position'));
  }
  static Future<void> saveLesson(Map<String, dynamic> data, {int? id}) async {
    if (id == null) { await db.from('lessons').insert(data); } else { await db.from('lessons').update(data).eq('id', id); }
  }

  static Future<List<Map<String, dynamic>>> procedures() async => List<Map<String, dynamic>>.from(await db.from('procedures').select().order('title'));
  static Future<void> saveProcedure(Map<String, dynamic> data, {int? id}) async {
    if (id == null) { await db.from('procedures').insert(data); } else { await db.from('procedures').update(data).eq('id', id); }
  }

  static Future<List<Map<String, dynamic>>> procedureSteps(int procedureId) async => List<Map<String, dynamic>>.from(await db.from('procedure_steps').select().eq('procedure_id', procedureId).order('position'));
  static Future<void> saveProcedureStep(int procedureId, String title, String description, int position) => db.from('procedure_steps').insert({'procedure_id':procedureId,'title':title,'description':description,'position':position});
  static Future<void> deleteProcedureStep(int id) => db.from('procedure_steps').delete().eq('id', id);

  static Future<List<Map<String, dynamic>>> simulations() async => List<Map<String, dynamic>>.from(await db.from('simulations').select().order('created_at', ascending: false));
  static Future<void> saveSimulation(Map<String, dynamic> data, {int? id}) async {
    if (id == null) { await db.from('simulations').insert(data); } else { await db.from('simulations').update(data).eq('id', id); }
  }

  static Future<List<Map<String, dynamic>>> simulationOptions(int simulationId) async => List<Map<String, dynamic>>.from(await db.from('simulation_options').select().eq('simulation_id', simulationId).order('position'));
  static Future<void> saveSimulationOption(int simulationId, String text, bool correct, String feedback, int position) => db.from('simulation_options').insert({'simulation_id':simulationId,'option_text':text,'is_correct':correct,'feedback':feedback,'position':position});
  static Future<void> deleteSimulationOption(int id) => db.from('simulation_options').delete().eq('id', id);

  static Future<List<Map<String, dynamic>>> advisors() async => List<Map<String, dynamic>>.from(await db.from('profiles').select().order('full_name'));
  static Future<void> updateProfileRole(String id, String role) => db.from('profiles').update({'role': role}).eq('id', id);
  static Future<void> setProfileActive(String id, bool active) => db.from('profiles').update({'active': active}).eq('id', id);

  static Future<List<Map<String, dynamic>>> ranking() async => List<Map<String, dynamic>>.from((await db.rpc('get_public_ranking')) as List);

  static Future<List<Map<String, dynamic>>> questions() async => List<Map<String, dynamic>>.from(
    await db.from('lesson_questions').select('*, lessons(title, courses(title))').order('id', ascending: false),
  );

  static Future<void> saveQuestion({int? id, required int lessonId, required String questionText, required List<Map<String, dynamic>> options}) async {
    int questionId;
    if (id == null) {
      final row = await db.from('lesson_questions').insert({'lesson_id': lessonId, 'question_text': questionText, 'position': 0}).select('id').single();
      questionId = (row['id'] as num).toInt();
    } else {
      questionId = id;
      await db.from('lesson_questions').update({'lesson_id': lessonId, 'question_text': questionText}).eq('id', id);
      await db.from('question_options').delete().eq('question_id', id);
    }
    await db.from('question_options').insert([
      for (var i = 0; i < options.length; i++) {
        'question_id': questionId,
        'option_text': options[i]['text'],
        'is_correct': options[i]['correct'] == true,
        'position': i,
      }
    ]);
  }

  static Future<List<Map<String, dynamic>>> questionOptions(int questionId) async => List<Map<String, dynamic>>.from(
    await db.from('question_options').select().eq('question_id', questionId).order('position'),
  );

  static Future<List<Map<String, dynamic>>> assignments() async => List<Map<String, dynamic>>.from(await db.from('training_assignments').select('*, courses(title), profiles!training_assignments_user_id_fkey(full_name,email)').order('created_at', ascending:false));
  static Future<void> saveAssignment(int courseId, String userId, DateTime? dueAt) async => db.from('training_assignments').insert({'course_id':courseId,'user_id':userId,'due_at':dueAt?.toIso8601String(),'assigned_by':db.auth.currentUser?.id});

  static Future<List<Map<String, dynamic>>> notifications() async => List<Map<String, dynamic>>.from(await db.from('notifications').select().order('created_at', ascending: false));
  static Future<void> saveNotification(Map<String, dynamic> data) async => db.from('notifications').insert(data);

  static Future<List<Map<String, dynamic>>> feedback() async => List<Map<String, dynamic>>.from(await db.from('content_feedback').select('*, profiles(full_name)').order('updated_at', ascending: false).limit(100));
  static Future<List<Map<String, dynamic>>> audit() async => List<Map<String, dynamic>>.from(await db.from('audit_logs').select('*, profiles(full_name)').order('created_at', ascending: false).limit(200));
  static Future<List<Map<String, dynamic>>> criticalAreas() async => List<Map<String, dynamic>>.from((await db.rpc('get_critical_learning_areas')) as List);
  static Future<List<Map<String, dynamic>>> reportRows() async => List<Map<String, dynamic>>.from((await db.rpc('get_advisor_report')) as List);

  static Future<Map<String, num>> dashboardCounts() async {
    final c = await courses();
    final l = await lessons();
    final allProfiles = await advisors();
    final advisorsOnly = allProfiles.where((p) => p['role'] == 'asesor').toList();
    final r = List<Map<String, dynamic>>.from(await db.from('lesson_results').select());
    final sims = List<Map<String, dynamic>>.from(await db.from('simulation_results').select());
    final avg = r.isEmpty ? 0.0 : r.map((e) => (e['score'] as num).toDouble()).reduce((a,b)=>a+b)/r.length;
    return {
      'courses': c.length,
      'lessons': l.length,
      'advisors': advisorsOnly.length,
      'evaluations': r.length,
      'simulations': sims.length,
      'average': avg,
    };
  }
}
