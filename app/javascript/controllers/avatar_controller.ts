import { Controller } from "@hotwired/stimulus"
import Uppy from "@uppy/core"
import Dashboard from "@uppy/dashboard"
import ActiveStorageUpload from "uppy-activestorage-upload"

export default class extends Controller {

  static targets = ["image", "trigger", "div"]

  readonly imageTarget!: HTMLImageElement
  readonly triggerTarget!: HTMLElement
  readonly divTarget!: HTMLElement

  readonly hasImageTarget: boolean
  readonly hasTriggerTarget: boolean
  readonly hasDivTarget: boolean

  connect() {
    const setupUppy = (element) => {
      const trigger = this.triggerTarget

      const direct_upload_url = document.querySelector("meta[name='direct-upload-url']")!.getAttribute("content")
      const field_name = element.dataset.uppy

      trigger.addEventListener("click", (e) => e.preventDefault())

      const uppy = new Uppy({
        restrictions: {
          maxNumberOfFiles: 1,
          allowedFileTypes: ["image/*"],
        },
        autoProceed: false,
        allowMultipleUploads: false,
        allowMultipleUploadBatches: false,
      })

      // @ts-expect-error
      uppy.use(ActiveStorageUpload, {
        directUploadUrl: direct_upload_url
      })

      uppy.use(Dashboard, {
        trigger: "#trigger",
        closeAfterFinish: true,
        inline: false,
        showProgressDetails: true,
        proudlyDisplayPoweredByUppy: false
      })

      const dashboard = document.querySelector(".uppy-Dashboard-inner")!
      dashboard.removeAttribute("style")

      uppy.on("complete", (result) => {
        result.successful.forEach(file => {
          appendUploadedFile(element, file, field_name)
          previewAvatar(element, file)
        })
      })
    }

    const appendUploadedFile = (element, file, field_name) => {
      const hiddenField = document.createElement("input")

      hiddenField.setAttribute("type", "hidden")
      hiddenField.setAttribute("name", field_name)
      hiddenField.setAttribute("data-pending-upload", "true")
      hiddenField.setAttribute("value", file.response.signed_id)

      element.appendChild(hiddenField)
    }

    const previewAvatar = (element, file) => {
      if (this.hasImageTarget) {
        this.imageTarget.src = file.preview
      }
      else {
        const avatarDiv = document.getElementById("avatar")!
        const avatar = document.createElement("img")
        avatar.src = file.preview
        const cls = ["object-cover", "rounded-full", "w-20", "h-20", "md:w-40", "md:h-40"]
        avatar.classList.add(...cls)
        avatarDiv.prepend(avatar)
      }
    }

    setupUppy(this.divTarget)
  }

}
