<script lang="ts">
  import { onMount } from 'svelte';
  import * as THREE from 'three';
  import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
  import { type Cube, cubeFromJson } from '$lib/cube'
  import Api from '$lib/api';
  import { create_cube } from '$lib/threejs';

  type SolutionStep = { name: string; moves: string[] };
  type Solution = { steps: SolutionStep[]; }

  let scramble_moves: string[] = $state([]);
  let solution_error = $state("");
  let solution: Solution = $state({ steps: [] });
  let current_step_index = $state(0);
  let current_move_index = $state(0);
  let cube: Cube;
  let cube_three_js: THREE.Group<THREE.Object3DEventMap>;
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x1E2A4A);
  onMount(() => {
    const width = 800;
    const height = 600;
    const camera = new THREE.PerspectiveCamera(55, width / height, 0.1, 2000);
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(width, height);

    const cube_container = document.getElementById("cube-container")!;
    cube_container.appendChild(renderer.domElement);

    camera.position.set(4, 5, 5);
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.01;
    renderer.setAnimationLoop(() => {
      controls.update();
      renderer.render(scene, camera);
    });

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

  async function scramble_and_solve() {
    await Api.scramble()
      .then(res => res.json())
      .then(json => {
        scramble_moves = json.moves;
        solution_error = "";
        solution = { steps: [] };
      });

    let new_cube = cube;
    for (const move of scramble_moves) {
      await Api.move(move, new_cube)
        .then(res => res.json())
        .then(json => {
          new_cube = cubeFromJson(json);
        });
    }
    update_cube(new_cube)

    await Api.solve(cube)
      .then(res => {
        if (res.status == 500) {
          res.text().then(error => solution_error = error);
        } else {
          res.json().then(json => {
            solution = json;
            current_move_index = 0;
            current_step_index = 0;
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
    const current_step = solution.steps.at(current_step_index);
    if (!current_step) return;
    const move = current_step.moves.at(current_move_index);
    if (!move) return;
    await make_move(move);

    if (current_move_index === current_step.moves.length - 1
        && current_step_index < solution.steps.length - 1) {
      current_step_index++;
      current_move_index = 0;
    } else if (current_move_index < current_step.moves.length) {
      current_move_index++;
    }
  }

  async function move_prev() {
    let undo_step_index = current_step_index;
    let undo_move_index = current_move_index - 1;
    let move = solution.steps.at(undo_step_index)?.moves.at(undo_move_index);
    if (current_move_index === 0 && current_step_index > 0) {
      const prev_step = solution.steps.at(current_step_index - 1);
      if (!prev_step) return;
      undo_step_index = current_step_index - 1;
      undo_move_index = prev_step.moves.length - 1;
      move = prev_step.moves.at(undo_move_index);
    }
    if (!move) return;

    let undo_move;
    if (move.charAt(move.length - 1) === '2') {
      undo_move = move;
    } else if (move.charAt(move.length - 1) == "'") {
      undo_move = move.substring(0, move.length - 1);
    } else {
      undo_move = move + "'";
    }
    await make_move(undo_move);
    current_step_index = undo_step_index;
    current_move_index = undo_move_index;
  }

function get_move_description(move: string | undefined): string {
  if (!move) {
    return '';
  }

  switch (move) {
    case "x": return "Rotate the cube forward around the X-axis.";
    case "x'": return "Rotate the cube backwards around the X-axis.";
    case "x2": return "Rotate the cube 180 degrees around the X-axis.";
    case "y": return "Rotate the cube clockwise around the Y-axis.";
    case "y'": return "Rotate the cube counter-clockwise around the Y-axis.";
    case "y2": return "Rotate the cube 180 degrees around the Y-axis.";
  }

  const move_face_map = new Map<string, string>([
    ['R', 'right'],
    ['L', 'left'],
    ['U', 'top'],
    ['D', 'bottom'],
    ['F', 'front'],
    ['B', 'back'],
  ]);

  const face = move_face_map.get(move.charAt(0));
  if (!face) {
    return '';
  }

  if (move.length == 1) {
    return `Turn the ${face} face clockwise.`;
  }
  if (move.length == 2 && move.charAt(1) == '2') {
    return `Turn the ${face} face twice.`;
  }

  if (move.length == 2 && move.charAt(1) == "'") {
    return `Turn the ${face} face counter-clockwise.`;
  }

  return '';
}
</script>

<div id='main-container'>

  <header id='title-header'>
    <h1>Rubik's Cube Solver</h1>
    <p id='tagline'>Your step-by-step guide to solving any scramble.</p>
  </header>

  <main id='layout-container'>

    <section id='cube-column'>
      <div id="cube-container"></div>
    </section>

    <section id='info-column'>

      <section class='info-card'>
        <h2>Your Scramble</h2>
        <div id='scramble-string'>
          {#if scramble_moves.length === 0}
            <span>Your scramble will be shown here</span>
          {:else}
            <span>{scramble_moves.join(' ')}</span>
          {/if}
        </div>
        <button type="button" onclick={scramble_and_solve} class='btn-secondary' id='scramble-btn'>Scramble</button>
        <p class='helper-text'>Ensure your physical cube matches the cube on the left before starting.</p>
      </section>

      <section class='info-card'>
        {#if solution_error !== ''}
          <h2>Solution</h2>
          <div id='error-message'>
            <div class="error-icon">⚠️</div> 
            <h3 class="error-title">Could Not Find a Solution</h3>
            <p class="error-detail">The scramble could not be solved.</p>
          </div>
        {:else if solution.steps.length === 0}
          <h2>Solution</h2>
          <p>After you scramble, the solution will be shown here</p>
        {:else if solution.steps.at(current_step_index) !== undefined
          && current_move_index >= solution.steps.at(current_step_index)!.moves.length
          && current_step_index === solution.steps.length - 1}
          <h2 class='celebration-title'>Cube Solved!</h2>
          <p class='celebration-subtitle'>Congratulations! You did it! 🎉</p>
        {:else}
          <h2>Solution</h2>
          <div id='progress-group'>
            <div id='progress-bar'>
              <div id='progress-fill' style='width: 22%;'></div>
            </div>
            <span id='progress-text'>Move {current_move_index + 1} of {solution.steps.at(current_step_index)?.moves.length}</span>
          </div>
          <span id='stage-tag'>STAGE: {solution.steps.at(current_step_index)?.name}</span>
          <div id='move-display'>
            <div id='big-move'>{solution.steps.at(current_step_index)?.moves.at(current_move_index)}</div>
            <p id='move-description'>{get_move_description(solution.steps.at(current_step_index)?.moves.at(current_move_index))}</p>
          </div>
          <div id='controls-group'>
            <button class='btn-secondary' onclick={move_prev} aria-label="Previous move">
              <span class="fa-solid fa-arrow-left"></span>
            </button>
            <button class='btn-primary' onclick={move_next} aria-label="Next move">
              <span class="fa-solid fa-arrow-right"></span>
            </button>
          </div>
        {/if}
      </section>

    </section>
  </main>
</div>

<style>
  #title-header {
    text-align: center;
    padding: 3rem 1rem 2rem 1rem;
    background-color: #0f1525;
    color: #e2e8f0;
    border-bottom: 1px solid #2d3b5c;
  }

  #title-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0 0 0.5rem 0;
    color: #e2e8f0;
    letter-spacing: -0.5px;
  }

  #title-header #tagline {
    font-size: 1.25rem;
    font-weight: 400;
    margin: 0 auto;
    color: #9aa6c9;
    max-width: 600px;
  }

  #layout-container {
    display: flex;
    justify-content: space-evenly;
    margin-top: 2rem;
  }

  #info-column {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .info-card {
    background-color: #1E2A4A;
    border-radius: 12px;
    padding: 1.5rem;
    text-align: left;
  }

  .info-card h2 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
    color: #e2e8f0;
  }

  .info-card #scramble-string {
    font-size: 0.9rem;
    font-family: 'Coursier New', monospace;
    background-color: #0F1525;
    padding: 0.75rem;
    border-radius: 6px;
    display: block;
    margin-bottom: 1rem;
    color: #9AA6C9;
  }

  .helper-text {
    font-size: 0.875rem;
    color: #9AA6C9;
    margin-top: 0.5rem;
  }

  #progress-text {
    font-size: 0.875rem;
    color: #9AA6C9;
  }

  #stage-tag {
    font-size: 0.9rem;
    font-weight: 600;
    color: #6db3f2;
    display: block;
    margin-bottom: 1.5rem;
  }

  #move-display {
    text-align: center;
  }

  #big-move {
    font-size: 4rem;
    font-weight: 800;
    color: #e2e8f0;
    margin: 0.5rem 0;
    line-height: 1.1;
  }

  #move-description {
    font-size: 1.1rem;
    color: #9AA6C9;
    margin-bottom: 1.5rem;
  }

  #controls-group {
    text-align: center;
  }

  #error-message {
    text-align: center;
    padding: 2rem;
    background-color: #1E2A4A;
    border: 1px solid;
    border-color: #E53E3E;
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(229, 62, 62, 0.25);
  }

  .error-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
  }

  .error-title {
      font-size: 1.5rem;
      font-weight: 700;
      color: #E53E3E;
      margin: 0 0 0.5rem 0;
  }

  .error-detail {
      color: #9AA6C9;
      margin-bottom: 1.5rem;
  }

  .celebration-title {
    font-size: 3rem;
    font-weight: 800;
    color: #6db3f2;
    margin: 0.5rem 0;
    position: relative;
    z-index: 2;
  }

  .celebration-subtitle {
    font-size: 1.5rem;
    color: #e2e8f0;
    margin-bottom: 1.5rem;
    position: relative;
    z-index: 2;
  }

  .btn-primary, .btn-secondary {
    font-size: 1rem;
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
  }

  .btn-primary {
    background-color: #4c78ce;
    color: white;
    border: none;
  }

  .btn-primary:hover {
    background-color: #6db3f2;
  }

  .btn-secondary {
    background-color: transparent;
    color: #4c78ce;
    border: 2px solid #4c78ce;
  }

  .btn-secondary:hover {
    background-color: #4c78ce;
    color: white;
  }
</style>
