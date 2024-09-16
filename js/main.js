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

const blue = new THREE.MeshBasicMaterial({ color: 0x0000ff, side: THREE.DoubleSide });
const green = new THREE.MeshBasicMaterial({ color: 0x00ff00, side: THREE.DoubleSide });
const red = new THREE.MeshBasicMaterial({ color: 0xff0000, side: THREE.DoubleSide });
const yellow = new THREE.MeshBasicMaterial({ color: 0xffff00, side: THREE.DoubleSide });
const white = new THREE.MeshBasicMaterial({ color: 0xffffff, side: THREE.DoubleSide });
const orange = new THREE.MeshBasicMaterial({ color: 0xffA500, side: THREE.DoubleSide });

const rect_size = 1 / 3;
const margin = 0.01;
const axis_pos = axis => axis * (rect_size);
function create_rect(color, x, y, z) {
  const geometry = new THREE.PlaneGeometry(rect_size, rect_size);
  const rect = new THREE.Mesh(geometry, color);
  rect.position.set(x, y, z);
  return rect;
}

const group = new THREE.Group();
function create_cube() {
  function create_side(is_x, is_y, is_z) {
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        if (is_x && is_y) {
          group.add(create_rect(blue, axis_pos(i), axis_pos(j), 0));
        } else if (is_x && is_z) {
          group.add(create_rect(blue, axis_pos(i), 0, axis_pos(j)));
        } else if (is_y && is_z) {
          group.add(create_rect(blue, 0, axis_pos(i), axis_pos(j)));
        }
      }
    }
  }
  //create_side(true, true, false);
  //create_side(true, false, true);
  create_side(false, true, true);
}

// front
group.add(create_rect(blue, 0, 0, 0));

// back
group.add(create_rect(green, 0, 0, axis_pos(1)));

// top
const rect3 = create_rect(white, 0, axis_pos(1) / 2, axis_pos(1) / 2);
rect3.rotation.set(Math.PI / 2, 0, 0);
group.add(rect3);

// bottom
const rect4 = create_rect(yellow, 0, -axis_pos(1) / 2, axis_pos(1) / 2);
rect4.rotation.set(Math.PI / 2, 0, 0);
group.add(rect4);

// right
const rect5 = create_rect(red, axis_pos(1) / 2, 0, axis_pos(1) / 2);
rect5.rotation.set(0, Math.PI / 2, 0);
group.add(rect5);

// left
const rect6 = create_rect(orange, -axis_pos(1) / 2, 0, axis_pos(1) / 2);
rect6.rotation.set(0, Math.PI / 2, 0);
group.add(rect6);

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

scene.add(group);

camera.position.z = 5;
function animate() {
	group.rotation.x += 0.01;
	group.rotation.y += 0.01;
	renderer.render(scene, camera);
}
renderer.setAnimationLoop(animate);
