class CriarRelatoriosRequest

  def initialize(dados, ambiente)
    @endpoint = '/relatorios'

    @data_de_nascimento, @nome, @cpf_numero = dados
    @url, @token = ambiente

    @response = HTTParty.post(
      @url + @endpoint,
      headers: {
        'Authorization' => @token,
        'Content-Type' => 'application/json'
      },
      body: {
        "matriz" => "consultaPessoaDefault",
        "parametros" => {
            "cpf_data_de_nascimento" => @data_de_nascimento,
            "cpf_nome" => @nome,
            "cpf_numero" => @cpf_numero
        }
      }.to_json
    )

    @response_json = JSON.parse(@response.to_s)

    begin
      @matriz = 'consultaPessoaDefault'
      @numero = @response_json['result']['numero']
    rescue
      nil
    end
  end

  attr_reader :response

  attr_reader :matriz

  attr_reader :numero

end
