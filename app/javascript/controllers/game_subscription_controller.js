import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"
import { Modal } from 'bootstrap'

export default class extends Controller {
  static targets = ["currentUser", "opponent", "button", "leftphrase", "rightphrase", "grid"]
  static values = { gameId: Number, currentUserId: Number }

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
    //   { received: data => console.log(data) }
    //   { received: data => this.userTarget.innerHTML = data.left_grid }
      { received: data => {
        console.log(data.paper_ball_throw);
        if (this.currentUserIdValue === data.current_user_id) {
          this.currentUserTarget.innerHTML = data.current_user_left_grid;
          this.opponentTarget.innerHTML = data.current_user_right_grid;
        } else {
          this.currentUserTarget.innerHTML = data.left_grid;
          this.opponentTarget.innerHTML = data.right_grid;
          this.buttonTarget.innerHTML = data.button;
          this.leftphraseTarget.innerHTML = data.leftphrase;
        }
        if (!data.ongoing) {
          this.myModal = new Modal(document.getElementById('victory_modal'), {
            keyboard: false
          })
          this.myModal.show();
          const title = document.getElementById("staticBackdropLabel")
          if (this.currentUserIdValue === data.current_user_id) {
            title.innerHTML = "<img class='result-game' src='/assets/trophy_new.png'>  Victory!  <img class='result-game' src='/assets/trophy_new.png'>";
          } else {
            title.innerHTML = "<img class='result-game' src='/assets/disappointed-face.png'> Game over... <img class='result-game' src='/assets/disappointed-face.png'>";

          }
        } else {
          if (data.paper_ball_throw) {
            this.throwPaperBalls(data.grid_target)
          }
        }
        }
      }
    )
    // console.log("Ready to play !")
  }

  throwPaperBalls(target) {
    console.log(target)
    console.log("lancé de bouletteeeeeesss")
    console.log(this.gridTargets);
    const gridToTarget = this.gridTargets.find((grid) => grid.dataset.gridId === `${target}`)
    console.log(gridToTarget);
    const tds = gridToTarget.querySelectorAll('td')
    const randomTds = this.getRandomElements(tds)
    console.log(randomTds);
    randomTds.forEach((el) => el.classList.add('paper-animation'))

  }

  getRandomElements(elements) {
    const randomElements = []
    for (let index = 0; index < 4; index++) {
      const randomNumber = Math.floor(Math.random() * elements.length)
      const randomElement = elements[randomNumber];
      console.log(randomElement);
      randomElements.push(randomElement)
    }
    return randomElements
  }
  // disconnect() {
  //   console.log("Unsubscribed from the game")
  //   this.channel.unsubscribe()
  // }
}
