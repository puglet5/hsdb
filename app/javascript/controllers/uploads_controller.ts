import { Controller } from "@hotwired/stimulus"
import Uppy from "@uppy/core"
import Dashboard from "@uppy/dashboard"
import ActiveStorageUpload from "uppy-activestorage-upload"

export default class extends Controller {

  static values = {
    filetype: String,
    allowedfiletypes: Array,
    allowmultiple: Boolean,
    thumbnails: Boolean,
  }

  filetypeValueValue: string
  allowedfiletypesValue: string[]
  allowmultipleValue: boolean
  thumbnailsValue: boolean

  static targets = ["div", "trigger", "text"]

  readonly triggerTarget!: HTMLElement
  readonly textTarget!: HTMLElement
  readonly divTarget!: HTMLElement

  readonly hasTriggerTarget: boolean
  readonly hasDivTarget: boolean
  readonly hasTextTarget: boolean

  connect() {

    const appendUploadedFile = (element, file, field_name) => {
      const hiddenField = document.createElement("input")

      hiddenField.setAttribute("type", "hidden")
      hiddenField.setAttribute("name", field_name)
      hiddenField.setAttribute("data-pending-upload", "true")
      hiddenField.setAttribute("value", file.response.signed_id)

      element.appendChild(hiddenField)
    }

    const pluralize = (count, noun, suffix = "s") =>
      `${count} ${noun}${count !== 1 ? suffix : ""}`

    const setupUppy = (element) => {
      const trigger = this.triggerTarget

      const direct_upload_url = document.querySelector("meta[name='direct-upload-url']")!.getAttribute("content")
      const field_name = element.dataset.uppy

      trigger.addEventListener("click", (e) => e.preventDefault())

      const uppy = new Uppy({
        autoProceed: false,
        allowMultipleUploads: this.allowmultipleValue,
        allowMultipleUploadBatches: this.allowmultipleValue,
        restrictions: {
          allowedFileTypes: this.allowedfiletypesValue.length ? this.allowedfiletypesValue : null,
          maxNumberOfFiles: this.allowmultipleValue ? null : 1
        },
      })

      // @ts-expect-error
      uppy.use(ActiveStorageUpload, {
        directUploadUrl: direct_upload_url
      })

      // @ts-expect-error
      uppy.use(Dashboard, {
        disableThumbnailGenerator: !this.thumbnailsValue,
        trigger: trigger,
        target: this.divTarget,
        closeAfterFinish: false,
        inline: false,
        showProgressDetails: false,
        fileManagerSelectionType: "both",
        proudlyDisplayPoweredByUppy: false
      })

      const dashboard = document.querySelector(".uppy-Dashboard-inner")!
      dashboard.removeAttribute("style")

      let filesCount = 0

      uppy.on("complete", (result) => {
        filesCount += result.successful.length
        const filecountText = document.querySelector(`#${this.textTarget.id}`)!
        filecountText.innerHTML = `Add ${pluralize(filesCount, "file")}`
        result.successful.forEach(file => {
          appendUploadedFile(element, file, field_name)
        })
      })
    }

    setupUppy(this.divTarget)
  }
}
