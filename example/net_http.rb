require 'require_relative'
require_relative '../lib/ruby_graph'

class Example
  def self.run(name)
    rv = RubyGraph.new
    rv.input_filename  = "_input/#{name}" # omit the .rb
    rv.dot_filename    =   "_dot/#{name}.dot"
    rv.log_filename    =   "_log/#{name}.log"
    rv.s_exp_filename  = "_s-exp/#{name}.rb"
    rv.process
  end
end

Example::run("net_http")