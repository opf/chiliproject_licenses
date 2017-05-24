module OpenProject
  module Licenses
    module Patches
      module ProjectsHelperPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            def no_results_box(
              action_url: nil,
              display_action: false,
              custom_title: nil,
              custom_action_text: nil
            )
              title = custom_title || t('.no_results_title_text', cascade: true)
              action_text = custom_action_text || t('.no_results_content_text')

              filters = render_to_string(partial: "projects/license_filter", locals: { license_versions: LicenseVersion.for_select })
              filters = "#{filters}" # to_s won't work on the output buffer

              s = render_to_string(
                partial: '/common/no_results',
                locals: {
                  title_text:  title,
                  action_text: display_action ? action_text : '',
                  action_url:  action_url || ''
                }
              )

              filters << "#{s}" # to_s won't work on the output buffer

              filters.html_safe
            end

            def render_project_hierarchy(projects)
              s = render_to_string(partial: "projects/license_filter", locals: { license_versions: LicenseVersion.for_select })
              s = "#{s}" # to_s won't work on the output buffer

              if projects.any?
                ancestors = []
                original_project = @project
                Project.project_tree(projects) do |project, _level|
                  # set the project environment to please macros.
                  @project = project

                  if ancestors.empty? || project.is_descendant_of?(ancestors.last)
                    s << "<ul class='projects #{ancestors.empty? ? 'root' : nil}'>\n"
                  else
                    ancestors.pop
                    s << '</li>'
                    while ancestors.any? && !project.is_descendant_of?(ancestors.last)
                      ancestors.pop
                      s << "</ul></li>\n"
                    end
                  end

                  classes = (ancestors.empty? ? 'root' : 'child')
                  s << "<li class='#{classes}'><div class='#{classes}'>" +
                    link_to_project(project, {}, { class: 'project' }, true)

                  if project.license.present?
                    s << "<div class=\"wiki description\"><b>License:</b> <a href=\"#{project.license.url}\">#{project.license.title}</a></div>"
                  end

                  unless project.description.blank?
                    formatted_text = format_text(project.short_description, project: project)
                    s << "<div class='wiki description'>#{formatted_text}</div>"
                  end

                  s << "</div>\n"
                  ancestors << project
                end

                s << ("</li></ul>\n" * ancestors.size)

                @project = original_project
              end

              s.html_safe
            end
          end
        end
      end
    end
  end
end
