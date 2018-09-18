class AddLicenseIdToProjects < ActiveRecord::Migration[5.0]
  def self.up
    return if Project.columns.include? :license_id

    add_column :projects, :license_id, :integer
  end

  def self.down
    remove_column :projects, :license_id
  end
end
