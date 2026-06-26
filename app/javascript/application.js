// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import Swal from "sweetalert2"

Turbo.config.forms.confirm = (message) =>
  Swal.fire({
    title: message,
    icon: "warning",
    showCancelButton: true,
    reverseButtons: true,
    focusCancel: true,
    confirmButtonText: "Sim, excluir",
    cancelButtonText: "Cancelar",
    confirmButtonColor: "#ef4444",
    cancelButtonColor: "#64748b",
  }).then((result) => result.isConfirmed)
