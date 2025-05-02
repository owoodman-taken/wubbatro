--- STEAMODDED HEADER
--- MOD_NAME: wubbatro
--- MOD_ID: WUBBATRO
--- MOD_AUTHOR: [me :)]
--- MOD_DESCRIPTION: My first joker
--- PREFIX: wubb
----------------------------------------------
------------MOD CODE -------------------------

--- ideas: reroll shop effect, lower boss effect
SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Atlas{
    key = 'wubbatarot',
    path = 'Tarot.png',
    px = 71,
    py = 95
}
---
---
---JOKERS
---
---
--- DONE! jack 
SMODS.Joker{
    key = "jack_the_joker",
    loc_txt = {
        name = 'jack the joker',
        text = {
        'when a {C:hearts}heart card {}is played,',
        'this joker gains {C:mult}+#1# mult{}.',
        'retrgger all jacks #2# times',
        '{C:inactive}(currently{} {C:mult}#3# Mult{}{C:inactive}){}'
        },
    },
    atlas = "Jokers",
    rarity = 2,
    cost = 10,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 1},
    config = {
        extra = {
            Mult_gain = 2,
            mult = 0,
            retrggers = 2
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Mult_gain, center.ability.extra.retrggers, center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
    
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 11 then
                return {
                    message = 'Again!',
                    colour = G.C.RED,
                    repetitions = card.ability.extra.retrggers
                }
            end
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Hearts") then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.Mult_gain
                
                return {
                    message = 'Upgraded Jack!',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
	    if context.joker_main then
	    	return {
            card = card,
			mult = card.ability.extra.mult
		    }
	    end
    end
}
--- DONE! burt basil
SMODS.Joker{
    key = 'Doc Basil',
    loc_txt = {
        name = 'Burnt Basil',
        text = {
            'non-face cards earn{C:money} $#1#{} when scored,'
        },
    },
    atlas = "Jokers",
    rarity = 2,
    cost = 40,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 2},
    config = {
        extra = {
            money_earned = 1,
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.money_earned}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                return {
                    dollars = card.ability.extra.money_earned
                }
            end
        end
    end    
}
--- DONE! calico (insane cash earning)
SMODS.Joker{
    key = 'Calico',
    loc_txt = {
        name = 'Calico Joker',
        text = {
            'this card gives you {C:money}$#1#{} at the',
            'start and end of every blind',
        },
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 40,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 0},
    config = {
        extra = {
            money_earning = 20,
            cards_needed_to_destroy = 6,
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.money_earning}}
    end,
    calculate = function (self, card, context)
        if context.setting_blind then
            return {
                dollars = card.ability.extra.money_earning
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.money_earning
            }
        end
        if context.cards_destroyed and not context.blueprint then
            for k, v in ipairs(context.glass_shattered) do
                card.ability.extra.cards_needed_to_destroy = card.ability.extra.cards_needed_to_destroy - 1
            end
        end
        if context.remove_playing_cards and not context.blueprint then
            for k, val in ipairs(context.removed) do
                card.ability.extra.cards_needed_to_destroy = card.ability.extra.cards_needed_to_destroy - 1
                return {
                    message = '>:(',
                    colour = G.C.RED
                }
            end
            if card.ability.extra.cards_needed_to_destroy == 0 or card.ability.extra.cards_needed_to_destroy == -1 and not context.blueprint then
                local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil, 'angry_calico')
                new_card:set_eternal()
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
                G.jokers:remove_card(card)
				card:remove()
            end
        end
    end
}
--- DONE! calico's fury
SMODS.Joker{
    key = 'angry_calico',
    loc_txt = {
        name = 'Calicos Fury',
        text = {
            '{C:red,E:2}you have upset him...{}',
            '{C:red,E:2}you will know regret.{}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 400000,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 0},
    config = {
        extra = {
            xmulti = 1,
            items_bought = 0,
            money_reuction = -10
        }
    },
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return false
    end,
    calculate = function (self,card,context)
        if context.setting_blind then
            return {
                dollars = card.ability.extra.money_reuction
            }
        end
        if context.end_of_round and context.individual then
            return {
                dollars = card.ability.extra.money_reuction
            }
        end 
        if context.buying_card or context.open_booster or context.reroll_shop then
            card.ability.extra.items_bought = card.ability.extra.items_bought + 1
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmulti - (card.ability.extra.items_bought * 0.05)
            }
        end
    end
}
--- DONE! spooky 
SMODS.Joker{
    key = 'spooky_joker',
    loc_txt = {
        name = 'Spooky Joker',
        text = {
            '{C:mult}+1 Mult{} and also {C:chips}+10 Chips{}',
            'for every {C:money}$1{} you currently have'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 15,
    unlocked = true, 
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = {
        extra = {
            Mult_gain = 0,
            Chip_gain = 0
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.Mult_gain = G.GAME.dollars * 1
            card.ability.extra.Chip_gain = G.GAME.dollars * 10

            return {
                mult = card.ability.extra.Mult_gain,
                chips = card.ability.extra.Chip_gain
            }
        end
    end
}
--- vignette
--- joker flavored fanta
--- rexipoo (omg its rexipoo :D its an insta win but like exodia) (last)
--- rexipoo's catylist (rare) (exodia part 3)
--- DONE! anthaneus (every 25 cards scored, make the 25th card polychrome)
SMODS.Joker{
    key = "anthanues",
    loc_txt = {
        name = 'anthaneus',
        text = {
        'after scoring {C:attention}25 face cards{}, add {C:edition}polychrome{},',
        'to the {C:attention}25th scored card{} {C:inactive}(#1# left to score){}'
        },
    },
    atlas = "Jokers",
    rarity = 3,
    cost = 20,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 0},
    config = {
        extra = {
            cards_left_to_score = 25
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.cards_left_to_score}}
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_face() then
                card.ability.extra.cards_left_to_score = card.ability.extra.cards_left_to_score - 1
                if card.ability.extra.cards_left_to_score == 0 then
                    context.other_card:set_edition('e_polychrome', true, nil, nil, nil, nil)
                end
            end
        end
    end
}
--- DONE! stupizzard (X0.05 mult per tarot used, X0.1 per spectral card.)
SMODS.Joker{
    key = "stupizzard",
    loc_txt = {
        name = 'stupid joker',
        text = {
        'gain {C:white,X:mult}#1#X{} Mult when a {C:tarot}tarot{} card,',
        'is used, and gain {C:white,X:mult}#2#X{} Mult when you',
        'you use a {C:spectral}spectral{} card.',
        '(currently {C:white,X:mult}#3#X{} Mult)'
        },
    },
    atlas = "Jokers",
    rarity = 3,
    cost = 10,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1},
    config = {
        extra = {
            tarot_gain = 0.05,
            spectral_gain = 0.1,
            x_mult = 1
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.tarot_gain, center.ability.extra.spectral_gain, center.ability.extra.x_mult}}
    end,
    calculate = function (self, card, context)
        if context.using_consumeable and not context.blueprint then
            if (context.consumeable.ability.set == "Tarot") then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.tarot_gain
                return {
                    message = '+0.05X!',
                    colour = G.C.RED
                }
            end
            if context.consumeable.ability.set == 'Spectral' then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.spectral_gain
                return {
                    message = '+0.1X!',
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
}
--- sedaroth (Cool sword consumable that can destroy a card and lower blind)
SMODS.Joker{
    key = "sedaroth",
    loc_txt = {
        name = 'sedaroth',
        text = {
        'gives you a {C:attention}cool lookin sword{} at the end of blinds',
        },
    },
    atlas = "Jokers",
    rarity = 3,
    cost = 15,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 1},
    config = {
        extra = {
            x_mult = 1
        }
    }, 
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calculate = function (self,card,context)
        if context.main_eval and context.end_of_round then
            SMODS.add_card({area = G.consumeables, key = 'c_wubb_cool_sword'})
        end
        
    end
}
--- owoodman (create a double tag when you win with first hand every round)
SMODS.Joker{
    key = "owoodman",
    loc_txt = {
        name = 'Owoodman',
        text = {
            'if you win with the {C:attention}first{} hand ({C:mult,E:2}NO DISCARDS{})',
            'of a blind, create a {C:attention,T:tag_double}double tag{}.',
            'this card will create {C:attention}#1#{} extra',
            'if you win with a single ({C:mult,E:2}NO RETRIGGERS{}) {C:white,X:inactive}stone{}',
            'card. {C:white,X:inactive}stone{} cards also grant {C:white,X:mult}X#2#{} mult'
        },
    },
    atlas = "Jokers",
    rarity = 4,
    cost = 30,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 3, y = 1},
    soul_pos = {x = 4, y = 1},
    config = {
        extra = {
            is_first_hand = 0,
            first_hand_stone_count = 0,
            extra_tags = 2,
            stone_x_mult = 4
        }
    },
    in_pool = function(self,wawa,wawa2)
         return true
    end,
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.extra_tags,
                center.ability.extra.stone_x_mult
            }
        }
    end,
    calculate = function(self,card,context)
        if context.hand_drawn then
            card.ability.extra.is_first_hand = 0
        end
        if context.first_hand_drawn then
            card.ability.extra.is_first_hand = 1
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect == 'Stone Card' then
                card.ability.extra.first_hand_stone_count = card.ability.extra.first_hand_stone_count + 1
                return {
                    xmult = card.ability.extra.stone_x_mult
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if context.game_over == false and card.ability.extra.is_first_hand == 1 then
                if card.ability.extra.first_hand_stone_count == 1 then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                        add_tag(Tag('tag_double'))
                        add_tag(Tag('tag_double'))
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                        end)
                        }))
                elseif true == true then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                        end)
                        }))
                end
            end

            card.ability.extra.is_first_hand = 0
            card.ability.extra.first_hand_stone_count = 0
        end
    end
}
--- 
--- 
--- CONSUMABLES
--- 
--- 
--- DONE! (sp) ALTER: SPACE (make 2 random planet)
SMODS.Consumable{
    key = 'alter_space',
    set = 'Spectral', --- wubba no pool, make it so they won't apear
    loc_txt = {
        name = 'SPACE',
        text = {
            'create 4 random {C:planet}planet cards{}',
        }
    },
    atlas = 'wubbatarot',
    pos = {x = 1, y = 0},
    unlocked = true,
    discovered = true,
    config = {
        extra = {
            can_use = 0
        }
    },
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calculate = function (self,card,context)
        if true == true then
            card.ability.extra.can_use = 1
        end
    end,
    use = function (self, card, area, copier)
        SMODS.add_card({area = G.consumeables, set = 'Planet'})
        SMODS.add_card({area = G.consumeables, set = 'Planet'})
        SMODS.add_card({area = G.consumeables, set = 'Planet'})
        SMODS.add_card({area = G.consumeables, set = 'Planet'})
    end,
    can_use = function(self, card)
        if card.ability.extra.can_use == 1 then
            return{true}
        else
            return{false}
        end

    end,
}
--- DONE! (sp) ALTER: TIME (-1 ante, -1 hand size)
SMODS.Consumable{
    key = 'alter_time',
    set = 'Spectral', --- wubba no pool, make it so they won't apear
    loc_txt = {
        name = 'TIME',
        text = {
            '{C:attention}-1 ante{}, {C:red}-1 hand size{}',
        }
    },
    atlas = 'wubbatarot',
    pos = {x = 0, y = 0},
    unlocked = true,
    discovered = true,
    config = {
        extra = {
            can_use = 0,
            h_size = -1
        }
    },
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calculate = function (self,card,context)
        if context.setting_blind then
            card.ability.extra.can_use = 1
        end
        if context.end_of_round then
            card.ability.extra.can_use = 0
        end
    end,
    use = function (self, card, area, copier)
        ease_ante(-1)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante-1
        G.hand:change_size(-1)
    end,
    can_use = function(self, card)
        if card.ability.extra.can_use == 1 then
            return{true}
        else
            return{false}
        end

    end,
}
--- (sp) ALTER: CORRUPTION (earn 10$)
SMODS.Consumable{
key = 'alter_corrupt',
set = 'Spectral', --- wubba no pool, make it so they won't apear
loc_txt = {
    name = 'CORRUPTION',
    text = {
        'earn {C:dollars}10${}',
    }
},
atlas = 'wubbatarot',
pos = {x = 2, y = 0},
unlocked = true,
discovered = true,
config = {
    extra = {
        can_use = 0,
        h_size = -1
    }
},
can_use = function (self, card)
    return true
end,
use = function (self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        ease_dollars(10, true)
        return true end }))
        delay(0.6)
    end
}
--- (sp) ALTER: COWHEAD (create 4 tarot cards)
SMODS.Consumable{
key = 'alter_cowhead',
set = 'Spectral', --- wubba no pool, make it so they won't apear
loc_txt = {
    name = 'COWHEAD',
    text = {
        'create 4 random {C:tarot}tarot{} cards',
        '{C:attention}DOES NOT NEED SPACE{}'
    }
},
atlas = 'wubbatarot',
pos = {x = 3, y = 0},
unlocked = true,
discovered = true,
config = {
    extra = {
        can_use = 0,
        h_size = -1
    }
},
can_use = function (self, card)
    return true
end,
use = function (self, card, area, copier)
    SMODS.add_card({area = G.consumeables, set = 'Tarot'})
    SMODS.add_card({area = G.consumeables, set = 'Tarot'})
    SMODS.add_card({area = G.consumeables, set = 'Tarot'})
    SMODS.add_card({area = G.consumeables, set = 'Tarot'})
end
}
--- (sp) ALTER: IMP, wait he is not an alter (give 2 cards in hand bonus enhancement and holographic)
SMODS.Consumable{
    key = 'alter_imp',
    set = 'Spectral', --- wubba no pool, make it so they won't apear
    loc_txt = {
        name = 'IMP- wait your not an alter',
        text = {
            'select {C:attention}2 cards{} and make them {C:edition,E:2}holographic{}',
            'and apply the {C:chips}bonus enhancement{} to them'
        }
    },
    atlas = 'wubbatarot',
    pos = {x = 4, y = 0},
    unlocked = true,
    discovered = true,
    config = {
        max_highlighted = 2,
        edition = 'e_holo',
        enhancement = 'm_bonus'
    },
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true end }))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_edition(card.ability.edition, true)
                G.hand.highlighted[i]:set_ability(card.ability.enhancement, true)
                return true end }))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}
