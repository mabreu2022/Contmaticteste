unit EnderecoModel;

interface

uses
  GBSwagger.Model.Attributes;

type
  [SwagObject('Modelo de Endereço retornado pela API')]
  TEndereco = class
  private
    FLogradouro: string;
    FBairro: string;
    FCidade: string;
    FUF: string;
    FComplemento: string;
    FIBGE: string;
    FFonte: string;
  published
    [SwagProp('Logradouro', 'string')]
    property Logradouro: string read FLogradouro write FLogradouro;

    [SwagProp('Bairro', 'string')]
    property Bairro: string read FBairro write FBairro;

    [SwagProp('Cidade', 'string')]
    property Cidade: string read FCidade write FCidade;

    [SwagProp('UF (Unidade Federativa)', 'string')]
    property UF: string read FUF write FUF;

    [SwagProp('Complemento', 'string')]
    property Complemento: string read FComplemento write FComplemento;

    [SwagProp('Código IBGE do município', 'string')]
    property IBGE: string read FIBGE write FIBGE;

    [SwagProp('Fonte da consulta do CEP', 'string')]
    property Fonte: string read FFonte write FFonte;
  end;

implementation

end.

