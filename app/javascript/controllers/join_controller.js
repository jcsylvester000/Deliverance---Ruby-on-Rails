import { Controller } from "@hotwired/stimulus"

// Drives the get-to-know-you modal: tab switching (register / login), the 4-step
// wizard, per-step validation (steps 1 & 2 required, step 3 skippable), and the
// progress bar. Progressive enhancement — without JS the form still shows every field.
export default class extends Controller {
  static targets = [
    "overlay", "register", "login", "tab",
    "step", "progress", "back", "next", "skip", "submit", "error"
  ]

  connect() {
    this.index = 0
    if (window.location.hash === "#join") this.open()
  }

  open() {
    this.overlayTarget.hidden = false
    this.showRegister()
  }

  close() {
    if (!this.hasOverlayTarget) return
    this.overlayTarget.hidden = true
  }

  showRegister() {
    this.registerTarget.hidden = false
    this.loginTarget.hidden = true
    this._activateTab("register")
    this.index = 0
    this._render()
  }

  showLogin() {
    this.registerTarget.hidden = true
    this.loginTarget.hidden = false
    this._activateTab("login")
  }

  next() {
    if (!this._validateStep(this.index)) return
    if (this.index < this._steps().length - 1) {
      this.index += 1
      this._render()
    }
  }

  back() {
    if (this.index > 0) {
      this.index -= 1
      this._render()
    }
  }

  skip() {
    // Clear the optional answer, then move on.
    const select = this._steps()[this.index].querySelector("select")
    if (select) select.value = ""
    this.next()
  }

  // ---- internals ----

  _steps() {
    return [...this.stepTargets].sort(
      (a, b) => Number(a.dataset.step) - Number(b.dataset.step)
    )
  }

  _render() {
    const steps = this._steps()
    steps.forEach((el, i) => (el.hidden = i !== this.index))

    this.progressTargets.forEach((dot, i) => {
      dot.classList.toggle("bg-cyan-400", i <= this.index)
      dot.classList.toggle("bg-slate-700", i > this.index)
    })

    const last = this.index === steps.length - 1
    const optional = this.stepIsOptional(this.index)

    this.backTarget.hidden = this.index === 0
    this.skipTarget.hidden = !optional
    this.nextTarget.hidden = last
    this.submitTarget.hidden = !last
    this.errorTarget.hidden = true
  }

  stepIsOptional(i) {
    // Step index 2 = "how did you hear about us" (optional/skippable).
    return Number(this._steps()[i].dataset.step) === 2
  }

  _validateStep(i) {
    const step = this._steps()[i]
    const radios = step.querySelectorAll("input[type=radio]")
    if (radios.length > 0 && ![...radios].some((r) => r.checked)) {
      this.errorTarget.hidden = false
      return false
    }
    this.errorTarget.hidden = true
    return true
  }

  _activateTab(name) {
    this.tabTargets.forEach((tab) => {
      const on = tab.dataset.tab === name
      tab.classList.toggle("bg-slate-950", on)
      tab.classList.toggle("text-white", on)
      tab.classList.toggle("text-slate-400", !on)
    })
  }
}
