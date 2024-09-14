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

function move_cube_post_req(direction, clockwise) {
  const body = {
    direction: direction,
    clockwise: clockwise,
    cube: getCube(),
  };
  fetch('/api/move', {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  }).then(res => res.text())
    .then(text => {
      document.getElementById('cube').outerHTML = text;
    });
}

document
  .getElementById('move_up_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["UP"], true));

document
  .getElementById('move_up_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["UP"], false));

document
  .getElementById('move_down_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["DOWN"], true));

document
  .getElementById('move_down_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["DOWN"], false));

document
  .getElementById('move_right_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["RIGHT"], true));

document
  .getElementById('move_right_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["RIGHT"], false));

document
  .getElementById('move_left_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["LEFT"], true));

document
  .getElementById('move_left_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["LEFT"], false));

document
  .getElementById('move_front_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["FRONT"], true));

document
  .getElementById('move_front_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["FRONT"], false));

document
  .getElementById('move_back_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["BACK"], true));

document
  .getElementById('move_back_counter_clockwise_btn')
  .addEventListener('click', () => move_cube_post_req(["BACK"], false));
