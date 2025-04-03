import * as THREE from 'three';


const blue = 0x0045AD;
const green = 0x009B48;
const red = 0xB90000;
const yellow = 0xFFD500;
const white = 0xFFFFFF;
const orange = 0xFF5900;

function sticker_to_color(sticker) {
  const sticker_to_color_map = {
    ["BLUE"]: blue,
    ["GREEN"]: green,
    ["RED"]: red,
    ["YELLOW"]: yellow,
    ["WHITE"]: white,
    ["ORANGE"]: orange,
  };
  return sticker_to_color_map[sticker];
}

function create_cubie(x, y, z, colors) {
  const materials = colors.map(c =>
    c ? new THREE.MeshBasicMaterial({ color: c }) :
        new THREE.MeshBasicMaterial({ color: 0x222222, transparent: true, opacity: 0.5 }));

  const cubie = new THREE.Mesh(
    new THREE.BoxGeometry(0.98, 0.98, 0.98),
    materials
  );
  cubie.position.set(x, y, z);
  return cubie;
}

function right_color(cube, y, z) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.right;
  return z == -1 ? face.trd :
    z == 0 ? face.snd :
    face.fst;
}

function left_color(cube, y, z) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.left;
  return z == -1 ? face.trd :
    z == 0 ? face.snd :
    face.fst;
}

function top_color(cube, x, z) {
  const face = cube.top_face;
  const row = z == -1 ? face.fst :
    z == 0 ? face.snd :
    face.trd;
  return x == -1 ? row.fst :
    x == 0 ? row.snd :
    row.trd;
}

function bottom_color(cube, x, z) {
  const face = cube.bottom_face;
  const row = z == -1 ? face.trd :
    z == 0 ? face.snd :
    face.fst;
  return x == -1 ? row.fst :
    x == 0 ? row.snd :
    row.trd;
}

function front_color(cube, x, y) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.front;
  return x == -1 ? face.fst :
    x == 0 ? face.snd :
    face.trd;
}

function back_color(cube, x, y) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.back;
  return x == -1 ? face.trd :
    x == 0 ? face.snd :
    face.fst;
}

export function create_cube(cube) {
  let cube_three_js = new THREE.Group();
  for (let x = -1; x <= 1; x++) {
    for (let y = -1; y <= 1; y++) {
      for (let z = -1; z <= 1; z++) {
        const colors = [
          x === 1 ? sticker_to_color(right_color(cube, y, z)) : null,
          x === -1 ? sticker_to_color(left_color(cube, y, z)) : null,
          y === 1 ? sticker_to_color(top_color(cube, x, z)) : null,
          y === -1 ? sticker_to_color(bottom_color(cube, x, z)) : null,
          z === 1 ? sticker_to_color(front_color(cube, x, y)) : null,
          z === -1 ? sticker_to_color(back_color(cube, x, y)) : null,
        ];
        cube_three_js.add(create_cubie(x, y, z, colors));
      }
    }
  }
  return cube_three_js;
}
