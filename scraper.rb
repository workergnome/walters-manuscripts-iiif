require 'dotenv'
Dotenv.load

require 'json'
require "fileutils"
require "typhoeus"
require 'nokogiri'
require "babosa"

# Fix for silly JSON bug in AWS library.
class Fixnum; def to_json(*_); to_s; end; end

class Scraper
  
  DATA_DIRECTORY = "scraped_data"
  
  def initialize
    @hydra = Typhoeus::Hydra.new
  end

  #---------------------
  def data_url(id)
    "http://purl.thewalters.org/art/#{id}/data"
  end

  #---------------------
  def image_url(id, img)
    "#{data_url(id)}/#{img}"
  end

  #---------------------
  def tei_url(id)
    "http://purl.thewalters.org/art/#{id}/TEI"
  end

  #---------------------
  def get_data(path, id)
    if File.exist? path
      xml_doc = File.open(path) { |f| Nokogiri::XML(f) }
    else
      puts tei_url(id)
      response = Typhoeus.get(tei_url(id), followlocation: true)
      return nil unless response.code == 200
      File.open(path, "w") do |output_file|
        output_file.puts response.body
      end
      xml_doc  = Nokogiri::XML(response.body)
    end
    xml_doc
  end

  #---------------------
  def queue_image(path,uri)
    unless File.exist? path
      image_request = Typhoeus::Request.new(uri, followlocation: true)
      downloaded_file = File.open(path,"wb")
      image_request.on_headers do |response|
        if response.code != 200
          raise "Request failed"
        end
      end
      image_request.on_body do |chunk|
        downloaded_file.write(chunk)
      end
      image_request.on_complete do |response|
        downloaded_file.close
      end
      @hydra.queue(image_request)
    end
  end

  def download_queue
    @hydra.run
  end
end]