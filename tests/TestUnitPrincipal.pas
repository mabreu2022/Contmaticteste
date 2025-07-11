unit TestUnitPrincipal;

interface

uses
  DUnitX.TestFramework, Unit1, System.SysUtils;

type
  [TestFixture]
  TTestCepUtils = class
  public
    [Setup]
    procedure SetUp;

    [Test]
    procedure Test_CepTemTodosDigitosIguais_Valido;

    [Test]
    procedure Test_CepTemTodosDigitosIguais_Invalido;

    [Test]
    procedure Test_Limpar_Objetos;

    [Test]
    procedure Test_ConsultarCEP_FallbackSimulado;
  end;

implementation

procedure TTestCepUtils.SetUp;
begin
  if not Assigned(FrmPrincipal) then
    FrmPrincipal := TFrmPrincipal.Create(nil);
end;

// ?? Testa CEP com dígitos iguais
procedure TTestCepUtils.Test_CepTemTodosDigitosIguais_Valido;
begin
  Assert.IsTrue(FrmPrincipal.CepTemTodosDigitosIguais('00000000'));
  Assert.IsTrue(FrmPrincipal.CepTemTodosDigitosIguais('99999999'));
end;

// ?? Testa CEP normal
procedure TTestCepUtils.Test_CepTemTodosDigitosIguais_Invalido;
begin
  Assert.IsFalse(FrmPrincipal.CepTemTodosDigitosIguais('12345678'));
  Assert.IsFalse(FrmPrincipal.CepTemTodosDigitosIguais('85236941'));
end;

// ?? Verifica limpeza de campos
procedure TTestCepUtils.Test_Limpar_Objetos;
begin
  // Preenche campos com valores simulados
  FrmPrincipal.edtEndereco.Text := 'Rua Teste';
  FrmPrincipal.edtBairro.Text := 'Centro';
  FrmPrincipal.EdtCidade.Text := 'São Paulo';
  FrmPrincipal.edtUF.Text := 'SP';
  FrmPrincipal.EdtIBGE.Text := '123456';
  FrmPrincipal.memoComplemento.Lines.Text := 'Próximo ao mercado';

  // Executa limpeza
  FrmPrincipal.Limpar_Objetos(False);

  // Verifica se foram esvaziados
  Assert.AreEqual('', FrmPrincipal.edtEndereco.Text);
  Assert.AreEqual('', FrmPrincipal.edtBairro.Text);
  Assert.AreEqual('', FrmPrincipal.EdtCidade.Text);
  Assert.AreEqual('', FrmPrincipal.edtUF.Text);
  Assert.AreEqual('', FrmPrincipal.EdtIBGE.Text);
  Assert.AreEqual('', FrmPrincipal.memoComplemento.Lines.Text);
end;

// ?? Simulação de fallback
procedure TTestCepUtils.Test_ConsultarCEP_FallbackSimulado;
var
  Resultado: TResultadoCEP;
begin
  // Simula um CEP inválido com todos os dígitos iguais
  Resultado := FrmPrincipal.ConsultarCEP('00000000');

  // Espera que nenhuma API tenha respondido
  Assert.AreEqual(fcIndefinida, Resultado.Fonte);
  Assert.IsFalse(Assigned(Resultado.JSON));
end;

end.
