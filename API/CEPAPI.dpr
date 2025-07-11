program CEPAPI;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.CORS,
  System.SysUtils,
  Horse.Jhonson,
  Horse.GBSwagger,
  GBSwagger.Model.Config,
  Horse.GBSwagger.Register,
  System.JSON,
  REST.JSON,
  CEPController in 'Controller\CEPController.pas',
  EnderecoModel in 'Model\EnderecoModel.pas';

procedure RegisterRoutes;
begin
  THorse.Use(HorseSwagger('/swagger/doc/html', // interface Swagger UI
    '/swagger/doc/json' // JSON da documentação
    )).Use(CORS).Use(Jhonson);

  // ?? Configuração da documentação
  Swagger.Info.Title('API de Consulta de CEP')
    .Description('Documentação automática gerada com GBSwagger')
    .Version('1.0.0').Contact.Name('Mauricio Dev').Email('mauricio@email.com')
    .URL('https://github.com/seu-usuario').&End.&End;

  // ?? Registro da controller para gerar a doc
  THorseGBSwaggerRegister.RegisterPath(TCEPController);

  // ?? Endpoint real da API
  THorse.Get('/cep/:numero',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      CEP: string;
      Controller: TCEPController;
      Endereco: TEndereco;
    begin
      CEP := Req.Params['numero'];
      Controller := TCEPController.Create;
      try
        Endereco := Controller.ConsultarCEP(CEP);
        if Assigned(Endereco) then
          Res.Status(200).Send(TJson.ObjectToJsonString(Endereco))
        else
          Res.Status(404).Send('CEP inválido ou não encontrado');
      finally
        Controller.Free;
      end;
    end);

  // ?? Interface Swagger UI customizada (opcional)
  THorse.Get('/docs',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.SendFile('docs/index.html');
    end);
end;

begin
  THorse.Use(Jhonson); // ativa o envio automático de JSON
  RegisterRoutes;
  THorse.Listen(9000);

end.
