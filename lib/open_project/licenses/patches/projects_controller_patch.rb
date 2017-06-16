module OpenProject
  module Licenses
    module Patches
      module ProjectsControllerPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            helper :license_versions

            before_filter :get_licenses, only: %i(new create edit update settings copy)

            # Lists visible projects
            def index
              @projects = Project.visible

              if params[:license_version_id].present?
                @projects = @projects.where(license_id: params[:license_version_id].to_i)
              end

              if params[:project_name].present?
                @projects = @projects.where(
                  "LOWER(#{Project.table_name}.name) LIKE ?", "%#{params[:project_name].downcase}%"
                )
              end

              respond_to do |format|
                format.html do
                  @projects = @projects.order('lft')
                end
                format.atom do
                  projects = @projects
                            .order('created_on DESC')
                            .limit(Setting.feeds_limit.to_i)
                  render_feed(projects, title: "#{Setting.app_title}: #{l(:label_project_latest)}")
                end
              end
            end
          end
        end

        def get_licenses
          @licenses = LicenseVersion.for_select
        end
      end
    end
  end
end
