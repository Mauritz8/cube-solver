<script>
  import { onMount } from 'svelte';
  import * as THREE from 'three';
  import Api from '$lib/index.ts';

  const color =
    c => new THREE.MeshBasicMaterial({ color: c, side: THREE.DoubleSide });
  const blue = color(0x0045AD);
  const green = color(0x009B48);
  const red = color(0xB90000);
  const yellow = color(0xFFD500);
  const white = color(0xFFFFFF);
  const orange = color(0xFF5900);

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

  function create_rect(size, color, x, y, z) {
    const geometry = new THREE.PlaneGeometry(size, size);
    const rect = new THREE.Mesh(geometry, color);
    rect.position.set(x, y, z);
    return rect;
  }

  const rect_size = 1 / 2;

  function create_side(side_name, side_arr) {
    const index_map = (x, y) => ({
      "FRONT": 3 * y + x,
      "RIGHT": 3 * y + x,
      "BOTTOM": 3 * y + x,
      "BACK": 3 * y + (2 - x),
      "LEFT": 3 * y + (2 - x),
      "TOP": 3 * (2 - y) + x,
    });

    const side_three_js = new THREE.Group();
    for (let x = 0; x < 3; x++) {
      for (let y = 0; y < 3; y++) {
        const i = index_map(x, y)[side_name];
        const color = sticker_to_color(side_arr[i]);
        const rect =
          create_rect(rect_size, color, x * rect_size, -y * rect_size, 0);
        side_three_js.add(rect);
      }
    }
    return side_three_js;
  }

  function create_cube(cube) {
    const cube_three_js = new THREE.Group();

    const back = create_side("BACK", cube.back);
    back.translateZ(-3 * rect_size);
    cube_three_js.add(back);

    const front = create_side("FRONT", cube.front);
    cube_three_js.add(front);

    const bottom = create_side("BOTTOM", cube.bottom);
    bottom.rotateX(Math.PI / 2);
    bottom.translateY(-rect_size / 2);
    bottom.translateZ(rect_size * 5 / 2);
    cube_three_js.add(bottom);

    const top = create_side("TOP", cube.top);
    top.rotateX(Math.PI / 2);
    top.translateZ(-rect_size / 2);
    top.translateY(-rect_size / 2);
    cube_three_js.add(top);

    const left = create_side("LEFT", cube.left);
    left.rotateY(Math.PI / 2);
    left.translateZ(-rect_size / 2);
    left.translateX(rect_size / 2);
    cube_three_js.add(left);

    const right = create_side("RIGHT", cube.right);
    right.rotateY(Math.PI / 2);
    right.translateZ(rect_size * 5 / 2);
    right.translateX(rect_size / 2);
    cube_three_js.add(right);

    return cube_three_js;
  }

  const solved_cube = {
    front: [
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
      ["GREEN"],
    ],
    left: [
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
      ["ORANGE"],
    ],
    right: [
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
      ["RED"],
    ],
    top: [
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
      ["WHITE"],
    ],
    bottom: [
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
      ["YELLOW"],
    ],
    back: [
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
      ["BLUE"],
    ],
  };

  let cube = solved_cube;

  let cube_three_js = create_cube(cube);
  const scene = new THREE.Scene();

  onMount(() => {
    const scene_height = 500;
    const scene_width = 500;
    const camera = new THREE.PerspectiveCamera(
      50, scene_width / scene_height, 0.1, 2000);

    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(scene_width, scene_height);
    renderer.setClearColor(0x000000, 0);
    const cube_container = document.getElementById("cube_container");
    cube_container.style.width =  scene_width;
    cube_container.style.height = scene_height;
    cube_container.appendChild(renderer.domElement);

    scene.add(cube_three_js);

    camera.position.x = 3;
    camera.position.y = 2;
    camera.position.z = 3;

    camera.lookAt(new THREE.Vector3(1, 0, 0));
    function animate() {
      //cube_three_js.rotation.x += 0.01;
      //cube_three_js.rotation.y += 0.01;
      renderer.render(scene, camera);
    }
    renderer.setAnimationLoop(animate);
  });

  function update_cube(new_cube) {
    scene.remove(cube_three_js);
    cube = new_cube;
    cube_three_js = create_cube(cube);
    scene.add(cube_three_js);
  }

  function move(direction, clockwise) {
    Api.move(cube, [direction], clockwise)
      .then(res => res.json()
      .then(json => update_cube(json)));
  }

  function scramble() {
    Api.scramble()
      .then(res => res.json()
      .then(json => update_cube(json)));
  }

  function rotate_right() {
    Api.rotate_right(cube)
      .then(res => res.json()
      .then(json => update_cube(json)));
  }
</script>


<h1 id="title">Rubik's Cube</h1>

<div id="layout">
  <div id="cube_container"></div>

  <div id="control_panel">
    <h2>Control Panel</h2>

    <div id="move_btns">
      <button type="button" onclick={() => move('UP', true)}>U</button>
      <button type="button" onclick={() => move('UP', false)}>U'</button>
      <button type="button" onclick={() => move('DOWN', true)}>D</button>
      <button type="button" onclick={() => move('DOWN', false)}>D'</button>
      <button type="button" onclick={() => move('RIGHT', true)}>R</button>
      <button type="button" onclick={() => move('RIGHT', false)}>R'</button>
      <button type="button" onclick={() => move('LEFT', true)}>L</button>
      <button type="button" onclick={() => move('LEFT', false)}>L'</button>
      <button type="button" onclick={() => move('FRONT', true)}>F</button>
      <button type="button" onclick={() => move('FRONT', false)}>F'</button>
      <button type="button" onclick={() => move('BACK', true)}>B</button>
      <button type="button" onclick={() => move('BACK', false)}>B'</button>
    </div>
    <div id="general_btns">
      <button type="button" id="scramble_btn" onclick={scramble}>Scramble</button>
    </div>
    <div id="rotate_btns">
      <button type="button" id="rotate_right_btn" onclick={rotate_right}>Rotate right</button>
    </div>
  </div>

</div>

<style>
  body {
    background-color: #F5F5F5;
  }

  #title {
    text-align: center;
  }

  #layout {
    display: flex;
    justify-content: space-around;
  }

  #cube_container {
    display: inline-block;
    background-color: #f9f9f9;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  }

  #control_panel {
    display: inline-block;
  }

  #move_btns {
    display: flex;
    row-gap: 5px;
  }

  button {
    padding: 10px;
    margin: 5px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    background-color: #0051ba;
    color: white;
  }

  button:hover {
    background-color: #0046ad;
  }
</style>
