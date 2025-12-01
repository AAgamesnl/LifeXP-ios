import SwiftUI
import Foundation

// MARK: - Core Models

enum LifeDimension: String, CaseIterable, Codable, Identifiable {
    case love
    case money
    case mind
    case adventure
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .love: return "Love"
        case .money: return "Money"
        case .mind: return "Mind"
        case .adventure: return "Adventure"
        }
    }
    
    var systemImage: String {
        switch self {
        case .love: return "heart.fill"
        case .money: return "dollarsign.circle.fill"
        case .mind: return "brain.head.profile"
        case .adventure: return "globe.europe.africa.fill"
        }
    }
}

enum ToneMode: String, CaseIterable, Identifiable {
    case soft
    case realTalk
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .soft: return "Soft & gentle"
        case .realTalk: return "Real talk"
        }
    }
}

struct ChecklistItem: Identifiable, Codable {
    let id: String
    let title: String
    let detail: String?
    let xp: Int
    let dimensions: [LifeDimension]
    let isPremium: Bool
}

struct CategoryPack: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let iconSystemName: String
    let accentColorHex: String
    let isPremium: Bool
    let items: [ChecklistItem]
}

struct Journey: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let iconSystemName: String
    let accentColorHex: String
    let durationDays: Int
    let focusDimensions: [LifeDimension]
    let stepItemIDs: [String]
}

struct Badge: Identifiable {
    let id: String
    let name: String
    let description: String
    let iconSystemName: String
}

// MARK: - Sample Data

enum SampleData {
    
