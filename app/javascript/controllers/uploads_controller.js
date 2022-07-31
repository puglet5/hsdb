import { Controller } from "@hotwired/stimulus"
import Uppy from "@uppy/core"
import Dashboard from "@uppy/dashboard"
import ActiveStorageUpload from "uppy-activestorage-upload"
import ImageEditor from "@uppy/image-editor"

export default class extends Controller {

  static targets = ["div", "trigger"]

  connect() {
    const setupUppy = (element) => {
      let trigger = this.triggerTarget

      let direct_upload_url = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
      let field_name = element.dataset.uppy

      trigger.addEventListener("click", (e) => e.preventDefault())

      let uppy = new Uppy({
        autoProceed: false,
        allowMultipleUploads: true,
        allowMultipleUploadBatches: true,
        restrictions: {
          allowedFileTypes: ["image/*"],
        },
      })

      uppy.use(ActiveStorageUpload, {
        directUploadUrl: direct_upload_url
      })

      uppy.use(Dashboard, {
        trigger: trigger,
        // target: target,
        closeAfterFinish: true,
        inline: false,
        showProgressDetails: true,
        fileManagerSelectionType: "both",
        proudlyDisplayPoweredByUppy: false
      })

      uppy.use(ImageEditor, {
        target: Dashboard,
        quality: 1,
        cropperOptions: {
          viewMode: 0,
          background: false,
          autoCropArea: 1,
          responsive: true,
          croppedCanvasOptions: {},
        },
        actions: {
          cropSquare: false,
          cropWidescreen: false,
          cropWidescreenVertical: false,
        },
      })

      let dashboard = document.querySelector(".uppy-Dashboard-inner")
      dashboard.removeAttribute("style")

      let files_uploaded = 0

      uppy.on("complete", (result) => {
        files_uploaded += result.successful.length
        let txt = document.querySelector("#uppy-text")
        txt.innerHTML = `Add ${files_uploaded} images`
        result.successful.forEach(file => {
          appendUploadedFile(element, file, field_name)
          imagePreveiw(element, file)
        })
      })
    }

    const appendUploadedFile = (element, file, field_name) => {
      const hiddenField = document.createElement("input")

      hiddenField.setAttribute("type", "hidden")
      hiddenField.setAttribute("name", field_name)
      hiddenField.setAttribute("data-pending-upload", true)
      hiddenField.setAttribute("value", file.response.signed_id)

      element.appendChild(hiddenField)
    }

    const imagePreveiw = () => {

    }


    setupUppy(this.divTarget)
  }

}
