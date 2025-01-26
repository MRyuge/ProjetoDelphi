unit Endereco;

interface

uses
  System.SysUtils, System.JSON;

type
  TEndereco = class
  private
    FIdEndereco: Int64;
    FIdPessoa: Int64;
    FDsCep: string;
  public
    constructor Create; overload;
    constructor Create(AIdEndereco, AIdPessoa: Int64; ADsCep: string); overload;
    destructor Destroy; override;

    // Métodos para JSON
    function ToJSON: TJSONObject;
    class function FromJSON(AJSON: TJSONObject): TEndereco;

    // Propriedades
    property IdEndereco: Int64 read FIdEndereco write FIdEndereco;
    property IdPessoa: Int64 read FIdPessoa write FIdPessoa;
    property DsCep: string read FDsCep write FDsCep;
  end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
  inherited Create;
end;

constructor TEndereco.Create(AIdEndereco, AIdPessoa: Int64; ADsCep: string);
begin
  inherited Create;
  FIdEndereco := AIdEndereco;
  FIdPessoa := AIdPessoa;
  FDsCep := ADsCep;
end;

destructor TEndereco.Destroy;
begin
  inherited Destroy;
end;

function TEndereco.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('IdEndereco', TJSONNumber.Create(FIdEndereco));
  Result.AddPair('IdPessoa', TJSONNumber.Create(FIdPessoa));
  Result.AddPair('DsCep', FDsCep);
end;

class function TEndereco.FromJSON(AJSON: TJSONObject): TEndereco;
begin
  Result := TEndereco.Create;
  Result.IdEndereco := AJSON.GetValue<Int64>('IdEndereco');
  Result.IdPessoa := AJSON.GetValue<Int64>('IdPessoa');
  Result.DsCep := AJSON.GetValue<string>('DsCep');
end;

end.

