require 'require_relative'
require_relative '/method_trails/file_handling'
require_relative '/method_trails/method_calls'
require_relative '/method_trails/parser'

class MethodTrails

  attr_accessor :input_filename
  attr_accessor :dot_filename
  attr_accessor :s_exp_filename
  
  # Reads Ruby file from +input_filename+.  Parses and processes the file.
  # Saves results to +dot_filename+ in GraphViz format.
  def process
    input_text = read_input_file
    s_exp      = parse_to_s_expression(input_text)
    write_s_exp_file(s_exp)
    dot_data   = get_method_calls(s_exp)
    write_dot_file(dot_data)
  end
  
  protected
  
  include FileHandling
  include MethodCalls
  include Parser

end
