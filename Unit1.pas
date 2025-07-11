unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CEPController, EnderecoModel;

type
  TFrmPrincipal = class(TForm)
    edtCEP: TEdit;
    edtEndereco: TEdit;
    edtBairro: TEdit;
    EdtCidade: TEdit;
    edtUF: TEdit;
    EdtIBGE: TEdit;
    memoComplemento: TMemo;
    lblFonte: TLabel;
    btnBuscarClick: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClickClick(Sender: TObject);

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnBuscarClickClick(Sender: TObject);
var
  Controller: TCEPController;
  Endereco: TEndereco;
begin
  Controller := TCEPController.Create;
  try
    Endereco := Controller.ConsultarCEP(edtCEP.Text);
    if Assigned(Endereco) then
    begin
      edtEndereco.Text     := Endereco.Logradouro;
      edtBairro.Text       := Endereco.Bairro;
      EdtCidade.Text       := Endereco.Cidade;
      edtUF.Text           := Endereco.UF;
      EdtIBGE.Text         := Endereco.IBGE;
      memoComplemento.Text := Endereco.Complemento;
      lblFonte.Caption     := 'Fonte: ' + Endereco.Fonte;
    end
    else
      ShowMessage('CEP inválido ou não encontrado.');
  finally
    Endereco.Free;
    Controller.Free;
  end;


end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  // Configurações iniciais, se necessário
end;

end.
