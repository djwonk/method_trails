class MethodTrails
  # This module is not currently used.
  # Instead, I rely on parsing.  See DETAILS file.
  module Introspect

    # Get the names of classes defined in +input_full_filename+.
    def get_class_names
      record_class_definitions do
        load input_full_filename
        # Or, an alternative is to use the following:
        # require input_filename
      end
    end
    
    # Get methods defined on +klasses+.
    def get_methods(klasses)
      m = {}
      klasses.each do |klass|
        m[klass.to_s] = klass.methods(false)
      end
      m
    end

    # Get instance methods defined on +klasses+.
    def get_instance_methods(klasses)
      m = {}
      klasses.each do |klass|
        m[klass.to_s] = klass.instance_methods(false)
      end
      m
    end
    
    protected
    
    # Remembers classes defined during block.
    def record_class_definitions
      extant, novel = [], []
      ObjectSpace.each_object(Class) { |k| extant << k }
      yield
      ObjectSpace.each_object(Class) { |k| novel << k if !extant.include?(k) }
      novel
    end

  end
end
