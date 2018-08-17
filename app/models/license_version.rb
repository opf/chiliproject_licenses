class LicenseVersion < ActiveRecord::Base
  unloadable

  belongs_to :license
  has_many :projects

  validates_presence_of :date, :identifier
  validates_uniqueness_of :identifier, :scope => :license_id
  validates_format_of :identifier, :with => /\A#{License::LICENSE_REGEX}\Z/

  scope :for_select, -> { includes(:license).order("licenses.name ASC, license_versions.date DESC") }

  def to_param
    @to_param ||= identifier.to_s
  end

  def title
    "#{license.safe_short_name} #{identifier}"
  end
end
