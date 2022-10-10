local Translations = {
    error = {
        fingerprints = 'Has dejado una huella en el cristal',
        minimum_police = 'Se necesita un mínimo de %{value} policías',
        wrong_weapon = 'Tu arma no es lo suficientemente fuerte..',
        to_much = 'Tienes demasiado en el bolsillo'
    },
    success = {},
    info = {
        progressbar = 'Rompiendo la vitrina',
    },
    general = {
        target_label = 'Destroza la vitrina',
        drawtextui_grab = '[E] Aplastar la vitrina',
        drawtextui_broken = 'La vitrina está rota'
    }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
