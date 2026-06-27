import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entidadeSelect", "groupItem", "groupCheckbox", "instrumentoItem", "perfilItem", "principalFuncaoSelect", "groupsEmpty", "instrumentosEmpty", "perfisEmpty"]
  static values = { selectedFuncaoIds: String }

  connect() {
    this.filterGroups()
    this.filterInstrumentos()
    this.syncPrincipalFuncoes()
    this.filterPerfis()
  }

  syncEntity() {
    this.clearChecks(this.groupCheckboxTargets)
    this.clearChecks(this.instrumentCheckboxes)
    this.filterGroups()
    this.filterInstrumentos()
  }

  syncFuncoes() {
    this.syncPrincipalFuncoes()
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

    const selectedFuncaoIds = this.selectedFunctionIds()
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

  syncPrincipalFuncoes() {
    if (!this.hasPrincipalFuncaoSelectTarget) return

    const selectedFuncaoIds = this.selectedFunctionIds()
    const select = this.principalFuncaoSelectTarget
    let currentValueAllowed = false

    Array.from(select.options).forEach((option) => {
      if (option.value === "") {
        option.hidden = false
        option.disabled = false
        return
      }

      const allowed = selectedFuncaoIds.includes(option.value)
      option.hidden = !allowed
      option.disabled = !allowed
      currentValueAllowed ||= allowed && option.value === select.value
    })

    if (!currentValueAllowed) {
      select.value = ""
    }
  }

  clearChecks(checkboxes) {
    checkboxes.forEach((checkbox) => {
      checkbox.checked = false
    })
  }

  get instrumentCheckboxes() {
    return this.instrumentoItemTargets
      .map((item) => item.querySelector('input[type="checkbox"]'))
      .filter(Boolean)
  }

  get functionCheckboxes() {
    return Array.from(this.element.querySelectorAll('input[name="g_pessoa[u_funcao_ids][]"]'))
  }

  selectedFunctionIds() {
    const checkedIds = this.functionCheckboxes
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => String(checkbox.value))

    if (checkedIds.length > 0) return checkedIds

    return (this.selectedFuncaoIdsValue || "").split(",").filter(Boolean)
  }
}
