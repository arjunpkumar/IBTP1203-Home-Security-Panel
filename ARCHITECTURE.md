# Architectural Overview: Home Security Panel iOS App

## 1. Architectural Pattern & Design Philosophy
The application follows a **Model-View-ViewModel (MVVM)** inspired architecture tailored for modern **SwiftUI**. 
* **Unidirectional Data Flow & State Ownership:** Global state is centralized within a single source of truth managed by an `@Observable` class (`SecurityManager`). This eliminates state synchronization bugs across different views.
* **Environment Injection:** The `SecurityManager` instance is injected at the root app entry point using SwiftUI's `.environment()` modifier, making dependencies accessible cleanly across all child views without tight coupling.

---

## 2. Component Breakdown

### A. Models (`Models/`)
* **`SecurityZoneModel` & `SecurityEventModel`:** Lightweight, immutable data structures conforming to `Codable` and `Identifiable`. Each zone tracks identifier, name, armed status, battery percentage, sensor health, and SF Symbol iconography.

### B. State Coordinator (`SecurityManager.swift`)
* Acts as the core business logic controller.
* Implements property observers (`didSet`) to automatically trigger local persistence whenever zones or events are mutated.
* Handles cross-tab reactivity: Toggling a zone in the dashboard instantly appends a corresponding record to the event history log.
* Manages native tactile feedback (`UIImpactFeedbackGenerator`) tied directly to state changes.

### C. Views (`Views/`)
* **`ZoneListView` (Dashboard):** Implements a structured `List` layout embedding quick control buttons, horizontal filter chips, and search logic. Structuring the header elements *inside* the list ensures stability for iOS Large Titles and search drawer geometry.
* **`EventHistoryView`:** Provides historical logs categorized by severity (`info`, `warning`, `critical`), complete with severity filtering chips and a secure clear-history mechanism protected by a confirmation alert.

---

## 3. Data Flow & Persistence Strategy
* **Local Storage:** Utilizes native `UserDefaults` combined with `Codable` JSON encoder/decoder pipelines.
* **Fallback Initialization:** If no locally persisted data is found on first launch, the manager populates a robust, multi-level default smart home configuration (front door, garage, perimeter, upper hallway, etc.) to ensure the app is fully testable immediately out of the box.

---

## 4. Concurrency & UI Performance
* Built with modern **Swift Concurrency** (`async/await`), utilizing asynchronous task sleeps for simulated network fetches and pull-to-refresh actions in event logs.
* Computed properties (`filteredZones`, `filteredEvents`) perform real-time filtering without mutating the core dataset, ensuring optimal O(n) filtering speeds with zero latency.