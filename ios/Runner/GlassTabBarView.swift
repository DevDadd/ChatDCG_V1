import Flutter
import SwiftUI

final class TabState: ObservableObject {
    @Published var index = 0
}

struct GlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        // Clear glass: mostly see-through, only the rim and refraction show
        if #available(iOS 26.0, *) {
            content.glassEffect(.clear.interactive(), in: Capsule())
        } else {
            content.background(Capsule().fill(.ultraThinMaterial).opacity(0.2))
        }
    }
}

/// Capsule behind the selected tab.
struct SelectionBubble: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            // Clear glass, no fill. Not .interactive(): that adds a white
            // glow under the finger
            Capsule()
                .fill(Color.clear)
                .glassEffect(.clear, in: Capsule())
        } else {
            Capsule().fill(Color.clear)
        }
    }
}

/// See-through drop that floats over the icons while the bubble is dragged,
/// like Telegram's tab bar. Deliberately no glass material or shadow: on top
/// of the glass bar both read as frosted, so the drop is drawn from light
/// alone (a bright rim plus a soft glow inside the edge for thickness) and the
/// magnified icon under it does the "lens" work.
struct LiquidLens: View {
    var body: some View {
        Capsule()
            .fill(Color.clear)
            // Glass thickness: light caught just inside the edge
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 5)
                    .blur(radius: 4)
                    .clipShape(Capsule())
            )
            // Bright rim: strongest top-left where light hits, fading round
            // the side, picking up again bottom-right
            .overlay(
                Capsule().strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.8), .white.opacity(0.12), .white.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            )
    }
}

/// Springy, slightly bouncy move, close to the iOS 26 tab bar
let tabSelectionAnimation = Animation.spring(response: 0.38, dampingFraction: 0.72)

struct GlassTabBar: View {
    @ObservedObject var state: TabState
    let items: [(title: String, icon: String)]
    let onSelect: (Int) -> Void

    @State private var width: CGFloat = 0
    // Finger x while the bubble is being dragged; nil when resting on a tab
    @State private var dragX: CGFloat?
    // 0...0.3, grows with finger speed; the lens stretches wide and flat
    // when flung and wobbles back to round when it slows
    @State private var stretch: CGFloat = 0

    private var itemWidth: CGFloat {
        items.isEmpty ? 0 : width / CGFloat(items.count)
    }

    private func index(at x: CGFloat) -> Int {
        guard itemWidth > 0 else { return state.index }
        return min(max(Int(x / itemWidth), 0), items.count - 1)
    }

    // Tab under the finger while dragging, otherwise the selected one
    private var highlighted: Int {
        dragX.map(index(at:)) ?? state.index
    }

    private var bubbleOffset: CGFloat {
        if let x = dragX {
            return min(max(x - itemWidth / 2, 0), width - itemWidth)
        }
        return CGFloat(state.index) * itemWidth
    }

    private func select(_ i: Int) {
        withAnimation(tabSelectionAnimation) {
            dragX = nil
            stretch = 0
            state.index = i
        }
        onSelect(i)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { i in
                VStack(spacing: 2) {
                    Image(systemName: items[i].icon)
                        .font(.system(size: 20, weight: .medium))
                    Text(items[i].title)
                        .font(.caption2)
                }
                // Magnified under the lens
                .scaleEffect(dragX != nil && highlighted == i ? 1.25 : 1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(highlighted == i ? Color.accentColor : Color.white)
                .accessibilityAddTraits(.isButton)
                .accessibilityAction { select(i) }
            }
        }
        .background(alignment: .leading) {
            // Resting bubble behind the icons; hands over to the lens on drag
            SelectionBubble()
                .opacity(dragX == nil ? 1 : 0)
                .frame(width: itemWidth)
                .offset(x: bubbleOffset)
        }
        .overlay(alignment: .leading) {
            // Lens sits above the icons so its glass refracts them. It swells
            // past the bar's edges and squashes with speed.
            LiquidLens()
                .frame(width: itemWidth)
                .scaleEffect(
                    // Roughly one tab wide, clearly taller than the bar
                    x: dragX == nil ? 0.9 : 1.1 * (1 + stretch),
                    y: dragX == nil ? 0.9 : 1.45 * (1 - stretch * 0.5)
                )
                .opacity(dragX == nil ? 0 : 1)
                .offset(x: bubbleOffset)
                .allowsHitTesting(false)
        }
        .background(GeometryReader { geo in
            Color.clear
                .onAppear { width = geo.size.width }
                .onChange(of: geo.size.width) { width = $0 }
        })
        .contentShape(Rectangle())
        // One gesture for both: a short touch selects the tab under it,
        // a drag carries the bubble and drops it on the nearest tab
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    guard dragX != nil || abs(value.translation.width) > 6 else { return }
                    // Distance the finger would still travel = its speed
                    let speed = abs(value.predictedEndLocation.x - value.location.x)
                    withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 0.55)) {
                        dragX = value.location.x
                        stretch = min(speed / 400, 0.3)
                    }
                }
                .onEnded { value in
                    select(index(at: value.location.x))
                }
        )
        .padding(6)
        .modifier(GlassBackground())
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        // Sit at the bottom of the Flutter-sized frame instead of centering in it
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

final class GlassTabBarFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        GlassTabBarPlatformView(frame: frame, viewId: viewId, args: args, messenger: messenger)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

final class GlassTabBarPlatformView: NSObject, FlutterPlatformView {
    private let host: UIHostingController<GlassTabBar>
    private let state = TabState()
    private let channel: FlutterMethodChannel

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "glass_tab_bar_\(viewId)", binaryMessenger: messenger)

        let raw = (args as? [String: Any])?["items"] as? [[String: String]] ?? []
        let items = raw.map { (title: $0["title"] ?? "", icon: $0["icon"] ?? "circle") }

        state.index = (args as? [String: Any])?["index"] as? Int ?? 0

        let ch = channel
        host = UIHostingController(rootView: GlassTabBar(
            state: state, items: items,
            onSelect: { ch.invokeMethod("onSelect", arguments: $0) }
        ))
        super.init()

        host.view.backgroundColor = .clear
        host.view.frame = frame

        // Flutter đổi tab từ phía Dart
        channel.setMethodCallHandler { [weak self] call, result in
            if call.method == "setIndex", let i = call.arguments as? Int {
                withAnimation(tabSelectionAnimation) { self?.state.index = i }
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> UIView { host.view }
}
