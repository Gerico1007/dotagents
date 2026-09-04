# 🔥 PHOENIX — la reprise de l'atelier musique de Jerry ⚡

*Phoenix est un genre d'arbre — le palmier-dattier — et il porte le nom de
l'oiseau qui renaît de ses cendres. Jerry a choisi ce nom : c'est une
résurrection, pas un remplacement.*

Écrit le **2026-09-03** par la voie `w17:p6` (Opus 5, 1M), qui tient l'atelier
depuis le 14 août et arrive au bout de son contexte. Tout ce qui est chiffré ici
a été **mesuré**, pas supposé. Réponds en français ; il passe à l'anglais sans
prévenir, suis-le.

---

## 0. LIS CECI EN PREMIER — pourquoi tu existes

Le 20 août, Jerry a laissé ce message. **Il ne m'était pas adressé** : une autre
voie avait repris l'atelier sans contexte, et avait produit des vidéos ratées.

> « C'est vraiment pas ce que je recherchais. La tête rouge ne déroule pas sur
> les partitions. Les partitions ne déroulent pas non plus — elles sont un bloc
> à la fois, une mesure à la fois. Si tu regardes les anciens vidéos on voit
> clairement que ça déroule. […] **Je veux que tu comprennes que tu n'as pas le
> même contexte que l'agent qui a travaillé sur l'opus 014.** C'est mon erreur,
> je dois réussir à te donner un meilleur contexte. […] Il y a trop de marge à
> l'erreur. »

**Ce brief est la réponse à ça.** Il n'est pas resté sans réponse depuis 14
jours par négligence : le Monitor de la voie précédente était mort et rien ne
la réveillait. Le fichier est `260820103823.m4a`, il n'est rattaché à aucune
composition. **Écoute-le, réponds-lui, rattache-le.**

Ce même message contient une deuxième demande, distincte et non musicale :
> « Ressors-moi toutes les actions, toutes les prises de décision, toutes les
> skills et scripts qui ont permis d'accomplir ta prise de décision, tous les
> résultats, tous les fichiers envoyés au script, pour une analyse complète du
> travail. Rien de musical ici. »

Elle est **toujours ouverte**. Ce brief en est une partie ; s'il la redemande,
le §4 est ta matière première.

---

## 1. Ta première action, dans cet ordre

```bash
export PIXEL_RECORDER_URL=https://localhost:8828
cd ~/.agents/skills/episode-voice-channel && ./scripts/episode preflight
~/.agents/skills/jamai-morning/scripts/jamai-watch --status
```

Puis **lis en entier** :
- `~/.agents/skills/jamai-morning/SKILL.md` — la méthode
- `~/.agents/skills/episode-voice-channel/SKILL.md` — le transport
- ce brief

**Arme un Monitor** sur `~/.local/state/episode-voice/jamai-watch.log`, motifs
`DÉPÔT`, `crochet en échec`, `MUET`, `arrêté`, `veille démarrée`, `échec`,
`erreur`. **C'est comme ça qu'il te parle.** Le Monitor de la voie précédente
est mort sans bruit le 16 août ; la veille, elle, a continué à tout capter.
**Un Monitor mort ressemble exactement à un atelier silencieux.**

### ⚠️ Le portail : 8828, et l'identité ne suffit pas
Le **8768 répond `jamai` lui aussi**, même racine, autre arbre de code. C'est le
couple **(port, arbre)** qui distingue :
```bash
ss -ltnp | grep :8828 ; readlink /proc/<pid>/cwd    # doit dire ~/salix/run/jamai-portal
```
Le 8830 sert l'atelier `abies` (une autre voie). Le défaut d'`episode` dans le
code est 8828, mais **sa propre documentation dit encore 8768** — épingle la
variable, ne fais pas confiance au défaut.

---

## 2. Qui est Jerry, et comment il travaille

**IL N'EST PAS DEVANT L'ÉCRAN. Publier n'est pas une permission à obtenir,
c'est le canal lui-même.** Ses mots du 10 août :

