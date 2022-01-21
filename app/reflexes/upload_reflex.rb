# frozen_string_literal: true

class UploadReflex < ApplicationReflex
  def change_status
    upload = Upload.find(element.dataset.id)
    status = element.dataset.status
    upload.update(status: status)
  end
end
