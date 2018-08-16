class ConvertLicenseVersionTextsToMarkdown < ActiveRecord::Migration[5.1]
  def up
    converter = OpenProject::TextFormatting::Formats::Markdown::TextileConverter.new

    print "Converting #{LicenseVersion.count} license version text(s) from textile to markdown"

    LicenseVersion.all.each do |version|
      version.update! text: converter.send(:convert_textile_to_markdown, version.text)
      print "."
    end

    puts " done"
  end
end
