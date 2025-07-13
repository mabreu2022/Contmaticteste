unit CEPController;

interface

uses
  Horse,
  Horse.Request,
  Horse.Response,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.JSON.Serializers,
  REST.JSON,
  IdHTTP,
  IdSSL,
  IdSSLOpenSSL,
  EnderecoModel,
  Horse.GBSwagger.Controller,
  GBSwagger.Model.Attributes,
  GBSwagger.Path.Attributes;

type
  [SwagPath('cep', 'Consulta de CEP')]
  TCEPController = class(THorseGBSwagger)
  published
    [SwagGET('cep/{numero}', 'Consulta endereço pelo número do CEP')]
    [SwagParamPath('numero', 'Número do CEP (8 dígitos)', True)]
    [SwagResponse(200, TEndereco, 'Consulta realizada com sucesso')]
    [SwagResponse(404, 'CEP inválido ou não encontrado')]
    procedure ConsultarCEPHandler;


  public
    function CepTemTodosDigitosIguais(const CEP: string): Boolean;
    function ConsultarCEPInterno(const ACEP: string): TEndereco;
  end;

implementation


function TCEPController.CepTemTodosDigitosIguais(const CEP: string): Boolean;
begin
  Result := (Length(CEP) = 8) and (CEP = StringOfChar(CEP[1], 8));
end;

procedure TCEPController.ConsultarCEPHandler;
var
  ACEP: string;
  Endereco: TEndereco;
begin
  ACEP := FRequest.Params['numero'];

  if CepTemTodosDigitosIguais(ACEP) then
  begin
    FResponse.Status(404).Send('CEP inválido ou não encontrado');
    Exit;
  end;

  Endereco := ConsultarCEPInterno(ACEP);

  if Assigned(Endereco) then
    //Res.Status(200).Send(TJson.ObjectToJsonString(Endereco))
    FResponse.Status(200).Send<TEndereco>(Endereco)
  else
    FResponse.Status(404).Send('CEP inválido ou não encontrado');
end;

function TCEPController.ConsultarCEPInterno(const ACEP: string): TEndereco;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  URL: string;
  JSON: TJSONObject;
  Response: string;
  Fonte: string;
  i: Integer;
  URLs: array [0 .. 2] of string;
begin
  Result := nil;

  if CepTemTodosDigitosIguais(ACEP) then
    Exit;

  // Ordem de consulta: AwesomeAPI, ViaCEP, ApiCEP
  URLs[0] := 'https://cep.awesomeapi.com.br/json/' + ACEP;
  URLs[1] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
  URLs[2] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 3) + '.json';

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    SSL.SSLOptions.Method := sslvTLSv1_2;
    SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSL;

    HTTP.ReadTimeout := 5000;
    HTTP.ConnectTimeout := 3000;

    for i := 0 to High(URLs) do
    begin
      // Cabeçalhos simulando navegador real para ApiCEP
      if i = 2 then
      begin
        HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36';
        HTTP.Request.Accept := 'application/json';
        HTTP.Request.AcceptEncoding := 'gzip, deflate, br';
        HTTP.Request.AcceptLanguage := 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7';
        HTTP.Request.Connection := 'keep-alive';
      end
      else
      begin
        HTTP.Request.UserAgent := 'Delphi VCL Client';
        HTTP.Request.Accept := 'application/json';
        HTTP.Request.AcceptEncoding := '';
        HTTP.Request.AcceptLanguage := '';
        HTTP.Request.Connection := '';
      end;

      try
        Response := HTTP.Get(URLs[i]);
        JSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;

        if Assigned(JSON) and ((not JSON.TryGetValue('erro', Response)) or (JSON.ToString <> '')) then
        begin
          Result := TEndereco.Create;

          case i of
            0: Fonte := 'AwesomeAPI';
            1: Fonte := 'ViaCEP';
            2: Fonte := 'ApiCEP';
          end;
          Result.Fonte := Fonte;

          // Mapeamento flexível por origem
          Result.Logradouro := JSON.GetValue('logradouro', JSON.GetValue('address_type', ''));
          Result.Bairro     := JSON.GetValue('bairro', JSON.GetValue('district', ''));
          Result.Cidade     := JSON.GetValue('localidade', JSON.GetValue('city', ''));
          Result.UF         := JSON.GetValue('uf', JSON.GetValue('state', ''));
          Result.Complemento:= JSON.GetValue('complemento', JSON.GetValue('address', ''));
          Result.IBGE       := JSON.GetValue('ibge', '');

          JSON.Free;
          Break;
        end;
      except
        on E: Exception do
        begin
          // Ignorar falha e tentar próxima
        end;
      end;
    end;
  finally
    SSL.Free;
    HTTP.Free;
  end;
end;

end.
