require_relative 'net'
require_relative 'mapper'
require 'bigdecimal/util'

module BandCampBX
  class Client
    attr_accessor :key
    attr_accessor :secret

    def initialize(key = nil, secret = nil)
      @key    = key
      @secret = secret
    end

    def balance
      mapper.map_balance(net.post("myfunds.php"))
    end

    def orders
      mapper.map_orders(net.post("myorders.php"))
    end

    def buy!(quantity, price, order_type)
      trade!("tradeenter.php", quantity, price, order_type)
    end

    def sell!(quantity, price, order_type)
      trade!("tradeenter.php", quantity, price, order_type)
    end

    def cancel(id, type)
      wrapping_standard_error do
        mapper.map_cancel(net.post("tradecancel.php", { id: id.to_s, type: type.to_s }))
      end
    end

    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end

    def trade!(endpoint, quantity, price, order_type)
      wrapping_standard_error do
        mapper.map_order(net.post(endpoint, { price: price.to_digits, quantity: quantity.to_digits, order_type: order_type.to_s }))
      end
    end

    def wrapping_standard_error &block
      begin
        yield
      rescue ::StandardError => e
        raise BandCampBX::StandardError.new(e.message)
      end
    end
  end
end
