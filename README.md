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

### ▶️ Padrões de Projeto Utilizados
1. MVC — Model-View-Controller
- Aplicação: Separação entre os dados (CEP, endereço), a interface do usuário (formulário Delphi) e a lógica que coordena tudo (Consultas via API).
- Benefício: Permite modificar o visual sem afetar a lógica, ou atualizar a lógica sem mexer na interface.
2. Strategy Pattern — Estratégia
- Aplicação: As diferentes APIs (ViaCEP, ApiCEP, AwesomeAPI) são chamadas de forma intercambiável.
- Benefício: Cada API pode ser vista como uma "estratégia" de consulta; se uma falha, a próxima entra em ação sem alterar o restante da estrutura.
3. Chain of Responsibility — Cadeia de Responsabilidade (implementação implícita)
- Aplicação: A função ConsultarCEP(...) testa as APIs em sequência: se uma não responde, passa para a próxima.
- Benefício: O fluxo de decisão é encadeado, favorecendo fallback automático e baixo acoplamento entre APIs.
4. Single Responsibility Principle (S do SOLID)
- Aplicação: Funções como CepTemTodosDigitosIguais e Limpar_Objetos têm responsabilidades únicas e bem definidas.
- Benefício: Facilita testes unitários, manutenção e reuso das funções.
5. Open/Closed Principle (O do SOLID)
- Aplicação: É possível adicionar uma nova API sem modificar as existentes — basta estender o código de consulta.
- Benefício: O sistema é aberto para extensão e fechado para modificação, reduzindo o risco de bugs em funcionalidades já estáveis.
6. Test Automation Pattern — usando DUnitX
- Aplicação: Criação de testes unitários para cada função lógica usando o framework DUnitX.
- Benefício: Verifica se partes críticas do sistema continuam funcionando após alterações.

🔁 Como alterar a ordem de consulta entre as APIs (ViaCEP, ApiCEP, AwesomeAPI)
A função ConsultarCEP(...) realiza consultas de CEP utilizando três APIs públicas em sequência. Por padrão, o projeto utiliza a seguinte ordem de prioridade:
- ViaCEP — consulta mais rápida e estável
- ApiCEP — como segunda alternativa
- AwesomeAPI — terceira tentativa, caso as anteriores falhem
Essa abordagem usa fallback automático: assim que uma API retorna dados válidos, o processo é encerrado e o resultado é entregue ao formulário.
🛠️ Para alterar a ordem de prioridade das APIs
Basta modificar a sequência do array URLs[...] dentro da função ConsultarCEP no arquivo CEPController.pas:

<pre lang="pascal">

URLs[0] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
URLs[1] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 3) + '.json';
URLs[2] := 'https://cep.awesomeapi.com.br/json/' + ACEP;
</pre>


Por exemplo, para testar a ApiCEP como principal, basta trocar para:

<pre lang="pascal">
  
URLs[0] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 3) + '.json';
URLs[1] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
URLs[2] := 'https://cep.awesomeapi.com.br/json/' + ACEP;

</pre>


Essa alteração é útil para:
- Fazer testes isolados com uma fonte específica
- Verificar o desempenho e tempo de resposta de cada API
- Validar formatos diferentes de retorno JSON

📌 Lembre-se de retornar à ordem original se quiser restaurar o comportamento de fallback padrão.


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


