import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    const activeTab = this.tabTargets.find((tab) => tab.classList.contains("is-active")) || this.tabTargets[0]
    if (activeTab) this.activate(activeTab.dataset.instrumentTabsPanelIdParam)
  }

  show(event) {
    this.activate(event.currentTarget.dataset.instrumentTabsPanelIdParam)
  }

  activate(panelId) {
    this.tabTargets.forEach((tab) => {
      const active = tab.dataset.instrumentTabsPanelIdParam === panelId
      tab.classList.toggle("is-active", active)
      tab.setAttribute("aria-selected", active)
    })

    this.panelTargets.forEach((panel) => {
      panel.hidden = panel.id !== panelId
    })
  }
}
