import "trix"
import "@rails/actiontext"
import { Turbo } from "@hotwired/turbo-rails"
import "@client-side-validations/client-side-validations/src"
import "@client-side-validations/simple-form/src"
import "./controllers"
import "./packs/mini-profiler-fix.js"
import "./packs/turbo_submit_handler.js"

Turbo.setConfirmMethod(() => {
  let modal = document.getElementById("confirm-modal")
  modal.showModal()

  console.log(modal)

  return new Promise((resolve) => {
    modal.addEventListener("close", () => {
      resolve(modal.returnValue == "confirm")
    }, { once: true })
  })
})
