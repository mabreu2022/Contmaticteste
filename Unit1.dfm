object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Consultar CEP'
  ClientHeight = 252
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  TextHeight = 15
  object lblEndereco: TLabel
    Left = 8
    Top = 107
    Width = 49
    Height = 15
    Caption = 'Endere'#231'o'
  end
  object lblBairro: TLabel
    Left = 8
    Top = 136
    Width = 31
    Height = 15
    Caption = 'Bairro'
  end
  object lblCidade: TLabel
    Left = 8
    Top = 165
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object lblUF: TLabel
    Left = 8
    Top = 194
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object lblIBGE: TLabel
    Left = 8
    Top = 223
    Width = 24
    Height = 15
    Caption = 'IBGE'
  end
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 88
    Height = 15
    Caption = 'Entre com o CEP'
  end
  object lblComplemento: TLabel
    Left = 319
    Top = 107
    Width = 77
    Height = 15
    Caption = 'Complemento'
  end
  object lblFonte: TLabel
    Left = 408
    Top = 224
    Width = 115
    Height = 15
    Caption = 'Qual API RESPONDEU'
  end
  object edtCEP: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object btnConsultaCEP: TButton
    Left = 134
    Top = 37
    Width = 91
    Height = 25
    Caption = 'Consulta CEP'
    TabOrder = 1
    OnClick = btnConsultaCEPClick
  end
  object edtEndereco: TEdit
    Left = 104
    Top = 104
    Width = 209
    Height = 23
    TabOrder = 2
  end
  object edtBairro: TEdit
    Left = 104
    Top = 133
    Width = 209
    Height = 23
    TabOrder = 3
  end
  object EdtCidade: TEdit
    Left = 104
    Top = 162
    Width = 209
    Height = 23
    TabOrder = 4
  end
  object edtUF: TEdit
    Left = 104
    Top = 191
    Width = 49
    Height = 23
    TabOrder = 5
  end
  object EdtIBGE: TEdit
    Left = 104
    Top = 220
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object memoComplemento: TMemo
    Left = 402
    Top = 104
    Width = 185
    Height = 89
    Lines.Strings = (
      '')
    TabOrder = 7
  end
end
