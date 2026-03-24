import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsService

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enviar automáticamente al terminar", isOn: $settings.autoSendOnFinish)
                    Toggle("Guardar parcial al terminar", isOn: $settings.savePartialOnFinish)
                    Toggle("Vibración al finalizar (Watch)", isOn: $settings.hapticOnFinish)
                    Toggle("Notificaciones locales", isOn: $settings.enableNotifications)
                }

                Section(header: Text("Formato por defecto")) {
                    Picker("Formato", selection: $settings.defaultMatchFormatRaw) {
                        ForEach(["Best of One","Best of Three","Best of Five"], id: \.
                                self) { format in
                            Text(format).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Color de acento")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(settings.accentOptions, id: \.
                                    self) { name in
                                Button {
                                    settings.accentColorName = name
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
