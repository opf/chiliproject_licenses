# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject
  module Licenses
    class Engine < ::Rails::Engine
      engine_name :openproject_licenses

      include OpenProject::Plugins::ActsAsOpEngine

      class << self
        def settings
          {
            partial: 'settings/licenses',
            default: {
              'top_text' => '',
              'bottom_text' => ''
            }
          }
        end
      end

      register(
        'openproject-licenses',
        author_url: 'https://openproject.org',
        requires_openproject: '>= 6.0.0',
        settings: settings
      ) do
        menu :top_menu,
             :licenses,
             {
               controller: 'licenses',
               action: 'index'
             },
             caption: I18n.t(:label_license_plural, default: "Licenses"),
             after: :projects

        permission :view_licenses, licenses: [:show, :index]
      end

      patches [:Project, :ProjectsController, :PermittedParams]

      initializer 'licenses.traits' do
        require 'open_project/licenses/traits/project_settings_controller'
      end

      initializer 'proto_plugin.register_hooks' do
        require 'open_project/licenses/hooks'
      end
    end
  end
end
