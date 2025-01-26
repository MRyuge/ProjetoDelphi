# Projeto DataSnap - Teste T�cnico

## Descri��o do Projeto

Este projeto foi desenvolvido como parte de um teste t�cnico utilizando o Delphi para criar um sistema de tr�s camadas. O objetivo principal � gerenciar informa��es de pessoas e endere�os, implementando boas pr�ticas de desenvolvimento e utilizando recursos avan�ados da linguagem Delphi.

---

## Estrutura do Projeto

### Diret�rios Principais:

```
C:\TesteDelphi\
?
??? Apresentacao (Client REST - Em Desenvolvimento)
?
??? Servidor (Servidor DataSnap)
?   ??? Business
?   ?   ??? PessoaBusiness.pas
?   ?   ??? EnderecoService.pas
?   ??? Modules
?   ?   ??? ServerMethodsUnit.pas
?   ?   ??? WebModuleUnit.pas
?   ??? Persistence
?   ?   ??? PessoaDAO.pas
?   ?   ??? EnderecoDAO.pas
?   ?   ??? EnderecoIntegracaoDAO.pas
?   ?   ??? DataModuleDatabase.pas
?   ??? Utils
?   ?   ??? HttpUtils.pas
?   ?   ??? JsonUtils.pas
?   ??? Threads
?       ??? AtualizaEnderecoThread.pas
?
??? Config
?   ??? DatabaseConfig.ini
?
??? Models
?   ??? Pessoa.pas
?   ??? Endereco.pas
?   ??? EnderecoIntegracao.pas
?
??? Assets
    ??? CSS
    ??? JS
    ??? Templates
```

---

## Funcionalidades Implementadas

### 1. **Camada de Persist�ncia**
- **PessoaDAO**:
  - `Insert`: Inserir nova pessoa.
  - `Update`: Atualizar uma pessoa existente.
  - `Delete`: Remover uma pessoa pelo ID.
  - `GetById`: Buscar uma pessoa pelo ID.
  - `GetAll`: Listar todas as pessoas.

- **EnderecoDAO**:
  - `Insert`: Inserir novo endere�o.
  - `Update`: Atualizar endere�o existente.
  - `Delete`: Remover endere�o pelo ID.
  - `GetAll`: Listar todos os endere�os.
  - `ObterTodosEnderecos`: Retornar uma lista completa de endere�os.

- **EnderecoIntegracaoDAO**:
  - `InserirOuAtualizarEnderecoIntegracao`: Atualizar ou inserir dados na tabela `endereco_integracao` com base em um endere�o fornecido.

### 2. **Camada de Neg�cio (Business)**
- **PessoaBusiness**:
  - Regras de neg�cio para opera��es relacionadas � entidade `Pessoa`.

- **EnderecoService**:
  - Servi�os para gerenciar e integrar informa��es de `Endereco` e `EnderecoIntegracao`.

### 3. **Camada de Apresenta��o (Servidor DataSnap)**
- M�todos REST dispon�veis:
  - `ListarPessoas`: Retorna todas as pessoas em formato JSON.
  - `InserirPessoa`: Insere uma nova pessoa.
  - `ListarEnderecos`: Retorna todos os endere�os em formato JSON.
  - `InserirEndereco`: Insere um novo endere�o.
  - `InserirEnderecos`: Insere v�rios endere�os em lote.

- **Thread para Atualiza��o de Endere�os**:
  - Classe `TAtualizaEnderecoThread`: Atualiza os dados de endere�os na tabela `endereco_integracao` utilizando a API ViaCEP.

---

## Configura��o do Ambiente

1. **Banco de Dados**:
   - Tipo: PostgreSQL
   - Configura��o:
     ```
     Host: localhost
     Porta: 5432
     Database: Teste
     Usu�rio: postgres
     Senha: postgres
     ```
   - Estrutura:
     - Tabelas: `pessoa`, `endereco`, `endereco_integracao`

2. **Configura��o do Servidor**:
   - Arquivo `DatabaseConfig.ini` para configura��o do banco de dados.
   - Porta padr�o para o servidor REST: `8081`

3. **Execut�veis**:
   - O servidor ser� compilado e estar� dispon�vel na pasta `Servidor\Win32`.

---

## Como Executar

1. **Configurar o Banco de Dados**:
   - Certifique-se de que o PostgreSQL est� instalado e configurado.
   - Execute os scripts de cria��o de tabela fornecidos no arquivo de especifica��es.

2. **Compilar o Servidor**:
   - Abra o projeto na IDE Delphi.
   - Compile o servidor na configura��o **Win32 Debug**.

3. **Iniciar o Servidor**:
   - Execute o arquivo `Server.exe`.
   - Acesse os servi�os REST via `http://localhost:8081/datasnap/rest`.

4. **Testar os Endpoints**:
   - Use o **Postman** ou outro cliente REST para testar os endpoints implementados.

---

## Pr�ximos Passos

1. **Desenvolver Cliente REST**:
   - Criar uma aplica��o cliente para consumir os servi�os expostos.

2. **Implementar Testes Automatizados**:
   - Adicionar testes unit�rios e de integra��o para garantir a estabilidade do sistema.

3. **Documenta��o Completa**:
   - Detalhar todos os endpoints e exemplos de requisi��es no README.

4. **Valida��es Avan�adas**:
   - Melhorar valida��es de dados e performance.

---

## Contato
Para d�vidas ou suporte, entre em contato pelo email: `maikryuge@gmail.com`.
