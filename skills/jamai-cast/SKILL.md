---
name: jamai-cast
description: Parler à Jerry et lui montrer quelque chose quand il n'est pas devant l'écran — une page sur la télé de la cuisine, une phrase sur l'enceinte. À charger dès qu'il dit qu'il est dans la cuisine, qu'il cuisine, qu'il ne peut pas voir l'écran, « dis-le-moi à voix haute », « mets-le sur la télé », ou dès qu'une réponse longue partirait dans un terminal que personne ne regarde.
---

# Répondre dans la cuisine

Jerry compose dans sa cuisine. Une réponse qui n'arrive que dans un terminal
n'arrive pas. Deux commandes, déjà sur le PATH :

```bash
jamai-cast-visual page.html      # l'image sur la télé   (--status, --stop, --url)
jamai-say-kitchen "…"            # la voix sur l'enceinte (edge-tts, fr-CA-SylvieNeural)
```

Elles vivent dans **`gmusic1007/jamai-core`**, couture `diffusion/`. Si une
commande manque : `~/salix/repos/jamai-core/install.sh` (puis `--check`).

## La règle du couple

**Télé = image. Enceinte = son.** Toujours les deux ensemble : la page porte
les chiffres et les noms qu'on ne peut pas retenir à l'oreille ; la voix porte
le sens, l'ordre des choses, et ce qu'il faut décider. Ne jamais lire un
tableau à voix haute ; ne jamais mettre à l'écran un raisonnement.

## La preuve, jamais l'assurance

Les deux commandes impriment une **preuve** et il faut la lire :

- cast → la ligne du serveur montrant que l'appareil a **tiré** la page
- say → un `Time:` qui **avance**

« La commande a répondu » ne prouve rien. Si la preuve manque, le dire à Jerry
tel quel — c'est souvent le réseau, pas le script. Un envoi qui échoue se
relance une fois ; deux échecs de suite = l'annoncer, pas insister.

## L'écran, mesuré — ne pas re-litiger

1280 × 720 CSS px, Chromium 90 (donc **pas** de `:has()`, pas de container
queries). La télé **rogne les bords** : Jerry a lu trois calibrages depuis la
cuisine et tranché **93 % — 1190 × 670**. Tout est déjà dans
`web/_socle.css`, la seule feuille de style. Écrire la page avec ses classes
(`.scene`, `.sure`, `.bandeau`, `.coeur`, `.pied`, `.titre`, `.fiches`) et
**rien sous 2.4vh** : ça se lit debout, à trois mètres.

**On ne peut pas scroller une Chromecast.** Si le contenu déborde, il est
perdu — couper le contenu, jamais réduire la police.

## Trois pièges payés une fois

| piège | ce qu'il faut faire |
|---|---|
| La télé **refuse l'audio seul** (mp3 → « No suitable format was found ») | mp4 h264/aac pour l'image animée ; le son va sur l'enceinte |
| `catt cast_site` se bloque si une app tourne déjà | `catt stop` avant — `jamai-cast-visual` le fait |
| `episode say` **ne parle pas à voix haute** | il importe un m4a dans le portail ; pour sonner dans une pièce, c'est `jamai-say-kitchen` |

## Ce que ça change dans la conversation

Quand Jerry est dans la cuisine, la réponse écrite n'est plus le livrable :
c'est la trace. Le livrable, c'est ce qu'il a **vu** et **entendu**. Écrire
d'abord ce qu'on va dire, puis la page qui le soutient — pas l'inverse.
