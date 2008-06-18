class MethodTrails
  module DotOutput

    class OutputGenerator
      def initialize(graph)
        @graph = graph
        @o     = []
      end
      attr_accessor :graph, :o
      
      def output_classes_and_i_methods
        if classes_and_i_methods = graph[:classes_and_i_methods]
          o << "/* Classes and their Instance Methods */"
          classes_and_i_methods.each_with_index do |hash, i|
            pairs = hash["class"].zip(hash["def"])
            hash["class"].uniq.each do |klass|
              o.concat cluster_start(klass)
              pairs.find_all { |p| p[0] == klass }.each do |p|
                o << dot_indent(1) + %{"#{p[1]}" [color=green];}
              end
              o.concat cluster_stop
            end
          end
          o << nil
        end
      end

      def output_i_methods_and_ids
        if i_methods_and_ids = graph[:i_methods_and_ids]
          i_methods_and_ids.each do |hash|
            pairs = hash["def"].zip(hash["ident"])
            pairs.each do |pair|
              o << %{"#{pair[0]}" -> "#{pair[1]}";}
            end
          end
        end
      end
      
      def run
        output_classes_and_i_methods
        output_i_methods_and_ids
      end
      
      def to_graph
        @o
      end
      
      def self.run(graph)
        new(graph).run.to_graph
      end
      
    end

    def dot_file_contents(graph)
      OutputGenerator.run(graph)
    end

    def dot_file_header
      @indent += 1
      <<-HEADER
digraph untitled
{
  graph [size=7.5,10];
  graph [center=1];
  graph [fontname=Arial];
  graph [overlap=false];
  graph [ratio=compress];
  node [style=filled];
  node [fillcolor="#DDDDDD"]
  node [fontname=Arial];
  node [fontsize=10];
  edge [fontname=Arial];
  edge [fontsize=10];

      HEADER
    end
    # graph [rankdir=LR];

    def dot_file_footer
      @indent -= 1
      <<-FOOTER
}
      FOOTER
    end
    
    protected
    
    # def output_classes(graph, o)
    #   if classes = graph[:classes]
    #     o << "/* Classes */"
    #     classes.each do |hash|
    #       hash["class"].each do |x|
    #         o << %{"#{x}" [shape=box, style=filled, fillcolor="#FFD8ED"];}
    #       end
    #     end
    #     o << nil
    #   end
    # end
    
    # def output_i_methods(graph, o)
    #   if i_methods = graph[:i_methods]
    #     o << "/* Instance Methods */"
    #     i_methods.each do |hash|
    #       hash["def"].each do |x|
    #         o << %{"#{x}" [style=filled, fillcolor="#FFFDD8"];}
    #       end
    #     end
    #     o << nil
    #   end
    # end

    # def output_c_methods(graph, o)
    #   if c_methods = graph[:c_methods]
    #     o << "/* Class Methods */"
    #     c_methods.each do |hash|
    #       hash["defs"].each do |x|
    #         o << %{"#{x}" [style=filled, fillcolor="#DAFFD8"];}
    #       end
    #     end
    #     o << nil
    #   end
    # end
    
    def output_classes_and_i_methods(graph, o)
      if classes_and_i_methods = graph[:classes_and_i_methods]
        o << "/* Classes and their Instance Methods */"
        classes_and_i_methods.each_with_index do |hash, i|
          pairs = hash["class"].zip(hash["def"])
          hash["class"].uniq.each do |klass|
            o.concat cluster_start(klass)
            pairs.find_all { |p| p[0] == klass }.each do |p|
              o << dot_indent(1) + %{"#{p[1]}" [color=green];}
            end
            o.concat cluster_stop
          end
        end
        o << nil
      end
    end
    
    def output_i_methods_and_ids(graph, o)
      if i_methods_and_ids = graph[:i_methods_and_ids]
        i_methods_and_ids.each do |hash|
          pairs = hash["def"].zip(hash["ident"])
          pairs.each do |pair|
            o << %{"#{pair[0]}" -> "#{pair[1]}";}
          end
        end
      end
    end

    def cluster_start(label)
      @cluster_id ||= 0
      @cluster_id += 1
      @indent += 1
      o = []
      o << "subgraph cluster_#{@cluster_id} {"
      o << dot_indent(1) + %{label="#{label}";}
      o << dot_indent(1) + "color=blue;"
    end
    
    def cluster_stop
      @indent -= 1
      o = []
      o << "}"
    end
    
    def dot_indent(x)
      "  " * x
    end
    
  end
end
