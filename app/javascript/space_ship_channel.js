btnBet.onclick = () => {
  channel.send({
    type: "bet",
    bet: { amount: amountInput.value },
  });
  btnBet.disabled = true;
};

btnLeft.onclick = () => {
  channel.send({ type: "left" });
  btnLeft.disabled = true;
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
    announcement.textContent = `Bets Time!`;
    btnLeft.disabled = true;
  },
  updatePayment(payment) {
    payElem.textContent = "x" + payment;
  },
  gameOver() {
    announcement.textContent = "Game over";
    explosion.className = "show";
    ship.className = "hidden";
    btnLeft.disabled = true;
  },
  flying() {
    btnBet.disabled = true;
    btnLeft.disabled = false;
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
    payElem.textContent = "x1.00";
    betsTable.innerHTML = "";
    announcement.textContent = `Bets Time!`;
    btnBet.disabled = false;
    btnLeft.disabled = false;
    explosion.className = "hidden";
    ship.className = "show";
  },
  updateCoins(coins) {
    amountInput.max = coins;
    updateCoins(coins);
  },
};

function format(result) {
  if (!result) return `<td>---</td>`;
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
