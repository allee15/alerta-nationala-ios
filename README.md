# Alerta Nationala - Aplicatie iOS (Cetatean)

Aplicatie nativa SwiftUI, pentru cetateni: alerte pentru zonele urmarite, ghiduri de urgenta offline, harta cu puncte de adunare si check-in "Sunt in siguranta".

> Arhitectura de ansamblu a sistemului si schema bazei de date sunt descrise in README-ul repo-ului de backend - aici sunt doar detaliile specifice acestei componente.

## Instructiuni de rulare

### Cerinte
- Xcode 16+ (proiectul folosește API-uri SwiftUI/MapKit din iOS 17, ex. `Map(position:)`, `.onChange(of:) { oldValue, newValue in }`)
- iOS 17+ ca deployment target
- Backend-ul pornit local sau deployat, accesibil de pe dispozitiv/simulator

### Pasi
1. Deschizi `AlertaNationala.xcodeproj` in Xcode.
2. In `API/ApiEnvironment.swift`, setezi `basePath` la adresa backend-ului:
   - Backend local: `http://localhost:3000/`
   - Backend live: `https://alerta-nationala-backend.vercel.app/`
3. Rulezi pe simulator sau pe dispozitiv (`Cmd+R`).

### Cont de test (cetatean)
Email: alexia.elena.aldea@gmail.com
Parola: 123456

### Permisiuni necesare
La prima deschidere a tab-ului **Puncte de adunare**, aplicatia cere acces la locatie (`NSLocationWhenInUseUsageDescription`, deja setat in `Info.plist`) - necesar pentru calculul distantelor. Refuzarea permisiunii nu blocheaza ecranul, doar ascunde distantele.

---

## Arhitectura acestei componente

**Pattern:** MVVM cu Combine - fiecare ecran are un `ViewModel` (`ObservableObject`, mostenind `BaseViewModel`), care expune `@Published` properties consumate direct din `View`. Apelurile de retea trec prin trei straturi: `Api` (URLSession brut) -> `Service` (logica de business + cache) -> `ViewModel`.

**Autentificare:** token-uri (access + refresh) in Keychain (`KeychainService`), nu in `UserDefaults`. `UserService.getUser()` face retry automat pe refresh token la un 401.

**Strategia offline-first - piesa centrala a aplicatiei:**

| Continut | Persistat local | Store | Comportament offline |
|---|---|---|---|
| Ghiduri de urgenta | Da, cu versionare | `GuidesStore` | Disponibile integral, sync incremental doar pe ce s-a schimbat |
| Puncte de adunare | Da | `AssemblyPointsStore` | Lista + distantele raman disponibile |
| Alerte | Da | `AlertsStore` | Se arata ultimele cunoscute, cu banner "date posibil neactualizate" |
| Check-in-uri trimise | Coada locala, cu timestamp real | `PendingCheckinsStore` | Se pun in coada offline, se trimit automat la urmatoarea deschidere cu net |
| Stare "am confirmat deja" | Da, per-device | `CheckedInAlertsStore` | Previne re-apasarea butonului de check-in dupa navigare/repornire |

Toate store-urile folosesc `UserDefaults` + `Codable`.

## Ecrane implementate
- Onboarding + autentificare (login, inregistrare cu selectie de zone)
- Home: alerte active, avertizari meteo oficiale (ANM), prognoza (Open-Meteo) - vizual diferentiate
- Detaliul unei alerte, cu check-in
- Lista ghidurilor + detaliul unui ghid
- Harta punctelor de adunare (harta fullscreen + card la tap pe pin + lista completa intr-un sheet) + redirect catre Google Maps
- Profil / Setari: editare zone de interes, tema (light/dark/system), logout

## Justificari tehnice specifice acestei componente
- **UserDefaults, nu Core Data/SwiftData**, pentru toate store-urile offline - volumul de date e mic, iar `Codable` + `UserDefaults` e mult mai simplu de intretinut.
- **MapKit, nu Google Maps SDK** - nu necesita API key, integrare nativa mai simpla.