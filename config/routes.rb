OpenProject::Application.routes.draw do
  resources :licenses do
    member do
      resources(
        :license_versions,
        except: [:index],
        param: :version_id,
        format: false,
        constraints: {
          id: License::LICENSE_REGEX,
          version_id: License::LICENSE_REGEX
        }
      )
    end
  end
end
