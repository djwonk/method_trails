require 'require_relative'
require_relative '../lib/method_trails'

class Example
  def self.run(name)
    rv = MethodTrails.new
    rv.input_filename  = "_input/#{name}.rb"
    rv.dot_filename    =   "_dot/#{name}.dot"
    rv.log_filename    =   "_log/#{name}.log"
    rv.s_exp_filename  = "_s-exp/#{name}.rb"
    rv.process
  end
end

Example::run("music")