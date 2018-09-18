module OpenProject
  module Licenses
    class Hooks < Redmine::Hook::ViewListener
      # :project
      # :form
      render_on :view_projects_show_sidebar_bottom, partial: 'hooks/projects/license'
      render_on :view_projects_form, partial: 'hooks/projects/license_fields'
    end
  end
end
