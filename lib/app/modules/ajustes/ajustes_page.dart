import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/services/auth_service.dart';
import 'package:cuidar_pet_app/app/shared/url/url_launcher.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_exit/bottom_sheet_exit.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_info/bottom_sheet_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oktoast/oktoast.dart';

import '../../shared/widget/bottom_sheet_notificacoes/bottom_sheet_notificacoes.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  @override
  Widget build(BuildContext context) {
    final Uri emailUrl = Uri.parse(
        'mailto:scheilasilvaalbino@rede.ulbra.br?subject=Contato%20-%20CuidarPet&body=Olá,%0A%0AEstou%20entrando%20em%20contato%20através%20do%20aplicativo%20CuidarPet.%0A%0AMensagem:%0A'
    );
    final Uri termosUrl = Uri.parse('https://www.freeprivacypolicy.com/live/96dbc229-e4e2-4e11-8e06-1db6fd312671');

    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        elevation: 0,
        title: const Text(
          'Ajustes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00845A),
              size: 24,
            ),
            onPressed: () {
              Modular.to.navigate('/$homeRoute');
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/img/logo_branco.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildMenuOption(
                    icon: Icons.notifications,
                    label: 'Notificações',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const BottomSheetNotificacoes(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    icon: Icons.email,
                    label: 'Fale conosco',
                    onTap: () {
                      UrlHelper.abrir(emailUrl);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    icon: Icons.help,
                    label: 'Sobre nós',
                    onTap: () {
                      BottomSheetInfo.show(
                        context: context,
                        titulo: 'Sobre nós',
                        mensagem:
                        'Seu Assistente para o Bem Estar dos Pets!\n\nO CuidarPet é o aplicativo ideal para ajudar você a cuidar do seu pet de forma prática e organizada. Seja um cachorro, gato, cavalo, vaca ou porco, aqui você pode registrar e acompanhar vacinas, medicações, alimentação e outros cuidados essenciais. Configure alertas personalizados para não esquecerde nenhum compromisso importante e garanta a saúde e o bem-estar do seu animal com facilidade.\n\n Simples, intuitivo e completo, o CuidarPet foi feito para quem ama e se preocupa com seus pets!',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    icon: Icons.description,
                    label: 'Termos e políticas',
                    onTap: () {
                      UrlHelper.abrir(termosUrl);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    icon: Icons.exit_to_app,
                    label: 'Sair do aplicativo',
                    onTap: () async {
                      final bool confirmar = await BottomSheetExit.show(
                        context: context,
                        mensagem: 'Você realmente deseja sair?',
                        textoConfirmar: 'SAIR',
                      );
                      if (confirmar) {
                        try {
                          final AuthService authService =
                          Modular.get<AuthService>();

                          await authService.signOut();

                          Modular.to.navigate('/');
                        } catch (e) {
                          showToast('Erro ao fazer logout: $e',
                              position: ToastPosition.bottom);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF00845A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
