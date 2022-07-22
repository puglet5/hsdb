class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(_initiator, record_id)
    PublicActivity.enabled = false
    spectrum = Spectrum.find(record_id)
    if spectrum&.csvs.any?
      spectrum.csvs.each do |csv|
        spectrum.processed_csvs.attach(csv.blob)
      end
    end
  end
end
