
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "radioBtn" ]

  connect() {
    console.log("yeaah")
  }
  toggleCheckedClass(event) {
    this.radioBtnTargets.forEach((input) => {
      input.checked ? input.classList.add("checked") : input.classList.remove("checked")
    })
  }
  
}