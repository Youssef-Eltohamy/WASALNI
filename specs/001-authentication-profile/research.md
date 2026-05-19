# Research: Authentication & Profile

**Spec:** [spec.md](./spec.md) · **Plan:** [plan.md](./plan.md)

---

هذا الملف يوثّق **القرارات التقنية المهمة** التي اتخذناها قبل التنفيذ، مع البدائل المرفوضة وأسباب الرفض. الهدف: لما حد يرجع للكود بعد 6 شهور، يفهم "ليه عملنا كده".

---

## R-1: State Management → Bloc

**القرار:** نستخدم `flutter_bloc` + `equatable` + Cubit للـ Forms.

**البدائل المرفوضة:**

| البديل | لماذا رُفض |
|--------|------------|
| **Riverpod** | المطوّر يفضّل Bloc ويعرفه أكتر. الفرق التقني لا يُبرر التكلفة المعرفية. |
| **GetX** | بيخلط State + Routing + DI، ضد الـ Clean Architecture، breaking changes متكررة |
| **Provider** | بسيط جداً، لا يصلح لتعقيد WASALNI المستقبلي (real-time, chat, إلخ) |

**التطبيق:**
- **Bloc** للـ states الكبيرة عبر التطبيق (`AuthBloc`, `ProfileBloc`)
- **Cubit** للـ Forms (`SignupFormCubit`, `SigninFormCubit`) — أبسط، أقل boilerplate
- **equatable** لكل state و event للمقارنة الصحيحة

---

## R-2: Form Management → `formz`

**القرار:** نستخدم `formz` لتمثيل حالات الـ form inputs.

**ليه:**
- يعطي type-safe input validation
- يدمج بسهولة مع Cubit
- يفصل validation logic عن UI

**البديل المرفوض:** Manual validation في كل field. سبب الرفض: تكرار، عرضة للأخطاء، صعب الاختبار.

**مثال:**
```dart
class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegex.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}
```

---

## R-3: Routing → `go_router`

**القرار:** نستخدم `go_router` للـ navigation.

**ليه:**
- Declarative (شبيه بالـ web routing)
- بيدعم Deep Links (مهم لـ Email Confirmation links + Password Reset)
- Type-safe routes
- موصى به من Flutter team

**البدائل المرفوضة:**
- **Navigator 1.0**: Imperative، صعب مع Deep Links
- **auto_route**: قوي بس code generation كبير لمشروع بحجم WASALNI الحالي

---

## R-4: Email Verification Strategy

**القرار:** Supabase Auth verify-on-link (المستخدم يضغط لينك في الإيميل).

**Flow:**
1. User يسجل → Supabase يبعت إيميل تلقائياً
2. الإيميل فيه deep link: `wasalni://auth/confirm?token=XXX`
3. App يفتح، Supabase SDK يعالج الـ token تلقائياً
4. `AuthBloc` يستقبل event `EmailConfirmed` → يوجّه لـ Profile Setup

**Deep Link Configuration:**
- iOS: Custom URL scheme `wasalni://` في `Info.plist`
- Android: Intent filter في `AndroidManifest.xml`

**البديل المرفوض:** OTP في الإيميل (المستخدم يكتب الكود في التطبيق). سبب الرفض: تجربة أسوأ، خطوة زيادة.

---

## R-5: Avatar Image Compression

**القرار:** نضغط الصور client-side قبل الرفع باستخدام `image` package.

**Logic:**
```dart
Future<Uint8List> compressAvatar(File file) async {
  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes)!;
  
  // Resize to max 800x800 maintaining aspect ratio
  final resized = img.copyResize(
    original,
    width: original.width > original.height ? 800 : null,
    height: original.height >= original.width ? 800 : null,
  );
  
  // Encode as JPEG quality 85
  return img.encodeJpg(resized, quality: 85);
}
```

**النتيجة المتوقعة:** صور بحجم 50-300KB بدلاً من 5MB+.

**البديل المرفوض:**
- رفع بدون ضغط: يستهلك Free Tier Storage بسرعة، تجربة أبطأ
- ضغط server-side عبر Edge Function: تعقيد زيادة، تكلفة compute

---

## R-6: Phone Format Normalization

**القرار:** كل أرقام الموبايل تتخزن بصيغة **`+20XXXXXXXXX`** (12 رقم بعد `+`).

**Client-side normalization:**

```dart
String normalizeEgyptianPhone(String input) {
  // Remove all non-digits
  var digits = input.replaceAll(RegExp(r'\D'), '');
  
  // Handle: 01XXXXXXXXX, 201XXXXXXXXX, 00201XXXXXXXXX
  if (digits.startsWith('0020')) digits = digits.substring(2);  // → 201...
  else if (digits.startsWith('20')) {} // already good
  else if (digits.startsWith('01')) digits = '20$digits';  // → 201...
  else throw FormatException('رقم موبايل غير صالح');
  
  return '+$digits';
}
```

**Server-side validation:** `CHECK (phone ~ '^\+201[0125]\d{8}$')` يقبل فقط `+2010`, `+2011`, `+2012`, `+2015` (شركات المحمول المصرية).

---

## R-7: Session Persistence → Supabase + Secure Storage

**القرار:** Supabase Auth بيدير الـ session بنفسه. نستخدم `flutter_secure_storage` كـ backing store عبر Supabase config.

**Setup:**
```dart
await Supabase.initialize(
  url: '...',
  anonKey: '...',
  authOptions: const FlutterAuthClientOptions(
    autoRefreshToken: true,
    pkceAsyncStorage: SharedPreferencesGotrueAsyncStorage(),
  ),
);
```

