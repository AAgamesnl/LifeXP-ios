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

    static let healthRebuild = Journey(
        id: "journey_health_rebuild",
        title: "Health Rebuild (12 dagen)",
        subtitle: "Basis health kit + energie terugwinnen.",
        iconSystemName: "cross.case.fill",
        accentColorHex: "#0EA4BF",
        durationDays: 12,
        focusDimensions: [.mind],
        stepItemIDs: [
            "health_baseline_checks",
            "health_sleep_consistency",
            "health_steps_tracking",
            "health_meal_prep",
            "health_mobility_reset",
            "health_morning_light"
        ]
    )

    static let socialGlow = Journey(
        id: "journey_social_glow",
        title: "Social Glow-Up (10 dagen)",
        subtitle: "Meer verbinding, minder awkward.",
        iconSystemName: "person.3.sequence.fill",
        accentColorHex: "#F97316",
        durationDays: 10,
        focusDimensions: [.love, .adventure],
        stepItemIDs: [
            "social_coffee_chat",
            "social_micro_event",
            "community_host",
            "social_public_question",
            "social_followups",
            "social_feedback_round"
        ]
    )

    static let roomReset = Journey(
        id: "journey_room_reset",
        title: "7-Day Room Reset",
        subtitle: "Van troep naar ‘ik kan hier ademen’.",
        iconSystemName: "bed.double.fill",
        accentColorHex: "#22C55E",
        durationDays: 7,
        focusDimensions: [.mind],
        stepItemIDs: [
            "minimalism_drawer",
            "minimalism_digital_trash",
            "home_moodboard",
            "home_corner",
            "home_scent_light"
        ]
    )

    static let socialConfidenceSteps = Journey(
        id: "journey_social_confidence_micro",
        title: "10-Day Social Confidence Micro-Steps",
        subtitle: "Elke dag één mini social uitdaging.",
        iconSystemName: "person.crop.circle.badge.questionmark",
        accentColorHex: "#A855F7",
        durationDays: 10,
        focusDimensions: [.mind, .love],
        stepItemIDs: [
            "social_new_person",
            "social_boundary_check",
            "social_honest_cancel",
            "boundaries_no_excuse",
            "conflict_triggers"
        ]
    )

    static let moneyReset = Journey(
        id: "journey_money_reset_lite",
        title: "14-Day Money Reset Lite",
        subtitle: "Rustiger gevoel rond geld zonder hardcore budget.",
        iconSystemName: "eurosign.circle.fill",
        accentColorHex: "#22C55E",
        durationDays: 14,
        focusDimensions: [.money, .mind],
        stepItemIDs: [
            "money_screenshot",
            "money_leaks",
            "money_mini_savings",
            "moving_fixed_costs",
            "freelance_admin_folder"
        ]
    )

    static let digitalDeclutter = Journey(
        id: "journey_digital_declutter",
        title: "21-Day Digital Declutter",
        subtitle: "Van notificatiehel naar zelf de baas zijn.",
        iconSystemName: "iphone.gen3.slash",
        accentColorHex: "#8B5CF6",
        durationDays: 21,
        focusDimensions: [.mind],
        stepItemIDs: [
            "digital_homescreen",
            "digital_notifications",
            "digital_phone_free",
            "minimalism_digital_trash",
            "calm_radar"
        ]
    )

    static let softMorning = Journey(
        id: "journey_soft_morning",
        title: "30-Day Soft Morning Era",
        subtitle: "Kleine aanpassingen aan je ochtenden, geen 5AM cult.",
        iconSystemName: "sunrise.fill",
        accentColorHex: "#FDE047",
        durationDays: 30,
        focusDimensions: [.mind],
        stepItemIDs: [
            "sleep_goal",
            "sleep_wind_down",
            "sleep_bed_only",
            "calm_reset_ritual",
            "weekend_rest_block"
        ]
    )

    static let studyFocus = Journey(
        id: "journey_study_focus",
        title: "7-Day Study / Focus Sprint",
        subtitle: "Voor studenten of iedereen met één grote taak.",
        iconSystemName: "book.closed.fill",
        accentColorHex: "#3B82F6",
        durationDays: 7,
        focusDimensions: [.mind],
        stepItemIDs: [
            "student_syllabus_check",
            "student_study_spot",
            "calm_half_todos",
            "movement_ten_walk"
        ]
    )

    static let singleGlow = Journey(
        id: "journey_single_glow",
        title: "14-Day Single Glow-Up Journey",
        subtitle: "Zelfliefde, solo dates, loskomen van ‘ik moet iemand hebben’.",
        iconSystemName: "heart.text.square",
        accentColorHex: "#7C3AED",
        durationDays: 14,
        focusDimensions: [.mind, .adventure],
        stepItemIDs: [
            "single_solo_date",
            "single_vision",
            "single_detox",
            "compassion_rewrite",
            "creativity_micro_session"
        ]
    )

    static let coupleConnection = Journey(
        id: "journey_couple_connection",
        title: "10-Day Couple Connection Reset",
        subtitle: "Kleine acties om weer dichter bij elkaar te komen.",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#EF4444",
        durationDays: 10,
        focusDimensions: [.love, .mind],
        stepItemIDs: [
            "couple_budget_date",
            "couple_phonefree",
            "couple_try_new",
            "conflict_debrief",
            "conflict_sorry2"
        ]
    )

    static let familyBoundariesBoost = Journey(
        id: "journey_family_boundaries",
        title: "7-Day Family Boundaries Boost",
        subtitle: "Minder drained uit familie-situaties komen.",
        iconSystemName: "shield.lefthalf.fill",
        accentColorHex: "#0EA5E9",
        durationDays: 7,
        focusDimensions: [.love, .mind],
        stepItemIDs: [
            "family_red_flags",
            "family_soft_boundary",
            "family_step_back",
            "boundaries_script"
        ]
    )

    static let creatorKickoff = Journey(
        id: "journey_creator_kickoff",
        title: "21-Day Creator Kickoff",
        subtitle: "Van ‘ik wil ooit creëren’ naar echte public posts.",
        iconSystemName: "camera.fill",
        accentColorHex: "#F472B6",
        durationDays: 21,
        focusDimensions: [.adventure, .mind],
        stepItemIDs: [
            "creator_reasons",
            "creativity_idea_dump",
            "creator_first_post",
            "creator_content_ritual",
            "creativity_mini_launch",
            "freelance_value_prop"
        ]
    )

    static let calmerPhone = Journey(
        id: "journey_calmer_phone",
        title: "7 Days to a Calmer Phone",
        subtitle: "Elke dag één concrete digitale hygiëne-stap.",
        iconSystemName: "iphone.gen3.slash",
        accentColorHex: "#8B5CF6",
        durationDays: 7,
        focusDimensions: [.mind],
        stepItemIDs: [
            "digital_notifications",
            "digital_homescreen",
            "digital_phone_free",
            "calm_reset_ritual"
        ]
    )

    static let adventureBingo = Journey(
        id: "journey_adventure_bingo",
        title: "30-Day Adventure Bingo",
        subtitle: "Elke paar dagen een micro-avontuur.",
        iconSystemName: "figure.hiking",
        accentColorHex: "#0EA5E9",
        durationDays: 30,
        focusDimensions: [.adventure],
        stepItemIDs: [
            "micro_new_park",
            "micro_new_route",
            "micro_free_activity",
            "passport_wildcard",
            "passport_memory_capture"
        ]
    )

    static let friendshipUpgrade = Journey(
        id: "journey_friendship_upgrade",
        title: "14-Day Friendship Upgrade",
        subtitle: "Van oppervlakkig naar ‘dit zijn echt mijn mensen’.",
        iconSystemName: "person.3.fill",
        accentColorHex: "#EC4899",
        durationDays: 14,
        focusDimensions: [.love, .mind],
        stepItemIDs: [
            "friendship_top3",
            "friendship_quality_time",
            "friendship_checkin",
            "social_followups"
        ]
    )

    static let careerCheckIn = Journey(
        id: "journey_career_checkin",
        title: "10-Day Career Check-in & Direction",
        subtitle: "Waar sta je in je job en wat wil je met de komende jaren?",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        durationDays: 10,
        focusDimensions: [.money, .mind],
        stepItemIDs: [
            "career_goals_firstyear",
            "career_diary",
            "career_alternatives",
            "career_feedback",
            "meaning_activity"
        ]
    )

    static let homeFeelsYou = Journey(
        id: "journey_home_feels_you",
        title: "7-Day Home Feels Like You",
        subtitle: "Kleine acties waardoor je ruimte meer als jij voelt.",
        iconSystemName: "lamp.table.fill",
        accentColorHex: "#FDE047",
        durationDays: 7,
        focusDimensions: [.mind, .adventure],
        stepItemIDs: [
            "home_moodboard",
            "home_corner",
            "home_scent_light",
            "moving_housewarming"
        ]
    )

    static let selfCompassionJourney = Journey(
        id: "journey_self_compassion",
        title: "21-Day Self-Compassion Journey",
        subtitle: "Elke dag een kleine oefening naar zachter praten tegen jezelf.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#F43F5E",
        durationDays: 21,
        focusDimensions: [.mind],
        stepItemIDs: [
            "compassion_rewrite",
            "compassion_letter",
            "compassion_win_list",
            "calm_radar"
        ]
    )

    static let travelPrep = Journey(
        id: "journey_travel_prep",
        title: "10-Day Travel Prep",
        subtitle: "Praktische en emotionele voorbereiding voor je trip.",
        iconSystemName: "airplane.departure",
        accentColorHex: "#0EA5E9",
        durationDays: 10,
        focusDimensions: [.adventure, .money],
        stepItemIDs: [
            "money_screenshot",
            "moving_inventory",
            "passport_sunrise_mission",
            "micro_free_activity",
            "seasonal_goal"
        ]
    )

    static let postTripIntegration = Journey(
        id: "journey_post_trip",
        title: "14-Day Post-Trip Integration",
        subtitle: "Herinneringen bewaren en geld reality check.",
        iconSystemName: "photo.on.rectangle",
        accentColorHex: "#22C55E",
        durationDays: 14,
        focusDimensions: [.mind, .adventure],
        stepItemIDs: [
            "passport_memory_capture",
            "money_leaks",
            "adv_memory_bank",
            "seasonal_checkin"
        ]
    )

    static let newCityOrientation = Journey(
        id: "journey_new_city",
        title: "7-Day New City Orientation",
        subtitle: "Snel thuis voelen in een nieuwe stad of buurt.",
        iconSystemName: "mappin.and.ellipse",
        accentColorHex: "#22C55E",
        durationDays: 7,
        focusDimensions: [.adventure, .mind],
        stepItemIDs: [
            "newcity_mark_spots",
            "newcity_coffee_base",
            "newcity_walk",
            "micro_new_park"
        ]
    )

    static let movementFoundation = Journey(
        id: "journey_movement_foundation",
        title: "30-Day Movement Foundation",
        subtitle: "Dagelijkse mini-beweging zonder calorie-focus.",
        iconSystemName: "figure.walk.circle.fill",
        accentColorHex: "#10B981",
        durationDays: 30,
        focusDimensions: [.mind, .adventure],
        stepItemIDs: [
            "movement_ten_walk",
            "movement_daily_stretch",
            "movement_fun_activity",
            "wellness_move_daily"
        ]
    )

    static let gentleSleepReset = Journey(
        id: "journey_gentle_sleep",
        title: "14-Day Gentle Sleep Reset",
        subtitle: "Zachte rituelen en experimenten voor betere slaap.",
        iconSystemName: "moon.zzz.fill",
        accentColorHex: "#0EA4BF",
        durationDays: 14,
        focusDimensions: [.mind],
        stepItemIDs: [
            "sleep_goal",
            "sleep_wind_down",
            "sleep_bed_only",
            "calm_reset_ritual",
            "wellness_sleep_reset"
        ]
    )

    static let workLifeRebalance = Journey(
        id: "journey_work_life_rebalance",
        title: "10-Day Work–Life Rebalance",
        subtitle: "Werk minder alles-opslurpend maken.",
        iconSystemName: "rectangle.portrait.and.arrow.right",
        accentColorHex: "#60A5FA",
        durationDays: 10,
        focusDimensions: [.mind, .love],
        stepItemIDs: [
            "work_end_ritual",
            "work_notifications_limit",
            "work_evening_free",
            "weekend_rest_block",
            "calm_half_todos"
        ]
    )

    static let studentOverwhelm = Journey(
        id: "journey_student_overwhelm",
        title: "7-Day Student Overwhelm Reset",
        subtitle: "Chaos in to-do’s en energie recht trekken.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        durationDays: 7,
        focusDimensions: [.mind, .money],
        stepItemIDs: [
            "student_syllabus_check",
            "student_budget",
            "calm_half_todos",
            "sleep_wind_down"
        ]
    )

    static let sideHustleLaunch = Journey(
        id: "journey_side_hustle",
        title: "21-Day Side Hustle Launch",
        subtitle: "Van idee naar iets dat minstens één keer geld oplevert.",
        iconSystemName: "eurosign.circle.fill",
        accentColorHex: "#22C55E",
        durationDays: 21,
        focusDimensions: [.money, .adventure],
        stepItemIDs: [
            "freelance_value_prop",
            "freelance_first_euro",
            "freelance_admin_folder",
            "creator_content_ritual",
            "creator_first_post"
        ]
    )

    static let minimalismLite = Journey(
        id: "journey_minimalism_lite",
        title: "14-Day Minimalism Lite",
        subtitle: "Stap voor stap minder rommel.",
        iconSystemName: "trash.circle.fill",
        accentColorHex: "#F97316",
        durationDays: 14,
        focusDimensions: [.mind],
        stepItemIDs: [
            "minimalism_drawer",
            "minimalism_clothes_give",
            "minimalism_digital_trash",
            "seasonal_closet"
        ]
    )

    static let holidaySurvival = Journey(
        id: "journey_holiday_survival",
        title: "10-Day Holiday / December Survival",
        subtitle: "Grenzen, geld en energie beschermen rond feestdagen.",
        iconSystemName: "snowflake",
        accentColorHex: "#0EA5E9",
        durationDays: 10,
        focusDimensions: [.love, .mind],
        stepItemIDs: [
            "boundaries_script",
            "money_mini_savings",
            "family_step_back",
            "calm_reset_ritual"
        ]
    )

    static let breakupFirstAid = Journey(
        id: "journey_breakup_first_aid",
        title: "7-Day Breakup First Aid",
        subtitle: "Zacht traject voor de eerste periode na een break.",
        iconSystemName: "bandage.fill",
        accentColorHex: "#EC4899",
        durationDays: 7,
        focusDimensions: [.mind, .love],
        stepItemIDs: [
            "breakup_no_contact",
            "breakup_lessons",
            "compassion_letter",
            "single_detox"
        ]
    )

    static let relationshipCoreDeepDive = Journey(
        id: "journey_relationship_core",
        title: "21-Day Relationship Core Deep Dive",
        subtitle: "Investeren in waarden, geld en conflict skills.",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#FF3B6A",
        durationDays: 21,
        focusDimensions: [.love, .mind],
        stepItemIDs: [
            "rel_values_talk",
            "rel_geld_gesprek",
            "rel_conflict_clean",
            "conflict_debrief",
            "conflict_sorry2"
        ]
    )

    static let socialMediaSoftDetox = Journey(
        id: "journey_social_media_detox",
        title: "14-Day Social Media Soft Detox",
        subtitle: "Minder scherm, meer real-life momentjes.",
        iconSystemName: "wifi.slash",
        accentColorHex: "#8B5CF6",
        durationDays: 14,
        focusDimensions: [.mind],
        stepItemIDs: [
            "digital_notifications",
            "digital_phone_free",
            "creator_reasons",
            "glow_digital_detox",
            "digital_homescreen"
        ]
    )

    static let mainCharacterKickstart = Journey(
        id: "journey_main_character",
        title: "10-Day Main Character Kickstart",
        subtitle: "Micro-quests waardoor je leven meer jouw verhaal voelt.",
        iconSystemName: "sparkles",
        accentColorHex: "#7C3AED",
        durationDays: 10,
        focusDimensions: [.adventure, .mind],
        stepItemIDs: [
            "micro_free_activity",
            "movement_fun_activity",
            "creativity_mini_launch",
            "single_solo_date",
            "passport_memory_capture"
        ]
    )

    private static let baseJourneys: [Journey] = [
        breakupGlowUp,
        getTogether,
        softLife,
        wellnessReset,
        creatorSprint,
        communityGlow,
        adventureSeason,
        missionRunway,
        legacyArc,
        luxuryReset,
        healthRebuild,
        socialGlow,
        roomReset,
        socialConfidenceSteps,
        moneyReset,
        digitalDeclutter,
        softMorning,
        studyFocus,
        singleGlow,
        coupleConnection,
        familyBoundariesBoost,
        creatorKickoff,
        calmerPhone,
        adventureBingo,
        friendshipUpgrade,
        careerCheckIn,
        homeFeelsYou,
        selfCompassionJourney,
        travelPrep,
        postTripIntegration,
        newCityOrientation,
        movementFoundation,
        gentleSleepReset,
        workLifeRebalance,
        studentOverwhelm,
        sideHustleLaunch,
        minimalismLite,
        holidaySurvival,
        breakupFirstAid,
        relationshipCoreDeepDive,
        socialMediaSoftDetox,
        mainCharacterKickstart
    ]

    static let all: [Journey] = baseJourneys
}
