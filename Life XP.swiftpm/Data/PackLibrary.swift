import Foundation

/// Static library of checklist packs used by the prototype.
enum PackLibrary {
    static let relationshipCore = CategoryPack(
        id: "relationship_core",
        title: "Relationship Core",
        subtitle: "Van situationship naar eerlijk samen, zonder drama.",
        iconSystemName: "heart.circle.fill",
        accentColorHex: "#FF3B6A",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "rel_values_talk",
                title: "Gesprek over waarden & toekomst",
                detail: "Jullie hebben bewust gepraat over geld, kinderen, wonen en hoe jullie het willen bouwen.",
                xp: 25,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_first_trip",
                title: "Eerste trip samen overleefd",
                detail: "Een weekend of langer samen weg geweest en er sterker uit gekomen.",
                xp: 20,
                dimensions: [.love, .adventure],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_conflict_clean",
                title: "Conflict clean-up",
                detail: "Na een ruzie hebben jullie echt geluisterd, sorry gezegd en nieuwe afspraken gemaakt.",
                xp: 30,
                dimensions: [.love, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "rel_geld_gesprek",
                title: "Geld zonder drama",
                detail: "Eerlijk gesprek gehad over schulden, sparen en uitgaven zonder dat het escaleerde.",
                xp: 25,
                dimensions: [.love, .money],
                isPremium: true
            ),
            ChecklistItem(
                id: "rel_repair_ritual",
                title: "Monthly repair ritual",
                detail: "Elke maand een uur ingepland om irritaties, verwachtingen en plannen bij te stellen.",
                xp: 30,
                dimensions: [.love],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_love_languages",
                title: "Love languages reality-check",
                detail: "Getest wat elkaars echte liefdetaal is en hoe je dat dagelijks toepast.",
                xp: 20,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "rel_emergency_plan",
                title: "Emergency plan als team",
                detail: "Wie bel je bij pech? Hoe regel je zorg? Er is een plan dat rust geeft in crisismomenten.",
                xp: 25,
                dimensions: [.love, .mind],
                isPremium: true
            )
        ]
    )

    static let glowUp = CategoryPack(
        id: "glow_up_era",
        title: "Glow-Up Era",
        subtitle: "Level up in looks, habits en energie zonder toxic hustle.",
        iconSystemName: "sparkles",
        accentColorHex: "#7C3AED",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "glow_basic_routine",
                title: "Routine locked in",
                detail: "Minstens 30 dagen een ochtend- of avondroutine volgehouden die je écht helpt.",
                xp: 30,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_friend_check",
                title: "Friend audit",
                detail: "Eerlijk gekeken wie je energie geeft en welke connecties je losser laat.",
                xp: 20,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_style_update",
                title: "Style refresh",
                detail: "Je kleding bewust geüpdatet naar hoe jij jezelf in je ‘main character era’ ziet.",
                xp: 25,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_hard_thing",
                title: "Eén hard ding per dag",
                detail: "Minstens 14 dagen elke dag iets gedaan waar je tegenop zag en het toch gefixt.",
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
                detail: "10 kracht-workouts voltooid in 30 dagen en progressie bijgehouden.",
                xp: 32,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "glow_signature_scent",
                title: "Signature look & scent",
                detail: "Een kenmerkende look en geur gevonden waar je je krachtig in voelt.",
                xp: 18,
                dimensions: [.mind, .love],
                isPremium: false
            )
        ]
    )

    static let breakupHealing = CategoryPack(
        id: "breakup_healing",
        title: "Breakup & Healing",
        subtitle: "Van delulu naar rustig en glowend vooruit.",
        iconSystemName: "bandage.fill",
        accentColorHex: "#EC4899",
        isPremium: true,
        items: [
            ChecklistItem(
                id: "breakup_no_contact",
                title: "30 dagen no contact",
                detail: "30 dagen geen contact gezocht met je ex en ook niet stiekem gestalkt.",
                xp: 40,
                dimensions: [.mind, .love],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_lessons",
                title: "3 lessen opgeschreven",
                detail: "Eerlijk opgeschreven wat jij hebt geleerd uit de relatie én de breakup.",
                xp: 25,
                dimensions: [.mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_selfdate",
                title: "Solo 'ex-date' ervaring",
                detail: "Iets gedaan wat je normaal samen deed, maar nu alleen – op jouw manier.",
                xp: 30,
                dimensions: [.mind, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "breakup_support_circle",
                title: "Support circle",
                detail: "3 mensen benoemd die je mag bellen als je wil terugvallen en hen dat verteld.",
                xp: 18,
                dimensions: [.love, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "breakup_new_story",
                title: "Nieuwe narratief",
                detail: "Opgeschreven wie je nu wordt zonder hen en welke waarden daarbij horen.",
                xp: 24,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let moneyCareer = CategoryPack(
        id: "money_career",
        title: "Money & Career",
        subtitle: "Van chaos naar ‘I’ve got this’.",
        iconSystemName: "briefcase.fill",
        accentColorHex: "#22C55E",
        isPremium: false,
        items: [
            ChecklistItem(
                id: "money_buffer",
                title: "Eerste spaarbuffer",
                detail: "Een buffer van minstens één maand vaste lasten opgebouwd.",
                xp: 30,
                dimensions: [.money, .mind],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_budget_flow",
                title: "Budget dat ademt",
                detail: "Maandbudget gemaakt met ruimte voor fun én sparen.",
                xp: 25,
                dimensions: [.money],
                isPremium: false
            ),
            ChecklistItem(
                id: "money_salary_talk",
                title: "Salarisgesprek gevoerd",
                detail: "Een gesprek gehad over salaris of rol, met voorbereiding en follow-up.",
                xp: 30,
                dimensions: [.money, .mind],
                isPremium: true
            ),
            ChecklistItem(
                id: "money_side_project",
                title: "Side income gestart",
                detail: "Eerste euro verdiend met een eigen aanbod of freelance klus.",
                xp: 35,
                dimensions: [.money, .adventure],
                isPremium: true
            ),
            ChecklistItem(
                id: "money_career_map",
                title: "Career map",
                detail: "Een 12-maands plan gemaakt met 3 stappen die je skills of salaris verhogen.",
                xp: 28,
                dimensions: [.mind],
                isPremium: false
            )
        ]
    )

    static let all: [CategoryPack] = [
        relationshipCore,
        glowUp,
        breakupHealing,
        moneyCareer
    ]

    static let heavyItemIDs: Set<String> = [
        "breakup_no_contact",
        "glow_hard_thing",
        "money_side_project"
    ]
}
