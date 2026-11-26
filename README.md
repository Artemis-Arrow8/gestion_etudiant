# Application mobile de gestion des étudiants

Projet fil rouge — Développement d'applications mobiles 2 (Licence 3, Genie Logiciel ITMA) — Flutter / Dart.

> Réalisé par : Kadiatou H. Guindo *(groupe à compléter)* · Enseignante : Dr COULIBALY Kadidiatou DJIBO
> Dépôts : https://github.com/Artemis-Arrow8/Gestion_etudiant · https://gitlab.com/Artemis-Arrow8/gestion_etudiants
> Mini-rapport (PDF, 5 pages) : [`docs/mini-rapport-tp5.pdf`](docs/mini-rapport-tp5.pdf)

## Présentation

Application qui permet à un étudiant de consulter son espace pédagogique depuis son téléphone :
profil, cours, notes, notifications et vérification de sa présence sur le campus.

**Public visé :** étudiants universitaires. **Plateforme :** Android (code multiplateforme).

## Compte de démonstration

| Email | Mot de passe |
|---|---|
| `awa.traore@etudiant.test` | `Demo@2026` |

**Authentification simulée :** le compte est fictif. Le code ne contient que l'empreinte SHA-256
du mot de passe.

## Fonctionnalités

| Fonctionnalité | Réalisation |
|---|---|
| Connexion | Validation des champs, affichage du mot de passe, message en cas d'échec — **authentification simulée** |
| Session | « Se souvenir de moi » (`shared_preferences`) et déconnexion avec confirmation |
| Tableau de bord | Message de bienvenue, 3 indicateurs (cours, moyenne, notifications), « Mes cours récents », raccourcis |
| Profil | Avatar, nom, matricule, email, filière, niveau |
| Cours | 6 cours (code, intitulé, enseignant, crédits), recherche, action « Voir les notes » |
| Notes | Notes des mêmes cours, moyenne pondérée par les crédits |
| Notifications | Liste chargée depuis l'API REST |
| États | Chargement, succès, liste vide, erreur avec « Réessayer » |
| Fonction native | Géolocalisation : présence sur le campus ; permission demandée au clic, refus simple et définitif gérés |
| Interface adaptative | Barre du bas sur téléphone, menu latéral à partir de 600 px, aucun débordement sur 320 px |
| Version Release | APK Android |

## Données

- **Jeu de données local** (`assets/data/`) : catalogue des cours et notes, reliés par le code du cours.
- **API REST JSONPlaceholder** : enseignants (`/users`) et notifications (`/posts`).
- Hors connexion, les cours et les notes restent disponibles.

Détail des fichiers et des champs : [`docs/donnees.md`](docs/donnees.md).

## Architecture (MVVM)

```
lib/
├── main.dart
├── models/         Student, Course, Grade, Instructor, NotificationModel, GeoPoint
├── screens/        Écrans (affichage uniquement)
├── viewmodels/     États et logique de présentation
├── repositories/   Accès aux données (origine cachée au ViewModel)
├── services/       API REST, fichiers JSON, stockage local, GPS, authentification simulée
├── widgets/        Composants réutilisables
└── utils/          Thème, couleurs, constantes, validateurs
```

Écran → ViewModel → Repository → Service → API / fichiers JSON / stockage / GPS.
Rôle de chaque couche : [`docs/architecture.md`](docs/architecture.md).

## Technologies

Flutter, Dart, `http` (API REST), `shared_preferences` (session), `geolocator` (GPS),
`crypto` (empreinte SHA-256), API [JSONPlaceholder](https://jsonplaceholder.typicode.com).

## Prérequis

- Flutter SDK (Dart 3.13 ou plus récent) et Android SDK
- Un émulateur ou un téléphone Android (internet pour les enseignants et les notifications)

## Installation et exécution

```bash
flutter pub get
flutter run
```

APK : `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`

## Tests

```bash
flutter analyze   # No issues found!
flutter test      # 53 tests réussis
```

Tests T1 à T6 du TP3, scénarios API du TP4 (200, liste vide, 404/500, JSON invalide,
réseau indisponible, timeout), ViewModels, cohérence des données et permission GPS.
Liste détaillée : [`docs/tests.md`](docs/tests.md).

## Captures d'écran

| Connexion | Tableau de bord | Cours |
|---|---|---|
| ![Connexion](docs/screenshots/01_connexion.png) | ![Tableau de bord](docs/screenshots/02_tableau_de_bord.png) | ![Cours](docs/screenshots/03_cours.png) |
| **Notes** | **Profil** | **Présence** |
| ![Notes](docs/screenshots/04_notes.png) | ![Profil](docs/screenshots/05_profil.png) | ![Présence](docs/screenshots/06_presence.png) |

## Limites connues

- **Connexion :** authentification simulée, un seul compte de démonstration. La validation côté
  mobile ne remplace pas une validation par un serveur.
- **Enseignants et notifications :** données de démonstration de JSONPlaceholder (noms fictifs,
  texte des notifications en latin).
- **Cours et notes :** jeu de données local fictif.
- **Présence :** coordonnées du campus approximatives (`lib/utils/app_constants.dart`).
- **Livraison :** APK signé avec la clé de débogage, icône Flutter par défaut et identifiant
  `com.example.gestion_etudiant`, à changer avant une publication sur Google Play.
