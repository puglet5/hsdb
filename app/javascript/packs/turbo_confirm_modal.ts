import { Turbo } from "@hotwired/turbo-rails"

Turbo.setConfirmMethod(() => {
  const modal: HTMLDialogElement = document.getElementById("confirm-modal") as HTMLDialogElement
  if (!modal) return
  modal.showModal()

  return new Promise((resolve) => {
    modal.addEventListener("close", () => {
      resolve(modal.returnValue == "confirm")
    }, { once: true })
  })
})
