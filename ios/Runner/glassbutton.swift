//
//  glassbutton.swift
//  Runner
//
//  Created by Quang Anh Nguyen on 20/10/26.
//

import Flutter
import SwiftUI

final class GlassButtonState: ObservableObject {
    @Published var label: String
    init(label: String) { self.label = label }
}

struct GlassButton: View {
    @ObservedObject var state: GlassButtonState
    let tint: Color?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(state.label)
                .font(.system(size: 16, weight: .semibold))
                // Dart sizes the button to fit the label; never wrap
                .lineLimit(1)
                .padding(.horizontal, 16)
                // Fill the Flutter-sized frame so the whole area is tappable
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .modifier(GlassButtonBackground(tint: tint))
    }
}

struct GlassButtonBackground: ViewModifier {
    let tint: Color?

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular.tint(tint).interactive(), in: .capsule)
        } else {
            content
                .background(.ultraThinMaterial, in: Capsule())
                .background(tint ?? .clear, in: Capsule())
        }
    }
}

final class GlassButtonFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        GlassButtonPlatformView(frame: frame, viewId: viewId, args: args, messenger: messenger)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

final class GlassButtonPlatformView: NSObject, FlutterPlatformView {
    private let host: UIHostingController<GlassButton>
    private let state: GlassButtonState
    private let channel: FlutterMethodChannel

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "glassbutton_\(viewId)", binaryMessenger: messenger)

        let params = args as? [String: Any]
        state = GlassButtonState(label: params?["label"] as? String ?? "")
        // Dart sends the tint as a 32-bit ARGB int (Color.toARGB32)
        let tint = (params?["tint"] as? Int).map { argb in
            Color(
                .sRGB,
                red: Double((argb >> 16) & 0xFF) / 255,
                green: Double((argb >> 8) & 0xFF) / 255,
                blue: Double(argb & 0xFF) / 255,
                opacity: Double((argb >> 24) & 0xFF) / 255
            )
        }

        let ch = channel
        host = UIHostingController(rootView: GlassButton(
            state: state, tint: tint,
            action: { ch.invokeMethod("onPressed", arguments: nil) }
        ))
        super.init()

        host.view.backgroundColor = .clear
        host.view.frame = frame

        // Flutter đổi label từ phía Dart
        channel.setMethodCallHandler { [weak self] call, result in
            if call.method == "setLabel", let label = call.arguments as? String {
                self?.state.label = label
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> UIView { host.view }
}
