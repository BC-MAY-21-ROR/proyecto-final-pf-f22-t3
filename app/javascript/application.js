// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers";
import "channels";

audioCoins.volume = 0.2;

window.updateCoins = (coins) => {
  // let utterance = new SpeechSynthesisUtterance();
  // utterance.text = "Hola Alan";
  // utterance.voice = speechSynthesis.getVoices()[13]
  // speechSynthesis.speak(utterance);
  audioCoins.play();
  TxtCoins.textContent = coins;
};
