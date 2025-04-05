<script lang="ts">
  import { onMount } from 'svelte';
  import * as THREE from 'three';
  import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
  import { type Cube, cubeFromJson } from '$lib/cube'
  import Api from '$lib/api';
  import { create_cube } from '$lib/threejs';


  let scramble_moves: string[] = [];
  let solution_error = "";
  let solution_moves: string[] = [];
  let cube: Cube;
  let cube_three_js: THREE.Group<THREE.Object3DEventMap>;
  const scene = new THREE.Scene();
  onMount(() => {
    const scene_height = 500;
    const scene_width = 500;
    const camera = new THREE.PerspectiveCamera(
      50, scene_width / scene_height, 0.1, 2000);

    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(scene_width, scene_height);
    renderer.setClearColor(0x000000, 0);
    const cube_container = document.getElementById("cube_container")!;
    cube_container.style.width =  scene_width.toString();
    cube_container.style.height = scene_height.toString();
    cube_container.appendChild(renderer.domElement);

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;

    Api.solved_cube()
    .then(res => res.json()
    .then(json => {
      cube = cubeFromJson(json);
      cube_three_js = create_cube(cube);
      scene.add(cube_three_js);
    }));


    camera.position.x = 3;
    camera.position.y = 2;
    camera.position.z = 7;

    function animate() {
      requestAnimationFrame(animate);
      controls.update();
      renderer.render(scene, camera);
    }
    renderer.setAnimationLoop(animate);
  });

  function update_cube(new_cube: Cube) {
    scene.remove(cube_three_js);
    cube = new_cube;
    cube_three_js = create_cube(cube);
    scene.add(cube_three_js);
  }

  async function scramble() {
    Api.scramble()
      .then(res => res.json())
      .then(json => {
        scramble_moves = json.moves;
        solution_error = "";
        solution_moves = [];
        update_cube(cubeFromJson(json.new_cube))
      });
  }

  async function solve() {
    Api.solve(cube)
      .then(res => {
        if (res.status == 500) {
          res.text().then(error => solution_error = error);
        } else {
          res.json().then(json => {
            solution_moves = json.moves; 
            update_cube(cubeFromJson(json.cube));
          });
        }
      });
  }
</script>


<div id="container">
  <h1 id="title">Rubik's Cube</h1>

  <div id="scramble">
    <p>{scramble_moves.join(" ")}</p>
  </div>

  <div id="solution">
    {#if solution_error !== ""}
      <p>{solution_error}</p>
    {:else}
      <p>{solution_moves.join(" ")}</p>
    {/if}
  </div>

  <div id="cube_container"></div>

  <div id="control_panel">
    <button type="button" onclick={scramble}>Scramble</button>
    <button type="button" onclick={solve}>Solve</button>
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

  #solution {
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
