import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsService

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General")) {
                    Toggle("Notificaciones locales", isOn: $settings.enableNotifications)
                        .onChange(of: settings.enableNotifications) { _, _ in settings.syncToWatch() }
                }

                Section(header: Text("Formato por defecto")) {
                    Picker("Formato", selection: $settings.defaultMatchFormatRaw) {
                        ForEach(["Best of One", "Best of Three", "Best of Five"], id: \.self) { format in
                            Text(format).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settings.defaultMatchFormatRaw) { _, _ in settings.syncToWatch() }
                    
                    Picker("Posición", selection: $settings.defaultPositionRaw) {
                        ForEach(["left", "right"], id: \.self) { pos in
                            Text(pos.capitalized).tag(pos)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settings.defaultPositionRaw) { _, _ in settings.syncToWatch() }
                }

                Section(header: Text("Color de acento")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(settings.accentOptions, id: \.self) { name in
                                Button {
                                    settings.accentColorName = name
                                    settings.syncToWatch()
                                } label: {
                                    ZStack {
                                        Color(name)
                                            .frame(width: 64, height: 40)
                                            .cornerRadius(8)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(settings.accentColorName == name ? 1 : 0), lineWidth: 2))
                                        if settings.accentColorName == name {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }.padding(.vertical, 6)
                    }
                }

                

                Section {
                    Button(role: .destructive) {
                        // Reset settings to defaults
                        settings.autoSendOnFinish = true
                        settings.savePartialOnFinish = true
                        settings.hapticOnFinish = true
                        settings.enableNotifications = true
                        settings.defaultMatchFormatRaw = "Best of One"
                        settings.accentColorName = "PPBlue"
                        settings.syncToWatch()
                    } label: {
                        Text("Restablecer valores por defecto")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsService.shared)
}