> « t'es censé publier là. Pas me poser des questions comme ça, publie. Si tu ne
> m'envoies pas, je ne peux pas savoir que tu me demandes des envoyés. »

**L'ordre, à chaque fois :**
1. `jamai-publish-melody --slug <explicite>` — sans `--slug` le slug casse sur les accents
2. **mesurer l'artefact réellement EN LIGNE**, pas le rendu local
3. la vidéo qui défile (§5) — c'est ce qui se regarde sur un téléphone
4. `episode note <op>` — quoi / pourquoi / ensuite
5. `episode say --persona aureon` — **voix française**, sous 30 s (`jamai`, `nyro`, `synth` sont anglophones)
6. `episode text <op> --source <clip>` — le verbatim de ce que tu as dit

**Tes questions vont dans la note ET dans la voix, jamais seulement dans le
terminal, et elles n'empêchent jamais l'envoi.**

### Ses trois canaux, et comment il te dit lequel
| il est… | tu lui parles par… |
|---|---|
| en marche / au loin | `episode say` dans la composition — il écoute sur son téléphone |
| **dans la cuisine** | `jamai-say-kitchen "…"` (enceinte) + `jamai-cast-visual <page.html>` (télé) |
| devant la télé | `catt -d "Television" cast <fichier.mp4>` lancé **détaché** (§5) |

Il annonce le changement : « je pars à la marche », « je suis rendu dans la
cuisine ». **Change de canal quand il le dit.**

⚠️ **La preuve n'est JAMAIS « la commande a répondu »** : c'est un temps qui
avance (`catt … status`) ou une ligne dans le journal du serveur. Le cache
d'appareils périme — `jamai-cast-visual --rescan` quand « device not found ».

### Ses préférences, non négociables
1. **Croches ligaturées**, groupées par temps. En ABC ce sont les **espaces de la source** qui décident.
2. **Jamais un voicing de guitare inventé.** Il donne des doigtés exacts : calcule, ne devine pas.
3. **`git add` par nom de fichier. Jamais `-A`, jamais `.`, jamais `-u`.** Et `git commit -- <chemins>`, parce que `commit` prend tout l'index.
4. **Il aime choisir : deux versions valent mieux qu'une question.**
5. **Nomme un choix comme un choix et un trou comme un trou.**
6. **Il écrit des accords SANS TIERCE, et c'est une signature.** Quatre pièces de suite. **Ne complète jamais un accord en lui ajoutant une tierce.**
7. **Quand il conteste : REMESURE, ne défends pas.** Il a eu raison **six fois** en deux jours.

### Ses seuils de stridence — bande 2-5 kHz **EN AMPLITUDE**
`13,12 % rejeté` · `5,98 % accepté` · `~3 % pour une pièce douce`.

⚠️ **L'échelle est l'AMPLITUDE, pas la puissance.** Même son : 18,3 % en
amplitude, 2,5 % en puissance. Se tromper d'échelle fait passer une pièce
stridente pour douce d'un facteur dix.

⚠️ **Et ces seuils viennent de pièces à DEUX voix sans batterie.** Une pièce à
quatre ou cinq voix avec un kit ne les atteint pas — mesuré une dizaine de fois.
**Dis le chiffre, dis d'où vient le seuil, et laisse son oreille trancher.**

---

## 3. Où sont les choses

| chemin | quoi |
|---|---|
| `~/Recordings-jamai/` | ce qu'il dépose — **211 fichiers** au 3 septembre |
| `~/compositions-jamai/` | l'atelier ; dépôt git `Gerico1007/assembly-jamai` |
| `~/salix/production/ngrok-mux/static/jamai/melody/` | les mélodies publiées |
| `~/.agents/skills/jamai-morning/scripts/` | les outils (§5) |
| `~/.local/share/jamai-cast/web/` | les pages pour la télé + `_socle.css` |
| `~/.local/state/episode-voice/drops/<fichier>/` | **le relevé que le crochet a déjà écrit pour chaque dépôt** |
| `~/.agents/briefs/INDEX.md` | l'index des voies — **qui écrit un brief y ajoute sa ligne le jour même** |

