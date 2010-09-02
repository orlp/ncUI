local C = select(2, ...):New(2)

-- ncUI config
C["general"] = { -- core settings
	uiscale = .64, -- the UI scale you want to use
	backdrop = {.1, .1, .1, 1, }, -- red, green, blue, alpha | number between 1 and 0 where 0 is none and 1 is full(alpha 1 is fully visible, alpha 0 is fully hidden)
	border = { .6, .6, .6, 1, }, -- same
}

C["media"] = { -- media locations
	["font"] = [[Fonts\FRIZQT__.ttf]], -- just a link to the gamefont
	["pixelfont"] = [[Interface\AddOns\ncUI\media\slkscr.ttf]], -- pixelated font
	["mask"] = [[Interface\ChatFrame\ChatFrameBackground]], -- minimap mask
	["mail"] = [[Interface\AddOns\ncUI\media\mail]], -- new mail button
	["button"] = [[Interface\AddOns\ncUI\media\button]], -- button skin
	["flat"] = [[Interface\AddOns\ncUI\media\flat]], -- statusbar skin(unitframes, nameplates)
	["highlight"] = [[Interface\AddOns\ncUI\media\button_hover]], -- button skin when hovering
	--["button_grey"] = [[Interface\AddOns\ncUI\media\button_grey]], -- button skin used with greytones when color can't be set(rarely used)
	["solid"] = [[Interface\AddOns\ncUI\media\solid]], -- solid texture
	["cross"] = [[Interface\Addons\ncUI\media\cross]],
	["unitframe"] = [[Interface\Addons\ncUI\media\solid]],
}

C["actionbar"] = {
	["bars"] = 1, -- 1 or 2 bars
}

C["worldmap"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["scale"] = 0.7, -- scales the worldmap by this amount
	["showcoords"] = true, -- true is to show coords, false is to hide
}

C["cdflash"] = {
	["enable"] = true,
	["flashtime"] = .75,
}

C["chat"] = {
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
		["Guilde"] = "G",
		["Groupe"] = "GR",
		["Chef de raid"] = "RL",
		["Avertissement Raid"] = "AR",
		["Officier"] = "O",
		["Champs de bataille"] = "CB",
		["Chef de bataille"] = "CDB",
		["Guild"] = "G",
		["Party"] = "P",
		["Party Leader"] = "PL",
		["Dungeon Guide"] = "DG",
		["Raid"] = "R",
		["Raid Leader"] = "RL",
		["Raid Warning"] = "RW",
		["Officer"] = "O",
		["Battleground"] = "B",
		["Battleground Leader"] = "BL",
		["Gilde"] = "G",
		["Gruppe"] = "Grp",
		["Gruppenanführer"] = "GrpL",
		["Dungeonführer"] = "DF",
		["Schlachtzug"] = "R",
		["Schlachtzugsleiter"] = "RL",
		["Schlachtzugswarnung"] = "RW",
		["Offizier"] = "O",
		["Schlachtfeld"] = "BG",
		["Schlachtfeldleiter"] = "BGL",
	},
	["colorscheme_editbox"] = { .6, .6, 1, 1, }, -- same parameters as other colorscheme_ settings, this one determines what color the editbox border should have
}

C["error"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	filter = { -- what messages to not hide
		["Inventory is full."] = true, -- inventory is full will not be hidden by default
		[""] = true, -- use this to unhide more messages(copy paste this line to add more)
	},
}

