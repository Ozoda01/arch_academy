# Arch Academy — To'liq Flutter O'quv Platformasi (1-Faza)

Ushbu loyiha Java, Kotlin, Dart va Flutter tillarini o'zbek tilida o'rgatuvchi zamonaviy o'quv platformasi hisoblanadi. Ilova **Clean Architecture** hamda **MVVM (Bloc/Cubit)** patternlari asosida mukammal va professional darajada ishlab chiqilmoqda.

---

## 🏛 Loyiha Arxitekturasi (Clean Architecture)

Loyiha arxitekturasi **Feature-first** (har bir funksiya alohida papkada) va **Layer-first** (Domain, Data, Presentation qatlamlari) qoidalariga rioya qilgan holda quyidagicha tuzilgan:

```text
lib/
├── core/                  # Ilova bo'ylab umumiy ishlatiladigan tizimlar
│   ├── error/             # Xatoliklarni boshqarish (Failures)
│   ├── network/           # Tarmoq ulanishlari (Dio ApiClient)
│   ├── router/            # Sahifalararo navigatsiya (GoRouter)
│   ├── theme/             # Light & Dark premium dizayn tizimi
│   ├── usecases/          # Barcha UseCase'lar uchun umumiy interfeys
│   └── widgets/           # Umumiy interfeys widgetlari (Button, Shimmer, Error)
│
├── features/              # Loyihaning asosiy funksional bo'limlari
│   ├── onboarding/        # Kirish sahifalari
│   ├── auth/              # Avtorizatsiya (kirish/ro'yxatdan o'tish)
│   ├── home/              # Bosh sahifa va bosh ekran layouti
│   ├── courses/           # Kurslar katalogi va kurs tafsilotlari
│   ├── player/            # Video darsliklar playerlari (Chewie / YouTube)
│   ├── quiz/              # Savol-javoblar va test topshirish tizimi
│   ├── progress/          # O'quvchining shaxsiy ko'rsatkichlari (statistika)
│   └── profile/           # Profil sozlamalari
│
├── injection_container.dart # GetIt orqali dependency injection sozlamasi
└── main.dart              # Ilovani ishga tushiruvchi bosh nuqta
```

---

## 🚀 1-Fazada Amalga Oshirilgan Ishlar va Sozlamalar (Commentary)

### 1. `pubspec.yaml` Paketlar Integratsiyasi
Loyiha ishlashi uchun zarur bo'lgan barcha eng so'nggi va barqaror paketlar bog'landi:
*   `flutter_bloc` — Cubit orqali interfeys holatini (state) boshqarish.
*   `go_router` — Mukammal routing va sahifalar almashinuvi uchun.
*   `dio` — API so'rovlarini professional tarzda yuborish.
*   `get_it` — Servislarni va Cubit'larni bir joydan boshqarish (Dependency Injection).
*   `hive_flutter` — Ilovada foydalanuvchi progressi va test natijalarini keshlash.
*   `google_fonts` — Premium tipografiya (Outfit va Plus Jakarta Sans).
*   `shimmer`, `lottie`, `flutter_animate` — Chiroyli va jozibali animatsiyalar yaratish uchun.

### 2. Core (Tizim asosi) Qatlamlari
*   **Theme (`core/theme/`):**
    *   `AppColors` da har bir tilga mos premium ranglar (Dart, Flutter, Java, Kotlin) va light/dark mode gradient ranglari sozlangan.
    *   `AppTheme` yordamida ilova foydalanuvchining telefon sozlamalariga mos ravishda avtomatik ravishda **Dark mode** yoki **Light mode**ga moslashadi.
*   **Routing (`core/router/`):**
    *   `GoRouter` yordamida yo'llar (paths) belgilandi.
    *   `ShellRoute` orqali ilovaning asosiy Bottom Navigation Bar (`MainLayout`) va uning ichidagi 4 ta asosiy tab (Home, Courses, Progress, Profile) muvaffaqiyatli ulangan.
*   **Network (`core/network/`):**
    *   `ApiClient` klassi yaratildi. Unda Dio kutubxonasi integratsiya qilinib, ulanishdagi xatoliklar (Timeout, connection error) o'zbek tilidagi chiroyli tushunarli xabarlarga o'giriladi.
*   **Error Handling (`core/error/`):**
    *   `Failure` abstraktsiyasi va uning vorislari (`ServerFailure`, `CacheFailure`, `NetworkFailure`) yozildi.

### 3. Umumiy UI elementlar (`core/widgets/`)
*   `CustomButton` — Bosganda dynamic ravishda kichrayib-kattalashuvchi (bounce) va chiroyli gradient fonli premium dizayndagi button.
*   `LoadingShimmer` — Skeleton effektli yuklanish animatsiyasi.
*   `AppErrorWidget` — Xatolik yuz berganda "Qayta urinish" imkoniyatini beruvchi tugmali error screen.

### 4. Dastlabki Sahifa va Modellar (Placeholders)
Sahifalarning yo'llari xatolarsiz ishlashi uchun barcha features sahifalarining dastlabki minimal ko'rinishlari yozildi va `app_router.dart` ga ulandi. Shuningdek, asosiy modellarimiz bo'lgan `Course` va `Lesson` entity klasslari [entities/](file:///c:/Flutter%20projects/arch_academy/lib/features/courses/domain/entities) ichida yaratib qo'yildi.

---

## 🏃‍♂️ Ishga Tushirish va Keyingi Qadamlar
1. Loyihani yuklab oling: `git clone https://github.com/Ozoda01/arch_academy.git`
2. Paketlarni yuklang: `flutter pub get`
3. Ilovani ishga tushiring: `flutter run`
