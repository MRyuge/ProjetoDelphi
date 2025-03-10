unit HttpClientUtils;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON;

type
  THttpClientUtils = class
  private

  public
    FBaseUrl: string;
    class function GetBaseUrl: string;
    class function Get(const URL: string): TJSONValue; static;
    class function Post(const URL: string; const Body: TJSONObject): TJSONValue;
      overload; static;

    class function Post(const URL: string; const Body: TJSONArray)
      : TJSONValue; overload; static;

    class function Put(const URL: string; const Body: TJSONObject)
      : TJSONValue; static;

    class function Delete(const URL: string): TJSONValue; static;
    class function ConsultarCEP(const CEP: string): TJSONObject; static;

    constructor Create;
  end;

implementation

uses
  IniFiles;

constructor THttpClientUtils.Create;
var
  IniFilePath: string;
  IniFile: TIniFile;
begin
  // Ajuste o caminho para encontrar o arquivo no local correto
  IniFilePath := ExtractFilePath(ParamStr(0)) + '..\..\Config\AppConfig.ini';
  // Caminho relativo

  // Verifica se o arquivo INI existe
  if not FileExists(IniFilePath) then
    raise Exception.Create('Arquivo AppConfig.ini n�o encontrado em: ' +
      IniFilePath);

  // L� o arquivo INI
  IniFile := TIniFile.Create(IniFilePath);
  try
    FBaseUrl := IniFile.ReadString('Server', 'BaseUrl', '');
    if FBaseUrl.Trim.IsEmpty then
      raise Exception.Create
        ('A URL do servidor n�o foi configurada no arquivo AppConfig.ini.');
  finally
    IniFile.Free;
  end;
end;

class function THttpClientUtils.ConsultarCEP(const CEP: string): TJSONObject;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  ResponseString: string;
  URL: string;
begin
  Result := nil;
  HttpClient := THTTPClient.Create;
  try
    try
      // Monta a URL para a consulta do CEP
      URL := Format('https://viacep.com.br/ws/%s/json/', [CEP]);

      // Configura o cliente HTTP
      HttpClient.ContentType := 'application/json';

      // Realiza a requisi��o GET
      Response := HttpClient.Get(URL);

      // Verifica se a resposta foi bem-sucedida
      if Response.StatusCode = 200 then
      begin
        ResponseString := Response.ContentAsString;

        // Converte a resposta em TJSONObject
        Result := TJSONObject.ParseJSONValue(ResponseString) as TJSONObject;

        // Verifica se o JSON � v�lido
        if not Assigned(Result) then
          raise Exception.Create('Resposta do servidor n�o � um JSON v�lido.');
      end
      else
        raise Exception.Create
          (Format('Erro na requisi��o. C�digo HTTP: %d. Mensagem: %s',
          [Response.StatusCode, Response.StatusText]));
    except
      on E: Exception do
        raise Exception.Create('Erro ao consultar o CEP: ' + E.Message);
    end;
  finally
    HttpClient.Free;
  end;
end;

class function THttpClientUtils.GetBaseUrl: string;
var
  IniFile: TIniFile;
  IniFilePath: string;
begin
  // Ajusta para sempre procurar a pasta Config no diret�rio do projeto
  IniFilePath := ExtractFilePath(ParamStr(0)) + '..\..\Config\AppConfig.ini';

  // Verifica se o arquivo INI existe
  if not FileExists(IniFilePath) then
    raise Exception.Create('Arquivo AppConfig.ini n�o encontrado em: ' +
      IniFilePath);

  IniFile := TIniFile.Create(IniFilePath);
  try
    Result := IniFile.ReadString('Server', 'BaseUrl', '');
    if Result.IsEmpty then
      raise Exception.Create('BaseUrl n�o configurado no AppConfig.ini');
  finally
    IniFile.Free;
  end;
end;

