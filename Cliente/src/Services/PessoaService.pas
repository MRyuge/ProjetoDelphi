unit PessoaService;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  HttpClientUtils, System.DateUtils, System.Net.HttpClient;

type
  TPessoaService = class
  private
    FBaseUrl: string;
    procedure LogMensagem(Memo: TMemo; const Msg: string);

  public
    constructor Create;
    function AtualizarPessoa(AIdPessoa, AFlNatureza: Integer;
      const ADsDocumento, ANmPrimeiro, ANmSegundo: string;
      ADtRegistro: TDateTime): Boolean;
    function ExcluirPessoa(IdPessoa: Int64): Boolean;
    function BuscarPessoa(IdPessoa: Int64): TJSONObject;

    function InserirPessoa(FlNatureza: Integer;
      DsDocumento, NmPrimeiro, NmSegundo: string;
      DtRegistro: TDateTime): Boolean;
    function ListarPessoas(Memo: TMemo): TJSONArray;

    function UpdatePessoaEmLote(const JSON: TJSONArray): Boolean;

  end;

implementation

constructor TPessoaService.Create;
begin
  FBaseUrl := THttpClientUtils.GetBaseUrl; // L� a URL do AppConfig.ini
end;

function TPessoaService.InserirPessoa(FlNatureza: Integer;
  DsDocumento, NmPrimeiro, NmSegundo: string; DtRegistro: TDateTime): Boolean;
var
  JSONBody: TJSONObject;
  Response: TJSONValue;
  JsonObj: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := False; // Inicializa como falso
  JSONBody := TJSONObject.Create;

  try
    // Monta o corpo JSON da requisi��o
    JSONBody.AddPair('FlNatureza', TJSONNumber.Create(FlNatureza));
    JSONBody.AddPair('DsDocumento', DsDocumento);
    JSONBody.AddPair('NmPrimeiro', NmPrimeiro);
    JSONBody.AddPair('NmSegundo', NmSegundo);
    JSONBody.AddPair('DtRegistro', DateToISO8601(DtRegistro));

    try
      // Realiza a requisi��o POST usando o HttpClientUtils
      Response := THttpClientUtils.Post(FBaseUrl + '/Pessoa', JSONBody);

      // Verifica se a resposta foi recebida e � v�lida
      if Assigned(Response) and (Response is TJSONObject) then
      begin
        JsonObj := TJSONObject(Response);

        // Verifica se a chave "result" existe no JSON e se � um array
        if JsonObj.TryGetValue<TJSONArray>('result', ResultArray) then
        begin
          // Verifica se o primeiro elemento do array � verdadeiro
          if (ResultArray.Count > 0) and (ResultArray.Items[0].Value = 'true')
          then
            Result := True
          else
            raise Exception.Create
              ('Erro ao inserir pessoa: opera��o n�o foi bem-sucedida.');
        end
        else
          raise Exception.Create
            ('Erro ao inserir pessoa: chave "result" n�o encontrada ou inv�lida.');
      end
      else
        raise Exception.Create
          ('Erro ao inserir pessoa: resposta inv�lida do servidor.');

    finally
      // Libera o JSON da mem�ria ap�s o uso
      JSONBody.Free;
      if Assigned(Response) then
        Response.Free;
    end;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao inserir pessoa: ' + E.Message);
    end;
  end;
end;

function TPessoaService.AtualizarPessoa(AIdPessoa, AFlNatureza: Integer;
  const ADsDocumento, ANmPrimeiro, ANmSegundo: string;
  ADtRegistro: TDateTime): Boolean;
var
  JSONBody: TJSONObject;
  Response: TJSONValue;
  JsonObj: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := False; // Inicializa como falso
  JSONBody := TJSONObject.Create;

  try
    // Monta o corpo JSON da requisi��o
    JSONBody.AddPair('IdPessoa', TJSONNumber.Create(AIdPessoa));
    JSONBody.AddPair('FlNatureza', TJSONNumber.Create(AFlNatureza));
    JSONBody.AddPair('DsDocumento', ADsDocumento);
    JSONBody.AddPair('NmPrimeiro', ANmPrimeiro);
    JSONBody.AddPair('NmSegundo', ANmSegundo);
    JSONBody.AddPair('DtRegistro', DateToISO8601(ADtRegistro));

    try
      // Realiza a requisi��o PUT usando o HttpClientUtils
      Response := THttpClientUtils.Put(FBaseUrl + '/Pessoa', JSONBody);

      // Verifica se a resposta foi recebida e � v�lida
      if Assigned(Response) and (Response is TJSONObject) then
      begin
        JsonObj := TJSONObject(Response);

        // Verifica se a chave "result" existe no JSON e se � um array
        if JsonObj.TryGetValue<TJSONArray>('result', ResultArray) then
        begin
          // Verifica se o primeiro elemento do array � verdadeiro
          if (ResultArray.Count > 0) and (ResultArray.Items[0].Value = 'true')
          then
            Result := True
          else
            raise Exception.Create
              ('Erro ao atualizar pessoa: opera��o n�o foi bem-sucedida.');
        end
        else
          raise Exception.Create
            ('Erro ao atualizar pessoa: chave "result" n�o encontrada ou inv�lida.');
      end
      else
        raise Exception.Create
          ('Erro ao atualizar pessoa: resposta inv�lida do servidor.');

    finally
      // Libera o JSON da mem�ria ap�s o uso
      JSONBody.Free;
      if Assigned(Response) then
        Response.Free;
    end;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao atualizar pessoa: ' + E.Message);
    end;
  end;
end;

