local Translations = {
    error = {
        fingerprints = 'Zanechal jsi otiskl prstu na skle',
        minimum_police = 'Je potřeba %{value} policistů',
        wrong_weapon = 'Tvoje zbraň není dost silná..',
        to_much = 'Máš moc plné kapsy'
    },
    success = {},
    info = {
        progressbar = 'Rozbíjení vitríny',
    },
    general = {
        target_label = 'Rozbij vitrínu',
        drawtextui_grab = '[E] Rozbij vitrínu',
        drawtextui_broken = 'Vitrína je již rozbitá'
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
