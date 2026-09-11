require "open3"
require "json"
require "tempfile"

# Uploads a file to UploadThing via the official Node SDK (bin/uploadthing_upload.mjs),
# keeping the secret token server-side. Returns a Result with the hosted URL + key.
class UploadthingService
  Result = Struct.new(:key, :url, :name, :size, keyword_init: true)
  class UploadError < StandardError; end

  def self.upload(uploaded_file)
    new.upload(uploaded_file)
  end

  # `uploaded_file` is an ActionDispatch::Http::UploadedFile (from params).
  def upload(uploaded_file)
    ext = File.extname(uploaded_file.original_filename.to_s)
    Tempfile.create(["deliverance-upload", ext]) do |tmp|
      tmp.binmode
      tmp.write(uploaded_file.read)
      tmp.flush

      stdout, stderr, status = Open3.capture3(
        { "UPLOADTHING_TOKEN" => ENV["UPLOADTHING_TOKEN"].to_s },
        "node", Rails.root.join("bin/uploadthing_upload.mjs").to_s,
        tmp.path,
        uploaded_file.original_filename.to_s,
        uploaded_file.content_type.to_s
      )

      unless status.success?
        detail = parse_error(stderr).presence || parse_error(stdout).presence || "unknown error"
        raise UploadError, detail
      end

      data = JSON.parse(stdout)
      Result.new(key: data["key"], url: data["url"], name: data["name"], size: data["size"])
    end
  end

  private

  def parse_error(str)
    JSON.parse(str)["error"]
  rescue StandardError
    str.to_s.strip
  end
end
