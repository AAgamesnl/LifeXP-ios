import SwiftUI
import Foundation

// MARK: - Analytics Dashboard
// Comprehensive analytics and visualization for life progress tracking

// MARK: - Models

/// Time period for analytics
enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case week = "7D"
    case month = "30D"
    case quarter = "90D"
    case year = "1Y"
    case allTime = "All"
    
    var id: String { rawValue }
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        case .allTime: return 9999
        }
    }
    
    var label: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .quarter: return "Quarter"
        case .year: return "This Year"
        case .allTime: return "All Time"
        }
    }
}

/// Data point for charts
struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let label: String?
    
    init(date: Date, value: Double, label: String? = nil) {
        self.date = date
        self.value = value
        self.label = label
    }
}

/// Dimension breakdown data
struct DimensionData: Identifiable {
    let id = UUID()
    let dimension: LifeDimension
    let value: Double
    let count: Int
    let trend: Double // positive = improving, negative = declining
}

/// Activity heatmap data
struct HeatmapData: Identifiable {
    let id = UUID()
    let date: Date
    let intensity: Double // 0.0 to 1.0
    let count: Int
}

/// Achievement milestone
struct Milestone: Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let iconSystemName: String
    let color: Color
    let xpEarned: Int
}

// MARK: - Analytics Engine

/// Processes and generates analytics data
@MainActor
final class AnalyticsEngine: ObservableObject {
    @Published var selectedPeriod: AnalyticsPeriod = .month
    @Published var xpTrend: [DataPoint] = []
    @Published var levelProgress: [DataPoint] = []
    @Published var dimensionBreakdown: [DimensionData] = []
    @Published var activityHeatmap: [HeatmapData] = []
    @Published var milestones: [Milestone] = []
    @Published var streakHistory: [DataPoint] = []
    @Published var completionRate: [DataPoint] = []
    @Published var isLoading = false
    
    private let calendar = Calendar.current
    private weak var appModel: AppModel?
    
    func configure(with appModel: AppModel) {
        self.appModel = appModel
        refreshData()
    }
    
    func refreshData() {
        guard let appModel = appModel else { return }
        
        isLoading = true
        
        // Generate all analytics data
        generateXPTrend(appModel: appModel)
        generateLevelProgress(appModel: appModel)
        generateDimensionBreakdown(appModel: appModel)
        generateActivityHeatmap(appModel: appModel)
        generateMilestones(appModel: appModel)
        generateStreakHistory(appModel: appModel)
        generateCompletionRate(appModel: appModel)
        
        isLoading = false
    }
    
    private func generateXPTrend(appModel: AppModel) {
        var points: [DataPoint] = []
        var runningXP = 0
        
        // Simulate historical XP gain (in real app, would use actual completion dates)
        let avgDailyXP = max(1, appModel.totalXP / max(1, selectedPeriod.days))
        
        for dayOffset in (0..<min(selectedPeriod.days, 30)).reversed() {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            let variance = Double.random(in: 0.5...1.5)
            runningXP += Int(Double(avgDailyXP) * variance)
            
            points.append(DataPoint(date: date, value: Double(runningXP)))
        }
        
        xpTrend = points
    }
    
    private func generateLevelProgress(appModel: AppModel) {
        var points: [DataPoint] = []
        let currentLevel = appModel.level
        
        // Show level milestones
        for level in max(1, currentLevel - 5)...currentLevel {
            let date = calendar.date(byAdding: .day, value: -(currentLevel - level) * 7, to: Date()) ?? Date()
            points.append(DataPoint(date: date, value: Double(level), label: "Level \(level)"))
        }
        
        levelProgress = points
    }
    
    private func generateDimensionBreakdown(appModel: AppModel) {
        var data: [DimensionData] = []
        
        for dimension in LifeDimension.allCases {
            let items = appModel.allVisibleItems.filter { $0.dimensions.contains(dimension) }
            let completedCount = items.filter { appModel.completedItemIDs.contains($0.id) }.count
            let totalCount = items.count
            
            let ratio = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
            
            // Calculate trend (simulated - would need historical data)
            let trend = Double.random(in: -0.1...0.2)
            
            data.append(DimensionData(
                dimension: dimension,
                value: ratio,
                count: completedCount,
                trend: trend
            ))
        }
        
        dimensionBreakdown = data.sorted { $0.value > $1.value }
    }
    
