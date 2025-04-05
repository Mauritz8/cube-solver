import * as THREE from 'three';
import { type Cube, Sticker } from './cube';


function sticker_color(sticker: Sticker) {
  switch (sticker) {
    case Sticker.BLUE: return 0x0045AD;
    case Sticker.GREEN: return 0x009B48;
    case Sticker.RED: return 0xB90000;
    case Sticker.YELLOW: return 0xFFD500;
    case Sticker.WHITE: return 0xFFFFFF;
    case Sticker.ORANGE: return 0xFF5900;
  }
}

function create_cubie(x: number, y: number, z: number, colors: (number | null)[]) {
  const seeThrough = new THREE.MeshBasicMaterial({
    color: 0x222222,
    transparent: true,
    opacity: 0.5
  });
  const colorMaterial = (c: number) => new THREE.MeshBasicMaterial({ color: c });
  const materials = colors.map(c => c ? colorMaterial(c) : seeThrough);

  const gap = 0.02;
  const size = 1 - gap;
  const cubie = new THREE.Mesh(
    new THREE.BoxGeometry(size, size, size),
    materials
  );
  cubie.position.set(x, y, z);
  return cubie;
}

function right_color(cube: Cube, y: number, z: number) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.right;
  return z == -1 ? face.trd :
    z == 0 ? face.snd :
    face.fst;
}

function left_color(cube: Cube, y: number, z: number) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.left;
  return z == -1 ? face.fst :
    z == 0 ? face.snd :
    face.trd;
}

function top_color(cube: Cube, x: number, z: number) {
  const face = cube.top_face;
  const row = z == -1 ? face.fst :
    z == 0 ? face.snd :
    face.trd;
  return x == -1 ? row.fst :
    x == 0 ? row.snd :
    row.trd;
}

function bottom_color(cube: Cube, x: number, z: number) {
  const face = cube.bottom_face;
  const row = z == -1 ? face.trd :
    z == 0 ? face.snd :
    face.fst;
  return x == -1 ? row.fst :
    x == 0 ? row.snd :
    row.trd;
}

function front_color(cube: Cube, x: number, y: number) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.front;
  return x == -1 ? face.fst :
    x == 0 ? face.snd :
    face.trd;
}

function back_color(cube: Cube, x: number, y: number) {
  const layer = y == -1 ? cube.bottom_layer :
    y == 0 ? cube.middle_layer :
    cube.top_layer;
  const face = layer.back;
  return x == -1 ? face.trd :
    x == 0 ? face.snd :
    face.fst;
}

export function create_cube(cube: Cube) {
  let cube_three_js = new THREE.Group();
  for (let x = -1; x <= 1; x++) {
    for (let y = -1; y <= 1; y++) {
      for (let z = -1; z <= 1; z++) {
        // TODO: refactor
        // the {direction}_color functions are difficult to understand
        const colors = [
          x === 1 ? sticker_color(right_color(cube, y, z)) : null,
          x === -1 ? sticker_color(left_color(cube, y, z)) : null,
          y === 1 ? sticker_color(top_color(cube, x, z)) : null,
          y === -1 ? sticker_color(bottom_color(cube, x, z)) : null,
          z === 1 ? sticker_color(front_color(cube, x, y)) : null,
          z === -1 ? sticker_color(back_color(cube, x, y)) : null,
        ];
        cube_three_js.add(create_cubie(x, y, z, colors));
      }
    }
  }
  return cube_three_js;
}
