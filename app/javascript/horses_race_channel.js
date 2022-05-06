let horsesImgs = [...document.querySelectorAll(".horse")];

let currentSelected = horseSelection.querySelector("div");
currentSelected.className = "selected";

horseSelection.onclick = (e) => {
  if (e.target.tagName == "H1") return;
  currentSelected.className = "";
  currentSelected = e.target;
  currentSelected.className = "selected";
};

btnBet.onclick = () => {
  channel.send({
    type: "bet",
    bet: { num: currentSelected.textContent, amount: amountInput.value },
  });
  btnBet.disabled = true;
};

const channel = window.consumer.subscriptions.create("HorsesRaceChannel", {
  connected() {
    console.log("Hello");
  },

  received(msg) {
    actions[msg.type](msg.data);
  },
});

// function chat(msg) {
//   messages.insertAdjacentHTML("afterbegin", `<p>${msg}</p>`);
// }

const actions = {
  info({ phase, bets, winner }) {
    actions.updateBets(bets);
    actions[phase](winner);
  },
  betsTime() {
    announcement.textContent = `Bets Time!`;
  },
  updateHorses(horses) {
    horses.forEach(
      (horse, i) =>
        (horsesImgs[i].style.left = `calc(${horse.pos / 10}% - 100px)`)
    );
  },
  gameOver(winner) {
    btnBet.disabled = true;
    announcement.textContent = `Winner is: ${winner}`;
  },
  running() {
    btnBet.disabled = true;
    announcement.textContent = "Running";
  },
  starting(seconds) {
    announcement.textContent = `Starting: ${seconds}`;
    if (seconds == 0) actions.running();
  },
  updateBets(bets) {
    betsTable.innerHTML = bets.map(createBetRow).join("");
  },
  reset() {
    betsTable.innerHTML = "";
    announcement.textContent = `Bets Time!`;
    horsesImgs.forEach((horse) => (horse.style.left = "calc(0% - 100px)"));
    btnBet.disabled = false;
  },
  updateCoins(coins) {
    updateCoins(coins);
  },
};

function format(result) {
  if (!result) return `<td>---</td>`;
  if (result > 0) return `<td class="green">+${result}</td>`;
  return `<td class="red">${result}</td>`;
}

function createBetRow(bet) {
  return `<tr>
            <td>${bet.user_name}</td>
            <td>${bet.num}</td>
            <td>${bet.amount}</td>
            ${format(bet.result)}
          </tr>`;
}

// let messages = document.querySelector("#messages");
// let input = document.querySelector("#txt");

// document.querySelector("#btn").onclick = () => {
//   channel.send({ type: "msg", msg: input.value });
//   input.value = "";
// };
