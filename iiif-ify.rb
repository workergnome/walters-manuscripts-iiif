require 'iiif_s3'
require_relative 'scraper'

MAX_RECORDS_TO_PARSE = 2

@scraper = Scraper.new

# ---------------------
# SET UP IIIF BUILDER
# ---------------------
iiif_options = {
  output_dir:  Scraper::DATA_DIRECTORY,
  image_directory_name: "img",
  variants: { "reference" => 600, "access" => 1200},
  upload_to_s3: true,
  image_file_types: [".jpg", ".tif", ".jpeg", ".tiff"],
  document_file_types: [".pdf"],
  verbose: true,
  # logo:        config["logo"]
}

@iiif = IiifS3::Builder.new(iiif_options)
@iiif.create_build_directories
image_records = []

# ---------------------
# Build an image record for each image
# ---------------------
current_record_number = 0

File.open("data/list.txt","r") do |f|
  f.each_line do |line|

    # Scrape file
    id = line.strip    
    xml_doc = @scraper.get_data("#{Scraper::DATA_DIRECTORY}/#{id}.xml", id)
    next unless xml_doc

    xml_doc.css("surface").each_with_index do |surface,i|

      uri =  @scraper.image_url(id, surface.css("graphic")[1]["url"])
      path = "#{Scraper::DATA_DIRECTORY}/#{uri.split("/").last}"
      @scraper.queue_image(path, uri)

      # Generate a data object for the image
      obj = {
        "path" => path,
        "id"       => id,
        "is_primary" => i == 0,
        "page_number" => i+1,
        "is_document" => true,
        "section" => surface["n"].to_slug.transliterate.normalize.to_s,
        "section_label" => surface["n"],
      }

      if obj["is_primary"]
        obj["label"]       = xml_doc.at_css("titleStmt title").text
        obj["description"] = xml_doc.at_css("notesStmt note").text
        obj["attribution"] = xml_doc.at_css("availability").text
      end

      # Add image to the queue
      image_records << IiifS3::ImageRecord.new(obj)
    end

    # Download all the images
    @scraper.download_queue
    current_record_number += 1
    break if current_record_number >= MAX_RECORDS_TO_PARSE
  end
end

## Process all the IIIF images and upload them
@iiif.load(image_records)
@iiif.process_data