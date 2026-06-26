import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table", "cards", "tableButton", "cardsButton"]

  connect() {
    this.show(localStorage.getItem("concreto-view") || "table")
  }

  showTable() { this.show("table") }
  showCards() { this.show("cards") }

  show(mode) {
    this.tableTarget.hidden = mode !== "table"
    this.cardsTarget.hidden = mode !== "cards"
    this.tableButtonTarget.classList.toggle("is-active", mode === "table")
    this.cardsButtonTarget.classList.toggle("is-active", mode === "cards")
    localStorage.setItem("concreto-view", mode)
  }
}
