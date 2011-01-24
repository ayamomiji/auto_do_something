module AutoDoSomething
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def auto(method, hash)
      method = method.to_sym
      args = hash[:with] || []
      args = [args] unless args.is_a? Array
      fields = hash[:for]
      fields = [fields] unless fields.is_a? Array
      return if fields.blank?

      fields.each do |field|
        class_eval do
          before_validation do |model|
            if model.respond_to?(:[]) && model.respond_to?(:[]=)
              model[field] = model[field].send(method, *args) if model[field].respond_to?(method)
            else
              getter = field
              setter = "#{field}=".to_sym
              if model.respond_to?(getter) && model.respond_to?(setter)
                if model.send(getter).respond_to?(method)
                  model.send(setter, model.send(getter).send(method, *args))
                end
              end
            end
          end
        end
      end
    end
  end
end

if defined? Rails
  class ActiveRecord::Base
    include AutoDoSomething
  end
end
