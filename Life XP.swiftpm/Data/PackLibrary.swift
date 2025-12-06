import Foundation

/// Static library of checklist packs used by the prototype.
enum PackLibrary {
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
            ),
            ChecklistItem(
                id: "rel_repair_ritual",
                title: "Monthly repair ritual",
                detail: "Elke maand een uur ingepland om kleine irritaties, verwachtingen en plannen bij te stellen.",
                xp: 30,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_love_languages",
                title: "Love languages reality-check",
                detail: "Jullie hebben getest wat elkaars echte liefdetaal is en hoe je dat dagelijks kan toepassen.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_emergency_plan",
                title: "Emergency plan als team",
                detail: "Wie belt je bij pech? Hoe regelen jullie zorg? Er is een plan dat rust geeft in crisismomenten.",
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
            ),
            ChecklistItem(
                id: "glow_digital_detox",
                title: "Weekend digital detox",
                detail: "48 uur zonder doomscrollen, meldingen uit en tijd gevuld met echte mensen of creatie.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "glow_strength_routine",
                title: "Sterker worden",
                detail: "Minstens 10 kracht-workouts voltooid in 30 dagen met progressie bijgehouden.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_signature_scent",
                title: "Signature look & scent",
                detail: "Je hebt een kenmerkende look + geur gevonden waar je je krachtig in voelt.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
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
            ),
            ChecklistItem(
                id: "breakup_support_circle",
                title: "Support circle",
                detail: "Je hebt 3 mensen benoemd die je mag bellen als je wil terugvallen en hen dat verteld.",
                xp: 18,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "breakup_new_story",
                title: "Nieuwe narratief",
                detail: "Je hebt opgeschreven wie je nu wordt zonder hen en welke waarden daar bij horen.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
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
            ),
            ChecklistItem(
                id: "money_automation",
                title: "Automate the boring stuff",
                detail: "Vaste lasten, sparen en beleggen staan automatisch ingepland na elke payday.",
                xp: 30,
                dimensions: [.money],
                isPremium: true
            ),
            ChecklistItem(
                id: "money_networking",
                title: "Value-first networking",
                detail: "Je hebt 3 warme connecties opgebouwd door iets van waarde te brengen zonder te vragen.",
                xp: 22,
                dimensions: [.money, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_portfolio",
                title: "Portfolio snapshot",
                detail: "Een simpel portfolio of slide deck dat je skills bewijst en klaarstaat om te delen.",
                xp: 26,
                dimensions: [.money, .adventure],
                isPremium: true
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
            ),
            ChecklistItem(
                id: "adult_emergency_contacts",
                title: "ICE lijst klaar",
                detail: "In je telefoon en huis staat een actuele ICE-lijst met contacten, meds en allergies.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "adult_meal_flow",
                title: "Meal flow",
                detail: "Je hebt een rotatie van 6 makkelijke maaltijden + boodschappenlijst die je zonder stress kan doen.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
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
            ),
            ChecklistItem(
                id: "adv_memory_bank",
                title: "Memory bank",
                detail: "Je hebt een fotoalbum / notitie met 12 momenten die je bewust hebt vastgelegd dit jaar.",
                xp: 18,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "adv_monthly_micro",
                title: "Monthly micro-adventure",
                detail: "Elke maand één nieuwe plek bezocht in je eigen stad of regio.",
                xp: 24,
                dimensions: [.adventure],
                isPremium: true
            )
        ]
    )

    static let wellnessReset = CategoryPack(
        id: "wellness_reset",
        title: "Wellness Reset",
        subtitle: "Slapen, ademhalen, grenzen en rust",
        iconSystemName: "leaf.fill",
        accentColorHex: "#10B981",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "wellness_sleep_reset",
                title: "Sleep reset week",
                detail: "7 nachten op rij voor middernacht geslapen en schermvrij 60 minuten voor bed.",
                xp: 26,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "wellness_boundaries",
                title: "Boundary scripts",
                detail: "3 voorbeelduitspreken geoefend voor ‘nee zeggen’ zodat je ze paraat hebt.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "wellness_therapy_consult",
                title: "Therapy consult",
                detail: "Een intake gepland of gedaan met een therapeut/coach om je emotionele baseline te checken.",
                xp: 34,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "wellness_move_daily",
                title: "Move daily streak",
                detail: "Minstens 10.000 stappen of 30 min bewegen voor 21 dagen op rij.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let creatorLab = CategoryPack(
        id: "creator_lab",
        title: "Creator Lab",
        subtitle: "Maak dingen, ship dingen, groei je reputatie",
        iconSystemName: "wand.and.stars",
        accentColorHex: "#8B5CF6",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "creator_idea_bank",
                title: "Idea bank",
                detail: "Een lijst met 30 content/side-project ideeën die je makkelijk kan oppakken.",
                xp: 22,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_publish_weekly",
                title: "Publish weekly",
                detail: "Minstens 4 weken na elkaar iets gepubliceerd (artikel, post, video, code, muziek).",
                xp: 32,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_collab",
                title: "Collab gedaan",
                detail: "Samen met iemand anders iets gemaakt en live gezet.",
                xp: 26,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_monetize",
                title: "Eerste euro online",
                detail: "Je hebt je eerste euro online verdiend met iets wat je maakte.",
                xp: 30,
                dimensions: [.money, .adventure],
                isPremium: true
            )
        ]
    )

    static let communityRoots = CategoryPack(
        id: "community_roots",
        title: "Community & Roots",
        subtitle: "Vrienden, buurt en dingen groter dan jezelf",
        iconSystemName: "person.3.sequence.fill",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "community_host",
                title: "Hosted people",
                detail: "Een diner/board game/filmavond georganiseerd voor vrienden of buren.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "community_volunteer",
                title: "Give back",
                detail: "Minstens 4 uur vrijwilligerswerk gedaan of gedoneerd waar je achter staat.",
                xp: 22,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "community_club",
                title: "Join a club",
                detail: "Aangesloten bij een club/vereniging waar je wekelijks mensen ontmoet.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "community_story",
                title: "Family archive",
                detail: "Een gesprek opgenomen met (groot)ouders over hun leven en wat je wil bewaren.",
                xp: 28,
                dimensions: [.love, .mind],
                isPremium: true
            )
        ]
    )

    static let missionControl = CategoryPack(
        id: "mission_control",
        title: "Mission Control",
        subtitle: "Systems, focus en output op NASA-niveau",
        iconSystemName: "target",
        accentColorHex: "#0EA5E9",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "mission_weekly_review",
                title: "Sunday reset + weekly review",
                detail: "Elke zondag 45 minuten: kalenders syncen, taken prioriteren, tijd geblokt voor deep work.",
                xp: 30,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_timeboxing",
                title: "Timeboxing master",
                detail: "Minstens 10 werkdagen timeboxed in je kalender en 80% van je blokken gehaald.",
                xp: 26,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_automation",
                title: "Automate the boring",
                detail: "3 terugkerende taken geautomatiseerd (facturen, reminders, templates).",
                xp: 28,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mission_focus_room",
                title: "Focus room",
                detail: "Een fysieke of digitale werksetup gebouwd die je onmiddellijk in flow brengt.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_12week",
                title: "12-week mission",
                detail: "Een 12-week doel gedefinieerd met 3 lead metrics en wekelijkse check-ins.",
                xp: 34,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mission_recharge_day",
                title: "Deep recharge day",
                detail: "Eén dag per maand geblokt voor herstel zonder guilt: sauna, massage, slapen, offline.",
                xp: 22,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let adventurePassport = CategoryPack(
        id: "adventure_passport",
        title: "Adventure Passport",
        subtitle: "Micro-adventures die je leven episch maken",
        iconSystemName: "globe.americas.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "passport_sunrise_mission",
                title: "Sunrise mission",
                detail: "Om 05:30 op, naar een hoog punt en de zonsopgang kijken met koffie.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_new_flavor",
                title: "New flavor night",
                detail: "Eten geproefd dat je nog nooit had – street food, regionale keuken of zelf gekookt.",
                xp: 16,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_24h_trip",
                title: "24h city hop",
                detail: "24 uur in een andere stad met slechts een backpack en een must-do lijst.",
                xp: 30,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "passport_memory_capture",
                title: "Memory capture",
                detail: "Een mini-vlog of fotoverhaal gemaakt van een dag en gedeeld met 1 persoon.",
                xp: 14,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_wildcard",
                title: "Wildcard invite",
                detail: "Je hebt iemand uitgenodigd voor een spontane activiteit (climbing, museum, silent disco).",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "passport_nature_reset",
                title: "Nature reset",
                detail: "Minstens 2 uur off-grid in de natuur met journal of schetsboek.",
                xp: 24,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let legacyImpact = CategoryPack(
        id: "legacy_impact",
        title: "Legacy & Impact",
        subtitle: "Bouw iets dat groter is dan jezelf",
        iconSystemName: "hand.heart.fill",
        accentColorHex: "#10B981",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "legacy_cause",
                title: "Pick a cause",
                detail: "Één thema gekozen waar je 12 maanden aan wil bijdragen (klimaat, jeugd, gelijkheid).",
                xp: 20,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "legacy_give",
                title: "Automate giving",
                detail: "Automatische maandelijkse bijdrage opgezet of tijd geblokt voor vrijwilligerswerk.",
                xp: 24,
                dimensions: [.money, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_workshop",
                title: "Teach your craft",
                detail: "Een workshop of online sessie gegeven over iets waar jij goed in bent.",
                xp: 26,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_mentor",
                title: "Mentor iemand",
                detail: "Een mentee gevonden en minstens 2 sessies gedaan met duidelijke doelen.",
                xp: 22,
                dimensions: [.love, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "legacy_story_archive",
                title: "Story archive",
                detail: "Een familiestuk, community-archief of audio-story gemaakt dat later nog bestaat.",
                xp: 30,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "legacy_micro_fund",
                title: "Micro-fund",
                detail: "Een mini-budget apart gezet om ideeën van vrienden of buurt te sponsoren.",
                xp: 18,
                dimensions: [.money, .love],
                isPremium: false
            )
        ]
    )

    static let luxuryCalm = CategoryPack(
        id: "luxury_calm",
        title: "Luxury Calm",
        subtitle: "High-end selfcare die je standaard optilt",
        iconSystemName: "sparkles.tv.fill",
        accentColorHex: "#A855F7",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "calm_spa_day",
                title: "Spa + sauna day",
                detail: "Een halve dag ingepland met spa, sauna of hammam zonder telefoon.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_sleep_sanctuary",
                title: "Sleep sanctuary",
                detail: "Je slaapkamer geüpgradet (licht, geur, lakens) voor elite slaap hygiene.",
                xp: 24,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_digital_sabbath",
                title: "Digital sabbath",
                detail: "Een wekelijkse dag zonder social media en nieuws, gevuld met analoge dingen.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_personal_chef",
                title: "Chef-mode dinner",
                detail: "Eén keer per maand een restaurant-level maaltijd gekookt of chef aan huis geboekt.",
                xp: 26,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_retreat",
                title: "Silent retreat",
                detail: "Een 1-3 daagse retreat gedaan voor stilte, breathwork of mindfulness.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "calm_beauty_ritual",
                title: "Beauty ritual",
                detail: "Een skincare/grooming-ritueel ingepland dat je 21 dagen hebt volgehouden.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let healthKit = CategoryPack(
        id: "health_kit",
        title: "Health Kit",
        subtitle: "Core health basics voor elke speler",
        iconSystemName: "cross.case.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "health_baseline_checks",
                title: "Baseline check-up",
                detail: "Bloedonderzoek, tandarts en huisarts in de afgelopen 12 maanden geregeld.",
                xp: 28,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_sleep_consistency",
                title: "Sleep consistency",
                detail: "14 dagen lang binnen hetzelfde 60-minutenvenster naar bed en opstaan.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_steps_tracking",
                title: "7k stappen streak",
                detail: "Minstens 7.000 stappen per dag, 10 dagen achter elkaar gehaald.",
                xp: 22,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_meal_prep",
                title: "Meal prep ready",
                detail: "Twee weken achter elkaar 3 gezonde lunches of diners per week voorbereid.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_mobility_reset",
                title: "Mobility reset",
                detail: "10 minuten mobiliteit of stretchen op 10 verschillende dagen gedaan.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_morning_light",
                title: "Morning sunlight",
                detail: "7 dagen op rij binnen 60 minuten na het opstaan buiten daglicht gepakt.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let socialConfidence = CategoryPack(
        id: "social_confidence",
        title: "Social Confidence",
        subtitle: "Van awkward naar aanwezig",
        iconSystemName: "person.3.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "social_coffee_chat",
                title: "2 coffee chats",
                detail: "Twee mensen benaderd voor een koffietje om iets nieuws te leren of te connecten.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_micro_event",
                title: "Host a micro-event",
                detail: "Vier mensen samengebracht voor een spelletjesavond, diner of wandeling.",
                xp: 24,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_public_question",
                title: "Stel de eerste vraag",
                detail: "Tijdens een event of meeting bewust de eerste vraag gesteld of gedeeld.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_followups",
                title: "DM follow-ups",
                detail: "Na een event drie mensen een DM gestuurd om contact te behouden.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_feedback_round",
                title: "Feedback rondje",
                detail: "Aan drie mensen feedback gevraagd over hoe je overkomt en wat sterker kan.",
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
                detail: "60 minuten al je dagelijkse prikkels in kaart gebracht en per bron beslist: keep, cut, delegate of automatiseren.",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_weekly_rhythm",
                title: "Weekly rhythm map",
                detail: "Een visuele map gemaakt van je week met vaste focusblokken, recovery slots, sociale touchpoints en chore-time.",
                xp: 26,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_skill_stack",
                title: "Skill stack refresh",
                detail: "3 skills gekozen die je in 90 dagen wil stacken, plus micro-practices en meetmomenten vastgelegd.",
                xp: 32,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_body_baseline",
                title: "Body baseline",
                detail: "Slaap, voeding, beweging en labs gelogd in één dashboard zodat je je echte baseline kent.",
                xp: 28,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_connection_squad",
                title: "Connection squad",
                detail: "Een vaste groep van 3-5 mensen samengesteld met maandelijkse meetups en een gedeelde accountability thread.",
                xp: 24,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_risk_rep",
                title: "Risk rep",
                detail: "Iets gedaan met berekend risico (investering, pitch, performance) en achteraf lessons & SOP genoteerd.",
                xp: 34,
                dimensions: [.adventure, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_inbox_zero",
                title: "Inbox zero protocol",
                detail: "Voor e-mail, DM's en to-do's één weekly protocol opgesteld en twee weken volgehouden.",
                xp: 20,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_personal_os",
                title: "Personal OS",
                detail: "Een eigen ‘operating system’ uitgewerkt met dashboards voor doelen, projecten, habits en reflecties.",
                xp: 36,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_rest_day",
                title: "Deliberate rest day",
                detail: "Een volledige dag zonder productiviteit, volledig gepland rond herstel, spel en traagheid.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_reputation_loop",
                title: "Reputation loop",
                detail: "Bewust 3 reputatie-moves gedaan: iets publiceren, iemand helpen, iets leren en delen.",
                xp: 30,
                dimensions: [.money, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_focus_retreat",
                title: "Solo focus retreat",
                detail: "48 uur weg (of thuis) geweest met één duidelijk deliverable en geen notificaties.",
                xp: 26,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_money_flow",
                title: "Money flow redesign",
                detail: "Cashflow, buffers en investeringen opnieuw ingedeeld met automatische transfers en guardrails.",
                xp: 34,
                dimensions: [.money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_identity_script",
                title: "Identity script",
                detail: "Een 1-pager geschreven over wie je aan het worden bent, met bewijs-stapjes en een ritueel om het te lezen.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "mega_mentor_circuit",
                title: "Mentor circuit",
                detail: "Twee mentoren benaderd + een peer gekozen, maandelijkse check-ins gepland en verwachtingen afgestemd.",
                xp: 28,
                dimensions: [.love, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_artifact_drop",
                title: "Artifact drop",
                detail: "Eén tastbaar of digitaal artefact gecreëerd dat je publiekelijk gedeeld hebt (guide, mini-course, tool).",
                xp: 32,
                dimensions: [.adventure, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "mega_legacy_note",
                title: "Legacy note",
                detail: "Een brief geschreven voor je toekomstige zelf of iemand die belangrijk is en in een veilige plek bewaard.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let studentSurvival = CategoryPack(
        id: "student_survival",
        title: "Student Survival",
        subtitle: "Voor iedereen die probeert niet te verdrinken in lessen, deadlines en rommelige kotkamers.",
        iconSystemName: "graduationcap.fill",
        accentColorHex: "#3B82F6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "student_syllabus_check",
                title: "Syllabus reality check",
                detail: "Alle vakken en belangrijke deadlines in één overzicht gezet.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "student_study_spot",
                title: "Blokplek gekozen",
                detail: "Een vaste plek gekozen om te studeren (thuis, bib of koffiebar).",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "student_budget",
                title: "Kot-budget gemaakt",
                detail: "Een weekbudget bepaald voor eten, uitgaan en vervoer.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let movingOut = CategoryPack(
        id: "moving_out_first_place",
        title: "Moving Out & First Place",
        subtitle: "Van ‘bij ouders’ naar ‘eigen plek, eigen regels’.",
        iconSystemName: "house.fill",
        accentColorHex: "#F59E0B",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "moving_inventory",
                title: "Basisinventaris gemaakt",
                detail: "Een lijst van écht noodzakelijke spullen opgesteld.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "moving_fixed_costs",
                title: "Vaste kosten berekend",
                detail: "Huur, energie, internet en verzekeringen in kaart gebracht.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "moving_housewarming",
                title: "Mini housewarming",
                detail: "Een kleine avond met vrienden of familie georganiseerd.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let newCity = CategoryPack(
        id: "new_city_starter",
        title: "New City Starter Pack",
        subtitle: "Je woont in een nieuwe stad en wil je er niet verloren voelen.",
        iconSystemName: "mappin.and.ellipse",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "newcity_mark_spots",
                title: "3 plekken markeren",
                detail: "Supermarkt, ontspanningsplek en nood-apotheek gemarkeerd.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "newcity_coffee_base",
                title: "Koffiebar-found",
                detail: "Een plek gevonden waar je je alleen comfortabel voelt.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "newcity_walk",
                title: "Neighborhood walk",
                detail: "Bewust zonder Google Maps je wijk verkend.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let socialConfidenceBasics = CategoryPack(
        id: "social_confidence_basics_pack",
        title: "Social Confidence Basics",
        subtitle: "Minder awkward in gesprekken zonder jezelf te forceren.",
        iconSystemName: "person.2.fill",
        accentColorHex: "#A855F7",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "social_new_person",
                title: "1 nieuwe persoon aangesproken",
                detail: "Kleine praat gemaakt in winkel, bar of werk.",
                xp: 12,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_honest_cancel",
                title: "Eerlijk ‘ik ben moe’ gezegd",
                detail: "Een afspraak afgezet zonder smoes.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "social_boundary_check",
                title: "Grenzen-check",
                detail: "Drie situaties opgeschreven waarin je eigenlijk ‘nee’ wilde zeggen.",
                xp: 14,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let deepFriendships = CategoryPack(
        id: "deep_friendships",
        title: "Deep Friendships",
        subtitle: "Niet 100 oppervlakkige contacten maar 3–5 mensen die echt tellen.",
        iconSystemName: "person.3.fill",
        accentColorHex: "#EC4899",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "friendship_top3",
                title: "Top-3 mensen gekozen",
                detail: "De mensen gekozen die je meer aandacht wilt geven.",
                xp: 10,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_quality_time",
                title: "Quality time gepland",
                detail: "Een 1-op-1 moment gepland zonder telefoon.",
                xp: 12,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_checkin",
                title: "Eerlijke check-in",
                detail: "Iemand gevraagd hoe het echt gaat.",
                xp: 12,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let familyBoundaries = CategoryPack(
        id: "family_boundaries_peace",
        title: "Family Boundaries & Peace",
        subtitle: "Voor iedereen met een familie die… ingewikkeld is.",
        iconSystemName: "shield.lefthalf.fill",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "family_red_flags",
                title: "Rode vlaggen benoemd",
                detail: "Genoteerd wat je triggert bij familie.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "family_soft_boundary",
                title: "1 zachte grens gezet",
                detail: "Een klein ‘ik doe dat liever niet’ uitgesproken.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "family_step_back",
                title: "Uit contact stappen",
                detail: "Bewust een ruziegeval niet via WhatsApp laten ontploffen.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let singleEra = CategoryPack(
        id: "single_era_solo",
        title: "Single Era – Solo Life",
        subtitle: "Niet wachten tot je ‘iemand’ hebt; dit is je main character season.",
        iconSystemName: "person.fill.badge.plus",
        accentColorHex: "#7C3AED",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "single_solo_date",
                title: "Solo date gepland",
                detail: "Cinema, koffie, museum of wandeling alleen ingepland.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "single_vision",
                title: "Vision zonder partner",
                detail: "Opgeschreven hoe je leven eruit mag zien als je alleen blijft.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "single_detox",
                title: "Social media detox van exen",
                detail: "Exen en situationships uit je feeds gefilterd.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let careerStarter = CategoryPack(
        id: "career_starter",
        title: "Career Starter / First Job",
        subtitle: "Voor je eerste job/stage: minder imposter, meer rust.",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "career_goals_firstyear",
                title: "Job-doelen uitgeschreven",
                detail: "Opgeschreven wat je wil leren in je eerste jaar.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_feedback",
                title: "Feedback gevraagd",
                detail: "Actief om eerlijke feedback gevraagd.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_commute_ritual",
                title: "Commute-routine",
                detail: "Standaard muziek, podcast of ritueel voor onderweg bepaald.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let careerPivot = CategoryPack(
        id: "career_pivot",
        title: "Career Pivot & Doubt",
        subtitle: "Twijfel aan je job zonder op autopilot te blijven.",
        iconSystemName: "arrow.triangle.2.circlepath",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "career_diary",
                title: "Eerlijk jobdagboek",
                detail: "Eén week per dag 3 bullets: energiegevers en -zuigers.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_alternatives",
                title: "Alternatieven verkennen",
                detail: "Drie andere beroepen of sectoren uitgezocht.",
                xp: 14,
                dimensions: [.money, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "career_informational_chat",
                title: "1 gesprek met iemand die anders werkt",
                detail: "Een informele call of koffie geregeld om te leren.",
                xp: 16,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let freelanceFoundations = CategoryPack(
        id: "freelance_foundations",
        title: "Freelance & Side Hustle Foundations",
        subtitle: "Voor iedereen die stiekem liever zijn eigen dingen doet.",
        iconSystemName: "eurosign.circle.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "freelance_value_prop",
                title: "Mini value-prop geschreven",
                detail: "In één zin: wat bied jij en voor wie?",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "freelance_first_euro",
                title: "Eerste € verdient",
                detail: "Ongeacht bedrag minstens één keer betaald werk gedaan.",
                xp: 16,
                dimensions: [.money, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "freelance_admin_folder",
                title: "Basis administratie-mapje gemaakt",
                detail: "Facturen en kosten gestructureerd opgeslagen.",
                xp: 12,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let digitalHygiene = CategoryPack(
        id: "digital_hygiene",
        title: "Digital Hygiene & Detox",
        subtitle: "Minder doomscrolling, minder ruis, meer headspace.",
        iconSystemName: "iphone.gen3.slash",
        accentColorHex: "#8B5CF6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "digital_homescreen",
                title: "Homescreen clean-up",
                detail: "Eén pagina met alleen essentials gemaakt.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "digital_notifications",
                title: "Notificatie-killer",
                detail: "Push uit voor minstens drie apps gezet.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "digital_phone_free",
                title: "Phone-free blok",
                detail: "Twee uur bewust zonder telefoon gegaan.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let sleepRest = CategoryPack(
        id: "sleep_rest_foundations",
        title: "Sleep & Rest Foundations",
        subtitle: "Geen perfecte 5 AM grind, gewoon minder gesloopt wakker worden.",
        iconSystemName: "bed.double.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "sleep_goal",
                title: "Realistische slaapdoel gekozen",
                detail: "Aantal uren bepaald dat bij jou past.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "sleep_wind_down",
                title: "Wind-down signaal",
                detail: "Vaste reminder of ritueel 30 minuten voor slapen ingesteld.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "sleep_bed_only",
                title: "Bed alleen voor slapen",
                detail: "Een week niet in bed gescrold of gewerkt.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let foodEnergy = CategoryPack(
        id: "food_energy",
        title: "Food & Energy",
        subtitle: "Niet afvallen, maar beter voelen in je lichaam.",
        iconSystemName: "fork.knife",
        accentColorHex: "#84CC16",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "food_mindful_meal",
                title: "1 maaltijd bewust gegeten",
                detail: "Zonder scherm en echt proeven.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "food_energy_tracker",
                title: "Energie-tracker",
                detail: "Drie dagen bijgehouden welke maaltijden je crash geven.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "food_new_meal",
                title: "Fun nieuwe maaltijd geprobeerd",
                detail: "Een nieuw recept of keuken getest.",
                xp: 12,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let movementBody = CategoryPack(
        id: "movement_body_respect",
        title: "Movement & Body Respect Basics",
        subtitle: "Bewegen als respect voor je lijf zonder bodyshaming.",
        iconSystemName: "figure.walk",
        accentColorHex: "#10B981",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "movement_ten_walk",
                title: "10-minuten-walk",
                detail: "Drie dagen na elkaar een 10-minutenwandeling gedaan.",
                xp: 10,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "movement_daily_stretch",
                title: "Stretch-moment",
                detail: "Vijf minuten per dag gestretcht.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "movement_fun_activity",
                title: "1 actieve activiteit die niet sporten voelt",
                detail: "Iets actiefs gedaan dat vooral leuk was (dans, zwemmen, klimmen).",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let creativityPassion = CategoryPack(
        id: "creativity_passion_projects",
        title: "Creativity & Passion Projects",
        subtitle: "Voor iedereen die ideeën heeft maar nooit eraan begint.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F472B6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "creativity_idea_dump",
                title: "Ideeën-dump",
                detail: "Alles wat je ooit wou maken opgeschreven.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creativity_micro_session",
                title: "1 micro-sessie",
                detail: "15 minuten aan één project gewerkt.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creativity_mini_launch",
                title: "Mini launch",
                detail: "Iets online gezet, ongeacht perfectie.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let selfCompassion = CategoryPack(
        id: "self_compassion_voice",
        title: "Self-Compassion & Inner Voice",
        subtitle: "Minder innerlijke bully, meer inner coach.",
        iconSystemName: "heart.text.square.fill",
        accentColorHex: "#F43F5E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "compassion_rewrite",
                title: "1 negatieve gedachte herschreven",
                detail: "Een harde gedachte naar iets milders herschreven.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "compassion_letter",
                title: "Brief naar jezelf",
                detail: "Een brief geschreven zoals aan een goede vriend(in).",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "compassion_win_list",
                title: "Win-lijstje",
                detail: "Tien dingen genoteerd die je de laatste jaren goed deed.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let everydayCalm = CategoryPack(
        id: "everyday_calm",
        title: "Everyday Calm & Overwhelm",
        subtitle: "Niet geen stress, maar iets minder ‘alles is te veel’.",
        iconSystemName: "brain.head.profile",
        accentColorHex: "#38BDF8",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "calm_radar",
                title: "Overwhelm radar",
                detail: "Drie triggers voor stressniveau herkend.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_reset_ritual",
                title: "Mini reset-ritueel",
                detail: "Ademhaling, korte wandeling of muziek gekozen als reset.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "calm_half_todos",
                title: "To-do’s gehalveerd",
                detail: "Daglijst gehalveerd naar realistisch niveau.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let lightMinimalism = CategoryPack(
        id: "light_minimalism",
        title: "Light Minimalism & De-Clutter",
        subtitle: "Minder spullen, meer ademruimte.",
        iconSystemName: "trash.circle.fill",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "minimalism_drawer",
                title: "1 lade of plank opgeruimd",
                detail: "Een volledige lade of plank uitgekuist.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "minimalism_clothes_give",
                title: "Kleding-stapel weggeven",
                detail: "Minstens vijf items weggegeven of gedoneerd.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "minimalism_digital_trash",
                title: "Digitale prullenbak",
                detail: "Downloads en screenshots opgeruimd.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let homeVibes = CategoryPack(
        id: "home_vibes_nesting",
        title: "Home Vibes & Nesting",
        subtitle: "Je plek voelt eindelijk als jij.",
        iconSystemName: "lamp.table.fill",
        accentColorHex: "#FDE047",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "home_moodboard",
                title: "Moodboard gemaakt",
                detail: "Een album of Pinterestboard gemaakt voor je ruimte.",
                xp: 10,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "home_corner",
                title: "1 hoekje afgewerkt",
                detail: "Een hoekje afgewerkt met iets kleins dat sfeer brengt.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "home_scent_light",
                title: "Geur & licht check",
                detail: "Bewuste keuze gemaakt voor licht of kaarsen.",
                xp: 10,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let microAdventures = CategoryPack(
        id: "micro_adventures",
        title: "Micro-Adventures & Local Exploration",
        subtitle: "Main character moments zonder vliegtuig.",
        iconSystemName: "figure.hiking",
        accentColorHex: "#0EA5E9",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "micro_new_park",
                title: "Nieuw park of wandeling geprobeerd",
                detail: "Een onbekend park of trail bezocht.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "micro_new_route",
                title: "Andere route naar werk of school",
                detail: "Bewust een andere route genomen.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "micro_free_activity",
                title: "Low budget activiteit gedaan",
                detail: "Een gratis of goedkope activiteit in je stad opgezocht en gedaan.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            )
        ]
    )

    static let moneyResetLite = CategoryPack(
        id: "money_reset_lite",
        title: "Money Reset Lite",
        subtitle: "Minder chaos zonder finfluencer te worden.",
        iconSystemName: "eurosign.arrow.circlepath",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "money_screenshot",
                title: "Geld-screenshot",
                detail: "Banksaldo’s en schulden eerlijk bekeken.",
                xp: 10,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_leaks",
                title: "Top-3 geldlekkages",
                detail: "Geldlekken opgeschreven en één aangepakt.",
                xp: 12,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_mini_savings",
                title: "Mini spaarpotje",
                detail: "Automatische spaaropdracht ingesteld, al is het €10.",
                xp: 14,
                dimensions: [.money, .mind],
                isPremium: false
            )
        ]
    )

    static let coupleDates = CategoryPack(
        id: "couple_dates",
        title: "Couple Dates & Shared Memories",
        subtitle: "Van Netflix en telefoon naar echte herinneringen.",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#EF4444",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "couple_budget_date",
                title: "Low budget date",
                detail: "Een budgetvriendelijke date bedacht en gedaan.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "couple_phonefree",
                title: "Telefoonvrije date",
                detail: "Een avond samen zonder telefoon.",
                xp: 10,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "couple_try_new",
                title: "Samen iets nieuws geprobeerd",
                detail: "Een nieuw spel, activiteit of restaurant getest.",
                xp: 12,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let conflictSkills = CategoryPack(
        id: "conflict_skills_repair",
        title: "Conflict Skills & Repair",
        subtitle: "Niet minder ruzie, maar betere ruzie.",
        iconSystemName: "hands.sparkles.fill",
        accentColorHex: "#14B8A6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "conflict_triggers",
                title: "Triggers van jezelf benoemd",
                detail: "Opgeschreven wat je raakt in conflicten.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "conflict_debrief",
                title: "Conflict ge-debriefed",
                detail: "Na afloop samen ge-debriefd.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "conflict_sorry2",
                title: "Sorry 2.0",
                detail: "Echte sorry uitgesproken met gedrag, gevoel en afspraak.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let boundariesPack = CategoryPack(
        id: "boundaries_saying_no",
        title: "Boundaries & Saying No",
        subtitle: "Voor de people pleasers.",
        iconSystemName: "hand.raised.fill",
        accentColorHex: "#A855F7",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "boundaries_no_excuse",
                title: "1 ‘nee’ gezegd",
                detail: "Een nee gezegd zonder duizend excuses.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "boundaries_script",
                title: "Boundary script geschreven",
                detail: "Een zin bedacht die je kan gebruiken.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "boundaries_energy_vamp",
                title: "Energiezuiger niet toegezegd",
                detail: "Een moment bewust niet toegezegd.",
                xp: 12,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let meaningValues = CategoryPack(
        id: "meaning_values",
        title: "Meaning & Values",
        subtitle: "Als je even niet weet waar je leven heen gaat.",
        iconSystemName: "sparkle.magnifyingglass",
        accentColorHex: "#6366F1",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "meaning_top_values",
                title: "Top-5 waarden gekozen",
                detail: "Een lijst met je vijf belangrijkste waarden gemaakt.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "meaning_activity",
                title: "1 activiteit gekozen",
                detail: "Een activiteit gekozen die twee waarden ondersteunt.",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "meaning_good_year",
                title: "Hoe ziet een goed jaar eruit?",
                detail: "Eerlijk opgeschreven hoe een goed jaar eruitziet voor jou.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let weekendUpgrade = CategoryPack(
        id: "weekend_upgrade",
        title: "Weekend Upgrade Pack",
        subtitle: "Elk weekend net 10% beter dan ‘scrollen en eten’.",
        iconSystemName: "calendar.badge.clock",
        accentColorHex: "#F97316",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "weekend_memorable",
                title: "Weekend-activiteit gepland",
                detail: "Iets ingepland dat je later herinnert.",
                xp: 12,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "weekend_life_admin",
                title: "1 uur life admin",
                detail: "Een uur geblokt voor mail, papieren en planning.",
                xp: 10,
                dimensions: [.mind, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "weekend_rest_block",
                title: "Bewust rustblok",
                detail: "Een blok waarin niets moest maar wel gekozen was.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let seasonalReset = CategoryPack(
        id: "seasonal_reset",
        title: "Seasonal Reset",
        subtitle: "Klein seizoensritueel zodat het jaar niet weg-slipt.",
        iconSystemName: "leaf.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "seasonal_checkin",
                title: "Season check-in",
                detail: "Genoteerd wat je achterlaat en meeneemt.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "seasonal_closet",
                title: "Kleding-seizoen wissel",
                detail: "Kleding gewisseld en weggegeven wat niet meer past.",
                xp: 12,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "seasonal_goal",
                title: "1 seizoensdoel gekozen",
                detail: "Een heel klein doel voor het nieuwe seizoen gekozen.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let healthAdmin = CategoryPack(
        id: "health_admin",
        title: "Health Admin & Self Check-ins",
        subtitle: "Uitgestelde dokters- en tandartsdingen zonder adviezen.",
        iconSystemName: "cross.case.fill",
        accentColorHex: "#0EA4BF",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "health_make_appointment",
                title: "Afspraak effectief gemaakt",
                detail: "Een tandarts- of huisartsafspraak ingepland.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_med_overview",
                title: "Medicatie-overzicht",
                detail: "Overzicht gemaakt van medicatie en supplementen (zonder advies).",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "health_questions_list",
                title: "Vragenlijst voor check-up",
                detail: "Vragen genoteerd voor je volgende consult.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let workLifeBoundaries = CategoryPack(
        id: "work_life_boundaries",
        title: "Work–Life Boundaries",
        subtitle: "Voor iedereen die ’s avonds nog mails leest.",
        iconSystemName: "rectangle.portrait.and.arrow.right",
        accentColorHex: "#60A5FA",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "work_end_ritual",
                title: "Hard einde werkdag",
                detail: "Een uur en ritueel gekozen om af te sluiten.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "work_notifications_limit",
                title: "Werkapps gelimiteerd",
                detail: "Notificaties buiten werkuren beperkt.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "work_evening_free",
                title: "Werkvrije avond",
                detail: "Een avond per week volledig werkvrij gepland.",
                xp: 14,
                dimensions: [.love, .mind],
                isPremium: false
            )
        ]
    )

    static let creatorSocialStarter = CategoryPack(
        id: "creator_social_starter",
        title: "Creator & Social Media Starter",
        subtitle: "Voor wie wil posten of maken maar blokkeert.",
        iconSystemName: "camera.fill",
        accentColorHex: "#F472B6",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "creator_reasons",
                title: "Waarom wil ik creëren?",
                detail: "Drie redenen opgeschreven waarom je wil maken of posten.",
                xp: 12,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_first_post",
                title: "1 imperfecte post",
                detail: "Een post online gezet zonder perfectionisme.",
                xp: 14,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_content_ritual",
                title: "Content-ritueel",
                detail: "Een vast moment per week gekozen om te maken.",
                xp: 12,
                dimensions: [.mind, .money],
                isPremium: false
            )
        ]
    )

    static let lifeChecklist = CategoryPack(
        id: "life_checklist_classic",
        title: "Life Checklist",
        subtitle: "Van geboorte tot bucketlist-momenten",
        iconSystemName: "checkmark.circle.fill",
        accentColorHex: "#2563EB",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "life_be_born",
                title: "👶 Be born",
                detail: "Welkom op de planeet: je eerste XP is binnen.",
                xp: 5,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_steps",
                title: "🚶‍♂️ Take first steps",
                detail: "Die wiebelige meters die de wereld openen.",
                xp: 6,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_words",
                title: "📣 Say first words",
                detail: "Je eerste woorden gedeeld met je wereld.",
                xp: 6,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_learn_read",
                title: "👨‍🏫 Learn to read",
                detail: "Boeken en borden ontgrendeld.",
                xp: 10,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_make_friend",
                title: "🤗 Make a friend",
                detail: "Je eerste echte vriend gevonden.",
                xp: 10,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_ride_bike",
                title: "🚴‍♂️ Learn to ride a bike",
                detail: "Balans, vrijheid en schrammen behaald.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_read_book",
                title: "📗 Read a book",
                detail: "Een compleet boek uitgelezen uit eigen keuze.",
                xp: 8,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_learn_swim",
                title: "🏊‍♂️ Learn to swim",
                detail: "Je eerste baantjes zonder drijfmiddelen.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_finish_elementary",
                title: "🏫 Finish elementary school",
                detail: "Je basisschooltijd afgerond.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_play_sport",
                title: "⚽ Play a sport",
                detail: "Mee gedaan met een sportteam of -club.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_fly_plane",
                title: "🛫 Fly in a plane",
                detail: "Je eerste keer de lucht in gegaan.",
                xp: 12,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_ride_boat",
                title: "🛥️ Ride a boat",
                detail: "Een tocht op het water gemaakt.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_train_trip",
                title: "🚆 Ride in a train",
                detail: "Met de trein een bestemming bereikt.",
                xp: 8,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_helicopter",
                title: "🚁 Ride a helicopter",
                detail: "Een vlucht met uitzicht vanuit een heli meegemaakt.",
                xp: 18,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_see_ocean",
                title: "🌊 See the ocean",
                detail: "Voor het eerst de zee gezien en geroken.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_see_snow",
                title: "❄️ See snow",
                detail: "Sneeuw in het echt meegemaakt.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_make_snowman",
                title: "☃️ Make a snowman",
                detail: "Je eigen sneeuwpop gebouwd.",
                xp: 10,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_finish_middle",
                title: "🏫 Finish middle school",
                detail: "Je middelbare school onderbouw afgerond.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_concert",
                title: "🎶 Go to a concert",
                detail: "Live muziek beleefd met volume en vibes.",
                xp: 14,
                dimensions: [.adventure, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_camping",
                title: "🏕️ Go camping",
                detail: "Een nacht in een tent of onder de sterren geslapen.",
                xp: 14,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_rollercoaster",
                title: "🎢 Ride a rollercoaster",
                detail: "Een achtbaan overleefd en misschien geschreeuwd.",
                xp: 14,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_play_instrument",
                title: "🎻 Play an instrument",
                detail: "Een instrument leren bespelen en laten horen.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_first_kiss",
                title: "💋 Get kissed",
                detail: "Je eerste kus gehad.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_credit_card",
                title: "💳 Get a credit card",
                detail: "Je eerste kredietkaart aangevraagd of gekregen.",
                xp: 16,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_start_driving",
                title: "🚘 Start driving",
                detail: "Je eerste kilometers gereden achter het stuur.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_roadtrip",
                title: "🗺️ Go on a roadtrip",
                detail: "Een trip gepland en gereden met stops en verhalen.",
                xp: 18,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_new_country",
                title: "🗾 Visit another country",
                detail: "Een grens overgestoken en een nieuw land ontdekt.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_public_speech",
                title: "🎤 Give a speech",
                detail: "Voor publiek gesproken zonder wegrennen.",
                xp: 18,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_graduate_highschool",
                title: "🏫 Graduate high school",
                detail: "Je middelbare school diploma in handen.",
                xp: 22,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_second_language",
                title: "🌐 Learn another language",
                detail: "Een nieuwe taal geleerd en gebruikt in gesprek.",
                xp: 22,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_invest_money",
                title: "💸 Invest some money",
                detail: "Je eerste geld belegd of geïnvesteerd.",
                xp: 24,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_meet_idol",
                title: "📷 Meet an idol",
                detail: "Iemand ontmoet die je bewondert.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_big_mistake",
                title: "😩 Make a terrible mistake",
                detail: "Een grote fout gemaakt en ervan geleerd.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_win_trophy",
                title: "🏆 Win a trophy",
                detail: "Een prijs of trofee binnengehaald.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_climb_mountain",
                title: "⛰️ Climb a mountain",
                detail: "Een top gehaald waar je hart van ging kloppen.",
                xp: 24,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_run_marathon",
                title: "🎽 Run a marathon",
                detail: "42 km afgelegd en de finish gehaald.",
                xp: 28,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_learn_cook",
                title: "🍳 Learn to cook",
                detail: "Een maaltijd zelfstandig gekookt die iemand anders lekker vond.",
                xp: 14,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_explore_cave",
                title: "🔦 Explore a cave",
                detail: "Ondergronds avontuur in een grot meegemaakt.",
                xp: 22,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_see_volcano",
                title: "🌋 See a volcano",
                detail: "Een vulkaan van dichtbij gezien.",
                xp: 22,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_graduate_college",
                title: "🎓 Graduate college",
                detail: "Een hbo/uni diploma behaald.",
                xp: 26,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_long_relationship",
                title: "💕 Have a long relationship",
                detail: "Minstens 1 jaar een relatie onderhouden.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_dumped",
                title: "🗑️ Get dumped",
                detail: "Een break-up doorgemaakt en verwerkt.",
                xp: 18,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_sign_contract",
                title: "🖊️ Sign a contract",
                detail: "Je eerste grote contract getekend.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_job",
                title: "🏢 Get a job",
                detail: "Je eerste baan of betaalde gig gestart.",
                xp: 20,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_promoted",
                title: "☝️ Get promoted",
                detail: "Een promotie of stap omhoog gekregen.",
                xp: 22,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_first_paycheck",
                title: "💵 Get a paycheck",
                detail: "Je eerste loon ontvangen en benut.",
                xp: 18,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_get_fired",
                title: "🔥 Get fired",
                detail: "Ontslag meegemaakt en opnieuw gestart.",
                xp: 18,
                dimensions: [.mind, .money],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_in_news",
                title: "📰 Get in the news",
                detail: "Vernoemd of verschenen in media.",
                xp: 18,
                dimensions: [.adventure, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_vote",
                title: "🗳️ Vote in an election",
                detail: "Gestemd in een lokale of landelijke verkiezing.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_switch_careers",
                title: "🤡 Switch careers",
                detail: "Van richting veranderd en opnieuw begonnen.",
                xp: 22,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_buy_house",
                title: "🏠 Buy a house",
                detail: "Een huis gekocht of hypotheek geregeld.",
                xp: 26,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_engaged",
                title: "💍 Get engaged",
                detail: "Verloofd geraakt en het gevierd.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_get_married",
                title: "👰 Get married",
                detail: "Ja gezegd tijdens je huwelijk.",
                xp: 28,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_have_kid",
                title: "👶 Have a kid",
                detail: "Ouder geworden van je eerste kind.",
                xp: 28,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_teach_walk",
                title: "🚶‍♂️ Teach your kid to walk",
                detail: "Samen de eerste stapjes geoefend.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_teach_talk",
                title: "📣 Teach your kid to talk",
                detail: "De eerste woordjes van je kind begeleid.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_watch_kid_graduate",
                title: "🎓 Watch your kid graduate",
                detail: "Aanwezig geweest bij het diploma van je kind.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_watch_kid_marry",
                title: "👰 Watch your kid get married",
                detail: "Je kind het ja-woord zien geven.",
                xp: 26,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_grandparent",
                title: "👴 Become a grandparent",
                detail: "Kleinkinderen verwelkomd in de familie.",
                xp: 24,
                dimensions: [.love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_retire",
                title: "🏖️ Retire",
                detail: "Gestopt met fulltime werk en een nieuw ritme gekozen.",
                xp: 22,
                dimensions: [.mind, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_tell_story",
                title: "📔 Tell your grandkid a story",
                detail: "Een verhaal gedeeld dat de familie bijblijft.",
                xp: 18,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_solar_eclipse",
                title: "🌑 See a solar eclipse",
                detail: "Een zonsverduistering bewust meegemaakt.",
                xp: 20,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_plant_garden",
                title: "🌷 Plant a garden",
                detail: "Zelf iets geplant en zien groeien.",
                xp: 16,
                dimensions: [.mind, .love],
                isPremium: false
            ),
            ChecklistItem(
                id: "life_travel_world",
                title: "🌎 Travel the world",
                detail: "Meerdere continenten bezocht en verhalen verzameld.",
                xp: 30,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_turn_100",
                title: "🎂 Turn 100",
                detail: "Een eeuw leven gevierd.",
                xp: 40,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "life_complete_checklist",
                title: "✔️ Complete Life Checklist",
                detail: "Alle mijlpalen in deze lijst afgevinkt.",
                xp: 50,
                dimensions: [.mind, .adventure],
                isPremium: true
            )
        ]
    )

    static let energyReset = CategoryPack(
        id: "energy_reset",
        title: "Energy Reset",
        subtitle: "Van drained naar opgeladen dagen.",
        iconSystemName: "bolt.heart.fill",
        accentColorHex: "#22D3EE",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "energy_sleep",
                title: "7 nachten slaap-commitment",
                detail: "Een week lang 7-9 uur geslapen met consistente bedtijden.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_walk",
                title: "Daily sunlight walk",
                detail: "5 dagen achter elkaar 20 minuten buiten gelopen.",
                xp: 18,
                dimensions: [.mind, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_meal_prep",
                title: "Meal prep mini",
                detail: "Twee energie-vriendelijke maaltijden voorbereid voor drukke dagen.",
                xp: 14,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "energy_afspraken",
                title: "Rust-blokken gepland",
                detail: "Bewust 3 herstelmomenten ingepland en nagekomen.",
                xp: 16,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "energy_caffeine",
                title: "Caffeine reset",
                detail: "Een week na 14:00 geen cafeïne meer genomen en energiedip gelogd.",
                xp: 20,
                dimensions: [.mind],
                isPremium: true
            )
        ]
    )

    static let creatorMode = CategoryPack(
        id: "creator_mode",
        title: "Creator Mode",
        subtitle: "Van idee naar shippen zonder perfectionisme.",
        iconSystemName: "paintbrush.pointed.fill",
        accentColorHex: "#F59E0B",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "creator_daily_output",
                title: "10 dagen shipping streak",
                detail: "10 dagen achter elkaar iets kleins gedeeld: post, prototype of snippet.",
                xp: 30,
                dimensions: [.adventure, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_feedback_loop",
                title: "Feedback loop",
                detail: "Minstens 3 mensen om gerichte feedback gevraagd en verwerkt.",
                xp: 22,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_system",
                title: "Creator system opgezet",
                detail: "Een repeterend tijdslot, templating of automation aangezet om te blijven posten.",
                xp: 18,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "creator_portfolio",
                title: "Mini-portfolio online",
                detail: "Een eenvoudige landingspagina of highlight reel live gezet.",
                xp: 26,
                dimensions: [.adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "creator_collab",
                title: "Collab gedaan",
                detail: "Samen met iemand anders iets gecreëerd en gedeeld.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            )
        ]
    )

    static let friendshipCare = CategoryPack(
        id: "friendship_care",
        title: "Friendship Care",
        subtitle: "Van losse appjes naar echte support crew.",
        iconSystemName: "hands.sparkles.fill",
        accentColorHex: "#16A34A",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "friendship_checkin",
                title: "3 check-ins",
                detail: "Drie vrienden actief gebeld of gesproken buiten socials om.",
                xp: 14,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_memory",
                title: "Nieuwe gezamenlijke herinnering",
                detail: "Een activiteit gedaan en vastgelegd als inside joke of foto.",
                xp: 18,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_help",
                title: "Helpen zonder terugverwachting",
                detail: "Bewust hulp of tijd gegeven zonder iets terug te verwachten.",
                xp: 16,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "friendship_hard_talk",
                title: "Eerlijk gesprek gevoerd",
                detail: "Een moeilijk onderwerp besproken zonder weg te duiken.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "friendship_followthrough",
                title: "Afspraak nagekomen",
                detail: "Een plan dat jij initieerde ook echt door laten gaan.",
                xp: 12,
                dimensions: [.love],
                isPremium: false
            )
        ]
    )

    static let calmFocus = CategoryPack(
        id: "calm_focus",
        title: "Calm Focus",
        subtitle: "Van chaos naar heldere dagen.",
        iconSystemName: "target",
        accentColorHex: "#EF4444",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "focus_daily_plan",
                title: "Dagstart met intentie",
                detail: "5 dagen begonnen met een top-3 en deze geëvalueerd.",
                xp: 18,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "focus_deep_work",
                title: "3 deep work blocks",
                detail: "Drie sessies van 90 minuten zonder afleiding voltooid.",
                xp: 24,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "focus_inbox_zero",
                title: "Inbox reset",
                detail: "Inbox of takenlijst opgeschoond en georganiseerd.",
                xp: 16,
                dimensions: [.mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "focus_boundaries",
                title: "Context switch kill-switch",
                detail: "Notificaties beperkt en focus-modi ingesteld voor werk/privé.",
                xp: 20,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "focus_review",
                title: "Weekreview",
                detail: "Eén uur genomen om wins, leercurve en volgende moves te noteren.",
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
