-- ncUI config
ncUIdb["general"] = { -- core settings
	uiscale = .64, -- the UI scale you want to use
	colorscheme_backdrop = {.1, .1, .1, 1, }, -- red, green, blue, alpha | number between 1 and 0 where 0 is none and 1 is full(alpha 1 is fully visible, alpha 0 is fully hidden)
	colorscheme_border = { .6, .6, .6, 1, }, -- same
}

ncUIdb["media"] = { -- media locations
	["font"] = [[Fonts\FRIZQT__.ttf]], -- just a link to the gamefont
	["pixelfont"] = [[Interface\AddOns\ncUI\media\slkscr.ttf]], -- pixelated font
	["mask"] = [[Interface\ChatFrame\ChatFrameBackground]], -- minimap mask
	["mail"] = [[Interface\AddOns\ncUI\media\mail]], -- new mail button
	["button"] = [[Interface\AddOns\ncUI\media\button]], -- button skin
	["flat"] = [[Interface\AddOns\ncUI\media\flat]], -- statusbar skin(unitframes, nameplates)
	["button_hover"] = [[Interface\AddOns\ncUI\media\button_hover]], -- button skin when hovering
	["button_grey"] = [[Interface\AddOns\ncUI\media\button_grey]], -- button skin used with greytones when color can't be set(rarely used)
	["solid"] = [[Interface\AddOns\ncUI\media\solid]], -- solid texture
	["cross"] = [[Interface\Addons\ncUI\media\cross]],
	["unitframe"] = [[Interface\Addons\ncUI\media\solid]],
}

ncUIdb["actionbar"] = {
	["rows"] = 1, -- 1 or 2 rows of actionbars
}

ncUIdb["worldmap"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["scale"] = 0.7, -- scales the worldmap by this amount
	["showcoords"] = true, -- true is to show coords, false is to hide
}

ncUIdb["chat"] = {
	sticky_channels = { -- if you just typed in a channel, when you press enter and the channel is sticky, then you will start typing in the same channel again
		["say"] = true, -- set to true to make the channel sticky, false to not make it sticky
		["emote"] = true,
		["yell"] = true,
		["party"] = true,
		["guild"] = true,
		["officer"] = true,
		["raid"] = true,
		["raid_warning"] = true,
		["battleground"] = true,
		["whisper"] = true,
		["channel"] = true,
	},
	replaces = { -- What to replaces certain tags with, for example "[1. General] [ncUI]: bla bla bla" changes to "1 ncUI: bla bla bla"
		["Guild"] = "G",
		["Party"] = "P",
		["Raid"] = "R",
		["Raid Leader"] = "RL",
		["Raid Warning"] = "RW",
		["Officer"] = "O",
		["Battleground"] = "B",
		["Battleground Leader"] = "BL",
	},
	["colorscheme_editbox"] = { .6, .6, 1, 1, }, -- same parameters as other colorscheme_ settings, this one determines what color the editbox border should have
}

ncUIdb["error"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	filter = { -- what messages to not hide
		["Inventory is full."] = true, -- inventory is full will not be hidden by default
		[""] = true, -- use this to unhide more messages(copy paste this line to add more)
	},
}

ncUIdb["actionbar"] = {
}

