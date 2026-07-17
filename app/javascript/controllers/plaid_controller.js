import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const handler = Plaid.create({
      token: 'link',
      onSuccess: (public_token, metadata) => {},
      onLoad: () => {},
      onExit: (err, metadata) => {},
      onEvent: (eventName, metadata) => {},
    });
  }
}