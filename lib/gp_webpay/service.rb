module GpWebpay
  class Service
    def initialize(*)
    end

    class << self
      ruby2_keywords def call(*args)
        new(*args).call
      end
    end

    def call
    end
  end
end
