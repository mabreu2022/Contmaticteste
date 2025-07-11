🗂️ Consulta de CEP em Delphi — Multi-API
Este projeto desenvolvido em Delphi realiza a busca de endereços a partir de um CEP informado pelo usuário, utilizando automaticamente 3 fontes diferentes de dados:
- 🔹 ViaCEP
- 🔹 ApiCEP
- 🔹 AwesomeAPI

🚀 Funcionalidades
- 🔄 Fallback automático entre APIs: se uma fonte falhar, a próxima é testada.
- 📦 Exibição completa do endereço no formulário Delphi:
- Logradouro
- Bairro
- Cidade
- Estado (UF)
- Complemento
- IBGE
- 🔐 Suporte a conexões seguras (TLS/SSL) com bibliotecas libssl-1_1.dll e libcrypto-1_1.dll
- 🔍 Identificação da fonte de dados usada com um label informativo.
- 🚫 Bloqueio de CEPs inválidos com todos os dígitos iguais (00000000, 11111111 etc):
- A consulta é automaticamente ignorada para ApiCEP e AwesomeAPI
- O usuário é avisado com uma mensagem explicativa
- 💨 Limpeza automática dos campos a cada nova consulta
- ✋ Validação de entrada para permitir apenas números no campo CEP

⚙️ Requisitos
- Delphi 10.x ou superior
- Bibliotecas SSL:
- libssl-1_1.dll
- libcrypto-1_1.dll
- Componentes:
- TIdHTTP
- TIdSSLIOHandlerSocketOpenSSL

📝 Estrutura do código
- ConsultarCEP(...): controla a lógica principal e fallback entre fontes
- TentarConsulta(...): realiza chamada HTTP e valida dados JSON retornados
- CarregarCEP*: popula os campos do formulário com os dados recebidos
- CepTemTodosDigitosIguais(...): bloqueia CEPs inválidos antes de chamar APIs sensíveis


