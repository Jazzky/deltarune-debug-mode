<img src="https://github.com/user-attachments/assets/ac88831a-bccd-4507-ae9d-c50faf9420e7" width="500" alt="logo"/>

Scripts de debug mode customisés pour Undertale Mod Tool fonctionnant avec Deltarune.\
Fonctionnent uniquement avec la version payante du jeu et la démo LTS en bêta Steam.

Conçu initialement pour l'équipe de fan traduction francophone [Deltarune FR](https://deltarune-fr.com).

[![English](https://img.shields.io/badge/Read_this_readme-in_English-blue)](README.md)

## 📖 Installation

* Télécharger le fichier `scripts.zip` depuis le menu <a href="releases">releases</a>.
* Extraire le fichier zip.

### Installation avec UTMT GUI

* Dans l'onglet `Scripts` d'Undertale Mod Tool, appuyer sur `Run other scripts...` .
* Sélectionner le bon fichier `debug_mode_chap[1-5].csx` en fonction du chapitre actuellement ouvert dans Undertale Mod Tool.
* Sauvegarder le fichier data.win modifié une fois qu'est apparue la fenêtre indiquant que le debug mode a été correctement installé.
* Répéter pour tous les chapitres.

### Installation avec UTMT CLI

* À l'aide d'un terminal de commande, exécuter la commande :\
`<chemin de UTMT CLI> load <chemin du data.win d'entrée> -s <chemin du script .csx> -o <chemin du data.win de sortie>`.

Ex. pour le chapitre 2 : `"...\UndertaleModCli.exe" load ".../DELTARUNE/chapter2_windows/data.win" -s ".../debug_mode_chap2.csx" -o ".../DELTARUNE/chapter2_windows/data.win"`

* Répéter pour tous les chapitres.

---

## 🛠️ Raccourcis principaux et fonctionnalités du debug mode

#### Général
| Touche(s) | Description |
| :--- | :--- |
| <kbd>F10</kbd> | Activer ou désactiver le debug mode |
| <kbd>D</kbd> | Ouvrir le menu debug |
| <kbd>S</kbd> | Sauvegarder la partie |
| <kbd>L</kbd> | Charger la dernière sauvegarde |
| <kbd>R</kbd> | Recharger la salle actuelle |
| <kbd>Retour arrière</kbd> + <kbd>R</kbd> | Relancer le jeu |
| <kbd>O</kbd> | Basculer entre 30, 60 et 120 FPS |
| <kbd>`</kbd> | Mettre le jeu à 150 FPS |
| <kbd>P</kbd> | Mettre le jeu à 1 FPS |

#### Navigation
| Touche(s) | Description |
| :--- | :--- |
| <kbd>Insert</kbd> | Se téléporter à la salle suivante |
| <kbd>Suppr</kbd> | Se téléporter à la salle précédente |
| <kbd>Clic milieu</kbd> | Ouvrir l'éditeur de salle |
| <kbd>Retour arrière</kbd> | Passer le segment d'intro (Spécifique au Chapitre 1) |

#### Combats
| Touche(s) | Description |
| :--- | :--- |
| <kbd>W</kbd> | Passer un combat |
| <kbd>Shift</kbd> + <kbd>W</kbd> | Passer un combat en recrutant les ennemis |
| <kbd>V</kbd> | Passer le tour de l'ennemi |
| <kbd>Alt</kbd> + <kbd>P</kbd> | Désactiver le défilement automatique des dialogues en combat |

#### Triche
| Touche(s) | Description |
| :--- | :--- |
| <kbd>G</kbd> | Activer ou désactiver le *Godmode* |
| <kbd>H</kbd> | Restaurer intégralement les PV de l'équipe |
| <kbd>T</kbd> | Remplir et vider la jauge de PT |
| <kbd>M</kbd> + <kbd>1</kbd> | Ajouter 100 $ à l'inventaire |
| <kbd>M</kbd> + <kbd>2</kbd> | Retirer 100 $ de l'inventaire |

## Autres fonctions

Certaines fonctions de debug déjà implémentées ont été conservées au travers des différents chapitres du jeu.

Pour celles-ci, les contrôles y sont donc les originaux et sont restés intouchés.

## Contribution

Si vous avez toutes sortes de suggestions ou vous rencontrez des bugs, n'hésitez pas à nous le faire savoir !
