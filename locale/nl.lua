local Translations = {
    error = {
        fingerprints = 'Je hebt een vingerafdruk achtergelaten..',
        security_active = 'Het beveiligingssysteem is actief..',
        minimum_police = 'Minimaal %{value} politie nodig',
        vitrine_hit = 'Deze vitrine is al geraakt',
        wrong_weapon = 'Je wapen is niet sterk genoeg..',
        to_much = 'Je zakken zijn vol..',
        fail_therm = 'Je hebt de thermiet niet goed aangebracht..',
        wrong_item = 'Je hebt niet het juiste item..',
        too_far = 'Je bent te ver weg..',
        stores_open = 'Ik zou het moeten proberen nadat de winkel sluit..',
        fail_hack = 'Je hebt het beveiligingssysteem niet gehackt..',
        skill_fail = 'Je %{value} vaardigheid is niet hoog genoeg..'
    },
    success = {
        thermite = 'Je hebt de thermiet correct aangebracht..',
        store_hit_threestore = 'Zekeringen gesprongen, de deuren zouden spoedig open moeten gaan..',
        store_hit_onestore = 'Zekeringen doorgebrand, de deuren zouden %{value} minuten open moeten gaan',
        hacked_threestore = 'Hack succesvol, alle deuren zouden open moeten zijn..',
        hacked_onestore = 'Hack geslaagd, beveiliging is uitgeschakeld'
    },
    info = {
        smashing_progress = 'De vitrine kapot maken',
        hacking_attempt = 'Verbinding maken met het beveiligingssysteem..',
        one_store_warning = 'Haast je! De winkel sluit over %{value} minuut'
    },
    general = {
        target_label = 'Smash de vitrine',
        drawtextui_grab = '[E] Smash de vitrine',
        drawtextui_broken = 'Vitrinekast is kapot'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
