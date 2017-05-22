module OpenProject
  module Licenses
    module Patches
      module ProjectPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            unloadable # Send unloadable so it will not be unloaded in development

            belongs_to :license, class_name: 'LicenseVersion'

            scope :with_license_id, lambda { |license_id| where(license_id: license_id) }
          end
        end
      end
    end
  end
end
