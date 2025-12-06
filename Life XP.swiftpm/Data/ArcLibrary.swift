import Foundation

/// Curated Arc catalog with chapters and quests.
enum ArcLibrary {
    // MARK: - Heart Repair
    static let heartRepair = Arc(
        id: "arc_heart_repair",
        title: "Heart Repair",
        subtitle: "Heartbreak is heavy. We’ll steady you and reopen softly.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#EC4899",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_heart_repair_foundation",
                title: "Stabilize",
                summary: "Close the loops, find calm breaths, remind yourself you’re safe.",
                quests: [
                    Quest(id: "heart_no_contact", title: "Gentle No-Contact", detail: "Unfollow, mute of archive triggers voor 14 dagen. Je hoeft het niet te checken.", kind: .choice, xp: 25, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "heart_support_check", title: "Anchor People", detail: "Noteer 3 mensen die safe voelen en plan één check-in.", kind: .reflection, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 12),
                    Quest(id: "heart_body_reset", title: "Body Reset", detail: "Slaap, eten en 20 minuten wandelen tellen vandaag als winst.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "heart_emergency_script", title: "SOS Script", detail: "Schrijf 3 zinnen die je tegen jezelf zegt bij cravings om te appen.", kind: .reflection, xp: 16, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_story",
                title: "Story Rewrite",
                summary: "Let the hurt speak, then claim een nieuw verhaal dat jou centraal zet.",
                quests: [
                    Quest(id: "heart_trigger_map", title: "Trigger Map", detail: "Noteer 5 momenten die pijn doen en één zachte reactie per trigger.", kind: .reflection, xp: 25, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "heart_reframe", title: "Reframe Ritual", detail: "Schrijf 5 nieuwe beliefs over jezelf na deze breuk.", kind: .reflection, xp: 30, dimensions: [.mind, .love], estimatedMinutes: 18),
                    Quest(id: "heart_selfdate", title: "Solo Self-Date", detail: "Plan een mini-uitje dat alleen voor jou is, geen afleiding.", kind: .action, xp: 35, dimensions: [.love, .adventure], estimatedMinutes: 60),
                    Quest(id: "heart_voice_memo", title: "Voice Memo", detail: "Neem 2 minuten op waarin je praat als je eigen beste vriend.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 5)
                ]
            ),
            Chapter(
                id: "arc_heart_repair_future",
                title: "Future Ready",
                summary: "Herbouw vertrouwen stap voor stap, met duidelijke grenzen en hoop.",
                quests: [
                    Quest(id: "heart_boundaries", title: "Boundary Script", detail: "Schrijf 2 scripts voor grenzen in dating die je kunt herhalen.", kind: .action, xp: 30, dimensions: [.love], estimatedMinutes: 14),
                    Quest(id: "heart_greenflags", title: "Green Flags", detail: "Noteer 5 groene en 3 rode vlaggen zodat je keuzes lichter worden.", kind: .choice, xp: 20, dimensions: [.mind, .love], estimatedMinutes: 12),
                    Quest(id: "heart_connection_lab", title: "Connection Lab", detail: "Organiseer een mini gathering met vertrouwde mensen om warm te draaien.", kind: .action, xp: 40, dimensions: [.love, .adventure], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Money Reset
    static let moneyReset = Arc(
        id: "arc_money_reset",
        title: "Money Reset",
        subtitle: "No more avoidance. Clear cijfers, kalm hoofd, next moves.",
        iconSystemName: "creditcard.fill",
        accentColorHex: "#10B981",
        focusDimensions: [.money, .mind],
        chapters: [
            Chapter(
                id: "arc_money_reset_truth",
                title: "Face The Numbers",
                summary: "Wees eerlijk, zonder shame. Je kan pas sturen als je ziet wat er is.",
                quests: [
                    Quest(id: "money_snapshot", title: "Money Snapshot", detail: "Schrijf saldo’s, schulden en vaste lasten op één plek.", kind: .reflection, xp: 25, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_rules", title: "3 Money Rules", detail: "Bepaal 3 simpele regels (bijv. geen delivery doordeweeks).", kind: .choice, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 10),
                    Quest(id: "money_safe_place", title: "Buffer Start", detail: "Zet €25-€50 apart als mini noodpot, al is het symbolisch.", kind: .action, xp: 30, dimensions: [.money], estimatedMinutes: 12),
                    Quest(id: "money_emotion", title: "Money Feel Check", detail: "Schrijf 5 zinnen over hoe geld je laat voelen zonder oordeel.", kind: .reflection, xp: 14, dimensions: [.mind], estimatedMinutes: 8)
                ]
            ),
            Chapter(
                id: "arc_money_reset_systems",
                title: "Systems On",
                summary: "Automatiseer basics zodat je hoofd ruimte krijgt voor groei.",
                quests: [
                    Quest(id: "money_autopay", title: "Autopay Essentials", detail: "Automatiseer huur en nuts, één keer goed zetten.", kind: .action, xp: 35, dimensions: [.money], estimatedMinutes: 30),
                    Quest(id: "money_budget", title: "Intentional Budget", detail: "Maak 4 buckets: needs, fun, growth, buffer met globale bedragen.", kind: .choice, xp: 25, dimensions: [.money], estimatedMinutes: 25),
                    Quest(id: "money_income", title: "Income Move", detail: "Pitch 1 freelance taak of vraag een 1:1 over salaris.", kind: .action, xp: 40, dimensions: [.money, .mind], estimatedMinutes: 35),
                    Quest(id: "money_cancel", title: "Subscription Audit", detail: "Schrap 2 terugkerende kosten of kies een goedkoper alternatief.", kind: .action, xp: 18, dimensions: [.money], estimatedMinutes: 20)
                ]
            ),
            Chapter(
                id: "arc_money_reset_growth",
                title: "Grow + Protect",
                summary: "Stack kleine wins, bescherm jezelf tegen stress en verrassingen.",
                quests: [
                    Quest(id: "money_insurance", title: "Cover The Basics", detail: "Check zorg- en aansprakelijkheidsverzekering. Fix hiaten.", kind: .action, xp: 20, dimensions: [.money], estimatedMinutes: 18),
                    Quest(id: "money_invest_intro", title: "Invest Intro", detail: "Lees 15 min over indexfonds-basics en noteer 2 vragen.", kind: .reflection, xp: 20, dimensions: [.money, .mind], estimatedMinutes: 15),
                    Quest(id: "money_monthly_review", title: "Monthly Review", detail: "Plan een vast moment voor numbers + feelings en noteer 3 acties.", kind: .reflection, xp: 25, dimensions: [.money, .mind], estimatedMinutes: 20),
                    Quest(id: "money_riskplan", title: "Emergency Playbook", detail: "Schrijf wat je doet bij inkomensverlies of plotselinge kosten.", kind: .choice, xp: 24, dimensions: [.money, .mind], estimatedMinutes: 16)
                ]
            )
        ]
    )

    // MARK: - Calm Mind
    static let calmMind = Arc(
        id: "arc_calm_mind",
        title: "Calm Mind",
        subtitle: "Van scattered naar grounded focus, zonder rigid rules.",
        iconSystemName: "wind.snow",
        accentColorHex: "#6366F1",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_calm_mind_reset",
                title: "Reset",
                summary: "Clear mentale tabs, kalmeer je lichaam, voel weer ruimte.",
                quests: [
                    Quest(id: "calm_brain_dump", title: "Brain Dump", detail: "Schrijf alles wat in je hoofd zit in 10 minuten, zonder filter.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_body", title: "Body Signal", detail: "5 minuten box-breathing en stretchen om spanning te laten zakken.", kind: .action, xp: 15, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "calm_digital", title: "Digital Pause", detail: "Zet 30 min niet storen en parkeer meldingen bewust.", kind: .choice, xp: 15, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "calm_sleep_plan", title: "Sleep Boundaries", detail: "Kies slaapritueel + scherm-curfew voor 3 avonden.", kind: .choice, xp: 22, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_focus",
                title: "Focus",
                summary: "Stop multitasken, start helder afronden met realistische blokken.",
                quests: [
                    Quest(id: "calm_single_task", title: "One Thing", detail: "Kies 1 taak die vandaag telt en definieer wat ‘done’ betekent.", kind: .choice, xp: 20, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_focus_room", title: "Focus Space", detail: "Reset je werkplek of kies een café waar je echt kunt landen.", kind: .action, xp: 25, dimensions: [.mind, .adventure], estimatedMinutes: 25),
                    Quest(id: "calm_timer", title: "3 Pomodoros", detail: "Doe 3 × 25-minuten sprints met 5-minuten pauzes.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "calm_context", title: "Context Switching", detail: "Noteer je top 5 afleiders en één oplossing per item.", kind: .reflection, xp: 18, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_calm_mind_play",
                title: "Play",
                summary: "Light dopamine, geen schuldgevoel. Je brein heeft dit nodig.",
                quests: [
                    Quest(id: "calm_micro_adventure", title: "Micro Adventure", detail: "1 uur nieuwe plek zonder agenda, alleen nieuwsgierigheid.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 75),
                    Quest(id: "calm_friend_ping", title: "Friend Ping", detail: "Plan koffie met iemand die je laat lachen of landen.", kind: .action, xp: 20, dimensions: [.love, .adventure], estimatedMinutes: 20),
                    Quest(id: "calm_wins", title: "Capture Wins", detail: "Noteer 5 recente wins, hoe klein ook, en voel ze even.", kind: .reflection, xp: 15, dimensions: [.mind], estimatedMinutes: 8),
                    Quest(id: "calm_sensory", title: "Sensory Reset", detail: "5-4-3-2-1 oefening: benoem 5 dingen die je ziet tot 1 dat je proeft.", kind: .action, xp: 16, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Creator Ignition
    static let creatorIgnition = Arc(
        id: "arc_creator_ignition",
        title: "Creator Ignition",
        subtitle: "Ship meer dan je scrollt. Maak signalen die mensen voelen.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F59E0B",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_creator_ignition_seed",
                title: "Spark",
                summary: "Verzamel ideeën en verlaag de drempel om te starten.",
                quests: [
                    Quest(id: "creator_swipe_file", title: "Swipe File", detail: "Start een notitie met 10 ideeën en referenties die je raken.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "creator_setup", title: "Create Setup", detail: "Richt 1 simpele tool in (Notes/Notion) met template zodat je kunt beginnen.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_timebox", title: "90-min Sprint", detail: "Timebox 90 minuten om één idee ruw te maken, zonder perfectionisme.", kind: .action, xp: 28, dimensions: [.mind], estimatedMinutes: 90),
                    Quest(id: "creator_inspiration_walk", title: "Inspiration Walk", detail: "Maak 10 foto’s van dingen die je raken en beschrijf er één.", kind: .action, xp: 20, dimensions: [.adventure], estimatedMinutes: 35)
                ]
            ),
            Chapter(
                id: "arc_creator_ignition_ship",
                title: "Ship",
                summary: "Publiceer klein en vaak. Momentum > perfectie.",
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
                summary: "Vind je mensen, laat je waarde zien, blijf leren.",
                quests: [
                    Quest(id: "creator_collab", title: "Collab Invite", detail: "Pitch 1 collab of podcast cameo met een concreet haakje.", kind: .choice, xp: 26, dimensions: [.adventure, .love], estimatedMinutes: 25),
                    Quest(id: "creator_newsletter", title: "Newsletter Seed", detail: "Bouw een simpele signup en stuur een korte eerste editie.", kind: .action, xp: 32, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "creator_metrics", title: "Retro + Metrics", detail: "Kijk 20 min naar stats en kies 1 experiment voor de volgende post.", kind: .reflection, xp: 22, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "creator_offer", title: "Tiny Offer", detail: "Maak een mini paid offer of tip jar en deel ‘m met je volgers.", kind: .action, xp: 28, dimensions: [.money, .mind], estimatedMinutes: 40)
                ]
            )
        ]
    )

    // MARK: - Social Recharge
    static let socialRecharge = Arc(
        id: "arc_social_recharge",
        title: "Social Recharge",
        subtitle: "Van isolatie naar vriendschappen die je opladen.",
        iconSystemName: "person.2.wave.2.fill",
        accentColorHex: "#06B6D4",
        focusDimensions: [.love, .adventure],
        chapters: [
            Chapter(
                id: "arc_social_recharge_inventory",
                title: "Inventory",
                summary: "Zie wie je vult en wie je lekt. Kies bewust waar je energie heen gaat.",
                quests: [
                    Quest(id: "social_map", title: "Relationship Map", detail: "Teken je huidige kring en noteer wie je vaker wil zien.", kind: .reflection, xp: 18, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_boundaries", title: "Social Boundaries", detail: "Schrijf 3 situaties waar je deze maand nee op zegt.", kind: .choice, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 10),
                    Quest(id: "social_support", title: "Support Ping", detail: "Stuur 2 mensen een voice note om te checken hoe ze zijn.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 14)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_habits",
                title: "Habits",
                summary: "Ontwerp terugkerende connectie die licht voelt.",
                quests: [
                    Quest(id: "social_weekly", title: "Weekly Anchor", detail: "Plan een wekelijks moment (wandeling/lunch) met één persoon.", kind: .choice, xp: 24, dimensions: [.love], estimatedMinutes: 12),
                    Quest(id: "social_group", title: "Host Mini-thing", detail: "Organiseer iets kleins: spelavond, brunch of movie night.", kind: .action, xp: 26, dimensions: [.love, .adventure], estimatedMinutes: 80),
                    Quest(id: "social_mentors", title: "Mentor Reachout", detail: "Stuur één mentor of rolmodel een update en gerichte vraag.", kind: .action, xp: 22, dimensions: [.love, .mind], estimatedMinutes: 18),
                    Quest(id: "social_space", title: "Social Energy", detail: "Plan 2 avonden zonder afspraken voor herstel, zonder schuld.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 6)
                ]
            ),
            Chapter(
                id: "arc_social_recharge_expand",
                title: "Expand",
                summary: "Stretch in nieuwe ruimtes maar bescherm je batterij.",
                quests: [
                    Quest(id: "social_event", title: "Attend New Event", detail: "Ga naar 1 meetup of club waar je nog niemand kent.", kind: .action, xp: 30, dimensions: [.adventure], estimatedMinutes: 90),
                    Quest(id: "social_followup", title: "Follow-up Ritual", detail: "Stuur 3 follow-ups binnen 24 uur na een ontmoeting.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 15),
                    Quest(id: "social_recharge", title: "Recharge Plan", detail: "Plan ook recovery tijd zodat je sociale batterij niet crasht.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 10)
                ]
            )
        ]
    )

    // MARK: - Student Groove
    static let studentGroove = Arc(
        id: "arc_student_groove",
        title: "Student Groove",
        subtitle: "Study met intentie, leef met lichtheid.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_student_groove_foundation",
                title: "Set the Base",
                summary: "Rustige structuur die haalbaar voelt, geen grind.",
                quests: [
                    Quest(id: "student_schedule", title: "Two-Day Plan", detail: "Plan alleen vandaag en morgen. Max 3 blokken per dag.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 12),
                    Quest(id: "student_workspace", title: "Study Nest", detail: "Ruim je desk, zet water klaar, kies één focus timer.", kind: .action, xp: 20, dimensions: [.mind], estimatedMinutes: 15),
                    Quest(id: "student_commute_walk", title: "Campus Walk", detail: "Verken een rustig hoekje op campus voor diepe focus.", kind: .action, xp: 16, dimensions: [.adventure], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_student_groove_execution",
                title: "Execute Smart",
                summary: "Leer sneller, stress minder, blijf menselijk.",
                quests: [
                    Quest(id: "student_active_recall", title: "Active Recall", detail: "Maak 10 flashcards van één hoofdstuk en test jezelf.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "student_office_hours", title: "Office Hours", detail: "Stel 2 vragen aan docent of tutor deze week.", kind: .action, xp: 26, dimensions: [.mind, .love], estimatedMinutes: 20),
                    Quest(id: "student_breaks", title: "Break Ritual", detail: "Kies 3 micro-breaks (stretchen, water, adem) en zet timers.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10)
                ]
            ),
            Chapter(
                id: "arc_student_groove_balance",
                title: "Balance",
                summary: "Herstel, vrienden en plezier horen erbij om te slagen.",
                quests: [
                    Quest(id: "student_social", title: "Study Buddy", detail: "Plan één gezamenlijke sessie met een klasgenoot.", kind: .action, xp: 20, dimensions: [.love, .mind], estimatedMinutes: 60),
                    Quest(id: "student_weekend", title: "Weekend Reset", detail: "Neem 90 minuten voor was, meal prep en planning.", kind: .action, xp: 28, dimensions: [.mind, .adventure], estimatedMinutes: 90),
                    Quest(id: "student_boundaries", title: "Phone Off Window", detail: "Zet 2 vaste tijdvakken zonder telefoon per dag.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6)
                ]
            )
        ]
    )

    // MARK: - Soft Life
    static let softLife = Arc(
        id: "arc_soft_life",
        title: "Soft Life",
        subtitle: "Zachte routines voor mensen die te veel dragen.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#A855F7",
        focusDimensions: [.love, .mind],
        chapters: [
            Chapter(
                id: "arc_soft_life_soothe",
                title: "Soothe",
                summary: "Reguleer je zenuwstelsel eerst, dan kun je weer voelen.",
                quests: [
                    Quest(id: "soft_morning", title: "Slow Morning", detail: "Sta 20 min eerder op, geen schermen, alleen adem en thee.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "soft_hydrate", title: "Hydrate Ritual", detail: "Zet 2 flesjes water klaar en drink ze vóór lunch.", kind: .choice, xp: 14, dimensions: [.mind], estimatedMinutes: 5),
                    Quest(id: "soft_touch", title: "Cozy Reset", detail: "Schone lakens, comfy outfit, geur die je kalmeert.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 25)
                ]
            ),
            Chapter(
                id: "arc_soft_life_receive",
                title: "Receive",
                summary: "Laat steun binnen. Je hoeft het niet solo te dragen.",
                quests: [
                    Quest(id: "soft_ask", title: "Ask for Help", detail: "Vraag één concreet ding aan iemand die je vertrouwt.", kind: .action, xp: 22, dimensions: [.love], estimatedMinutes: 10),
                    Quest(id: "soft_no", title: "Soft No", detail: "Oefen één vriendelijk nee-script en gebruik het vandaag.", kind: .choice, xp: 18, dimensions: [.love, .mind], estimatedMinutes: 8),
                    Quest(id: "soft_treat", title: "Mini Treat", detail: "Plan iets kleins voor jezelf onder de €15, zonder schuld.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 15)
                ]
            ),
            Chapter(
                id: "arc_soft_life_flow",
                title: "Flow",
                summary: "Lichte structuur, nul hustle. Genoeg is genoeg.",
                quests: [
                    Quest(id: "soft_three", title: "Rule of Three", detail: "Kies 3 prioriteiten per dag, niet meer.", kind: .choice, xp: 18, dimensions: [.mind], estimatedMinutes: 6),
                    Quest(id: "soft_evening", title: "Evening Buffer", detail: "Creëer 45 min decompressie zonder input (wandeling of boek).", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 45),
                    Quest(id: "soft_social", title: "Low-Key Hang", detail: "Nodig 1 persoon uit voor thee of film zonder hosting stress.", kind: .action, xp: 20, dimensions: [.love], estimatedMinutes: 90)
                ]
            )
        ]
    )

    // MARK: - Weekend Reset
    static let weekendReset = Arc(
        id: "arc_weekend_reset",
        title: "Weekend Reset",
        subtitle: "Sluit de week, open de volgende met lichtheid.",
        iconSystemName: "sun.haze.fill",
        accentColorHex: "#F97316",
        focusDimensions: [.mind, .adventure],
        chapters: [
            Chapter(
                id: "arc_weekend_reset_cleanup",
                title: "Clean Sweep",
                summary: "Ruim fysieke en digitale rommel op zodat je hoofd zakt.",
                quests: [
                    Quest(id: "weekend_reset_room", title: "Room Reset", detail: "20-min timer: surfaces leeg, was in mand, prullenbak leeg.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 20),
                    Quest(id: "weekend_reset_inbox", title: "Inbox Zero-lite", detail: "Archiveer 20 mails/DM’s, laat alleen 3 acties over.", kind: .action, xp: 18, dimensions: [.mind], estimatedMinutes: 25),
                    Quest(id: "weekend_reset_finances", title: "Money Pulse", detail: "Check bankapps 10 min, noteer gevoel en één besluit.", kind: .reflection, xp: 16, dimensions: [.money, .mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_plan",
                title: "Plan + Prep",
                summary: "Lichte planning, zero overwhelm. Kies wat lucht geeft.",
                quests: [
                    Quest(id: "weekend_reset_calendar", title: "Calendar Check", detail: "Bekijk komende week en blok 2 herstelmomenten.", kind: .choice, xp: 16, dimensions: [.mind], estimatedMinutes: 10),
                    Quest(id: "weekend_reset_meal", title: "Meals Ready", detail: "Plan 3 maaltijden en koop basics of bestel een foodbox.", kind: .action, xp: 22, dimensions: [.mind], estimatedMinutes: 35),
                    Quest(id: "weekend_reset_outfit", title: "Outfit Stack", detail: "Leg 2 outfits klaar zodat maandagochtend zacht start.", kind: .action, xp: 14, dimensions: [.mind], estimatedMinutes: 12)
                ]
            ),
            Chapter(
                id: "arc_weekend_reset_play",
                title: "Play + Connect",
                summary: "Refuel met iets lichts en een mens die je vertrouwt.",
                quests: [
                    Quest(id: "weekend_reset_walk", title: "Sunlight Walk", detail: "20-30 min buiten met muziek of podcast die je kalmeert.", kind: .action, xp: 18, dimensions: [.adventure], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_friend", title: "Check-in Coffee", detail: "Korte koffie of call met iemand die je oplaadt.", kind: .action, xp: 16, dimensions: [.love], estimatedMinutes: 30),
                    Quest(id: "weekend_reset_reflect", title: "Week Retro", detail: "Noteer 3 wins, 2 lessen en 1 ding om los te laten.", kind: .reflection, xp: 20, dimensions: [.mind], estimatedMinutes: 15)
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
