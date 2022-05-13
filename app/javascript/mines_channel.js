const cards = [...document.querySelectorAll(".card")]

cards.forEach((card, num) => {
  card.onclick = () => channel.send({ type: "flip", num });
})

btnStart.onclick = () => {
  channel.send({ type: "start" });
  btnStart.disabled = true;
}

btnLeave.onclick = () => {
  channel.send({ type: "leave" });
  btnLeave.disabled = true;
}

const channel = window.consumer.subscriptions.create("MinesChannel", {
  connected() {
    btnStart.disabled = false;
    console.log("Hello");
  },
  
  received(msg) {
    console.log(msg);
    actions[msg.type](msg.data);
  },
});

const actions = {
  start(coins){
    cards.forEach(card => card.style.transform = "rotateY(0deg)");
    updateCoins(coins)
    btnLeave.textContent = "Retirarme y ganar $10"
    btnLeave.disabled = false;
  }, 
  flip({back, num, prize}) {
    btnLeave.textContent = "Retirarme y ganar $"+prize
    let card = cards[num]
    let backSide = card.querySelector("div:last-child")
    backSide.textContent = back;
    card.style.transform = "rotateY(180deg)";
    if(back == "Boom"){
      btnStart.disabled = false;
      btnLeave.disabled = true;
      btnLeave.textContent = "Retirarme"
      backSide.style.backgroundColor = "red"
    }else backSide.style.backgroundColor = "green"
  },
  leave(coins){
    btnStart.disabled = false;
    btnLeave.disabled = true;
    btnLeave.textContent = "Retirarme"
    updateCoins(coins)
  }
}
