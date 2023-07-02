import { Controller } from "@hotwired/stimulus"
import Uppy, { PluginOptions, UppyFile, UppyOptions } from "@uppy/core"
import Dashboard, { DashboardOptions } from "@uppy/dashboard"
import ActiveStorageUpload from "uppy-activestorage-upload"

export default class extends Controller {

  static values = {
    allowedfiletypes: Array,
    allowmultiplefiles: Boolean,
    generatethumbnails: Boolean,
  }

  allowedfiletypesValue: string[]
  allowmultiplefilesValue: boolean
  generatethumbnailsValue: boolean

  static targets = ["div", "trigger", "text"]

  readonly triggerTarget!: HTMLElement
  readonly textTarget!: HTMLElement
  readonly divTarget!: HTMLElement

  connect() {

    const uppyOptions: UppyOptions = {
      autoProceed: false,
      allowMultipleUploads: this.allowmultiplefilesValue,
      allowMultipleUploadBatches: this.allowmultiplefilesValue,
      restrictions: {
        allowedFileTypes: this.allowedfiletypesValue.length ? this.allowedfiletypesValue : null,
        maxNumberOfFiles: this.allowmultiplefilesValue ? null : 1
      },
    }

    const dashboardOptions: DashboardOptions = {
      disableThumbnailGenerator: !this.generatethumbnailsValue,
      // @ts-expect-error
      trigger: this.triggerTarget,
      doneButtonHandler: null,
      target: this.divTarget,
      closeModalOnClickOutside: true,
      animateOpenClose: false,
      disableInformer: true,
      theme: "auto",
      hidePauseResumeButton: true,
      closeAfterFinish: false,
      inline: false,
      showRemoveButtonAfterComplete: false,
      showProgressDetails: true,
      fileManagerSelectionType: "files",
      proudlyDisplayPoweredByUppy: false
    }

    const setupUppy = (element: HTMLElement) => {
      const directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
      const fieldName = element.dataset.uppy

      const uppy = new Uppy(uppyOptions)

      uppy.use(ActiveStorageUpload, {
        directUploadUrl
      } as PluginOptions)

      uppy.use(Dashboard, dashboardOptions)

      uppy.on("complete", (result) => {
        const filecountText = document.querySelector(`#${this.textTarget.id}`) as HTMLElement
        filecountText.innerHTML = `Add ${pluralize(result.successful.length, "file")}`
        result.successful.forEach(file => {
          appendUploadedFile(element, file, fieldName)
        })
      })
    }

    setupUppy(this.divTarget)

    this.triggerTarget.addEventListener("click", (e) => e.preventDefault())
    const dashboard = document.querySelector(".uppy-Dashboard-inner") as HTMLElement
    dashboard.removeAttribute("style")
  }
}

function pluralize(count: number, noun: string, suffix = "s") {
  return `${count} ${noun}${count !== 1 ? suffix : ""}`
}

function appendUploadedFile(element: HTMLElement, file: UppyFile, fieldName: string) {
  const hiddenField = document.createElement("input")

  hiddenField.setAttribute("type", "hidden")
  hiddenField.setAttribute("name", fieldName)
  hiddenField.setAttribute("data-pending-upload", "true")
  hiddenField.setAttribute("value", file.response.signed_id)

  element.appendChild(hiddenField)
}
