class Specialty {
  final String name;
  final String price;

  const Specialty({required this.name, required this.price});
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String location;
  final double rating;
  final String distance;
  final String category;
  final bool isFavorite;
  final String openingHours;
  final List<Specialty> specialties;
  final String phone;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.rating,
    required this.distance,
    required this.category,
    required this.isFavorite,
    required this.openingHours,
    required this.specialties,
    required this.phone,
  });

  Restaurant copyWith({bool? isFavorite}) => Restaurant(
        id: id,
        name: name,
        image: image,
        location: location,
        rating: rating,
        distance: distance,
        category: category,
        isFavorite: isFavorite ?? this.isFavorite,
        openingHours: openingHours,
        specialties: specialties,
        phone: phone,
      );
}
