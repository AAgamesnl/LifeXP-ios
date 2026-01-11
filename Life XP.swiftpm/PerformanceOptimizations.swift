import SwiftUI
import Foundation

// MARK: - Performance Optimizations
// Advanced caching, memory management, and performance utilities

// MARK: - Cache Manager

/// Thread-safe cache for expensive computations
final class CacheManager {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, AnyObject>()
    private let queue = DispatchQueue(label: "com.lifexp.cache", attributes: .concurrent)
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
        
        // Clear cache on memory warning
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.clearCache()
        }
    }
    
    func set<T: AnyObject>(_ object: T, forKey key: String, cost: Int = 0) {
        queue.async(flags: .barrier) { [weak self] in
            self?.cache.setObject(object, forKey: key as NSString, cost: cost)
        }
    }
    
    func get<T: AnyObject>(forKey key: String) -> T? {
        queue.sync {
            cache.object(forKey: key as NSString) as? T
        }
    }
    
    func remove(forKey key: String) {
        queue.async(flags: .barrier) { [weak self] in
            self?.cache.removeObject(forKey: key as NSString)
        }
    }
    
    func clearCache() {
        queue.async(flags: .barrier) { [weak self] in
            self?.cache.removeAllObjects()
        }
    }
}

// MARK: - Computed Value Cache

/// Caches expensive computed values with automatic invalidation
@propertyWrapper
struct Cached<Value> {
    private var cachedValue: Value?
    private var computeValue: () -> Value
    private var lastComputeTime: Date?
    private let ttl: TimeInterval
    
    init(ttl: TimeInterval = 60, compute: @escaping () -> Value) {
        self.ttl = ttl
        self.computeValue = compute
    }
    
    var wrappedValue: Value {
        mutating get {
            let now = Date()
            if let cached = cachedValue,
               let lastTime = lastComputeTime,
               now.timeIntervalSince(lastTime) < ttl {
                return cached
            }
            
            let newValue = computeValue()
            cachedValue = newValue
            lastComputeTime = now
            return newValue
        }
    }
    
    mutating func invalidate() {
        cachedValue = nil
        lastComputeTime = nil
    }
}

// MARK: - Debounced State

/// State wrapper that debounces updates
@propertyWrapper
struct DebouncedState<Value>: DynamicProperty {
    @State private var storedValue: Value
    @State private var pendingValue: Value?
    @State private var debounceTask: Task<Void, Never>?
    
    private let delay: TimeInterval
    
    init(wrappedValue: Value, delay: TimeInterval = 0.3) {
        self._storedValue = State(initialValue: wrappedValue)
        self.delay = delay
    }
    
    var wrappedValue: Value {
        get { storedValue }
        nonmutating set {
            debounceTask?.cancel()
            pendingValue = newValue
            
            debounceTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                if !Task.isCancelled, let pending = pendingValue {
                    storedValue = pending
                    pendingValue = nil
                }
            }
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

// MARK: - Lazy View Loading

/// Defers view creation until actually needed
struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

// MARK: - Equatable View Wrapper

/// Prevents unnecessary view updates
struct EquatableView<Content: View, Value: Equatable>: View, Equatable {
    let value: Value
    let content: (Value) -> Content
    
    static func == (lhs: EquatableView, rhs: EquatableView) -> Bool {
        lhs.value == rhs.value
    }
    
    var body: some View {
        content(value)
    }
}

// MARK: - Optimized List Item

/// Optimized list row with built-in performance features
struct OptimizedListItem<Content: View>: View {
    let id: String
    let content: () -> Content
    
    @State private var hasAppeared = false
    
    init(id: String, @ViewBuilder content: @escaping () -> Content) {
        self.id = id
        self.content = content
    }
    
    var body: some View {
        Group {
            if hasAppeared {
                content()
            } else {
                Color.clear
                    .frame(height: 60)
            }
        }
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
            }
        }
    }
}

// MARK: - Image Cache

