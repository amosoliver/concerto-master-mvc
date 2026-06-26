import { Controller } from "@hotwired/stimulus"

// Visual input mask only: formats the field as the user types (cpf, cep, ...).
// The unmasked value is normalized server-side before saving, so the digits
// are never persisted with the mask punctuation.
const MAX_LENGTH = { cpf: 11, cep: 8 }

const MASKS = {
  cpf: (digits) =>
    digits
      .replace(/^(\d{3})(\d)/, "$1.$2")
      .replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3")
      .replace(/^(\d{3})\.(\d{3})\.(\d{3})(\d{1,2})$/, "$1.$2.$3-$4"),
  cep: (digits) => digits.replace(/^(\d{5})(\d)/, "$1-$2")
}

export default class extends Controller {
  static values = { pattern: String }

  connect() {
    this.format()
    this.element.addEventListener("input", this.format)
  }

  disconnect() {
    this.element.removeEventListener("input", this.format)
  }

  format = () => {
    const digits = this.element.value.replace(/\D/g, "").slice(0, MAX_LENGTH[this.patternValue])
    this.element.value = MASKS[this.patternValue](digits)
  }
}
