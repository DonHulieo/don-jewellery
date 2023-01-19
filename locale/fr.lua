local Translations = {
    error = {
        fingerprints = 'Tu as laissé une empreinte sur la vitre',
        minimum_police = 'Il faut un minimum de %{value} policiers pour commencer',
        wrong_weapon = 'Ton arme n\'est pas suffisament forte ou efficace...',
        stores_open = 'Je devrais le faire une fois que le magasin est fermé...',
        to_much = 'Tu as trop dans tes poches'
    },
    success = {},
    info = {
        progressbar = 'Brisage de la vitrine d\'exposition',
    },
    general = {
        target_label = 'Brise la vitrine d\'exposition',
        drawtextui_grab = '[E] Brise la vitrine',
        drawtextui_broken = 'La vitrine est brisée'
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end