    // Packs
    static let relationshipCore = CategoryPack(
        id: "relationship_core",
        title: "Relationship Core",
        subtitle: "Van situationship tot conscious relationship",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#FF3B6A",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "rel_values_talk",
                title: "Gesprek over waarden & toekomst",
                detail: "Je hebt minstens één keer bewust gepraat over geld, kinderen, wonen en toekomstverwachtingen.",
                xp: 25,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_first_trip",
                title: "Eerste trip samen overleefd",
                detail: "Een weekend of langer samen weg geweest zonder elkaar dood te willen maken.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_conflict_clean",
                title: "Conflict clean-up",
                detail: "Na een ruzie hebben jullie echt gereflecteerd, sorry gezegd en concrete afspraken gemaakt.",
                xp: 30,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "rel_geld_gesprek",
                title: "Geld zonder drama",
                detail: "Jullie hebben een eerlijk gesprek gehad over schulden, sparen en uitgaven zonder dat het escaleerde.",
                xp: 25,
                dimensions: [.love, .money],
                isPremium: true
            )
        ]
    )
    
    static let glowUp = CategoryPack(
        id: "glow_up_era",
        title: "Glow-Up Era",
        subtitle: "Level up in looks, habits & energy",
        iconSystemName: "sparkles",
        accentColorHex: "#7C3AED",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "glow_basic_routine",
                title: "Routine locked in",
                detail: "Je hebt minstens 30 dagen na elkaar een ochtend- of avondroutine volgehouden.",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_friend_check",
                title: "Friend audit",
                detail: "Je hebt eerlijk gekeken welke mensen je echt energie geven en welke niet.",
                xp: 20,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_style_update",
                title: "Style refresh",
                detail: "Je hebt bewust je kledingstijl geüpdatet naar hoe jij jezelf in je ‘main character era’ ziet.",
                xp: 25,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_hard_thing",
                title: "Eén hard ding per dag",
                detail: "Je hebt minstens 14 dagen na elkaar elke dag iets gedaan waar je tegenop zag.",
                xp: 35,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )
    
    static let breakupHealing = CategoryPack(
        id: "breakup_healing",
        title: "Breakup & Healing",
        subtitle: "Van delulu naar healed and glowing",
        iconSystemName: "bandage.fill",
        accentColorHex: "#EC4899",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "breakup_no_contact",
                title: "30 dagen no contact",
                detail: "Je hebt 30 dagen geen contact gezocht met je ex (en ook niet stiekem gestalkt).",
                xp: 40,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_lessons",
                title: "3 lessen opgeschreven",
                detail: "Je hebt eerlijk opgeschreven wat jij hebt geleerd uit de relatie én de breakup.",
                xp: 25,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_selfdate",
                title: "Solo 'ex-date' ervaring",
                detail: "Je hebt iets gedaan wat je normaal samen deed, maar nu alleen – en je hebt er je eigen versie van gemaakt.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )
    
    static let moneyCareer = CategoryPack(
        id: "money_career",
        title: "Money & Career",
        subtitle: "Van chaos naar ‘I’ve got this’",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "money_buffer",
                title: "Eerste spaarbuffer",
                detail: "Je hebt minstens één maand vaste kosten aan de kant staan.",
                xp: 35,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_debt_overview",
                title: "Schuld reality check",
                detail: "Je hebt alle schulden + rentes op één plek verzameld zodat je niet meer wegkijkt.",
                xp: 25,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_raise",
                title: "Gesprek over loon",
                detail: "Je hebt minstens één keer in je leven zelf een gesprek gestart over opslag of betere voorwaarden.",
                xp: 35,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "career_cv_update",
                title: "CV & LinkedIn on point",
                detail: "Je hebt je CV en online profiel geüpdatet zodat ze kloppen met wie je nu bent.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )
    
    static let adulting = CategoryPack(
        id: "adulting_101",
        title: "Adulting 101",
        subtitle: "Voor iedereen die ‘ik regel het later’ zegt",
        iconSystemName: "house.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "adult_insurances",
                title: "Basisverzekeringen geregeld",
                detail: "Je weet welke verzekeringen je hebt en waarvoor ze zijn (en je betaalt niet voor dubbele dingen).",
                xp: 30,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_admin_system",
                title: "Admin systeem",
                detail: "Je hebt een eenvoudig systeem om documenten, facturen en brieven te bewaren.",
                xp: 25,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_health_check",
                title: "Gezondheidscheck gedaan",
                detail: "Je hebt minstens één keer een algemene gezondheidscheck laten doen (huisarts / tandarts / bloedonderzoek).",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            )
        ]
    )
    
    static let adventure = CategoryPack(
        id: "adventure_memories",
        title: "Adventure & Memories",
        subtitle: "Main character momentjes verzamelen",
        iconSystemName: "airplane.departure",
        accentColorHex: "#3B82F6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "adv_solo_trip",
                title: "Solo trip",
                detail: "Je bent minstens één keer alleen op reis geweest (dagtrip of langer).",
                xp: 35,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "adv_night_out",
                title: "All-nighter met vrienden",
                detail: "Je hebt een nacht gehad die je nog jaren gaat vertellen tegen mensen.",
                xp: 25,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "adv_scary_thing",
                title: "Bang maar gedaan",
                detail: "Je hebt iets gedaan waar je écht bang voor was, puur om te groeien.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: false
            )
        ]
    )
    
    static let packs: [CategoryPack] = [
        relationshipCore,
        glowUp,
        breakupHealing,
        moneyCareer,
        adulting,
        adventure
    ]
    
    // Zwaardere / gevoelige items (voor safe mode)
    static let heavyItemIDs: Set<String> = [
        "breakup_no_contact",
        "breakup_lessons",
        "breakup_selfdate",
        "adult_health_check"
    ]
    
    // Journeys
    static let journeys: [Journey] = [
        Journey(
            id: "journey_breakup_glowup",
            title: "Breakup → Glow-Up (30 dagen)",
            subtitle: "Van heartbroken naar ‘I’m actually good now’.",
            iconSystemName: "heart.slash.circle.fill",
            accentColorHex: "#EC4899",
            durationDays: 30,
            focusDimensions: [.mind, .love],
            stepItemIDs: [
                "breakup_no_contact",
                "breakup_lessons",
                "breakup_selfdate",
                "glow_basic_routine",
                "glow_friend_check",
                "glow_style_update"
            ]
        ),
        Journey(
            id: "journey_get_together",
            title: "Get Your Sh*t Together (7 dagen)",
            subtitle: "Money, admin & basic life grown-up mode.",
            iconSystemName: "folder.badge.gearshape",
            accentColorHex: "#22C55E",
            durationDays: 7,
            focusDimensions: [.money, .mind],
            stepItemIDs: [
                "money_debt_overview",
                "adult_admin_system",
                "adult_insurances",
                "money_buffer",
                "career_cv_update"
            ]
        ),
        Journey(
            id: "journey_soft_life_starter",
            title: "Soft Life Starter",
            subtitle: "Minder chaos, meer rust & liefde.",
            iconSystemName: "moon.stars.fill",
            accentColorHex: "#7C3AED",
            durationDays: 14,
            focusDimensions: [.mind, .love],
            stepItemIDs: [
                "rel_values_talk",
                "rel_first_trip",
                "glow_basic_routine",
                "glow_friend_check",
                "adv_night_out"
            ]
        )
    ]
}

// MARK: - App Model

final class AppModel: ObservableObject {
    
    // Data
    @Published var packs: [CategoryPack]
    let journeys: [Journey]
    
    @Published private(set) var completedItemIDs: Set<String>
    
    // PRO (nu nog dev toggle; later IAP)
    @Published var premiumUnlocked: Bool = false
    
