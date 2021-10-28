module JSONApi
  class Deserializer
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    class Configuration
      attr_accessor :support_lids

      def initialize
        @support_lids = true
      end
    end
  end
end
