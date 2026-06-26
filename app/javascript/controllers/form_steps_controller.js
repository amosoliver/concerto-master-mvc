import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "tab"]

  connect() {
    this.index = 0
    this.render()
  }

  next() {
    if (this.index < this.stepTargets.length - 1) {
      this.index += 1
      this.render()
    }
  }

  previous() {
    if (this.index > 0) {
      this.index -= 1
      this.render()
    }
  }

  goTo(event) {
    this.index = Number(event.currentTarget.dataset.step)
    this.render()
  }

  render() {
    this.stepTargets.forEach((step, index) => {
      step.hidden = index !== this.index
    })

    this.tabTargets.forEach((tab, index) => {
      tab.classList.toggle("is-active", index === this.index)
    })
  }
}
