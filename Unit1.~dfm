object Form1: TForm1
  Left = 192
  Top = 111
  Width = 824
  Height = 593
  Caption = 'SODOKU'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 542
    Height = 542
    OnMouseDown = ImageMouseDown
  end
  object GroupBox1: TGroupBox
    Left = 568
    Top = 168
    Width = 233
    Height = 375
    Caption = 'BACKTRACK'
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 64
      Width = 47
      Height = 16
      Caption = 'Level :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 90
      Top = 63
      Width = 13
      Height = 20
      Caption = '--'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 24
      Top = 272
      Width = 69
      Height = 16
      Caption = 'Iteration ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 24
      Top = 304
      Width = 69
      Height = 16
      Caption = 'Solution ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object iteration: TLabel
      Left = 104
      Top = 272
      Width = 9
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object solution: TLabel
      Left = 104
      Top = 304
      Width = 9
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MiniMap: TImage
      Left = 136
      Top = 16
      Width = 75
      Height = 342
    end
    object InitButton: TButton
      Left = 24
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Init'
      TabOrder = 0
      OnClick = InitButtonClick
    end
    object StartButton: TButton
      Left = 24
      Top = 136
      Width = 75
      Height = 25
      Caption = 'Start'
      Enabled = False
      TabOrder = 1
      OnClick = StartButtonClick
    end
    object NextButton: TButton
      Left = 24
      Top = 176
      Width = 75
      Height = 25
      Caption = 'Next'
      Enabled = False
      TabOrder = 2
      OnClick = NextButtonClick
    end
    object StopButton: TButton
      Left = 24
      Top = 216
      Width = 75
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 3
      OnClick = StopButtonClick
    end
    object CheckBox1: TCheckBox
      Left = 32
      Top = 32
      Width = 73
      Height = 17
      Caption = 'animation'
      TabOrder = 4
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 257
    Height = 161
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
    Visible = False
  end
  object GroupBox2: TGroupBox
    Left = 568
    Top = 16
    Width = 233
    Height = 137
    Caption = 'SODOKU'
    TabOrder = 2
    object LoadButton: TButton
      Left = 32
      Top = 32
      Width = 150
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = LoadButtonClick
    end
    object SaveButton: TButton
      Left = 32
      Top = 64
      Width = 150
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = SaveButtonClick
    end
    object ExitButton: TButton
      Left = 32
      Top = 96
      Width = 150
      Height = 25
      Caption = 'Exit'
      TabOrder = 2
      OnClick = ExitButtonClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 280
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    Left = 280
    Top = 56
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 416
    Top = 40
  end
end