--- (tar) The burbger (next hand gets 2X mult)
    key = 'burger',
    set = 'Tarot', --- wubba no pool, make it so they won't apear
    loc_txt = {
        name = 'the burbger',
        text = {
            'for the rest of round (or next), you gain {X:mult}X2MULT{}',
        }
    },
    atlas = 'wubbatarot',
    pos = {x = 0, y = 1},
    unlocked = true,
    discovered = true,
    config = {
        burbger_joker = 'burb_joker'
    },
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil, 'j_wubb_burb_joker')
        new_card:set_edition('e_negative', true)
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
    end
}
--- burbger joker thing
SMODS.Joker{
    key = 'burb_joker',
    loc_txt = {
        name = 'burbger',
        text = {
            '{X:mult}X2MULT{}, but {C:red}destroy self{} at end of round',
        },
    },
    atlas = 'wubbatarot',
    rarity = 1,
    cost = 0,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1},
    config = {
        extra = {
            x_mult = 2
        }
    },
    in_pool = function(self,wawa,wawa2)
         return false
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                x_mult = 2
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                    return true;
                end
            }))

        end
    end
}
--- (sp) nombre's gift (insert that one image and gives you a negative dupe of a joker but perishable)
--- (tar) chicken (exodia part 1)
--- (sp) OMG IT'S HIM!!!(exodia part 2)
--- DONE!!! cool sword
SMODS.Consumable {
    key = 'cool_sword',
    set = 'Tarot', --- wubba no pool, make it so they won't apear
    loc_txt = {
        name = 'cool sword',
        text = {
            'lower the blind requirement by 10%',
        }
    },
    atlas = 'wubbatarot',
    cost = 4,
    pos = {x = 3, y = 1},
    unlocked = true,
    discovered = true,
    config = {
        extra = {
            can_use = 0
        }
    },
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    use = function (self, card, area, copier)
        Change_blind_size(G.GAME.blind.chips*0.8,false,false)
    end,
    can_use = function(self, card)
        return{true}
    end,
    calculate = function (self, card, context)
        if context.before and context.cardarea and context.using_consumeable then
            if card.ability.name == 'coolsword' then
            
               return {

               }
            end
            
        end
    end
}
---
---
---BLINDS
---
---
---the wubbaburbger etablishment
SMODS.Blind{
    key = 'wubbaburbger',
    loc_txt = {
        name = 'The Wubbaburbger',
        text = {
            'all face cards, all hearts,',
            'all aces, and 10s are all debuffed'
        }
    },
    atlas = 'wubbablinds', pos = {x = 0, y = 0},
    discovered = true,
    boss_colour = HEX('CF8861'),
    dollars = 10,
    boss = {
        showdown = true,
        
    },
    debuff = {
        suit = 'Hearts',
        nominal = 10,
        value = 'Ace'
    },
    
}
---
---
---Enhancements
---
---
---corrupted cards (destroyed when triggered but give 5 dollars)
---
---
---MISC. 
---
---
---rainbow gradient
---change blind size function (thank you to jen's almanac or I guess polterworks now)
function Change_blind_size(newsize, instant, silent) newsize = newsize G.GAME.blind.chips = newsize local chips_UI = G.hand_text_area.blind_chips if instant then G.GAME.blind.chip_text = number_format(newsize) G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips) G.HUD_blind:recalculate() chips_UI:juice_up() if not silent then play_sound('chips2') end else G.E_MANAGER:add_event(Event({func = function() G.GAME.blind.chip_text = number_format(newsize) G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips) G.HUD_blind:recalculate() chips_UI:juice_up() if not silent then play_sound('chips2') end return true end })) end end
