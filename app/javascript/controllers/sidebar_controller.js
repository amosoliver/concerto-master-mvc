import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay", "toggle"]

  connect() {
    this.onKeydown = this.onKeydown.bind(this)
    document.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  toggle() {
    const isOpen = this.panelTarget.classList.toggle("is-open")
    this.overlayTarget.classList.toggle("is-open", isOpen)
    this.toggleTarget.setAttribute("aria-expanded", String(isOpen))
  }

  close() {
    this.panelTarget.classList.remove("is-open")
    this.overlayTarget.classList.remove("is-open")
    this.toggleTarget.setAttribute("aria-expanded", "false")
  }

  onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
