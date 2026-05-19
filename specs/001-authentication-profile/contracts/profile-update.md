# Contract: Update Profile

**Endpoint:** Supabase Postgrest — `UPDATE public.profiles`

---

## Request

```dart
final response = await supabase
    .from('profiles')
    .update({
      'full_name': 'يوسف التهامي الجديد',
      'phone': '+201198765432',
      // أي حقل عاوز تعدله
    })
    .eq('id', supabase.auth.currentUser!.id)
    .select()
    .single();
```

### Updatable Fields

| الحقل | قابل للتعديل؟ | ملاحظات |
|------|---------------|----------|
| `id` | ❌ | محظور (PK) |
| `full_name` | ✅ | نفس validation الـ create |
| `phone` | ✅ | نفس validation. **تنبيه:** unique constraint قد يفشل |
| `governorate` | ✅ | من قائمة الـ 27 |
| `city_or_village` | ✅ | نفس validation |
| `avatar_url` | ✅ | عبر avatar-upload contract |
| `birth_date` | ✅ | nullable |
| `created_at` | ❌ | immutable |
| `updated_at` | ❌ | يتحدث تلقائياً بـ trigger |

---

## Success Response

نفس response الـ create — كائن الـ profile بعد التحديث.

**في الـ Bloc:** نطلق `ProfileEvent.profileUpdated(profile)` → state يفضل `ProfileState.loaded` بالبيانات الجديدة.

---

## Error Responses

نفس أخطاء `profile-create`، بالإضافة لـ:

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `PGRST116` | لا row to update (مفيش profile) | "بروفايلك مش موجود، أنشئه أولاً" |

---

## Partial Updates

نسمح بـ partial updates — مش لازم نبعت كل الحقول. مثال:

```dart
// فقط تحديث الاسم
await supabase
    .from('profiles')
    .update({'full_name': 'الاسم الجديد'})
    .eq('id', userId);
```

**في الـ UI:** الـ EditProfileForm بيظهر كل الحقول مع البيانات الحالية. لما المستخدم يضغط "حفظ"، نبعت فقط الحقول اللي اتغيرت.

---

## Avatar Update Special Case

لما المستخدم يرفع صورة جديدة:
1. ارفع الجديدة على Storage (نفس المسار: `avatars/{user_id}/avatar.{ext}`)
2. ⚠️ الـ Storage بـ `upsert: true` بيستبدل الصورة القديمة تلقائياً.
3. حدّث `avatar_url` بنفس الـ URL (في حالة تغير الـ extension من jpg لـ png مثلاً).

```dart
// لا حاجة لحذف صريح للقديمة
await supabase.storage.from('avatars').upload(
  '${userId}/avatar.jpg',
  newImageFile,
  fileOptions: const FileOptions(upsert: true),
);
```

---

## Acceptance Test

```dart
blocTest<ProfileBloc, ProfileState>(
  'emits [Loading, Loaded] with updated data',
  build: () => ProfileBloc(repository: mockRepo),
  seed: () => ProfileState.loaded(profile: oldProfile),
  act: (bloc) => bloc.add(UpdateProfileRequested(updates)),
  setUp: () {
    when(() => mockRepo.updateProfile(any(), any()))
        .thenAnswer((_) async => Right(updatedProfile));
  },
  expect: () => [
    ProfileState.loading(profile: oldProfile),
    ProfileState.loaded(profile: updatedProfile),
  ],
);
```
