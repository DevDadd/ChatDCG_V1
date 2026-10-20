//
//  GlassIconButton.swift
//  Runner
//
//  Like glassbutton.swift, but shows an SF Symbol instead of a label.
//

import Flutter
import SwiftUI

final class GlassIconButtonState: ObservableObject {
    @Published var symbol: String
    init(symbol: String) { self.symbol = symbol }
}

struct GlassIconButton: View {
    @ObservedObject var state: GlassIconButtonState
    let iconSize: CGFloat
    let color: Color?
    let tint: Color?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: state.symbol)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(color ?? .primary)
                // Fill the Flutter-sized frame so the whole area is tappable
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        // A capsule on a square frame is a circle
        .modifier(GlassButtonBackground(tint: tint))
    }
}

/// Dart sends colors as a 32-bit ARGB int (Color.toARGB32)
private func colorFromARGB(_ value: Any?) -> Color? {
    (value as? Int).map { argb in
        Color(
            .sRGB,
            red: Double((argb >> 16) & 0xFF) / 255,
            green: Double((argb >> 8) & 0xFF) / 255,
            blue: Double(argb & 0xFF) / 255,
            opacity: Double((argb >> 24) & 0xFF) / 255
        )
    }
}

final class GlassIconButtonFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        GlassIconButtonPlatformView(frame: frame, viewId: viewId, args: args, messenger: messenger)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

final class GlassIconButtonPlatformView: NSObject, FlutterPlatformView {
    private let host: UIHostingController<GlassIconButton>
    private let state: GlassIconButtonState
    private let channel: FlutterMethodChannel

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "glassiconbutton_\(viewId)", binaryMessenger: messenger)

        let params = args as? [String: Any]
        state = GlassIconButtonState(symbol: params?["symbol"] as? String ?? "circle")
        let iconSize = (params?["iconSize"] as? Double).map { CGFloat($0) } ?? 18

        let ch = channel
        host = UIHostingController(rootView: GlassIconButton(
            state: state,
            iconSize: iconSize,
            color: colorFromARGB(params?["color"]),
            tint: colorFromARGB(params?["tint"]),
            action: { ch.invokeMethod("onPressed", arguments: nil) }
        ))
        super.init()

        host.view.backgroundColor = .clear
        host.view.frame = frame

        // Flutter đổi icon từ phía Dart
        channel.setMethodCallHandler { [weak self] call, result in
            if call.method == "setSymbol", let symbol = call.arguments as? String {
                self?.state.symbol = symbol
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> UIView { host.view }
}
