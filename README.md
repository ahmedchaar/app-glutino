# Glutino 🥦

**Glutino** est une application mobile puissante et intuitive conçue pour accompagner les personnes coeliaques ou sensibles au gluten dans leur quotidien. Elle permet de scanner des produits pour vérifier leur composition et de trouver des restaurants adaptés à proximité.

## 🚀 Fonctionnalités principales

- **Scanner de Produits** : Utilise l'appareil photo pour scanner les codes-barres et identifier instantanément si un produit contient du gluten via OpenFoodFacts.
- **Répertoire de Restaurants** : Géolocalisation des restaurants proposant des options sans gluten via OpenStreetMap (Overpass API).
- **Liste de Courses** : Gestion personnalisée d'une liste de courses persistante.
- **Profil Utilisateur** : Gestion des préférences de sensibilité, historique des produits scannés et restaurants favoris.
- **Mode Secours** : Système de protection intégré pour réinitialiser les données locales en cas de corruption ou de saturation de mémoire.

## 🛠️ Technologies utilisées

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

## 💻 Installation et Exécution

### Prérequis
- Flutter SDK (version 3.0.0 ou supérieure)
- Android Studio / VS Code avec extensions Flutter/Dart
- Un compte Firebase configuré (pour l'authentification)

### Étapes
1. **Cloner le projet** :
   ```bash
   git clone [url-du-repo]
   cd glutino
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Lancer l'application** :
   ```bash
   flutter run
   ```

## 🌐 Présentation des APIs et Endpoints

### 🍎 Produits (OpenFoodFacts)
- **Rôle** : Récupérer les informations nutritionnelles et les ingrédients.
- **Endpoint Principal** : `https://world.openfoodfacts.org/api/v0/product/[barcode].json`

### 🍴 Restaurants (Overpass API)
- **Rôle** : Rechercher des établissements (amenity=restaurant, cafe, fast_food) dans un rayon défini autour de l'utilisateur.
- **Endpoint** : `https://overpass-api.de/api/interpreter`
- **Requête (Overpass QL)** : Filtrage par tags `cuisine`, `amenity` et coordonnées GPS.

---

Développé avec ❤️ pour la communauté Glutino.
