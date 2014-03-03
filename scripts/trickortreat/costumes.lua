local Costume = require "trickortreat.costume"

local costumes = {}

function TrickOrTreat_AddCostume( costume )
	table.insert( costumes, costume )
end

TrickOrTreat_AddCostume( Costume( "tree", "a tree", {bushhat=0.75, armorwood=0.75}, 1.5 ) )
--TrickOrTreat_AddCostume( Costume( "nature", "nature", {bushhat=0.75, flowerhat=0.5, armorgrass=0.25}, 0.75 ) )
--TrickOrTreat_AddCostume( Costume( "bird", "a bird", {featherhat=0.75}, 0.75 ) )
TrickOrTreat_AddCostume( Costume( "spider", "a spider", {spiderhat=1, armor_sanity=0.25, armorslurper=0.5}, 1 ) )
TrickOrTreat_AddCostume( Costume( "footballplayer", "a football player", {footballhat=1, armormarble=0.5}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "caveman", "a caveman", {hambat=0.75, armorgrass=0.75, armorslurper=0.75, beefalohat=0.5}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "hiker", "a hiker", {cane=0.75, backpack=0.75, piggyback=0.75, krampus_sack=1.25}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "gentleman", "a gentleman", {tophat=0.75, sweatervest=0.75, cane=0.75}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "farmer", "a farmer", {strawhat=0.75, pitchfork=0.75, armorgrass=0.25}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "miner", "a miner", {minerhat=0.75, pickaxe=0.75, goldenpickaxe=1, multitool_axe_pickaxe=1.25, armorgrass=0, armorwood=0}, 1.5 ) )
TrickOrTreat_AddCostume( Costume( "entomologist", "an entomologist", {beehat=1, bugnet=1, armorgrass=0, armorwood=0}, 2 ) )
TrickOrTreat_AddCostume( Costume( "nightman", "The Nightman", {nightsword=1, armor_sanity=1}, 2 ) )
TrickOrTreat_AddCostume( Costume( "warrior", "a warrior", {slurtlehat=1, armorgrass=0, armorwood=0.25, armormarble=0.5, armorruins=0.75, spear=1}, 2 ) )
TrickOrTreat_AddCostume( Costume( "ancientwarrior", "an ancient warrior", {armorruins=0.75, ruinshat=0.75, ruins_bat=0.75}, 2 ) )
TrickOrTreat_AddCostume( Costume( "oldperson", "an old person", {walrushat=1, sweatervest=0.5, cane=1}, 2 ) )
TrickOrTreat_AddCostume( Costume( "icefisher", "an ice fisher", {winterhat=1, trunkvest_summer=1, trunkvest_winter=1, fishingrod=1}, 3 ) )
TrickOrTreat_AddCostume( Costume( "weirdo", "a weirdo", {onemanband=.75, umbrella=.75, beefalohat=0.5, featherhat=0.5, beehat=0.5, spiderhat=0.5, footballhat=0.5, earmuffshat=0.5, winterhat=0.5, bushhat=0.5, flowerhat=0.5, slurtlehat=0.5}, 2 ) )
TrickOrTreat_AddCostume( Costume( "tribalhunter", "a tribal hunter", {featherhat=0.5, bushhat=0.5, armorgrass=0.5, spear=0.75, axe=0.75, golenaxe=0.75, multitool_axe_pickaxe=1, lucy=0.75, blowdart_pipe=0.75, blowdart_fire=0.75, blowdart_sleep=0.75 }, 1.75 ) )
TrickOrTreat_AddCostume( Costume( "king", "a king", {ruinshat=1, armorruins=1, icestaff=0.75, firestaff=0.75, telestaff=0.75, yellowstaff=1, orangestaff=1, greenstaff=1 }, 2.5 ) )
TrickOrTreat_AddCostume( Costume( "flavorflav", "Flavor Flav", {yellowamulet=2, beefalohat=1, ruinshat=1, tophat=1 }, 3 ) )
TrickOrTreat_AddCostume( Costume( "snurtle", "a snurtle", {armorsnurtleshell=1}, 1 ) )
TrickOrTreat_AddCostume( Costume( "tmnsnurtle", "a Teenage Mutant Ninja Snurtle", {armorsnurtleshell=1, flowerhat=0.75, spear=1}, 2.75 ) ) -- don't have the right items to do this properly, but I couldn't resist
TrickOrTreat_AddCostume( Costume( "batman", "Batman", {armor_sanity=1, boomerang=1}, 2 ) )
TrickOrTreat_AddCostume( Costume( "dovahkiin", "the Dovahkiin", {beefalohat=0.5, armormarble=0.75, nightsword=0.75}, 2 ) )
TrickOrTreat_AddCostume( Costume( "metaldetector", "a metal detector", {diviningrod=1, footballhat=1, earmuffshat=1}, 2 ) )
TrickOrTreat_AddCostume( Costume( "indianajones", "Indiana Jones", {strawhat=1, shovel=0.5, goldenshovel=0.75}, 1.5 ) )

return costumes