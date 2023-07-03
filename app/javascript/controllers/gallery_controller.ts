import { Controller } from "@hotwired/stimulus"
import { PreparedPhotoSwipeOptions } from "photoswipe"
import PhotoSwipeLightbox from "photoswipe/lightbox"

export default class extends Controller {

  static targets = ["wrapper"]

  connect() {

    const options = {
      gallery: "#gallery",
      children: "a",
      showHideAnimationType: "none",
      initialZoomLevel: "fit",
      secondaryZoomLevel: 2,
      maxZoomLevel: 4,
      pswpModule: () => import("photoswipe")
    }

    const lightbox = new PhotoSwipeLightbox(options as Partial<PreparedPhotoSwipeOptions>)

    lightbox.on("uiRegister", function () {
      lightbox.pswp.ui.registerElement({
        name: "download-button",
        order: 8,
        isButton: true,
        tagName: "a",

        html: {
          isCustomSVG: true,
          inner: "<path d=\"M20.5 14.3 17.1 18V10h-2.2v7.9l-3.4-3.6L10 16l6 6.1 6-6.1ZM23 23H9v2h14Z\" id=\"pswp__icn-download\"/>",
          outlineID: "pswp__icn-download"
        },

        onInit: (el: HTMLAnchorElement, pswp) => {
          el.setAttribute("download", "")
          el.setAttribute("target", "_blank")
          el.setAttribute("rel", "noopener")

          pswp.on("change", () => {
            el.href = pswp.currSlide.data.src
          })
        }
      })
    })

    lightbox.init()
  }
}
