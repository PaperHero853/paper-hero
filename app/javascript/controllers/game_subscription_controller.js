import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"
import { Modal } from 'bootstrap'

export default class extends Controller {
  static targets = ["user", "opponent", "button", "leftphrase", "rightphrase"]
  static values = { gameId: Number }

  connect() {
    this.myModal = new Modal(document.getElementById('victory_modal'), {
      keyboard: false
    })
    this.channel = consumer.subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
    //   { received: data => console.log(data) }
    //   { received: data => this.userTarget.innerHTML = data.left_grid }
      { received: data => {
        this.userTarget.innerHTML = data.left_grid;
        this.opponentTarget.innerHTML = data.right_grid;
        this.buttonTarget.innerHTML = data.button;
        this.leftphraseTarget.innerHTML = data.leftphrase;
        if (!data.ongoing) {
          this.myModal.show();
        }
        }
      }
    )
    // console.log("Ready to play !")
  }
  // disconnect() {
  //   console.log("Unsubscribed from the game")
  //   this.channel.unsubscribe()
  // }
}
