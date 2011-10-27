require 'pp'
require 'require_relative'
require_relative 'dot_output'

class MethodTrails
  module FileHandling

    # Reads entire file into memory, as an array of lines
    def read_input_file_as_lines
      text = nil
      File.open(input_filename, "r") do |file|
        text = file.readlines
      end
      text.map { |line| line.chomp }
    end

    # Reads entire file into memory, as one string
    def read_input_file
      text = nil
      File.open(input_filename, "r") do |file|
        text = file.read
      end
      text
    end

    def write_log_file(log_contents)
      File.open(log_filename, "w") do |file|
        file.print(log_contents)
      end
    end

    def write_s_exp_file(s_exp)
      File.open(s_exp_filename, "w") do |file|
        file.print(s_exp.pretty)
      end
    end

    def write_dot_file(graph)
      @indent = 0
      File.open(dot_filename, "w") do |file|
        file.print dot_file_header
        dot_file_contents(graph).each do |line|
          file.puts dot_indent(@indent) + "#{line}"
        end
        file.print dot_file_footer
      end
    end

    include DotOutput

  end
end