/// Efficient image caching system
actor ImageCache {
    static let shared = ImageCache()
    
    private var cache: [String: UIImage] = [:]
    private let maxCacheSize = 50
    private var accessOrder: [String] = []
    
    func image(for key: String) -> UIImage? {
        if let image = cache[key] {
            // Move to end (most recently used)
            if let index = accessOrder.firstIndex(of: key) {
                accessOrder.remove(at: index)
            }
            accessOrder.append(key)
            return image
        }
        return nil
    }
    
    func setImage(_ image: UIImage, for key: String) {
        // Evict oldest if at capacity
        if cache.count >= maxCacheSize, let oldest = accessOrder.first {
            cache.removeValue(forKey: oldest)
            accessOrder.removeFirst()
        }
        
        cache[key] = image
        accessOrder.append(key)
    }
    
    func clearCache() {
        cache.removeAll()
        accessOrder.removeAll()
    }
}

// MARK: - Async Image Loader

/// Optimized async image loading with caching
struct CachedAsyncImage: View {
    let url: URL?
    let placeholder: AnyView
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(url: URL?, @ViewBuilder placeholder: () -> some View = { ProgressView() }) {
        self.url = url
        self.placeholder = AnyView(placeholder())
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        let key = url.absoluteString
        
        // Check cache first
        if let cached = await ImageCache.shared.image(for: key) {
            image = cached
            return
        }
        
        // Load from network
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                await ImageCache.shared.setImage(loadedImage, for: key)
                await MainActor.run {
                    image = loadedImage
                }
            }
        } catch {
            // Silent fail - placeholder will remain
        }
    }
}

// MARK: - Throttled Action

/// Prevents action from being called too frequently
struct ThrottledAction {
    private let interval: TimeInterval
    private var lastExecution: Date?
    private let action: () -> Void
    
    init(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
    }
    
    mutating func execute() {
        let now = Date()
        if let last = lastExecution, now.timeIntervalSince(last) < interval {
            return
        }
        lastExecution = now
        action()
    }
}

// MARK: - Memory Monitor

/// Monitors app memory usage
final class MemoryMonitor: ObservableObject {
    static let shared = MemoryMonitor()
    
    @Published var memoryUsage: UInt64 = 0
    @Published var isMemoryPressure = false
    
    private var timer: Timer?
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateMemoryUsage()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            memoryUsage = info.resident_size
            isMemoryPressure = info.resident_size > 200 * 1024 * 1024 // 200MB threshold
        }
    }
}

// MARK: - View Modifiers

/// Adds lazy loading behavior to any view
struct LazyLoadingModifier: ViewModifier {
    @State private var isLoaded = false
    let threshold: CGFloat
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            Group {
                if isLoaded {
                    content
                } else {
                    Color.clear
                }
            }
            .onAppear {
                // Load when appearing in viewport
                if geometry.frame(in: .global).minY < UIScreen.main.bounds.height + threshold {
                    isLoaded = true
                }
            }
        }
    }
}

extension View {
    func lazyLoading(threshold: CGFloat = 100) -> some View {
        modifier(LazyLoadingModifier(threshold: threshold))
    }
}

/// Prevents view updates during scroll
struct ScrollOptimizationModifier: ViewModifier {
    @State private var isScrolling = false
    
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isScrolling)
            .onPreferenceChange(ScrollingPreferenceKey.self) { value in
                isScrolling = value
            }
    }
}

struct ScrollingPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

// MARK: - Optimized Animations

/// Animation presets optimized for performance
struct OptimizedAnimations {
    /// Fast, minimal animation for UI feedback
    static let quick = Animation.spring(response: 0.25, dampingFraction: 0.9)
    
    /// Standard interaction animation
    static let standard = Animation.spring(response: 0.35, dampingFraction: 0.85)
    
    /// Smooth, polished animation for important transitions
    static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    /// Bouncy animation for celebratory moments
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.6)
    
    /// Minimal animation for reduced motion users
    static let minimal = Animation.easeOut(duration: 0.15)
}

