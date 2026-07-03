import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table", "cards", "tableButton", "cardsButton"]

  connect() {
    this.mediaQuery = window.matchMedia("(max-width: 980px)")
    this.handleViewportChange = () => this.syncWithViewport()
    this.mediaQuery.addEventListener("change", this.handleViewportChange)
    this.syncWithViewport()
  }

  disconnect() {
    this.mediaQuery?.removeEventListener("change", this.handleViewportChange)
  }

  showTable() { this.show("table") }
  showCards() { this.show("cards") }

  syncWithViewport() {
    this.show(this.mediaQuery.matches ? "cards" : "table")
  }

  show(mode) {
    this.tableTarget.hidden = mode !== "table"
    this.cardsTarget.hidden = mode !== "cards"
    this.tableButtonTarget.classList.toggle("is-active", mode === "table")
    this.cardsButtonTarget.classList.toggle("is-active", mode === "cards")
  }
}
