program ClientVCL;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {FrmPrincipal},
  EnderecoModel in 'Model\EnderecoModel.pas',
  CEPController in 'Controller\CEPController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
