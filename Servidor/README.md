# Projeto DataSnap - Teste Técnico

## Descrição do Projeto

Este projeto foi desenvolvido como parte de um teste técnico utilizando o Delphi para criar um sistema de três camadas. O objetivo principal é gerenciar informações de pessoas e endereços, implementando boas práticas de desenvolvimento e utilizando recursos avançados da linguagem Delphi.

---

## Estrutura do Projeto

### Diretórios Principais:

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

### 1. **Camada de Persistência**
- **PessoaDAO**:
  - `Insert`: Inserir nova pessoa.
  - `Update`: Atualizar uma pessoa existente.
  - `Delete`: Remover uma pessoa pelo ID.
  - `GetById`: Buscar uma pessoa pelo ID.
  - `GetAll`: Listar todas as pessoas.

- **EnderecoDAO**:
  - `Insert`: Inserir novo endereço.
  - `Update`: Atualizar endereço existente.
  - `Delete`: Remover endereço pelo ID.
  - `GetAll`: Listar todos os endereços.
  - `ObterTodosEnderecos`: Retornar uma lista completa de endereços.

- **EnderecoIntegracaoDAO**:
  - `InserirOuAtualizarEnderecoIntegracao`: Atualizar ou inserir dados na tabela `endereco_integracao` com base em um endereço fornecido.

### 2. **Camada de Negócio (Business)**
- **PessoaBusiness**:
  - Regras de negócio para operações relacionadas à entidade `Pessoa`.

- **EnderecoService**:
  - Serviços para gerenciar e integrar informações de `Endereco` e `EnderecoIntegracao`.

### 3. **Camada de Apresentação (Servidor DataSnap)**
- Métodos REST disponíveis:
  - `ListarPessoas`: Retorna todas as pessoas em formato JSON.
  - `InserirPessoa`: Insere uma nova pessoa.
  - `ListarEnderecos`: Retorna todos os endereços em formato JSON.
  - `InserirEndereco`: Insere um novo endereço.
  - `InserirEnderecos`: Insere vários endereços em lote.

- **Thread para Atualização de Endereços**:
  - Classe `TAtualizaEnderecoThread`: Atualiza os dados de endereços na tabela `endereco_integracao` utilizando a API ViaCEP.

---

## Configuração do Ambiente

1. **Banco de Dados**:
   - Tipo: PostgreSQL
   - Configuração:
     ```
     Host: localhost
     Porta: 5432
     Database: Teste
     Usuário: postgres
     Senha: postgres
     ```
   - Estrutura:
     - Tabelas: `pessoa`, `endereco`, `endereco_integracao`

2. **Configuração do Servidor**:
   - Arquivo `DatabaseConfig.ini` para configuração do banco de dados.
   - Porta padrão para o servidor REST: `8081`

3. **Executáveis**:
   - O servidor será compilado e estará disponível na pasta `Servidor\Win32`.

---

## Como Executar

1. **Configurar o Banco de Dados**:
   - Certifique-se de que o PostgreSQL está instalado e configurado.
   - Execute os scripts de criação de tabela fornecidos no arquivo de especificações.

2. **Compilar o Servidor**:
   - Abra o projeto na IDE Delphi.
   - Compile o servidor na configuração **Win32 Debug**.

3. **Iniciar o Servidor**:
   - Execute o arquivo `Server.exe`.
   - Acesse os serviços REST via `http://localhost:8081/datasnap/rest`.

4. **Testar os Endpoints**:
   - Use o **Postman** ou outro cliente REST para testar os endpoints implementados.

---

## Próximos Passos

1. **Desenvolver Cliente REST**:
   - Criar uma aplicação cliente para consumir os serviços expostos.

2. **Implementar Testes Automatizados**:
   - Adicionar testes unitários e de integração para garantir a estabilidade do sistema.

3. **Documentação Completa**:
   - Detalhar todos os endpoints e exemplos de requisições no README.

4. **Validações Avançadas**:
   - Melhorar validações de dados e performance.

---

## Contato
Para dúvidas ou suporte, entre em contato pelo email: `maikryuge@gmail.com`.
