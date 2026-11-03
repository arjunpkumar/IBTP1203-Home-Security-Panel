import SwiftUI

struct ZoneListView: View {
    @Environment(SecurityManager.self) private var securityManager
    @State private var searchText = ""
    @State private var selectedFilter: ZoneFilter = .all
    @State private var showDisarmConfirmation = false

    enum ZoneFilter {
        case all, armed, disarmed
    }

    var filteredZones: [SecurityZoneModel] {
        securityManager.zones.filter { zone in
            let matchesSearch = searchText.isEmpty || zone.name.localizedStandardContains(searchText)
            switch selectedFilter {
            case .all: return matchesSearch
            case .armed: return matchesSearch && zone.isArmed
            case .disarmed: return matchesSearch && !zone.isArmed
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Header Controls Section (Lives inside the list to keep Large Title stable)
                Section {
                    HStack(spacing: 12) {
                        Button(action: { securityManager.setAllZones(armed: true) }) {
                            Label("Arm All", systemImage: "lock.fill")
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { showDisarmConfirmation = true }) {
                            Label("Disarm All", systemImage: "lock.open.fill")
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            filterButton(title: "All Zones", filter: .all)
                            filterButton(title: "Armed", filter: .armed)
                            filterButton(title: "Disarmed", filter: .disarmed)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } header: {
                    Text("Quick Controls")
                }

                // Security Zones Section
                Section(header: Text("Zones (\(filteredZones.count))")) {
                    ForEach(filteredZones) { zone in
                        HStack(spacing: 16) {
                            Image(systemName: zone.iconName)
                                .font(.title2)
                                .foregroundColor(zone.isArmed ? .blue : .orange)
                                .frame(width: 32)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(zone.name)
                                    .font(.headline)
                                Text("Battery: \(zone.batteryLevel)% • Status: \(zone.sensorStatus)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { zone.isArmed },
                                set: { _ in securityManager.toggleZone(zone) }
                            ))
                            .labelsHidden()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search security zones...")
            .navigationTitle("Security Zones")
            .navigationBarTitleDisplayMode(.large)
            .alert("Disarm Entire System?", isPresented: $showDisarmConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Disarm All", role: .destructive) {
                    securityManager.setAllZones(armed: false)
                }
            } message: {
                Text("This will deactivate protection for all security zones across the property.")
            }
        }
    }

    private func filterButton(title: String, filter: ZoneFilter) -> some View {
        Button(action: { selectedFilter = filter }) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(selectedFilter == filter ? Color.accentColor : Color.secondary.opacity(0.15))
                .foregroundColor(selectedFilter == filter ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    ZoneListView()
        .environment(SecurityManager())
}
