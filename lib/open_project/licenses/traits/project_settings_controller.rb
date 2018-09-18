module OpenProject
  module Licenses
    module Traits
      module ProjectSettingsController
        def self.prepended(base)
          base.class_eval do
            before_action :get_licenses, only: %i(show)
          end
        end

        def get_licenses
          @licenses = LicenseVersion.for_select
        end
      end
    end
  end
end

ProjectSettingsController.prepend OpenProject::Licenses::Traits::ProjectSettingsController