function TPessoaService.ExcluirPessoa(IdPessoa: Int64): Boolean;
var
  URL: string;
  ResponseJson: TJSONValue;
  JsonObj: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := False; // Inicializa como falso por padr�o

  try
    // Monta a URL para a requisi��o DELETE
    URL := FBaseUrl + '/pessoa/' + IdPessoa.ToString;

    // Realiza a requisi��o DELETE e obt�m a resposta em formato JSON
    ResponseJson := THttpClientUtils.Delete(URL);

    try
      // Verifica se a resposta � um objeto JSON v�lido
      if not(ResponseJson is TJSONObject) then
        raise Exception.Create
          ('A resposta do servidor n�o � um objeto JSON v�lido.');

      // Faz o cast expl�cito para TJSONObject
      JsonObj := TJSONObject(ResponseJson);

      // Verifica se existe a chave "result" e se ela � uma TJSONArray
      if JsonObj.TryGetValue<TJSONArray>('result', ResultArray) then
      begin
        // Verifica se o primeiro elemento da lista � um valor booleano e � "true"
        if (ResultArray.Count > 0) and (ResultArray.Items[0].Value = 'true')
        then
        begin
          Result := True; // Exclus�o bem-sucedida
        end
        else
        begin
          raise Exception.Create('A opera��o falhou. O servidor retornou: ' +
            ResultArray.ToString);
        end;
      end
      else
        raise Exception.Create
          ('A chave "result" n�o foi encontrada ou n�o � v�lida na resposta do servidor.');

    finally
      // Libera o JSON da mem�ria ap�s o uso
      ResponseJson.Free;
    end;

  except
    on E: Exception do
    begin
      // Lan�a uma exce��o com detalhes do erro
      raise Exception.Create('Erro ao excluir pessoa: ' + E.Message);
    end;
  end;
end;

function TPessoaService.BuscarPessoa(IdPessoa: Int64): TJSONObject;
var
  Response: TJSONValue;
begin
  Response := THttpClientUtils.Get(FBaseUrl + '/BuscarPessoa/' +
    IdPessoa.ToString);
  try
    if Assigned(Response) and (Response is TJSONObject) then
      Result := TJSONObject(Response.Clone)
    else
      raise Exception.Create('Erro ao buscar pessoa: resposta inv�lida.');
  finally
    Response.Free;
  end;
end;

function TPessoaService.ListarPessoas(Memo: TMemo): TJSONArray;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  ResponseString: string;
  ResponseJSONObject: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := nil;
  HttpClient := THTTPClient.Create;
  try
    // Realiza a requisi��o GET
    Response := HttpClient.Get(FBaseUrl + '/ListarPessoas');

    // Verifica se a resposta foi bem-sucedida
    if Response.StatusCode = 200 then
    begin
      // Converte a resposta para TJSONObject
      ResponseString := Response.ContentAsString;
      LogMensagem(Memo, 'Resposta recebida: ' + ResponseString);

      // Verifica se a resposta � um TJSONObject
      ResponseJSONObject := TJSONObject.ParseJSONValue(ResponseString)
        as TJSONObject;
      if Assigned(ResponseJSONObject) then
      begin
        // Tenta extrair o array de pessoas que pode estar no campo 'result'
        if ResponseJSONObject.TryGetValue<TJSONArray>('result', ResultArray)
        then
        begin
          // Exibe a resposta no Memo para depura��o
          LogMensagem(Memo, 'Campo "result" encontrado no TJSONObject');
          Result := ResultArray; // Retorna o array de pessoas
        end
        else
        begin
          // Se o campo 'result' n�o for encontrado, exibe os campos presentes no TJSONObject
          LogMensagem(Memo, 'Campos no TJSONObject: ' +
            ResponseJSONObject.ToString);
          raise Exception.Create('Campo "result" n�o encontrado na resposta.');
        end;
      end
      else
      begin
        raise Exception.Create('Resposta n�o � um TJSONObject v�lido.');
      end;
    end
    else
      raise Exception.Create('Erro ao listar pessoas: ' + Response.StatusText);
  finally
    HttpClient.Free;
  end;
end;

function TPessoaService.UpdatePessoaEmLote(const JSON: TJSONArray): Boolean;
var
  Response: TJSONValue;
  JSONResponse: TJSONObject;
  ResultArray: TJSONArray;
begin
  Result := False; // Inicializa como falso

  try
    // Realiza a requisi��o POST para atualizar pessoas em lote
    Response := THttpClientUtils.Post(FBaseUrl + '/PessoaEmLote', JSON);

    try
      // Verifica se a resposta foi retornada
      if Assigned(Response) and (Response is TJSONObject) then
      begin
        JSONResponse := TJSONObject(Response);

        // Verifica se o campo "result" existe e � um array
        if JSONResponse.TryGetValue<TJSONArray>('result', ResultArray) then
        begin
          // Verifica se o array cont�m pelo menos um valor booleano "true"
          if (ResultArray.Count > 0) and (ResultArray.Items[0] is TJSONBool)
          then
            Result := TJSONBool(ResultArray.Items[0]).AsBoolean;
        end
        else
          raise Exception.Create('Campo "result" n�o encontrado na resposta.');
      end
      else
        raise Exception.Create('Resposta da API n�o � um objeto JSON v�lido.');
    finally
      Response.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao atualizar pessoas em lote: ' + E.Message);
  end;
end;

procedure TPessoaService.LogMensagem(Memo: TMemo; const Msg: string);
begin
  Memo.Lines.Add(Msg); // Adiciona a mensagem ao Memo
end;

end.
