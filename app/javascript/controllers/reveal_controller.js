import { Controller } from "@hotwired/stimulus"

// Reveal-on-scroll. Put data-controller="reveal" on a wrapper; every
// [data-reveal] element inside (or the wrapper itself) fades/slides in once
// as it enters the viewport. Degrades gracefully without IntersectionObserver.
export default class extends Controller {
  connect() {
    const targets = this.element.hasAttribute("data-reveal")
      ? [this.element]
      : Array.from(this.element.querySelectorAll("[data-reveal]"))

    if (!("IntersectionObserver" in window)) {
      targets.forEach((t) => t.classList.add("revealed"))
      return
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("revealed")
          this.observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.12, rootMargin: "0px 0px -8% 0px" })

    targets.forEach((t) => this.observer.observe(t))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}
