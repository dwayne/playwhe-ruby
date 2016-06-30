require "dry-configurable"

module PlayWhe
  class Settings
    extend Dry::Configurable

    setting :http do
      setting :read_timeout, 5
      setting :write_timeout, 5
      setting :connect_timeout, 5
    end

    setting :url, "http://nlcb.co.tt/app/index.php/pwresults/playwhemonthsum"
  end
end
