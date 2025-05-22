SMODS.Atlas({
    key = 'supreme_arcana',
    px = 71,
    py = 95,
    path = 'SupremeArcana.png'
})

--this mod was made in about a day with minimal lua experience

 SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 32,    
    py = 32
 })
SMODS.Consumable {
    key = 'well',
    set = 'Tarot',
    pos = {
        x = 0,
        y = 0
    },
    loc_txt = {
        name = "The Well",
        text = {
            "Decreases rank of",
                    "up to {C:attention}#1#{} selected",
                    "cards by {C:attention}1",
        }
    },
    atlas = 'supreme_arcana',
    cost = 4,
    config = { max_highlighted = 2, min_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                    assert(SMODS.modify_rank(G.hand.highlighted[i], -1))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'eye',
    set = 'Tarot',
    pos = {
        x = 1,
        y = 0
    },
    loc_txt = {
        name = "The Eye",
        text = {
            "Swaps the suit and rank of",
            "{C:attention}#1#{} selected cards",
        }
    },
    atlas = 'supreme_arcana',
    cost = 4,
    config = { max_highlighted = 2, min_highlighted = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        local leftmost = G.hand.highlighted[2]
        
            local rightmostSuit = rightmost.base.suit
            local rightmostRank = rightmost.base.value
            local leftmostSuit = leftmost.base.suit
            local leftmostRank = leftmost.base.value

        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
                        assert(SMODS.change_base(rightmost, leftmostSuit, leftmostRank))
                        assert(SMODS.change_base(leftmost, rightmostSuit, rightmostRank))
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'oracle',
    set = 'Spectral',
    pos = {
        x = 2,
        y = 0
    },
    loc_txt = {
        name = "The Oracle",
        text = {
            "Makes all held ",
            "consumables {C:dark_edition}Negative{}",
        }
    },
    atlas = 'supreme_arcana',
    cost = 4,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                for i,v in ipairs(G.consumeables.cards) do
                    v:set_edition('e_negative')
                end
                card:juice_up(0.3, 0.5)
                return true
            end
            
        }))
    end,
    can_use = function(self, card)
        return #G.consumeables.cards > 0
    end
}