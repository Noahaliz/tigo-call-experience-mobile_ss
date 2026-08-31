import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/admin_theme.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SupabaseConfig.url, publishableKey: SupabaseConfig.publishableKey);
  runApp(const TigoAdminApp());
}

class TigoAdminApp extends StatelessWidget {
  const TigoAdminApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Tigo Aprende Admin',
    theme: adminTheme(),
    home: Supabase.instance.client.auth.currentSession == null ? const AdminLoginScreen() : const AdminShell(),
  );
}
