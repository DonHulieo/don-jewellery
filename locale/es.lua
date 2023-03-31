local Translations = {
    error = {
        fingerprints = 'Has dejado una huella dactilar..',
        security_active = 'El sistema de seguridad está activo..',
        minimum_police = 'El sistema de seguridad está activo..',
        vitrine_hit = 'Esta vitrina ya ha sido golpeada',
        wrong_weapon = 'Tu arma no es lo suficientemente fuerte...',
        to_much = 'Tus bolsillos están llenos..',
        fail_therm = 'No aplicaste la termita correctamente..',
        wrong_item = 'No tienes el artículo correcto...',
        too_far = 'Estas muy lejos..',
        stores_open = 'Debería intentarlo después de que cierre la tienda...',
        fail_hack = 'No lograste hackear el sistema de seguridad...',
        skill_fail = 'Tu habilidad %{value} no es lo suficientemente alta...'
    },
    success = {
        thermite = 'Aplicaste correctamente la termita..',
        store_hit_threestore = 'Fusibles quemados, las puertas deberían abrirse pronto.',
        store_hit_onestore = 'Fusibles quemados, las puertas deberían abrirse durante %{value} minutos',
        hacked_threestore = 'Hackeo exitoso, todas las puertas deberían estar abiertas..',
        hacked_onestore = 'Hackeo exitoso, la seguridad está deshabilitada'
    },
    info = {
        smashing_progress = 'Rompiendo la vitrina',
        hacking_attempt = 'Conectando al sistema de seguridad..',
        one_store_warning = '¡Apurarse! La tienda cerrará en %{value} minuto'
    },
    general = {
        target_label = 'Rompe la vitrina',
        drawtextui_grab = '[E] Rompe la vitrina',
        drawtextui_broken = 'La vitrina está rota'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
