import Foundation

/// Static library of checklist packs used by the prototype.
enum PackLibrary {
    static let relationshipCore = CategoryPack(
        id: "relationship_core",
        title: "Relationship Core",
        subtitle: "From situationship to conscious relationship",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#FF3B6A",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "rel_values_talk",
                title: "Conversation about values & future",
                detail: "You have consciously talked at least once about money, children, housing and expectations for the future.",
                xp: 25,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_first_trip",
                title: "Survived first trip together",
                detail: "Been away together for a weekend or longer without wanting to kill each other.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_conflict_clean",
                title: "Conflict clean-up",
                detail: "After an argument, you really reflected, said sorry and made concrete agreements.",
                xp: 30,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "rel_geld_gesprek",
                title: "Money without drama",
                detail: "You had an honest conversation about debt, savings and spending without it escalating.",
                xp: 25,
                dimensions: [.love, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "rel_repair_ritual",
                title: "Monthly repair ritual",
                detail: "Scheduled an hour every month to adjust minor irritations, expectations and plans.",
                xp: 30,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_love_languages",
                title: "Love languages reality-check",
                detail: "You tested what each other's real love language is and how you can apply it every day.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_emergency_plan",
                title: "Emergency plan as a team",
                detail: "Who will you call in the event of a breakdown? How do you arrange care? There is a plan that provides peace in moments of crisis.",
                xp: 25,
                dimensions: [.love, .mind],
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
                detail: "You have maintained a morning or evening routine for at least 30 days in a row.",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_friend_check",
                title: "Friend audit",
                detail: "You have taken an honest look at which people really give you energy and which do not.",
                xp: 20,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_style_update",
                title: "Style refresh",
                detail: "You have consciously updated your clothing style to how you see yourself in your 'main character era'.",
                xp: 25,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_hard_thing",
                title: "One hard thing a day",
                detail: "You have done something you dreaded every day for at least 14 days in a row.",
                xp: 35,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_digital_detox",
                title: "Weekend digital detox",
                detail: "48 hours without doomscrolling, notifications off and time filled with real people or creation.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "glow_strength_routine",
                title: "Become stronger",
                detail: "Completed at least 10 strength workouts in 30 days with progress tracked.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_signature_scent",
                title: "Signature look & scent",
                detail: "You've found a signature look + scent that makes you feel powerful.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let breakupHealing = CategoryPack(
        id: "breakup_healing",
        title: "Breakup & Healing",
        subtitle: "From delulu to healed and glowing",
        iconSystemName: "bandage.fill",
        accentColorHex: "#EC4899",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "breakup_no_contact",
                title: "30 days no contact",
                detail: "You have not contacted your ex for 30 days (or secretly stalked them).",
                xp: 40,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_lessons",
                title: "3 lessons written down",
                detail: "You have honestly written down what you learned from the relationship and the breakup.",
                xp: 25,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_selfdate",
                title: "Solo 'ex-date' experience",
                detail: "You've done something you normally did together, but now alone – and you've made your own version of it.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_support_circle",
                title: "Support circle",
                detail: "You have appointed 3 people who you can call if you want to fall back and told them so.",
                xp: 18,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "breakup_new_story",
                title: "New narrative",
                detail: "You have written down who you are now without them and what values go with that.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let moneyCareer = CategoryPack(
        id: "money_career",
        title: "Money & Career",
        subtitle: "From chaos to 'I've got this'",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "money_buffer",
                title: "First savings buffer",
                detail: "You have at least one month of fixed costs set aside.",
                xp: 35,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_debt_overview",
                title: "Schuld reality check",
                detail: "You have collected all debts + interest in one place so that you can no longer look away.",
                xp: 25,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_raise",
                title: "Discussion about wages",
                detail: "At least once in your life you have initiated a conversation about a raise or better terms.",
                xp: 35,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "career_cv_update",
                title: "CV & LinkedIn on point",
                detail: "You've updated your resume and online profile to reflect who you are today.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_automation",
                title: "Automate the boring stuff",
                detail: "Fixed costs, savings and investments are automatically scheduled after each payday.",
                xp: 30,
                dimensions: [.money],
                isPremium: true
            ),
            ChecklistItem(
                id: "money_networking",
                title: "Value-first networking",
                detail: "You have built 3 warm connections by bringing something of value without asking.",
                xp: 22,
                dimensions: [.money, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_portfolio",
                title: "Portfolio snapshot",
                detail: "A simple portfolio or slide deck that proves your skills and is ready to share.",
                xp: 26,
                dimensions: [.money, .adventure],
                isPremium: true
            )
        ]
    )

