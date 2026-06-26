import { Controller } from "@hotwired/stimulus"

// Forces the field to uppercase as the user types. The same normalization
// also happens server-side (Uppercasable concern), so this is purely visual.
export default class extends Controller {
  connect() {
    this.element.addEventListener("input", this.upcase)
  }

  disconnect() {
    this.element.removeEventListener("input", this.upcase)
  }

  upcase = () => {
    const { selectionStart, selectionEnd } = this.element
    this.element.value = this.element.value.toUpperCase()
    this.element.setSelectionRange(selectionStart, selectionEnd)
  }
}
