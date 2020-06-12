require 'httparty'
require 'rspec'
require 'json_matchers/rspec'
require 'json'
require 'pry-byebug'
require 'rspec_junit_formatter'
require 'rspec_html_reporter'

URL = 'https://api-v2.idwall.co'
TOKEN = "#{ENV['IDWALL_TOKEN']}"
AMBIENTE = [URL, TOKEN]

$tipo_dados = ENV["env"]
VALID = true
if $tipo_dados == 'invalid'

  ARQUIVO = 'dados_invalidos.txt'
  VALID = false

else

  ARQUIVO = 'dados_validos.txt'

end
