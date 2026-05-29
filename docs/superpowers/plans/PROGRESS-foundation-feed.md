# تقدّم التنفيذ — Foundation + Feed

> **آخر تحديث:** 2026-05-29 16:03
> **الخطة:** `docs/superpowers/plans/2026-05-29-frontend-foundation-and-feed.md`
> **طريقة التنفيذ:** Subagent-Driven (وكيل لكل task + مراجعة spec ثم code quality)
> **الفرع:** `002-rebuild-from-zero`

## النسبة المئوية

**1 / 14 خلصت = ~7%**

`[█░░░░░░░░░░░░░] 7%`

## الحالة بالتفصيل

| # | Task | الحالة | Commit |
|---|---|---|---|
| 1 | Dependencies + Cairo font | ✅ تم | `aea80c5` |
| 2 | Theme tokens | ⏳ شغّال دلوقتي | — |
| 3 | Enums + models (freezed) | ⬜ باقي | — |
| 4 | Repository exceptions + interfaces | ⬜ باقي | — |
| 5 | Realistic mock data | ⬜ باقي | — |
| 6 | Mock repositories | ⬜ باقي | — |
| 7 | DI (get_it) | ⬜ باقي | — |
| 8 | Connectivity service + cubit | ⬜ باقي | — |
| 9 | Shared state widgets | ⬜ باقي | — |
| 10 | Navigation shell + app boot | ⬜ باقي | — |
| 11 | FeedBloc | ⬜ باقي | — |
| 12 | ListingCard widget | ⬜ باقي | — |
| 13 | FeedScreen + states | ⬜ باقي | — |
| 14 | Wire Feed into shell + verify | ⬜ باقي | — |

## اللي تم (تفصيل)

- **Task 1:** تثبيت الـ dependencies (flutter_bloc 9.1، go_router 17.2، get_it 9.2، connectivity_plus 7.1، cached_network_image 3.4، freezed 3.2، bloc_test 10، mocktail 1) + بندلة خط Cairo (variable) في `assets/fonts/Cairo.ttf` + تسجيله في pubspec. `flutter analyze` نظيف.
  - **قرار تنفيذي:** `json_serializable` اتأجّل لمرحلة الباك (تعارض مع bloc_test + مش محتاجينه في الـ mock). الـ models هتستخدم freezed لـ copyWith/equality بس.

## اللي باقي (تفصيل)

- **Task 2:** theme tokens (ألوان/مسافات/خطوط/ThemeData) من الـ design system.
- **Task 3–6:** models (freezed) + repository interfaces + sealed exceptions + mock data واقعية + mock repos.
- **Task 7–10:** DI + connectivity (service/cubit) + shared widgets + go_router shell بـ4 تابات + app boot.
- **Task 11–14:** FeedBloc + ListingCard + شاشة Feed بكل الحالات + ربطها بالـ shell + تحقق نهائي (analyze + كل الاختبارات + تشغيل يدوي).

## ملاحظات
- بيتحدّث بعد كل task (أدق من كل نص ساعة).
- المراجعة المزدوجة (spec compliance ثم code quality) بتتعمل لكل task كود قبل ما تتعلّم "تمت".
