import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "item", "destroyField"]
  static values = { index: Number }

  add() {
    const html = this.templateTarget.innerHTML.replaceAll("__INDEX__", String(this.indexValue))
    this.containerTarget.insertAdjacentHTML("beforeend", html)
    this.indexValue += 1
  }

  remove(event) {
    const item = event.currentTarget.closest('[data-grupo-builder-target="item"]')
    if (!item) return

    const destroyField = item.querySelector('[data-grupo-builder-target="destroyField"]')
    if (destroyField) {
      destroyField.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }
}
