import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entidadeSelect", "groupItem", "groupCheckbox", "instrumentoItem", "perfilItem", "groupsEmpty", "instrumentosEmpty", "perfisEmpty"]
  static values = { selectedFuncaoIds: String }

  connect() {
    this.filterGroups()
    this.filterInstrumentos()
    this.filterPerfis()
  }

  filterGroups() {
    if (!this.hasEntidadeSelectTarget) return

    const entidadeId = this.entidadeSelectTarget.value
    let visibleCount = 0

    this.groupItemTargets.forEach((item) => {
      const visible = !entidadeId || item.dataset.entidadeId === entidadeId
      this.toggleItem(item, visible)
      if (visible) visibleCount += 1

      const checkbox = item.querySelector('input[type="checkbox"]')
      if (!visible && checkbox) checkbox.checked = false
    })

    if (this.hasGroupsEmptyTarget) {
      this.groupsEmptyTarget.hidden = visibleCount > 0
    }
  }

  filterInstrumentos() {
    if (this.hasEntidadeSelectTarget) this.filterGroups()
    if (!this.hasInstrumentoItemTarget) return

    const selectedGroupIds = this.groupCheckboxTargets
      .filter((checkbox) => checkbox.checked && !checkbox.closest("[hidden]"))
      .map((checkbox) => String(checkbox.value))

    let visibleCount = 0

    this.instrumentoItemTargets.forEach((item) => {
      const allowedGroupIds = (item.dataset.grupoIds || "").split(",").filter(Boolean)
      const visible = selectedGroupIds.length > 0 && allowedGroupIds.some((groupId) => selectedGroupIds.includes(groupId))
      this.toggleItem(item, visible)
      if (visible) visibleCount += 1

      const checkbox = item.querySelector('input[type="checkbox"]')
      if (!visible && checkbox) checkbox.checked = false
    })

    if (this.hasInstrumentosEmptyTarget) {
      this.instrumentosEmptyTarget.hidden = visibleCount > 0
    }
  }

  filterPerfis() {
    if (!this.hasPerfilItemTarget) return

    const selectedFuncaoIds = (this.selectedFuncaoIdsValue || "").split(",").filter(Boolean)
    let visibleCount = 0

    this.perfilItemTargets.forEach((item) => {
      const allowedFuncaoIds = (item.dataset.funcaoIds || "").split(",").filter(Boolean)
      const visible = selectedFuncaoIds.length > 0 && allowedFuncaoIds.some((funcaoId) => selectedFuncaoIds.includes(funcaoId))
      this.toggleItem(item, visible)
      if (visible) visibleCount += 1

      const checkbox = item.querySelector('input[type="checkbox"]')
      if (!visible && checkbox) checkbox.checked = false
    })

    if (this.hasPerfisEmptyTarget) {
      this.perfisEmptyTarget.hidden = visibleCount > 0
    }
  }

  toggleItem(item, visible) {
    item.hidden = !visible
    item.classList.toggle("is-hidden", !visible)
  }
}
