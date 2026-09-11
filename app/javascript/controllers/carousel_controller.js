import { Controller } from "@hotwired/stimulus"

// A tiny, dependency-free carousel used for the hero backdrop (mode: "fade")
// and the testimonials slider (mode: "swap"). Auto-advances, pauses on hover,
// and supports dots + prev/next.
export default class extends Controller {
  static targets = ["slide", "dot"]
  static values = {
    index: { type: Number, default: 0 },
    interval: { type: Number, default: 6000 },
    mode: { type: String, default: "fade" }
  }

  connect() {
    this.show(this.indexValue)
    this.start()
  }

  disconnect() {
    this.stop()
  }

  start() {
    if (this.intervalValue > 0 && this.slideTargets.length > 1) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  stop() {
    if (this.timer) { clearInterval(this.timer); this.timer = null }
  }

  pause() { this.stop() }
  resume() { this.stop(); this.start() }

  next() { this.show((this.indexValue + 1) % this.slideTargets.length) }
  prev() { this.show((this.indexValue - 1 + this.slideTargets.length) % this.slideTargets.length) }

  to(event) {
    const i = Number(event.currentTarget.dataset.index || 0)
    this.show(i)
    this.resume()
  }

  show(i) {
    this.indexValue = i

    this.slideTargets.forEach((el, n) => {
      const active = n === i
      if (this.modeValue === "fade") {
        el.classList.toggle("opacity-100", active)
        el.classList.toggle("opacity-0", !active)
        el.classList.toggle("z-10", active)
      } else {
        el.classList.toggle("hidden", !active)
      }
    })

    this.dotTargets.forEach((d, n) => {
      const active = n === i
      d.classList.toggle("bg-cyan-400", active)
      d.classList.toggle("w-6", active)
      d.classList.toggle("bg-white/30", !active)
      d.classList.toggle("w-2.5", !active)
    })
  }
}
