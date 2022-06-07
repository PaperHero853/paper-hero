import { Controller } from "stimulus"
 
export default class extends Controller {
  static targets = [ "td" ]

  paper() {
   if (this.tdTarget.dataset.count === "4") {
     const randomTds = []
     for (let index = 0; index < 4; index++) {
      const element = array[index];
      const randomTd = this.tdTargets[Math.floor(Math.random()*this.tdTargets.length)];
      console.log(randomTd);
      randomTds.push(randomTd)
     }
      console.log(randomTds);
   }
/*     this.tdTargets[140].classList.add('paper-animation')
 */    // this.tdTarget.classList.add('paper-animation')
  }
}
