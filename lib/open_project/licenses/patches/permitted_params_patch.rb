module OpenProject
  module Licenses
    module Patches
      module PermittedParamsPatch
        def self.included(base) # :nodoc:
          base.prepend InstanceMethods
        end

        module InstanceMethods
          def project
            res = super

            require 'pry'; binding.pry

            res
          end
        end
      end
    end
  end
end
