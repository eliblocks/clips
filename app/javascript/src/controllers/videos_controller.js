import { Controller } from "stimulus"

export default class extends Controller {
  login() {
    $("#login-modal").modal()
  }
}