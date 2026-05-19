# Contract: Create Profile

**Endpoint:** Supabase Postgrest — `INSERT INTO public.profiles`

---

## Request

```dart
final response = await supabase
    .from('profiles')
    .insert({
      'id': supabase.auth.currentUser!.id,
      'full_name': 'يوسف التهامي',
      'phone': '+201012345678',
      'governorate': 'الدقهلية',
      'city_or_village': 'كفر المقدام',
      // optional:
      'avatar_url': null,
      'birth_date': null,
    })
    .select()
    .single();
```

### Required Fields

| الحقل | النوع | Validation |
|------|------|------------|
| `id` | `uuid` | لازم = `auth.uid()` (مفروض بـ RLS) |
| `full_name` | `text` | trim, `≥3` حروف |
| `phone` | `text` | `+201[0125]XXXXXXXX` (مصري) |
| `governorate` | `text` | من قائمة الـ 27 |
| `city_or_village` | `text` | trim, `≥2` حروف |

### Optional Fields

| الحقل | النوع | Validation |
|------|------|------------|
| `avatar_url` | `text` | URL لـ Supabase Storage (نملأها بعد رفع الصورة) |
| `birth_date` | `date` | بعد 1920 وقبل اليوم |

---

## Success Response

```dart
Map<String, dynamic> { 
  'id': 'uuid',
  'full_name': 'يوسف التهامي',
  'phone': '+201012345678',
  'governorate': 'الدقهلية',
  'city_or_village': 'كفر المقدام',
  'avatar_url': null,
  'birth_date': null,
  'created_at': '2026-05-19T08:35:00Z',
  'updated_at': '2026-05-19T08:35:00Z',
}
```

**في الـ Bloc:** نطلق `ProfileEvent.profileCreated(profile)` → state يبقى `ProfileState.loaded(profile)`.

---

## Error Responses

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `23505` | Phone unique violation | "رقم الموبايل ده مستخدم بالفعل" |
| `23514` | Check constraint (governorate, phone, name length) | "بيانات غير صالحة، تحقق من المدخلات" |
| `42501` | RLS violation | "ليس لديك صلاحية" (نظرياً مش هتحصل) |
| `network` | لا اتصال | "تحقق من اتصالك بالإنترنت" |

---

## Order of Operations

```
1. User يدخل البيانات في الـ form
2. (لو رفع صورة) Avatar Picker → ضغط → رفع لـ Storage → الحصول على URL
3. INSERT INTO profiles مع الـ URL (لو موجود)
4. ProfileBloc يتحدث → ينتقل المستخدم للـ Feed
```

**لو الـ insert فشل بعد رفع الصورة:** الصورة في Storage بدون profile. هنحذفها في cleanup task لاحقاً (orphan cleanup). في MVP: نسامح هذا.

---

## Acceptance Test

```dart
blocTest<ProfileBloc, ProfileState>(
  'emits [Loading, Loaded] on successful create',
  build: () => ProfileBloc(repository: mockRepo),
  act: (bloc) => bloc.add(CreateProfileRequested(formData)),
  setUp: () {
    when(() => mockRepo.createProfile(any()))
        .thenAnswer((_) async => Right(mockProfile));
  },
  expect: () => [
    ProfileState.loading(),
    ProfileState.loaded(profile: mockProfile),
  ],
);
```
