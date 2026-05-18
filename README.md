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

### 🎨 2-Faza: Asosiy UI va O'quv Kontenti (MVP Features)
Ushbu bosqichda ilovamizning barcha asosiy va markaziy UI sahifalari hamda o'quv kontenti bo'limlari to'liq va premium tarzda ishlab chiqildi:
*   **Onboarding Sahifasi (`lib/features/onboarding/`):**
    *   3 slaydli chiroyli slaydlar (`PageView` orqali).
    *   `flutter_animate` yordamida titellar va tasvirlar silliq, dynamic tarzda kirib kelishi.
    *   Dynamic nuqtali indicatorlar va "Boshlash" navigatsiyasi.
*   **Bosh Sahifa (`lib/features/home/`):**
    *   Salomlashish qismi, foydalanuvchi profil rasmi va kunlik progress ko'rsatkichi.
    *   `CircularPercentIndicator` bilan premium **34%** lik circular progress doirasi.
    *   Tillar bo'yicha dinamik gorizontal filter chiplari (All, Dart, Flutter, Java, Kotlin) va ularni bosganda state avtomatik yangilanishi.
*   **Kurslar Katalogi (`lib/features/courses/presentation/pages/courses_page.dart`):**
    *   Qidiruv paneli (Search query) orqali kurslarni izlash.
    *   Tillar va qiyinchilik darajalari (Boshlang'ich, O'rta, Yuqori) bo'yicha to'liq dropdown filtrlash tizimi.
*   **Kurs Detallari (`lib/features/courses/presentation/pages/course_detail_page.dart`):**
    *   SliverAppBar bilan dynamic premium header qismi.
    *   Kurs haqida va Dasturi uchun Tab tizimi.
    *   Checklist orqali nimalar o'rgatilishi haqida premium UI.
    *   Darslar ro'yxatida **Darslarni Qulflash/Ochish** logikasi: `isPreview == true` bo'lgan bepul darslarni ko'rish mumkin, pullik darslarni bosganda foydalanuvchiga premium a'zolik kerakligi haqida tushunarli dialog chiqadi.
*   **Kurs Kartochkasi (`lib/features/courses/presentation/widgets/course_card.dart`):**
    *   Har bir til uchun alohida dynamic rangli badge (Dart = Ko'k, Flutter = Och ko'k, Java = To'q sariq, Kotlin = Binafsha).
    *   Bosganda chiroyli scale bo'luvchi (tap scale) premium effekt, rating, darslar soni va umumiy davomiylik ko'rsatkichi.
*   **Cubit & Dependency Injection:**
    *   `CoursesCubit` va `LessonsCubit` yordamida state management boshqaruvi to'liq Clean arxitekturaga moslab integratsiya qilindi va `injection_container.dart` da ro'yxatdan o'tkazildi.

### 🎬 3-Faza: O'quv jarayoni va Video Player (Core Learning)
Ilovaning markaziy qismi bo'lgan video playerlar va o'quv progressini saqlash tizimi muvaffaqiyatli integratsiya qilindi:
*   **In-App Video Player (`lib/features/player/`):**
    *   `video_player` va `chewie` yordamida silliq fullscreen boshqaruvi va premium controls.
    *   "Darsni yakunladim" tugmasi orqali dars holatini `Hive` lokal omboriga yozish.
*   **YouTube Player (`lib/features/player/`):**
    *   `youtube_player_flutter` paketi yordamida YouTube linklarini dynamic o'qib ko'rsatish.
*   **Mening Progressim Sahifasi (`lib/features/progress/`):**
    *   Katta `CircularPercentIndicator` bilan umumiy o'zlashtirish foizining visual gradient kartochkasi.
    *   **fl_chart** orqali premium **BarChart (Ustunli Grafik)**: Dart, Flutter, Java, Kotlin tillaridagi o'zlashtirish foizlarini visual solishtirish 📊.
*   **Profil Sahifasi (`lib/features/profile/`):**
    *   Foydalanuvchi ma'lumotlari, Light/Dark reji switchlari hamda progressni noldan boshlash uchun xavfsiz **"Progressni tozalash"** dialog utilitasi.

### 🏆 4-Faza: Test Tizimi (Quiz) va Yakuniy Polish
Kurs oxirida bilimlarni tekshiruvchi premium test tizimi va vizual effektlar:
*   **Quiz Sahifasi (`lib/features/quiz/presentation/pages/quiz_page.dart`):**
    *   15 soniyalik visual circular orqaga hisoblagich (Timer).
    *   To'g'ri javob tanlanganda yashil rangli dynamic **Pulse (Kattalashuv) animatsiyasi** 🟢.
    *   Xato javob tanlanganda qizil rangli **Shake (Titrash) animatsiyasi** 🔴.
    *   Savol javobdan so'ng, uning tushuntirishi (Explanation) yoritiluvchi premium visual informativ block.
*   **Natijalar Sahifasi (`lib/features/quiz/presentation/pages/quiz_result_page.dart`):**
    *   Agar foydalanuvchi testdan muvaffaqiyatli o'tsa (kamida 60%), butun ekranda dynamic **Lottie Confetti** bayramona animatsiyasi o'ynaydi! 🎉
    *   Circular Score indicator hamda to'g'ri/xato javoblarning tahlili va tushuntirishlari yozilgan review paneli.

---

## 🏃‍♂️ Ishga Tushirish va Keyingi Qadamlar
1. Loyihani yuklab oling: `git clone https://github.com/Ozoda01/arch_academy.git`
2. Paketlarni yuklang: `flutter pub get`
3. Ilovani ishga tushiring: `flutter run`
