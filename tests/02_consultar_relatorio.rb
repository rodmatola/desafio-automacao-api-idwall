require_relative '../env.rb'
require_relative '../requests/InfoRelatorioRequest'

JsonMatchers.schema_root = './schemas'

RSpec.describe 'Contrato da consulta de relatórios:' do

  it 'Consulta se foi concluido com sucesso' do

    puts "  Numero do relatório: #{$numero_relatorio}\n"

    info_relatorio = InfoRelatorioRequest.new($numero_relatorio, AMBIENTE)

    until info_relatorio.status == 'CONCLUIDO'
      info_relatorio = InfoRelatorioRequest.new($numero_relatorio, AMBIENTE)
      print '.'
      sleep(60)
    end

    expect(info_relatorio.response.code).to eq 200
    expect(info_relatorio.response).to match_response_schema('consultar_relatorio_processado_schema')

    if VALID
      expect(info_relatorio.resultado).to eq 'VALID'
    else
      expect(info_relatorio.resultado).to eq 'INVALID'
    end

  end

end
