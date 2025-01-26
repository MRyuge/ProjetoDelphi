unit PessoaBusiness;

interface

uses
  System.SysUtils, PessoaDAO, Pessoa, System.Generics.Collections;

type
  TPessoaBusiness = class
  private
    FDAO: TPessoaDAO;
  public
    constructor Create(ADAO: TPessoaDAO);
    function InserirPessoa(FlNatureza: Integer;
      DsDocumento, NmPrimeiro, NmSegundo: string;
      DtRegistro: TDateTime): Boolean;
    function AtualizarPessoa(IdPessoa: Int64; FlNatureza: Integer;
      DsDocumento, NmPrimeiro, NmSegundo: string;
      DtRegistro: TDateTime): Boolean;
    function ExcluirPessoa(IdPessoa: Int64): Boolean;
    function BuscarPessoaPorId(IdPessoa: Int64): TPessoa;
    function ListarPessoas: TList<TPessoa>;
  end;

implementation

{ TPessoaBusiness }

constructor TPessoaBusiness.Create(ADAO: TPessoaDAO);
begin
  inherited Create;
  FDAO := ADAO;
end;

function TPessoaBusiness.InserirPessoa(FlNatureza: Integer;
  DsDocumento, NmPrimeiro, NmSegundo: string; DtRegistro: TDateTime): Boolean;
var
  Pessoa: TPessoa;
begin
  if DsDocumento.Trim.IsEmpty then
    raise Exception.Create('O documento não pode ser vazio.');
  if NmPrimeiro.Trim.IsEmpty then
    raise Exception.Create('O nome não pode ser vazio.');

  Pessoa := TPessoa.Create(0, FlNatureza, DsDocumento, NmPrimeiro, NmSegundo,
    DtRegistro);
  try
    Result := FDAO.Insert(Pessoa);
  finally
    Pessoa.Free;
  end;
end;

function TPessoaBusiness.AtualizarPessoa(IdPessoa: Int64; FlNatureza: Integer;
  DsDocumento, NmPrimeiro, NmSegundo: string; DtRegistro: TDateTime): Boolean;
var
  Pessoa: TPessoa;
begin
  if IdPessoa <= 0 then
    raise Exception.Create('ID inválido para atualização.');

  Pessoa := TPessoa.Create(IdPessoa, FlNatureza, DsDocumento, NmPrimeiro,
    NmSegundo, DtRegistro);
  try
    Result := FDAO.Update(Pessoa);
  finally
    Pessoa.Free;
  end;
end;

function TPessoaBusiness.ExcluirPessoa(IdPessoa: Int64): Boolean;
begin
  if IdPessoa <= 0 then
    raise Exception.Create('ID inválido para exclusão.');

  Result := FDAO.Delete(IdPessoa);
end;

function TPessoaBusiness.BuscarPessoaPorId(IdPessoa: Int64): TPessoa;
begin
  if IdPessoa <= 0 then
    raise Exception.Create('ID inválido para busca.');

  Result := FDAO.GetById(IdPessoa);
end;

function TPessoaBusiness.ListarPessoas: TList<TPessoa>;
begin
  Result := FDAO.GetAll;
end;

end.
