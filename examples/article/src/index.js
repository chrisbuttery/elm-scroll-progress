require('./main.css');

const Elm = require('./Main.elm');
const root  = document.getElementById('root');
const app = Elm.Main.embed(root);

const target = document.querySelector('.article');
// ... or target the body
// const target = document.documentElement;

window.addEventListener('scroll', function() {
  app.ports.onScroll.send({
    scrollTop: document.documentElement.scrollTop || document.body.scrollTop,
    targetScrollHeight: target.scrollHeight,
    clientHeight: document.documentElement.clientHeight
  });
});