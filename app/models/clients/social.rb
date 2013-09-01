module Clients
  module Social
    CLIENT_KLASSES = [TwitterClients, Facebook, Google, InstagrAm]
    CLIENT_KLASSES_MAP = CLIENT_KLASSES.inject({}){|hash, klass|
      hash[klass::PROVIDER.to_sym] = klass
      hash
    }.freeze

    def self.find_class provider
      CLIENT_KLASSES_MAP[provider.to_sym]
    end
  end
end