    private func generateActivityHeatmap(appModel: AppModel) {
        var data: [HeatmapData] = []
        let daysToShow = min(selectedPeriod.days, 90)
        
        // Generate activity data for each day
        let completedCount = appModel.completedItemIDs.count
        let avgDaily = max(1, completedCount / max(1, daysToShow))
        
        for dayOffset in 0..<daysToShow {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            let variance = Int.random(in: 0...(avgDaily * 2))
            let intensity = min(1.0, Double(variance) / Double(max(1, avgDaily * 2)))
            
            data.append(HeatmapData(date: date, intensity: intensity, count: variance))
        }
        
        activityHeatmap = data.reversed()
    }
    
    private func generateMilestones(appModel: AppModel) {
        var milestonesList: [Milestone] = []
        let totalXP = appModel.totalXP
        let streak = appModel.currentStreak
        let completedCount = appModel.completedItemIDs.count
        
        // XP milestones
        let xpMilestones = [100, 250, 500, 1000, 2500, 5000, 10000]
        for milestone in xpMilestones where totalXP >= milestone {
            milestonesList.append(Milestone(
                id: "xp_\(milestone)",
                title: "\(milestone) XP",
                description: "Earned \(milestone) total experience points",
                date: Date(), // Would need actual date in real implementation
                iconSystemName: "star.fill",
                color: .yellow,
                xpEarned: milestone / 10
            ))
        }
        
        // Streak milestones
        let streakMilestones = [3, 7, 14, 30, 60, 100]
        for milestone in streakMilestones where streak >= milestone {
            milestonesList.append(Milestone(
                id: "streak_\(milestone)",
                title: "\(milestone) Day Streak",
                description: "Maintained activity for \(milestone) consecutive days",
                date: Date(),
                iconSystemName: "flame.fill",
                color: .orange,
                xpEarned: milestone * 5
            ))
        }
        
        // Completion milestones
        let completionMilestones = [10, 25, 50, 100, 250, 500]
        for milestone in completionMilestones where completedCount >= milestone {
            milestonesList.append(Milestone(
                id: "complete_\(milestone)",
                title: "\(milestone) Items",
                description: "Completed \(milestone) life improvement items",
                date: Date(),
                iconSystemName: "checkmark.circle.fill",
                color: .green,
                xpEarned: milestone
            ))
        }
        
        self.milestones = milestonesList.sorted { $0.date > $1.date }
    }
    
    private func generateStreakHistory(appModel: AppModel) {
        var points: [DataPoint] = []
        let currentStreak = appModel.currentStreak
        let daysToShow = min(selectedPeriod.days, 30)
        
        // Simulate streak history
        var streak = currentStreak
        for dayOffset in 0..<daysToShow {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            points.insert(DataPoint(date: date, value: Double(streak)), at: 0)
            
            // Random chance of streak continuing backwards
            if Bool.random() && streak > 0 {
                streak = max(0, streak - 1)
            }
        }
        
        streakHistory = points
    }
    
    private func generateCompletionRate(appModel: AppModel) {
        var points: [DataPoint] = []
        let daysToShow = min(selectedPeriod.days, 30)
        
        // Generate completion rate per day
        for dayOffset in 0..<daysToShow {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            let rate = Double.random(in: 0.3...1.0) // Simulated
            points.insert(DataPoint(date: date, value: rate), at: 0)
        }
        
        completionRate = points
    }
    
    // MARK: - Computed Statistics
    
    var averageCompletionRate: Double {
        guard !completionRate.isEmpty else { return 0 }
        return completionRate.reduce(0) { $0 + $1.value } / Double(completionRate.count)
    }
    
    var xpGrowthRate: Double {
        guard xpTrend.count >= 2 else { return 0 }
        let recent = xpTrend.suffix(7).reduce(0) { $0 + $1.value } / 7
        let earlier = xpTrend.prefix(7).reduce(0) { $0 + $1.value } / 7
        guard earlier > 0 else { return 0 }
        return (recent - earlier) / earlier * 100
    }
    
    var bestDimension: LifeDimension? {
        dimensionBreakdown.first?.dimension
    }
    
    var weeklyActivity: Int {
        activityHeatmap.suffix(7).reduce(0) { $0 + $1.count }
    }
}

// MARK: - Views

/// Main Analytics Dashboard View
struct AnalyticsDashboardView: View {
    @Environment(AppModel.self) private var appModel
    @StateObject private var engine = AnalyticsEngine()
    
    @State private var showingExport = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Period selector
                    PeriodSelector(selectedPeriod: $engine.selectedPeriod)
                        .onChange(of: engine.selectedPeriod) { _, _ in
                            engine.refreshData()
                        }
                    
