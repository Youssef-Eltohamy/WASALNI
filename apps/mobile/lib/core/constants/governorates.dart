class Governorate {
  final String code;
  final String nameAr;

  const Governorate({required this.code, required this.nameAr});

  @override
  String toString() => nameAr;
}

const List<Governorate> egyptianGovernorates = <Governorate>[
  Governorate(code: 'CAI', nameAr: 'القاهرة'),
  Governorate(code: 'GIZ', nameAr: 'الجيزة'),
  Governorate(code: 'ALX', nameAr: 'الإسكندرية'),
  Governorate(code: 'DAK', nameAr: 'الدقهلية'),
  Governorate(code: 'SHR', nameAr: 'الشرقية'),
  Governorate(code: 'MNF', nameAr: 'المنوفية'),
  Governorate(code: 'QLY', nameAr: 'القليوبية'),
  Governorate(code: 'GHR', nameAr: 'الغربية'),
  Governorate(code: 'KFS', nameAr: 'كفر الشيخ'),
  Governorate(code: 'BEH', nameAr: 'البحيرة'),
  Governorate(code: 'ISM', nameAr: 'الإسماعيلية'),
  Governorate(code: 'PSD', nameAr: 'بورسعيد'),
  Governorate(code: 'SUZ', nameAr: 'السويس'),
  Governorate(code: 'NSI', nameAr: 'شمال سيناء'),
  Governorate(code: 'SSI', nameAr: 'جنوب سيناء'),
  Governorate(code: 'DMT', nameAr: 'دمياط'),
  Governorate(code: 'BNS', nameAr: 'بني سويف'),
  Governorate(code: 'FYM', nameAr: 'الفيوم'),
  Governorate(code: 'MNY', nameAr: 'المنيا'),
  Governorate(code: 'AST', nameAr: 'أسيوط'),
  Governorate(code: 'SHG', nameAr: 'سوهاج'),
  Governorate(code: 'QNA', nameAr: 'قنا'),
  Governorate(code: 'LXR', nameAr: 'الأقصر'),
  Governorate(code: 'ASW', nameAr: 'أسوان'),
  Governorate(code: 'RES', nameAr: 'البحر الأحمر'),
  Governorate(code: 'WAD', nameAr: 'الوادي الجديد'),
  Governorate(code: 'MAT', nameAr: 'مطروح'),
];

const Set<String> _governorateNamesArSet = {
  'القاهرة','الجيزة','الإسكندرية','الدقهلية','الشرقية','المنوفية',
  'القليوبية','الغربية','كفر الشيخ','البحيرة','الإسماعيلية','بورسعيد',
  'السويس','شمال سيناء','جنوب سيناء','دمياط','بني سويف','الفيوم',
  'المنيا','أسيوط','سوهاج','قنا','الأقصر','أسوان',
  'البحر الأحمر','الوادي الجديد','مطروح',
};

bool isValidGovernorate(String nameAr) {
  return _governorateNamesArSet.contains(nameAr);
}
