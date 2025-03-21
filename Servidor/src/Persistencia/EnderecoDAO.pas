unit EnderecoDAO;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  Endereco, EnderecoIntegracao, DataModuleDatabase;

type
  TEnderecoDAO = class
  private

  public
    function GetAll: TList<TEndereco>;
    function Insert(Endereco: TEndereco): Boolean;
    function Update(Endereco: TEndereco): Boolean;
    function Delete(IdEndereco: Int64): Boolean;
    procedure InserirOuAtualizarEnderecoIntegracao(const AEnderecoIntegracao
      : TEnderecoIntegracao);
    function GetById(IdEndereco: Int64): TEndereco;
    function EnderecoExiste(IdEndereco: Int64): Boolean;
  end;

implementation

{ TEnderecoDAO }

function TEnderecoDAO.EnderecoExiste(IdEndereco: Int64): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.FDConnection;
    Query.SQL.Text := 'SELECT 1 FROM endereco WHERE idendereco = :IdEndereco';
    Query.ParamByName('IdEndereco').AsLargeInt := IdEndereco;
    Query.Open;

    Result := not Query.IsEmpty;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.GetAll: TList<TEndereco>;
var
  Lista: TList<TEndereco>;
  Query: TFDQuery;
  Endereco: TEndereco;
begin
  Lista := TList<TEndereco>.Create;
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;
      Query.SQL.Text := 'SELECT idendereco, idpessoa, dscep FROM endereco';
      Query.Open;

      while not Query.Eof do
      begin
        Endereco := TEndereco.Create(Query.FieldByName('idendereco').AsLargeInt,
          Query.FieldByName('idpessoa').AsLargeInt, Query.FieldByName('dscep')
          .AsString);
        Lista.Add(Endereco);
        Query.Next;
      end;

      Result := Lista;
    except
      on E: Exception do
      begin
        Lista.Free;
        raise Exception.Create('Erro ao buscar todos os endere�os: ' +
          E.Message);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.Insert(Endereco: TEndereco): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;
      Query.SQL.Text :=
        'INSERT INTO endereco (idpessoa, dscep) VALUES (:IdPessoa, :DsCep)';
      Query.ParamByName('IdPessoa').AsLargeInt := Endereco.IdPessoa;
      Query.ParamByName('DsCep').AsString := Endereco.DsCep;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao inserir endere�o: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.Update(Endereco: TEndereco): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;
      Query.SQL.Text :=
        'UPDATE endereco SET idpessoa = :IdPessoa, dscep = :DsCep WHERE idendereco = :IdEndereco';
      Query.ParamByName('IdPessoa').AsLargeInt := Endereco.IdPessoa;
      Query.ParamByName('DsCep').AsString := Endereco.DsCep;
      Query.ParamByName('IdEndereco').AsLargeInt := Endereco.IdEndereco;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar endere�o: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.Delete(IdEndereco: Int64): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;
      Query.SQL.Text := 'DELETE FROM endereco WHERE idendereco = :IdEndereco';
      Query.ParamByName('IdEndereco').AsLargeInt := IdEndereco;
      Query.ExecSQL;
      Result :=  Query.RowsAffected > 0;
    except
      on E: Exception do
        raise Exception.Create('Erro ao excluir endere�o: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

procedure TEnderecoDAO.InserirOuAtualizarEnderecoIntegracao
  (const AEnderecoIntegracao: TEnderecoIntegracao);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;

      Query.SQL.Text :=
        'SELECT COUNT(*) FROM endereco_integracao WHERE idendereco = :IdEndereco';
      Query.ParamByName('IdEndereco').AsLargeInt :=
        AEnderecoIntegracao.IdEndereco;
      Query.Open;

      if Query.Fields[0].AsInteger > 0 then
      begin
        Query.SQL.Text :=
          'UPDATE endereco_integracao SET dsuf = :DsUf, nmcidade = :NmCidade, nmbairro = :NmBairro, '
          + 'nmlogradouro = :NmLogradouro, dscomplemento = :DsComplemento WHERE idendereco = :IdEndereco';
      end
      else
      begin
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
    except
      on E: Exception do
        raise Exception.Create
          ('Erro ao inserir ou atualizar endere�o de integra��o: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.GetById(IdEndereco: Int64): TEndereco;
var
  Query: TFDQuery;
  Endereco: TEndereco;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := dmDatabase.FDConnection;
      Query.SQL.Text :=
        'SELECT idendereco, idpessoa, dscep FROM endereco WHERE idendereco = :IdEndereco';
      Query.ParamByName('IdEndereco').AsLargeInt := IdEndereco;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Endereco := TEndereco.Create(Query.FieldByName('idendereco').AsLargeInt,
          Query.FieldByName('idpessoa').AsLargeInt, Query.FieldByName('dscep')
          .AsString);
        Result := Endereco;
      end
      else
        raise Exception.Create('Endere�o com ID ' + IdEndereco.ToString +
          ' n�o encontrado.');
    except
      on E: Exception do
        raise Exception.Create('Erro ao buscar endere�o por ID: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

end.
