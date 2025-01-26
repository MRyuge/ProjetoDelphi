# Cliente do Sistema de Gerenciamento

Este é o cliente do sistema de gerenciamento desenvolvido em Delphi. Ele se comunica com o servidor para realizar operações como gerenciamento de pessoas e endereços.

## Funcionalidades

- Listar, visualizar, editar e excluir registros de pessoas.
- Listar, visualizar, editar e excluir registros de endereços.
- Integração com a API ViaCEP para buscar dados de endereço.
- Atualização em lote de pessoas.
- Interface gráfica com componentes intuitivos.

## Requisitos

- Windows (32-bit ou 64-bit)
- **Delphi Rio 10.3** ou superior (se for necessário compilar o código-fonte)
- API do servidor configurada e rodando (veja o repositório do servidor para detalhes)
- Dependências:
  - OpenSSL (se a aplicação usar `IdHTTP` com HTTPS)
  - Certifique-se de que as bibliotecas necessárias estão na pasta do executável (`libssl-1_1.dll` e `libcrypto-1_1.dll`)

## Estrutura do Projeto

```plaintext
client/
├── src/         # Código-fonte do cliente
├── bin/         # Executáveis e dependências do cliente
├── docs/        # Documentação específica do cliente
├── .gitignore   # Ignorar arquivos gerados pelo Delphi
└── README.md    # Documentação do cliente
Como Configurar
Baixar o Repositório

bash
Copiar
Editar
git clone https://github.com/MRyuge/ProjetoDelphi
cd client
Dependências

Certifique-se de que as bibliotecas OpenSSL estão disponíveis no sistema ou na pasta bin/.
Configuração do Servidor

Configure o servidor de acordo com as instruções no README do Servidor.
Atualize o arquivo de configuração do cliente (config.ini) com o URL do servidor.
Exemplo de config.ini:

ini
Copiar
Editar
[Server]
BaseUrl=http://localhost:8080
Executar o Cliente

Navegue até a pasta bin/ e execute o arquivo Cliente.exe.
Como Usar
Gerenciamento de Pessoas

Listar: Navegue até a aba "Pessoas" e clique em "Listar".
Editar: Selecione uma pessoa e clique em "Editar".
Excluir: Selecione uma pessoa e clique em "Excluir".
Gerenciamento de Endereços

Listar: Navegue até a aba "Endereços" e clique em "Listar".
Visualizar: Clique em um endereço para exibir os detalhes no campo dedicado.
Atualizar ViaCEP: Clique no botão "Atualizar Endereços" para integrar com a API ViaCEP.
Atualização em Lote

Use o botão "Atualizar em Lote" para carregar um arquivo JSON com os dados.
Contribuição
Contribuições são bem-vindas! Siga os passos abaixo:

Faça um fork do repositório.
Crie uma branch para sua feature:
bash
Copiar
Editar
git checkout -b minha-feature
Commit suas mudanças:
bash
Copiar
Editar
git commit -m 'Adicionei minha feature'
Faça o push para sua branch:
bash
Copiar
Editar
git push origin minha-feature
Crie um Pull Request.
Licença
Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.

Nota: Certifique-se de que o servidor está ativo antes de iniciar o cliente para evitar erros de conexão.

markdown
Copiar
Editar

### Como adaptar
- Substitua os links do repositório por URLs reais.
- Personalize informações como requisitos específicos ou dependências adicionais.
- Ajuste o texto para refletir qualquer funcionalidade extra ou mudanças no comportamento
