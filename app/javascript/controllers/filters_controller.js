import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "toggleButton"]
  static values = { active: Boolean }

  connect() {
    this.show(this.activeValue)
  }

  toggle() {
    this.show(this.panelTarget.hidden)
  }

  show(visible) {
    this.panelTarget.hidden = !visible
    this.toggleButtonTarget.classList.toggle("is-active", visible)
    this.toggleButtonTarget.setAttribute("aria-expanded", String(visible))
  }
}
