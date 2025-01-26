unit EnderecoBusiness;

interface

uses
  System.SysUtils, EnderecoDAO, Endereco, System.Generics.Collections;

type
  TEnderecoBusiness = class
  private
    FDAO: TEnderecoDAO;
  public
    constructor Create(ADAO: TEnderecoDAO);
    function InserirEndereco(IdPessoa: Int64; DsCep: string): Boolean;
    function AtualizarEndereco(IdEndereco, IdPessoa: Int64; DsCep: string): Boolean;
    function ExcluirEndereco(IdEndereco: Int64): Boolean;
    function BuscarEnderecoPorId(IdEndereco: Int64): TEndereco;
    function ListarEnderecos: TList<TEndereco>;
  end;

implementation

{ TEnderecoBusiness }

constructor TEnderecoBusiness.Create(ADAO: TEnderecoDAO);
begin
  inherited Create;
  FDAO := ADAO;
end;

function TEnderecoBusiness.InserirEndereco(IdPessoa: Int64; DsCep: string): Boolean;
var
  Endereco: TEndereco;
begin
  if IdPessoa <= 0 then
    raise Exception.Create('ID da pessoa inválido.');

  if DsCep.Trim.IsEmpty then
    raise Exception.Create('O CEP não pode ser vazio.');

  Endereco := TEndereco.Create(0, IdPessoa, DsCep);
  try
    Result := FDAO.Insert(Endereco);
  finally
    Endereco.Free;
  end;
end;

function TEnderecoBusiness.AtualizarEndereco(IdEndereco, IdPessoa: Int64; DsCep: string): Boolean;
var
  Endereco: TEndereco;
begin
  if IdEndereco <= 0 then
    raise Exception.Create('ID do endereço inválido.');

  if IdPessoa <= 0 then
    raise Exception.Create('ID da pessoa inválido.');

  if DsCep.Trim.IsEmpty then
    raise Exception.Create('O CEP não pode ser vazio.');

  Endereco := TEndereco.Create(IdEndereco, IdPessoa, DsCep);
  try
    Result := FDAO.Update(Endereco);
  finally
    Endereco.Free;
  end;
end;

function TEnderecoBusiness.ExcluirEndereco(IdEndereco: Int64): Boolean;
begin
  if IdEndereco <= 0 then
    raise Exception.Create('ID do endereço inválido.');

  Result := FDAO.Delete(IdEndereco);
end;

function TEnderecoBusiness.BuscarEnderecoPorId(IdEndereco: Int64): TEndereco;
begin
  if IdEndereco <= 0 then
    raise Exception.Create('ID do endereço inválido.');

  Result := FDAO.GetById(IdEndereco);
end;

function TEnderecoBusiness.ListarEnderecos: TList<TEndereco>;
begin
  Result := FDAO.GetAll;
end;

end.

