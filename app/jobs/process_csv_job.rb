# frozen_string_literal: true

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(_initiator, record_id)
    PublicActivity.enabled = false
    spectrum = Spectrum.find(record_id)
    if spectrum&.files.any?
      spectrum.files.each do |csv|
        csv.open(tmpdir: Rails.root.join('tmp/storage')) do |tmp|
          processed_file_path = `python lib/assets/spectra_file_converter.py "#{tmp.path}"`.chomp
          unless processed_file_path == 1
            spectrum.processed_csvs.attach(io: File.open(processed_file_path), filename: "#{csv.filename}.csv",
                                           content_type: 'text/csv')
            FileUtils.rm(processed_file_path)
          end
        end
      end
    end
  end
end
