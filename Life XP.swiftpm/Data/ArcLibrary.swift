import Foundation

/// Curated Arc catalog with chapters and quests.
enum ArcLibrary {
    // MARK: - Heart Repair
    static let heartRepair = Arc(
        id: "arc_heart_repair",
        title: "Heart Repair",
        subtitle: "From cracked to steady. Rebuild trust in yourself.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#EC4899",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_heart_repair_foundation",
                title: "Stabilize",
                summary: "Stop the bleeding, set clean edges.",
                quests: [
                    Quest(id: "heart_no_contact", title: "Gentle No-Contact", detail: "Unfollow, mute, of archive reminders voor 14 dagen.", kind: .choice, xp: 25, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "heart_support_check", title: "Anchor People", detail: "List 3 mensen die safe voelen en plan 1 check-in.", kind: .reflection, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 12),
                    Quest(id: "heart_body_reset", title: "Body Reset", detail: "Slaap + eten + wandelen 20 min. vandaag telt.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "heart_emergency_script", title: "SOS Script", detail: "Schrijf 3 regels die je tegen jezelf zegt bij cravings om te appen.", kind: .reflection, xp: 16, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_story",
                title: "Story Rewrite",
                summary: "Process & reclaim je narratief.",
                quests: [
                    Quest(id: "heart_trigger_map", title: "Trigger Map", detail: "Noteer 5 momenten die pijn doen en 1 zachte reactie.", kind: .reflection, xp: 25, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "heart_reframe", title: "Reframe Ritual", detail: "Schrijf 5 nieuwe beliefs over jezelf na deze breuk.", kind: .reflection, xp: 30, dimensions: [.mind, .love], estimatedMinutes: 18),
                    Quest(id: "heart_selfdate", title: "Solo Self-Date", detail: "Plan een mini-uitje dat alleen voor jou is.", kind: .action, xp: 35, dimensions: [.love, .adventure], estimatedMinutes: 60),
                    Quest(id: "heart_voice_memo", title: "Voice Memo", detail: "Neem 2 minuten op waarin je je eigen beste vriend bent.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 5)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_future",
                title: "Future Ready",
                summary: "Open up zonder rushed vibes.",
                quests: [
                    Quest(id: "heart_boundaries", title: "Boundary Script", detail: "Schrijf 2 scripts voor grenzen in dating.", kind: .action, xp: 30, dimensions: [.love], estimatedMinutes: 14),
                    Quest(id: "heart_greenflags", title: "Green Flags", detail: "Noteer 5 groene en 3 rode vlaggen.", kind: .choice, xp: 20, dimensions: [.mind, .love], estimatedMinutes: 12),
                    Quest(id: "heart_connection_lab", title: "Connection Lab", detail: "Organiseer een mini gathering met vertrouwde mensen.", kind: .action, xp: 40, dimensions: [.love, .adventure], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Money Reset
    static let moneyReset = Arc(
        id: "arc_money_reset",
        title: "Money Reset",
        subtitle: "From avoidance to clear numbers and momentum.",
        iconSystemName: "creditcard.fill",
        accentColorHex: "#10B981",
        focusDimensions: [.money, .mind],
        chapters: [
            Chapter(
                id: "arc_money_reset_truth",
                title: "Face The Numbers",
                summary: "Clarity first, zonder shame.",
                quests: [
                    Quest(id: "money_snapshot", title: "Money Snapshot", detail: "Schrijf op: saldo’s, schulden, vaste lasten.", kind: .reflection, xp: 25, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_rules", title: "3 Money Rules", detail: "Bepaal simpele regels (bijv. no delivery doordeweeks).", kind: .choice, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 10),
                    Quest(id: "money_safe_place", title: "Buffer Start", detail: "Zet €25-€50 apart als mini noodpot.", kind: .action, xp: 30, dimensions: [.money], estimatedMinutes: 12),
                    Quest(id: "money_emotion", title: "Money Feel Check", detail: "Schrijf 5 zinnen over hoe geld je laat voelen zonder te oordelen.", kind: .reflection, xp: 14, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_money_reset_systems",
                title: "Systems On",
                summary: "Automate + simplify so you can breathe.",
                quests: [
                    Quest(id: "money_autopay", title: "Autopay Essentials", detail: "Automatiseer huur + nuts, één keer goed zetten.", kind: .action, xp: 35, dimensions: [.money], estimatedMinutes: 30),
                    Quest(id: "money_budget", title: "Intentional Budget", detail: "Maak 4 buckets: needs, fun, growth, buffer.", kind: .choice, xp: 25, dimensions: [.money], estimatedMinutes: 25),
                    Quest(id: "money_income", title: "Income Move", detail: "Pitch 1 freelance taak of vraag om 1:1 over salaris.", kind: .action, xp: 40, dimensions: [.money, .mind], estimatedMinutes: 35),
                    Quest(id: "money_cancel", title: "Subscription Audit", detail: "Schrap 2 recurring kosten of kies een goedkoper alternatief.", kind: .action, xp: 18, dimensions: [.money], estimatedMinutes: 20)
                ]
            ),
            Chapter(
                id: "arc_money_reset_growth",
                title: "Grow + Protect",
                summary: "Stack little wins voor compound effect.",
                quests: [
                    Quest(id: "money_insurance", title: "Cover The Basics", detail: "Check zorg + aansprakelijkheid. Fix hiaten.", kind: .action, xp: 20, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_invest_intro", title: "Invest Intro", detail: "Lees 15 min over indexfund basics en noteer vragen.", kind: .reflection, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 15),
                    Quest(id: "money_monthly_review", title: "Monthly Review", detail: "Plan terugkerend moment voor numbers & feelings.", kind: .reflection, xp: 25, dimensions: [.money, .mind], estimatedMinutes: 20),
                    Quest(id: "money_riskplan", title: "Emergency Playbook", detail: "Schrijf wat je doet bij verlies van inkomen of plots kost.", kind: .choice, xp: 24, dimensions: [.money, .mind], estimatedMinutes: 16)
                ]
            )
        ]
    )

    // MARK: - Calm Mind
    static let calmMind = Arc(
        id: "arc_calm_mind",
        title: "Calm Mind",
        subtitle: "From scattered to grounded focus.",
        iconSystemName: "wind.snow",
        accentColorHex: "#6366F1",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_calm_mind_reset",
                title: "Reset",
                summary: "Clear mental tabs + body stress.",
                quests: [
                    Quest(id: "calm_brain_dump", title: "Brain Dump", detail: "Schrijf alles wat in je hoofd zit in 10 minuten.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_body", title: "Body Signal", detail: "5 minuten box-breathing + stretchen.", kind: .action, xp: 15, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_digital", title: "Digital Pause", detail: "Zet 30 min niet storen en parkeer notificaties.", kind: .choice, xp: 15, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "calm_sleep_plan", title: "Sleep Boundaries", detail: "Kies slaap-ritueel + scherm curfew voor 3 nachten.", kind: .choice, xp: 22, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_focus",
                title: "Focus",
                summary: "Less multitask, meer clear finish.",
                quests: [
                    Quest(id: "calm_single_task", title: "One Thing", detail: "Kies 1 taak die vandaag telt, definieer ‘done’.", kind: .choice, xp: 20, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_focus_room", title: "Focus Space", detail: "Creëer een visuele reset (bureau, kamer, café).", kind: .action, xp: 25, dimensions: [.mind, .adventure], estimatedMinutes: 25),
                    Quest(id: "calm_timer", title: "3 Pomodoros", detail: "Doe 3 × 25-minuten sprints met 5-min pauzes.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "calm_context", title: "Context Switching", detail: "Noteer je top 5 afleiders en 1 oplossing per item.", kind: .reflection, xp: 18, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_play",
                title: "Play",
                summary: "Light adventure to refill dopamine.",
                quests: [
                    Quest(id: "calm_micro_adventure", title: "Micro Adventure", detail: "1 uur nieuwe plek, zonder agenda.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 75),
                    Quest(id: "calm_friend_ping", title: "Friend Ping", detail: "Plan koffie met iemand die je lacht laat voelen.", kind: .action, xp: 20, dimensions: [.love, .adventure], estimatedMinutes: 20),
                    Quest(id: "calm_wins", title: "Capture Wins", detail: "Noteer 5 recente wins, hoe klein ook.", kind: .reflection, xp: 15, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_sensory", title: "Sensory Reset", detail: "5-4-3-2-1 oefening: benoem 5 dingen die je ziet tot 1 dat je proeft.", kind: .action, xp: 16, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Creator Ignition
    static let creatorIgnition = Arc(
        id: "arc_creator_ignition",
        title: "Creator Ignition",
        subtitle: "Ship more than you scroll. Turn ideas into signals.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F59E0B",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_creator_ignition_seed",
                title: "Spark",
                summary: "Collect sparks and lower the bar to start.",
                quests: [
                    Quest(id: "creator_swipe_file", title: "Swipe File", detail: "Start een notitie met 10 ideeën en referenties.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "creator_setup", title: "Create Setup", detail: "Richt 1 simpele tool in (Notes/Notion) met template.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_timebox", title: "90-min Sprint", detail: "Timebox 90 minuten om één idee ruw te maken.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "creator_inspiration_walk", title: "Inspiration Walk", detail: "10 foto’s maken van dingen die je raken en 1 beschrijven.", kind: .action, xp: 20, dimensions: [.adventure], estimatedMinutes: 35)
                ]
            ),
            Chapter(
                id: "arc_creator_ignition_ship",
                title: "Ship",
                summary: "Publish small and often.",
                quests: [
                    Quest(id: "creator_small_post", title: "Small Post", detail: "Publiceer 1 post zonder eindeloos te tweaken.", kind: .action, xp: 25, dimensions: [.mind, .adventure], estimatedMinutes: 30),
                    Quest(id: "creator_feedback", title: "Feedback Loop", detail: "Vraag 2 peers om feedback en noteer 3 verbeteringen.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 22),
                    Quest(id: "creator_batch", title: "Batch 3", detail: "Maak 3 stukjes content in 1 sessie, klaar om te posten.", kind: .action, xp: 30, dimensions: [.mind], estimatedMinutes: 75),
                    Quest(id: "creator_publish_rule", title: "Publishing Rule", detail: "Kies een minimum cadence (bijv. 1× per week) en blok tijd.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 15)
                ]
            ),
            Chapter(
                id: "arc_creator_ignition_signal",
                title: "Signal",
                summary: "Find your people and own your lane.",
                quests: [
                    Quest(id: "creator_collab", title: "Collab Invite", detail: "Pitch 1 collab of podcast cameo.", kind: .choice, xp: 26, dimensions: [.adventure, .love], estimatedMinutes: 25),
                    Quest(id: "creator_newsletter", title: "Newsletter Seed", detail: "Bouw een simpele signup + stuur eerste editie.", kind: .action, xp: 32, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "creator_metrics", title: "Retro + Metrics", detail: "Kijk 20 min naar stats en kies 1 experiment.", kind: .reflection, xp: 22, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_offer", title: "Tiny Offer", detail: "Maak een mini paid offer of tip jar en deel ‘m.", kind: .action, xp: 28, dimensions: [.money, .mind], estimatedMinutes: 40)
                ]
            )
        ]
    )

    // MARK: - Social Recharge
    static let socialRecharge = Arc(
        id: "arc_social_recharge",
        title: "Social Recharge",
        subtitle: "From isolation to nourishing friendships.",
        iconSystemName: "person.2.wave.2.fill",
        accentColorHex: "#06B6D4",
        focusDimensions: [.love, .adventure],
        chapters: [
            Chapter(
                id: "arc_social_recharge_inventory",
                title: "Inventory",
                summary: "See who fills you up, who drains.",
                quests: [
                    Quest(id: "social_map", title: "Relationship Map", detail: "Teken je huidige kring en wie je vaker wil zien.", kind: .reflection, xp: 18, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_boundaries", title: "Social Boundaries", detail: "Schrijf 3 situaties waar je nee op zegt deze maand.", kind: .choice, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 10),
                    Quest(id: "social_support", title: "Support Ping", detail: "Stuur 2 mensen een voice note om te checken hoe ze zijn.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 14)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_habits",
                title: "Habits",
                summary: "Design recurring connection.",
                quests: [
                    Quest(id: "social_weekly", title: "Weekly Anchor", detail: "Plan een wekelijks moment (wandeling/lunch) met 1 persoon.", kind: .choice, xp: 24, dimensions: [.love], estimatedMinutes: 12),
                    Quest(id: "social_group", title: "Host Mini-thing", detail: "Organiseer iets kleins: spelavond, brunch, movie night.", kind: .action, xp: 26, dimensions: [.love, .adventure], estimatedMinutes: 80),
                    Quest(id: "social_mentors", title: "Mentor Reachout", detail: "Stuur 1 mentor/rolmodel een update + vraag.", kind: .action, xp: 22, dimensions: [.love, .mind], estimatedMinutes: 18),
                    Quest(id: "social_space", title: "Social Energy", detail: "Plan 2 reisdagen/avonden zonder afspraken voor herstel.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 6)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_expand",
                title: "Expand",
                summary: "Stretch into new rooms.",
                quests: [
                    Quest(id: "social_event", title: "Attend New Event", detail: "Ga naar 1 meetup/club waar je nog niemand kent.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 90),
                    Quest(id: "social_followup", title: "Follow-up Ritual", detail: "Stuur 3 follow-ups binnen 24 uur na een ontmoeting.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_recharge", title: "Recharge Plan", detail: "Plan ook recovery tijd zodat social batterijen niet crashen.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 10)
                ]
            )
        ]
    )

    // MARK: - Student Groove
    static let studentGroove = Arc(
        id: "arc_student_groove",
        title: "Student Groove",
        subtitle: "Study with intention, still have a life.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_student_groove_foundation",
                title: "Set the Base",
                summary: "Rustige structuur die je aankan.",
                quests: [
                    Quest(id: "student_schedule", title: "Two-Day Plan", detail: "Plan alleen vandaag + morgen. 3 blokken max.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 12),
                    Quest(id: "student_workspace", title: "Study Nest", detail: "Ruim je desk, zet water klaar, kies 1 focus timer.", kind: .action, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "student_commute_walk", title: "Campus Walk", detail: "Verken 1 nieuw rustig hoekje op campus voor focus.", kind: .action, xp: 16, dimensions: [.adventure], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_student_groove_execution",
                title: "Execute Smart",
                summary: "Leer sneller, stress minder.",
                quests: [
                    Quest(id: "student_active_recall", title: "Active Recall", detail: "Maak 10 flashcards van 1 hoofdstuk.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "student_office_hours", title: "Office Hours", detail: "Stel 2 vragen aan docent of tutor deze week.", kind: .action, xp: 26, dimensions: [.mind, .love], estimatedMinutes: 20),
                    Quest(id: "student_breaks", title: "Break Ritual", detail: "Kies 3 micro-breaks (stretchen, water, adem) en zet timers.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10)
                ]
            ),
            Chapter(
                id: "arc_student_groove_balance",
                title: "Balance",
                summary: "Herstel, vrienden en plezier tellen mee.",
                quests: [
                    Quest(id: "student_social", title: "Study Buddy", detail: "Plan 1 gezamenlijke sessie met een klasgenoot.", kind: .action, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 60),
                    Quest(id: "student_weekend", title: "Weekend Reset", detail: "Neem 90 min voor was, meal prep en planning.", kind: .action, xp: 28, dimensions: [.mind, .adventure], estimatedMinutes: 90),
                    Quest(id: "student_boundaries", title: "Phone Off Window", detail: "Zet 2 vaste tijdvakken zonder telefoon per dag.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Soft Life
    static let softLife = Arc(
        id: "arc_soft_life",
        title: "Soft Life",
        subtitle: "Gentle routines for people who overfunction.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#A855F7",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_soft_life_soothe",
                title: "Soothe",
                summary: "Regulate nervous system first.",
                quests: [
                    Quest(id: "soft_morning", title: "Slow Morning", detail: "Sta 20 min eerder op, geen schermen, alleen adem + thee.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "soft_hydrate", title: "Hydrate Ritual", detail: "Zet 2 flesjes water klaar en drink ze vóór lunch.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "soft_touch", title: "Cozy Reset", detail: "Frisse lakens + comfy outfit + favoriete geur.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_soft_life_receive",
                title: "Receive",
                summary: "Practice letting others support you.",
                quests: [
                    Quest(id: "soft_ask", title: "Ask for Help", detail: "Vraag 1 concreet ding aan iemand die je vertrouwt.", kind: .action, xp: 22, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "soft_no", title: "Soft No", detail: "Oefen 1 vriendelijk nee-script en gebruik het vandaag.", kind: .choice, xp: 18, dimensions: [.love, .mind], estimatedMinutes: 8),
                    Quest(id: "soft_treat", title: "Mini Treat", detail: "Plan iets kleins voor jezelf onder de €15.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 15)
                ]
            ),
            Chapter(
                id: "arc_soft_life_flow",
                title: "Flow",
                summary: "Light structure, zero hustle.",
                quests: [
                    Quest(id: "soft_three", title: "Rule of Three", detail: "Kies 3 prioriteiten per dag, niet meer.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6),
                    Quest(id: "soft_evening", title: "Evening Buffer", detail: "Creëer 45-min decompressie zonder input (wandeling/boek).", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "soft_social", title: "Low-Key Hang", detail: "Nodig 1 persoon uit voor thee/film zonder hosting stress.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Weekend Reset
    static let weekendReset = Arc(
        id: "arc_weekend_reset",
        title: "Weekend Reset",
        subtitle: "Close the week, open the next.",
        iconSystemName: "sun.haze.fill",
        accentColorHex: "#F97316",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_weekend_reset_cleanup",
                title: "Clean Sweep",
                summary: "Clearing space for next week.",
                quests: [
                    Quest(id: "weekend_reset_room", title: "Room Reset", detail: "20-min timer: surfaces leeg, was in mand, prullenbak leeg.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "weekend_reset_inbox", title: "Inbox Zero-lite", detail: "Archiveer 20 mails/DMs, laat alleen 3 acties over.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "weekend_reset_finances", title: "Money Pulse", detail: "Check bankapps 10 min, noteer gevoel + 1 besluit.", kind: .reflection, xp: 16, dimensions: [.money, .mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_plan",
                title: "Plan + Prep",
                summary: "Light planning, no overwhelm.",
                quests: [
                    Quest(id: "weekend_reset_calendar", title: "Calendar Check", detail: "Bekijk komende week, blok 2 herstelmomenten.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "weekend_reset_meal", title: "Meals Ready", detail: "Plan 3 maaltijden, koop basis of bestel een foodbox.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 35),
                    Quest(id: "weekend_reset_outfit", title: "Outfit Stack", detail: "Leg 2 outfits klaar zodat maandagochtend zacht start.", kind: .action, xp: 14, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_play",
                title: "Play + Connect",
                summary: "Refuel with something light.",
                quests: [
                    Quest(id: "weekend_reset_walk", title: "Sunlight Walk", detail: "20-30 min buiten met muziek of podcast.", kind: .action, xp: 18, dimensions: [.adventure], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_friend", title: "Check-in Coffee", detail: "Korte koffie of call met iemand die oplaadt.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_reflect", title: "Week Retro", detail: "Noteer 3 wins, 2 lessen, 1 ding om los te laten.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15)
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
