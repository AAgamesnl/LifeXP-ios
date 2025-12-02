import SwiftUI

struct PacksView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 18) {
                    ForEach(model.packs) { pack in
                        NavigationLink(destination: PackDetailView(pack: pack)) {
                            PackCardView(pack: pack)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Life Packs")
        }
    }
}

struct PackCardView: View {
    @EnvironmentObject var model: AppModel
    let pack: CategoryPack
    
    var body: some View {
        let accent = Color(hex: pack.accentColorHex, default: .accentColor)
        
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(accent.opacity(0.15))
                
                Image(systemName: pack.iconSystemName)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(accent)
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(pack.title)
                        .font(.headline)
                    
                    if pack.isPremium {
                        Text("PRO")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(Color.yellow.opacity(0.2))
                            )
                            .overlay(
                                Capsule().stroke(Color.yellow.opacity(0.7), lineWidth: 1)
                            )
                    }
                }
                
                Text(pack.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                ProgressView(
                    value: model.progress(for: pack),
                    total: 1
                )
                .tint(accent.opacity(0.9))
                
                Text("\(Int(model.progress(for: pack) * 100))% completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
}

// MARK: - Pack Detail

struct PackDetailView: View {
    @EnvironmentObject var model: AppModel
    let pack: CategoryPack
    
    var items: [ChecklistItem] {
        model.items(for: pack)
    }
    
    var body: some View {
        let accent = Color(hex: pack.accentColorHex, default: .accentColor)
        
        List {
            Section {
                HStack(alignment: .top, spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(accent.opacity(0.15))
                        
                        Image(systemName: pack.iconSystemName)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(accent)
                    }
                    .frame(width: 64, height: 64)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(pack.title)
                            .font(.title2.bold())
                        
                        Text(pack.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: model.progress(for: pack))
                            .tint(accent)
                        
                        Text("\(Int(model.progress(for: pack) * 100))% completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            Section(header: Text("Checklist")) {
                ForEach(items) { item in
                    ChecklistRow(item: item, accent: accent)
                }
            }
        }
        .navigationTitle(pack.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Checklist Row

struct ChecklistRow: View {
    @EnvironmentObject var model: AppModel
    let item: ChecklistItem
    let accent: Color
    
    @State private var showPaywall = false
    
    var body: some View {
        Button {
            if item.isPremium && !model.premiumUnlocked {
                showPaywall = true
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    model.toggle(item)
                }
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: model.isCompleted(item) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(model.isCompleted(item) ? accent : Color(.systemGray4))
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if item.isPremium {
                            Text("PRO")
                                .font(.caption2.bold())
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule().fill(Color.yellow.opacity(0.16))
                                )
                                .overlay(
                                    Capsule().stroke(Color.yellow.opacity(0.7), lineWidth: 0.8)
                                )
                        }
                    }
                    
                    if let detail = item.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    HStack(spacing: 8) {
                        Text("\(item.xp) XP")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(accent.opacity(0.12))
                            )
                            .foregroundColor(accent)
                        
                        ForEach(item.dimensions) { dim in
                            HStack(spacing: 4) {
                                Image(systemName: dim.systemImage)
                                Text(dim.label)
                            }
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(Color(.systemGray6))
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .alert("Life XP PRO", isPresented: $showPaywall) {
            Button("Later", role: .cancel) { }
        } message: {
            Text("Deze task hoort bij Life XP PRO.\n\nIn de echte app kun je PRO ontgrendelen via een eenmalige in-app aankoop. Voor nu kun je PRO testen via de dev toggle in Settings.")
        }
    }
}