class function THttpClientUtils.Get(const URL: string): TJSONValue;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  ResponseString: string;
begin
  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    // Configura o SSLHandler para TLS 1.2
    SSLHandler.SSLOptions.Method := sslvTLSv1_2;
    SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSLHandler;

    // Configura o cabe�alho da requisi��o
    HTTP.Request.ContentType := 'application/json';

    // Realiza a requisi��o GET
    ResponseString := HTTP.Get(URL);

    // Verifica se a resposta n�o est� vazia
    if ResponseString.Trim.IsEmpty then
      raise Exception.Create('Resposta vazia recebida do servidor.');

    // Converte a resposta para JSON
    Result := TJSONObject.ParseJSONValue(ResponseString);
    if not Assigned(Result) then
      raise Exception.Create('Falha ao converter a resposta para JSON.');
  finally
    HTTP.Free;
    SSLHandler.Free;
  end;
end;

class function THttpClientUtils.Post(const URL: string; const Body: TJSONArray)
  : TJSONValue;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestBody: TStringStream;
  ResponseString: string;
begin
  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RequestBody := TStringStream.Create(Body.ToString, TEncoding.UTF8);
  try
    HTTP.IOHandler := SSLHandler;
    HTTP.Request.ContentType := 'application/json';

    // Realiza a requisi��o POST
    ResponseString := HTTP.Post(URL, RequestBody);

    // Converte a resposta em TJSONValue
    Result := TJSONObject.ParseJSONValue(ResponseString);
  finally
    HTTP.Free;
    SSLHandler.Free;
    RequestBody.Free;
  end;
end;

class function THttpClientUtils.Post(const URL: string; const Body: TJSONObject)
  : TJSONValue;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestBody: TStringStream;
  ResponseString: string;
begin
  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RequestBody := TStringStream.Create(Body.ToString, TEncoding.UTF8);
  try
    HTTP.IOHandler := SSLHandler;
    HTTP.Request.ContentType := 'application/json';

    // Realiza a requisi��o POST
    ResponseString := HTTP.Post(URL, RequestBody);

    // Converte a resposta em TJSONValue
    Result := TJSONObject.ParseJSONValue(ResponseString);
  finally
    HTTP.Free;
    SSLHandler.Free;
    RequestBody.Free;
  end;
end;

class function THttpClientUtils.Put(const URL: string; const Body: TJSONObject)
  : TJSONValue;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestBody: TStringStream;
  ResponseString: string;
begin
  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RequestBody := TStringStream.Create(Body.ToString, TEncoding.UTF8);
  try
    HTTP.IOHandler := SSLHandler;
    HTTP.Request.ContentType := 'application/json';

    // Realiza a requisi��o PUT
    ResponseString := HTTP.Put(URL, RequestBody);

    // Converte a resposta em TJSONValue
    Result := TJSONObject.ParseJSONValue(ResponseString);
  finally
    HTTP.Free;
    SSLHandler.Free;
    RequestBody.Free;
  end;
end;

class function THttpClientUtils.Delete(const URL: string): TJSONValue;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  ResponseString: string;
begin
  HttpClient := THTTPClient.Create;
  try
    // Configura o tipo de conte�do para a requisi��o
    HttpClient.ContentType := 'application/json';

    // Envia a requisi��o DELETE
    try
      Response := HttpClient.Delete(URL); // Envia a requisi��o DELETE
      ResponseString := Response.ContentAsString;
      // Obt�m a resposta como string

      // Verifica se a resposta n�o est� vazia
      if ResponseString.Trim.IsEmpty then
        raise Exception.Create('Resposta vazia recebida do servidor.');

      // Converte a resposta em TJSONValue
      Result := TJSONObject.ParseJSONValue(ResponseString);

      // Verifica se a resposta � um JSON v�lido
      if not Assigned(Result) then
        raise Exception.Create('Resposta n�o � um JSON v�lido.');

    except
      on E: Exception do
        raise Exception.Create('Erro ao realizar requisi��o DELETE: ' +
          E.Message);
    end;

  finally
    HttpClient.Free;
  end;
end;

end.
