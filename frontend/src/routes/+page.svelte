<script>
  import { onMount } from 'svelte';
  import * as THREE from 'three';
  import Api from '$lib/api.ts';
  import { create_cube } from '$lib/threejs.js';
  import { solved_cube } from '$lib/cube.ts';


  let scramble_moves = "";

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

    const animate = () => renderer.render(scene, camera);
    renderer.setAnimationLoop(animate);
  });

  function update_cube(new_cube) {
    scene.remove(cube_three_js);
    cube = new_cube;
    cube_three_js = create_cube(cube);
    scene.add(cube_three_js);
  }

  function scramble() {
    Api.scramble()
      .then(res => res.json()
      .then(json => {
        scramble_moves = json.moves.join(" ");
        update_cube(json.new_cube)
      }));
  }
</script>


<div id="container">
  <h1 id="title">Rubik's Cube</h1>

  <div id="scramble">
    <p>{scramble_moves}</p>
  </div>

  <div id="cube_container"></div>

  <div id="control_panel">
    <button type="button" onclick={scramble}>Scramble</button>
    <button type="button">Solve</button>
  </div>
</div>

<style>
  #container {
    height: 100vh;
    background-color: #0F1525;
    text-align: center;
  }

  #title {
    display: inline-block;
    color: #E0E5EC;
    font-size: 48px;
  }

  #scramble {
    color: #E0E5EC;
    font-size: 36px;
  }

  #cube_container {
    display: inline-block;
    background-color: #1E2A4A;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  }

  #control_panel {
    display: flex;
    justify-content: center;
    gap: 50px;
  }

  button {
    padding: 10px;
    margin: 1em;
    font-size: 36px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    background-color: #2A4D6E;
    color: #E0E5EC;
  }

  button:hover {
    background-color: #3A6B8F;
  }
</style>
