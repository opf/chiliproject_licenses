class License < ActiveRecord::Base
  LICENSE_REGEX = /[a-zA-Z0-9][\w\-\.]*/

  has_many :versions, -> { order("license_versions.date DESC") }, class_name: 'LicenseVersion', dependent: :destroy

  has_many :logos, :class_name => "Attachment", :as => :container, :dependent => :destroy

  validates_presence_of :name, :identifier
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /\A#{LICENSE_REGEX}\Z/

  accepts_nested_attributes_for :versions, :allow_destroy => false
  accepts_nested_attributes_for :logos, :allow_destroy => false

  acts_as_attachable :view_permission => :view_licenses, :delete_permission => :edit_licenses

  after_save :add_logos
  attr_accessor :logo_data

  def to_param
    @to_param ||= identifier.to_s
  end

  def latest_version
    versions.first
  end

  def first_version_attributes=(params)
    versions.build(params)
  end

  def attachments_deletable?(user = User.current)
    user.admin?
  end

  def attachments_visible?(user = User.current)
    true
  end

  def project
    nil
  end

  def attachments
    logos
  end

  def attachments=(args)
    logo_data = args
  end

  def safe_short_name
    return short_name if short_name.present?
    name
  end

  def link_text
    result = name
    result += " (#{short_name})" if short_name.present?
    result
  end

  private

  def add_logos
    attach_files logo_data
    attachments.each(&:save!)
  end
end
