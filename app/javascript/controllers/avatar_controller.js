import { Controller } from "@hotwired/stimulus";
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
import ActiveStorageUpload from 'uppy-activestorage-upload'


export default class extends Controller {

  static targets = [ "image", "trigger", "div" ]

  connect() {
    const setupUppy = (element) => {
      let trigger = this.triggerTarget

      let direct_upload_url = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
      let field_name = element.dataset.uppy

      trigger.addEventListener("click", (e) => e.preventDefault())

      let uppy = new Uppy({
        restrictions: {
        maxNumberOfFiles: 1,
        },
        autoProceed: false,
        allowMultipleUploads: false,
        allowMultipleUploadBatches: false,
      })

      console.log(uppy)

      uppy.use(ActiveStorageUpload, {
        directUploadUrl: direct_upload_url
      })

      uppy.use(Dashboard, {
        trigger: trigger,
        closeAfterFinish: true,
        inline: false,
        showProgressDetails: true,
        proudlyDisplayPoweredByUppy: false
      })

      let dashboard = document.querySelector('.uppy-Dashboard-inner')
      dashboard.removeAttribute('style')

      uppy.on('complete', (result) => {
        result.successful.forEach(file => {
          appendUploadedFile(element, file, field_name)
          previewAvatar(element, file)
        })
        uppy.reset()
      })
    }

    const appendUploadedFile = (element, file, field_name) => {
      const hiddenField = document.createElement('input')

      hiddenField.setAttribute('type', 'hidden')
      hiddenField.setAttribute('name', field_name)
      hiddenField.setAttribute('data-pending-upload', true)
      hiddenField.setAttribute('value', file.response.signed_id)

      element.appendChild(hiddenField)
    }

    const previewAvatar = (element, file) => {
      let img = this.imageTarget
      if (img) {
        img.src = file.preview
      }
    }


    setupUppy(this.divTarget)
  }

}
