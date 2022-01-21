# frozen_string_literal: true

class UploadReflex < ApplicationReflex
  def change_status
    PublicActivity.enabled = false
    upload = Upload.find(element.dataset.upload_id)
    status = element.dataset.status
    upload.update(status: status)
    PublicActivity.enabled = true
  end
end
