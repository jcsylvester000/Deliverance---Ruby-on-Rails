import { Controller } from "@hotwired/stimulus"

// Animated number that counts up from 0 to `to` the first time it scrolls
// into view. Usage:
//   <span data-controller="countup" data-countup-to-value="1200"
//         data-countup-suffix-value="+">0</span>
export default class extends Controller {
  static values = {
    to: Number,
    duration: { type: Number, default: 1600 },
    prefix: { type: String, default: "" },
    suffix: { type: String, default: "" }
  }

  connect() {
    this.done = false
    if (!("IntersectionObserver" in window)) { this.render(this.toValue); return }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !this.done) {
          this.done = true
          this.animate()
        }
      })
    }, { threshold: 0.5 })

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  animate() {
    const start = performance.now()
    const to = this.toValue
    const dur = this.durationValue

    const tick = (now) => {
      const p = Math.min((now - start) / dur, 1)
      const eased = 1 - Math.pow(1 - p, 3)
      this.render(Math.round(to * eased))
      if (p < 1) requestAnimationFrame(tick)
    }
    requestAnimationFrame(tick)
  }

  render(value) {
    this.element.textContent = `${this.prefixValue}${value.toLocaleString()}${this.suffixValue}`
  }
}
