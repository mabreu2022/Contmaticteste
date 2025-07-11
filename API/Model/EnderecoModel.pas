unit EnderecoModel;

interface

//{$RTTI EXPLICIT METHODS([vcPublic]) PROPERTIES([vcPublished])}
//{$RTTI EXPLICIT METHODS([vcPublic]) PROPERTIES([vcPublished])}
{$RTTI EXPLICIT METHODS([vcPublished]) PROPERTIES([vcPublished])}


type
  TEndereco = class
  private
    FLogradouro: string;
    FBairro: string;
    FCidade: string;
    FUF: string;
    FComplemento: string;
    FIBGE: string;
    FFonte: string;
    FCep: string;
    FDdd: string;
    FEstado: string;
    FGia: string;
    FSiafi: string;
  published
    property Logradouro: string read FLogradouro write FLogradouro;
    property Bairro: string read FBairro write FBairro;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
    property Complemento: string read FComplemento write FComplemento;
    property IBGE: string read FIBGE write FIBGE;
    property Fonte: string read FFonte write FFonte;
    property Cep: string read FCep write FCep;
    property Ddd: string read FDdd write FDdd;
    property Estado: string read FEstado write FEstado;
    property Gia: string read FGia write FGia;
    property Siafi: string read FSiafi write FSiafi;
  end;

implementation

end.

