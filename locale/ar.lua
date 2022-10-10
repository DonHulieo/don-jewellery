local Translations = {
    error = {
        fingerprints = 'لقد ترك بصمة على الزجاج',
        minimum_police = 'شرطي %{value} يلزم توجد',
        wrong_weapon = 'سلاحك ليس قويا بما فيه الكفاية',
        to_much = 'لديك الكثير في حقيبتك'
    },
    success = {},
    info = {
        progressbar = 'جاري الكسر',
    },
    general = {
        target_label = 'تحطيم و كسر',
        drawtextui_grab = '[E] تحطيم الشباك',
        drawtextui_broken = 'الحالة: مكسورة'
    }
}

if GetConvar('qb_locale', 'en') == 'ar' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