// MARK: - Batch Update Coordinator

/// Batches multiple state updates to reduce render cycles
@MainActor
final class BatchUpdateCoordinator: ObservableObject {
    private var pendingUpdates: [() -> Void] = []
    private var isProcessing = false
    
    func enqueue(_ update: @escaping () -> Void) {
        pendingUpdates.append(update)
        
        if !isProcessing {
            processUpdates()
        }
    }
    
    private func processUpdates() {
        guard !pendingUpdates.isEmpty else { return }
        isProcessing = true
        
        // Process all pending updates in a single transaction
        Task { @MainActor in
            let updates = pendingUpdates
            pendingUpdates.removeAll()
            
            withAnimation(.default) {
                for update in updates {
                    update()
                }
            }
            
            isProcessing = false
            
            // Check for more updates that came in during processing
            if !pendingUpdates.isEmpty {
                processUpdates()
            }
        }
    }
}

// MARK: - Precomputed Values

/// Stores precomputed values for expensive calculations
struct PrecomputedStats {
    let totalXP: Int
    let level: Int
    let progress: Double
    let dimensionScores: [LifeDimension: Double]
    let streakInfo: (current: Int, best: Int)
    let completedCount: Int
    
    @MainActor
    static func compute(from appModel: AppModel) -> PrecomputedStats {
        let completedIDs = appModel.completedItemIDs
        let allItems = appModel.allVisibleItems
        
        // Dimension scores
        var dimensionScores: [LifeDimension: Double] = [:]
        for dimension in LifeDimension.allCases {
            let items = allItems.filter { $0.dimensions.contains(dimension) }
            let completed = items.filter { completedIDs.contains($0.id) }.count
            dimensionScores[dimension] = items.isEmpty ? 0 : Double(completed) / Double(items.count)
        }
        
        return PrecomputedStats(
            totalXP: appModel.totalXP,
            level: appModel.level,
            progress: appModel.levelProgress,
            dimensionScores: dimensionScores,
            streakInfo: (appModel.currentStreak, appModel.bestStreak),
            completedCount: completedIDs.count
        )
    }
}

// MARK: - Debug Performance View

#if DEBUG
struct PerformanceDebugView: View {
    @StateObject private var memoryMonitor = MemoryMonitor.shared
    @State private var frameCount = 0
    @State private var fps: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Memory: \(ByteCountFormatter.string(fromByteCount: Int64(memoryMonitor.memoryUsage), countStyle: .memory))")
                .font(.caption.monospaced())
            
            Text("FPS: \(String(format: "%.1f", fps))")
                .font(.caption.monospaced())
            
            if memoryMonitor.isMemoryPressure {
                Text("⚠️ Memory Pressure")
                    .font(.caption.bold())
                    .foregroundStyle(.red)
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task {
            // Simple FPS counter
            var lastTime = Date()
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                let now = Date()
                fps = Double(frameCount) / now.timeIntervalSince(lastTime)
                frameCount = 0
                lastTime = now
            }
        }
    }
}
#endif

// MARK: - Optimized Data Structures

/// A set that maintains insertion order for predictable iteration
struct OrderedSet<Element: Hashable>: Sequence {
    private var array: [Element] = []
    private var set: Set<Element> = []
    
    var count: Int { array.count }
    var isEmpty: Bool { array.isEmpty }
    
    mutating func insert(_ element: Element) {
        if set.insert(element).inserted {
            array.append(element)
        }
    }
    
    mutating func remove(_ element: Element) {
        if set.remove(element) != nil {
            array.removeAll { $0 == element }
        }
    }
    
    func contains(_ element: Element) -> Bool {
        set.contains(element)
    }
    
    func makeIterator() -> IndexingIterator<[Element]> {
        array.makeIterator()
    }
}

// MARK: - Preview

#if DEBUG
struct PerformanceOptimizations_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceDebugView()
            .padding()
    }
}
#endif
