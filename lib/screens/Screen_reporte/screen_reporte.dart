import 'dart:async'; // Necesario para el Timer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/ad_state_provider.dart';
import 'package:recetas_app/helpers/ad_helper.dart';
import 'widgets/widgets.dart';

class ScreenReporte extends StatefulWidget {
  const ScreenReporte({super.key});

  @override
  State<ScreenReporte> createState() => _ScreenReporteState();
}

class _ScreenReporteState extends State<ScreenReporte> {
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();
    // Iniciamos un timer de 30 segundos
    _adTimer = Timer(const Duration(seconds: 30), () {
      _triggerAd();
    });
  }

  void _triggerAd() {
    if (!mounted) return;

    final adProvider = context.read<AdStateProvider>();
    // Registramos la interacción por tiempo de permanencia
    if (adProvider.recordInteraction()) {
      AdHelper.showInterstitialAd();
    }
  }

  @override
  void dispose() {
    // IMPORTANTE: Cancelamos el timer si el usuario sale de la pantalla
    // antes de que se cumplan los 30 segundos.
    _adTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial', 
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ReporteDataView(),
      ),
    );
  }
}