[![CircleCI](https://circleci.com/gh/rodmatola/desafios-qa/tree/master.svg?style=svg)](https://circleci.com/gh/rodmatola/desafios-qa/tree/master)

# Idwall - Desafio de automação de testes de API

- [Enunciado do desafio "automação API"](https://github.com/rodmatola/desafios-qa/tree/master/qa-engineer-api/apis)
- [Enunciado do desafio "Plano para área de QA"](https://github.com/idwall/desafios-qa/blob/master/qa-engineer-api/planning)

## Configurações utilizadas
- Ruby 2.6.3
- Bundler 1.17.2

## Rodando localmente
- clone o repositório
- no terminal, vá até o diretório `/qa-engineer-api/apis/contrato`
- instale as dependências com `bundle install`
- siga as instruções contidas em "[Escondendo o token: Localmente como varável de ambiente (recomendado)](#ambienteLocal)"
  - alternativa: vá até o arquivo `/qa-engineer-api/apis/contrato/env.rb` e atribua seu token à varíavel `TOKEN`.

Na pasta existem 2 arquivos:
- `dados_invalidos.txt`: arquivo para colocar dados irreais, para validação de status "INVALID"
- `dados_validos.txt`: arquivo para colocar dados reais, para validação de status "VALID"

Para rodar, existem algumas alternativas de comando, dependendo da saída desejada:

Para dados válidos (padrão), digite:
```ruby
bundle exec rspec tests/* --order defined -fd
```
em que `--order defined` é para primeiro criar o relatório e depois consultá-lo. Esta opção executa os arquivos na ordem da pasta. O parâmetro `-fd` é para formatar a saída do terminal como um relatório de execução de testes. Sem esta opção a saída será somente "." (pontos)

Outras opções de formatação (acrescentar ao final do comando):
- --format RspecHtmlReporter: para gerar um relatório HTML localmente. Ficará na pasta `reports`
- --format RspecJunitFormatter --out [nome].xml: para saída no formato JUnit XML, utilizado em CIs

Para dados inválidos, acrescente `env=invalid` no início do comando:
```ruby
env=invalid bundle exec rspec tests/* --order defined -fd
```

Sugestão de implementação: fazer a consulta dos dados diretamente num banco.

## Rodando num CI
Este projeto está configurado para rodar no CircleCI, basta integrar o repositório e configurar a variável de ambiente IDWALL_TOKEN.

Configurações em `.circleci/config.yml`

Aqui uso o parâmetro adicional `--fail-fast`, para que o teste finalize assim que falhar, não rodando os seguintes.

Por padrão, está para rodar somente dados inválidos para não expor informações sensíveis. Para dados válidos, descomentar no yml e acrescentar em `dados_valido.txt` no formato `data,nome,cpf`.


## Escondendo o token
<a name="ambienteLocal"></a>

## Localmente como varável de ambiente (recomendado)
Caso rode os testes localmente ou num Mac Mini como servidor, você pode colocar o token como uma variável de ambiente, no `.bash_profile` ou no `.zshrc`. Abra uma das duas opções que use e acrescente o seguinte comando:
```
export IDWALL_TOKEN=[seu token]
```
No lugar de `IDWALL_TOKEN`, pode usar o nome que quiser.


## Localmente num arquivo em separado (evitar)
Pode-se colocar o token em um arquivo separado do seu repositório, ou no próprio repositório e adicioná-lo ao `.gitignore`.

A pesar de possível, não é recomendado que se faça isso pois levará a configurações adicionais e possíveis erros.

## CI
Num CI, deve-se ir até as configurações de variáveis de ambiente e definí-las.

## Validações implementadas

### Criar relatórios com sucesso (POST e GET)
Ao se criar um relatório com sucesso, expera-se que as seguintes condições sejam atendidas:
- status code seja 200
- que atendam ao contrato estabelecido no JSON Schema
- que o número do relatório criado seja igual ao do consultado
- que o nome da matriz criada seja igual a da consultada
- que o status inicial da consulta contenha "PROCESSANDO"

### Consultar relatórios com sucesso (GET)
Para a consulta de relatórios, a automação espera até que o status da consulta seja "CONCLUIDO", fazendo uma requisição a cada minuto até que o status seja alcançado. Outras validações:
- status code seja 200
- que atendam ao contrato estabelecido no JSON Schema
- que chave "resultado" tenha valor 'VALID', caso sejam usados dados válidos
- que chave "resultado" tenha valor 'INVALID', caso sejam usados dados inválidos


### Implementações futuras:
- rodar a consulta do relatório em paralelo
- O teste da criação de relatórios contém verificações mínimas para saber se foi criado com sucesso. Como esse teste já tem mais de uma responsabilidade, colocar outras verificações nos testes de consulta.
- regras para o status "EM ANALISE" e como a automação deve se comportar, pois pode ficar mais de um dia nesse status.



## Outras validações

### Ao obter status do relatório (GET /relatorios)
Alguma das condições abaixo é verdadeira? Se sim, podemos acrescentar esta validação (ou outra que seja verdadeira).
```
se
  "validado_manualmente": false,
então
  "validado_por": null
```
```
se
  "validado_manualmente": true,
então
  "validado_por": not_null
```

Além disso, assim como é pedido que o valor da chave `"resultado"` seja conferido, podemos adicionar validadções de outras chaves se necessário. Também os textos das mensagens, apesar de não ser boa prática.

### Status "EM ANALISE" (POST /relatorios)
Não sei as condições para a reprodução desse status, ou se é possível ou viável reproduzí-lo controladamente para testes automatizados.

### Status "PRE-PROCESSANDO" (POST /relatorios)
Apesar de não fazer parte do desafio, ao testar o endpoint com a sintaxe da documentação, retornou o seguinte erro:

## Postman

Uma _collection_ do Postman também consta no repositório. Esta _collection_ serve para fazer testes manuais na API. Costumo fazer exploratórios pelo Postaman para aprender o comportamento da API e conferir a documentação antes de automatizá-la.

## Inconsistências encontradas

Ver arquivo [INCONSISTENCIAS.md](https://github.com/rodmatola/desafios-qa/blob/master/qa-engineer-api/apis/contrato/INCONSISTENCIAS.md)
