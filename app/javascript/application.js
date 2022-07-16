require("@rails/activestorage").start();

import "trix"
import "flowbite/dist/flowbite.js"
import "@rails/actiontext";
import "@hotwired/turbo-rails"
import "./controllers"
import "./packs/back-to-top.js"
import "./packs/mini-profiler-fix.js"
import "./packs/uppy_uploads.js"
import "./packs/direct_upload.js"
import "./packs/metadata_fields.js"

addEventListener("turbo:submit-start", ({ target }) => {
  if (target.elements) {

    for (const field of target.elements) {
      field.disabled = true
    }

  }
})
