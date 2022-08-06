import { Controller } from "@hotwired/stimulus"
import PhotoSwipeLightbox from "photoswipe/lightbox"

export default class extends Controller {

  static targets = [ "wrapper" ]

  connect() {
    const lightbox = new PhotoSwipeLightbox({
      gallery: "#gallery",
      children: "a",
      showHideAnimationType: "none",
      initialZoomLevel: "fit",
      secondaryZoomLevel: 2,
      maxZoomLevel: 4,
      pswpModule: () => import("photoswipe")
    })

    lightbox.init()
  }
}
