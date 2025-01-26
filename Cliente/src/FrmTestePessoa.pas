unit FrmTestePessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, PessoaService, EnderecoService, System.JSON,
  System.Net.HttpClient, System.Net.URLClient, IdHTTP, System.IniFiles,
  Vcl.ComCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, System.DateUtils;

type
  TForm2 = class(TForm)
    MemoResultado: TMemo;
    PageControl1: TPageControl;
    TabSheetNovoPessoa: TTabSheet;
    TabSheet2: TTabSheet;
    edtDocumento: TEdit;
    edtNatureza: TEdit;
    edtPrimeiroNome: TEdit;
    edtSegundoNome: TEdit;
    dtDataRegistro: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TabSheetEnderecoNovo: TTabSheet;
    Label11: TLabel;
    edtEnderecoIdPessoa: TEdit;
    Label12: TLabel;
    edtEndecoCep: TEdit;
    TreeView1: TTreeView;
    Panel2: TPanel;
    BtnPessoaGrava: TButton;
    TabSheetLote: TTabSheet;
    Button1: TButton;
    TabSheetPessoaListar: TTabSheet;
    TabSheetEnderecoListar: TTabSheet;
    ListViewPessoas: TListView;
    Panel4: TPanel;
    btnPessoaEditar: TButton;
    btnPessoaNovo: TButton;
    btnPessoaDelete: TButton;
    StatusBar1: TStatusBar;
    lblIdCLiente: TLabel;
    edtIdPessoa: TEdit;
    TabSheetCEP: TTabSheet;
    edtCEP: TEdit;
    Label6: TLabel;
    MemoResulrCEP: TMemo;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    btnEnderecoGravar: TButton;
    lbNome: TLabel;
    btnEnderecoCancel: TButton;
    btnPessoaCancel: TButton;
    ListViewEnderecos: TListView;
    memoEnderecoIntegrado: TMemo;
    Panel1: TPanel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button12: TButton;
    memoResult: TMemo;
    memoResultJson: TMemo;
    procedure BtnPessoaGravaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnListarPessoaClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure ListViewPessoasDblClick(Sender: TObject);
    procedure btnPessoaNovoClick(Sender: TObject);
    procedure btnPessoaDeleteClick(Sender: TObject);
    procedure btnPessoaEditarClick(Sender: TObject);
    procedure edtEnderecoIdPessoaExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtCEPExit(Sender: TObject);
    procedure btnPessoaCancelClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure edtEndecoCepExit(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ListViewEnderecosDblClick(Sender: TObject);
    procedure btnEnderecoGravarClick(Sender: TObject);
    procedure btnEnderecoCancelClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListViewEnderecosClick(Sender: TObject);
  private
    FStatus: string;
    FBaseUrl: string;
    FPessoaService: TPessoaService;
    FEnderecoService: TEnderecoService;
    FIdEndereco: string;

    // Pesssoa
    procedure LogMensagem(Memo: TMemo; const Msg: string);
    procedure ListarPessoas;
    function BuscarPessoa(id: Int64): TJSONObject;
    procedure GravaPessoa;
    procedure ExcluirPessoa(id: Int64);
    procedure EditPessoa;
    procedure TabSheetHide;
    procedure ClearFieldsPessoa;
    procedure RefreshListaPessoa;
    procedure AtualizarPessoasEmLote;

    // Endereço
    procedure ListaEndereco;
    function BuscarEndereco(id: Int64): TJSONObject;
    procedure GravarEndereco;
    procedure ExcluirEndereco(IdEndereco: Int64);
    procedure EditEndereco;
    procedure RefreshListaEndereco;
    procedure ClearFieldsEndereco;
    procedure VisualizarEnderecoIntegracao;
  public
    { Public declarations }
  protected

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.ListaEndereco;
var
  EnderecosJSON: TJSONArray;
  EnderecoJSON: TJSONObject;

  function DesserializarJSONArray(ResultArray: TJSONArray): TJSONArray;
  var
    JSONString: string;
  begin
    Result := nil;

    // Verifica se o array tem pelo menos um item e o primeiro item é uma string
    if (ResultArray.Count > 0) and (ResultArray.Items[0] is TJSONString) then
    begin
      // Obtém a string JSON do primeiro item
      JSONString := TJSONString(ResultArray.Items[0]).Value;

      // Desserializa a string JSON para TJSONArray
      Result := TJSONObject.ParseJSONValue(JSONString) as TJSONArray;
      if not Assigned(Result) then
        raise Exception.Create
          ('Erro ao desserializar a string JSON para TJSONArray.');
    end
    else
      raise Exception.Create('TJSONArray não contém strings JSON válidas.');
  end;

  procedure PreencherListView(JSONArray: TJSONArray);
  var
    I: Integer;
    ListItem: TListItem;
  begin
    // Limpa o ListView antes de preencher
    ListViewEnderecos.Items.Clear;

    // Itera sobre o JSONArray e preenche o ListView
    for I := 0 to JSONArray.Count - 1 do
    begin
      if JSONArray.Items[I] is TJSONObject then
      begin
        EnderecoJSON := TJSONObject(JSONArray.Items[I]);

        // Adiciona os dados ao ListView
        ListItem := ListViewEnderecos.Items.Add;
        ListItem.Caption := EnderecoJSON.GetValue<Int64>('IdEndereco').ToString;
        // ID
        ListItem.SubItems.Add(EnderecoJSON.GetValue<string>('DsCep')); // CEP
      end;
    end;
  end;

begin
  try
    // Obtém o JSON como TJSONArray e desserializa o conteúdo
    EnderecosJSON := TEnderecoService.Create.ListarEnderecos;
    EnderecosJSON := DesserializarJSONArray(EnderecosJSON);

    // Verifica se o JSONArray foi processado corretamente
    if not Assigned(EnderecosJSON) then
      raise Exception.Create('Erro ao desserializar o JSONArray.');

    // Preenche o ListView com os dados do JSONArray
    PreencherListView(EnderecosJSON);

    MemoResultado.Lines.Add('Endereços listadas com sucesso.')

    // ShowMessage('Endereços listados com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao listar endereços: ' + E.Message);
  end;
end;

procedure TForm2.ListarPessoas;
var
  PessoasJSON: TJSONArray;
  PessoaJSON: TJSONObject;
  ListItem: TListItem;
  // I: Integer;

  function DesserializarJSONArray(ResultArray: TJSONArray): TJSONArray;
  var
    JSONString: string;
  begin
    Result := nil;

    // Verifica se o array tem pelo menos um item e o primeiro item é uma string
    if (ResultArray.Count > 0) and (ResultArray.Items[0] is TJSONString) then
    begin
      // Obtém a string JSON do primeiro item
      JSONString := TJSONString(ResultArray.Items[0]).Value;

      // Desserializa a string JSON para TJSONArray
      Result := TJSONObject.ParseJSONValue(JSONString) as TJSONArray;
      if not Assigned(Result) then
        raise Exception.Create
          ('Erro ao desserializar a string JSON para TJSONArray.');
    end
    else
      raise Exception.Create('TJSONArray não contém strings JSON válidas.');
  end;

  procedure PreencherListView(JSONArray: TJSONArray);
  var
    I: Integer;
  begin
    // Limpa o ListView antes de preencher
    ListViewPessoas.Items.Clear;

    // Itera sobre o JSONArray e preenche o ListView
    for I := 0 to JSONArray.Count - 1 do
    begin
      if JSONArray.Items[I] is TJSONObject then
      begin
        PessoaJSON := TJSONObject(JSONArray.Items[I]);

        // Adiciona os dados ao ListView
        ListItem := ListViewPessoas.Items.Add;
        ListItem.Caption := PessoaJSON.GetValue<Int64>('IdPessoa').ToString;
        // ID
        ListItem.SubItems.Add(PessoaJSON.GetValue<string>('NmPrimeiro') + ' ' +
          PessoaJSON.GetValue<string>('NmSegundo')); // Nome completo
        ListItem.SubItems.Add(PessoaJSON.GetValue<string>('DsDocumento'));
        // Documento
        ListItem.SubItems.Add(PessoaJSON.GetValue<string>('DtRegistro'));
        // Data de Registro
      end;
    end;
  end;

begin
  try
    MemoResultado.Clear;
    // Obtém o JSON como TJSONArray e desserializa o conteúdo
    PessoasJSON := FPessoaService.ListarPessoas(MemoResultado);
    PessoasJSON := DesserializarJSONArray(PessoasJSON);

    // Verifica se o JSONArray foi processado corretamente
    if not Assigned(PessoasJSON) then
      raise Exception.Create('Erro ao desserializar o JSONArray.');

    // Preenche o ListView com os dados do JSONArray
    PreencherListView(PessoasJSON);

    MemoResultado.Lines.Add('Pessoas listadas com sucesso.');
  except
    on E: Exception do
    begin
      MemoResultado.Lines.Add('Erro ao listar pessoas: ' + E.Message);
    end;
  end;

end;

procedure TForm2.ListViewEnderecosClick(Sender: TObject);
begin
  VisualizarEnderecoIntegracao;
end;

procedure TForm2.ListViewEnderecosDblClick(Sender: TObject);
begin
  EditEndereco;
end;

procedure TForm2.ListViewPessoasDblClick(Sender: TObject);
begin
  EditPessoa;
end;

procedure TForm2.LogMensagem(Memo: TMemo; const Msg: string);
begin
  Memo.Lines.Add(Msg);
end;

procedure TForm2.RefreshListaEndereco;
begin
  TabSheetEnderecoListar.TabVisible := True;
  PageControl1.ActivePage := TabSheetEnderecoListar;
  ListaEndereco;
end;

procedure TForm2.RefreshListaPessoa;
begin
  TabSheetPessoaListar.TabVisible := True;
  PageControl1.ActivePage := TabSheetPessoaListar;
  ListarPessoas;
end;

procedure TForm2.TabSheetHide;
begin
  lbNome.Hide;
  TabSheetNovoPessoa.TabVisible := False;
  TabSheetPessoaListar.TabVisible := False;
  TabSheetEnderecoNovo.TabVisible := False;
  TabSheetEnderecoListar.TabVisible := False;
  TabSheetLote.TabVisible := False;
  TabSheetCEP.TabVisible := False;
  TabSheetLote.TabVisible := False;
  TabSheetEnderecoListar.TabVisible := False;
end;

procedure TForm2.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  // Oculta todos os TabSheets primeiro
  TabSheetHide;

  if Assigned(Node) then
  begin

    if Assigned(Node.Parent) then
    begin
      // Tratamento para os subitens de "Pessoa"
      if (Node.Parent.Text = 'Pessoa') and (Node.Text = 'Lotes') then
      begin
        TabSheetLote.TabVisible := True;
        PageControl1.ActivePage := TabSheetLote;
      end
      else if (Node.Parent.Text = 'Endereço') and (Node.Text = 'CEP') then
      begin
        TabSheetCEP.TabVisible := True;
        PageControl1.ActivePage := TabSheetCEP;
      end;
    end
    else
    begin

      if (Node.Text = 'Pessoa') then
      begin
        RefreshListaPessoa;
      end
      else if (Node.Text = 'Endereço') then
      begin
        RefreshListaEndereco;
      end;
    end;
  end;
end;

procedure TForm2.VisualizarEnderecoIntegracao;
var
  SelectedID: Int64;
  SelectedItem: TListItem;
  EnderecoIntegracaoObj, JSONResponse: TJSONObject;
  ResultArray: TJSONArray;
begin
  // Verifica se há um item selecionado no ListView
  if Assigned(ListViewEnderecos.Selected) then
  begin
    SelectedItem := ListViewEnderecos.Selected;

    try
      // Converte o texto da coluna [0] (Caption) para Int64 (ID do endereço)
      SelectedID := StrToInt64(SelectedItem.Caption);

      // Chama o método BuscarEnderecoIntegracao com o ID selecionado
      JSONResponse := FEnderecoService.BuscarEnderecoIntegracao(SelectedID);
      try
        if Assigned(JSONResponse) and JSONResponse.TryGetValue<TJSONArray>
          ('result', ResultArray) then
        begin
          if (ResultArray.Count > 0) and (ResultArray.Items[0] is TJSONObject)
          then
          begin
            EnderecoIntegracaoObj := TJSONObject(ResultArray.Items[0]);

            // Exibe os dados do endereço integrado no Memo
            memoEnderecoIntegrado.Lines.Clear;
            memoEnderecoIntegrado.Lines.Add('ID do Endereço: ' +
              EnderecoIntegracaoObj.GetValue<string>('IdEndereco', ''));
            memoEnderecoIntegrado.Lines.Add
              ('UF: ' + EnderecoIntegracaoObj.GetValue<string>('DsUf', ''));
            memoEnderecoIntegrado.Lines.Add
              ('Cidade: ' + EnderecoIntegracaoObj.GetValue<string>
              ('NmCidade', ''));
            memoEnderecoIntegrado.Lines.Add
              ('Bairro: ' + EnderecoIntegracaoObj.GetValue<string>
              ('NmBairro', ''));
            memoEnderecoIntegrado.Lines.Add
              ('Logradouro: ' + EnderecoIntegracaoObj.GetValue<string>
              ('NmLogradouro', ''));
            memoEnderecoIntegrado.Lines.Add
              ('Complemento: ' + EnderecoIntegracaoObj.GetValue<string>
              ('DsComplemento', ''));
          end
          else
            raise Exception.Create('Formato inválido no campo "result".');
        end
        else
          raise Exception.Create('Campo "result" não encontrado ou vazio.');
      finally
        JSONResponse.Free;
      end;
    except
      on E: EConvertError do
        ShowMessage('Erro ao converter o ID selecionado para número: ' +
          E.Message);
      on E: Exception do
        ShowMessage('Erro ao buscar os dados de integração do endereço: ' +
          E.Message);
    end;
  end
  else
    ShowMessage('Nenhum item selecionado.');
end;

procedure TForm2.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
end;

procedure TForm2.AtualizarPessoasEmLote;
var
  PessoaService: TPessoaService;
  PessoasJSON: TJSONArray;
  OpenDialog: TOpenDialog;
  JSONFile: TStringList;
  FileContent: string;
  ResponseMessage: string;
begin
  OpenDialog := TOpenDialog.Create(Self);
  JSONFile := TStringList.Create;
  PessoaService := TPessoaService.Create;

  try
    OpenDialog.Filter := 'JSON Files|*.json';
    OpenDialog.Title := 'Selecione um arquivo JSON';

    // Verifica se o usuário selecionou um arquivo
    if OpenDialog.Execute then
    begin
      // Lê o conteúdo do arquivo selecionado
      JSONFile.LoadFromFile(OpenDialog.FileName);
      FileContent := JSONFile.Text;

      // Converte o conteúdo para um TJSONArray
      PessoasJSON := TJSONObject.ParseJSONValue(FileContent) as TJSONArray;
      if not Assigned(PessoasJSON) then
        raise Exception.Create('O arquivo JSON não contém um array válido.');

      // Envia o JSON para o serviço
      try
        if PessoaService.UpdatePessoaEmLote(PessoasJSON) then
          ResponseMessage := 'Pessoas atualizadas em lote com sucesso!'
        else
          ResponseMessage := 'Falha ao atualizar pessoas em lote.';

        // Exibe o resultado no Memo
        memoResultJson.Clear;
        memoResultJson.Lines.Add(ResponseMessage);
        memoResultJson.Lines.Add('JSON Enviado:');
        memoResultJson.Lines.Add(PessoasJSON.ToString);
      except
        on E: Exception do
          memoResultJson.Lines.Add('Erro ao atualizar pessoas em lote: ' +
            E.Message);
      end;
    end
    else
      memoResultJson.Lines.Add('Nenhum arquivo foi selecionado.');
  finally
    JSONFile.Free;
    PessoaService.Free;
    if Assigned(PessoasJSON) then
      PessoasJSON.Free;
    OpenDialog.Free;
  end;
end;

procedure TForm2.btnEnderecoCancelClick(Sender: TObject);
begin
  TabSheetHide;
  TabSheetEnderecoListar.TabVisible := True;
  PageControl1.ActivePage := TabSheetEnderecoListar;
end;

procedure TForm2.btnEnderecoGravarClick(Sender: TObject);
begin
  GravarEndereco;
end;

procedure TForm2.BtnPessoaGravaClick(Sender: TObject);
begin
  GravaPessoa;
end;

procedure TForm2.BtnListarPessoaClick(Sender: TObject);
begin
  ListarPessoas;
end;

function TForm2.BuscarEndereco(id: Int64): TJSONObject;
var
  RootJSON: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := nil; // Garante que Result seja inicializado como nil

  try
    MemoResultado.Clear;
    // Recebe o JSON raiz
    RootJSON := FEnderecoService.BuscarEndereco(id);
    try
      // Extrai o array "result"
      ResultArray := RootJSON.GetValue<TJSONArray>('result');

      // Verifica se o array contém itens
      if Assigned(ResultArray) and (ResultArray.Count > 0) then
      begin
        // Clona o primeiro objeto do array para retornar como Result
        Result := TJSONObject(ResultArray.Items[0].Clone);
        LogMensagem(MemoResultado, Format('Endereco encontrado: %s %s',
          [Result.GetValue<string>('IdPessoa'),
          Result.GetValue<string>('DsCep')]));
      end
      else
        LogMensagem(MemoResultado, 'Nenhuma pessoa encontrada.');
    finally
      RootJSON.Free; // Libera o JSON raiz
    end;
  except
    on E: Exception do
    begin
      LogMensagem(MemoResultado, 'Erro ao buscar endereco: ' + E.Message);
      raise; // Relança a exceção para tratamento no chamador
    end;
  end;

end;

function TForm2.BuscarPessoa(id: Int64): TJSONObject;
var
  RootJSON: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := nil; // Garante que Result seja inicializado como nil

  try
    MemoResultado.Clear;
    // Recebe o JSON raiz
    RootJSON := FPessoaService.BuscarPessoa(id);
    try
      // Extrai o array "result"
      ResultArray := RootJSON.GetValue<TJSONArray>('result');

      // Verifica se o array contém itens
      if Assigned(ResultArray) and (ResultArray.Count > 0) then
      begin
        // Clona o primeiro objeto do array para retornar como Result
        Result := TJSONObject(ResultArray.Items[0].Clone);
        LogMensagem(MemoResultado, Format('Pessoa encontrada: %s %s',
          [Result.GetValue<string>('NmPrimeiro'),
          Result.GetValue<string>('NmSegundo')]));
      end
      else
        LogMensagem(MemoResultado, 'Nenhuma pessoa encontrada.');
    finally
      RootJSON.Free; // Libera o JSON raiz
    end;
  except
    on E: Exception do
    begin
      LogMensagem(MemoResultado, 'Erro ao buscar pessoa: ' + E.Message);
      raise; // Relança a exceção para tratamento no chamador
    end;
  end;
end;

procedure TForm2.Button12Click(Sender: TObject);
var
  SelectedID: Int64;
  SelectedItem: TListItem;
begin
  // Verifica se há um item selecionado
  if Assigned(ListViewEnderecos.Selected) then
  begin
    SelectedItem := ListViewEnderecos.Selected;

    try
      // Converte o texto da coluna [0] (Caption) para Int64
      SelectedID := StrToInt64(SelectedItem.Caption);

      ExcluirEndereco(SelectedID);
    except
      on E: EConvertError do
        ShowMessage('Erro ao converter o ID selecionado para número: ' +
          E.Message);
    end;
  end
  else
    ShowMessage('Nenhum item selecionado.');

end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  AtualizarPessoasEmLote;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  FStatus := 'Update';
  EditEndereco;
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
  FStatus := 'Insert';

  TabSheetHide;
  ClearFieldsPessoa;
  TabSheetEnderecoNovo.TabVisible := True;
  PageControl1.ActivePage := TabSheetEnderecoNovo;
end;

procedure TForm2.Button9Click(Sender: TObject);
var
  EnderecoService: TEnderecoService;
begin
  EnderecoService := TEnderecoService.Create;
  try
    try
      // Chama o método para iniciar a atualização de integração de endereços
      EnderecoService.AtualizarIntegracaoViaCep;
      RefreshListaEndereco;
      ShowMessage
        ('Atualização de integração de endereços iniciada com sucesso!');
    except
      on E: Exception do
        ShowMessage('Erro ao iniciar a atualização de endereços: ' + E.Message);
    end;
  finally
    EnderecoService.Free;
  end;

end;

procedure TForm2.btnPessoaCancelClick(Sender: TObject);
begin
  TabSheetHide;
  TabSheetPessoaListar.TabVisible := True;
  PageControl1.ActivePage := TabSheetPessoaListar;
end;

procedure TForm2.btnPessoaDeleteClick(Sender: TObject);
var
  SelectedID: Int64;
  SelectedItem: TListItem;
begin
  // Verifica se há um item selecionado
  if Assigned(ListViewPessoas.Selected) then
  begin
    SelectedItem := ListViewPessoas.Selected;

    try
      // Converte o texto da coluna [0] (Caption) para Int64
      SelectedID := StrToInt64(SelectedItem.Caption);

      ExcluirPessoa(SelectedID);
    except
      on E: EConvertError do
        ShowMessage('Erro ao converter o ID selecionado para número: ' +
          E.Message);
    end;
  end
  else
    ShowMessage('Nenhum item selecionado.');

end;

procedure TForm2.btnPessoaEditarClick(Sender: TObject);
begin
  FStatus := 'Update';
  EditPessoa;
end;

procedure TForm2.btnPessoaNovoClick(Sender: TObject);
begin
  FStatus := 'Insert';
  edtIdPessoa.Hide;
  lblIdCLiente.Hide;
  TabSheetHide;
  ClearFieldsPessoa;
  TabSheetNovoPessoa.TabVisible := True;
  PageControl1.ActivePage := TabSheetNovoPessoa;
end;

procedure TForm2.ClearFieldsEndereco;
begin
  edtEnderecoIdPessoa.Clear;
  edtEndecoCep.Clear;
end;

procedure TForm2.ClearFieldsPessoa;
begin
  edtIdPessoa.Clear;
  edtNatureza.Clear;
  edtDocumento.Clear;
  edtPrimeiroNome.Clear;
  edtSegundoNome.Clear;
end;

procedure TForm2.EditEndereco;
var
  SelectedID: Int64;
  SelectedItem: TListItem;
  EnderecoObj: TJSONObject;

  FIdEndereco, FIdPessoa, FDsCep: string;
begin
  // Verifica se há um item selecionado no ListView
  if Assigned(ListViewEnderecos.Selected) then
  begin
    SelectedItem := ListViewEnderecos.Selected;

    try
      // Converte o texto da coluna [0] (Caption) para Int64 (ID da pessoa)
      SelectedID := StrToInt64(SelectedItem.Caption);

      // Chama o método BuscarPessoa com o ID selecionado
      EnderecoObj := BuscarEndereco(SelectedID);
      try
        if Assigned(EnderecoObj) then
        begin
          // Preenche os campos do formulário com os valores retornados
          if EnderecoObj.TryGetValue<string>('IdEndereco', FIdEndereco) then
            Self.FIdEndereco := FIdEndereco;

          if EnderecoObj.TryGetValue<string>('IdPessoa', FIdPessoa) then
            edtEnderecoIdPessoa.Text := FIdPessoa
          else
            edtEnderecoIdPessoa.Text := '';

          if EnderecoObj.TryGetValue<string>('DsCep', FDsCep) then
            edtEndecoCep.Text := FDsCep
          else
            edtEndecoCep.Text := '';

        end
        else
          raise Exception.Create('Erro: EnderecoObj não foi inicializado.');

      finally
        EnderecoObj.Free;
      end;

      TabSheetHide;
      TabSheetEnderecoNovo.TabVisible := True;
      PageControl1.ActivePage := TabSheetEnderecoNovo;

    except
      on E: EConvertError do
        ShowMessage('Erro ao converter o ID selecionado para número: ' +
          E.Message);
      on E: Exception do
        ShowMessage('Erro ao buscar os dados endereço: ' + E.Message);
    end;
  end
  else
    ShowMessage('Nenhum item selecionado.');

end;

procedure TForm2.EditPessoa;
var
  SelectedID: Int64;
  SelectedItem: TListItem;
  PessoaObj: TJSONObject;
  IdPessoa, FlNatureza, DsDocumento, NmPrimeiro, NmSegundo, DtRegistro: string;
  DtRegistroValue: TDateTime;
begin
  // Verifica se há um item selecionado no ListView
  if Assigned(ListViewPessoas.Selected) then
  begin
    SelectedItem := ListViewPessoas.Selected;

    try
      // Converte o texto da coluna [0] (Caption) para Int64 (ID da pessoa)
      SelectedID := StrToInt64(SelectedItem.Caption);

      // Chama o método BuscarPessoa com o ID selecionado
      PessoaObj := BuscarPessoa(SelectedID);
      try
        if Assigned(PessoaObj) then
        begin
          // Preenche os campos do formulário com os valores retornados
          if PessoaObj.TryGetValue<string>('IdPessoa', IdPessoa) then
            edtIdPessoa.Text := IdPessoa
          else
            edtIdPessoa.Text := '';

          if PessoaObj.TryGetValue<string>('FlNatureza', FlNatureza) then
            edtNatureza.Text := FlNatureza
          else
            edtNatureza.Text := '';

          if PessoaObj.TryGetValue<string>('DsDocumento', DsDocumento) then
            edtDocumento.Text := DsDocumento
          else
            edtDocumento.Text := '';

          if PessoaObj.TryGetValue<string>('NmPrimeiro', NmPrimeiro) then
            edtPrimeiroNome.Text := NmPrimeiro
          else
            edtPrimeiroNome.Text := '';

          if PessoaObj.TryGetValue<string>('NmSegundo', NmSegundo) then
            edtSegundoNome.Text := NmSegundo
          else
            edtSegundoNome.Text := '';

          // Trata DtRegistro
          if PessoaObj.TryGetValue<TDateTime>('DtRegistro', DtRegistroValue)
          then
            dtDataRegistro.DateTime := DtRegistroValue
          else if PessoaObj.TryGetValue<string>('DtRegistro', DtRegistro) then
          begin
            try
              dtDataRegistro.DateTime := ISO8601ToDate(DtRegistro);
              // Converte ISO8601 para TDateTime
            except
              dtDataRegistro.DateTime := Now;
              // Usa a data atual em caso de falha
            end;
          end
          else
            dtDataRegistro.DateTime := Now;
        end
        else
          raise Exception.Create('Erro: PessoaObj não foi inicializado.');

      finally
        PessoaObj.Free;
      end;

      TabSheetHide;
      TabSheetNovoPessoa.TabVisible := True;
      PageControl1.ActivePage := TabSheetNovoPessoa;

    except
      on E: EConvertError do
        ShowMessage('Erro ao converter o ID selecionado para número: ' +
          E.Message);
      on E: Exception do
        ShowMessage('Erro ao buscar os dados da pessoa: ' + E.Message);
    end;
  end
  else
    ShowMessage('Nenhum item selecionado.');

end;

procedure TForm2.edtEndecoCepExit(Sender: TObject);
var
  EnderecoService: TEnderecoService;
  DadosCEP: TJSONObject;
  CEP: string;
begin
  CEP := edtEndecoCep.Text;
  memoResult.Clear;

  EnderecoService := TEnderecoService.Create;
  try
    try
      // Chama o método ConsultarCEP
      DadosCEP := EnderecoService.ConsultarCEP(CEP);
      try
        // Exibe os dados do CEP no Memo
        memoResult.Lines.Add('CEP: ' + DadosCEP.GetValue<string>('cep'));
        memoResult.Lines.Add('Logradouro: ' + DadosCEP.GetValue<string>
          ('logradouro'));
        memoResult.Lines.Add('Complemento: ' + DadosCEP.GetValue<string>
          ('complemento'));
        memoResult.Lines.Add('Bairro: ' + DadosCEP.GetValue<string>('bairro'));
        memoResult.Lines.Add('Cidade: ' + DadosCEP.GetValue<string>
          ('localidade'));
        memoResult.Lines.Add('UF: ' + DadosCEP.GetValue<string>('uf'));
      finally
        DadosCEP.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao consultar o CEP: ' + E.Message);
    end;
  finally
    EnderecoService.Free;
  end;
end;

procedure TForm2.edtEnderecoIdPessoaExit(Sender: TObject);
var
  PessoaObj: TJSONObject;
  NmPrimeiro, NmSegundo: string;
begin
  if edtEnderecoIdPessoa.Text <> '' then
  begin
    PessoaObj := BuscarPessoa(StrToInt(edtEnderecoIdPessoa.Text));
    if PessoaObj.TryGetValue<string>('NmPrimeiro', NmPrimeiro) and
      PessoaObj.TryGetValue<string>('NmSegundo', NmSegundo) then
    begin
      lbNome.Visible := True;
      lbNome.Caption := NmPrimeiro + ' ' + NmSegundo;
    end;
  end;

end;

procedure TForm2.edtCEPExit(Sender: TObject);
var
  EnderecoService: TEnderecoService;
  DadosCEP: TJSONObject;
  CEP: string;
begin
  CEP := edtCEP.Text;
  MemoResulrCEP.Clear;

  EnderecoService := TEnderecoService.Create;
  try
    try
      // Chama o método ConsultarCEP
      DadosCEP := EnderecoService.ConsultarCEP(CEP);
      try
        // Exibe os dados do CEP no Memo
        MemoResulrCEP.Lines.Add('CEP: ' + DadosCEP.GetValue<string>('cep'));
        MemoResulrCEP.Lines.Add('Logradouro: ' + DadosCEP.GetValue<string>
          ('logradouro'));
        MemoResulrCEP.Lines.Add('Complemento: ' + DadosCEP.GetValue<string>
          ('complemento'));
        MemoResulrCEP.Lines.Add('Bairro: ' + DadosCEP.GetValue<string>
          ('bairro'));
        MemoResulrCEP.Lines.Add('Cidade: ' + DadosCEP.GetValue<string>
          ('localidade'));
        MemoResulrCEP.Lines.Add('UF: ' + DadosCEP.GetValue<string>('uf'));
        MemoResulrCEP.Lines.Add('IBGE: ' + DadosCEP.GetValue<string>('ibge'));
      finally
        DadosCEP.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao consultar o CEP: ' + E.Message);
    end;
  finally
    EnderecoService.Free;
  end;

end;

procedure TForm2.ExcluirEndereco(IdEndereco: Int64);
var
  EnderecoService: TEnderecoService;
begin
  EnderecoService := TEnderecoService.Create;
  try
    try
      // Chama o serviço para excluir o endereço
      if EnderecoService.ExcluirEndereco(IdEndereco) then
      begin
        RefreshListaEndereco;
        ShowMessage('Endereço excluído com sucesso!');
      end
      else
        ShowMessage('Falha ao excluir o endereço.');
    except
      on E: Exception do
        ShowMessage('Erro ao excluir o endereço: ' + E.Message);
    end;
  finally
    EnderecoService.Free;
  end;
end;

procedure TForm2.ExcluirPessoa(id: Int64);
var
  PessoaService: TPessoaService;
  IdPessoa: Int64;
begin
  PessoaService := TPessoaService.Create;
  try
    if PessoaService.ExcluirPessoa(id) then
    begin
      RefreshListaPessoa;
      LogMensagem(MemoResultado, 'Pessoa excluída com sucesso!');
    end
    else
      LogMensagem(MemoResultado, 'Falha ao excluir a pessoa.');
  finally
    PessoaService.Free;
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
var
  IniFilePath: string;
  IniFile: TIniFile;
begin
  FIdEndereco := '';
  FStatus := '';
  // Carregar FBaseUrl do arquivo AppConfig.ini
  IniFilePath := ExtractFilePath(ParamStr(0)) + '..\..\Config\AppConfig.ini';
  IniFile := TIniFile.Create(IniFilePath);
  try
    FBaseUrl := IniFile.ReadString('Server', 'BaseUrl', '');
    if FBaseUrl.Trim.IsEmpty then
      raise Exception.Create('BaseUrl não configurado no AppConfig.ini.');
  finally
    IniFile.Free;
  end;

  FPessoaService := TPessoaService.Create;
  FEnderecoService := TEnderecoService.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FPessoaService.Free;
  FEnderecoService.Free;
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0; // Cancela o comportamento padrão do Enter
    Perform(WM_NEXTDLGCTL, 0, 0); // Move para o próximo controle (Tab)
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  // Oculta todos os TabSheets primeiro
  TabSheetHide;
end;

procedure TForm2.GravaPessoa;
var
  IdPessoa, FlNatureza, DsDocumento, NmPrimeiro, NmSegundo: string;
  DtRegistro: TDateTime;
  OperacaoSucesso: Boolean;
  MensagemLog: string;
begin
  try
    // Captura os valores dos campos
    IdPessoa := edtIdPessoa.Text;
    FlNatureza := edtNatureza.Text;
    DsDocumento := edtDocumento.Text;
    NmPrimeiro := edtPrimeiroNome.Text;
    NmSegundo := edtSegundoNome.Text;
    DtRegistro := dtDataRegistro.Date;

    // Valida os campos obrigatórios
    if FlNatureza.IsEmpty or DsDocumento.IsEmpty or NmPrimeiro.IsEmpty or
      NmSegundo.IsEmpty then
    begin
      LogMensagem(MemoResultado, 'Preencha todos os campos obrigatórios.');
      Exit;
    end;

    // Executa a operação (Inserir ou Atualizar)
    if FStatus = 'Insert' then
    begin
      OperacaoSucesso := FPessoaService.InserirPessoa(StrToInt(FlNatureza),
        DsDocumento, NmPrimeiro, NmSegundo, DtRegistro);
      MensagemLog := 'Pessoa inserida com sucesso!';
    end
    else
    begin
      OperacaoSucesso := FPessoaService.AtualizarPessoa(StrToInt(IdPessoa),
        StrToInt(FlNatureza), DsDocumento, NmPrimeiro, NmSegundo, DtRegistro);
      MensagemLog := 'Pessoa atualizada com sucesso!';
    end;

    // Log do resultado
    if OperacaoSucesso then
    begin
      LogMensagem(MemoResultado, MensagemLog);
      RefreshListaPessoa;
    end
    else
      LogMensagem(MemoResultado, 'Erro ao realizar a operação.');

  except
    on E: Exception do
      LogMensagem(MemoResultado, 'Erro ao processar a operação: ' + E.Message);
  end;

end;

procedure TForm2.GravarEndereco;
var
  EnderecoService: TEnderecoService;
  EnderecoJSON: TJSONObject;
  IdPessoa, IdEndereco: Int64;
  DsCep: string;
  OperacaoSucesso: Boolean;
  MensagemLog: string;
begin
  try
    // Valida os campos antes de enviar a requisição
    if not TryStrToInt64(edtEnderecoIdPessoa.Text, IdPessoa) then
      raise Exception.Create('ID da Pessoa inválido.');

    DsCep := edtEndecoCep.Text;
    if DsCep.IsEmpty then
      raise Exception.Create('CEP não pode estar vazio.');

    // Monta o JSON para enviar ao servidor
    EnderecoJSON := TJSONObject.Create;
    try
      EnderecoJSON.AddPair('IdPessoa', TJSONNumber.Create(IdPessoa));
      EnderecoJSON.AddPair('DsCep', DsCep);

      // Chama o serviço para gravar o endereço
      EnderecoService := TEnderecoService.Create;
      try
        // Executa a operação (Inserir ou Atualizar)
        if FStatus = 'Insert' then
        begin
          OperacaoSucesso := EnderecoService.InserirEndereco(EnderecoJSON);
          MensagemLog := 'Endereço gravado com sucesso!';

        end
        else
        begin
          EnderecoJSON.AddPair('IdEndereco', TJSONNumber.Create(FIdEndereco));
          OperacaoSucesso := EnderecoService.AtualizarEndereco(EnderecoJSON);
          MensagemLog := 'Endereço atualizado com sucesso!';
        end;

        // Log do resultado
        if OperacaoSucesso then
        begin
          LogMensagem(MemoResultado, MensagemLog);
          RefreshListaEndereco;
        end
        else
          LogMensagem(MemoResultado, 'Erro ao realizar a operação.');

      finally
        EnderecoService.Free;
      end;
    finally
      EnderecoJSON.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao gravar endereço: ' + E.Message);
  end;

end;

end.
