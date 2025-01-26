unit HttpUtils;

interface

uses
  System.SysUtils, EnderecoIntegracao, IdSSLOpenSSL, IdHTTP, System.JSON,
  System.Net.HttpClient;

type
  THttpUtils = class
  public
    class function GetJSON(const URL: string): TJSONObject;
    class function ConsultarViaCEP(ACep: string): TEnderecoIntegracao;
  end;

implementation

{ THttpUtils }

class function THttpUtils.ConsultarViaCEP(ACep: string): TEnderecoIntegracao;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  JsonResponse: TJSONObject;
  ResponseString: string;
  EnderecoIntegracao: TEnderecoIntegracao;

  function IsNumeric(const AValue: string): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 1 to Length(AValue) do
      if not CharInSet(AValue[I], ['0' .. '9']) then
        Exit(False);
  end;

begin
  Result := nil;

  if ACep.Trim.IsEmpty or (Length(ACep) <> 8) or not IsNumeric(ACep) then
    raise Exception.Create
      ('CEP inválido. O CEP deve conter exatamente 8 dígitos numéricos.');

  HttpClient := THTTPClient.Create;
  try
    try
      Response := HttpClient.Get
        (Format('https://viacep.com.br/ws/%s/json/', [ACep]));

      if Response.StatusCode = 200 then
      begin
        ResponseString := Response.ContentAsString;
        JsonResponse := TJSONObject.ParseJSONValue(ResponseString)
          as TJSONObject;

        if not Assigned(JsonResponse) then
          raise Exception.Create('Resposta do servidor não é um JSON válido.');

        try
          // Verifica explicitamente se o campo "erro" está presente e é "true"
          if JsonResponse.TryGetValue<string>('erro', ResponseString) and
            (ResponseString = 'true') then
            raise Exception.Create('CEP não encontrado.');

          // Preenche o objeto TEnderecoIntegracao
          EnderecoIntegracao := TEnderecoIntegracao.Create;
          EnderecoIntegracao.DsUf := JsonResponse.GetValue<string>('uf', '');
          EnderecoIntegracao.NmCidade := JsonResponse.GetValue<string>
            ('localidade', '');
          EnderecoIntegracao.NmBairro := JsonResponse.GetValue<string>
            ('bairro', '');
          EnderecoIntegracao.NmLogradouro := JsonResponse.GetValue<string>
            ('logradouro', '');
          EnderecoIntegracao.DsComplemento := JsonResponse.GetValue<string>
            ('complemento', '');

          Result := EnderecoIntegracao;
        finally
          JsonResponse.Free;
        end;
      end
      else
        raise Exception.CreateFmt
          ('Erro ao consultar o ViaCEP. Código HTTP: %d - %s',
          [Response.StatusCode, Response.StatusText]);
    except
      on E: Exception do
        raise Exception.Create('Erro ao consultar o ViaCEP: ' + E.Message);
    end;
  finally
    HttpClient.Free;
  end;
end;

class function THttpUtils.GetJSON(const URL: string): TJSONObject;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Response: string;
begin
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    HTTP.IOHandler := SSL;
    HTTP.Request.Accept := 'application/json';
    Response := HTTP.Get(URL);
    Result := TJSONObject.ParseJSONValue(Response) as TJSONObject;
  finally
    HTTP.Free;
    SSL.Free;
  end;

end;

end.
