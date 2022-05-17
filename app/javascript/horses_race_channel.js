function addActions(ele) {
  ele.hide = () => ele.classList.add("hidden");
  ele.show = () => ele.classList.remove("hidden");
  ele.enable = () => (ele.disabled = false);
  ele.disable = () => (ele.disabled = true);
}

addActions(bet);

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
  bet.hide();
  horseSelection.style.pointerEvents = "none";
};

const channel = window.consumer.subscriptions.create("HorsesRaceChannel", {
  connected() {
    console.log("Hello");
  },

  received(msg) {
    actions[msg.type](msg.data);
  },
});

const actions = {
  info({ phase, bets, winner, betted }) {
    actions[phase](winner);
    actions.updateBets(bets);
    if (betted) {
      currentSelected.className = "";
      currentSelected = horseSelection.querySelectorAll("div")[betted - 1];
      currentSelected.className = "selected";
      horseSelection.style.pointerEvents = "none";
      bet.hide();
    }
  },
  betsTime() {
    betsTable.innerHTML = "";
    announcement.textContent = `Bets Time!`;
    horsesImgs.forEach((horse) => (horse.style.left = "calc(0% - 90px)"));
    bet.show();
    horseSelection.style.pointerEvents = "auto";
  },
  updateHorses(horses) {
    horses.forEach(
      (horse, i) =>
        (horsesImgs[i].style.left = `calc(${horse.pos / 10}% - 90px)`)
    );
  },
  gameOver(winner) {
    bet.hide();
    announcement.textContent = `Winner is: ${winner}`;
    horseSelection.style.pointerEvents = "none";
  },
  running() {
    bet.hide();
    announcement.textContent = "Running";
    horseSelection.style.pointerEvents = "none";
  },
  starting(seconds) {
    announcement.textContent = `Starting: ${seconds}`;
    if (seconds == 0) actions.running();
  },
  updateBets(bets) {
    betsTable.innerHTML = bets.map(createBetRow).join("");
  },
  reset() {
    actions.betsTime();
  },
  updateCoins(coins) {
    amountInput.max = coins;
    updateCoins(coins);
  },
};

function format(result) {
  if (!result) return `<td></td>`;
  if (result > 0) return `<td class="green">+${result}</td>`;
  return `<td class="red">${result}</td>`;
}

function createBetRow(bet) {
  return `<tr>
            <td>${bet.user}</td>
            <td>${bet.num}</td>
            <td>$${bet.amount}</td>
            ${format(bet.result)}
          </tr>`;
}

// let messages = document.querySelector("#messages");
// let input = document.querySelector("#txt");

// document.querySelector("#btn").onclick = () => {
//   channel.send({ type: "msg", msg: input.value });
//   input.value = "";
// };