C["extrabuttons"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

C["tooltip"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

C["cooldown"] = {
	enable = true, -- true to enable this mod, false to disable
	fade = true, -- if set to true buttons will fade when they are on cooldown
	treshold = 6.5, -- if the cooldown remainder is less than this in seconds the tresholdcolor will be applied
	color = {1, 1, 1}, -- the color of the cooldowntext in red, green, blue values
	tresholdcolor = {1, 0, 0}, -- the color of the cooldowntext when below the treshold in red, green, blue values
}

C["merchant"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["sellgrays"] = true, -- automaticly sell grays?
	["autorepair"] = true, -- automaticly repair?
}

C["quest"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

C["resurrect"] = {
	["enable"] = true,
}

C["datatext"] = { -- Determine what feed a datatext slot should have. Possible datafeeds are: bag, mail, dur, money, ms, mem, exprep.
	left1 = "bag",
	left2 = "exprep",
	left3 = "dur",
	right1 = "money",
	right2 = "ms",
	right3 = "mem",
}

C["nameplates"] = {
	["enable"] = true,
	["font"] = C["media"].pixelfont,
	["fontsize"] = 7,
	["tags"] = "THINOUTLINE",
	["texture"] = C["media"].unitframe,
}

C["bags"] = {
	["enable"] = true,
}

C["focus"] = {
	["enable"] = true,
	["button"] = 1,
	["modify"] = "alt",
}

C["killingblow"] = {
	["enable"] = true,
}

C["spellalerter"] = {
	["enable"] = true,
	HARMFUL_SPELLS = {
		-- Priest
		[GetSpellInfo(605)] = 1, -- Mind Control
		[GetSpellInfo(13860)] = 1, -- Mind Blast
		[GetSpellInfo(7140)] = 1, -- Holy Fire
		[GetSpellInfo(13704)] = 1, -- Psychic Scream
		[GetSpellInfo(11444)] = 1, -- Shackle Undead
		[GetSpellInfo(64044)] = 1, -- Psychic Horror
		[GetSpellInfo(8129)] = 1, -- Mana Burn
		[GetSpellInfo(35155)] = 1, -- Smite
		[GetSpellInfo(34919)] = 1, -- Vampiric Touch
		[GetSpellInfo(32000)] = 1, -- Mind Sear

		-- Druid
		[GetSpellInfo(11922)] = 1, -- Entangling Roots
		[GetSpellInfo(33786)] = 1, -- Cyclone
		[GetSpellInfo(9739)] = 1, -- Wrath
		[GetSpellInfo(21668)] = 1, -- Starfire

		-- Deathknight
		[GetSpellInfo(47528)] = 1, -- Mind Freeze
		[GetSpellInfo(42650)] = 1, -- Army of the Dead
		[GetSpellInfo(47476)] = 1, -- Strangulate
		[GetSpellInfo(53570)] = 1, -- Hungering Cold
		
		-- Hunter
		[GetSpellInfo(3034)] = 1, -- Viper Sting
		[GetSpellInfo(24335)] = 1, -- Wyvern Sting
		[GetSpellInfo(34490)] = 1, -- Silencing Shot
		[GetSpellInfo(19503)] = 1, -- Scatter Shot
		
		-- Mage
		[GetSpellInfo(28285)] = 1, -- Polymorph
		[GetSpellInfo(29457)] = 1, -- Frostbolt
		[GetSpellInfo(20797)] = 1, -- Fireball
		[GetSpellInfo(58462)] = 1, -- Arcane Blast
		[GetSpellInfo(24995)] = 1, -- Pyroblast
		[GetSpellInfo(72169)] = 1, -- Flamestrike
		[GetSpellInfo(69570)] = 1, -- Frostfire Bolt
		[GetSpellInfo(11436)] = 1, -- Slow
		[GetSpellInfo(31687)] = 1, -- Summon Water Elemental
		[GetSpellInfo(10206)] = 1, -- Scorch
		[GetSpellInfo(36848)] = 1, -- Mirror Image

		-- Shaman
		[GetSpellInfo(15207)] = 1, -- Lightning Bolt
		[GetSpellInfo(25021)] = 1, -- Chain Lightning	
		[GetSpellInfo(53788)] = 1, -- Lava Burst
		[GetSpellInfo(39609)] = 1, -- Mana Tide Totem
		[GetSpellInfo(1350)] = 1, -- Feral Spirit

		-- Warlock
		[GetSpellInfo(30002)] = 1, -- Fear
		[GetSpellInfo(5484)] = 1, -- Howl of Terror
		[GetSpellInfo(6359)] = 1, -- Seduction
		[GetSpellInfo(22336)] = 1, -- Shadow Bolt
		[GetSpellInfo(32865)] = 1, -- Seed of Corruption
		[GetSpellInfo(7720)] = 1, -- Ritual of Summoning
		[GetSpellInfo(17924)] = 1, -- Soul Fire
		[GetSpellInfo(48210)] = 1, -- Haunt
		[GetSpellInfo(30358)] = 1, -- Searing Pain
		[GetSpellInfo(24466)] = 1, -- Banish
		[GetSpellInfo(69576)] = 1, -- Chaos Bolt
		[GetSpellInfo(348)] = 1, -- Immolate
		[GetSpellInfo(67931)] = 1, -- Death Coil
		[GetSpellInfo(48018)] = 1, -- Demonic Circle: Summon
		[GetSpellInfo(34438)] = 1, -- Unstable Affliction
		[GetSpellInfo(23308)] = 1, -- Incinerate
		[GetSpellInfo(39082)] = 1, -- Shadowfury

		-- Paladin
		[GetSpellInfo(17149)] = 1, -- Exorcism
	},

	HEALING_SPELLS = {
		-- Priest
		[GetSpellInfo(48119)] = 1, -- Binding Heal
		[GetSpellInfo(61964)] = 1, -- Circle of Healing
		[GetSpellInfo(27870)] = 1, -- Lightwell
		[GetSpellInfo(32375)] = 1, -- Mass Dispel
		[GetSpellInfo(17138)] = 1, -- Flash Heal
		[GetSpellInfo(60003)] = 1, -- Greater Heal
		[GetSpellInfo(59195)] = 1, -- Heal
		[GetSpellInfo(29170)] = 1, -- Lesser Heal
		[GetSpellInfo(15585)] = 1, -- Prayer of Healing
		[GetSpellInfo(35599)] = 1, -- Resurrection
		[GetSpellInfo(70619)] = 1, -- Divine Hymn
		[GetSpellInfo(64904)] = 1, -- Hymn of Hope
		[GetSpellInfo(52984)] = 1, -- Penance
		[GetSpellInfo(19238)] = 1, -- Desperate Prayer

		-- Druid
		[GetSpellInfo(23381)] = 1, -- Healing Touch
		[GetSpellInfo(34361)] = 1, -- Regrowth
		[GetSpellInfo(51918)] = 1, -- Revive
		[GetSpellInfo(35369)] = 1, -- Rebirth
		[GetSpellInfo(57765)] = 1, -- Nourish

		-- Paladin
		[GetSpellInfo(33641)] = 1, -- Flash of Light
		[GetSpellInfo(647)] = 1, -- Holy Light
		[GetSpellInfo(7328)] = 1, -- Redemption
		[GetSpellInfo(633)] = 1, -- Lay on Hands

		-- Shaman
		[GetSpellInfo(15799)] = 1, -- Chain Heal
		[GetSpellInfo(547)] = 1, -- Healing Wave
		[GetSpellInfo(28850)] = 1, -- Lesser Healing Wave
		[GetSpellInfo(20609)] = 1, -- Ancestral Spirit

		-- Rogue
		[GetSpellInfo(21060)] = 1, -- Blind
		[GetSpellInfo(36563)] = 1, -- Shadowstep
		[GetSpellInfo(44521)] = 1, -- Preparation
	},

	BUFF_SPELLS = {
		-- Druid
		[GetSpellInfo(16810)] = 1, -- Nature's Grasp,
		[GetSpellInfo(17116)] = 1, -- Nature's Swiftness,
		[GetSpellInfo(22842)] = 1, -- Frenzied Regeneration,
		[GetSpellInfo(29166)] = 1, -- Innervate,
		[GetSpellInfo(53191)] = 1, -- Starfall,
		[GetSpellInfo(43317)] = 1, -- Dash,
		
		-- Death Knight
		[GetSpellInfo(50514)] = 1, -- Summon Gargoyle,
		[GetSpellInfo(58130)] = 1, -- Icebound Fortitude,
		[GetSpellInfo(49028)] = 1, -- Dancing Rune Weapon,
		[GetSpellInfo(55213)] = 1, -- Hysteria,
		
		-- Mage
		[GetSpellInfo(29976)] = 1, -- Presence of Mind,
		[GetSpellInfo(36911)] = 1, -- Ice Block,
		[GetSpellInfo(25641)] = 1, -- Frost Ward,
		[GetSpellInfo(37844)] = 1, -- Fire Ward,
		[GetSpellInfo(54160)] = 1, -- Arcane Power,
		[GetSpellInfo(11392)] = 1, -- Invisibility,
		[GetSpellInfo(49264)] = 1, -- Blazing Speed,
		[GetSpellInfo(57761)] = 1, -- Fireball!,
		[GetSpellInfo(28682)] = 1, -- Combustion,
		[GetSpellInfo(12472)] = 1, -- Icy Veins,
		
		-- Shaman
		[GetSpellInfo(6742)] = 1, -- Bloodlust,
		[GetSpellInfo(64701)] = 1, -- Elemental Mastery,
		[GetSpellInfo(23689)] = 1, -- Heroism,
		
		-- Warlock
		[GetSpellInfo(17941)] = 1, -- Shadow Trance,
		[GetSpellInfo(37673)] = 1, -- Metamorphosis,
		
		-- Rogue
		[GetSpellInfo(57840)] = 1, -- Killing Spree,
		[GetSpellInfo(28752)] = 1, -- Adrenaline Rush,
		[GetSpellInfo(33735)] = 1, -- Blade Flurry,
		[GetSpellInfo(51713)] = 1, -- Shadow Dance,
		[GetSpellInfo(61922)] = 1, -- Sprint,
		[GetSpellInfo(8822)] = 1, -- Stealth,
		[GetSpellInfo(15087)] = 1, -- Evasion,
		[GetSpellInfo(39666)] = 1, -- Cloak of Shadows,
		
		-- Warrior
		[GetSpellInfo(46924)] = 1, -- Bladestorm
		[GetSpellInfo(12976)] = 1, -- Last Stand
		[GetSpellInfo(13847)] = 1, -- Recklessness
		[GetSpellInfo(20240)] = 1, -- Retaliation
		[GetSpellInfo(15062)] = 1, -- Shield Wall
		[GetSpellInfo(12292)] = 1, -- Death Wish
		[GetSpellInfo(9943)] = 1, -- Spell Reflection

		-- Paladin
		[GetSpellInfo(43430)] = 1, -- Avenging Wrath
		[GetSpellInfo(66115)] = 1, -- Hand of Freedom
		[GetSpellInfo(41450)] = 1, -- Blessing of Protection
		[GetSpellInfo(13874)] = 1, -- Divine Shield
		[GetSpellInfo(13007)] = 1, -- Divine Protection
		[GetSpellInfo(6940)] = 1, -- Hand of Sacrifice
		[GetSpellInfo(53601)] = 1, -- Sacred Shield
		[GetSpellInfo(54428)] = 1, -- Divine Plea

		-- Hunter
		[GetSpellInfo(31567)] = 1, -- Deterrence	
		[GetSpellInfo(34692)] = 1, -- The Beast Within

		-- Priest
		[GetSpellInfo(44416)] = 1, -- Pain Suppression
		[GetSpellInfo(37274)] = 1, -- Power Infusion
		[GetSpellInfo(47585)] = 1, -- Dispersion

		-- Racial
		[GetSpellInfo(69575)] = 1, -- Stoneform
		[GetSpellInfo(24378)] = 1, -- Berserking
	},
}