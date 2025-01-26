program Client;

uses
  Vcl.Forms,
  HttpClientUtils in 'Utils\HttpClientUtils.pas',
  PessoaService in 'Services\PessoaService.pas',
  FrmTestePessoa in 'FrmTestePessoa.pas' {Form2},
  EnderecoService in 'Services\EnderecoService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
