import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button"]

  connect() {
    this.outsideClick = this.outsideClick.bind(this)
    this.closeOthers = this.closeOthers.bind(this)
    this.closeOnScroll = this.closeOnScroll.bind(this)
    document.addEventListener("click", this.outsideClick)
    window.addEventListener("dropdown:open", this.closeOthers)
    window.addEventListener("scroll", this.closeOnScroll, true)

    // Stop tracking this as a Stimulus target once it's reparented:
    // keep a plain reference instead, since moving it out of `element`
    // makes Stimulus drop it from `panelTarget`.
    this.panel = this.panelTarget
    this.panel.style.position = "fixed"
    document.body.appendChild(this.panel)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick)
    window.removeEventListener("dropdown:open", this.closeOthers)
    window.removeEventListener("scroll", this.closeOnScroll, true)
    this.panel.remove()
  }

  toggle(event) {
    event.stopPropagation()
    this.panel.hidden ? this.open() : this.close()
  }

  open() {
    window.dispatchEvent(new CustomEvent("dropdown:open", { detail: this.element }))
    this.panel.hidden = false
    this.reposition()
    this.buttonTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    this.panel.hidden = true
    this.buttonTarget.setAttribute("aria-expanded", "false")
  }

  reposition() {
    const vw = window.innerWidth

    if (vw <= 780) {
      // Bottom sheet on mobile/tablet: ignore button position entirely.
      // CSS handles the visual anchoring (see @media max-width:780px rules).
      this.panel.style.removeProperty("top")
      this.panel.style.removeProperty("left")
      this.panel.style.removeProperty("maxHeight")
      return
    }

    const rect = this.buttonTarget.getBoundingClientRect()
    const vh = window.innerHeight
    const margin = 8
    const gap = 6

    // Horizontal: align to button's right edge, clamped to viewport.
    const left = Math.min(
      Math.max(margin, rect.right - this.panel.offsetWidth),
      vw - this.panel.offsetWidth - margin
    )

    // Vertical: prefer below the button; open upward if more space above.
    const spaceBelow = vh - rect.bottom - gap - margin
    const spaceAbove = rect.top - gap - margin
    let top
    if (spaceBelow >= this.panel.offsetHeight || spaceBelow >= spaceAbove) {
      top = Math.min(rect.bottom + gap, vh - this.panel.offsetHeight - margin)
    } else {
      top = Math.max(margin, rect.top - this.panel.offsetHeight - gap)
    }

    this.panel.style.top = `${Math.max(margin, top)}px`
    this.panel.style.left = `${Math.max(margin, left)}px`
    this.panel.style.maxHeight = `${vh - margin * 2}px`
  }

  closeOthers(event) {
    if (event.detail !== this.element) this.close()
  }

  closeOnScroll(event) {
    if (!this.panel.hidden && !this.panel.contains(event.target)) this.close()
  }

  outsideClick(event) {
    if (!this.element.contains(event.target) && !this.panel.contains(event.target)) this.close()
  }
}
