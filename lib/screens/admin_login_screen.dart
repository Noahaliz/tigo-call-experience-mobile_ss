import 'package:flutter/material.dart';
import '../core/admin_theme.dart';
import '../services/admin_service.dart';
import '../widgets/tigi_mascot.dart';
import 'admin_shell.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> submit() async {
    setState(() { loading = true; error = null; });
    try {
      final ok = await AdminService.login(email.text.trim(), password.text);
      if (!mounted) return;
      if (!ok) { setState(() => error = 'Este usuario no tiene permisos administrativos.'); return; }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminShell()));
    } catch (_) {
      setState(() => error = 'No pudimos iniciar sesión. Revisa tus credenciales.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Center(child: AdminTigiMascot(size: 110)),
                const SizedBox(height: 12),
                const Text('Tigo Aprende Admin', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AdminColors.navy)),
                const SizedBox(height: 6),
                const Text('Gestiona contenidos, resultados y seguimiento desde un solo lugar.', textAlign: TextAlign.center, style: TextStyle(color: AdminColors.muted)),
                const SizedBox(height: 24),
                TextField(controller: email, decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.mail_outline))),
                const SizedBox(height: 12),
                TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline))),
                if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 18),
                FilledButton(onPressed: loading ? null : submit, child: Text(loading ? 'Ingresando...' : 'Ingresar al panel')),
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}
