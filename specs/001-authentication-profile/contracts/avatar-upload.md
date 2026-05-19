# Contract: Avatar Upload

**Endpoint:** Supabase Storage — `supabase.storage.from('avatars').upload()`

---

## Pre-Upload: Image Compression (Client-side)

```dart
Future<Uint8List> compressAvatar(File file) async {
  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes);
  if (original == null) throw FormatException('صورة غير صالحة');
  
  // Resize to max 800x800
  final resized = img.copyResize(
    original,
    width: original.width > original.height ? 800 : null,
    height: original.height >= original.width ? 800 : null,
  );
  
  return img.encodeJpg(resized, quality: 85);
}
```

**النتيجة:** صور بحجم 50-300KB بدلاً من الـ MB الأصلية.

---

## Request

```dart
final userId = supabase.auth.currentUser!.id;
final filePath = '$userId/avatar.jpg';

await supabase.storage.from('avatars').uploadBinary(
  filePath,
  compressedBytes,
  fileOptions: const FileOptions(
    upsert: true,           // يستبدل لو موجودة
    contentType: 'image/jpeg',
  ),
);

// احصل على الـ public URL
final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
```

### Parameters

| الحقل | النوع | إلزامي | Validation |
|------|------|---------|-------------|
| `filePath` | `String` | ✅ | لازم يبدأ بـ `{user_id}/` |
| `data` | `Uint8List` | ✅ | حجم ≤2MB |
| `contentType` | `String` | ✅ | `image/jpeg`, `image/png`, `image/webp` |
| `upsert` | `bool` | ✅ | `true` (للاستبدال) |

---

## Success Response

```dart
String publicUrl = 'https://nseuurovkxymrwxamftz.supabase.co/storage/v1/object/public/avatars/uuid/avatar.jpg';
```

**التالي:** نمرر الـ `publicUrl` لـ `profile-update` contract لتحديث `avatar_url`.

---

## Error Responses

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `413` | File too large | "حجم الصورة كبير، الحد 2MB" |
| `400` | Invalid MIME type | "صيغة الصورة غير مدعومة (JPG/PNG/WebP)" |
| `403` | RLS violation | "ليس لديك صلاحية الرفع" |
| `network` | لا اتصال | "تحقق من اتصالك بالإنترنت" |

---

## RLS-Enforced Constraint

```sql
-- من data-model.md
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
)
```

ده يضمن إن المستخدم يقدر يرفع/يعدل في folder اسمه `{user_id}/` بس. لو حاول يرفع في folder تاني → 403.

---

## Image Optimization Strategy

| المرحلة | التطبيق |
|---------|---------|
| **Pre-upload** | Resize 800x800 + JPEG quality 85 (client-side) |
| **Storage** | Supabase يحفظ الصورة كما هي |
| **Delivery** | Supabase Image Transformation (مدفوع في Pro) → نأجل لـ Phase 2 |

في MVP: نرفع الصورة المضغوطة كما هي ونعرضها مباشرة. كافٍ لأحجام الـ avatars.

---

## Acceptance Test

```dart
test('compresses and uploads avatar successfully', () async {
  final repo = ProfileRepository(supabase: mockSupabase);
  final mockFile = createLargeImageFile(5 * 1024 * 1024);  // 5MB
  
  when(() => mockStorage.uploadBinary(any(), any(), fileOptions: any(named: 'fileOptions')))
      .thenAnswer((_) async => '');
  
  final result = await repo.uploadAvatar(userId, mockFile);
  
  expect(result, isA<Right<Failure, String>>());
  
  // تأكد إن البايتس المُرفوعة <2MB
  final captured = verify(() => mockStorage.uploadBinary(
    any(), captureAny(), fileOptions: any(named: 'fileOptions')
  )).captured;
  expect((captured.first as Uint8List).length, lessThan(2 * 1024 * 1024));
});
```
