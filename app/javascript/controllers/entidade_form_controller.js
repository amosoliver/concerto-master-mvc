import { Controller } from "@hotwired/stimulus"

const GEOCODER_URL = "https://nominatim.openstreetmap.org/search"

export default class extends Controller {
  static values = {
    estadoLabel: String,
    municipioLabel: String
  }

  static targets = [
    "estado",
    "municipio",
    "logradouro",
    "bairro",
    "cep",
    "latitude",
    "longitude",
    "mapFrame",
    "mapStatus",
    "mapLink"
  ]

  connect() {
    this.scheduleGeocode = this.debounce(() => this.geocodeAddress(), 700)
    if (this.hasEstadoTarget && this.hasMunicipioTarget) this.syncMunicipioState()
    this.renderMap()
  }

  async estadoChanged() {
    if (!this.hasEstadoTarget || !this.hasMunicipioTarget) return

    await this.loadMunicipios()
    this.scheduleGeocode()
  }

  addressChanged() {
    this.scheduleGeocode()
  }

  async loadMunicipios() {
    if (!this.hasEstadoTarget || !this.hasMunicipioTarget) return

    const estadoId = this.estadoTarget.value
    const selectedMunicipioId = this.municipioTarget.value

    if (!estadoId) {
      this.replaceMunicipioOptions([], "")
      return
    }

    this.mapStatus("Carregando municípios...")

    try {
      const response = await fetch(`/g_municipios.json?g_estado_id=${encodeURIComponent(estadoId)}`, {
        headers: { Accept: "application/json" }
      })

      if (!response.ok) throw new Error("Erro ao carregar municípios")

      const municipios = await response.json()
      const selectedStillExists = municipios.some((municipio) => String(municipio.id) === String(selectedMunicipioId))
      this.replaceMunicipioOptions(municipios, selectedStillExists ? selectedMunicipioId : "")
      this.mapStatus("Municípios atualizados.")
    } catch (_error) {
      this.replaceMunicipioOptions([], "")
      this.mapStatus("Não foi possível carregar os municípios.")
    }
  }

  async geocodeAddress() {
    if (!this.hasMapFrameTarget) return

    const query = this.addressQuery()
    if (query.length < 12) {
      this.clearCoordinates()
      this.renderMap()
      return
    }

    this.mapStatus("Localizando endereço no mapa...")

    try {
      const url = new URL(GEOCODER_URL)
      url.searchParams.set("format", "jsonv2")
      url.searchParams.set("limit", "1")
      url.searchParams.set("countrycodes", "br")
      url.searchParams.set("q", query)

      const response = await fetch(url.toString(), {
        headers: { Accept: "application/json" }
      })

      if (!response.ok) throw new Error("Erro ao consultar mapa")

      const [result] = await response.json()
      if (!result) {
        this.clearCoordinates()
        this.mapStatus("Endereço não encontrado. Revise os campos e tente novamente.")
        this.renderMap()
        return
      }

      this.latitudeTarget.value = result.lat
      this.longitudeTarget.value = result.lon
      this.mapStatus("Endereço localizado com sucesso.")
      this.renderMap()
    } catch (_error) {
      this.clearCoordinates()
      this.mapStatus("Não foi possível localizar o endereço agora.")
      this.renderMap()
    }
  }

  replaceMunicipioOptions(municipios, selectedId) {
    const select = this.municipioTarget
    const blankLabel = select.dataset.placeholder || "Selecione um município..."
    const options = [{ value: "", text: blankLabel }].concat(
      municipios.map((municipio) => ({ value: String(municipio.id), text: municipio.descricao }))
    )

    if (select.tomselect) {
      const control = select.tomselect
      control.clear(true)
      control.clearOptions()
      control.addOptions(options)
      control.refreshOptions(false)
      control.setValue(selectedId || "", true)
      control.sync()
    } else {
      select.innerHTML = ""
      options.forEach((option) => {
        const element = document.createElement("option")
        element.value = option.value
        element.textContent = option.text
        if (String(option.value) === String(selectedId)) element.selected = true
        select.appendChild(element)
      })
    }

    this.syncMunicipioState()
  }

  syncMunicipioState() {
    if (!this.hasEstadoTarget || !this.hasMunicipioTarget) return

    const hasEstado = this.estadoTarget.value.length > 0
    this.municipioTarget.disabled = !hasEstado

    if (this.municipioTarget.tomselect) {
      if (hasEstado) {
        this.municipioTarget.tomselect.enable()
      } else {
        this.municipioTarget.tomselect.disable()
        this.municipioTarget.tomselect.clear(true)
      }
    }
  }

  renderMap() {
    if (!this.hasMapFrameTarget) return

    const latitude = this.latitudeTarget.value
    const longitude = this.longitudeTarget.value

    if (!latitude || !longitude) {
      this.mapFrameTarget.removeAttribute("src")
      if (this.hasMapLinkTarget) this.mapLinkTarget.setAttribute("href", "#")
      return
    }

    const lat = Number(latitude)
    const lng = Number(longitude)
    const delta = 0.01
    const bbox = [lng - delta, lat - delta, lng + delta, lat + delta].join("%2C")
    const marker = `${lat}%2C${lng}`
    const embedUrl = `https://www.openstreetmap.org/export/embed.html?bbox=${bbox}&layer=mapnik&marker=${marker}`
    const linkUrl = `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=16/${lat}/${lng}`

    this.mapFrameTarget.src = embedUrl
    if (this.hasMapLinkTarget) this.mapLinkTarget.href = linkUrl
  }

  addressQuery() {
    return [
      this.logradouroTarget.value,
      this.bairroTarget.value,
      this.municipioLabel(),
      this.estadoLabel(),
      this.cepTarget.value,
      "Brasil"
    ].filter(Boolean).join(", ")
  }

  municipioLabel() {
    return this.hasMunicipioTarget ? this.municipioTarget.selectedOptions[0]?.textContent?.trim() : this.municipioLabelValue
  }

  estadoLabel() {
    return this.hasEstadoTarget ? this.estadoTarget.selectedOptions[0]?.textContent?.trim() : this.estadoLabelValue
  }

  clearCoordinates() {
    this.latitudeTarget.value = ""
    this.longitudeTarget.value = ""
  }

  mapStatus(message) {
    if (this.hasMapStatusTarget) this.mapStatusTarget.textContent = message
  }

  debounce(callback, wait) {
    let timeout

    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => callback.apply(this, args), wait)
    }
  }
}
