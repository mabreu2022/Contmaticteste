unit TestCEPController;

interface

uses
  DUnitX.TestFramework, CEPController, EnderecoModel;

type
  [TestFixture]
  TTestCepController = class
  public
    [Test]
    procedure Test_CepTemTodosDigitosIguais_Valido;

    [Test]
    procedure Test_CepTemTodosDigitosIguais_Invalido;

    [Test]
    procedure Test_ConsultarCEP_Fallback;

    [Test]
    procedure Test_ConsultarCEP_Valido;
  end;

implementation

procedure TTestCepController.Test_CepTemTodosDigitosIguais_Valido;
var
  Controller: TCEPController;
begin
  Controller := TCEPController.Create;
  try
    Assert.IsTrue(Controller.CepTemTodosDigitosIguais('00000000'));
    Assert.IsTrue(Controller.CepTemTodosDigitosIguais('99999999'));
  finally
    Controller.Free;
  end;
end;

procedure TTestCepController.Test_CepTemTodosDigitosIguais_Invalido;
var
  Controller: TCEPController;
begin
  Controller := TCEPController.Create;
  try
    Assert.IsFalse(Controller.CepTemTodosDigitosIguais('12345678'));
    Assert.IsFalse(Controller.CepTemTodosDigitosIguais('85236941'));
  finally
    Controller.Free;
  end;
end;

procedure TTestCepController.Test_ConsultarCEP_Fallback;
var
  Controller: TCEPController;
  Endereco: TEndereco;
begin
  Controller := TCEPController.Create;
  try
    Endereco := Controller.ConsultarCEP('00000000'); // dígitos iguais ? deve cair no fallback
    Assert.IsNull(Endereco);
  finally
    Controller.Free;
  end;
end;

procedure TTestCepController.Test_ConsultarCEP_Valido;
var
  Controller: TCEPController;
  Endereco: TEndereco;
begin
  Controller := TCEPController.Create;
  try
    Endereco := Controller.ConsultarCEP('01001000'); // CEP real de SP
    try
      Assert.IsNotNull(Endereco);
      Assert.AreEqual('SP', Endereco.UF);
      Assert.IsTrue(Endereco.Fonte <> '');
    finally
      Endereco.Free;
    end;
  finally
    Controller.Free;
  end;
end;

end.
