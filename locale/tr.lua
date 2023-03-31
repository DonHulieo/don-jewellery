local Translations = {
    error = {
        fingerprints = 'Bir parmak izi bıraktın..',
        security_active = 'Güvenlik sistemi aktif..',
        minimum_police = 'Minimum %{value} polis gerekli',
        vitrine_hit = 'Bu vitrin zaten vuruldu',
        wrong_weapon = 'Silahın yeterince güçlü değil..',
        to_much = 'cepleriniz dolu..',
        fail_therm = 'Termiti doğru uygulamamışsın..',
        wrong_item = 'Doğru öğeye sahip değilsin..',
        too_far = 'Sen çok uzaksın..',
        stores_open = 'Mağaza kapandıktan sonra denemeliyim..',
        fail_hack = 'Güvenlik sistemini hacklemeyi başaramadınız..',
        skill_fail = '%{value} beceriniz yeterince yüksek değil..'
    },
    success = {
        thermite = 'Termiti doğru uygulamışsınız..',
        store_hit_threestore = 'Sigortalar atmış kapılar bir an önce açılsın..',
        store_hit_onestore = 'Sigortalar atmış, kapılar %{value} dakika süreyle açılmalıdır',
        hacked_threestore = 'Hack başarılı, tüm kapılar açık olmalı..',
        hacked_onestore = 'Hack başarılı, güvenlik devre dışı'
    },
    info = {
        smashing_progress = 'vitrinin parçalanması',
        hacking_attempt = 'Güvenlik sistemine bağlanılıyor..',
        one_store_warning = 'Acele etmek! Mağaza %{value} dakika içinde kapanacak'
    },
    general = {
        target_label = 'Vitrini parçala',
        drawtextui_grab = '[E] Vitrini parçala',
        drawtextui_broken = 'Vitrin kırıldı'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
