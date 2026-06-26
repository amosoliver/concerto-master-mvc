import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

const ICONS = {
  notice: "success",
  alert: "error",
  warning: "warning",
}

export default class extends Controller {
  static values = { type: String, message: String }

  connect() {
    if (!this.messageValue) return

    Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 4000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener("mouseenter", Swal.stopTimer)
        toast.addEventListener("mouseleave", Swal.resumeTimer)
      },
    }).fire({
      icon: ICONS[this.typeValue] || "info",
      title: this.messageValue,
    })
  }
}