    // Preferences
    @Published var toneMode: ToneMode = .soft {
        didSet {
            UserDefaults.standard.set(toneMode.rawValue, forKey: Keys.toneMode)
        }
    }
    
    @Published var hideHeavyTopics: Bool = false {
        didSet {
            UserDefaults.standard.set(hideHeavyTopics, forKey: Keys.hideHeavy)
        }
    }
    
    @Published var primaryFocus: LifeDimension? = nil
    @Published var overwhelmedLevel: Int = 3
    
    // Streaks
    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var bestStreak: Int = 0
    private var lastActiveDay: Date?
    
    // UserDefaults keys
    private enum Keys {
        static let completed = "lifeXP.completedItemIDs"
        static let toneMode = "lifeXP.toneMode"
        static let hideHeavy = "lifeXP.hideHeavy"
        static let currentStreak = "lifeXP.currentStreak"
        static let bestStreak = "lifeXP.bestStreak"
        static let lastActiveDay = "lifeXP.lastActiveDay"
    }
    
    init() {
        self.packs = SampleData.packs
        self.journeys = SampleData.journeys
        
        let stored = UserDefaults.standard.stringArray(forKey: Keys.completed) ?? []
        self.completedItemIDs = Set(stored)
        
        if let raw = UserDefaults.standard.string(forKey: Keys.toneMode),
           let tone = ToneMode(rawValue: raw) {
            self.toneMode = tone
        }
        
        self.hideHeavyTopics = UserDefaults.standard.bool(forKey: Keys.hideHeavy)
        
        self.currentStreak = UserDefaults.standard.integer(forKey: Keys.currentStreak)
        self.bestStreak = UserDefaults.standard.integer(forKey: Keys.bestStreak)
        if let date = UserDefaults.standard.object(forKey: Keys.lastActiveDay) as? Date {
            self.lastActiveDay = date
        }
    }
    
    // MARK: - Persistence helpers
    
    private func persistCompleted() {
        UserDefaults.standard.set(Array(completedItemIDs), forKey: Keys.completed)
    }
    
    private func persistStreaks() {
        UserDefaults.standard.set(currentStreak, forKey: Keys.currentStreak)
        UserDefaults.standard.set(bestStreak, forKey: Keys.bestStreak)
        if let last = lastActiveDay {
            UserDefaults.standard.set(last, forKey: Keys.lastActiveDay)
        }
    }
    
    // MARK: - Items helpers
    
    func items(for pack: CategoryPack) -> [ChecklistItem] {
        if hideHeavyTopics {
            return pack.items.filter { !SampleData.heavyItemIDs.contains($0.id) }
        } else {
            return pack.items
        }
    }
    
    var allVisibleItems: [ChecklistItem] {
        packs.flatMap { items(for: $0) }
    }
    
    func item(withID id: String) -> ChecklistItem? {
        for pack in packs {
            if let match = pack.items.first(where: { $0.id == id }) {
                if hideHeavyTopics && SampleData.heavyItemIDs.contains(id) {
                    return nil
                }
                return match
            }
        }
        return nil
    }
    
    // MARK: - Completion & XP
    
    func isCompleted(_ item: ChecklistItem) -> Bool {
        completedItemIDs.contains(item.id)
    }
    
    func toggle(_ item: ChecklistItem) {
        let wasCompleted = isCompleted(item)
        
        if wasCompleted {
            completedItemIDs.remove(item.id)
        } else {
            completedItemIDs.insert(item.id)
            registerActivityToday()
        }
        persistCompleted()
    }
    
