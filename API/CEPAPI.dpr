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

// NOVO C�DIGO - Adicione isso no seu DPR
type
  [SwagPath('testeswagger', 'Testes de Rota B�sica')]
  TSimpleTestController = class
  public
    [SwagGET('/hello')]
    [SwagResponse(200, 'Mensagem de Ol�')]
    procedure HelloHandler(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  end;

procedure TSimpleTestController.HelloHandler(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Hello from SimpleTestController!');
end;
// FIM DO NOVO C�DIGO

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
    .Description('Documenta��o autom�tica gerada com GBSwagger')
    .Version('1.0.0')
    .Contact.Name('Mauricio Abreu')
    .Email('conectsolutions@hotmail.com')
    .URL('https://github.com/mabreu2022')
    .&End.&End;

    // For�a o Delphi a incluir TEndereco no execut�vel (previne o otimizador de remover)
  _ := TEndereco.ClassName;

  // Registrar o controller
  THorseGBSwaggerRegister.RegisterPath(TCEPController);

end;


begin

  RegisterRoutes;
  THorse.Listen(9000);

end.
