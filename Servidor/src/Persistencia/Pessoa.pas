unit Pessoa;

interface

uses
  System.SysUtils, System.JSON,System.DateUtils;

type
  TPessoa = class
  private
    FIdPessoa: Int64;
    FFlNatureza: Integer;
    FDsDocumento: string;
    FNmPrimeiro: string;
    FNmSegundo: string;
    FDtRegistro: TDateTime;
  public
    constructor Create; overload;
    constructor Create(AIdPessoa: Int64; AFlNatureza: Integer; ADsDocumento, ANmPrimeiro, ANmSegundo: string; ADtRegistro: TDateTime); overload;
    destructor Destroy; override;

    // Métodos para JSON
    function ToJSON: TJSONObject;
    class function FromJSON(AJSON: TJSONObject): TPessoa;

    // Propriedades
    property IdPessoa: Int64 read FIdPessoa write FIdPessoa;
    property FlNatureza: Integer read FFlNatureza write FFlNatureza;
    property DsDocumento: string read FDsDocumento write FDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write FNmPrimeiro;
    property NmSegundo: string read FNmSegundo write FNmSegundo;
    property DtRegistro: TDateTime read FDtRegistro write FDtRegistro;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin
  inherited Create;
end;

constructor TPessoa.Create(AIdPessoa: Int64; AFlNatureza: Integer; ADsDocumento, ANmPrimeiro, ANmSegundo: string; ADtRegistro: TDateTime);
begin
  inherited Create;
  FIdPessoa := AIdPessoa;
  FFlNatureza := AFlNatureza;
  FDsDocumento := ADsDocumento;
  FNmPrimeiro := ANmPrimeiro;
  FNmSegundo := ANmSegundo;
  FDtRegistro := ADtRegistro;
end;

destructor TPessoa.Destroy;
begin
  inherited Destroy;
end;

function TPessoa.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('IdPessoa', TJSONNumber.Create(FIdPessoa));
  Result.AddPair('FlNatureza', TJSONNumber.Create(FFlNatureza));
  Result.AddPair('DsDocumento', FDsDocumento);
  Result.AddPair('NmPrimeiro', FNmPrimeiro);
  Result.AddPair('NmSegundo', FNmSegundo);
  Result.AddPair('DtRegistro', TJSONString.Create(DateToISO8601(FDtRegistro)));
end;

class function TPessoa.FromJSON(AJSON: TJSONObject): TPessoa;
begin
  Result := TPessoa.Create;
  Result.IdPessoa := AJSON.GetValue<Int64>('IdPessoa');
  Result.FlNatureza := AJSON.GetValue<Integer>('FlNatureza');
  Result.DsDocumento := AJSON.GetValue<string>('DsDocumento');
  Result.NmPrimeiro := AJSON.GetValue<string>('NmPrimeiro');
  Result.NmSegundo := AJSON.GetValue<string>('NmSegundo');
  Result.DtRegistro := ISO8601ToDate(AJSON.GetValue<string>('DtRegistro'));
end;

end.

