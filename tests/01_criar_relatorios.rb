require_relative '../env.rb'
require_relative '../requests/CriarRelatoriosRequest'
require_relative '../requests/InfoRelatorioRequest'

JsonMatchers.schema_root = './schemas'

RSpec.describe 'Contrato da geração de relatórios:' do

  dados_cliente = File.readlines(ARQUIVO)

  dados_cliente.sample(1).each do |dados|

    puts "#\n# Dados testados: #{dados}#"

    it 'Criado com sucesso' do

      relatorio = CriarRelatoriosRequest.new(dados.chomp.split(','), AMBIENTE)
      info_relatorio = InfoRelatorioRequest.new(relatorio.numero, AMBIENTE)

      expect(relatorio.response.code).to eq 200
      expect(relatorio.response).to match_response_schema('criar_relatorio_sucesso_schema')

      expect(info_relatorio.response.code).to eq 200
      expect(info_relatorio.response).to match_response_schema('consultar_relatorio_processando_schema')

      expect(relatorio.numero).to eq info_relatorio.numero
      expect(relatorio.matriz).to eq info_relatorio.nome
      expect(info_relatorio.status).to include('PROCESSANDO')

      $numero_relatorio = relatorio.numero

    end

    it 'Erro por falta de dados' do

      relatorio = CriarRelatoriosRequest.new('', AMBIENTE)

      expect(relatorio.response.code).to eq 400
      expect(relatorio.response).to match_response_schema('criar_relatorio_falta_dados_schema')

    end

  end

end
