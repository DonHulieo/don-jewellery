local Translations = {
    error = {
        fingerprints = 'You\'ve left a fingerprint..',
        security_active = 'The security system is active..',
        minimum_police = 'Minimum of %{value} police needed',
        vitrine_hit = 'This display case has already been hit',
        wrong_weapon = 'Your weapon is not strong enough..',
        to_much = 'You\'re pockets are full..',
        fail_therm = 'You didn\'t apply the thermite correctly..',
        wrong_item = 'You don\'t have the right item..',
        too_far = 'You\'re too far away..',
        stores_open = 'I should try after the store closes..',
        fail_hack = 'You failed to hack the security system..',
        skill_fail = 'Your %{value} skill is not high enough..'
    },
    success = {
        thermite = 'You applied the thermite correctly..',
        store_hit_threestore = 'Fuses blown, the doors should open soon..',
        store_hit_onestore = 'Fuses blown, the doors should open for %{value} minutes',
        hacked_threestore = 'Hack successful, all doors should be open..',
        hacked_onestore = 'Hack successful, security is disabled'
    },
    info = {
        smashing_progress = 'Smashing the display case',
        hacking_attempt = 'Connecting to the security system..',
        one_store_warning = 'Hurry! The store will close in %{value} minute'
    },
    general = {
        target_label = 'Smash the display case',
        drawtextui_grab = '[E] Smash the display case',
        drawtextui_broken = 'Display case is broken'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})