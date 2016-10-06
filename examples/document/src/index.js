require('./main.css');

const Elm = require('./Main.elm');
const root  = document.getElementById('root');
const app = Elm.Main.embed(root);

const target = document.documentElement;
// ... or target a specific element
// const target = document.querySelector('.article');

window.addEventListener('scroll', function() {
  app.ports.onScroll.send({
    scrollTop: document.documentElement.scrollTop || document.body.scrollTop,
    targetScrollHeight: target.scrollHeight,
    clientHeight: document.documentElement.clientHeight
  });
});