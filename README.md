<img src="https://github.com/user-attachments/assets/ac88831a-bccd-4507-ae9d-c50faf9420e7" width="500" alt="logo"/>

Custom debug mode scripts to use with Undertale Mod Tool for Deltarune.\
Only works with paid version of the game and the LTS demo from the Steam beta.

Initially created for the french fan translation team [Deltarune FR](https://deltarune-fr.com).

[![Français](https://img.shields.io/badge/Readme_disponible-en_Français-red)](README.fr-FR.md)

## 📖 Installation

* Download the `scripts.zip` file from the [releases](https://github.com/Str4ky/deltarune-debug-mode/releases) menu.
* Extract the zip file.

### Installation with UTMT GUI

* In the `Scripts` tab  from Undertale Mod Tool, press on  `Run other scripts...` .
* Select the right `debug_mode_chap[1-5].csx` file based on the currently opened chapter in Undertale Mod Tool.
* Save the modified data.win file once as appeared the popup saying that the debug mode has been successfully installed.
* Repeat for each chapters.

### Installation with UTMT CLI

* With a terminal, execute this command:\
`<UTMT CLI path> load <entry data.win path> -s <.csx script path> -o <output data.win path>`.

Ex. for chapter 2 : `"...\UndertaleModCli.exe" load ".../DELTARUNE/chapter2_windows/data.win" -s ".../debug_mode_chap2.csx" -o ".../DELTARUNE/chapter2_windows/data.win"`

* Repeat for each chapters.

---

## 🛠️ Main shortcuts and debug mode features

#### General
| Key(s) | Description |
| :--- | :--- |
| <kbd>F10</kbd> | Toggle debug mode |
| <kbd>D</kbd> | Open debug menu |
| <kbd>S</kbd> | Save game |
| <kbd>L</kbd> | Load last save |
| <kbd>R</kbd> | Reload current room |
| <kbd>Backspace</kbd> + <kbd>R</kbd> | Restart game |
| <kbd>O</kbd> | Toggle between 30, 60 and 120 FPS |
| <kbd>`</kbd> | Set game to 150 FPS |
| <kbd>P</kbd> | Set game to 1 FPS |

#### Navigation
| Key(s) | Description |
| :--- | :--- |
| <kbd>Insert</kbd> | Go to next room |
| <kbd>Suppr</kbd> | Go to previous room |
| <kbd>Middle click</kbd> | Open room editor |
| <kbd>Backspace</kbd> | Skip intro sequence (Only Chapter 1) |

#### Battles
| Key(s) | Description |
| :--- | :--- |
| <kbd>W</kbd> | Skip battle |
| <kbd>Shift</kbd> + <kbd>W</kbd> | Skip battle with recruit |
| <kbd>V</kbd> | Skip enemy's turn |
| <kbd>Alt</kbd> + <kbd>P</kbd> | Disable battle dialog autoskip |

#### Cheat
| Key(s) | Description |
| :--- | :--- |
| <kbd>G</kbd> | Toggle *Godmode* |
| <kbd>H</kbd> | Fully restore party PV |
| <kbd>T</kbd> | Fill and empty TP bar |
| <kbd>M</kbd> + <kbd>1</kbd> | Add 100 D$ to inventory |
| <kbd>M</kbd> + <kbd>2</kbd> | Remove 100 D$ to inventory |

## More functions

Some debug functions already implemented as been left in each chapters.

For those, controls are still the one they have been assigned to and have been untouched.

## Contribution

If you have any suggestions or encounter bugs, feel free to let us know!
