import Foundation

/// Curated Arc catalog with chapters and quests.
enum ArcLibrary {
    // MARK: - Heart Repair
    static let heartRepair = Arc(
        id: "arc_heart_repair",
        title: "Heart Repair",
        subtitle: "Heartbreak is heavy. We'll steady you and reopen softly.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#EC4899",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_heart_repair_foundation",
                title: "Stabilize",
                summary: "Close the loops, find calm breaths, remind yourself you're safe.",
                quests: [
                    Quest(id: "heart_no_contact", title: "Gentle No-Contact", detail: "Unfollow, mute, or archive triggers for 14 days. You don't need to check.", kind: .choice, xp: 25, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "heart_support_check", title: "Anchor People", detail: "Write down three people who feel safe and plan one check-in.", kind: .reflection, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 12),
                    Quest(id: "heart_body_reset", title: "Body Reset", detail: "Sleep, eat, and a 20-minute walk count as wins today.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "heart_emergency_script", title: "SOS Script", detail: "Write three lines you can tell yourself when the urge to text hits.", kind: .reflection, xp: 16, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_story",
                title: "Story Rewrite",
                summary: "Let the hurt speak, then claim a new story that centers you.",
                quests: [
                    Quest(id: "heart_trigger_map", title: "Trigger Map", detail: "Write down five moments that hurt and one gentle response for each.", kind: .reflection, xp: 25, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "heart_reframe", title: "Reframe Ritual", detail: "Write five new beliefs about yourself after this breakup.", kind: .reflection, xp: 30, dimensions: [.mind, .love], estimatedMinutes: 18),
                    Quest(id: "heart_selfdate", title: "Solo Self-Date", detail: "Plan a mini outing that's just for you, no distractions.", kind: .action, xp: 35, dimensions: [.love, .adventure], estimatedMinutes: 60),
                    Quest(id: "heart_voice_memo", title: "Voice Memo", detail: "Record two minutes talking to yourself like your best friend.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 5)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_future",
                title: "Future Ready",
                summary: "Rebuild trust step by step, with clear boundaries and hope.",
                quests: [
                    Quest(id: "heart_boundaries", title: "Boundary Script", detail: "Write two boundary scripts for dating that you can repeat.", kind: .action, xp: 30, dimensions: [.love], estimatedMinutes: 14),
                    Quest(id: "heart_greenflags", title: "Green Flags", detail: "List five green flags and three red flags to make choices lighter.", kind: .choice, xp: 20, dimensions: [.mind, .love], estimatedMinutes: 12),
                    Quest(id: "heart_connection_lab", title: "Connection Lab", detail: "Host a mini gathering with trusted people to warm up again.", kind: .action, xp: 40, dimensions: [.love, .adventure], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Money Reset
    static let moneyReset = Arc(
        id: "arc_money_reset",
        title: "Money Reset",
        subtitle: "No more avoidance. Clear numbers, calm mind, next moves.",
        iconSystemName: "creditcard.fill",
        accentColorHex: "#10B981",
        focusDimensions: [.money, .mind],
        chapters: [
            Chapter(
                id: "arc_money_reset_truth",
                title: "Face The Numbers",
                summary: "Be honest without shame. You can only steer what you can see.",
                quests: [
                    Quest(id: "money_snapshot", title: "Money Snapshot", detail: "Write balances, debts, and fixed costs in one place.", kind: .reflection, xp: 25, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_rules", title: "Three Money Rules", detail: "Define three simple rules (e.g., no delivery on weekdays).", kind: .choice, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 10),
                    Quest(id: "money_safe_place", title: "Buffer Start", detail: "Set aside a small emergency buffer, even if it's symbolic.", kind: .action, xp: 30, dimensions: [.money], estimatedMinutes: 12),
                    Quest(id: "money_emotion", title: "Money Feel Check", detail: "Write five lines about how money makes you feel, without judgment.", kind: .reflection, xp: 14, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_money_reset_systems",
                title: "Systems On",
                summary: "Automate the basics so your head has room for growth.",
                quests: [
                    Quest(id: "money_autopay", title: "Autopay Essentials", detail: "Automate rent and utilities so it's set once and done.", kind: .action, xp: 35, dimensions: [.money], estimatedMinutes: 30),
                    Quest(id: "money_budget", title: "Intentional Budget", detail: "Create four buckets: needs, fun, growth, buffer with rough amounts.", kind: .choice, xp: 25, dimensions: [.money], estimatedMinutes: 25),
                    Quest(id: "money_income", title: "Income Move", detail: "Pitch one freelance task or ask for a 1:1 on salary.", kind: .action, xp: 40, dimensions: [.money, .mind], estimatedMinutes: 35),
                    Quest(id: "money_cancel", title: "Subscription Audit", detail: "Cut two recurring costs or switch to a cheaper alternative.", kind: .action, xp: 18, dimensions: [.money], estimatedMinutes: 20)
                ]
            ),
            Chapter(
                id: "arc_money_reset_growth",
                title: "Grow + Protect",
                summary: "Stack small wins and protect yourself from stress and surprises.",
                quests: [
                    Quest(id: "money_insurance", title: "Cover The Basics", detail: "Check health and liability coverage. Fix any gaps.", kind: .action, xp: 20, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_invest_intro", title: "Invest Intro", detail: "Read 15 minutes on index fund basics and note two questions.", kind: .reflection, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 15),
                    Quest(id: "money_monthly_review", title: "Monthly Review", detail: "Schedule a moment for numbers and feelings, then note three actions.", kind: .reflection, xp: 25, dimensions: [.money, .mind], estimatedMinutes: 20),
                    Quest(id: "money_riskplan", title: "Emergency Playbook", detail: "Write what you'll do if income drops or surprise costs hit.", kind: .choice, xp: 24, dimensions: [.money, .mind], estimatedMinutes: 16)
                ]
            )
        ]
    )

    // MARK: - Calm Mind
    static let calmMind = Arc(
        id: "arc_calm_mind",
        title: "Calm Mind",
        subtitle: "From scattered to grounded focus, without rigid rules.",
        iconSystemName: "wind.snow",
        accentColorHex: "#6366F1",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_calm_mind_reset",
                title: "Reset",
                summary: "Clear mental tabs, calm your body, feel space again.",
                quests: [
                    Quest(id: "calm_brain_dump", title: "Brain Dump", detail: "Write everything in your head for 10 minutes, unfiltered.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_body", title: "Body Signal", detail: "Five minutes of box breathing and stretching to drop the tension.", kind: .action, xp: 15, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_digital", title: "Digital Pause", detail: "Set 30 minutes of do-not-disturb and park notifications on purpose.", kind: .choice, xp: 15, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "calm_sleep_plan", title: "Sleep Boundaries", detail: "Pick a sleep ritual and screen curfew for three nights.", kind: .choice, xp: 22, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_focus",
                title: "Focus",
                summary: "Stop multitasking, start finishing with realistic blocks.",
                quests: [
                    Quest(id: "calm_single_task", title: "One Thing", detail: "Choose one task that matters today and define what done means.", kind: .choice, xp: 20, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_focus_room", title: "Focus Space", detail: "Reset your workspace or pick a cafe where you can truly land.", kind: .action, xp: 25, dimensions: [.mind, .adventure], estimatedMinutes: 25),
                    Quest(id: "calm_timer", title: "Three Pomodoros", detail: "Do three 25-minute sprints with five-minute breaks.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "calm_context", title: "Context Switching", detail: "Note your top five distractions and one fix for each.", kind: .reflection, xp: 18, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_play",
                title: "Play",
                summary: "Light dopamine, no guilt. Your brain needs this.",
                quests: [
                    Quest(id: "calm_micro_adventure", title: "Micro Adventure", detail: "One hour in a new spot with no agenda, just curiosity.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 75),
                    Quest(id: "calm_friend_ping", title: "Friend Ping", detail: "Plan coffee with someone who makes you laugh or feel grounded.", kind: .action, xp: 20, dimensions: [.love, .adventure], estimatedMinutes: 20),
                    Quest(id: "calm_wins", title: "Capture Wins", detail: "Write down five recent wins, however small, and feel them.", kind: .reflection, xp: 15, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_sensory", title: "Sensory Reset", detail: "5-4-3-2-1 practice: name five things you see down to one you taste.", kind: .action, xp: 16, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Creator Ignition
    static let creatorIgnition = Arc(
        id: "arc_creator_ignition",
        title: "Creator Ignition",
        subtitle: "Ship more than you scroll. Make signals people feel.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F59E0B",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_creator_ignition_seed",
                title: "Spark",
                summary: "Collect ideas and lower the barrier to start.",
                quests: [
                    Quest(id: "creator_swipe_file", title: "Swipe File", detail: "Start a note with 10 ideas and references that spark you.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "creator_setup", title: "Create Setup", detail: "Set up one simple tool (Notes/Notion) with a template so you can begin.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_timebox", title: "90-Minute Sprint", detail: "Timebox 90 minutes to rough out one idea, no perfectionism.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "creator_inspiration_walk", title: "Inspiration Walk", detail: "Take 10 photos of things that move you and describe one.", kind: .action, xp: 20, dimensions: [.adventure], estimatedMinutes: 35)
                ]
            ),
            Chapter(
                id: "arc_creator_ignition_ship",
                title: "Ship",
                summary: "Publish small and often. Momentum beats perfection.",
                quests: [
                    Quest(id: "creator_small_post", title: "Small Post", detail: "Publish one post without endless tweaking.", kind: .action, xp: 25, dimensions: [.mind, .adventure], estimatedMinutes: 30),
                    Quest(id: "creator_feedback", title: "Feedback Loop", detail: "Ask two peers for feedback and note three improvements.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 22),
                    Quest(id: "creator_batch", title: "Batch Three", detail: "Make three pieces of content in one session, ready to post.", kind: .action, xp: 30, dimensions: [.mind], estimatedMinutes: 75),
                    Quest(id: "creator_publish_rule", title: "Publishing Rule", detail: "Choose a minimum cadence (e.g., weekly) and block time.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 15)
                ]
            ),
            Chapter(
                id: "arc_creator_ignition_signal",
                title: "Signal",
                summary: "Find your people, show your value, keep learning.",
                quests: [
                    Quest(id: "creator_collab", title: "Collab Invite", detail: "Pitch one collab or podcast cameo with a concrete hook.", kind: .choice, xp: 26, dimensions: [.adventure, .love], estimatedMinutes: 25),
                    Quest(id: "creator_newsletter", title: "Newsletter Seed", detail: "Build a simple signup and send a short first edition.", kind: .action, xp: 32, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "creator_metrics", title: "Retro + Metrics", detail: "Spend 20 minutes on stats and pick one experiment for the next post.", kind: .reflection, xp: 22, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_offer", title: "Tiny Offer", detail: "Create a mini paid offer or tip jar and share it with your audience.", kind: .action, xp: 28, dimensions: [.money, .mind], estimatedMinutes: 40)
                ]
            )
        ]
    )

    // MARK: - Social Recharge
    static let socialRecharge = Arc(
        id: "arc_social_recharge",
        title: "Social Recharge",
        subtitle: "From isolation to friendships that charge you up.",
        iconSystemName: "person.2.wave.2.fill",
        accentColorHex: "#06B6D4",
        focusDimensions: [.love, .adventure],
        chapters: [
            Chapter(
                id: "arc_social_recharge_inventory",
                title: "Inventory",
                summary: "See who fills you and who drains you. Choose where your energy goes.",
                quests: [
                    Quest(id: "social_map", title: "Relationship Map", detail: "Sketch your current circle and note who you want to see more.", kind: .reflection, xp: 18, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_boundaries", title: "Social Boundaries", detail: "Write three situations you will say no to this month.", kind: .choice, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 10),
                    Quest(id: "social_support", title: "Support Ping", detail: "Send two people a voice note to check in on them.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 14)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_habits",
                title: "Habits",
                summary: "Design recurring connection that feels light.",
                quests: [
                    Quest(id: "social_weekly", title: "Weekly Anchor", detail: "Plan a weekly moment (walk/lunch) with one person.", kind: .choice, xp: 24, dimensions: [.love], estimatedMinutes: 12),
                    Quest(id: "social_group", title: "Host Mini-Thing", detail: "Host something small: game night, brunch, or movie night.", kind: .action, xp: 26, dimensions: [.love, .adventure], estimatedMinutes: 80),
                    Quest(id: "social_mentors", title: "Mentor Reachout", detail: "Send one mentor or role model an update and a focused question.", kind: .action, xp: 22, dimensions: [.love, .mind], estimatedMinutes: 18),
                    Quest(id: "social_space", title: "Social Energy", detail: "Plan two nights with no plans to recover, no guilt.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 6)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_expand",
                title: "Expand",
                summary: "Stretch into new rooms while protecting your battery.",
                quests: [
                    Quest(id: "social_event", title: "Attend New Event", detail: "Go to one meetup or club where you don't know anyone yet.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 90),
                    Quest(id: "social_followup", title: "Follow-up Ritual", detail: "Send three follow-ups within 24 hours after meeting someone.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_recharge", title: "Recharge Plan", detail: "Schedule recovery time so your social battery doesn't crash.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 10)
                ]
            )
        ]
    )

    // MARK: - Student Groove
    static let studentGroove = Arc(
        id: "arc_student_groove",
        title: "Student Groove",
        subtitle: "Study with intention, live with lightness.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_student_groove_foundation",
                title: "Set the Base",
                summary: "Calm structure that feels doable, not grindy.",
                quests: [
                    Quest(id: "student_schedule", title: "Two-Day Plan", detail: "Plan only today and tomorrow. Max three blocks per day.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 12),
                    Quest(id: "student_workspace", title: "Study Nest", detail: "Clear your desk, set water out, choose one focus timer.", kind: .action, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "student_commute_walk", title: "Campus Walk", detail: "Find a quiet campus corner for deep focus.", kind: .action, xp: 16, dimensions: [.adventure], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_student_groove_execution",
                title: "Execute Smart",
                summary: "Learn faster, stress less, stay human.",
                quests: [
                    Quest(id: "student_active_recall", title: "Active Recall", detail: "Make 10 flashcards from one chapter and test yourself.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "student_office_hours", title: "Office Hours", detail: "Ask two questions to a teacher or tutor this week.", kind: .action, xp: 26, dimensions: [.mind, .love], estimatedMinutes: 20),
                    Quest(id: "student_breaks", title: "Break Ritual", detail: "Choose three micro-breaks (stretch, water, breath) and set timers.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10)
                ]
            ),
            Chapter(
                id: "arc_student_groove_balance",
                title: "Balance",
                summary: "Recovery, friends, and fun belong in the mix.",
                quests: [
                    Quest(id: "student_social", title: "Study Buddy", detail: "Plan one shared session with a classmate.", kind: .action, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 60),
                    Quest(id: "student_weekend", title: "Weekend Reset", detail: "Take 90 minutes for laundry, meal prep, and planning.", kind: .action, xp: 28, dimensions: [.mind, .adventure], estimatedMinutes: 90),
                    Quest(id: "student_boundaries", title: "Phone Off Window", detail: "Set two fixed phone-free windows per day.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Soft Life
    static let softLife = Arc(
        id: "arc_soft_life",
        title: "Soft Life",
        subtitle: "Gentle routines for people carrying too much.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#A855F7",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_soft_life_soothe",
                title: "Soothe",
                summary: "Regulate your nervous system first, then you can feel again.",
                quests: [
                    Quest(id: "soft_morning", title: "Slow Morning", detail: "Wake 20 minutes earlier, no screens, just breath and tea.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "soft_hydrate", title: "Hydrate Ritual", detail: "Set out two water bottles and finish them before lunch.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "soft_touch", title: "Cozy Reset", detail: "Fresh sheets, comfy outfit, a scent that calms you.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_soft_life_receive",
                title: "Receive",
                summary: "Let support in. You don't have to carry it solo.",
                quests: [
                    Quest(id: "soft_ask", title: "Ask for Help", detail: "Ask for one concrete thing from someone you trust.", kind: .action, xp: 22, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "soft_no", title: "Soft No", detail: "Practice one kind no-script and use it today.", kind: .choice, xp: 18, dimensions: [.love, .mind], estimatedMinutes: 8),
                    Quest(id: "soft_treat", title: "Mini Treat", detail: "Plan something small for yourself under $15, no guilt.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 15)
                ]
            ),
            Chapter(
                id: "arc_soft_life_flow",
                title: "Flow",
                summary: "Light structure, zero hustle. Enough is enough.",
                quests: [
                    Quest(id: "soft_three", title: "Rule of Three", detail: "Choose three priorities per day, no more.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6),
                    Quest(id: "soft_evening", title: "Evening Buffer", detail: "Create 45 minutes of decompression without input (walk or book).", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "soft_social", title: "Low-Key Hang", detail: "Invite one person for tea or a movie without hosting stress.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Weekend Reset
    static let weekendReset = Arc(
        id: "arc_weekend_reset",
        title: "Weekend Reset",
        subtitle: "Close the week and open the next with lightness.",
        iconSystemName: "sun.haze.fill",
        accentColorHex: "#F97316",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_weekend_reset_cleanup",
                title: "Clean Sweep",
                summary: "Clear physical and digital clutter so your head settles.",
                quests: [
                    Quest(id: "weekend_reset_room", title: "Room Reset", detail: "20-minute timer: clear surfaces, laundry in the basket, trash out.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "weekend_reset_inbox", title: "Inbox Zero-lite", detail: "Archive 20 emails/DMs and leave only three actions.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "weekend_reset_finances", title: "Money Pulse", detail: "Check banking apps for 10 minutes, note a feeling and one decision.", kind: .reflection, xp: 16, dimensions: [.money, .mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_plan",
                title: "Plan + Prep",
                summary: "Light planning, zero overwhelm. Choose what brings ease.",
                quests: [
                    Quest(id: "weekend_reset_calendar", title: "Calendar Check", detail: "Review next week and block two recovery moments.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "weekend_reset_meal", title: "Meals Ready", detail: "Plan three meals and grab basics or order a meal kit.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 35),
                    Quest(id: "weekend_reset_outfit", title: "Outfit Stack", detail: "Set out two outfits so Monday morning starts softly.", kind: .action, xp: 14, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_play",
                title: "Play + Connect",
                summary: "Refuel with something light and a person you trust.",
                quests: [
                    Quest(id: "weekend_reset_walk", title: "Sunlight Walk", detail: "20–30 minutes outside with music or a calming podcast.", kind: .action, xp: 18, dimensions: [.adventure], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_friend", title: "Check-in Coffee", detail: "A quick coffee or call with someone who recharges you.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_reflect", title: "Week Retro", detail: "Write down three wins, two lessons, and one thing to let go.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15)
                ]
            )
        ]
    )

    static let all: [Arc] = [
        heartRepair,
        moneyReset,
        calmMind,
        creatorIgnition,
        socialRecharge,
        studentGroove,
        softLife,
        weekendReset
    ]
}
