import { Controller } from "@hotwired/stimulus"

// A drag-and-drop upload zone. The controller is on the <form>; dropping or picking a file
// submits the form, which uploads to UploadThing server-side.
export default class extends Controller {
  static targets = ["input", "zone", "label"]

  open() { this.inputTarget.click() }

  dragover(event) {
    event.preventDefault()
    this.zoneTarget.classList.add("ring-2", "ring-cyan-400", "bg-white/[0.06]")
  }

  dragleave() {
    this.zoneTarget.classList.remove("ring-2", "ring-cyan-400", "bg-white/[0.06]")
  }

  drop(event) {
    event.preventDefault()
    this.zoneTarget.classList.remove("ring-2", "ring-cyan-400", "bg-white/[0.06]")
    if (event.dataTransfer.files.length) {
      this.inputTarget.files = event.dataTransfer.files
      this.submit()
    }
  }

  change() {
    if (this.inputTarget.files.length) this.submit()
  }

  submit() {
    if (this.hasLabelTarget) this.labelTarget.textContent = "Uploading…"
    this.element.requestSubmit()
  }
}
