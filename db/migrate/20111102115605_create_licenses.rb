class CreateLicenses < ActiveRecord::Migration[5.0]
  def self.up
    return if ActiveRecord::Base.connection.tables.include?("licenses")

    create_table :licenses do |t|
      t.column :name, :string
      t.column :short_name, :string
      t.column :url, :string
      t.column :identifier, :string
    end
  end

  def self.down
    drop_table :licenses
  end
end
