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
    const rect = this.buttonTarget.getBoundingClientRect()
    this.panel.style.top = `${rect.bottom + 6}px`
    this.panel.style.left = `${Math.max(8, rect.right - this.panel.offsetWidth)}px`
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
