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

procedure RegisterRoutes;
var
  Controller: TCEPController;
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

  // Registrar o controller
  THorseGBSwaggerRegister.RegisterPath(TCEPController);

end;


begin

  RegisterRoutes;
  THorse.Listen(9000);

end.
