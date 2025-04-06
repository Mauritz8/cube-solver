<script lang="ts">
  import { onMount } from 'svelte';
  import * as THREE from 'three';
  import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
  import { type Cube, cubeFromJson } from '$lib/cube'
  import Api from '$lib/api';
  import { create_cube } from '$lib/threejs';


  let scramble_moves: string[] = $state([]);
  let solution_error = $state("");
  let solution_moves: string[] = $state([]);
  let current_move_index = $state(0);
  let cube: Cube;
  let cube_three_js: THREE.Group<THREE.Object3DEventMap>;
  const scene = new THREE.Scene();
  onMount(() => {
    const camera = new THREE.PerspectiveCamera(75, 1, 0.1, 2000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(500, 500);
    renderer.setClearColor(0x000000, 0);

    const cube_container = document.getElementById("cube_container")!;
    cube_container.appendChild(renderer.domElement);

    camera.position.x = 3;
    camera.position.y = 2;
    camera.position.z = 7;
    new OrbitControls(camera, renderer.domElement);
    renderer.setAnimationLoop(() => renderer.render(scene, camera));

    Api.solved_cube()
    .then(res => res.json()
    .then(json => {
      cube = cubeFromJson(json);
      cube_three_js = create_cube(cube);
      scene.add(cube_three_js);
    }));
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
        current_move_index = 0;
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
            current_move_index = solution_moves.length;
            update_cube(cubeFromJson(json.cube));
          });
        }
      });
  }

  async function make_move(move: string) {
    Api.move(move, cube)
      .then(res => res.json())
      .then(json => {
          update_cube(cubeFromJson(json));
      });
  }

  async function move_next() {
    if (current_move_index >= solution_moves.length) return;
    const move = solution_moves.at(current_move_index);
    if (move) {
      await make_move(move);
      current_move_index++;
    }
  }

  async function move_prev() {
    const index = current_move_index - 1;
    if (index < 0) return;
    const move = solution_moves.at(index);
    if (move) {
      const undo_move = move.length === 1 ? move + "'" : move[0];
      await make_move(undo_move);
      current_move_index--;
    }
  }

  function disable_solve_btn() {
    return solution_moves.length > 0 || solution_error !== "";
  }

</script>


<div id="container">
  <h1 id="title">Rubik's Cube Solver</h1>

  <div id="info">
    {#if solution_error !== ""}
      <p id="solution-error">{solution_error}</p>
    {:else if solution_moves.length > 0}
      <h2 id="info-header">Solution</h2>
      <button class="move-btn" onclick={move_prev} aria-label="Make previous move">
        <span class="fas fa-arrow-left"></span>
      </button>
      {#each solution_moves as move, i}
        {#if i === current_move_index}
          <span id="move-indicator"></span>
        {/if}
        <span>{move}</span>
      {/each}
      {#if current_move_index === solution_moves.length}
        <span id="move-indicator"></span>
      {/if}
      <button class="move-btn" onclick={move_next} aria-label="Make next move">
        <span class="fas fa-arrow-right"></span>
      </button>
    {:else if scramble_moves.length > 0}
      <h2 id="info-header">Scramble</h2>
      {#each scramble_moves as move}
        <span>{move}</span>
      {/each}
    {/if}
  </div>

  <div id="cube_container"></div>

  <div id="control_panel">
    <button type="button" onclick={scramble}>Scramble</button>
    <button
      type="button"
      class={disable_solve_btn() ? "btn-disabled" : ""}
      onclick={solve}
      disabled={disable_solve_btn()}
    >Solve</button>
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
    font-size: 3em;
  }

  #info {
    color: #E0E5EC;
    margin: 1em 1em;
  }

  #info-header, #solution-error {
    font-size: 2.5em;
  }

  #info > span {
    margin: 0 0.2em;
    font-size: 2em;
  }

  .move-btn {
    margin: 0;
  }

  #move-indicator {
    font-size: 30px;
    border-left: 5px solid #2A4D6E;
    height: 1em;
    margin: 0 0.5em !important;
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

  .btn-disabled {
    pointer-events: none;
  }
</style>
