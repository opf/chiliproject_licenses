module OpenProject
  module Licenses
    module Patches
      module ProjectsControllerPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            helper :license_versions

            before_filter :get_licenses, only: %i(new create edit update settings copy)
          end
        end

        def get_licenses
          @licenses = LicenseVersion.for_select
        end
      end
    end
  end
end
