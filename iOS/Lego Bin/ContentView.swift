import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editing: SetItem?
    @State private var draft: SetItem = .blank()

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Sets Yet",
                        systemImage: "square.grid.2x2",
                        description: Text("Tap + to add your first set.")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            Button {
                                draft = item
                                editing = item
                                showingAdd = true
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name.isEmpty ? "Untitled" : item.name)
                                        .font(Theme.bodyFont.weight(.semibold))
                                        .foregroundStyle(Theme.ink)
                                    if !item.setNumber.isEmpty {
                                        Text(item.setNumber)
                                            .font(.caption)
                                            .foregroundStyle(Theme.ink.opacity(0.6))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .accessibilityIdentifier("row_\(item.id.uuidString)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                        .listRowBackground(Color.white.opacity(0.6))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Lego Bin")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            draft = .blank()
                            editing = nil
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEditSheet(draft: $draft, isEditing: editing != nil) {
                    if editing != nil {
                        store.update(draft)
                    } else {
                        store.add(draft)
                    }
                    showingAdd = false
                } onCancel: {
                    showingAdd = false
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

private struct AddEditSheet: View {
    @Binding var draft: SetItem
    var isEditing: Bool
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Set Details") {
                TextField("Name", text: $draft.name)
                    .accessibilityIdentifier("field_name")
                TextField("SetNumber", text: $draft.setNumber)
                    .accessibilityIdentifier("field_setNumber")
                TextField("PieceCount", text: $draft.pieceCount)
                    .accessibilityIdentifier("field_pieceCount")
                TextField("BuildStatus", text: $draft.buildStatus)
                    .accessibilityIdentifier("field_buildStatus")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(isEditing ? "Edit Set" : "Add Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave() }
                        .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
