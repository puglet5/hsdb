module BulkDownload
  extend ActiveSupport::Concern

  included do
    private

    def bulk_download
      filename = "#{@upload.title}#{Time.current}.zip"
      temp_file = Tempfile.new(filename)

      begin
        Zip::OutputStream.open(temp_file) { |zos| }

        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
          @upload.images.all.each do |attachment|
            File.open(Tempfile.new(attachment.filename.to_s), 'w', encoding: 'ASCII-8BIT') do |file|
              attachment.download do |chunk|
                file.write(chunk)
              end
              zip.add(attachment.filename.to_s, file.path)
            end
          end
        end

        zip_data = File.read(temp_file.path)
        send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end
  end
end
