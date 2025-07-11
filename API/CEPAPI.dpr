program CEPAPI;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.GBSwagger,
  GBSwagger.Model.Config,
  Horse.GBSwagger.Register,
  CEPController in 'Controller\CEPController.pas',
  EnderecoModel in 'Model\EnderecoModel.pas';

procedure RegisterRoutes;
var
  Controller: TCEPController;
begin
  // Middleware
  THorse
    .Use(HorseSwagger('/swagger/doc/html', '/swagger/doc/json'))
    .Use(CORS)
    .Use(Jhonson);

  // Swagger Info
  Swagger
    .Info
      .Title('API de Consulta de CEP')
      .Description('Documentação automática gerada com GBSwagger')
      .Version('1.0.0')
      .Contact
        .Name('Mauricio Abreu')
        .Email('conectsolutions@hotmail.com')
        .URL('https://github.com/mabreu2022')
      .&End
    .&End;

  // Registra Controller no Swagger
  THorseGBSwaggerRegister.RegisterPath(TCEPController);

  // Instancia a controller
  Controller := TCEPController.Create;

  //Aqui está a linha que FALTAVA:
//  THorse.Get('/cep/:numero', Controller.ConsultarCEP);
end;


begin
  RegisterRoutes;
  THorse.Listen(9000);
end.

