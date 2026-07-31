import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switchToken(event) {
    const form = this.element
    const csrfInput = form.querySelector('input[name="authenticity_token"]')
    csrfInput.value = event.params.token
  }
}