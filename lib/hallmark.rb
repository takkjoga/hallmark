require "hallmark/version"

module Hallmark
  def hallmarked(klass, only: nil, except: nil)
    singleton_methods = { only: [], except: []}
    instance_methods = { only: [], except: []}
    { only: only, except: except }.each do |key, value|
      case value
      when Array
        singleton_methods[key] = value
        instance_methods[key] = value
      when Hash
        singleton_methods[key] = value[:singleton_methods] || []
        instance_methods[key] = value[:instance_methods] || []
      end
    end
    hallmarked_singleton_methods(klass, only: singleton_methods[:only], except: singleton_methods[:except])
    hallmarked_instance_methods(klass, only: instance_methods[:only], except: instance_methods[:except])
  end

  def hallmarked_singleton_methods(klass, only: [], except: [])
    _methods = klass.methods(false).map(&:to_sym)
    _methods &= only.map(&:to_sym) unless only.empty?
    _methods -= except.map(&:to_sym) unless except.empty?
    _methods.each do |method_name|
      module_eval <<-EOS
        def self.#{method_name}(*args)
          raise NotImplementedError
        end
      EOS
    end
  end

  def hallmarked_instance_methods(klass, only: [], except: [])
    _instance_methods = klass.instance_methods(false).map(&:to_sym)
    _instance_methods &= only.map(&:to_sym) unless only.empty?
    _instance_methods -= except.map(&:to_sym) unless except.empty?
    _instance_methods.each do |instance_method_name|
      define_method(instance_method_name) do |*args|
        raise NotImplementedError
      end
    end
  end
end

Module.send(:include, Hallmark)
