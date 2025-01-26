unit EnderecoIntegracaoDAO;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, EnderecoIntegracao, DataModuleDatabase;

type
  TEnderecoIntegracaoDAO = class
  private

  public
    procedure InserirOuAtualizar(AEnderecoIntegracao: TEnderecoIntegracao);
    function GetByIdEndereco(AIdEndereco: Int64): TEnderecoIntegracao;
    procedure InserirOuAtualizarEnderecoIntegracao(const Integracao
      : TEnderecoIntegracao);
  end;

implementation

{ TEnderecoIntegracaoDAO }

procedure TEnderecoIntegracaoDAO.InserirOuAtualizar(AEnderecoIntegracao
  : TEnderecoIntegracao);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.FDConnection;

    // Verifica se o registro j� existe
    Query.SQL.Text :=
      'SELECT COUNT(*) FROM endereco_integracao WHERE idendereco = :IdEndereco';
    Query.ParamByName('IdEndereco').AsLargeInt :=
      AEnderecoIntegracao.IdEndereco;
    Query.Open;

    if Query.Fields[0].AsInteger > 0 then
    begin
      // Atualiza registro existente
      Query.SQL.Text :=
        'UPDATE endereco_integracao SET dsuf = :DsUf, nmcidade = :NmCidade, nmbairro = :NmBairro, '
        + 'nmlogradouro = :NmLogradouro, dscomplemento = :DsComplemento ' +
        'WHERE idendereco = :IdEndereco';
    end
    else
    begin
      // Insere novo registro
      Query.SQL.Text :=
        'INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) '
        + 'VALUES (:IdEndereco, :DsUf, :NmCidade, :NmBairro, :NmLogradouro, :DsComplemento)';
    end;

    Query.ParamByName('IdEndereco').AsLargeInt :=
      AEnderecoIntegracao.IdEndereco;
    Query.ParamByName('DsUf').AsString := AEnderecoIntegracao.DsUf;
    Query.ParamByName('NmCidade').AsString := AEnderecoIntegracao.NmCidade;
    Query.ParamByName('NmBairro').AsString := AEnderecoIntegracao.NmBairro;
    Query.ParamByName('NmLogradouro').AsString :=
      AEnderecoIntegracao.NmLogradouro;
    Query.ParamByName('DsComplemento').AsString :=
      AEnderecoIntegracao.DsComplemento;

    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TEnderecoIntegracaoDAO.GetByIdEndereco(AIdEndereco: Int64)
  : TEnderecoIntegracao;
var
  Query: TFDQuery;
  EnderecoIntegracao: TEnderecoIntegracao;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.FDConnection;
    Query.SQL.Text :=
      'SELECT * FROM endereco_integracao WHERE idendereco = :IdEndereco';
    Query.ParamByName('IdEndereco').AsLargeInt := AIdEndereco;
    Query.Open;

    if not Query.IsEmpty then
    begin
      EnderecoIntegracao := TEnderecoIntegracao.Create;
      EnderecoIntegracao.IdEndereco := Query.FieldByName('idendereco')
        .AsLargeInt;
      EnderecoIntegracao.DsUf := Query.FieldByName('dsuf').AsString;
      EnderecoIntegracao.NmCidade := Query.FieldByName('nmcidade').AsString;
      EnderecoIntegracao.NmBairro := Query.FieldByName('nmbairro').AsString;
      EnderecoIntegracao.NmLogradouro :=
        Query.FieldByName('nmlogradouro').AsString;
      EnderecoIntegracao.DsComplemento :=
        Query.FieldByName('dscomplemento').AsString;

      Result := EnderecoIntegracao;
    end
    else
      raise Exception.Create
        ('Nenhum endere�o de integra��o encontrado para o ID ' +
        AIdEndereco.ToString);
  finally
    Query.Free;
  end;
end;

procedure TEnderecoIntegracaoDAO.InserirOuAtualizarEnderecoIntegracao
  (const Integracao: TEnderecoIntegracao);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.FDConnection;

    // Verifica se o registro j� existe
    Query.SQL.Text :=
      'SELECT COUNT(*) FROM endereco_integracao WHERE idendereco = :IdEndereco';
    Query.ParamByName('IdEndereco').AsLargeInt := Integracao.IdEndereco;
    Query.Open;

    if Query.Fields[0].AsInteger > 0 then
    begin
      // Registro existe, realiza o UPDATE
      Query.SQL.Text :=
        'UPDATE endereco_integracao SET dsuf = :DsUf, nmcidade = :NmCidade, ' +
        'nmbairro = :NmBairro, nmlogradouro = :NmLogradouro, dscomplemento = :DsComplemento '
        + 'WHERE idendereco = :IdEndereco';
    end
    else
    begin
      // Registro n�o existe, realiza o INSERT
      Query.SQL.Text :=
        'INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) '
        + 'VALUES (:IdEndereco, :DsUf, :NmCidade, :NmBairro, :NmLogradouro, :DsComplemento)';
    end;

    Query.ParamByName('IdEndereco').AsLargeInt := Integracao.IdEndereco;
    Query.ParamByName('DsUf').AsString := Integracao.DsUf;
    Query.ParamByName('NmCidade').AsString := Integracao.NmCidade;
    Query.ParamByName('NmBairro').AsString := Integracao.NmBairro;
    Query.ParamByName('NmLogradouro').AsString := Integracao.NmLogradouro;
    Query.ParamByName('DsComplemento').AsString := Integracao.DsComplemento;

    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
