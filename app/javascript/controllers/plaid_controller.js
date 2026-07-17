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
      const handler = Plaid.create({
        token: json["link_token"],
        onSuccess: (public_token, metadata) => {
          console.log("GOT PUBLIC TOKEN!")
          console.log(public_token)
          window.location.path = `/plaid/linked?public_token=${public_token}`

          const url = new URL(window.location.href);
          url.pathname = "/plaid/linked"
          url.searchParams.set('public_token', public_token)

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