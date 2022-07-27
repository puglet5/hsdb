# frozen_string_literal: true

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(_initiator, record_id, last_n = nil)
    PublicActivity.enabled = false
    spectrum = Spectrum.find(record_id)
    if last_n.nil?
      spectrum.files.each do |csv|
        process_file(spectrum, csv)
      end
    else
      spectrum.files.last(last_n).each do |csv|
        process_file(spectrum, csv)
      end
    end
  end

  def process_file(record, file)
    file.open(tmpdir: Rails.root.join('tmp/storage')) do |tmp|
      processed_file_path = `python lib/assets/spectra_file_converter.py "#{tmp.path}"`.chomp
      unless processed_file_path == 1
        record.processed_csvs.attach(io: File.open(processed_file_path), filename: "#{file.filename}.csv",
                                     content_type: 'text/csv')
        FileUtils.rm(processed_file_path)
      end
    end
  end
end
