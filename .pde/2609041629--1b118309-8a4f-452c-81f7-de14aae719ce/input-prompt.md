# Prompt de Jerry — 2026-09-04

## Ses mots, verbatim

> okay one of the things that we would want to do is to create a watch for
> Android device so if you look too a b i e s you can probably found some
> directory in which there's some musical content to analyze but I think it is
> set up to be sent to a specific folder inside of the computer kind of a repo
> that has origin the computer instead of git hub I don't know if it's clear
> what I'm seeing but actually we create music by looking in the folder
> recording but there is other folder in which I can put musical content with
> the Android phone some of the action that it's done by you could be executed
> by the Android phone and some others need to be done in a computer it's
> probably another intention in ply in my prom so probably we need a pde to
> analyze that

Il dit lui-même qu'il y a **plusieurs intentions repliées** dans ce prompt et
demande explicitement une décomposition.

## Contexte immédiat

Le prompt arrive juste après qu'il a montré `assembly-pi`, le dépôt où il bâtit
le successeur de la voie qui tient l'atelier musique. Le paquet `.pi/` y porte
déjà une extension `jamai-session-guide.ts` avec des commandes `jamai-watch
start|status|stop` et un outil `jamai_watch_scan`, et un document
`docs/jamai-v3-id-0003-requirements.md` qui dit que la **cartouche de
composition** doit devenir l'objet premier, pas le dossier surveillé.

## Réalité courante — MESURÉE le 2026-09-04, pas supposée

### Deux entrées de musique, pas une
- `~/Recordings-jamai/` sur **eury** — 211 fichiers, la source historique. C'est
  là que regarde la veille `jamai-watch` et toute la méthode `jamai-morning`.
- `~/studio/jamai/` sur **abies** (Android/Termux) — six cartouches :
  `id-0001`, `id-0002`, `id-0003`, `op-001-abies-join`, `op-018-tuesla`,
  `opab-001-related2-jreu-003`. **Rien ne surveille ce côté-là.**
- `~/Recordings/` sur abies ne contient que 2 fichiers de mai. Ce n'est pas
  l'entrée vivante.

### Le dépôt dont l'origine est l'ordinateur — il existe, il est nommé
`~/studio` sur abies est un lien vers
`/storage/emulated/0/Download/termux-offload-2026-08-27/studio`, qui **est un
dépôt git** dont l'origine est :

    ssh://gmusic@eury.ferret-harmonic.ts.net/srv/git/gmusic/studio.git

Un dossier par atelier. Le nu sur eury porte `aureon episodes jamai movement
nyro synth`. Copie de travail sur eury : `/srv/assembly/studio`.

### Le canal est cassé en DEUX endroits, mesuré
| où | état | date |
|---|---|---|
| abies, copie de travail | 2 commits locaux jamais poussés (`5dd21ca`, `8ba34a1`) | 24 août 13 h 15 |
| abies, fichiers | tout `id-0003` non commité, non suivi | 28-29 août |
| eury, dépôt nu `/srv/git/gmusic/studio.git` | `758292b` | **17 août 17 h 57** |
| eury, copie `/srv/assembly/studio` | `6ee4a05` — un commit derrière le nu | **17 août 16 h 41** |

Conséquence : **la musique faite sur le téléphone depuis le 17 août n'est jamais
arrivée sur l'ordinateur.** `id-0003` — 38 fichiers, la cartouche la plus riche,
celle dont le document v3 tire toutes ses exigences — n'existe que sur abies.

Défaut supplémentaire : `git` refuse d'opérer sur `~/studio` depuis Termux
(« detected dubious ownership », le dépôt est sur le stockage partagé Android).
Aucun script nommé `sync` n'a été trouvé dans `~/bin` ni `~/.local/bin` d'abies ;
les commits « Sync compositions <date> » ont donc une autre provenance.

### Un troisième dossier, orphelin
`~/4abies/` sur eury contient des dépôts bruts d'abies (m4a, mid,
`*_movement.jsonl`), derniers du **23 août**. Ce n'est pas un dépôt git et ce
n'est pas le même canal que `studio.git`.

### Ce qui existe déjà comme veilles
- `~/.agents/skills/jamai-morning/scripts/jamai-watch` — vivante sur eury
  (pid 4059578 depuis le 14 août), surveille `~/Recordings-jamai`.
- `~/.agents/skills/jamai-morning/scripts/abies-watch` et `ilex-watch` —
  existent déjà, non vérifiées dans cette session.
- La veille pi (`jamai-watch start` de l'extension) n'a **jamais tourné sur
  eury** : `~/.config/assembly-pi/jamai-watch-state.json` est absent.
- Le 20 août, une critique de Jerry est restée **14 jours sans réponse** parce
  que le Monitor qui devait réveiller la session était mort, alors que la veille
  de fond avait tout capté six secondes après le dépôt.

## Ce que le prompt semble contenir, à vérifier par la décomposition

1. Créer une veille pour un appareil Android.
2. Reconnaître qu'il y a **deux entrées** de contenu musical, pas une, et que
   l'atelier n'en surveille qu'une.
3. Le transport téléphone → ordinateur est un dépôt git dont l'origine est
   l'ordinateur, et il est en panne.
4. **Répartir le travail** : certaines actions peuvent s'exécuter sur le
   téléphone, d'autres exigent l'ordinateur. Cette frontière n'est écrite nulle
   part.
5. Une intention qu'il sent sans la nommer — c'est lui qui le dit.
