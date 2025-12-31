import '../models/restaurant_model.dart';

class RestaurantService {
  Future<List<Restaurant>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      Restaurant(
        id: '1',
        name: 'Savoi the cake',
        image:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&h=600&fit=crop',
        location: 'Grand',
        rating: 4.5,
        distance: '5 min en voiture',
        category: 'Pâtisserie',
        isFavorite: true,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 123 456 789',
      ),
      Restaurant(
        id: '2',
        name: 'Tik Tak Family',
        image:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&h=600&fit=crop',
        location: 'Ghazela',
        rating: 4.2,
        distance: '5 min en voiture',
        category: 'Restaurant',
        isFavorite: true,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 98 765 432',
      ),
      Restaurant(
        id: '3',
        name: 'Love swij q',
        image:
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
        location: 'Manar 3',
        rating: 4.8,
        distance: '5 min en voiture',
        category: 'Café',
        isFavorite: true,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 55 123 456',
      ),
    ];
  }

  Future<List<Restaurant>> getRecommended() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      Restaurant(
        id: '4',
        name: 'Love sens gluten',
        image:
            'https://images.unsplash.com/photo-1578474846511-04ba529f0b88?w=800&h=600&fit=crop',
        location: 'Tunis, Manar 2',
        rating: 4.3,
        distance: '8 min en voiture',
        category: 'Restaurant',
        isFavorite: false,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 22 333 444',
      ),
      Restaurant(
        id: '5',
        name: 'Tik Tak family',
        image:
            'https://images.unsplash.com/photo-1551632436-cbf8dd35adfa?w=800&h=600&fit=crop',
        location: 'Tunis, Manar 2',
        rating: 4.5,
        distance: '8 min en voiture',
        category: 'Restaurant',
        isFavorite: false,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 71 222 333',
      ),
      Restaurant(
        id: '6',
        name: "MoonBean's Coffee",
        image:
            'https://images.unsplash.com/photo-1445116572660-236099ec97a0?w=800&h=600&fit=crop',
        location: 'Tunis, Manar 2',
        rating: 4.7,
        distance: '8 min en voiture',
        category: 'Café',
        isFavorite: false,
        openingHours: '8 am en voiture',
        specialties: [
          Specialty(name: 'Pizza', price: '20DT'),
          Specialty(name: 'Cup Cake', price: '12DT'),
          Specialty(name: 'Tik Tak Family', price: '45 DT'),
        ],
        phone: '+216 20 111 222',
      ),
    ];
  }
}