ncUIdb["extrabuttons"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

ncUIdb["tooltip"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

ncUIdb["cooldown"] = {
	enable = true, -- true to enable this mod, false to disable
	fade = true, -- if set to true buttons will fade when they are on cooldown
	treshold = 6.5, -- if the cooldown remainder is less than this in seconds the tresholdcolor will be applied
	color = {1, 1, 1}, -- the color of the cooldowntext in red, green, blue values
	tresholdcolor = {1, 0, 0}, -- the color of the cooldowntext when below the treshold in red, green, blue values
}

ncUIdb["merchant"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["sellgrays"] = true, -- automaticly sell grays?
	["autorepair"] = true, -- automaticly repair?
}

ncUIdb["quest"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

ncUIdb["resurrect"] = {
	["enable"] = true,
}

ncUIdb["minimap"] = {
	["speed"] = 20,
	["combatspeed"] = 80,
}

ncUIdb["datatext"] = { -- Determine what feed a datatext slot should have. Possible datafeeds are: bag, mail, dur, money, ms, mem, exprep.
	left1 = "bag",
	left2 = "mail",
	left3 = "dur",
	right1 = "money",
	right2 = "ms",
	right3 = "mem",
}

ncUIdb["nameplates"] = {
	["enable"] = true,
	["font"] = ncUIdb["media"].pixelfont,
	["fontsize"] = 7,
	["tags"] = "THINOUTLINE",
	["texture"] = ncUIdb["media"].unitframe,
}

ncUIdb["bags"] = {
	["enable"] = true,
}

ncUIdb["spellalerter"] = {
	["enable"] = true,
	HARMFUL_SPELLS = {
		-- Priest
		["Mind Control"] = true, -- Mind Control
		["Mind Blast"] = true, -- Mind Blast
		["Holy Fire"] = true,
		["Psychic Scream"] = true,
		["Shackle Undead"] = true,
		["Psychic Horror"] = true,
		["Mana Burn"] = true,
		["Smite"] = true,
		["Holy Fire"] = true,
		["Vampiric Touch"] = true,
		["Mind Sear"] = true,

		-- Druid
		["Entangling Roots"] = true,
		["Cyclone"] = true,
		["Wrath"] = true,
		["Starfire"] = true,
		
		-- Deathknight
		["Mind Freeze"] = true,
		["Army of the Dead"] = true,
		["Strangulate"] = true,
		["Hungering Cold"] = true,
		
		-- Hunter
		["Viper Sting"] = true,
		["Wyvern Sting"] = true,
		["Silencing Shot"] = true,
		["Scatter Shot"] = true,
		
		-- Mage
		["Polymorph"] = true,
		["Polymorph: Pig"] = true,
		["Polymorph: Turtle"] = true,
		["Frostbolt"] = true,
		["Fireball"] = true,
		["Arcane Blast"] = true,
		["Pyroblast"] = true,
		["Flamestrike"] = true,
		["Frostfire Bolt"] = true,
		["Slow"] = true,
		["Summon Water Elemental"] = true,
		["Scorch"] = true,
		["Mirror Image"] = true,
		
		-- Shaman
		["Lightning Bolt"] = true,
		["Chain Lightning"] = true,	
		["Lava Burst"] = true,
		["Mana Tide Totem"] = true,
		["Feral Spirit"] = true,
		
		-- Warlock
		["Fear"] = true,
		["Howl of Terror"] = true,
		["Seduction"] = true,
		["Shadow Bolt"] = true,
		["Seed of Corruption"] = true,
		["Ritual of Summoning"] = true,
		["Soul Fire"] = true,
		["Haunt"] = true,
		["Searing Pain"] = true,
		["Banish"] = true,
		["Chaos Bolt"] = true,
		["Immolate"] = true,
		["Death Coil"] = true,
		["Demonic Circle: Summon"] = true,
		["Unstable Affliction"] = true,
		["Incinerate"] = true,
		["Shadowfury"] = true,
		
		-- Paladin
		["Exorcism"] = true,
	},
	HEALING_SPELLS = {
		-- Priest
		["Binding Heal"] = true,
		["Circle of Healing"] = true,
		["Lightwell"] = true,
		["Mass Dispel"] = true,
		["Flash Heal"] = true,
		["Greater Heal"] = true,
		["Heal"] = true,
		["Lesser Heal"] = true,	
		["Prayer of Healing"] = true,
		["Resurrection"] = true,
		["Divine Hymn"] = true,
		["Hymn of Hope"] = true,
		["Penance"] = true,
		["Desperate Prayer"] = true,
		
		-- Druid
		["Healing Touch"] = true,
		["Regrowth"] = true,
		["Revive"] = true,
		["Rebirth"] = true,
		["Nourish"] = true,
		
		
		-- Paladin
		["Flash of Light"] = true,
		["Holy Light"] = true,
		["Redemption"] = true,
		["Lay on Hands"] = true,
		
		-- Shaman
		["Chain Heal"] = true,	
		["Healing Wave"] = true,
		["Lesser Healing Wave"] = true,
		["Ancestral Spirit"] = true,
		
		-- Rogue
		["Blind"] = true,
		["Shadowstep"] = true,
		["Preparation"] = true,
	},
	BUFF_SPELLS = {
		["Nature's Grasp"] = true,
		["Summon Gargoyle"] = true,
		["Presence of Mind"] = true,
		["Icebound Fortitude"] = true,
		["Ice Block"] = true,
		["Frost Ward"] = true,
		["Fire Ward"] = true,
		["Dancing Rune Weapon"] = true,
		["Hysteria"] = true,
		["Bloodlust"] = true,
		["Arcane Power"] = true,
		["Shadow Trance"] = true,
		["Metamorphosis"] = true,
		["Bladestorm"] = true,
		["Last Stand"] = true,
		["Recklessness"] = true,
		["Retaliation"] = true,
		["Shield Wall"] = true,
		["Adrenaline Rush"] = true,
		["Avenging Wrath"] = true,
		["Blessing of Freedom"] = true,
		["Blessing of Protection"] = true,
		["Death Wish"] = true,
		["Deterrence"] = true,	
		["Divine Shield"] = true,
		["Divine Protection"] = true,
		["Evasion"] = true,
		["Elemental Mastery"] = true,
		["Nature's Swiftness"] = true,
		["Heroism"] = true,
		["Pain Suppression"] = true,
		["Perception"] = true,
		["Recklessness"] = true,
		["Spell Reflection"] = true,
		["Stealth"] = true,
		["Stoneform"] = true,
		["Frenzied Regeneration"] = true,
		["The Beast Within"] = true,
		["Power Infusion"] = true,
		["Dispersion"] = true,
		["Innervate"] = true,
		["Starfall"] = true,
		["Sprint"] = true,
		["Cloak of Shadows"] = true,
		["Hand of Sacrifice"] = true,
		["Avenging Wrath"] = true,
		["Blazing Speed"] = true,
		["Fireball!"] = true,
		["Combustion"] = true,
		["Killing Spree"] = true,
		["Adrenaline Rush"] = true,
		["Blade Flurry"] = true,
		["Shadow Dance"] = true,
	},
	PROC_SPELLS = {
		["Shadow Trance"] = true,
		["Fingers of Frost"] = true,
		["Fireball!"] = true,
		["Backlash"] = true,
		["The Art of War"] = true,
	},
}