**Compositions vivantes** : `op-013-paranoia` (réb majeur), `op-014-les-quatre-accords` (do majeur, 36 clips), `op-015-annie` (lab majeur, avec son amie Annie).

**Deux dépôts jamais rattachés** : `260806153232.m4a` (un message Facebook, pas
de la musique — le laisser) et `260820103823.m4a` (**sa critique, à traiter**).

---

## 4. L'OPUS 014 — la méthode qu'il veut refaire

**C'est le cœur de ce brief.** En une journée, l'opus 014 est passé de quatre
accords nommés à l'oral à une chanson complète de 65 mesures avec clip vidéo.
Voici comment, étape par étape, parce qu'il veut le refaire.

### 4.1 Le point de départ : il nomme, on mesure
Il a dit : « do majeur, la mineur, sol majeur, mi mineur, étouffé de paume,
tempo 90, la mélodie à la basse, noire pointée · croche · blanche puis noire
pointée · croche · noire pointée · croche ».

**Sa figure tombait juste au centième** : 3+1+4 = 8 croches et 3+1+3+1 = 8, deux
mesures de 4/4 pile. **Vérifié dans le MIDI**, durées 1,50 · 0,50 · 2,00 noires.
→ **Toujours vérifier sa dictée rythmique dans le MIDI rendu. Il dicte juste.**

Sa prise de guitare de 17 h 37 était **illisible** (aucun pouls, chroma plat,
hauteurs à ±50 cents). J'ai refusé d'en tirer une grille. **Do majeur sortait
deuxième à 65,6 % sur douze tonalités testées — la mesure pointait au bon
endroit sans pouvoir trancher, et c'est LUI qui a tranché.** Ne tranche pas à sa
place quand la mesure hésite ; dis qu'elle hésite.

### 4.2 La construction, section par section
| section | mesures | ce qui la fait |
|---|---|---|
| INTRO | 8 | arpège sur SA figure, **aucune batterie** |
| COUPLET | 8 | l'arpège passe aux **croches égales** (le débit double), la batterie entre à la mesure 10 et monte en **7 paliers : 2 · 6 · 10 · 12 · 13 · 14 · 15 frappes** |
| REFRAIN | 8 | **la mélodie arrive**, la batterie **tient** au niveau du sommet |
| COUPLET 2 | 8 | la mélodie **se retire**, la batterie ne retombe pas |
| REFRAIN 2 | 8 | la mélodie revient |
| **PONT** | 8 | **les cordes** reprennent les accords, **deux mesures par accord**. La batterie descend à 2 frappes puis **remonte à 14** |
| REFRAIN 3 | 8 | **17 frappes/mesure**, le sommet du morceau |
| FERMETURE | 9 | la mélodie revient **en descendant**, ralenti, une 65ᵉ mesure |

### 4.3 LES CINQ LEÇONS PAYÉES — ce sont elles qu'il veut voir réappliquées

**① Un refrain doit être PLUS que le couplet, sur toutes les dimensions.**
Mon premier refrain a été refusé : « je n'ai pas senti que ça faisait partie de
la chanson ». Mesuré, il était **moins** que le couplet sur cinq dimensions :

| | fin du couplet | mon refrain raté |
|---|---|---|
| frappes/mesure | 15 | 5 puis 2 |
| silence rythmique | 18 % | **81 %** |
| mélodie nouvelle | — | **aucune** |
| figure rythmique | la sienne | **la même** |
| registre · tempo | — | identiques |

**Le mécanisme :** un crescendo de sept paliers qui débouchait sur la section la
plus VIDE du morceau. *Une montée promet une arrivée ; celle-là livrait une
soustraction.* C'est littéralement ce qu'il appelle « ça baisse le groove ».

