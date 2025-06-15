import 'package:flutter/material.dart';

class TermosPoliticasPage extends StatelessWidget {
  const TermosPoliticasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57), // Verde similar ao da imagem
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E8B57),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            const Text(
              'Termos e Política',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Introdução
            const Text(
              'Seja bem-vindo ao CuidarPet!\nAo utilizar nosso aplicativo, você concorda com os seguintes Termos de Uso:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            // Seção 1
            _buildSection(
              '1. Uso do Aplicativo',
              'Você deve utilizar o CuidarPet apenas para fins legais e de acordo com estes Termos.\nO aplicativo é uma ferramenta de apoio e não substitui o acompanhamento veterinário profissional.',
            ),

            // Seção 2
            _buildSection(
              '2. Cadastro e Informações',
              'Caso o aplicativo solicite dados pessoais ou dos seus pets, você se compromete a fornecer informações verdadeiras e atualizadas.',
            ),

            // Seção 3
            _buildSection(
              '3. Propriedade Intelectual',
              'Todo o conteúdo do CuidarPet — textos, imagens, logos, ícones e funcionalidades — é protegido por direitos autorais.\nNenhum pode ser copiado, distribuído ou utilizado sem autorização.',
            ),

            // Seção 4
            _buildSection(
              '4. Modificações no Aplicativo',
              'Reservamos o direito de alterar, suspender ou descontinuar qualquer funcionalidade do CuidarPet a qualquer momento, sem aviso prévio.',
            ),

            // Seção 5
            _buildSection(
              '5. Limitação de Responsabilidade',
              'O CuidarPet não se responsabiliza por qualquer dano decorrente do uso incorreto do aplicativo ou pela ausência de cuidados médicos veterinários.',
            ),

            // Seção 6
            _buildSection(
              '6. Atualizações dos Termos',
              'Podemos atualizar estes Termos de Uso periodicamente. Notificaremos você sobre mudanças relevantes.',
            ),

            // Contato
            const Text(
              'Se tiver dúvidas, entre em contato conosco pelo e-mail: scheilasilvaalbino@rede.ulbra.br',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Política de Privacidade
            const Text(
              'Política de Privacidade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              'Sua privacidade é muito importante para nós. Leia atentamente como tratamos suas informações:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Seções da Política de Privacidade
            _buildSection(
              '1. Informações que Coletamos',
              'Dados fornecidos por você: nome, e-mail, informações sobre seus pets (nome, idade, espécie).\nInformações de uso: como você interage com o aplicativo.',
            ),

            _buildSection(
              '2. Como Usamos Suas Informações',
              'Para melhorar a experiência no app;\n\nPara enviar lembretes e notificações relacionadas ao cuidado dos pets;\n\nPara comunicações sobre atualizações e novidades.',
            ),

            _buildSection(
              '3. Compartilhamento de Informações',
              'Nós não vendemos nem compartilhamos seus dados pessoais com terceiros.',
            ),

            _buildSection(
              '4. Armazenamento e Segurança',
              'Adotamos medidas técnicas e administrativas para proteger suas informações contra acesso não autorizado.',
            ),

            _buildSection(
              '5. Direitos do Usuário',
              'Você pode solicitar:\n\nAcesso aos seus dados;\n\nCorreção de dados incorretos;\n\nExclusão dos seus dados pessoais.',
            ),

            const Text(
              'Basta nos contatar em:\nscheilasilvaalbino@rede.ulbra.br',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            _buildSection(
              '6. Atualizações desta Política',
              'Podemos alterar esta Política de Privacidade. Você será informado caso mudanças significativas sejam feitas.',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}