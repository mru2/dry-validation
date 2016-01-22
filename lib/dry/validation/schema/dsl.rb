module Dry
  module Validation
    class Schema
      module DSL
        def define(type, name, &block)
          key = type.new(name, self)
          key.__send__(key.predicate, &block)
        end

        def key(name, &block)
          define(Key, name, &block)
        end

        def optional(name, &block)
          Key.new(name, self).optional(&block)
        end

        def attr(name, &block)
          define(Attr, name, &block)
        end

        def value(name)
          Schema::Rule::Result.new(name, [], target: self)
        end

        def rule(name, &block)
          if block
            predicate = yield

            checks << Schema::Rule.new(
              name,
              [:check, [name, predicate.to_ary, predicate.keys]],
              target: self, keys: predicate.keys
            )

            checks.last
          else
            self[name].to_check
          end
        end

        def [](name)
          rules.detect { |rule| rule.name == name }
        end
      end
    end
  end
end