    private func registerActivityToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let last = lastActiveDay {
            let lastDay = calendar.startOfDay(for: last)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            switch diff {
            case 0:
                // zelfde dag -> streak niet aanpassen
                break
            case 1:
                currentStreak += 1
            default:
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        lastActiveDay = today
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        persistStreaks()
    }
    
    func progress(for pack: CategoryPack) -> Double {
        let visible = items(for: pack)
        guard !visible.isEmpty else { return 0 }
        let done = visible.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(visible.count)
    }
    
    var globalProgress: Double {
        let allItems = allVisibleItems
        guard !allItems.isEmpty else { return 0 }
        let done = allItems.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(allItems.count)
    }
    
    var totalXP: Int {
        allVisibleItems
            .filter { completedItemIDs.contains($0.id) }
            .reduce(0) { $0 + $1.xp }
    }
    
    func xp(for dimension: LifeDimension) -> Int {
        allVisibleItems
            .filter { completedItemIDs.contains($0.id) && $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }
    
    func maxXP(for dimension: LifeDimension) -> Int {
        allVisibleItems
            .filter { $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }
    
    // MARK: - Journeys
    
    func journeyProgress(_ journey: Journey) -> Double {
        let steps = journey.stepItemIDs.compactMap { item(withID: $0) }
        guard !steps.isEmpty else { return 0 }
        let done = steps.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(steps.count)
    }
    
    func journeyCompletedCount(_ journey: Journey) -> Int {
        journey.stepItemIDs
            .compactMap { item(withID: $0) }
            .filter { completedItemIDs.contains($0.id) }
            .count
    }
    
    func journeyTotalCount(_ journey: Journey) -> Int {
        journey.stepItemIDs.compactMap { item(withID: $0) }.count
    }
    
    // MARK: - Suggesties & coach
    
    var suggestedItem: (pack: CategoryPack, item: ChecklistItem)? {
        let pairs: [(pack: CategoryPack, item: ChecklistItem)] = packs.flatMap { pack in
            items(for: pack).map { (pack: pack, item: $0) }
        }
        
        let incomplete = pairs.filter { pair in
            !completedItemIDs.contains(pair.item.id) &&
            (!pair.item.isPremium || premiumUnlocked)
        }
        
        return incomplete.randomElement()
    }
    
    private func ratio(for dimension: LifeDimension) -> Double {
        let max = maxXP(for: dimension)
        guard max > 0 else { return 0 }
        return Double(xp(for: dimension)) / Double(max)
    }
    
    var lowestDimension: LifeDimension? {
        let candidates = LifeDimension.allCases
        let withMax = candidates.filter { maxXP(for: $0) > 0 }
        guard !withMax.isEmpty else { return nil }
        return withMax.min(by: { ratio(for: $0) < ratio(for: $1) })
    }
    
    var coachMessage: String {
        let score = Int(globalProgress * 100)
        _ = currentStreak
        
        switch toneMode {
        case .soft:
            if score < 20 {
                return "Iedereen start ergens. Eén kleine taak vandaag is genoeg. Je hoeft niet ineens je hele leven te fixen."
            } else if score < 50 {
                return "Je bent bezig, en dat zie je. Kies vandaag iets uit je focus-pack en vier dat het gelukt is."
            } else {
                return "Je bent al een eind op weg. Vergeet niet ook te rusten en te genieten van wat je al hebt gebouwd."
            }
            
        case .realTalk:
            if score < 20 {
                return "Je leven gaat zichzelf niet levelen. Eén kleine taak. Vandaag. Geen excuses."
            } else if score < 50 {
                return "Je bent onderweg, maar je speelt nog op easy mode. Pak vandaag iets waar je eigenlijk geen zin in hebt."
            } else {
                return "Je bent aan het levellen. Nu niet achteroverleunen en alles laten rotten. Blijf consequent."
            }
        }
    }
    
    // MARK: - Badges
    
    var unlockedBadges: [Badge] {
        var result: [Badge] = []
        
        if totalXP >= 50 {
            result.append(Badge(
                id: "badge_getting_started",
                name: "Getting Started",
                description: "Je hebt de eerste stappen gezet en al 50+ XP verzameld.",
                iconSystemName: "sparkles"
            ))
        }
        
        if totalXP >= 200 {
            result.append(Badge(
                id: "badge_leveling_up",
                name: "Leveling Up",
                description: "Je hebt 200+ XP. Je bent officieel bezig met een glow-up.",
                iconSystemName: "arrow.up.circle.fill"
            ))
        }
        
        if xp(for: .love) >= 80 {
            result.append(Badge(
                id: "badge_soft_lover",
                name: "Soft Lover",
                description: "Je investeert serieus in relaties en verbinding.",
                iconSystemName: "heart.circle.fill"
            ))
        }
        
        if xp(for: .money) >= 80 {
            result.append(Badge(
                id: "badge_money_minded",
                name: "Money Minded",
                description: "Je bent eerlijk naar je geld aan het kijken en dat betaalt zich terug.",
                iconSystemName: "banknote.fill"
            ))
        }
        
        if currentStreak >= 3 {
            result.append(Badge(
                id: "badge_streak_3",
                name: "On A Roll",
                description: "Minstens 3 dagen na elkaar iets voor je leven gedaan.",
                iconSystemName: "flame.fill"
            ))
        }
        
        if bestStreak >= 7 {
            result.append(Badge(
                id: "badge_streak_7",
                name: "Consistency Era",
                description: "Je hebt een streak van 7+ dagen gehaald.",
                iconSystemName: "calendar.badge.checkmark"
            ))
        }
        
        return result
    }
}

// MARK: - Design Helpers

extension Color {
    init(hex: String, default defaultColor: Color = .accentColor) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }
        
        guard cleaned.count == 6,
              let rgb = UInt64(cleaned, radix: 16)
        else {
            self = defaultColor
            return
        }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self = Color(red: r, green: g, blue: b)
    }
}