**② RETENIR N'EST PAS RETOMBER.** Au pont et au retour du couplet, la batterie
ne repart jamais de zéro. Ce qui fait entendre le retour au couplet, c'est **la
mélodie qui se retire**, pas une chute d'énergie. On enlève ce qui chante, pas
ce qui pousse.

**③ Le masque se mesure.** Il a entendu « les accords couvrent le cor ».
Vérifié : cor do#3→fa4 (durée médiane **1,00** noire), nappe fa#3→la#4 (durée
médiane **3,96**) → **71 % de recouvrement de registre**. Corrigé en montant les
accords d'une octave et en les **piquant** au lieu de les tenir → **0 %**.
→ **Avant d'empiler deux voix, mesure leur recouvrement de registre et leur
durée médiane.**

**④ L'instrument se choisit sur mesure, jamais au goût.** Chaque fois, mon
premier réflexe était le pire :
- guitare **acier** 12,31 % → **nylon 5,75 %** (la seule vraie guitare qui passe)
- **violoncelle** 10,18 % → **cor d'harmonie 2,77 %**
- cymbale **crash** 10,72 % → **tom grave 5,48 %**
- **flûte + clarinette 25,82 %** (le pire de dix couples) → **cor + basson 3,59 %**

Méthode : rendre la MÊME partition avec plusieurs `%%MIDI program`, via
`fluidsynth -ni -F out.wav -r 44100 -g 0.9 /usr/share/sounds/sf2/FluidR3_GM.sf2`,
et mesurer la bande 2-5 kHz en amplitude sur chacune.

**⑤ La fin ne doit pas finir sec.** Il a dit « ça finit trop sec ». Corrigé :
la mélodie revient sur les **trois dernières mesures en DESCENDANT** (mi5 → do4,
16 demi-tons), une **65ᵉ mesure** ajoutée (blanche pointée + silence de noire),
et un **ralenti mesure par mesure : 84 · 76 · 68 · 58**.

**⑥ Une note trop haute tenue trop longtemps crie.** Mesure 56, sol5 tenu 4
temps : « vraiment trop intense ». Remplacé par **do5+mi5** (la tierce, pas la
quinte, avec une harmonie une tierce en dessous). Mesuré : aigu 1,5-4 kHz
**24,42 % → 20,27 %**, RMS 0,1417 → 0,1847. *Moins criard, plus plein.*

### 4.4 L'arc final, mesuré en RMS — la forme d'une vraie chanson
```
intro 0,0803 · couplet 0,0832 · REFRAIN 0,1356 · couplet 0,0845
REFRAIN 0,1350 · pont 0,1000 · REFRAIN 3 0,1458 ← le sommet · fin 0,0829
```
**Le refrain monte trois fois et la troisième est la plus haute. Le pont se
tient ENTRE le couplet et le refrain — il retient, il ne creuse pas.**
→ **Mesure cet arc à chaque assemblage. C'est le contrôle le plus utile qui
existe pour savoir si une chanson tient.**

---

## 5. LES OUTILS — et le défaut du 20 août que tu dois ne PAS refaire

