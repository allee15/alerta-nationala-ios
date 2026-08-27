# Alertă Națională — Aplicație iOS (Cetățean)

Aplicație nativă SwiftUI, pentru cetățeni: alerte pentru zonele urmărite, ghiduri de urgență offline, hartă cu puncte de adunare și check-in "Sunt în siguranță".

> Arhitectura de ansamblu a sistemului și schema bazei de date sunt descrise în README-ul repo-ului de backend — aici sunt doar detaliile specifice acestei componente.

## Instrucțiuni de rulare

### Cerințe
- Xcode 16+ (proiectul folosește API-uri SwiftUI/MapKit din iOS 17, ex. `Map(position:)`, `.onChange(of:) { oldValue, newValue in }`)
- iOS 17+ ca deployment target
- Backend-ul pornit local sau deployat, accesibil de pe dispozitiv/simulator

### Pași
1. Deschizi `AlertaNationala.xcodeproj` (sau `.xcworkspace`, dacă există) în Xcode.
2. În `API/ApiEnvironment.swift`, setezi `basePath` la adresa backend-ului:
   - Simulator, backend local: `http://localhost:3000/`
   - Dispozitiv fizic, backend local: `http://<IP-ul-local-al-Mac-ului>:3000/` (simulatorul poate accesa `localhost`, dar un iPhone fizic pe aceeași rețea are nevoie de IP-ul real al laptopului)
3. Rulezi pe simulator sau pe dispozitiv (`Cmd+R`).

### Cont de test (cetățean)
Vezi README-ul de backend: `citizen@test.com` / `Test1234!`, cu zona **Cluj** — asigură-te că ai și date de test (alerte/puncte de adunare) create pe acel județ din dashboard-ul web, altfel ecranele vor apărea goale (corect, dar puțin puțin util pentru demo).

### Permisiuni necesare
La prima deschidere a tab-ului **Puncte de adunare**, aplicația cere acces la locație (`NSLocationWhenInUseUsageDescription`, deja setat în `Info.plist`) — necesar pentru calculul distanțelor. Refuzarea permisiunii nu blochează ecranul, doar ascunde distanțele.

---

## Arhitectura acestei componente

**Pattern:** MVVM cu Combine — fiecare ecran are un `ViewModel` (`ObservableObject`, moștenind `BaseViewModel`), care expune `@Published` properties consumate direct din `View`. Apelurile de rețea trec prin trei straturi: `Api` (URLSession brut) → `Service` (logică de business + cache + retry pe 401) → `ViewModel`.

**Autentificare:** token-uri (access + refresh) în Keychain (`KeychainService`), nu în `UserDefaults`. `UserService.getUser()` face retry automat pe refresh token la un 401, dar **nu** delogează userul la o simplă eroare de rețea (bug corectat explicit — vezi mai jos) — doar la un refresh token cu adevărat expirat/invalid.

**Strategia offline-first — piesa centrală a aplicației:**

| Conținut | Persistat local? | Store | Comportament offline |
|---|---|---|---|
| Ghiduri de urgență | Da, cu versionare | `GuidesStore` | Disponibile integral, sync incremental doar pe ce s-a schimbat |
| Puncte de adunare | Da | `AssemblyPointsStore` | Lista + distanțele rămân disponibile |
| Alerte (bonus, nu era cerut explicit) | Da | `AlertsStore` | Se arată ultimele cunoscute, cu banner "date posibil neactualizate" |
| Check-in-uri trimise | Coadă locală, cu timestamp real | `PendingCheckinsStore` | Se pun în coadă offline, se trimit automat la următoarea deschidere cu net |
| Stare "am confirmat deja" | Da, per-device | `CheckedInAlertsStore` | Previne re-apăsarea butonului de check-in după navigare/repornire |

Toate store-urile folosesc `UserDefaults` + `Codable`, cu pattern identic: `all()`/`load()`, `replace()`/`upsert()`.

## Ecrane implementate
- Onboarding + autentificare (login, înregistrare cu selecție de zone)
- Home: alerte active, avertizări meteo oficiale (ANM), prognoză (Open-Meteo) — vizual diferențiate
- Detaliul unei alerte, cu check-in
- Lista ghidurilor (listă simplă, categorie ca badge) + detaliul unui ghid
- Harta punctelor de adunare (hartă fullscreen + card la tap pe pin + listă completă într-un sheet) + deep link către Google/Apple Maps
- Profil / Setări: editare zone de interes, temă (light/dark/system), logout

## Justificări tehnice specifice acestei componente
- **UserDefaults, nu Core Data/SwiftData**, pentru toate store-urile offline — volumul de date e mic (câteva zeci de ghiduri/puncte/alerte), iar `Codable` + `UserDefaults` e mult mai simplu de întreținut și de explicat la interviu decât un model Core Data complet, fără compromisuri reale la această scară.
- **MapKit, nu Google Maps SDK** — nu necesită API key, integrare nativă mai simplă; deep link-ul către Google Maps pentru rutare rămâne opțional, prin `comgooglemaps://` cu fallback pe Apple Maps.
- **Fără `NWPathMonitor` pentru reactivitate live la net** — sincronizarea (alerte, check-in-uri) se declanșează la `onAppear` al ecranelor relevante, nu printr-un listener continuu de rețea. Suficient pentru scenariul cerut, dar nu actualizează automat dacă userul rămâne nemișcat pe ecran exact în clipa în care revine conexiunea.

## Ce nu am terminat și ce aș fi făcut diferit
- **Bug corectat pe parcurs, notabil:** inițial, orice eroare de rețea (nu doar un token expirat) declanșa delogarea completă a userului (`UserService.getUser()` trata orbește orice eșec ca sesiune invalidă). Am separat explicit eroarea de rețea de eroarea de autorizare reală — userul rămâne logat offline, doar conținutul live (alertele, dacă n-are cache) arată eroare de rețea.
- **Fără notificări push** — userul vede o alertă nouă doar la deschiderea aplicației. Aș adăuga APNs pentru notificare instantă, ca într-un sistem real de tip RO-Alert.
- **Starea de check-in e per-device** (`UserDefaults`), nu confirmată de server printr-un flag `hasCheckedIn` pe fiecare alertă — la reinstalare sau logare pe alt dispozitiv, userul ar putea (teoretic) apăsa din nou. Corect ar fi ca serverul să confirme starea, nu doar clientul.
- **Fără teste automate** (unit pentru ViewModels, UI tests pentru fluxurile critice) — dat fiind timpul limitat, am prioritizat acoperirea funcțională.
- **Editarea poziției pe hartă** pentru un punct de adunare existent nu se face din iOS (doar din web) — decizie de scop, cetățeanul oricum nu ar trebui să poată edita puncte de adunare.
