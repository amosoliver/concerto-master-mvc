import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["musicaCheckbox", "grupoContainer"]

  connect() {
    this.sync()
  }

  toggleMusica(event) {
    const checkbox = event.currentTarget
    const itemKey = checkbox.dataset.itemKey
    const container = this.grupoContainerTargets.find((target) => target.dataset.itemKey === itemKey)
    if (!container) return

    const enabled = checkbox.checked
    container.classList.toggle("is-disabled", !enabled)

    container.querySelectorAll('input[type="checkbox"]').forEach((groupCheckbox) => {
      groupCheckbox.disabled = !enabled
      groupCheckbox.checked = enabled ? groupCheckbox.checked : false
    })
  }

  sync() {
    this.musicaCheckboxTargets.forEach((checkbox) => {
      this.toggleMusica({ currentTarget: checkbox })
    })
  }
}
