document.addEventListener("turbo:load", () => {
  let mybutton = document.getElementById("btn-back-to-top")

  window.onscroll = function () {
    scrollFunction()
  }

  function scrollFunction() {
    if (document.body.scrollTop > 500 || document.documentElement.scrollTop > 500) {
      mybutton.style.display = "block"
    } else {
      mybutton.style.display = "none"
    }
  }

  mybutton.addEventListener("click", backToTop)

  function backToTop() {
    document.body.scrollTop = 0
    document.documentElement.scrollTop = 0
  }

})
