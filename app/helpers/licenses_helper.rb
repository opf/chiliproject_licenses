module LicensesHelper

  def link_to_license(l)
    link_to(l.link_text, get_license_url(l), :class => l.url.present? ? 'external' : '')
  end

private

  def get_license_url(l)
    return l.url if l.url.present?
    license_path(l)
  end
end
