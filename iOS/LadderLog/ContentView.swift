import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: LadderEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.name.isEmpty ? "Untitled" : entry.name)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            Text(entry.heightFeet)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Ladder Log")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No ladders yet", systemImage: "tray", description: Text("Tap + to add your first ladder."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: LadderEntry?

    @State private var name: String = ""
    @State private var heightFeet: String = ""
    @State private var lastInspection: String = ""
    @State private var weightRating: String = ""

    init(isPresented: Binding<Bool>, editing: LadderEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _name = State(initialValue: e.name) }
        if let e = editing { _heightFeet = State(initialValue: e.heightFeet) }
        if let e = editing { _lastInspection = State(initialValue: e.lastInspection) }
        if let e = editing { _weightRating = State(initialValue: e.weightRating) }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("addNameField")
                TextField("Height feet", text: $heightFeet)
                    .accessibilityIdentifier("addHeightFeetField")
                TextField("Last inspection", text: $lastInspection)
                    .accessibilityIdentifier("addLastInspectionField")
                TextField("Weight rating", text: $weightRating)
                    .accessibilityIdentifier("addWeightRatingField")
            }
            .navigationTitle(editing == nil ? "Add Ladder" : "Edit Ladder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.name = name
                            e.heightFeet = heightFeet
                            e.lastInspection = lastInspection
                            e.weightRating = weightRating
                            store.update(e)
                        } else {
                            let entry = LadderEntry(name: name, heightFeet: heightFeet, lastInspection: lastInspection, weightRating: weightRating)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
