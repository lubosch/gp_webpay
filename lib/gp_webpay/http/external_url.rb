module GpWebpay
  module Http
    class ExternalUrl
      attr_accessor :url, :full_url, :params

      def initialize(url:, full_url:, params:)
        @url = url
        @full_url = full_url
        @params = params
      end
    end
  end
end
