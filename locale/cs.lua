local Translations = {
    error = {
        fingerprints = 'Zanechal jsi otisk prstu..',
        security_active = 'Zabezpečovací systém je aktivní..',
        minimum_police = 'Zabezpečovací systém je aktivní..',
        vitrine_hit = 'Tato vitrína již byla zasažena',
        wrong_weapon = 'Vaše zbraň není dostatečně silná..',
        to_much = 'máš plné kapsy..',
        fail_therm = 'Neaplikovali jste termit správně.',
        wrong_item = 'Nemáte správnou položku..',
        too_far = 'Jsi moc daleko..',
        stores_open = 'Měl bych to zkusit po zavření obchodu..',
        fail_hack = 'Nepodařilo se vám hacknout bezpečnostní systém.',
        skill_fail = 'Vaše %{value} dovednost není dostatečně vysoká..'
    },
    success = {
        thermite = 'Aplikovali jste termit správně.',
        store_hit_threestore = 'Přepálené pojistky, dveře by se měly brzy otevřít..',
        store_hit_onestore = 'Pojistky spálené, dveře by se měly otevřít na %{value} minut',
        hacked_threestore = 'Hack úspěšný, všechny dveře by měly být otevřené..',
        hacked_onestore = 'Hack byl úspěšný, zabezpečení je deaktivováno'
    },
    info = {
        smashing_progress = 'Rozbití vitríny',
        hacking_attempt = 'Připojení k zabezpečovacímu systému..',
        one_store_warning = 'Pospěš si! Obchod se zavře za %{value} minutu'
    },
    general = {
        target_label = 'Rozbijte vitrínu',
        drawtextui_grab = '[E] Rozbijte vitrínu',
        drawtextui_broken = 'Vitrína je rozbitá'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
