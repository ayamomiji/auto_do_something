module AutoDoSomething
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def method_missing(method, *args, &block)
      if m = method.to_s.match(/^auto_(.+)/)
        do_something = m[1].to_sym
        class_eval do
          before_validation do |model|
            args.each do |n|
              if model.respond_to?(:[]=) && model.respond_to?(:[])
                model[n] = model[n].send(do_something) if model[n].respond_to?(do_something)
              else
                getter = n
                setter = "#{n}=".to_sym
                if model.respond_to?(getter) && model.respond_to?(setter)
                  if model.send(getter).respond_to?(do_something)
                    model.send(setter, model.send(getter).send(do_something))
                  end
                end
              end
            end
          end
        end
      else
        super
      end
    end
  end
end

if defined? Rails
  class ActiveRecord::Base
    include AutoDoSomething
  end
end
