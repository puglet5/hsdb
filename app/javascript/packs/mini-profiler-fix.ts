//@ts-nocheck

document.addEventListener("turbo:before-visit", e => {
  window.MiniProfilerContainer = document.querySelector("body > .profiler-results")
  if (!e.defaultPrevented) window.MiniProfiler.pageTransition()
})

document.addEventListener("turbo:load", () => {
  if (window.MiniProfilerContainer) {
    document.body.appendChild(window.MiniProfilerContainer)
  }
})
