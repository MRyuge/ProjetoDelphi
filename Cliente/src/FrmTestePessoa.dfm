object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'TesteDelphi '
  ClientHeight = 369
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 106
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 121
    Top = 0
    Width = 528
    Height = 350
    ActivePage = TabSheetEnderecoListar
    Align = alClient
    TabOrder = 0
    object TabSheetNovoPessoa: TTabSheet
      Caption = 'Pessoa'
      object Label1: TLabel
        Left = 271
        Top = 67
        Width = 52
        Height = 14
        Caption = 'Natureza:'
      end
      object Label2: TLabel
        Left = 127
        Top = 67
        Width = 68
        Height = 14
        Caption = 'Documento:'
      end
      object Label3: TLabel
        Left = 127
        Top = 115
        Width = 83
        Height = 14
        Caption = 'Primeiro Nome:'
      end
      object Label4: TLabel
        Left = 127
        Top = 163
        Width = 89
        Height = 14
        Caption = 'Segundo Nome:'
      end
      object Label5: TLabel
        Left = 127
        Top = 211
        Width = 77
        Height = 14
        Caption = 'Data Registro:'
      end
      object lblIdCLiente: TLabel
        Left = 127
        Top = 19
        Width = 57
        Height = 14
        Caption = 'ID Pessoa:'
      end
      object dtDataRegistro: TDateTimePicker
        Left = 127
        Top = 231
        Width = 118
        Height = 22
        Date = 45681.000000000000000000
        Time = 0.742718553243321400
        TabOrder = 5
      end
      object edtDocumento: TEdit
        Left = 127
        Top = 87
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 1
      end
      object edtNatureza: TEdit
        Left = 271
        Top = 87
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 2
      end
      object edtPrimeiroNome: TEdit
        Left = 127
        Top = 135
        Width = 265
        Height = 22
        TabOrder = 3
      end
      object edtSegundoNome: TEdit
        Left = 127
        Top = 183
        Width = 265
        Height = 22
        TabOrder = 4
      end
      object Panel2: TPanel
        Left = 0
        Top = 280
        Width = 520
        Height = 41
        Align = alBottom
        TabOrder = 6
        object BtnPessoaGrava: TButton
          AlignWithMargins = True
          Left = 110
          Top = 4
          Width = 100
          Height = 33
          Align = alLeft
          Caption = 'Gravar'
          TabOrder = 0
          OnClick = BtnPessoaGravaClick
        end
        object btnPessoaCancel: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 100
          Height = 33
          Align = alLeft
          Caption = 'Cancelar'
          TabOrder = 1
          OnClick = btnPessoaCancelClick
        end
      end
      object edtIdPessoa: TEdit
        Left = 127
        Top = 39
        Width = 121
        Height = 22
        NumbersOnly = True
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabSheetEnderecoNovo: TTabSheet
      Caption = 'Endere'#231'o'
      ImageIndex = 3
      object Label11: TLabel
        Left = 3
        Top = 11
        Width = 57
        Height = 14
        Caption = 'ID Pessoa:'
      end
      object Label12: TLabel
        Left = 3
        Top = 59
        Width = 25
        Height = 14
        Caption = 'CEP:'
      end
      object lbNome: TLabel
        Left = 130
        Top = 34
        Width = 41
        Height = 14
        Caption = 'lbNome'
        Visible = False
      end
      object edtEnderecoIdPessoa: TEdit
        Left = 3
        Top = 31
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 0
        OnExit = edtEnderecoIdPessoaExit
      end
      object edtEndecoCep: TEdit
        Left = 3
        Top = 79
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 1
        OnExit = edtEndecoCepExit
      end
      object Panel3: TPanel
        Left = 0
        Top = 280
        Width = 520
        Height = 41
        Align = alBottom
        TabOrder = 2
        object btnEnderecoGravar: TButton
          AlignWithMargins = True
          Left = 110
          Top = 4
          Width = 100
          Height = 33
          Align = alLeft
          Caption = 'Gravar'
          TabOrder = 0
          OnClick = btnEnderecoGravarClick
        end
        object btnEnderecoCancel: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 100
          Height = 33
          Align = alLeft
          Caption = 'Cancelar'
          TabOrder = 1
          OnClick = btnEnderecoCancelClick
        end
      end
      object memoResult: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 107
        Width = 514
        Height = 170
        Align = alBottom
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 3
      end
    end
    object TabSheetLote: TTabSheet
      Caption = 'Inclus'#227'o em Lote'
      ImageIndex = 5
      object Button1: TButton
        Left = 3
        Top = 16
        Width = 169
        Height = 25
        Caption = 'Abrir Arquivo JSON'
        TabOrder = 0
        OnClick = Button1Click
      end
      object memoResultJson: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 47
        Width = 514
        Height = 271
        Align = alBottom
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheetPessoaListar: TTabSheet
      Caption = 'Lista de Pessoas'
      ImageIndex = 6
      object ListViewPessoas: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 514
        Height = 279
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'ID'
          end
          item
            AutoSize = True
            Caption = 'Nome Completo'
          end
          item
            AutoSize = True
            Caption = 'Documento'
          end
          item
            AutoSize = True
            Caption = 'Data de Registro'
          end>
        DoubleBuffered = True
        FlatScrollBars = True
        GridLines = True
        RowSelect = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = ListViewPessoasDblClick
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 288
        Width = 514
        Height = 30
        Align = alBottom
        TabOrder = 1
        object btnPessoaEditar: TButton
          AlignWithMargins = True
          Left = 85
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Editar'
          TabOrder = 0
          OnClick = btnPessoaEditarClick
        end
        object btnPessoaNovo: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Novo'
          TabOrder = 1
          OnClick = btnPessoaNovoClick
        end
        object btnPessoaDelete: TButton
          AlignWithMargins = True
          Left = 166
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnPessoaDeleteClick
        end
      end
    end
    object TabSheetEnderecoListar: TTabSheet
      Caption = 'Lista Endere'#231'os'
      ImageIndex = 7
      object ListViewEnderecos: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 190
        Height = 279
        Align = alLeft
        Columns = <
          item
            AutoSize = True
            Caption = 'ID PESSOA'
          end
          item
            AutoSize = True
            Caption = 'CEP'
          end>
        DoubleBuffered = True
        FlatScrollBars = True
        GridLines = True
        RowSelect = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewEnderecosClick
        OnDblClick = ListViewEnderecosDblClick
      end
      object memoEnderecoIntegrado: TMemo
        AlignWithMargins = True
        Left = 199
        Top = 3
        Width = 318
        Height = 279
        Align = alClient
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 288
        Width = 514
        Height = 30
        Align = alBottom
        TabOrder = 2
        object Button7: TButton
          AlignWithMargins = True
          Left = 85
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Editar'
          TabOrder = 0
          OnClick = Button7Click
        end
        object Button8: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Novo'
          TabOrder = 1
          OnClick = Button8Click
        end
        object Button9: TButton
          AlignWithMargins = True
          Left = 247
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Atualizar'
          TabOrder = 2
          OnClick = Button9Click
        end
        object Button12: TButton
          AlignWithMargins = True
          Left = 166
          Top = 4
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Excluir'
          TabOrder = 3
          OnClick = Button12Click
        end
      end
    end
    object TabSheetCEP: TTabSheet
      Caption = 'Consultar CEP'
      ImageIndex = 6
      object Label6: TLabel
        Left = 3
        Top = 12
        Width = 25
        Height = 14
        Caption = 'CEP:'
      end
      object edtCEP: TEdit
        Left = 3
        Top = 32
        Width = 102
        Height = 22
        NumbersOnly = True
        TabOrder = 0
        OnExit = edtCEPExit
      end
      object MemoResulrCEP: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 60
        Width = 514
        Height = 258
        Align = alBottom
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Lista Endere'#231'o'
      ImageIndex = 7
      TabVisible = False
    end
    object TabSheet2: TTabSheet
      Caption = 'Logs'
      ImageIndex = 1
      object MemoResultado: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 514
        Height = 315
        Align = alClient
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 350
    Align = alLeft
    AutoExpand = True
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnChange = TreeView1Change
    Items.NodeData = {
      03020000002A0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0001000000010650006500730073006F006100280000000000000000000000FF
      FFFFFFFFFFFFFF00000000000000000000000001054C006F007400650073002E
      0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000100000001
      0845006E006400650072006500E7006F00240000000000000000000000FFFFFF
      FFFFFFFFFF0000000000000000000000000103430045005000}
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 350
    Width = 649
    Height = 19
    Panels = <
      item
        Text = 'Vers'#227'o:'
        Width = 50
      end
      item
        Text = '1.0'
        Width = 50
      end
      item
        Width = 50
      end>
  end
end
