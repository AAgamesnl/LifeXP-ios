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

    static let all: [CategoryPack] = [
        relationshipCore,
        glowUp,
        breakupHealing,
        moneyCareer,
        adulting,
        adventure
    ]

    /// Items that should be hidden when the user enables safe mode.
    static let heavyItemIDs: Set<String> = [
        "breakup_no_contact",
        "breakup_lessons",
        "breakup_selfdate",
        "adult_health_check"
    ]
}
