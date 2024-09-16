import * as THREE from 'three';

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
    move: {
      direction: direction,
      clockwise: clockwise,
    },
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

function move_on_btn_click(btn_id, direction, clockwise) {
  document
    .getElementById(btn_id)
    .addEventListener('click', () => move_cube_post_req([direction], clockwise));
}

move_on_btn_click('move_up_clockwise_btn', 'UP', true);
move_on_btn_click('move_up_counter_clockwise_btn', 'UP', false);
move_on_btn_click('move_down_clockwise_btn', 'DOWN', true);
move_on_btn_click('move_down_counter_clockwise_btn', 'DOWN', false);
move_on_btn_click('move_right_clockwise_btn', 'RIGHT', true);
move_on_btn_click('move_right_counter_clockwise_btn', 'RIGHT', false);
move_on_btn_click('move_left_clockwise_btn', 'LEFT', true);
move_on_btn_click('move_left_counter_clockwise_btn', 'LEFT', false);
move_on_btn_click('move_front_clockwise_btn', 'FRONT', true);
move_on_btn_click('move_front_counter_clockwise_btn', 'FRONT', false);
move_on_btn_click('move_back_clockwise_btn', 'BACK', true);
move_on_btn_click('move_back_counter_clockwise_btn', 'BACK', false);

document.getElementById('scramble_btn').addEventListener('click', () => {
  fetch('/api/scramble')
    .then(res => res.text())
    .then(text => document.getElementById('cube_container').outerHTML = text);
});

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

const blue = new THREE.MeshBasicMaterial({ color: 0x0000ff });
const green = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
const red = new THREE.MeshBasicMaterial({ color: 0xff0000 });
const yellow = new THREE.MeshBasicMaterial({ color: 0xffff00 });
const white = new THREE.MeshBasicMaterial({ color: 0xffffff });
const orange = new THREE.MeshBasicMaterial({ color: 0xffA500 });

const cubie_size = 1 / 3;
function create_cubie(x, y, z) {
  const geometry = new THREE.BoxGeometry(cubie_size, cubie_size, cubie_size);
  const materials = [
    green,
    orange,
    blue,
    red,
    white,
    yellow,
  ];
  const cubie = new THREE.Mesh(geometry, materials);
  cubie.position.set(x, y, z);
  return cubie;
}

const margin = 0.01;
const axis_pos = axis => axis * (cubie_size + margin);
const group = new THREE.Group();
for (let x = 0; x < 3; x++) {
  for (let y = 0; y < 3; y++) {
    for (let z = 0; z < 3; z++) {
      group.add(create_cubie(axis_pos(x), axis_pos(y), axis_pos(z)));
    }
  }
}
scene.add(group);

camera.position.z = 5;
function animate() {
	group.rotation.x += 0.01;
	group.rotation.y += 0.01;
	renderer.render(scene, camera);
}
renderer.setAnimationLoop(animate);
