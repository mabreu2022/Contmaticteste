unit CEPController;

interface

uses
  EnderecoModel;

type
  TCEPController = class
  public
    function CepTemTodosDigitosIguais(const CEP: string): Boolean;
    function ConsultarCEP(const ACEP: string): TEndereco;
  end;

implementation

uses
  IdHTTP, IdSSL, IdSSLOpenSSL, SysUtils, System.JSON;

function TCEPController.CepTemTodosDigitosIguais(const CEP: string): Boolean;
begin
  Result := (Length(CEP) = 8) and (CEP = StringOfChar(CEP[1], 8));
end;

function TCEPController.ConsultarCEP(const ACEP: string): TEndereco;
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

  // URLs das APIs
  // URLs[0] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
  // URLs[1] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 3) + '.json';
  // URLs[2] := 'https://cep.awesomeapi.com.br/json/' + ACEP;

  // Teste  primeira api APICEP
  // URLs[0] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' +
  // Copy(ACEP, 6, 3) + '.json';
  // URLs[1] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
  // URLs[2] := 'https://cep.awesomeapi.com.br/json/' + ACEP;

  // testeAwesome sendo a primeira
  URLs[0] := 'https://cep.awesomeapi.com.br/json/' + ACEP; // AwesomeAPI
  URLs[1] := 'https://viacep.com.br/ws/' + ACEP + '/json/'; // ViaCEP
  URLs[2] := 'https://cdn.apicep.com/file/apicep/' + Copy(ACEP, 1, 5) + '-' +
    Copy(ACEP, 6, 3) + '.json'; // ApiCEP

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSL.SSLOptions.Method := sslvTLSv1_2;
    SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
    SSL.SSLOptions.VerifyMode := []; // retirar depois
    SSL.SSLOptions.VerifyDepth := 0;
    SSL.SSLOptions.Mode := sslmUnassigned;
    HTTP.IOHandler := SSL;

    HTTP.ReadTimeout := 5000;
    HTTP.ConnectTimeout := 3000;

    for i := 0 to High(URLs) do
    begin
      try
        Response := HTTP.Get(URLs[i]);
        JSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;

        if Assigned(JSON) and ((not JSON.TryGetValue('erro', Response)) or
          (JSON.ToString <> '')) then
        begin
          Result := TEndereco.Create;
          case i of
            0:
              Fonte := 'AwesomeAPI';
            1:
              Fonte := 'ViaCEP';
            2:
              Fonte := 'ApiCEP';
          end;

          Result.Fonte := Fonte;

          // Mapeamento flexível dependendo da origem
          Result.Logradouro := JSON.GetValue('logradouro',
            JSON.GetValue('address_type', ''));
          Result.Bairro := JSON.GetValue('bairro',
            JSON.GetValue('district', ''));
          Result.Cidade := JSON.GetValue('localidade',
            JSON.GetValue('city', ''));
          Result.UF := JSON.GetValue('uf', JSON.GetValue('state', ''));
          Result.Complemento := JSON.GetValue('complemento',
            JSON.GetValue('address', ''));
          Result.IBGE := JSON.GetValue('ibge', '');

          JSON.Free;
          Break;
        end;
      except
        on E: Exception do
        begin
          // Ignora falha e tenta próxima
        end;
      end;
    end;
  finally
    SSL.Free;
    HTTP.Free;
  end;
end;

end.
