program CEPAPI;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.GBSwagger,
  GBSwagger.Model.Config,
  Horse.GBSwagger.Register,
  GBSwagger.Model.Path,
  GBSwagger.Model.Info,
  CEPController in 'Controller\CEPController.pas',
  EnderecoModel in 'Model\EnderecoModel.pas';

// NOVO CÓDIGO - Adicione isso no seu DPR
type
  [SwagPath('testeswagger', 'Testes de Rota Básica')]
  TSimpleTestController = class
  public
    [SwagGET('/hello')]
    [SwagResponse(200, 'Mensagem de Olá')]
    procedure HelloHandler(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  end;

procedure TSimpleTestController.HelloHandler(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Hello from SimpleTestController!');
end;
// FIM DO NOVO CÓDIGO

procedure RegisterRoutes;
var
  Controller: TCEPController;
  _ : string;
begin
  THorse.Use(CORS)
        .Use(Jhonson)
        .Use(HorseSwagger('/swagger/doc/html', '/swagger/doc/json'));

  Swagger.Info
    .Title('API de Consulta de CEP')
    .Description('Documentação automática gerada com GBSwagger')
    .Version('1.0.0')
    .Contact.Name('Mauricio Abreu')
    .Email('conectsolutions@hotmail.com')
    .URL('https://github.com/mabreu2022')
    .&End.&End;

    // Força o Delphi a incluir TEndereco no executável (previne o otimizador de remover)
  _ := TEndereco.ClassName;

  // Registrar o controller
  THorseGBSwaggerRegister.RegisterPath(TCEPController);

end;


begin

  RegisterRoutes;
  THorse.Listen(9000);

end.
