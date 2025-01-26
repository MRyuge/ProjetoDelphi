# Servidor do Sistema de Gerenciamento

## Descrição do Projeto

Este projeto é o **Servidor** de um sistema de gerenciamento desenvolvido utilizando Delphi e DataSnap, com suporte a funcionalidades REST para gerenciar informações de pessoas e endereços. O servidor utiliza práticas modernas de desenvolvimento e é organizado em camadas.

---

## Estrutura do Projeto

### Diretórios Principais:


markdown
Copiar
Editar

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
  - `GetById`: Buscar um endereço pelo ID.
  - `GetAll`: Listar todos os endereços.

- **EnderecoIntegracaoDAO**:
  - `GetByIdEndereco`: Buscar dados de integração de endereço por ID.
  - `InserirOuAtualizar`: Atualizar ou inserir dados na tabela `endereco_integracao`.

### 2. **Camada de Negócio (Business)**
- **PessoaBusiness**:
  - Implementa regras de negócio relacionadas à entidade `Pessoa`.

- **EnderecoService**:
  - Gerencia serviços relacionados às entidades `Endereco` e `EnderecoIntegracao`.

### 3. **Camada de Apresentação**
- **Endpoints REST Disponíveis**:
  - **Pessoa**:
    - `updatePessoa`: Insere ou atualiza uma pessoa.
    - `acceptPessoa`: Atualiza uma pessoa existente.
    - `cancelPessoa`: Remove uma pessoa pelo ID.
    - `ListarPessoas`: Lista todas as pessoas.
    - `updatePessoaEmLote`: Atualiza várias pessoas em lote.
    - `BuscarPessoa`: Busca uma pessoa pelo ID.
  - **Endereço**:
    - `updateEndereco`: Insere ou atualiza um endereço.
    - `acceptEndereco`: Atualiza um endereço existente.
    - `cancelEndereco`: Remove um endereço pelo ID.
    - `ListarEnderecos`: Lista todos os endereços.
    - `BuscarEndereco`: Busca um endereço pelo ID.
    - `BuscarEnderecoIntegracao`: Busca os dados de integração de um endereço.
  - **Serviços Gerais**:
    - `AtualizarIntegracaoViaCep`: Atualiza dados de endereços usando a API ViaCEP.

---

## Configuração do Ambiente

### Banco de Dados:
- **Tipo**: PostgreSQL
- **Configuração**:
Host: localhost Porta: 5432 Database: Teste Usuário: postgres Senha: postgres

markdown
Copiar
Editar
- **Tabelas**:
- `pessoa`
- `endereco`
- `endereco_integracao`

### Configuração do Servidor:
- **Arquivo de Configuração**: `Config\DatabaseConfig.ini`
- **Porta Padrão**: `8081`

---

## Como Executar

1. **Configurar o Banco de Dados**:
 - Certifique-se de que o PostgreSQL está instalado e configurado.
 - Execute os scripts de criação de tabelas.

2. **Compilar o Servidor**:
 - Abra o projeto na IDE Delphi.
 - Compile o servidor na configuração **Win32 Debug**.

3. **Iniciar o Servidor**:
 - Execute o arquivo `Server.exe`.
 - Acesse os serviços REST via `http://localhost:8081/datasnap/rest`.

4. **Testar os Endpoints**:
 - Utilize ferramentas como **Postman** ou **Insomnia** para testar os endpoints REST.

---

## Próximos Passos

- **Desenvolver Testes Automatizados**:
- Implementar testes unitários e de integração.

- **Melhorar Documentação**:
- Adicionar exemplos detalhados de requisições e respostas.

- **Aprimorar Integrações**:
- Explorar novas APIs para validações e enriquecimento de dados.

---

## Contato

Para dúvidas ou suporte, entre em contato pelo email: `maikryuge@gmail.com`.
