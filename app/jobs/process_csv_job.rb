# frozen_string_literal: true

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(_initiator, record_id, last_n = nil)
    PublicActivity.enabled = false
    spectrum = Spectrum.find(record_id)
    spectrum.processing_ongoing!
    errs = 0

    if last_n.nil?
      file_count = spectrum.files.count

      spectrum.files.each do |csv|
        errs += 1 unless process_file(spectrum, csv)
      end

    else
      file_count = spectrum.files.last(last_n).count

      spectrum.files.last(last_n).each do |csv|
        errs += 1 unless process_file(spectrum, csv)
      end

    end

    spectrum.processing_mixed! if errs < file_count
    spectrum.processing_error! if errs == file_count
    spectrum.processing_successful! if errs.zero?
  end

  def process_file(record, file)
    file.open(tmpdir: Rails.root.join('tmp/storage')) do |tmp|
      processed_file_path = `python lib/assets/spectra_file_converter.py "#{tmp.path}"`.chomp
      if processed_file_path == 1
        false
      else
        record.processed_csvs.attach(io: File.open(processed_file_path), filename: "#{file.filename}.csv",
                                     content_type: 'text/csv')
        FileUtils.rm(processed_file_path)
        true
      end
    end
  rescue StandardError
    logger.error "Error processing file: #{file.inspect}"
    false
  end
end
