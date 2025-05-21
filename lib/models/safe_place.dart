import 'package:latlong2/latlong.dart';

class SafePlace {
  final String name;
  final String nameKz;
  final String nameRu;
  final String description;
  final String phoneNumber;
  final String address;
  final LatLng location;
  final String category;
  final String workingHours;

  const SafePlace({
    required this.name,
    required this.nameKz,
    required this.nameRu,
    required this.description,
    required this.phoneNumber,
    required this.address,
    required this.location,
    required this.category,
    required this.workingHours,
  });
}

class SafePlaces {
  static const List<SafePlace> places = [
    SafePlace(
      name: 'Crisis Center for Women',
      nameKz: 'Әйелдер кризис орталығы',
      nameRu: 'Кризисный центр для женщин',
      description: 'Support and shelter for women in crisis situations',
      phoneNumber: '8-727-273-77-77',
      address: 'Almaty, Tole bi 59',
      location: LatLng(43.2220, 76.8512),
      category: 'Crisis Center',
      workingHours: '24/7',
    ),
    SafePlace(
      name: 'Aman Saulyk Foundation',
      nameKz: 'Аман-саулық қоры',
      nameRu: 'Фонд «Аман-саулық»',
      description: 'Healthcare and social support foundation',
      phoneNumber: '8-727-273-77-78',
      address: 'Almaty, Abai 150',
      location: LatLng(43.2389, 76.8897),
      category: 'Healthcare',
      workingHours: 'Mon-Fri 9:00-18:00',
    ),
    SafePlace(
      name: 'Kazakhstan Women\'s Union',
      nameKz: 'Қазақстан әйелдер одағы',
      nameRu: 'Союз женщин Казахстана',
      description: 'Women\'s rights and empowerment organization',
      phoneNumber: '8-727-273-77-79',
      address: 'Almaty, Furmanov 187',
      location: LatLng(43.2567, 76.9286),
      category: 'Organization',
      workingHours: 'Mon-Fri 9:00-18:00',
    ),
    SafePlace(
      name: 'Legal Aid Center',
      nameKz: 'Заңгерлік көмек орталығы',
      nameRu: 'Центр юридической помощи',
      description: 'Free legal consultation and support',
      phoneNumber: '8-727-273-77-80',
      address: 'Almaty, Satpaev 22',
      location: LatLng(43.2389, 76.8897),
      category: 'Legal',
      workingHours: 'Mon-Fri 9:00-18:00',
    ),
    SafePlace(
      name: 'Psychological Support Center',
      nameKz: 'Психологиялық қолдау орталығы',
      nameRu: 'Центр психологической поддержки',
      description: 'Professional psychological support and counseling',
      phoneNumber: '8-727-273-77-81',
      address: 'Almaty, Zheltoksan 59',
      location: LatLng(43.2389, 76.8897),
      category: 'Healthcare',
      workingHours: 'Mon-Sat 9:00-20:00',
    ),
  ];
}
