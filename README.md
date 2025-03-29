# CubeSolver: Interactive 3D Rubik's Cube Solver
A 3D Rubik's Cube simulator with built-in solving guidance. Use the "Scramble"
button to randomize the cube, then select "Solve" to display a step-by-step 
solution.

## 🛠️ Tech Stack
* **Frontend:** Svelte
* **Backend:** OCaml with Dream

## ⚡ Quick Start

1. Backend
```
# install dependencies
opam install . --deps-only --with-test --with-doc

# setup environment
eval $(opam env)

# launch server
dune exec ./bin/server.exe
```

2. Frontend
```
cd frontend

# install dependencies
npm install

# run web application
npm run dev
```
