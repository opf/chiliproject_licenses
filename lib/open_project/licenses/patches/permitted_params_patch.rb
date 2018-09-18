module OpenProject
  module Licenses
    module Patches
      module PermittedParamsPatch
        def self.included(base) # :nodoc:
          base.prepend InstanceMethods
        end

        module InstanceMethods
          def project
            p = super

            project_params = params.require(:project)

            p[:license_id] = project_params[:license_id] if project_params[:license_id]

            p
          end
        end
      end
    end
  end
end
