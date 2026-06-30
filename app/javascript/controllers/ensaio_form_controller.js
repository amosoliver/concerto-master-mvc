import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["eventoCheckbox", "eventoSection", "musicaCheckbox"]

  connect() {
    this.refresh()
  }

  toggleEvento(event) {
    const checkbox = event.currentTarget
    const eventId = checkbox.dataset.eventId
    const section = this.eventoSectionTargets.find((target) => target.dataset.eventId === eventId)

    if (section) {
      section.hidden = !checkbox.checked
    }

    this.musicaCheckboxTargets
      .filter((target) => target.dataset.eventId === eventId)
      .forEach((target) => {
        target.checked = checkbox.checked
      })
  }

  refresh() {
    const selectedIds = this.eventoCheckboxTargets
      .filter((target) => target.checked)
      .map((target) => target.dataset.eventId)

    this.eventoSectionTargets.forEach((target) => {
      target.hidden = !selectedIds.includes(target.dataset.eventId)
    })
  }
}
