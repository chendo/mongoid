module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Symbol #:nodoc:
      module Inflections #:nodoc:
        def singular?
          to_s.singular?
        end
        def plural?
          to_s.plural?
        end
      end
    end
  end
end
