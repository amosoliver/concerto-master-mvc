import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const savedTheme = localStorage.getItem("concreto-theme") || "light"
    this.applyTheme(savedTheme)
  }

  toggle() {
    const nextTheme = document.documentElement.dataset.theme === "dark" ? "light" : "dark"
    this.applyTheme(nextTheme)
  }

  applyTheme(theme) {
    document.documentElement.dataset.theme = theme
    localStorage.setItem("concreto-theme", theme)
    document.documentElement.style.colorScheme = theme
  }
}
