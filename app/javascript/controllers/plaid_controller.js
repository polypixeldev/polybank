import { Controller } from "@hotwired/stimulus"
import csrf from "common/csrf";

export default class extends Controller {
  connect() {
    console.log("hey")
  }

  link() {
    fetch("/plaid/generate_link_token", {
      method: "POST",
      headers: {
        'X-CSRF-Token': csrf(), 
      }
    }).then(r => r.json()).then(json => {
      const linkToken = json["link_token"]
      const handler = Plaid.create({
        token: linkToken,
        onSuccess: () => {
          console.log("done!")

          const url = new URL(window.location.href);
          url.pathname = "/plaid/linked"
          url.searchParams.set('link_token', linkToken)

          window.location.href = url.toString();
        },
        onLoad: () => {},
        onExit: (err, metadata) => {},
        onEvent: (eventName, metadata) => {},
      });

      handler.open()
    })
  }
}