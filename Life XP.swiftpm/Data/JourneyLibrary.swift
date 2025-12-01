import Foundation

/// Curated journey catalog referencing checklist items.
enum JourneyLibrary {
    static let breakupGlowUp = Journey(
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
    )

    static let getTogether = Journey(
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
    )

    static let softLife = Journey(
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

    static let all: [Journey] = [
        breakupGlowUp,
        getTogether,
        softLife
    ]
}
