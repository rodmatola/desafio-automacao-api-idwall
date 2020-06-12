class InfoRelatorioRequest

  def initialize(numero, ambiente)
    @endpoint = '/relatorios'

    @numero = numero
    @url, @token = ambiente

    @response = HTTParty.get(
      @url + @endpoint + "/#{@numero}",
      headers: {
        'Authorization' => @token,
        'Content-Type' => 'application/json'
      }
    )

    @response_json = JSON.parse(@response.to_s)

    begin
      @numero = @response_json['result']['numero']
      @status = @response_json['result']['status']
      @nome = @response_json['result']['nome']
      @resultado = @response_json['result']['resultado']
    rescue
      nil
    end
  end

  attr_reader :response

  attr_reader :numero

  attr_reader :status

  attr_reader :nome

  attr_reader :resultado

end
