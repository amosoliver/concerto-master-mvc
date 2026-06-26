import { Controller } from "@hotwired/stimulus"

// Enhances every native <select> inside this element (a <form>, typically)
// with Tom Select so it gets search + a styling hook ("select2-like") that
// actually matches .form-control instead of the bare browser widget.
//
// Tom Select is loaded as a plain vendored UMD script (see the layout), not
// through the importmap: its npm ESM build splits across many files with
// relative imports that only resolve against its own CDN tree, so a single
// pinned/downloaded entry file 404s on its siblings once served locally.
export default class extends Controller {
  connect() {
    if (!window.TomSelect) return

    this.instances = Array.from(this.element.querySelectorAll("select")).map((select) => {
      const instance = new window.TomSelect(select, {
        create: false,
        onInitialize: function() {
          syncDisabledState(this)
          syncPlaceholder(this)
        },
        onChange: function() {
          syncDisabledState(this)
          syncPlaceholder(this)
        },
      })

      syncDisabledState(instance)
      syncPlaceholder(instance)
      return instance
    })
  }

  disconnect() {
    this.instances?.forEach((instance) => instance.destroy())
    this.instances = []
  }
}

function syncPlaceholder(instance) {
  if (!instance?.control_input) return

  instance.control_input.placeholder = instance.items.length ? "" : placeholderText(instance)
}

function syncDisabledState(instance) {
  if (!instance) return

  const hasRealOptions = instance.options && Object.keys(instance.options).length > 0
  instance.control_input.disabled = !hasRealOptions
  instance.wrapper.classList.toggle("is-disabled", !hasRealOptions)
}

function placeholderText(instance) {
  const hasRealOptions = instance.options && Object.keys(instance.options).length > 0
  return hasRealOptions ? instance.settings.placeholder || "" : "Nenhum dado disponível"
}
