function getSideStickers(sideId) {
  const side = document.getElementById(sideId);
  const sticker_elems = Array.from(side.getElementsByClassName('sticker'));
  return sticker_elems.map(
    sticker_elem => [sticker_elem.classList[1].toUpperCase()]
  );
}

function getCube() {
  return {
    front: getSideStickers('front'),
    right: getSideStickers('right'),
    left: getSideStickers('left'),
    top: getSideStickers('top'),
    bottom: getSideStickers('bottom'),
    back: getSideStickers('back'),
  };
}

function move_cube_post_req(path) {
  fetch(path, {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(getCube()),
  }).then(res => res.text())
    .then(text => {
      document.getElementById('cube').outerHTML = text;
    });
}

document
  .getElementById('move_up_btn')
  .addEventListener('click', () => move_cube_post_req('/api/move_up'));
