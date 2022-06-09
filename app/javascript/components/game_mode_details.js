const gameModeDetails = () => {
  const gameMode = document.querySelector('.form-range');
  const gameModeText = document.querySelector('.game-mode-details');

  if (gameMode) {
    gameMode.addEventListener('click', (event) => {
      gameModeText.innerHTML = "";

      if (gameMode.value == 6) {
        gameModeText.insertAdjacentHTML('afterbegin',
          `<h3>Easy mode:</h3>
          <hr>
          <ul>
            <li>Grid size: 6x6</li>
            <li>Office space: 2 desks</li>
              <ul>
                <li>1 employee desk (2x2)</li>
                <li>1 intern desk (2x1)</li>
              </ul>
          </ul>`
        )
      } else if (gameMode.value == 10) {
        gameModeText.insertAdjacentHTML('afterbegin',
          `<h3>Normal mode:</h3>
          <hr>
          <ul>
            <li>Grid size: 10x10</li>
            <li>Office space: 4 desks</li>
              <ul>
                <li>1 manager desk (3x2)</li>
                <li>2 employee desk (2x2)</li>
                <li>1 intern desk (2x1)</li>
              </ul>
          </ul>`
        )
      } else {
        gameModeText.insertAdjacentHTML('afterbegin',
          `<h3>Hard mode:</h3>
          <hr>
          <ul>
            <li>Grid size: 14x14</li>
            <li>Office space: 6 desks</li>
              <ul>
                <li>1 manager desk (3x2)</li>
                <li>3 employee desk (2x2)</li>
                <li>2 intern desk (2x1)</li>
              </ul>
          </ul>`
        )
      }
    })
  }
}

export { gameModeDetails };