    static let adulting = CategoryPack(
        id: "adulting_101",
        title: "Adulting 101",
        subtitle: "For everyone who says 'I'll deal with it later'",
        iconSystemName: "house.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "adult_insurances",
                title: "Basic insurance arranged",
                detail: "You know which insurance policies you have and what they are for (and you don't pay for duplicates).",
                xp: 30,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_admin_system",
                title: "Admin system",
                detail: "You have a simple system for storing documents, invoices and letters.",
                xp: 25,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_health_check",
                title: "Health check done",
                detail: "You have had a general health check done at least once (GP / dentist / blood test).",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "adult_emergency_contacts",
                title: "ICE list ready",
                detail: "There is a current ICE list with contacts, meds and allergies in your phone and home.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_meal_flow",
                title: "Meal flow",
                detail: "You have a rotation of 6 easy meals + shopping list that you can do without stress.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let adventure = CategoryPack(
        id: "adventure_memories",
        title: "Adventure & Memories",
        subtitle: "Collect main character moments",
        iconSystemName: "airplane.departure",
        accentColorHex: "#3B82F6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "adv_solo_trip",
                title: "Solo trip",
                detail: "You have traveled alone at least once (day trip or longer).",
                xp: 35,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "adv_night_out",
                title: "All nighter with friends",
                detail: "You had a night that you will tell people about for years to come.",
                xp: 25,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "adv_scary_thing",
                title: "Afraid but done",
                detail: "You did something that you were really afraid of, purely to grow.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "adv_memory_bank",
                title: "Memory bank",
                detail: "You have a photo album / note with 12 moments that you consciously captured this year.",
                xp: 18,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "adv_monthly_micro",
                title: "Monthly micro-adventure",
                detail: "Visited one new place every month in your own city or region.",
                xp: 24,
                dimensions: [.adventure],
                isPremium: true
            )
        ]
    )

    static let wellnessReset = CategoryPack(
        id: "wellness_reset",
        title: "Wellness Reset",
        subtitle: "Sleeping, breathing, boundaries and rest",
        iconSystemName: "leaf.fill",
        accentColorHex: "#10B981",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "wellness_sleep_reset",
                title: "Sleep reset week",
                detail: "Slept before midnight 7 nights in a row and screen-free 60 minutes before bed.",
                xp: 26,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "wellness_boundaries",
                title: "Boundary scripts",
                detail: "Practiced 3 sample statements for 'saying no' so that you have them ready.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "wellness_therapy_consult",
                title: "Therapy consult",
                detail: "Planned or done an intake with a therapist/coach to check your emotional baseline.",
                xp: 34,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "wellness_move_daily",
                title: "Move daily streak",
                detail: "At least 10,000 steps or 30 minutes of exercise for 21 days in a row.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let creatorLab = CategoryPack(
        id: "creator_lab",
        title: "Creator Lab",
        subtitle: "Make things, ship things, grow your reputation",
        iconSystemName: "wand.and.stars",
        accentColorHex: "#8B5CF6",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "creator_idea_bank",
                title: "Idea bank",
                detail: "A list of 30 content/side-project ideas that you can easily pick up.",
                xp: 22,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_publish_weekly",
                title: "Publish weekly",
                detail: "Published something (article, post, video, code, music) at least 4 weeks in a row.",
                xp: 32,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_collab",
                title: "Collab done",
                detail: "Made something together with someone else and put it live.",
                xp: 26,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_monetize",
                title: "First euro online",
                detail: "You earned your first euro online with something you made.",
                xp: 30,
                dimensions: [.money, .adventure],
                isPremium: true
            )
        ]
    )

    static let communityRoots = CategoryPack(
        id: "community_roots",
        title: "Community & Roots",
        subtitle: "Friends, neighborhood and things bigger than yourself",
        iconSystemName: "person.3.sequence.fill",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "community_host",
                title: "Hosted people",
                detail: "Organized a dinner/board game/movie evening for friends or neighbors.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "community_volunteer",
                title: "Give back",
                detail: "Have done or donated at least 4 hours of volunteer work that you support.",
                xp: 22,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "community_club",
                title: "Join a club",
                detail: "Affiliated with a club/association where you meet people every week.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "community_story",
                title: "Family archive",
                detail: "A recorded conversation with (grand)parents about their lives and what you want to keep.",
                xp: 28,
                dimensions: [.love, .mind],
                isPremium: true
            )
        ]
    )

    static let missionControl = CategoryPack(
        id: "mission_control",
        title: "Mission Control",
        subtitle: "Systems, focus and output at NASA level",
        iconSystemName: "target",
        accentColorHex: "#0EA5E9",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "mission_weekly_review",
                title: "Sunday reset + weekly review",
                detail: "45 minutes every Sunday: sync calendars, prioritize tasks, block time for deep work.",
                xp: 30,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_timeboxing",
                title: "Timeboxing master",
                detail: "At least 10 working days timeboxed in your calendar and 80% of your blocks achieved.",
                xp: 26,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_automation",
                title: "Automate the boring",
                detail: "3 recurring tasks automated (invoices, reminders, templates).",
                xp: 28,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mission_focus_room",
                title: "Focus room",
                detail: "Built a physical or digital work setup that immediately puts you in flow.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_12week",
                title: "12-week mission",
                detail: "A 12-week goal defined with 3 lead metrics and weekly check-ins.",
                xp: 34,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_recharge_day",
                title: "Deep recharge day",
                detail: "One day a month blocked for guilt-free recovery: sauna, massage, sleeping, offline.",
                xp: 22,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let adventurePassport = CategoryPack(
        id: "adventure_passport",
        title: "Adventure Passport",
        subtitle: "Micro-adventures that make your life epic",
        iconSystemName: "globe.americas.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "passport_sunrise_mission",
                title: "Sunrise mission",
                detail: "Up at 5:30 am, go to a high point and watch the sunrise with coffee.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_new_flavor",
                title: "New flavor night",
                detail: "Tasted food you've never had before – street food, regional cuisine or home-cooked.",
                xp: 16,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_24h_trip",
                title: "24h city hop",
                detail: "24 hours in another city with just a backpack and a must-do list.",
                xp: 30,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "passport_memory_capture",
                title: "Memory capture",
                detail: "A mini vlog or photo story made from a day and shared with 1 person.",
                xp: 14,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_wildcard",
                title: "Wildcard invite",
                detail: "You have invited someone for a spontaneous activity (climbing, museum, silent disco).",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_nature_reset",
                title: "Nature reset",
                detail: "At least 2 hours off-grid in nature with a journal or sketchbook.",
                xp: 24,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let legacyImpact = CategoryPack(
        id: "legacy_impact",
        title: "Legacy & Impact",
        subtitle: "Build something bigger than yourself",
        iconSystemName: "hand.heart.fill",
        accentColorHex: "#10B981",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "legacy_cause",
                title: "Pick a cause",
                detail: "Chosen one theme that you want to contribute to for 12 months (climate, youth, equality).",
                xp: 20,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "legacy_give",
                title: "Automate giving",
                detail: "Set up an automatic monthly contribution or block time for volunteer work.",
                xp: 24,
                dimensions: [.money, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_workshop",
                title: "Teach your craft",
                detail: "Delivered a workshop or online session about something you are good at.",
                xp: 26,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_mentor",
                title: "Mentor someone",
                detail: "Found a mentee and did at least 2 sessions with clear goals.",
                xp: 22,
                dimensions: [.love, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "legacy_story_archive",
                title: "Story archive",
                detail: "Created a family heirloom, community archive or audio story that will still exist later.",
                xp: 30,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_micro_fund",
                title: "Micro-fund",
                detail: "A mini budget set aside to sponsor ideas from friends or neighborhood.",
                xp: 18,
                dimensions: [.money, .love],
                isPremium: false
            )
        ]
    )

    static let luxuryCalm = CategoryPack(
        id: "luxury_calm",
        title: "Luxury Calm",
        subtitle: "High-end self-care that lifts you up by default",
        iconSystemName: "sparkles.tv.fill",
        accentColorHex: "#A855F7",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "calm_spa_day",
                title: "Spa + sauna day",
                detail: "Planned a half day with spa, sauna or hammam without telephone.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_sleep_sanctuary",
                title: "Sleep sanctuary",
                detail: "Your bedroom upgraded (light, scent, sheets) for elite sleep hygiene.",
                xp: 24,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_digital_sabbath",
                title: "Digital sabbath",
                detail: "A weekly day without social media and news, filled with analogue things.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_personal_chef",
                title: "Chef fashion dinner",
                detail: "Cooked a restaurant-level meal once a month or booked a chef at home.",
                xp: 26,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_retreat",
                title: "Silent retreat",
                detail: "Did a 1-3 day retreat for silence, breathwork or mindfulness.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_beauty_ritual",
                title: "Beauty ritual",
                detail: "Scheduled a skincare/grooming ritual that you continued for 21 days.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let healthKit = CategoryPack(
        id: "health_kit",
        title: "Health Kit",
        subtitle: "Core health basics for every player",
        iconSystemName: "cross.case.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "health_baseline_checks",
                title: "Baseline check-up",
                detail: "Blood tests, dentist and GP arranged in the past 12 months.",
                xp: 28,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_sleep_consistency",
                title: "Sleep consistency",
                detail: "Going to bed and getting up within the same 60-minute window for 14 days.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_steps_tracking",
                title: "7k steps streak",
                detail: "At least 7,000 steps per day, achieved for 10 days in a row.",
                xp: 22,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_meal_prep",
                title: "Meal prep ready",
                detail: "Prepared 3 healthy lunches or dinners per week for two weeks in a row.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_mobility_reset",
                title: "Mobility reset",
                detail: "10 minutes of mobility or stretching done on 10 different days.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_morning_light",
                title: "Morning sunlight",
                detail: "Caught outside daylight within 60 minutes of waking up 7 days in a row.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let socialConfidence = CategoryPack(
        id: "social_confidence",
        title: "Social Confidence",
        subtitle: "From awkward to present",
        iconSystemName: "person.3.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "social_coffee_chat",
                title: "2 coffee chats",
                detail: "Two people approached for a coffee to learn something new or connect.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_micro_event",
                title: "Host a micro-event",
                detail: "Four people brought together for a game night, dinner or walk.",
                xp: 24,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_public_question",
                title: "Ask the first question",
                detail: "Consciously ask or share the first question during an event or meeting.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_followups",
                title: "DM follow-ups",
                detail: "After an event, three people were sent a DM to maintain contact.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_feedback_round",
                title: "Feedback round",
                detail: "Asked three people for feedback about how you came across and what could be stronger.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let megaMomentum = CategoryPack(
        id: "mega_momentum",
        title: "Mega Momentum Pack",
        subtitle: "Ridiculously detailed challenges to upgrade every area",
        iconSystemName: "burst.fill",
        accentColorHex: "#FF6B00",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "mega_energy_audit",
                title: "Energy + attention audit",
                detail: "60 minutes of mapping all your daily stimuli and deciding per source: keep, cut, delegate or automate.",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_weekly_rhythm",
                title: "Weekly rhythm map",
                detail: "Created a visual map of your week with fixed focus blocks, recovery slots, social touchpoints and chore time.",
                xp: 26,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_skill_stack",
                title: "Skill stack refresh",
                detail: "Choose 3 skills that you want to stack in 90 days, plus micro-practices and measurement moments recorded.",
                xp: 32,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_body_baseline",
                title: "Body baseline",
                detail: "Sleep, nutrition, exercise and labs logged in one dashboard so you know your real baseline.",
                xp: 28,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_connection_squad",
                title: "Connection squad",
                detail: "A permanent group of 3-5 people put together with monthly meetups and a shared accountability thread.",
                xp: 24,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_risk_rep",
                title: "Risk Rep",
                detail: "Did something with calculated risk (investment, pitch, performance) and recorded lessons & SOP afterwards.",
                xp: 34,
                dimensions: [.adventure, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_inbox_zero",
                title: "Inbox zero protocol",
                detail: "One weekly protocol was drawn up for e-mail, DMs and to-dos and maintained for two weeks.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_personal_os",
                title: "Personal OS",
                detail: "Developed its own operating system with dashboards for goals, projects, habits and reflections.",
                xp: 36,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_rest_day",
                title: "Deliberate rest day",
                detail: "A full day without productivity, completely planned around recovery, play and slowness.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_reputation_loop",
                title: "Reputation loop",
                detail: "Consciously made 3 reputation moves: publish something, help someone, learn something and share.",
                xp: 30,
                dimensions: [.money, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_focus_retreat",
                title: "Solo focus retreat",
                detail: "Been away (or at home) for 48 hours with one clear deliverable and no notifications.",
                xp: 26,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_money_flow",
                title: "Money flow redesign",
                detail: "Cash flow, buffers and investments reorganized with automatic transfers and guardrails.",
                xp: 34,
                dimensions: [.money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_identity_script",
                title: "Identity script",
                detail: "A 1-pager written about who you are becoming, with proof steps and a ritual for reading it.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_mentor_circuit",
                title: "Mentor circuit",
                detail: "Two mentors approached + one peer chosen, monthly check-ins scheduled and expectations aligned.",
                xp: 28,
                dimensions: [.love, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_artifact_drop",
                title: "Artifact drop",
                detail: "Created one tangible or digital artifact that you have shared publicly (guide, mini-course, tool).",
                xp: 32,
                dimensions: [.adventure, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_legacy_note",
                title: "Legacy note",
                detail: "A letter written for your future self or someone important and kept in a safe place.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let studentSurvival = CategoryPack(
        id: "student_survival",
        title: "Student Survival",
        subtitle: "For everyone who tries not to drown in classes, deadlines and messy dorm rooms.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "student_syllabus_check",
                title: "Syllabus reality check",
                detail: "All subjects and important deadlines in one overview.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "student_study_spot",
                title: "Block spot chosen",
                detail: "Chosen a permanent place to study (home, library or coffee bar).",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "student_budget",
                title: "Kot budget created",
                detail: "Determined a weekly budget for food, going out and transportation.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let movingOut = CategoryPack(
        id: "moving_out_first_place",
        title: "Moving Out & First Place",
        subtitle: "From 'with parents' to 'own place, own rules'.",
        iconSystemName: "house.fill",
        accentColorHex: "#F59E0B",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "moving_inventory",
                title: "Basic inventory created",
                detail: "Drawn up a list of really necessary items.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "moving_fixed_costs",
                title: "Fixed costs calculated",
                detail: "Rent, energy, internet and insurance mapped out.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "moving_housewarming",
                title: "Mini housewarming",
                detail: "Organized a small evening with friends or family.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let newCity = CategoryPack(
        id: "new_city_starter",
        title: "New City Starter Pack",
        subtitle: "You live in a new city and don't want to feel lost.",
        iconSystemName: "mappin.and.ellipse",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "newcity_mark_spots",
                title: "Mark 3 spots",
                detail: "Supermarket, relaxation area and emergency pharmacy marked.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "newcity_coffee_base",
                title: "Coffee bar-found",
                detail: "Found a place where you feel comfortable alone.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "newcity_walk",
                title: "Neighborhood walk",
                detail: "Consciously explore your neighborhood without Google Maps.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let socialConfidenceBasics = CategoryPack(
        id: "social_confidence_basics_pack",
        title: "Social Confidence Basics",
        subtitle: "Less awkward in conversations without forcing yourself.",
        iconSystemName: "person.2.fill",
        accentColorHex: "#A855F7",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "social_new_person",
                title: "1 new person addressed",
                detail: "Small talk made in the shop, bar or work.",
                xp: 12,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_honest_cancel",
                title: "Honestly said 'I'm tired'",
                detail: "An appointment canceled without an excuse.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_boundary_check",
                title: "Boundaries check",
                detail: "Write down three situations in which you actually wanted to say 'no'.",
                xp: 14,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let deepFriendships = CategoryPack(
        id: "deep_friendships",
        title: "Deep Friendships",
        subtitle: "Not 100 superficial contacts but 3–5 people who really count.",
        iconSystemName: "person.3.fill",
        accentColorHex: "#EC4899",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "friendship_top3",
                title: "Top 3 people chosen",
                detail: "Chose the people you want to give more attention to.",
                xp: 10,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_quality_time",
                title: "Quality time gepland",
                detail: "A 1-on-1 moment planned without a telephone.",
                xp: 12,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_checkin",
                title: "Fair check-in",
                detail: "Someone asked how things are really going.",
                xp: 12,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let familyBoundaries = CategoryPack(
        id: "family_boundaries_peace",
        title: "Family Boundaries & Peace",
        subtitle: "For anyone with a family that is… complicated.",
        iconSystemName: "shield.lefthalf.fill",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "family_red_flags",
                title: "Red flags identified",
                detail: "Note what triggers you with family.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "family_soft_boundary",
                title: "1 soft border set",
                detail: "A small 'I'd rather not do that' uttered.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "family_step_back",
                title: "Get out of contact",
                detail: "Consciously do not let an argument explode via WhatsApp.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let singleEra = CategoryPack(
        id: "single_era_solo",
        title: "Single Era – Solo Life",
        subtitle: "Don't wait until you have 'someone'; this is your main character season.",
        iconSystemName: "person.fill.badge.plus",
        accentColorHex: "#7C3AED",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "single_solo_date",
                title: "Solo date planned",
                detail: "Cinema, coffee, museum or walk only scheduled.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "single_vision",
                title: "Vision without a partner",
                detail: "Written down what your life could be like if you were left alone.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "single_detox",
                title: "Social media detox from exes",
                detail: "Exes and situationships filtered from your feeds.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let careerStarter = CategoryPack(
        id: "career_starter",
        title: "Career Starter / First Job",
        subtitle: "For your first job/internship: less imposter, more peace.",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "career_goals_firstyear",
                title: "Job goals written out",
                detail: "Write down what you want to learn in your first year.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_feedback",
                title: "Feedback requested",
                detail: "Actively asked for honest feedback.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_commute_ritual",
                title: "Commute-routine",
                detail: "Standard music, podcast or ritual determined for on the road.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let careerPivot = CategoryPack(
        id: "career_pivot",
        title: "Career Pivot & Doubt",
        subtitle: "Question your job without staying on autopilot.",
        iconSystemName: "arrow.triangle.2.circlepath",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "career_diary",
                title: "Honest job diary",
                detail: "One week 3 bullets per day: energy givers and extractors.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_alternatives",
                title: "Explore alternatives",
                detail: "Selected three other professions or sectors.",
                xp: 14,
                dimensions: [.money, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_informational_chat",
                title: "1 conversation with someone who works differently",
                detail: "Arranged an informal call or coffee to learn.",
                xp: 16,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let freelanceFoundations = CategoryPack(
        id: "freelance_foundations",
        title: "Freelance & Side Hustle Foundations",
        subtitle: "For everyone who secretly prefers to do their own things.",
        iconSystemName: "eurosign.circle.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "freelance_value_prop",
                title: "Mini value prop written",
                detail: "In one sentence: what do you offer and for whom?",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "freelance_first_euro",
                title: "First € earned",
                detail: "Regardless of amount, paid work has been done at least once.",
                xp: 16,
                dimensions: [.money, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "freelance_admin_folder",
                title: "Basic administration folder created",
                detail: "Invoices and costs stored in a structured manner.",
                xp: 12,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let digitalHygiene = CategoryPack(
        id: "digital_hygiene",
        title: "Digital Hygiene & Detox",
        subtitle: "Less doom scrolling, less noise, more headspace.",
        iconSystemName: "iphone.gen3.slash",
        accentColorHex: "#8B5CF6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "digital_homescreen",
                title: "Homescreen clean-up",
                detail: "Created one page with only essentials.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "digital_notifications",
                title: "Notification killer",
                detail: "Push turned off for at least three apps.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "digital_phone_free",
                title: "Phone-free blok",
                detail: "Consciously went two hours without a phone.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let sleepRest = CategoryPack(
        id: "sleep_rest_foundations",
        title: "Sleep & Rest Foundations",
        subtitle: "No perfect 5 AM grind, just waking up less wrecked.",
        iconSystemName: "bed.double.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "sleep_goal",
                title: "Realistic sleep goal chosen",
                detail: "Number of hours determined that suits you.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "sleep_wind_down",
                title: "Wind-down signal",
                detail: "Fixed reminder or ritual set 30 minutes before bedtime.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "sleep_bed_only",
                title: "Bed only for sleeping",
                detail: "Didn't scroll in bed or work for a week.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let foodEnergy = CategoryPack(
        id: "food_energy",
        title: "Food & Energy",
        subtitle: "Not losing weight, but feeling better in your body.",
        iconSystemName: "fork.knife",
        accentColorHex: "#84CC16",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "food_mindful_meal",
                title: "Consciously eaten 1 meal",
                detail: "Without a screen and real tasting.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "food_energy_tracker",
                title: "Energy tracker",
                detail: "Keep track of which meals give you a crash for three days.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "food_new_meal",
                title: "Fun new meal tried",
                detail: "Tested a new recipe or cuisine.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let movementBody = CategoryPack(
        id: "movement_body_respect",
        title: "Movement & Body Respect Basics",
        subtitle: "Exercise as respect for your body without body shaming.",
        iconSystemName: "figure.walk",
        accentColorHex: "#10B981",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "movement_ten_walk",
                title: "10 minute walk",
                detail: "Took a 10-minute walk three days in a row.",
                xp: 10,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "movement_daily_stretch",
                title: "Stretch-moment",
                detail: "Stretched five minutes a day.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "movement_fun_activity",
                title: "1 active activity that doesn't feel like exercise",
                detail: "Did something active that was especially fun (dance, swimming, climbing).",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let creativityPassion = CategoryPack(
        id: "creativity_passion_projects",
        title: "Creativity & Passion Projects",
        subtitle: "For everyone who has ideas but never gets started.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F472B6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "creativity_idea_dump",
                title: "Idea dump",
                detail: "Everything you ever wanted to make written down.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creativity_micro_session",
                title: "1 micro session",
                detail: "Worked on one project for 15 minutes.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creativity_mini_launch",
                title: "Mini launch",
                detail: "Put something online, regardless of perfection.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let selfCompassion = CategoryPack(
        id: "self_compassion_voice",
        title: "Self-Compassion & Inner Voice",
        subtitle: "Less inner bully, more inner coach.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#F43F5E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "compassion_rewrite",
                title: "1 negative thought rewritten",
                detail: "A hard thought rewritten into something milder.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "compassion_letter",
                title: "Letter to yourself",
                detail: "A letter written as if to a good friend.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "compassion_win_list",
                title: "Win list",
                detail: "Listed ten things you did well in recent years.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let everydayCalm = CategoryPack(
        id: "everyday_calm",
        title: "Everyday Calm & Overwhelm",
        subtitle: "Not no stress, but a little less 'everything is too much'.",
        iconSystemName: "brain.head.profile",
        accentColorHex: "#38BDF8",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "calm_radar",
                title: "Overwhelm radar",
                detail: "Three stress level triggers recognized.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_reset_ritual",
                title: "Mini reset ritual",
                detail: "Breathing, short walk or music selected as reset.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_half_todos",
                title: "To-do's halved",
                detail: "Daily list halved to realistic level.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let lightMinimalism = CategoryPack(
        id: "light_minimalism",
        title: "Light Minimalism & De-Clutter",
        subtitle: "Less stuff, more breathing space.",
        iconSystemName: "trash.circle.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "minimalism_drawer",
                title: "1 drawer or shelf tidied up",
                detail: "Cleaned out an entire drawer or shelf.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "minimalism_clothes_give",
                title: "Giving away a pile of clothes",
                detail: "Gave away or donated at least five items.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "minimalism_digital_trash",
                title: "Digital trash can",
                detail: "Downloads and screenshots cleaned up.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let homeVibes = CategoryPack(
        id: "home_vibes_nesting",
        title: "Home Vibes & Nesting",
        subtitle: "Your place finally feels like you.",
        iconSystemName: "lamp.table.fill",
        accentColorHex: "#FDE047",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "home_moodboard",
                title: "Created a mood board",
                detail: "An album or Pinterest board created for your space.",
                xp: 10,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "home_corner",
                title: "1 corner finished",
                detail: "A corner finished with something small that creates atmosphere.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "home_scent_light",
                title: "Odor & light check",
                detail: "Conscious choice made for light or candles.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let microAdventures = CategoryPack(
        id: "micro_adventures",
        title: "Micro-Adventures & Local Exploration",
        subtitle: "Main character moments without an airplane.",
        iconSystemName: "figure.hiking",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "micro_new_park",
                title: "Tried a new park or walk",
                detail: "Visited an unknown park or trail.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "micro_new_route",
                title: "Different route to work or school",
                detail: "Consciously took a different route.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "micro_free_activity",
                title: "Low budget activity done",
                detail: "Find and do a free or cheap activity in your city.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let moneyResetLite = CategoryPack(
        id: "money_reset_lite",
        title: "Money Reset Lite",
        subtitle: "Less chaos without becoming an influencer.",
        iconSystemName: "eurosign.arrow.circlepath",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "money_screenshot",
                title: "Money screenshot",
                detail: "Bank balances and debts looked at honestly.",
                xp: 10,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_leaks",
                title: "Top 3 money leaks",
                detail: "Money leaks written down and one addressed.",
                xp: 12,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_mini_savings",
                title: "Mini piggy bank",
                detail: "Automatic savings order set, even if it is €10.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let coupleDates = CategoryPack(
        id: "couple_dates",
        title: "Couple Dates & Shared Memories",
        subtitle: "From Netflix and telephone to real memories.",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#EF4444",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "couple_budget_date",
                title: "Low budget date",
                detail: "A budget-friendly date thought up and done.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "couple_phonefree",
                title: "Phone-free date",
                detail: "An evening together without a telephone.",
                xp: 10,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "couple_try_new",
                title: "Tried something new together",
                detail: "Tested a new game, activity or restaurant.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let conflictSkills = CategoryPack(
        id: "conflict_skills_repair",
        title: "Conflict Skills & Repair",
        subtitle: "Not less arguing, but better arguing.",
        iconSystemName: "hands.sparkles.fill",
        accentColorHex: "#14B8A6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "conflict_triggers",
                title: "Identify your own triggers",
                detail: "Write down what affects you in conflicts.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "conflict_debrief",
                title: "Conflict ge-debriefed",
                detail: "Debriefed together afterwards.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "conflict_sorry2",
                title: "Sorry 2.0",
                detail: "Genuine sorry expressed with behavior, feeling and agreement.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let boundariesPack = CategoryPack(
        id: "boundaries_saying_no",
        title: "Boundaries & Saying No",
        subtitle: "For the people pleasers.",
        iconSystemName: "hand.raised.fill",
        accentColorHex: "#A855F7",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "boundaries_no_excuse",
                title: "1 said 'no'",
                detail: "A no said without a thousand excuses.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "boundaries_script",
                title: "Boundary script written",
                detail: "Come up with a sentence that you can use.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "boundaries_energy_vamp",
                title: "Energy sucker not promised",
                detail: "Consciously not promised for a moment.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let meaningValues = CategoryPack(
        id: "meaning_values",
        title: "Meaning & Values",
        subtitle: "When you don't know where your life is going.",
        iconSystemName: "sparkle.magnifyingglass",
        accentColorHex: "#6366F1",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "meaning_top_values",
                title: "Top 5 values chosen",
                detail: "Made a list of your five most important values.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "meaning_activity",
                title: "1 activity chosen",
                detail: "Chose an activity that supports two values.",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "meaning_good_year",
                title: "What does a good year look like?",
                detail: "Honestly wrote down what a good year looks like for you.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let weekendUpgrade = CategoryPack(
        id: "weekend_upgrade",
        title: "Weekend Upgrade Pack",
        subtitle: "Every weekend just 10% better than 'scrolling and eating'.",
        iconSystemName: "calendar.badge.clock",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "weekend_memorable",
                title: "Weekend activity planned",
                detail: "Plan something that you will remember later.",
                xp: 12,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "weekend_life_admin",
                title: "1 hour life admin",
                detail: "An hour blocked for email, papers and planning.",
                xp: 10,
                dimensions: [.mind, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "weekend_rest_block",
                title: "Conscious rest block",
                detail: "A block in which nothing was required but was chosen.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let seasonalReset = CategoryPack(
        id: "seasonal_reset",
        title: "Seasonal Reset",
        subtitle: "Small seasonal ritual so that the year does not slip away.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "seasonal_checkin",
                title: "Season check-in",
                detail: "Note what you leave behind and what you take with you.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "seasonal_closet",
                title: "Clothing season change",
                detail: "Changed clothes and gave away what no longer fit.",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "seasonal_goal",
                title: "1 season goal chosen",
                detail: "Chosen a very small goal for the new season.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let healthAdmin = CategoryPack(
        id: "health_admin",
        title: "Health Admin & Self Check-ins",
        subtitle: "Postponed doctor and dentist things without advice.",
        iconSystemName: "cross.case.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "health_make_appointment",
                title: "Appointment effectively made",
                detail: "Scheduled a dentist or GP appointment.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_med_overview",
                title: "Medication overview",
                detail: "Overview made of medication and supplements (without advice).",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_questions_list",
                title: "Questionnaire for check-up",
                detail: "Questions noted for your next consultation.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let workLifeBoundaries = CategoryPack(
        id: "work_life_boundaries",
        title: "Work–Life Boundaries",
        subtitle: "For everyone who still reads emails in the evening.",
        iconSystemName: "rectangle.portrait.and.arrow.right",
        accentColorHex: "#60A5FA",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "work_end_ritual",
                title: "Hard end of workday",
                detail: "An hour and ritual chosen to conclude.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "work_notifications_limit",
                title: "Work apps limited",
                detail: "Notifications outside working hours limited.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "work_evening_free",
                title: "Work-free evening",
                detail: "Planned one evening a week completely work-free.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let creatorSocialStarter = CategoryPack(
        id: "creator_social_starter",
        title: "Creator & Social Media Starter",
        subtitle: "For those who want to post or create but are blocked.",
        iconSystemName: "camera.fill",
        accentColorHex: "#F472B6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "creator_reasons",
                title: "Why do I want to create?",
                detail: "Three reasons written down why you want to create or post.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_first_post",
                title: "1 imperfect post",
                detail: "A post put online without perfectionism.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_content_ritual",
                title: "Content ritual",
                detail: "Chose a fixed moment per week to make it.",
                xp: 12,
                dimensions: [.mind, .money],
                isPremium: false
            )
        ]
    )

    static let lifeChecklist = CategoryPack(
        id: "life_checklist_classic",
        title: "Life Checklist",
        subtitle: "From birth to bucket list moments",
        iconSystemName: "checkmark.circle.fill",
        accentColorHex: "#2563EB",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "life_be_born",
                title: "Being born",
                detail: "Welcome to the planet: your first XP has arrived.",
                xp: 5,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_steps",
                title: "First steps",
                detail: "Those wobbly meters that open up the world.",
                xp: 6,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_words",
                title: "First words",
                detail: "Your first words shared with your world.",
                xp: 6,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_learn_read",
                title: "Learning to read",
                detail: "Books and boards unlocked.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_make_friend",
                title: "First friend made",
                detail: "Found your first real friend.",
                xp: 10,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_ride_bike",
                title: "Learning to ride a bike",
                detail: "Achieved balance, freedom and scratches.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_read_book",
                title: "Finished first book",
                detail: "A complete book read by your own choice.",
                xp: 8,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_learn_swim",
                title: "Learn to swim",
                detail: "Your first laps without flotation devices.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_finish_elementary",
                title: "Completed primary school",
                detail: "Completed your primary school years.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_play_sport",
                title: "Played team sports",
                detail: "Participated in a sports team or club.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_fly_plane",
                title: "Flew for the first time",
                detail: "Your first time in the air.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_ride_boat",
                title: "Made a boat trip",
                detail: "Made a trip on the water.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_train_trip",
                title: "Made a train trip",
                detail: "Reached a destination by train.",
                xp: 8,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_helicopter",
                title: "Experienced a helicopter flight",
                detail: "Experienced a flight with a view from a helicopter.",
                xp: 18,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_see_ocean",
                title: "Seen the ocean",
                detail: "Saw and smelled the sea for the first time.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_see_snow",
                title: "Snow polite",
                detail: "Experienced snow in real life.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_make_snowman",
                title: "Snowman built",
                detail: "Built your own snowman.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_finish_middle",
                title: "Completed secondary education",
                detail: "Completed your junior high school education.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_concert",
                title: "Went to a concert",
                detail: "Experience live music with volume and vibes.",
                xp: 14,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_camping",
                title: "Camping overnight",
                detail: "Slept a night in a tent or under the stars.",
                xp: 14,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_rollercoaster",
                title: "Rollercoaster ride",
                detail: "Survived a roller coaster and maybe screamed.",
                xp: 14,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_play_instrument",
                title: "Learn to play an instrument",
                detail: "Learning to play and perform an instrument.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_kiss",
                title: "Had first kiss",
                detail: "Had your first kiss.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_credit_card",
                title: "First credit card arranged",
                detail: "Applied for or received your first credit card.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_start_driving",
                title: "Started driving",
                detail: "Your first kilometers driven behind the wheel.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_roadtrip",
                title: "Road trip ridden",
                detail: "A trip planned and driven with stops and stories.",
                xp: 18,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_new_country",
                title: "Visited a new country",
                detail: "Crossed a border and discovered a new country.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_public_speech",
                title: "Speech given in front of an audience",
                detail: "Speaking in front of an audience without running away.",
                xp: 18,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_graduate_highschool",
                title: "Received a high school diploma",
                detail: "Your high school diploma in hands.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_second_language",
                title: "Learned a second language",
                detail: "Learned a new language and used it in conversation.",
                xp: 22,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_invest_money",
                title: "First investment made",
                detail: "Your first money invested or invested.",
                xp: 24,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_meet_idol",
                title: "Idol meets",
                detail: "Meet someone you admire.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_big_mistake",
                title: "Made a big mistake and learned",
                detail: "Made a big mistake and learned from it.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_win_trophy",
                title: "Won a prize or trophy",
                detail: "Won a prize or trophy.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_climb_mountain",
                title: "Reached mountain top",
                detail: "Reached a summit that made your heart beat.",
                xp: 24,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_run_marathon",
                title: "Completed marathon",
                detail: "Completed 42 km and reached the finish.",
                xp: 28,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_learn_cook",
                title: "Learn to cook yourself",
                detail: "A meal independently cooked that someone else liked.",
                xp: 14,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_explore_cave",
                title: "Cave discovered",
                detail: "Experienced an underground adventure in a cave.",
                xp: 22,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_see_volcano",
                title: "Volcano seen up close",
                detail: "A volcano seen up close.",
                xp: 22,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_graduate_college",
                title: "Obtained a HBO/uni diploma",
                detail: "Obtained an HBO/uni diploma.",
                xp: 26,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_long_relationship",
                title: "Relationship longer than a year",
                detail: "Maintain a relationship for at least 1 year.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_dumped",
                title: "Experiencing a break-up",
                detail: "Going through and processing a break-up.",
                xp: 18,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_sign_contract",
                title: "First major contract signed",
                detail: "Signed your first major contract.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_job",
                title: "First job started",
                detail: "Started your first job or paid gig.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_promoted",
                title: "Got a promotion",
                detail: "Received a promotion or step up.",
                xp: 22,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_first_paycheck",
                title: "Receiving first salary",
                detail: "Receive and use your first salary.",
                xp: 18,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_fired",
                title: "Experiencing dismissal",
                detail: "Experienced dismissal and started again.",
                xp: 18,
                dimensions: [.mind, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_in_news",
                title: "Appeared in the news",
                detail: "Mentioned or appearing in media.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_vote",
                title: "Voted in election",
                detail: "Voted in a local or national election.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_switch_careers",
                title: "Career switched",
                detail: "Changed direction and started again.",
                xp: 22,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_buy_house",
                title: "Bought my own house",
                detail: "Bought a house or arranged a mortgage.",
                xp: 26,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_engaged",
                title: "Got engaged",
                detail: "Got engaged and celebrated.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_married",
                title: "Married",
                detail: "Said yes during your wedding.",
                xp: 28,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_have_kid",
                title: "Had first child",
                detail: "Became a parent of your first child.",
                xp: 28,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_teach_walk",
                title: "Teaching your child to walk",
                detail: "Practiced the first steps together.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_teach_talk",
                title: "Teaching your child to talk",
                detail: "Accompanied by your child's first words.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_watch_kid_graduate",
                title: "Your child's graduation ceremony",
                detail: "Been present at your child's graduation.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_watch_kid_marry",
                title: "Experienced your child's wedding",
                detail: "Seeing your child say yes.",
                xp: 26,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_grandparent",
                title: "Became a grandparent",
                detail: "Grandchildren welcomed into the family.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_retire",
                title: "Retired",
                detail: "Stopped full-time work and chose a new rhythm.",
                xp: 22,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_tell_story",
                title: "Family story retold",
                detail: "A story shared that will stay with the family.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_solar_eclipse",
                title: "Solar eclipse seen",
                detail: "Consciously experienced a solar eclipse.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_plant_garden",
                title: "Own garden",
                detail: "Planted something yourself and watched it grow.",
                xp: 16,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_travel_world",
                title: "Traveled around the world",
                detail: "Visited several continents and collected stories.",
                xp: 30,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_turn_100",
                title: "Celebrated 100th anniversary",
                detail: "Celebrating a century of life.",
                xp: 40,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_complete_checklist",
                title: "Life Checklist voltooid",
                detail: "All milestones in this list checked off.",
                xp: 50,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let energyReset = CategoryPack(
        id: "energy_reset",
        title: "Energy Reset",
        subtitle: "From drained to charged days.",
        iconSystemName: "bolt.heart.fill",
        accentColorHex: "#22D3EE",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "energy_sleep",
                title: "7 nights sleep commitment",
                detail: "Slept 7-9 hours for a week with consistent bedtimes.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_walk",
                title: "Daily sunlight walk",
                detail: "Walked outside for 20 minutes 5 days in a row.",
                xp: 18,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_meal_prep",
                title: "Meal prep mini",
                detail: "Two energy-friendly meals prepared for busy days.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_afspraken",
                title: "Rest blocks planned",
                detail: "Consciously planned and complied with 3 recovery moments.",
                xp: 16,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "energy_caffeine",
                title: "Caffeine reset",
                detail: "A week after 2 p.m., no more caffeine and an energy dip logged.",
                xp: 20,
                dimensions: [.mind],
                isPremium: true
            )
        ]
    )

    static let creatorMode = CategoryPack(
        id: "creator_mode",
        title: "Creator Mode",
        subtitle: "From idea to shipping without perfectionism.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F59E0B",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "creator_daily_output",
                title: "10 day shipping streak",
                detail: "Shared something small for 10 days in a row: post, prototype or snippet.",
                xp: 30,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_feedback_loop",
                title: "Feedback loop",
                detail: "At least 3 people were asked for specific feedback and processed.",
                xp: 22,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_system",
                title: "Creator system set up",
                detail: "A repetitive time slot, templating or automation enabled to keep posting.",
                xp: 18,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_portfolio",
                title: "Mini portfolio online",
                detail: "A simple landing page or highlight reel put live.",
                xp: 26,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_collab",
                title: "Collab done",
                detail: "Created and shared something together with someone else.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let friendshipCare = CategoryPack(
        id: "friendship_care",
        title: "Friendship Care",
        subtitle: "From individual apps to real support crew.",
        iconSystemName: "hands.sparkles.fill",
        accentColorHex: "#16A34A",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "friendship_checkin",
                title: "3 check-ins",
                detail: "Actively called or spoke to three friends outside of social media.",
                xp: 14,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_memory",
                title: "New shared memory",
                detail: "An activity done and recorded as an inside joke or photo.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_help",
                title: "Helping without expecting anything in return",
                detail: "Consciously giving help or time without expecting anything in return.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_hard_talk",
                title: "Had an honest conversation",
                detail: "A difficult subject discussed without ducking away.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "friendship_followthrough",
                title: "Appointment kept",
                detail: "A plan that you initiated actually goes ahead.",
                xp: 12,
                dimensions: [.love],
                isPremium: false
            )
        ]
    )

    static let calmFocus = CategoryPack(
        id: "calm_focus",
        title: "Calm Focus",
        subtitle: "From chaos to clear days.",
        iconSystemName: "target",
        accentColorHex: "#EF4444",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "focus_daily_plan",
                title: "Start the day with intention",
                detail: "Started 5 days with a top 3 and evaluated it.",
                xp: 18,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "focus_deep_work",
                title: "3 deep work blocks",
                detail: "Completed three 90-minute sessions without distractions.",
                xp: 24,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "focus_inbox_zero",
                title: "Inbox reset",
                detail: "Inbox or to-do list cleaned and organized.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "focus_boundaries",
                title: "Context switch kill-switch",
                detail: "Notifications limited and focus modes set for work/life.",
                xp: 20,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "focus_review",
                title: "Weekreview",
                detail: "Took one hour to record wins, learning curve and next moves.",
                xp: 18,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    private static let basePacks: [CategoryPack] = [
        lifeChecklist,
        relationshipCore,
        glowUp,
        breakupHealing,
        moneyCareer,
        adulting,
        adventure,
        wellnessReset,
        creatorLab,
        communityRoots,
        missionControl,
        adventurePassport,
        legacyImpact,
        luxuryCalm,
        megaMomentum,
        healthKit,
        socialConfidence,
        energyReset,
        studentSurvival,
        movingOut,
        newCity,
        socialConfidenceBasics,
        deepFriendships,
        friendshipCare,
        familyBoundaries,
        singleEra,
        careerStarter,
        careerPivot,
        freelanceFoundations,
        digitalHygiene,
        calmFocus,
        sleepRest,
        foodEnergy,
        movementBody,
        creativityPassion,
        selfCompassion,
        everydayCalm,
        lightMinimalism,
        homeVibes,
        microAdventures,
        creatorMode,
        moneyResetLite,
        coupleDates,
        conflictSkills,
        boundariesPack,
        meaningValues,
        weekendUpgrade,
        seasonalReset,
        healthAdmin,
        workLifeBoundaries,
        creatorSocialStarter
    ]

    static let all: [CategoryPack] = basePacks

    /// Items that should be hidden when the user enables safe mode.
    static let heavyItemIDs: Set<String> = [
        "breakup_no_contact",
        "breakup_lessons",
        "breakup_selfdate",
        "adult_health_check",
        "wellness_therapy_consult",
        "glow_hard_thing",
        "money_side_project"
    ]
}
