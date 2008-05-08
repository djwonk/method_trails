require 'require_relative'
require 'ripper'
require_relative '/../classes/s_exp'

class MethodTrails
  module Parser

    # Parses +text+.  Returns a +SExp+.
    def parse_to_s_expression(text)
      begin
      Ripper.sexp(text).to_s_exp(true) # disable capturing atoms
      rescue LoadError
      end
    end

  end
end
