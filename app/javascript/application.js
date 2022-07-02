require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();


import "./packs/direct_upload";
import "trix"
import "flowbite/dist/flowbite.js"
import 'tw-elements';
import "@rails/actiontext";



//////// Back to top button


// Get the button
let mybutton = document.getElementById('btn-back-to-top');

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () {
  scrollFunction();
};

function scrollFunction() {
  if (document.body.scrollTop > 500 || document.documentElement.scrollTop > 500) {
    mybutton.style.display = 'block';
  } else {
    mybutton.style.display = 'none';
  }
}
// When the user clicks on the button, scroll to the top of the document
mybutton.addEventListener('click', backToTop);

function backToTop() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}
