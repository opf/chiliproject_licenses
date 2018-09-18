module LicenseVersionsHelper
  def link_to_license_version(lv)
    link_to(lv.title, get_license_version_url(lv), :class => lv.url.present? ? 'external' : '')
  end

  private

  def get_license_version_url(lv)
    return lv.url if lv.url.present?
    license_version_path(lv.license, lv)
  end
end

