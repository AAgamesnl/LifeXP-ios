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

    static let megaVault = MegaPackLibrary.vault

    static let all: [CategoryPack] = [
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
        luxuryCalm
    ] + megaVault

    /// Items that should be hidden when the user enables safe mode.
    static let heavyItemIDs: Set<String> = [
        "breakup_no_contact",
        "breakup_lessons",
        "breakup_selfdate",
        "adult_health_check",
        "wellness_therapy_consult"
    ]
}
