unit EnderecoIntegracao;

interface

type
  TEnderecoIntegracao = class
  private
    FIdEndereco: Int64;
    FDsUf: string;
    FNmCidade: string;
    FNmBairro: string;
    FNmLogradouro: string;
    FDsComplemento: string;
  public
    constructor Create; overload;
    constructor Create(AIdEndereco: Int64; const ADsUf, ANmCidade, ANmBairro,
      ANmLogradouro, ADsComplemento: string); overload;
    property IdEndereco: Int64 read FIdEndereco write FIdEndereco;
    property DsUf: string read FDsUf write FDsUf;
    property NmCidade: string read FNmCidade write FNmCidade;
    property NmBairro: string read FNmBairro write FNmBairro;
    property NmLogradouro: string read FNmLogradouro write FNmLogradouro;
    property DsComplemento: string read FDsComplemento write FDsComplemento;
  end;

implementation

constructor TEnderecoIntegracao.Create;
begin
  inherited Create;
end;

constructor TEnderecoIntegracao.Create(AIdEndereco: Int64;
  const ADsUf, ANmCidade, ANmBairro, ANmLogradouro, ADsComplemento: string);
begin
  inherited Create;
  FIdEndereco := AIdEndereco;
  FDsUf := ADsUf;
  FNmCidade := ANmCidade;
  FNmBairro := ANmBairro;
  FNmLogradouro := ANmLogradouro;
  FDsComplemento := ADsComplemento;
end;

end.
