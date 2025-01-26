program Server;
{$APPTYPE GUI}





{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  WebModuleUnit in 'Modules\WebModuleUnit.pas' {WebModule1: TWebModule},
  ServerMethodsUnit in 'Modules\ServerMethodsUnit.pas' {DSServerModule1: TDSServerModule},
  AtualizaEnderecoThread in 'Negocios\AtualizaEnderecoThread.pas',
  EnderecoBusiness in 'Negocios\EnderecoBusiness.pas',
  PessoaBusiness in 'Negocios\PessoaBusiness.pas',
  DataModuleDatabase in 'Persistencia\DataModuleDatabase.pas' {dmDatabase: TDataModule},
  Endereco in 'Persistencia\Endereco.pas',
  EnderecoDAO in 'Persistencia\EnderecoDAO.pas',
  EnderecoIntegracao in 'Persistencia\EnderecoIntegracao.pas',
  Pessoa in 'Persistencia\Pessoa.pas',
  PessoaDAO in 'Persistencia\PessoaDAO.pas',
  EnderecoIntegracaoDAO in 'Persistencia\EnderecoIntegracaoDAO.pas',
  HttpUtils in 'Utils\HttpUtils.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.Run;
end.
