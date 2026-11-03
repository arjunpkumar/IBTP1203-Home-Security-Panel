# 🛡️ Home Security Panel

An elegant, lightweight iOS application built with **SwiftUI** and modern **Swift Concurrency**, designed to track residential security zones and historical event logs in real time.

---

## 🚀 Key Features

* **Zone Dashboard:** Real-time monitoring of designated security zones with battery diagnostics, sensor status, and reactive arm/disarm toggles.
* **Event History Screen:** Chronological log tracking system events with color-coded severity levels (info / warning / critical) and pull-to-refresh asynchronous simulation.
* **Modular Tab Layout:** Clean navigation split cleanly between zones and historical alerts.
* **Local Persistence:** Zones and events are persisted across app launches using `UserDefaults` (JSON-encoded `Codable` models).
* **Reactive State:** Single source of truth via an `@Observable` `SecurityManager` injected through the SwiftUI environment.

---

## 🏗️ Architecture & Design Patterns

* **MVVM Design Pattern:** Clean separation between pure data models (`SecurityZoneModel`, `SecurityEventModel`), state handlers (`SecurityManager`), and declarative SwiftUI views.
* **Swift Concurrency:** Utilizes structured concurrency (`async/await`, `Task.sleep`) for asynchronous data refresh simulations.
* **Declarative UI:** Built entirely using modern SwiftUI (`NavigationStack`, `TabView`, `@State` bindings, `.refreshable`).
* **Observation Framework:** Uses the `@Observable` macro (iOS 17+) for fine-grained, automatic view updates without manual `ObservableObject`/`@Published` boilerplate.
* **Persistence Layer:** `didSet` observers on published collections encode to `UserDefaults` on every mutation; `init` hydrates from storage or falls back to mock data.

---

## 📂 Project Structure

```text
HomeSecurityPanel/
├── App/
│   └── HomeSecurityPanelApp.swift        # @main entry point → MainTabView
├── Models/
│   ├── SecurityZoneModel.swift           # Zone data model (id, name, isArmed, batteryLevel, sensorStatus, iconName)
│   ├── SecurityEventModel.swift           # Event data model (id, title, timestamp, severity w/ color)
│   └── SecurityManager.swift             # @Observable state holder + persistence + toggle logic
├── Views/
│   ├── MainTabView.swift                 # TabView (Zones / Events) + injects SecurityManager
│   ├── Dashboard/
│   │   └── ZoneListView.swift            # List of zones with arm/disarm Toggle
│   └── Events/
│       └── EventHistoryView.swift        # Chronological event log + pull-to-refresh
└── Resources/
    └── Assets.xcassets                   # App icon, accent color
```

---

## 🧩 Data Models

### `SecurityZoneModel`
| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier |
| `name` | `String` | Human-readable zone name |
| `isArmed` | `Bool` | Whether the zone is currently armed |
| `batteryLevel` | `Int` | Sensor battery percentage (0–100) |
| `sensorStatus` | `String` | Status text (e.g. "Secure", "Attention") |
| `iconName` | `String` | SF Symbol name for the zone icon |

### `SecurityEventModel`
| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier |
| `title` | `String` | Event description |
| `timestamp` | `String` | Human-readable time string |
| `severity` | `EventSeverity` | `.info` (blue), `.warning` (orange), `.critical` (red) |

---

## 🔄 State & Event Flow

1. `MainTabView` creates a single `@State SecurityManager` and injects it via `.environment(...)`.
2. `ZoneListView` reads `securityManager.zones` and renders each zone row.
3. Toggling a zone calls `securityManager.toggleZone(_:)`, which:
   - Flips `isArmed` for the matching zone.
   - Stamps the current time.
   - Prepends a new `SecurityEventModel` (severity `.info` if armed, `.warning` if disarmed).
   - Triggers `didSet` persistence for both collections.
4. `EventHistoryView` renders `securityManager.events` (newest first) with color-coded severity dots.
5. Pull-to-refresh invokes `fetchNewEvents()`, which simulates an async fetch via `Task.sleep`.

---

## ⚙️ Requirements

* **Xcode:** 26.0 or later (project uses deployment target 26.2)
* **iOS:** 26.2+ (iPhone & iPad — `TARGETED_DEVICE_FAMILY = "1,2"`)
* **Swift:** 5.0
* **No third-party dependencies** — uses only first-party frameworks (SwiftUI, Foundation, Observation).

---

## 🛠️ Build & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/arjunpkumar/IBTP1203-Home-Security-Panel.git
   cd IBTP1203-Home-Security-Panel/HomeSecurityPanel
   ```
2. Open the project in Xcode:
   ```bash
   open HomeSecurityPanel.xcodeproj
   ```
3. Select a simulator (e.g. iPhone 17) or a connected device.
4. Build & run with `⌘R`.

Or build from the command line:
```bash
xcodebuild -project HomeSecurityPanel.xcodeproj \
           -scheme HomeSecurityPanel \
           -destination 'platform=iOS Simulator,name=iPhone 17' \
           build
```

---

## 🧪 Testing

No unit/UI tests are currently included. To add tests, create a test target in Xcode and cover:
* `SecurityManager.toggleZone(_:)` state + event creation.
* `didSet` persistence round-trip via `UserDefaults`.
* `SecurityEventModel.EventSeverity.color` mapping.

---

## 📝 Known Limitations

* `fetchNewEvents()` only simulates latency (`Task.sleep`) and does not generate new events.
* Duplicate `import SwiftUI` statements exist in `ZoneListView.swift` and `EventHistoryView.swift`.
* `SecurityEventModel` and `SecurityManager` import `SwiftUI` unnecessarily (could be reduced to `Foundation` / `Observation`).
* No remote backend or push notifications — all data is local/mock.

---

## 📸 Screenshots

See the `Screenshots/` directory (currently empty) for UI captures.

---

## 📄 License

No license file is currently specified. Please contact the repository owner for usage terms.