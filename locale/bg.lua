local Translations = {
    error = {
        fingerprints = 'Остави отпечатък',
        security_active = 'Системата за сигурност е активна...',
        minimum_police = 'Трябва да има поне %{value} полицая в града',
        vitrine_hit = 'Вече си счупил тази витрина',
        wrong_weapon = 'Оръжието ти не става за нищо',
        to_much = 'Пълни са ти джобовете',
        fail_therm = 'Не приложи термита правилно',
        wrong_item = 'Нямаш правилния предмет',
        too_far = 'Твърде далече си',
        stores_open = 'Магазина е отворен',
        fail_hack = 'Не успя да хакнеш системата за сигурност',
        skill_fail = 'Не си достатъчно оптиен',
        store_hit = 'Бушоните вече са изгърмяли'
    },
    success = {
        thermite = 'Приложи термит',
        store_hit_threestore = 'Бушоните гръмнаха, вратите ще се отворят',
        store_hit_onestore = 'Бушоните гръмнаха, вратите ще са отворени за %{value} минути', --'Бушоните гръмнаха, резервния генератор ще се активира след %{value} минути'
        hacked_threestore = 'Успя да го хакнеш, вратите ще се отворят',
        hacked_onestore = 'Успя да го хакнеш, системата за сигурност ще спре'
    },
    info = {
        smashing_progress = 'Разбиваш',
        hacking_attempt = 'Свързваш се към системата за сигурност',
        one_store_warning = 'Побързай, магазина ще се затвори след %{value} минути'
    },
    general = {
        target_label = 'Разбий витрина',
        drawtextui_grab = '[E] Разбий витрина',
        drawtextui_broken = 'Витрината е разбита'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
