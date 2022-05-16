function addActions(ele) {
  ele.hide = () => ele.classList.add("hidden");
  ele.show = () => ele.classList.remove("hidden");
  ele.enable = () => (ele.disabled = false);
  ele.disable = () => (ele.disabled = true);
}

addActions(bet);
addActions(btnLeft);
addActions(explosion);
addActions(ship);

btnBet.onclick = () => {
  channel.send({
    type: "bet",
    bet: { amount: amountInput.value },
  });
  bet.hide();
  btnLeft.show();
};

btnLeft.onclick = () => {
  channel.send({ type: "left" });
  btnLeft.disable();
};

const channel = window.consumer.subscriptions.create("SpaceShipChannel", {
  connected() {
    console.log("Hello");
  },

  received(msg) {
    actions[msg.type](msg.data);
  },
});

const actions = {
  info({ phase, bets }) {
    actions.updateBets(bets);
    actions[phase]();
  },
  betsTime() {
    payElem.textContent = "x1.00";
    betsTable.innerHTML = "";
    announcement.textContent = `Bets Time!`;
    bet.show();
    btnLeft.hide();
    btnLeft.disable();
    explosion.hide();
    ship.show();
    ship.classList.remove("move");
  },
  updatePayment(payment) {
    payElem.textContent = "x" + payment;
  },
  gameOver() {
    announcement.textContent = "Game over";
    ship.hide();
    explosion.show();
    btnLeft.disable();
  },
  flying() {
    bet.hide();
    btnLeft.show();
    btnLeft.enable();
    ship.show();
    ship.classList.add("move");
    announcement.textContent = "Flying";
  },
  starting(seconds) {
    announcement.textContent = `Starting: ${seconds}`;
    if (seconds == 0) actions.flying();
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
  if (result < 0) return `<td class="red">${result}</td>`;
  return `<td class="green">${result}</td>`;
}

function createBetRow(bet) {
  return `<tr>
            <td>${bet.user_name}</td>
            <td>${bet.amount}</td>
            ${format(bet.result)}
          </tr>`;
}
