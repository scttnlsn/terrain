module Terrain
  class Config
    attr_accessor :max_records

    def max_records
      @max_records || Float::INFINITY
    end
  end
end
