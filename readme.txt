============================================================
                     GLUTINO - README
============================================================

Projet : Application de détection de gluten et répertoire de restaurants.

------------------------------------------------------------
1. PRÉREQUIS POUR LA COMPILATION
------------------------------------------------------------
- Flutter SDK : Version 3.0.0 ou supérieure.
- Dart SDK : Inclus avec Flutter.
- Android Studio / VS Code : Avec les plugins Flutter et Dart installés.
- Connexion Internet : Nécessaire pour la récupération des dépendances et l'accès aux APIs.

------------------------------------------------------------
2. ÉTAPES POUR COMPILER ET EXÉCUTER
------------------------------------------------------------
⚠️ IMPORTANT : Exécution Web non supportée
L'application est conçue pour Android/iOS. Ne pas lancer sur Chrome/Edge (problèmes de mémoire et CORS).

Étape 1 : Récupérer les dépendances
> flutter pub get

Étape 2 : Lancer l'application (Choisissez UNE méthode)

MÉTHODE A : Sur un téléphone physique (Recommandé)
1. Activez le mode "Développeur" sur votre téléphone (tapez 7 fois sur Numéro de build).
2. Activez le "Débogage USB".
3. Branchez le téléphone au PC.
4. Lancez : > flutter run

MÉTHODE B : Sur un Émulateur (Android Studio)
1. Ouvrez le Device Manager dans Android Studio.
2. Démarrez un téléphone virtuel (Pixel, etc.).
3. Une fois allumé, lancez : > flutter run

Pour générer un fichier APK de production (Release) :
> flutter build apk --release

------------------------------------------------------------
3. SPÉCIFICITÉS TECHNIQUES
------------------------------------------------------------
- Authentification : Le projet utilise Firebase Authentication. Les services sont déjà configurés via les fichiers natifs (google-services.json pour Android).
- APIs Externes utilisées :
    * OpenFoodFacts (Produits)
    * Overpass API / OpenStreetMap (Restaurants)
- Stockage : Utilisation de SharedPreferences et Flutter Secure Storage pour la persistance locale des données.

------------------------------------------------------------
4. ARCHITECTURE DU CODE
------------------------------------------------------------
- lib/models : Définition des objets (User, Product, Restaurant).
- lib/services : Logique de communication avec les APIs et Firebase.
- lib/screens : Interfaces utilisateur (Tabs, Login, Signup).
- lib/providers : Gestion de l'état (State Management) via Provider.

============================================================
Développé par Ahmed Chaar
============================================================