### `jamai-scroll.py` — la partition qui DÉFILE, avec la barre rouge
*(s'appelait `jamai-defile.py` jusqu'au 2026-08-15 ; ce nom-là n'existe plus)*
```bash
~/.agents/skills/jamai-morning/scripts/jamai-scroll.py \
   <partition.png> <audio.mp3> <sortie.mp4> <sec/mesure|liste> <nb_mesures> [partition.svg]
```

**LA RÈGLE, ÉCRITE DANS SA MÉMOIRE ET DANS LE SKILL** — ses mots du 14 août :
> « je trouve ça vraiment génial la ligne rouge qui défile […] **je veux que
> tous les vidéos comportent cette barre rouge qui défile.** »

**C'est exactement ce qui a été raté le 20 août** : « la tête rouge ne déroule
pas, les partitions ne déroulent pas non plus, elles sont un bloc à la fois ».
Une vidéo faite avec `episode video --image … --audio …` donne une **image
fixe** — ce n'est PAS ce qu'il veut. **Jamais d'image fixe. Toujours le défilé.**

**Trois choses non négociables dedans, chacune payée :**
1. **UNE SEULE PORTÉE.** `%%pagewidth` large + `%%barsperstaff N` + `-B N`.
   Au-delà de ~40 mesures, `abcm2ps` sort *« Output buffer overflow »* et ne
   produit **aucun fichier, sans erreur ailleurs** → `-k 8192`.
2. **Le panoramique est PAR MORCEAUX**, jamais linéaire. `abcm2ps` espace les
   mesures selon leur contenu (mesuré : de **298 à 608 px** sur la même ligne).
   Les positions se lisent **dans le SVG**, pas dans les pixels :
   `<text x="341.54" …>2</text>` avec `%%measurenb 1`. La détection au pixel
   marchait sur 2 portées et **échouait sur 3** (10 mesures trouvées au lieu de
   16, aucun seuil ne donnait le bon compte).
3. **La tête de lecture est un `overlay`, JAMAIS un `drawbox`.** Mesuré :
   `drawbox` **n'évalue pas `t`** dans son expression `x` — son paramètre
   d'épaisseur s'appelle aussi `t` et masque la variable. Avec `x='t*100'` il ne
   dessine **rien** ; `overlay` donne 51 / 201 / 401 px à t = 0,5 / 2 / 4 s.
   Et la tête doit être dessinée à *(position jouée − décalage de la fenêtre)* :
   sinon elle se fige aux deux bouts pendant que la musique continue.

**L'outil REFUSE de produire une vidéo si le compte de mesures ne correspond
pas.** C'est voulu. Ne contourne pas ce garde-fou.

**Vérifie TOUJOURS par l'image** : extrais 2-3 arrêts et compare la tête au
numéro de mesure attendu. *Un compte qui tombe juste n'est pas une preuve.*

### `jamai-clip.py` — sa vidéo en fond, la partition fondue par-dessus
```bash
jamai-clip.py <fond> <partition-rgba.png> <audio> <sortie.mp4> \
              <sec/mesure|liste> <nb_mesures> [bande_y] [assombri] [partition.svg]
```
- La partition devient une image **RVBA** : blanc pur, l'alpha porte l'encre.
  **Opacité 0,55** (il l'a demandée : « plus transparent pour qu'on voie le visuel »).
- `blend=all_mode=screen` rend **toute l'image MAGENTA** — espaces
  colorimétriques différents. Utiliser `overlay` avec un vrai canal alpha.
- Ses prises sont **verticales** (1080×1920, drapeau de rotation) : élargir à la
  toile puis recadrer une bande — et **ses pieds ne sont pas à la même hauteur
  d'une prise à l'autre**, d'où le paramètre `bande_y`.
- **Place les coupes à la MESURE, pas à l'œil** : mesure la chaleur (R−B) et le
  vert (G−(R+B)/2) image par image de ses prises pour savoir où le soleil ou les
  arbres apparaissent. C'est comme ça que le soleil est tombé pile sur le refrain.
- Fond noir uni = « la partition seule, plein écran » — il en a demandé pour
  certains couplets.

### Pour la télé
```bash
nohup catt -d "Television" cast <fichier.mp4> > /tmp/catt.log 2>&1 &
```
**Jamais par le serveur 8899** : c'est un `SimpleHTTPServer` qui **ignore les
requêtes Range** (mesuré : HTTP 200 avec 127 Mo entiers au lieu d'un 206). Le
Chromecast annonce « Playing » et n'affiche rien. Le serveur de `catt` répond
206. **`catt` sert le fichier pendant toute la lecture — lance-le détaché.**
Réencode sous ~70 Mo. Pour la composition, ~40 Mo : **122 Mo ne s'ouvre pas sur
son téléphone** (il l'a signalé).

---

## 6. LES PIÈGES MUETS — même forme : fichier valide, aucune erreur, résultat faux

1. **Une LIGNE VIDE termine le morceau en ABC.** MIDI valide de 323 octets, zéro note, zéro avertissement. Sépare par `%`.
2. **`%%MIDI gchordoff` est PAR VOIX.** En en-tête il ne couvre que la première.
3. **Une altération se propage jusqu'à la fin de la mesure**, à travers les octaves.
4. **`clef=treble-8` SONNE une octave plus bas que l'écriture.** Piège payé : arpège monté d'une octave dans le texte → **100 % de recouvrement** avec la basse dans le MIDI.
5. **`abc2midi` TRONQUE un tempo décimal.** `Q:1/4=90.18` → **90,000 BPM**. Et `90.8` → 90,0 : il tronque, il n'arrondit pas. Aucun avertissement.
6. **Valeurs non notables.** 5/8 et 7/8 sortent en « ronde à trois points ». Ramène à 1,2,3,4,6,8 — **après** la troncature ET **après** la coupe sur la barre de mesure, qui les recréent toutes les deux.
7. **La colonne `temps` de `jamai-midi.py` est en NOIRES, pas en secondes.**
8. **La queue muette.** Un ralenti final a produit un fichier de **443 s pour 176 s de musique** — 60 % de vide. Mesure où le son s'arrête et coupe.
9. **L'URL publique sert parfois l'ANCIEN fichier après republication.** md5 différent du disque. Contourne avec `?v=<horodatage>` et **compare les md5**.
10. **La durée d'une note ≠ sa valeur rythmique.** La durée sonnante d'une voix (0,255 s) est le temps avant qu'il respire ; la valeur rythmique est **l'intervalle jusqu'à l'attaque suivante** (0,790 s). Confondre les deux écrit une mélodie en doubles-croches qui sonne deux fois trop vite. **Il l'a entendu avant moi.**
11. **Sur une prise très grave, le chromagramme ordinaire ne dit RIEN** (12 classes entre 4,8 % et 13,3 %). Une **FFT fine (16384 points, 2,7 Hz)** sur les fondamentales 70-700 Hz résout les hauteurs au cent près.
12. **Le crochet classe parfois PAROLE en MUSIQUE.** Un message enregistré dans la rue reste alors **non transcrit**. Le portail refuse aussi les `.mov` à `/transcribe`. Extrais l'audio et appelle Groq directement (clé dans `~/.env`, **non quotée**).
13. **Les noms de notes ne survivent pas à la synthèse vocale.** « mi ré do ré » est revenu **« mirer doré »**. Les hauteurs vont **à l'écran**.
14. **Deux imports dans la même seconde** sont refusés par le portail.

**Compte les notes après chaque rendu. Regarde la partition en image.** Tous les
défauts de gravure ont été trouvés comme ça.

---

## 7. Ta frontière

- **Tu fais de la musique.** L'audit de sécurité (`w1J`), la voie « structure de chanson » (`w1E`) et l'atelier `abies` (`w1B`) ne sont pas à toi.
- **Ne câble rien en systemd sans son mot.** La veille `jamai-watch.service` existe déjà et tourne — n'y touche pas.
- **Ne touche à aucun pane voisin.** `idle` ne veut pas dire libre.
- **`git add` par nom.** Commit après chaque écriture de source.

## 8. Les marques qui prouvent que tu as pris la relève

1. Le Monitor est armé et tu l'as dit.
2. `260820103823.m4a` est **écouté, répondu et rattaché** à une composition.
3. Sa demande d'« analyse complète du travail » a reçu une réponse ou une date.
4. Ta ligne est dans `~/.agents/briefs/INDEX.md`, **le jour même**.

---

🌸 Tu ne remplaces personne : tu reprends une conversation qui dure depuis
trois semaines et qui s'est arrêtée sur une critique restée sans réponse. La
première chose à faire n'est pas de composer — c'est de lui dire que tu l'as
entendu.
