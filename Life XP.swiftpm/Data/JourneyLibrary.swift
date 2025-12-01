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

    static let wellnessReset = Journey(
        id: "journey_wellness_reset",
        title: "Wellness Reset (10 dagen)",
        subtitle: "Slaap, bewegen en grenzen terug op groen.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#10B981",
        durationDays: 10,
        focusDimensions: [.mind],
        stepItemIDs: [
            "wellness_sleep_reset",
            "wellness_boundaries",
            "wellness_move_daily",
            "glow_digital_detox",
            "wellness_therapy_consult"
        ]
    )

    static let creatorSprint = Journey(
        id: "journey_creator_sprint",
        title: "Creator Sprint (21 dagen)",
        subtitle: "Ship, collab en verdien je eerste euro.",
        iconSystemName: "wand.and.stars",
        accentColorHex: "#8B5CF6",
        durationDays: 21,
        focusDimensions: [.mind, .money, .adventure],
        stepItemIDs: [
            "creator_idea_bank",
            "creator_publish_weekly",
            "creator_collab",
            "creator_monetize",
            "money_portfolio",
            "money_networking"
        ]
    )

    static let communityGlow = Journey(
        id: "journey_community_glow",
        title: "Community Glow (14 dagen)",
        subtitle: "Van soloplayer naar iemand die samen dingen maakt.",
        iconSystemName: "person.3.sequence.fill",
        accentColorHex: "#0EA5E9",
        durationDays: 14,
        focusDimensions: [.love, .adventure],
        stepItemIDs: [
            "community_host",
            "community_volunteer",
            "community_club",
            "adv_memory_bank",
            "rel_repair_ritual"
        ]
    )

    static let adventureSeason = Journey(
        id: "journey_adventure_season",
        title: "Adventure Season (10 dagen)",
        subtitle: "Spontane XP-hits en verhalen voor later.",
        iconSystemName: "safari.fill",
        accentColorHex: "#F97316",
        durationDays: 10,
        focusDimensions: [.adventure, .love],
        stepItemIDs: [
            "passport_sunrise_mission",
            "passport_new_flavor",
            "passport_wildcard",
            "passport_24h_trip",
            "passport_memory_capture"
        ]
    )

    static let missionRunway = Journey(
        id: "journey_mission_runway",
        title: "Mission Runway (21 dagen)",
        subtitle: "Van chaos naar cruise-control output.",
        iconSystemName: "target",
        accentColorHex: "#0EA5E9",
        durationDays: 21,
        focusDimensions: [.mind, .money],
        stepItemIDs: [
            "mission_weekly_review",
            "mission_timeboxing",
            "mission_focus_room",
            "mission_12week",
            "mission_automation"
        ]
    )

    static let legacyArc = Journey(
        id: "journey_legacy_arc",
        title: "Legacy Arc (30 dagen)",
        subtitle: "Maak impact, leer iemand anders vliegen.",
        iconSystemName: "hand.heart.fill",
        accentColorHex: "#10B981",
        durationDays: 30,
        focusDimensions: [.love, .mind, .money],
        stepItemIDs: [
            "legacy_cause",
            "legacy_give",
            "legacy_mentor",
            "legacy_workshop",
            "legacy_story_archive"
        ]
    )

    static let luxuryReset = Journey(
        id: "journey_luxury_reset",
        title: "Luxury Calm Reset (14 dagen)",
        subtitle: "Rust, rituals en high-end selfcare.",
        iconSystemName: "sparkles.tv.fill",
        accentColorHex: "#A855F7",
        durationDays: 14,
        focusDimensions: [.mind, .love],
        stepItemIDs: [
            "calm_sleep_sanctuary",
            "calm_digital_sabbath",
            "calm_spa_day",
            "calm_beauty_ritual",
            "calm_retreat"
        ]
    )

    static let all: [Journey] = [
        breakupGlowUp,
        getTogether,
        softLife,
        wellnessReset,
        creatorSprint,
        communityGlow,
        adventureSeason,
        missionRunway,
        legacyArc,
        luxuryReset
    ]
}
