object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Image Squash'
  ClientHeight = 254
  ClientWidth = 728
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BtnStart: TButton
    Left = 0
    Top = 212
    Width = 728
    Height = 25
    Align = alBottom
    Caption = 'Lancer le traitement'
    TabOrder = 0
    OnClick = BtnStartClick
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 237
    Width = 728
    Height = 17
    Align = alBottom
    DoubleBuffered = False
    ParentDoubleBuffered = False
    Style = pbstMarquee
    State = pbsPaused
    TabOrder = 1
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 404
    Height = 206
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 404
      Height = 13
      Align = alTop
      Caption = 'Document Squash '#224' traiter'
      ExplicitWidth = 128
    end
    object LbATraiter: TListBox
      Left = 0
      Top = 13
      Width = 404
      Height = 193
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 413
    Top = 3
    Width = 312
    Height = 206
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 3
    object Label2: TLabel
      Left = 11
      Top = 69
      Width = 291
      Height = 13
      Caption = 'Ouvrir le document enregistr'#233', ou le glisser sur cette fen'#234'tre'
    end
    object Label3: TLabel
      Left = 64
      Top = 13
      Width = 184
      Height = 13
      Caption = 'Ouvrir le document Squash dans Word'
    end
    object Label4: TLabel
      Left = 89
      Top = 32
      Width = 134
      Height = 13
      Caption = 'Fichier / Enregistrer sous ...'
    end
    object Label5: TLabel
      Left = 44
      Top = 50
      Width = 224
      Height = 13
      Caption = 'S'#233'lectionner Type : Page Web (*.htm, *.html) '
    end
    object BtnOuvrir: TButton
      Left = 124
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Ouvrir ...'
      Default = True
      TabOrder = 0
      OnClick = BtnOuvrirClick
    end
  end
  object FileDialog: TOpenTextFileDialog
    DefaultExt = '*.htm'
    Filter = 'rapport Squash enregistr'#233' en Page Web (*.htm)|*.htm'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 561
    Top = 152
  end
end