**النتيجة:** الـ session يفضل صالح حتى لو المستخدم قفل التطبيق ورجع بعد أيام. الـ Refresh token تلقائي.

**البديل المرفوض:** إدارة الـ session يدوياً. سبب الرفض: إعادة اختراع العجلة، أخطاء أمنية محتملة.

---

## R-8: Egyptian Governorates → ملف JSON ثابت

**القرار:** قائمة المحافظات (27) ملف ثابت في `apps/mobile/lib/core/constants/governorates.dart`، **مش في DB**.

**ليه:**
- القائمة لا تتغير (المحافظات في مصر ثابتة منذ سنوات)
- لا حاجة لاستعلام DB في كل dropdown
- DB يتأكد منها بـ `CHECK constraint`

**Structure:**
```dart
class Governorate {
  final String code;     // e.g., 'CAI'
  final String nameAr;   // e.g., 'القاهرة'
  
  const Governorate(this.code, this.nameAr);
}

const egyptianGovernorates = <Governorate>[
  Governorate('CAI', 'القاهرة'),
  Governorate('GIZ', 'الجيزة'),
  // ... 25 آخرين
];
```

**ملحوظة:** نخزن `nameAr` فقط في DB. الـ `code` للاستخدام الداخلي لو احتجناه.

---

## R-9: Error Handling Strategy

**القرار:** كل الأخطاء من Supabase تتحوّل لـ `Failure` objects مع رسائل **عربية ودودة**.

**Hierarchy:**
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override List<Object> get props => [message];
}

class AuthFailure extends Failure { ... }
class ProfileFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }
class UnknownFailure extends Failure { ... }
```

**Error Mapper:**
```dart
Failure mapSupabaseError(Object error) {
  if (error is AuthApiException) {
    return switch (error.statusCode) {
      '400' => AuthFailure('بيانات الدخول غير صحيحة'),
      '422' => AuthFailure('الإيميل مسجل بالفعل'),
      '429' => AuthFailure('محاولات كتيرة، حاول بعد دقيقة'),
      _ => AuthFailure('حصل خطأ، جرب تاني'),
    };
  }
  if (error is PostgrestException) { ... }
  if (error is StorageException) { ... }
  return UnknownFailure('خطأ غير متوقع');
}
```

**الـ Bloc بيستقبل Failure ويعرضه في الـ UI** (مفيش `try-catch` في الـ widgets).

---

## R-10: Testing Strategy

**القرار:** نركّز على 3 أنواع اختبارات:

| النوع | الأداة | الـ Coverage Target |
|------|--------|----------------------|
| **Unit tests** للـ validators | `flutter_test` | 100% (الـ regex tricky) |
| **Bloc tests** | `bloc_test` + `mocktail` | كل الـ events والـ states |
| **Widget tests** | `flutter_test` | الشاشات الأساسية (Signup, Signin, Profile Setup) |

**لا نعمل:**
- Integration tests على Supabase الحقيقي في الـ CI (تكلفة + بطء). بدلاً منها: mock الـ AuthRepository في الـ Bloc tests.
- E2E tests في MVP (بنرجع لها في Phase 2).

---

## R-11: Deep Linking Library

**القرار:** نستخدم `app_links ^6.x` للتعامل مع الـ deep links (email confirmation, password reset).

**ليه:**
- يدعم iOS + Android + Web
- API بسيط ومستقر
- يتعامل مع cold start (App مقفول) و warm start (App في الخلفية)

**البديل المرفوض:** `uni_links` — قديم ومش بيتم تحديثه.

---

## R-12: Why NOT Phone OTP in MVP

**القرار:** Phone OTP مؤجل بعد MVP. التسجيل بإيميل بس.

**حسابات التكلفة:**
- Supabase Phone Auth + Twilio: ~$0.05 per SMS
- متوقع 1000-5000 user في 3 شهور = $50-250
- + RTL في الإيميل أرخص وأكثر استقراراً للسوق المصري

**ماذا نخسر؟**
- بعض الناس مش بيستخدموا إيميل (متوقع 20-30%)
- الـ "Reach" أقل في القرى

**Phase 2 Plan:**
- WhatsApp OTP عبر **WhatsApp Cloud API** (مجاني تقريباً)
- أو SMS مصري محلي (~$0.005 / SMS = 10× أرخص من Twilio)

---

## R-13: Hydrated Bloc (لاحقاً، مش في هذا الـ spec)

**القرار:** **لن** نستخدم `hydrated_bloc` في Spec 1. Supabase Auth بيدير الـ session بنفسه، فلا حاجة لـ persistence إضافية للـ AuthBloc.

**متى نستخدمه؟** لما نضيف states محتاجة persistence مش بتيجي من السيرفر (مثل: filter preferences في الـ Feed، favorited businesses لو offline).

---

## ملخص الـ Dependencies الـ Final

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^9.0.0
  bloc: ^9.0.0
  equatable: ^2.0.7
  
  # Backend
  supabase_flutter: ^2.5.6
  
  # Forms
  formz: ^0.0.5
  
  # Routing
  go_router: ^17.0.0
  
  # Deep Links
  app_links: ^6.4.1
  
  # Image
  image_picker: ^1.1.2
  image: ^4.6.0
  
  # Storage
  flutter_secure_storage: ^9.2.4
  
  # Env
  flutter_dotenv: ^5.1.0
  
  # Internationalization
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
```