                    // Quick stats
                    QuickStatsGrid(appModel: appModel, engine: engine)
                    
                    // XP trend chart
                    XPTrendCard(data: engine.xpTrend, period: engine.selectedPeriod)
                    
                    // Dimension breakdown
                    DimensionBreakdownCard(data: engine.dimensionBreakdown)
                    
                    // Activity heatmap
                    ActivityHeatmapCard(data: engine.activityHeatmap)
                    
                    // Streak chart
                    StreakChartCard(data: engine.streakHistory)
                    
                    // Completion rate
                    CompletionRateCard(data: engine.completionRate, average: engine.averageCompletionRate)
                    
                    // Milestones
                    MilestonesCard(milestones: engine.milestones)
                    
                    // Insights
                    AnalyticsInsightsCard(engine: engine, appModel: appModel)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.bottom, 100)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            engine.refreshData()
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        
                        Button {
                            showingExport = true
                        } label: {
                            Label("Export Data", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingExport) {
                DataExportSheet(appModel: appModel)
            }
            .onAppear {
                engine.configure(with: appModel)
            }
        }
    }
}

// MARK: - Period Selector

struct PeriodSelector: View {
    @Binding var selectedPeriod: AnalyticsPeriod
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases) { period in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedPeriod = period
                    }
                    HapticsEngine.lightImpact()
                } label: {
                    Text(period.rawValue)
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? BrandTheme.accent : Color.secondary.opacity(0.15))
                        .foregroundStyle(selectedPeriod == period ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Quick Stats Grid

struct QuickStatsGrid: View {
    let appModel: AppModel
    let engine: AnalyticsEngine
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickStatCard(
                title: "Total XP",
                value: "\(appModel.totalXP)",
                icon: "star.fill",
                color: .yellow,
                trend: engine.xpGrowthRate > 0 ? "+\(Int(engine.xpGrowthRate))%" : nil
            )
            
            QuickStatCard(
                title: "Level",
                value: "\(appModel.level)",
                icon: "trophy.fill",
                color: .purple,
                trend: nil
            )
            
            QuickStatCard(
                title: "Streak",
                value: "\(appModel.currentStreak)",
                icon: "flame.fill",
                color: .orange,
                trend: appModel.currentStreak > appModel.bestStreak / 2 ? "🔥" : nil
            )
            
            QuickStatCard(
                title: "Completed",
                value: "\(appModel.completedItemIDs.count)",
                icon: "checkmark.circle.fill",
                color: .green,
                trend: nil
            )
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
                if let trend = trend {
                    Text(trend)
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                }
            }
            
            Text(value)
                .font(.title.bold())
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - XP Trend Card

struct XPTrendCard: View {
    let data: [DataPoint]
    let period: AnalyticsPeriod
    
    var maxValue: Double {
        data.map(\.value).max() ?? 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("XP Progress")
                    .font(.headline)
                
                Spacer()
                
                if let last = data.last, let first = data.first {
                    let growth = last.value - first.value
                    Text("+\(Int(growth)) XP")
                        .font(.subheadline.bold())
                        .foregroundStyle(.green)
                }
            }
            
            if data.isEmpty {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                // Simple line chart
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(1, data.count - 1))
                    
                    ZStack {
                        // Grid lines
                        ForEach(0..<5) { i in
                            let y = height * CGFloat(i) / 4
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        }
                        
                        // Line
                        Path { path in
                            for (index, point) in data.enumerated() {
                                let x = CGFloat(index) * stepX
                                let y = height - (CGFloat(point.value / maxValue) * height)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [BrandTheme.accent, BrandTheme.accent.opacity(0.5)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                        
                        // Fill
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: height))
                            
                            for (index, point) in data.enumerated() {
                                let x = CGFloat(index) * stepX
                                let y = height - (CGFloat(point.value / maxValue) * height)
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                            
                            path.addLine(to: CGPoint(x: width, y: height))
                            path.closeSubpath()
                        }
                        .fill(
                            LinearGradient(
                                colors: [BrandTheme.accent.opacity(0.3), BrandTheme.accent.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        // Data points
                        ForEach(Array(data.enumerated()), id: \.element.id) { index, point in
                            let x = CGFloat(index) * stepX
                            let y = height - (CGFloat(point.value / maxValue) * height)
                            
                            Circle()
                                .fill(BrandTheme.accent)
                                .frame(width: 6, height: 6)
                                .position(x: x, y: y)
                        }
                    }
                }
                .frame(height: 150)
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Dimension Breakdown Card

struct DimensionBreakdownCard: View {
    let data: [DimensionData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Life Dimensions")
                .font(.headline)
            
            ForEach(data) { item in
                HStack(spacing: 12) {
                    Image(systemName: item.dimension.iconSystemName)
                        .foregroundStyle(Color(hex: item.dimension.accentColorHex))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.dimension.label)
                                .font(.subheadline.bold())
                            
                            Spacer()
                            
                            Text("\(Int(item.value * 100))%")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            
                            // Trend indicator
                            if item.trend > 0.05 {
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            } else if item.trend < -0.05 {
                                Image(systemName: "arrow.down.right")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.secondary.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: item.dimension.accentColorHex))
                                    .frame(width: geometry.size.width * item.value)
                            }
                        }
                        .frame(height: 8)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Activity Heatmap Card

struct ActivityHeatmapCard: View {
    let data: [HeatmapData]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Activity")
                    .font(.headline)
                
                Spacer()
                
                // Legend
                HStack(spacing: 4) {
                    Text("Less")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    ForEach([0.1, 0.3, 0.5, 0.7, 1.0], id: \.self) { intensity in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(BrandTheme.accent.opacity(intensity))
                            .frame(width: 12, height: 12)
                    }
                    
                    Text("More")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            if data.isEmpty {
                Text("No activity data")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(data) { point in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(point.intensity > 0 ? BrandTheme.accent.opacity(0.2 + point.intensity * 0.8) : Color.secondary.opacity(0.1))
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            
            // Day labels
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Streak Chart Card

struct StreakChartCard: View {
    let data: [DataPoint]
    
    var maxStreak: Double {
        max(data.map(\.value).max() ?? 1, 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Streak History")
                    .font(.headline)
                
                Spacer()
                
                if let current = data.last {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(Int(current.value)) days")
                            .font(.subheadline.bold())
                    }
                }
            }
            
            if data.isEmpty {
                Text("Start a streak to see your history")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                // Bar chart
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(data) { point in
                        VStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .orange.opacity(0.5)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: max(4, CGFloat(point.value / maxStreak) * 80))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 80)
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Completion Rate Card

struct CompletionRateCard: View {
    let data: [DataPoint]
    let average: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Daily Completion")
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(average * 100))% avg")
                    .font(.subheadline.bold())
                    .foregroundStyle(average > 0.7 ? .green : average > 0.4 ? .yellow : .orange)
            }
            
            if data.isEmpty {
                Text("Complete some items to see your rate")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                // Area chart
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(1, data.count - 1))
                    
                    ZStack {
                        // Average line
                        Path { path in
                            let y = height - (CGFloat(average) * height)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                        .stroke(Color.secondary.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        
                        // Fill
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: height))
                            
                            for (index, point) in data.enumerated() {
                                let x = CGFloat(index) * stepX
                                let y = height - (CGFloat(point.value) * height)
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                            
                            path.addLine(to: CGPoint(x: width, y: height))
                            path.closeSubpath()
                        }
                        .fill(
                            LinearGradient(
                                colors: [.green.opacity(0.4), .green.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        // Line
                        Path { path in
                            for (index, point) in data.enumerated() {
                                let x = CGFloat(index) * stepX
                                let y = height - (CGFloat(point.value) * height)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    }
                }
                .frame(height: 100)
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Milestones Card

struct MilestonesCard: View {
    let milestones: [Milestone]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Milestones")
                .font(.headline)
            
            if milestones.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "flag.fill")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("Complete activities to earn milestones")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(milestones.prefix(10)) { milestone in
                            MilestoneItem(milestone: milestone)
                        }
                    }
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

struct MilestoneItem: View {
    let milestone: Milestone
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(milestone.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: milestone.iconSystemName)
                    .font(.title2)
                    .foregroundStyle(milestone.color)
            }
            
            Text(milestone.title)
                .font(.caption.bold())
                .lineLimit(1)
            
            Text("+\(milestone.xpEarned) XP")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(width: 80)
    }
}

// MARK: - Analytics Insights Card

struct AnalyticsInsightsCard: View {
    let engine: AnalyticsEngine
    let appModel: AppModel
    
    var insights: [(String, String, String, Color)] {
        var result: [(String, String, String, Color)] = []
        
        // Best dimension
        if let best = engine.bestDimension {
            result.append((
                "Top Area",
                "\(best.label) is your strongest dimension",
                best.iconSystemName,
                Color(hex: best.accentColorHex)
            ))
        }
        
        // XP growth
        if engine.xpGrowthRate > 10 {
            result.append((
                "Great Progress!",
                "Your XP growth is up \(Int(engine.xpGrowthRate))% recently",
                "chart.line.uptrend.xyaxis",
                .green
            ))
        }
        
        // Activity
        if engine.weeklyActivity > 20 {
            result.append((
                "Active Week",
                "You've completed \(engine.weeklyActivity) activities this week",
                "bolt.fill",
                .blue
            ))
        }
        
        // Completion rate
        if engine.averageCompletionRate > 0.7 {
            result.append((
                "Consistent",
                "Your completion rate is \(Int(engine.averageCompletionRate * 100))%",
                "checkmark.seal.fill",
                .purple
            ))
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Insights")
                .font(.headline)
            
            if insights.isEmpty {
                Text("Complete more activities to unlock insights")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(Array(insights.enumerated()), id: \.offset) { _, insight in
                    HStack(spacing: 12) {
                        Image(systemName: insight.2)
                            .font(.title2)
                            .foregroundStyle(insight.3)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(insight.0)
                                .font(.subheadline.bold())
                            Text(insight.1)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Data Export Sheet

struct DataExportSheet: View {
    @Environment(\.dismiss) private var dismiss
    let appModel: AppModel
    
    @State private var exportFormat: ExportFormat = .json
    @State private var includeSettings = true
    @State private var includeProgress = true
    @State private var includeStats = true
    @State private var exportedData: String = ""
    @State private var showingShareSheet = false
    
    enum ExportFormat: String, CaseIterable {
        case json = "JSON"
        case csv = "CSV"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Format") {
                    Picker("Export Format", selection: $exportFormat) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Include") {
                    Toggle("Settings", isOn: $includeSettings)
                    Toggle("Progress & Completions", isOn: $includeProgress)
                    Toggle("Statistics", isOn: $includeStats)
                }
                
                Section {
                    Button {
                        generateExport()
                        showingShareSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Generate & Share")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                if !exportedData.isEmpty {
                    Section("Preview") {
                        Text(exportedData)
                            .font(.system(.caption, design: .monospaced))
                            .lineLimit(20)
                    }
                }
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let data = exportedData.data(using: .utf8) {
                    ShareSheet(items: [data])
                }
            }
        }
    }
    
    private func generateExport() {
        switch exportFormat {
        case .json:
            generateJSON()
        case .csv:
            generateCSV()
        }
    }
    
    private func generateJSON() {
        var export: [String: Any] = [
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "appVersion": "1.0"
        ]
        
        if includeSettings {
            export["settings"] = [
                "coachingTone": appModel.settings.toneMode.rawValue,
                "hideHeavyTopics": appModel.hideHeavyTopics,
                "enabledDimensions": appModel.settings.enabledDimensions.map { $0.rawValue }
            ]
        }
        
        if includeProgress {
            export["progress"] = [
                "completedItemIDs": Array(appModel.completedItemIDs),
                "totalXP": appModel.totalXP,
                "level": appModel.level
            ]
        }
        
        if includeStats {
            export["stats"] = [
                "currentStreak": appModel.currentStreak,
                "bestStreak": appModel.bestStreak,
                "completedCount": appModel.completedItemIDs.count
            ]
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: export, options: .prettyPrinted),
           let string = String(data: data, encoding: .utf8) {
            exportedData = string
        }
    }
    
    private func generateCSV() {
        var rows: [[String]] = []
        
        // Header
        rows.append(["Category", "Key", "Value"])
        
        if includeProgress {
            rows.append(["Progress", "Total XP", "\(appModel.totalXP)"])
            rows.append(["Progress", "Level", "\(appModel.level)"])
            rows.append(["Progress", "Completed Items", "\(appModel.completedItemIDs.count)"])
        }
        
        if includeStats {
            rows.append(["Stats", "Current Streak", "\(appModel.currentStreak)"])
            rows.append(["Stats", "Best Streak", "\(appModel.bestStreak)"])
        }
        
        if includeSettings {
            rows.append(["Settings", "Tone Mode", appModel.settings.toneMode.rawValue])
            rows.append(["Settings", "Hide Heavy Topics", "\(appModel.hideHeavyTopics)"])
        }
        
        exportedData = rows.map { $0.joined(separator: ",") }.joined(separator: "\n")
    }
}

// MARK: - Share Sheet (UIKit Bridge)

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#if DEBUG
struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsDashboardView()
            .environment(AppModel())
    }
}
#endif
