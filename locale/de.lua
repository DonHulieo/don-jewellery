local Translations = {
    error = {
        fingerprints = 'Du hast Fingerabdrücke am Glas hinterlassen...',
        minimum_police = '%{value} Polizisten benötigt',
        wrong_weapon = 'Deine Waffe ist nicht stark genug..',
        to_much = 'Du hast zu viel in deinen Taschen!'
    },
    success = {},
    info = {
        progressbar = 'Glas brechen',
    },
    general = {
        target_label = 'Vitrine aufbrechen',
        drawtextui_grab = '~o~[~b~E~o~]~w~ um aufzubrechen',
        drawtextui_broken = 'AUFGEBROCHEN'
    }
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
