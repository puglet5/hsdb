
const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')
const ActiveStorageUpload = require('uppy-activestorage-upload')

document.addEventListener('turbo:load', () => {
  document.querySelectorAll('[data-uppy]').forEach(element => setupUppy(element))
})


function setupUppy(element) {
  let trigger = element.querySelector('[data-behavior="uppy-trigger"]')
  let form = element.closest('form')
  let direct_upload_url = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
  let field_name = element.dataset.uppy

  trigger.addEventListener("click", (event) => event.preventDefault())

  let uppy = new Uppy({
    autoProceed: false,
    allowMultipleUploads: true,
    allowMultipleUploadBatches: true,
    // logger: Uppy.debugLogger
  })

  uppy.use(ActiveStorageUpload, {
    directUploadUrl: direct_upload_url
  })

  uppy.use(Dashboard, {
    trigger: trigger,
    closeAfterFinish: false,
    inline: false,
    // showLinkToFileUploadResult: true
    showProgressDetails: true,
    fileManagerSelectionType: "both",
    proudlyDisplayPoweredByUppy: false,
  })

  uppy.on('complete', (result) => {

    result.successful.forEach(file => {
      appendUploadedFile(element, file, field_name)
    })

  })
}

function appendUploadedFile(element, file, field_name) {
  const hiddenField = document.createElement('input')

  hiddenField.setAttribute('type', 'hidden')
  hiddenField.setAttribute('name', field_name)
  hiddenField.setAttribute('data-pending-upload', true)
  hiddenField.setAttribute('value', file.response.signed_id)

  element.appendChild(hiddenField)
}

