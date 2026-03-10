# Glutino 🥦

**Glutino** est une application mobile puissante et intuitive conçue pour accompagner les personnes coeliaques ou sensibles au gluten dans leur quotidien. Elle permet de scanner des produits pour vérifier leur composition et de trouver des restaurants adaptés à proximité.

## Fonctionnalités principales

- **Scanner de Produits** : Utilise l'appareil photo pour scanner les codes-barres et identifier instantanément si un produit contient du gluten via OpenFoodFacts.
- **Répertoire de Restaurants** : Géolocalisation des restaurants proposant des options sans gluten via OpenStreetMap (Overpass API).
- **Liste de Courses** : Gestion personnalisée d'une liste de courses persistante.
- **Profil Utilisateur** : Gestion des préférences de sensibilité, historique des produits scannés et restaurants favoris.
- **Mode Secours** : Système de protection intégré pour réinitialiser les données locales en cas de corruption ou de saturation de mémoire.

## Technologies utilisées

### Frontend
- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Gestion d'état** : Provider
- **UI/UX** : Google Fonts (Poppins), Iconsax, Lucide Icons, Animations sur mesure.
- **Scanner** : Mobile Scanner

### Backend & Services
- **Backend-as-a-Service** : [Firebase](https://firebase.google.com/) (Authentication pour la gestion des utilisateurs).
- **Stockage Local** : 
  - `SharedPreferences` (Préférences utilisateur, métadonnées).
  - `Flutter Secure Storage` (Données sensibles et favoris).

### APIs Externes
- **[OpenFoodFacts API](https://world.openfoodfacts.org/)** : Base de données mondiale pour les produits alimentaires.
- **[Overpass API (OpenStreetMap)](https://overpass-api.de/)** : Extraction de données géographiques pour les restaurants et cafés.

## Installation et Exécution

⚠️ **IMPORTANT : Exécution Web non supportée**
L'application est optimisée pour les terminaux mobiles. L'exécution sur navigateur Web (Chrome, Edge, etc.) risque d'entraîner des erreurs de mémoire ou de politique CORS (Cross-Origin Resource Sharing) liées aux APIs utilisées. **Veuillez exécuter l'application sur un appareil mobile réel ou un émulateur.**

### Prérequis
- Flutter SDK (version 3.0.0 ou supérieure)
- Android Studio / VS Code avec extensions Flutter/Dart
- Un compte Firebase configuré (pour l'authentification)

### Étapes préliminaires
1. **Cloner le projet** :
   ```bash
   git clone [url-du-repo]
   cd glutino
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

### Méthode 1 : Exécution sur un téléphone physique (Recommandé)
1. Activez le mode **Options pour les développeurs** sur votre téléphone Android (Tapez 7 fois sur le "Numéro de build" dans les paramètres).
2. Dans les options pour les développeurs, activez le **Débogage USB**.
3. Branchez votre téléphone à votre ordinateur via un câble USB.
4. Lancez le projet avec la commande :
   ```bash
   flutter run
   ```
   *(Si un popup apparaît sur le téléphone, autorisez le débogage USB).*

### Méthode 2 : Exécution sur un émulateur (Android Studio)
1. Ouvrez Android Studio et lancez le **Device Manager** (Gestionnaire d'appareils virtuel).
2. Créez et lancez un appareil virtuel (ex: Pixel 4, API 33).
3. Une fois l'émulateur démarré, dans votre terminal VS Code / Android Studio, tapez :
   ```bash
   flutter run
   ```

## Présentation des APIs et Endpoints

### Produits (OpenFoodFacts)
- **Rôle** : Récupérer les informations nutritionnelles et les ingrédients.
- **Endpoint Principal** : `https://world.openfoodfacts.org/api/v0/product/[barcode].json`

### Restaurants (Overpass API)
- **Rôle** : Rechercher des établissements (amenity=restaurant, cafe, fast_food) dans un rayon défini autour de l'utilisateur.
- **Endpoint** : `https://overpass-api.de/api/interpreter`
- **Requête (Overpass QL)** : Filtrage par tags `cuisine`, `amenity` et coordonnées GPS.

---

Développé avec ❤️ pour la communauté Glutino.
