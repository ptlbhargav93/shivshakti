require 'paperclip/media_type_spoof_detector'

Paperclip.options[:command_path] = "/usr/local/bin/identify"

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end