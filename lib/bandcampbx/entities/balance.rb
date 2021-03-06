require_relative './base'

module BandCampBX
  module Entities
    class Balance < Base
      def self.mappings
        {
          usd_balance: map_decimal,
          btc_balance: map_decimal,
          usd_reserved: map_decimal,
          btc_reserved: map_decimal,
          usd_available: map_decimal,
          btc_available: map_decimal,
          fee: map_decimal
        }
      end

      setup_readers
    end
  end
end
