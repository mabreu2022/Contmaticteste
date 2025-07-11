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

🧪 Testes implementados

- `Test_CepTemTodosDigitosIguais_Valido` — garante que CEPs como `00000000` e `99999999` sejam identificados como inválidos
- `Test_CepTemTodosDigitosIguais_Invalido` — confirma que CEPs como `12345678` passam normalmente
- `Test_Limpar_Objetos` — verifica que todos os campos do formulário são limpos corretamente
- `Test_ConsultarCEP_FallbackSimulado` — testa a lógica de fallback quando o CEP é inválido e não deve consultar outras APIs

### ▶️ Como executar os testes

1. Abra o projeto gerado pelo assistente DUnitX
2. Certifique-se de que `Unit1.pas` está incluída no projeto de testes
3. Compile e execute (`F9`)
4. Visualize os resultados no DUnitX Runner (interface gráfica ou console)



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


