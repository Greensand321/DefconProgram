# DefconProgram

This project implements a fictional Cold War style command center built with Lua for the CC:Tweaked mod in Minecraft. It simulates a network of terminals controlling a launch system.

## Directory Overview
- **services/** – main programs run on the command computer and remote listeners
- **modules/** – reusable libraries for the UI, networking and system utilities
- **config/** – configuration and environment overrides

## Getting Started
1. Install CC:Tweaked in your Minecraft world.
2. Copy this repository onto two or more in‑game computers equipped with modems.
3. On your primary computer run:
   ```
   services/command_center.lua
   ```
   This displays the **WOPR COMMAND MENU**.
4. On each remote computer run:
   ```
   services/remote_listener.lua
   ```
   The terminal shows the frequency it is listening on and will report incoming launch orders.

## Command Center Menu
The command center presents three options:
1. **Launch Sequence** – initiate the fictional missile launch process.
2. **View Arsenal** – view a list of available missile IDs and their status.
3. **Exit** – quit the program.

### Launch Sequence
When you choose **Launch Sequence**, the main terminal prints **WOPR EXECUTION ORDER** and requests two parts of a code labeled *PART ONE* and *PART TWO*. If you enter `1` and `2` respectively, a message is sent to the remote listener which replies with the confirmation code `4321`.

If the confirmation is received the program prompts you for the launch code. The default code is `123456789` (hashed in `config/default.lua`). You have three attempts to enter it correctly. A successful entry triggers a blinking warning message **NUCLEAR ATTACK PROTOCOL ACTIVE**, followed by a ten second countdown. After the countdown the program prints **Missiles launched!** as a simulated result.

### View Arsenal
Displays a small list of missiles (stub data) and waits for you to press Enter to return to the menu.

## Door Control Password
The repository includes a separate `password` program that controls a redstone door. Run it on a computer adjacent to a door and enter the password `defcon1` to temporarily open and then close the door.

## Logs
Logs are written to `data/logs/launch_log.txt` whenever significant events occur (if the directory exists). You can view these logs from within the command center by choosing the appropriate menu option in some versions of the program.

## DEFCON Level Demo
`services/defcon_control.lua` presents a simple interface for experimenting with
different DEFCON levels. The program automatically searches for an attached
monitor and displays buttons labeled **1** through **5**. Selecting a button
lowers or raises the current level—descending requires going one step at a time
while ascending can skip levels. Each level changes the monitor's color and
selecting level **1** causes the screen to blink briefly before remaining red
until another level is chosen.

Run it with:

```
services/defcon_control.lua
```

For additional technical details see `docs/README.md`.
