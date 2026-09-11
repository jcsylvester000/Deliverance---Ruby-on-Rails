import { Controller } from "@hotwired/stimulus"

// The futuristic "setting up your dashboard" HUD: steps a progress bar through a few
// provisioning messages, then redirects to the role dashboard.
export default class extends Controller {
  static targets = ["bar", "percent", "status"]
  static values = { url: String }

  connect() {
    this.steps = [
      [15, "Provisioning workspace…"],
      [40, "Calibrating your dashboard…"],
      [65, "Wiring the applicant pipeline…"],
      [90, "Syncing notifications…"],
      [100, "Ready."]
    ]
    this.i = 0
    this.tick()
  }

  disconnect() {
    if (this.timer) clearTimeout(this.timer)
  }

  tick() {
    if (this.i >= this.steps.length) {
      this.timer = setTimeout(() => (window.location.href = this.urlValue), 550)
      return
    }
    const [pct, label] = this.steps[this.i]
    if (this.hasBarTarget) this.barTarget.style.width = `${pct}%`
    if (this.hasPercentTarget) this.percentTarget.textContent = `${pct}%`
    if (this.hasStatusTarget) this.statusTarget.textContent = label
    this.i += 1
    this.timer = setTimeout(() => this.tick(), 560)
  }
}
