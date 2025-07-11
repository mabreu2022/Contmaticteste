unit CEPController;

interface

{$RTTI EXPLICIT METHODS([vcPublic]) PROPERTIES([vcPublic])}

uses
  Horse,
  EnderecoModel,
  GBSwagger.Model.Attributes; //Atributos para documentação Swagger

type
  [SwagPath('cep', 'Consulta CEP')] //Tag e agrupamento de rota na interface Swagger
  TCEPController = class
  public
    function CepTemTodosDigitosIguais(const CEP: string): Boolean;

    [SwagGET('/cep/{numero}', 'Consulta um CEP específico')]
    [SwagParamPath('numero', 'string', true, 'Número do CEP (somente dígitos)')]
    [SwagResponse(200, 'Endereço encontrado com sucesso', TEndereco)]
    [SwagResponse(404, 'CEP inválido ou não encontrado')]
    function ConsultarCEP(const ACEP: string): TEndereco;
  end;

implementation

uses
  IdHTTP,
  IdSSL,
  IdSSLOpenSSL,
  SysUtils,
  System.JSON;

function TCEPController.CepTemTodosDigitosIguais(const CEP: string): Boolean;
begin
  Result := (Length(CEP) = 8) and (CEP = StringOfChar(CEP[1], 8));
end;

function TCEPController.ConsultarCEP(const ACEP: string): TEndereco;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JSON: TJSONObject;
  Response: string;
  Fonte: string;
  i: Integer;
  URLs: array[0..2] of string;
begin
  Result := nil;

  if CepTemTodosDigitosIguais(ACEP) then
    Exit;

  //URLs das APIs de consulta
  URLs[0] := 'https://viacep.com.br/ws/' + ACEP + '/json/';
  URLs[1] := 'https://cdn.apicep.com/file/apicep/' +
             Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 3) + '.json';
  URLs[2] := 'https://cep.awesomeapi.com.br/json/' + ACEP;

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
      try
        Response := HTTP.Get(URLs[i]);

        Writeln('Tentando: ' + URLs[i]);
        Writeln('Resposta recebida: ' + Response);

        JSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;

        if Assigned(JSON) then
          Writeln('JSON: ' + JSON.ToString);

        if Assigned(JSON) and
           ((not JSON.TryGetValue('erro', Response)) or (JSON.ToString <> '')) then
        begin
          Result := TEndereco.Create;

          case i of
            0: Fonte := 'ViaCEP';
            1: Fonte := 'ApiCEP';
            2: Fonte := 'AwesomeAPI';
          end;

          Result.Fonte       := Fonte;
          Result.Logradouro  := JSON.GetValue('logradouro', JSON.GetValue('address_type', ''));
          Result.Bairro      := JSON.GetValue('bairro', JSON.GetValue('district', ''));
          Result.Cidade      := JSON.GetValue('localidade', JSON.GetValue('city', ''));
          Result.UF          := JSON.GetValue('uf', JSON.GetValue('state', ''));
          Result.Complemento := JSON.GetValue('complemento', JSON.GetValue('address', ''));
          Result.IBGE        := JSON.GetValue('ibge', '');
          Result.Cep         := JSON.GetValue('cep', '');
          Result.Ddd         := JSON.GetValue('ddd', '');
          Result.Estado      := JSON.GetValue('estado', '');
          Result.Gia         := JSON.GetValue('gia', '');
          Result.Siafi       := JSON.GetValue('siafi', '');

          JSON.Free;
          Break;
        end;
      except
        on E: Exception do
          Writeln('Erro ao consultar ' + URLs[i] + ': ' + E.Message);
      end;
    end;
  finally
    SSL.Free;
    HTTP.Free;
  end;
end;

end.
