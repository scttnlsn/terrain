module Terrain
  class Page
    class RangeError < StandardError; end

    RANGE_REGEX = /^(?<from>[0-9]*)-(?<to>[0-9]*)$/

    attr_reader :scope, :range

    def initialize(scope, range = nil)
      @scope = scope
      @range = range
    end

    def bounds
      @bounds ||= begin
        if range.present?
          if match
            raise RangeError if from > to
            [from, to]
          else
            raise RangeError
          end
        else
          [0, count - 1]
        end
      end
    end

    def count
      @count ||= scope.count
    end

    def records
      from, to = bounds
      limit = [to - from + 1, Terrain.config.max_records].min
      @records ||= scope.offset(from).limit(limit)
    end

    def content_range
      if count > 0
        from, to = bounds
        to = [to, from + records.count - 1].min
        "#{from}-#{to}/#{count}"
      else
        '*/0'
      end
    end

    private

    def match
      range.match(RANGE_REGEX)
    end

    def from
      match && match[:from].present? ? match[:from].to_i : 0
    end

    def to
      match && match[:to].present? ? match[:to].to_i : (count - 1)
    end
  end
end
