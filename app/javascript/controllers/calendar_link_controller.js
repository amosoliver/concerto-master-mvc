import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  open(event) {
    if (!this.hasUrlValue) return
    if (event.target.closest("a, button, input, select, textarea, label, summary")) return

    if (event.type === "keydown") {
      if (event.key !== "Enter" && event.key !== " ") return
      event.preventDefault()
    }

    window.location = this.urlValue
  }
}
