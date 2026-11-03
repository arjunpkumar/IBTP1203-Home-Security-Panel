import SwiftUI

struct EventHistoryView: View {
    @Environment(SecurityManager.self) private var securityManager
    @State private var selectedSeverity: SecurityEventModel.EventSeverity? = nil
    @State private var showClearConfirmation = false
    @State private var isLoading = false

    var filteredEvents: [SecurityEventModel] {
        guard let severity = selectedSeverity else {
            return securityManager.events
        }
        return securityManager.events.filter { $0.severity == severity }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Severity Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        severityChip(title: "All Events", severity: nil)
                        severityChip(title: "Info", severity: .info)
                        severityChip(title: "Warnings", severity: .warning)
                        severityChip(title: "Critical", severity: .critical)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                // Event List
                List(filteredEvents) { event in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(event.severity.color)
                            .frame(width: 10, height: 10)
                            .padding(.top, 6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.subheadline)
                                .bold()
                            Text(event.timestamp)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .refreshable {
                    await fetchNewEvents()
                }
            }
            .navigationTitle("Event History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // Clear History Button in Top Right Toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showClearConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .disabled(securityManager.events.isEmpty)
                }
            }
            // Warning Confirmation Alert
            .alert("Clear Event History?", isPresented: $showClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    securityManager.clearHistory()
                }
            } message: {
                Text("This action cannot be undone. All recorded security event logs will be permanently deleted.")
            }
        }
    }
    
    private func severityChip(title: String, severity: SecurityEventModel.EventSeverity?) -> some View {
        Button(action: { selectedSeverity = severity }) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(selectedSeverity == severity ? Color.accentColor : Color.secondary.opacity(0.15))
                .foregroundColor(selectedSeverity == severity ? .white : .primary)
                .cornerRadius(20)
        }
    }

    func fetchNewEvents() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

#Preview {
    EventHistoryView()
        .environment(SecurityManager())
}
