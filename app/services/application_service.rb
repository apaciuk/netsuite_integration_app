class ApplicationService::Base
    def self.call(*args, &block)
        new(*args, &block).call
    end
end
