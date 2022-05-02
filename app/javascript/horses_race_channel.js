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

window.channel = window.consumer.subscriptions.create("HorsesRaceChannel", {
  connected() {
    console.log("Hello");
  },

  received(data) {
    if (data.type == "info") {
      updateBets(data.bets);
      if (data.phase == "running") running();
      if (data.phase == "raceEnd") raceEnd(data.winner);
      if (data.phase == "betsTime") announcement.textContent = `BetsTime!`;
    }

    if (data.type == "chat") chat(data.msg);
    if (data.type == "moveHorses") moveHorses(data.horses);
    if (data.type == "raceEnd") raceEnd(data.winner);
    if (data.type == "starting") starting(data.seconds);
    if (data.type == "updateBets") updateBets(data.bets);
    if (data.type == "reset") reset();
  },
});

// function chat(msg) {
//   messages.insertAdjacentHTML("afterbegin", `<p>${msg}</p>`);
// }

function updateBets(bets) {
  betsTable.innerHTML = bets
    .map(
      (bet) =>
        `<tr>
          <td>${bet.user_name}</td>
          <td>${bet.num}</td>
          <td>${bet.amount}</td>
          ${format(bet.result)}
        </tr>`
    )
    .join("");
}

function format(result) {
  if (!result) return `<td>---</td>`;
  if (result > 0) return `<td class="green">+${result}</td>`;
  return `<td class="red">${result}</td>`;
}

function starting(seconds) {
  announcement.textContent = `Starting: ${seconds}`;
  if (seconds == 0) running();
}

function running() {
  btnBet.disabled = true;
  announcement.textContent = "Running";
}

function raceEnd(winner) {
  announcement.textContent = `Winner is: ${winner}`;
}

function moveHorses(horses) {
  horses.forEach(
    (horse, i) =>
      (horsesImgs[i].style.left = `calc(${horse.pos / 10}% - 100px)`)
  );
}

function reset() {
  betsTable.innerHTML = "";
  announcement.textContent = `Bet Time!`;
  horsesImgs.forEach((horse) => (horse.style.left = "calc(0% - 100px)"));
  btnBet.disabled = false;
}

// let messages = document.querySelector("#messages");
// let input = document.querySelector("#txt");

// document.querySelector("#btn").onclick = () => {
//   channel.send({ type: "msg", msg: input.value });
//   input.value = "";
// };
