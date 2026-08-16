---
name: gmusic-routine
description: Répondre à Jerry selon le moment de sa journée — quel appareil lui parle, sur quel ton, et quand se taire. À charger dès qu'il annonce où il est ou ce qu'il fait : « je suis dans la cuisine », « je cuisine », « je ne peux pas voir l'écran », « je sors », « je vais me coucher », « parle-moi », « mets-le sur la télé » — et dès qu'une réponse partirait dans un terminal que personne ne regarde.
---

# Répondre au moment, pas à l'écran

Jerry annonce un moment. Ce moment dit **quel appareil** répond, **sur quel ton**,
et **quand se taire**. Une commande unique tient la charnière :

```bash
routine                          # les moments déclarés
routine <moment> posture         # à LIRE avant de composer la réponse
routine <moment> say "…"         # la voix, sur l'enceinte de ce moment
routine <moment> show page.html  # l'image, sur l'écran de ce moment
routine <moment> exit            # en partant
routine new                      # en écrire un — il scanne avant de demander
```

## Les trois couches — ne pas les mélanger

| couche | dépôt | ce qu'elle sait |
|---|---|---|
| l'outil | `gmusic1007/jamai-core` | comment faire la chose — **jamais chez qui** |
| le moment | `gmusic1007/gmusic-routine` | quel appareil, quelle voix, quel ton |
| la phrase | *cette skill* | ce que Jerry dit pour déclencher |

**Ne jamais appeler `jamai-say` ou `jamai-cast` directement.**
Elles refusent désormais de partir sans qu'on leur nomme un appareil — et ce
nom appartient au moment, pas à toi. Passe par `routine`.

`routine` vient de `jamai-core` (couture `moments/`) ; les moments eux-mêmes
viennent de `gmusic-routine`. Si l'un manque, relancer l'`install.sh` du dépôt
concerné.

## Lire la posture avant de répondre

`routine <moment> posture` rend une consigne écrite pour toi, pas pour une
machine. Elle décide **du ton et de la longueur**, jamais du canal. Lis-la avant
de composer, pas après.

Pour `kitchen` elle dit, en substance : la voix porte le sens, l'ordre des
choses et ce qu'il faut décider ; l'écran porte les chiffres et les noms qu'on
ne retient pas à l'oreille. **Jamais lire un tableau à voix haute. Jamais mettre
un raisonnement à l'écran. Toujours les deux ensemble.**

## La preuve, jamais l'assurance

Les deux canaux impriment une preuve, et il faut la lire :

- l'image → la ligne du serveur montrant que l'appareil a **tiré** la page
- la voix → un `Time:` qui **avance**

« La commande a répondu » ne prouve rien. Preuve absente → le dire tel quel :
c'est souvent le réseau, pas le script. Un échec se relance **une** fois ; deux
d'affilée, on l'annonce au lieu d'insister.

## L'écran, mesuré — ne pas re-litiger

1280 × 720 CSS px, Chromium 90 (donc **pas** de `:has()`, pas de container
queries). La télé rogne les bords : trois calibrages lus depuis la cuisine, et
Jerry a tranché **93 % — 1190 × 670**. Tout est dans `_socle.css`, posé par
`gmusic-routine`. Écrire la page avec ses classes (`.scene`, `.sure`,
`.bandeau`, `.coeur`, `.pied`, `.titre`, `.fiches`) et **rien sous 2.4vh** : ça
se lit debout, à trois mètres. **On ne scrolle pas une Chromecast** — si ça
déborde, couper le contenu, jamais réduire la police.

## Trois pièges payés une fois

| piège | ce qu'il faut faire |
|---|---|
| La télé **refuse l'audio seul** | mp4 h264/aac pour l'image animée ; le son va sur l'enceinte |
| `catt cast_site` se bloque si une app tourne déjà | `catt stop` avant — `jamai-cast` le fait |
| `episode say` **ne parle pas à voix haute** | il importe un m4a dans le portail ; pour sonner dans une pièce, c'est `routine <moment> say` |

## Ce que ça change dans la conversation

Quand Jerry est dans un moment, la réponse écrite n'est plus le livrable : c'est
la trace. Le livrable est ce qu'il a **vu** et **entendu**. Composer d'abord ce
qu'on va dire, puis la page qui le soutient — pas l'inverse. Et en partant,
`sortie` : sans elle, on continue de parler à une pièce vide.
