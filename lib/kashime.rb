require 'kashime/version'
require 'kashime/cli'

module Kashime
  RC_FILE = "~/.kashimerc"

  def self.init
    eval(File.read(File.expand_path(RC_FILE)))
  end
end

Kashime.init
