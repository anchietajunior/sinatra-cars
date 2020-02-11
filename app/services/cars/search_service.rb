require 'httparty'
require 'nokogiri'
require 'pry'

module Cars
  class SearchService < AppService
    def initialize(params)
      @params = params
      @cars = []
    end

    def call
      mount_cars
      Result.new(true, nil, cars)
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    private

    attr_accessor :params, :cars

    def mount_cars
      elements.each do |element|
        cars << { 
          description: formatted_description(element.css('a').text),
          year: formatted_year(element.css('a').text),
          details: "Some info",
          price: "Some price" 
        }
      end
    end

    def formatted_year text
      text.gsub(/[\t\n\r]+/, '').gsub!("Mais detalhes", "")[0..3]
    end

    def formatted_description text
      text.gsub(/[\t\n\r]+/, '').gsub!("Mais detalhes", "")[4..]
    end

    def elements
      parsed_page.css('div.veiculosEstoque')
    end

    def parsed_page
      unparsed_page = HTTParty.get("https://caldarelliveiculos.com.br/busca")
      Nokogiri::HTML(unparsed_page)
    end
  end
end