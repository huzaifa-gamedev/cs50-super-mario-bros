# 🍄 CS50 — Super Mario Bros

[![LÖVE2D](https://img.shields.io/badge/Engine-L%C3%96VE2D-informational)](https://love2d.org/)
[![Language](https://img.shields.io/badge/Language-Lua-blue)](https://www.lua.org/)
[![Course](https://img.shields.io/badge/Course-CS50G-red)](https://cs50.harvard.edu/games/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Course:** [CS50's Introduction to Game Development](https://cs50.harvard.edu/games/)  
**Assignment:** Super Mario Bros  
**Engine / Language:** LÖVE2D (Lua)  

---

## 📋 Project Overview  

This repository contains my implementation of the **Super Mario Bros** assignment from CS50's Introduction to Game Development.  

🎮 Inspired by the classic, this project introduces **keys, locks, and a progressive level system** that extends gameplay dynamically.  

📺 You can also watch my gameplay demo on [YouTube](https://youtu.be/z59Mh9Epx6U?si=R2Ov0DEHoSa9Ewo3).

---

### What I Implemented  

- ✔️ **Safe Player Spawn** — Player always spawns **above solid ground**, never over a pit.  
- ✔️ **Keys & Locks** — Randomly generated **colored key and lock block** (from `keys_and_locks.png`). Picking up the key unlocks the block and makes it disappear.  
- ✔️ **Goal Post System** — Unlocking the block spawns a **goal post** at the end of the level using assets from `flags.png`.  
- ✔️ **Progressive Levels** — Touching the goal post regenerates a **longer level** and restarts the player at the beginning, while **preserving score** across levels.  
- ✔️ **PlayState Enhancements** — Modified `PlayState:enter` to handle **level tracking, score persistence, and map resizing**.  

---

## 🎬 Gameplay Preview  

![Gameplay Preview](docs/gameplay.gif)  

---

## 🚀 How to Run  

1. Install [LÖVE2D](https://love2d.org/).  

2. Clone this repository:  

   ```bash
   git clone https://github.com/huzaifa-gamedev/cs50-super-mario-bros.git
   cd cs50-mario
   ```  

3. Run the game:  

   ```bash
   love .
   ```  

---

## 🎯 Controls  

- **Arrow Keys (↑ ↓ ← →)** — Move Mario.  
- **Spacebar** — Jump.  
- **Escape** — Quit game.  

---

## 🧠 Notes on Implementation  

- **Player Ground Check:** Iterated over columns in `LevelMaker.lua` to ensure spawn above a solid tile (`TILE_ID_GROUND`).  
- **Keys & Locks:** Added random placement during level generation with `onConsume` callback logic for key pickup.  
- **Goal Post:** Spawned pole + flag pieces in `onCollide` when lock is removed. Used `GameObject` instances to construct the flagpole.  
- **Level Progression:** Extended `PlayState:enter` with parameters (`level`, `score`, `mapWidth`) to enable regenerating levels with increasing difficulty.  
- **State Persistence:** Updated `gStateMachine:change('play')` calls to pass score and level width for continuity.  

---

## ✨ Credits  

- Original skeleton code & assets: CS50's Introduction to Game Development (Harvard). Licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).  

---

## 📄 License  

- This implementation: © 2025 Muhammad Huzaifa Karim. Licensed under the [MIT License](LICENSE).  

For more details, see [ATTRIBUTION.md](ATTRIBUTION.md).  

---

## ✍️ Author  

**Muhammad Huzaifa Karim**  
[GitHub Profile](https://github.com/huzaifakarim1)  

---

## 📬 Contact  

For ideas, feedback, or collaboration, feel free to reach out via [GitHub](https://github.com/huzaifakarim1).  

---

© 2025 Muhammad Huzaifa Karim. All rights reserved.
