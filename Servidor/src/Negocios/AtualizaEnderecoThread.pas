unit AtualizaEnderecoThread;

interface

uses
  System.Classes, System.Generics.Collections, EnderecoDAO, Endereco,
  EnderecoIntegracao,
  EnderecoIntegracaoDAO, HttpUtils, System.JSON, System.SysUtils;

type
  TAtualizaEnderecoThread = class(TThread)
  private
    FEnderecoDAO: TEnderecoDAO;
    FEnderecoIntegracaoDAO: TEnderecoIntegracaoDAO;
    procedure ProcessarEndereco(AEndereco: TEndereco);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

implementation

constructor TAtualizaEnderecoThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FEnderecoDAO := TEnderecoDAO.Create;
  FEnderecoIntegracaoDAO := TEnderecoIntegracaoDAO.Create;
end;

destructor TAtualizaEnderecoThread.Destroy;
begin
  FEnderecoDAO.Free;
  FEnderecoIntegracaoDAO.Free;
  inherited;
end;

procedure TAtualizaEnderecoThread.ProcessarEndereco(AEndereco: TEndereco);
var
  EnderecoIntegracao: TEnderecoIntegracao;
begin
  try
    // Consulta a API ViaCEP para obter os dados
    EnderecoIntegracao := THttpUtils.ConsultarViaCEP(AEndereco.DsCep);

    // Verifica se a consulta retornou dados v�lidos
    if not Assigned(EnderecoIntegracao) then
    begin
      Writeln(Format('Nenhuma informa��o encontrada para o CEP: %s (ID: %d)',
        [AEndereco.DsCep, AEndereco.IdEndereco]));
      Exit;
    end;

    try
      // Define o ID do endere�o para a integra��o
      EnderecoIntegracao.IdEndereco := AEndereco.IdEndereco;

      // Atualiza ou insere os dados no banco
      FEnderecoIntegracaoDAO.InserirOuAtualizar(EnderecoIntegracao);
    finally
      EnderecoIntegracao.Free;
    end;
  except
    on E: Exception do
    begin
      // Sincroniza a execu��o para capturar exce��es no contexto correto
      Synchronize(
        procedure
        begin
          Writeln(Format('Erro ao processar Endere�o ID %d (CEP: %s): %s',
            [AEndereco.IdEndereco, AEndereco.DsCep, E.Message]));
        end);
    end;
  end;
end;

procedure TAtualizaEnderecoThread.Execute;
var
  ListaEnderecos: TList<TEndereco>;
  Endereco: TEndereco;
begin
  ListaEnderecos := FEnderecoDAO.GetAll;

  if not Assigned(ListaEnderecos) then
    raise Exception.CreateFmt
      ('Erro: Nenhum endere�o encontrado para atualizar.', []);

  try
    for Endereco in ListaEnderecos do
    begin
      try
        // Processa cada endere�o individualmente
        ProcessarEndereco(Endereco);
      except
        on E: Exception do
        begin
          // Lan�a uma exce��o espec�fica para cada endere�o com detalhes do erro
          raise Exception.CreateFmt('Erro ao processar endere�o ID %d: %s',
            [Endereco.IdEndereco, E.Message]);
        end;
      end;
    end;
  finally
    ListaEnderecos.Free; // Libera a lista se a propriedade for da thread
  end;
end;

end.
