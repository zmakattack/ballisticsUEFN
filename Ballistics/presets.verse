using { /Verse.org/Simulation }
using { /Fortnite.com/Items/RangerPistol/Ballistic }
using { /Fortnite.com/Items/HandCannon/Ballistic }
using { /Fortnite.com/Items/MachinePistol/Ballistic }
using { /Fortnite.com/Items/FrenzyAutoShotgun/Ballistic }
using { /Fortnite.com/Items/HammerPumpShotgun/Ballistic }
ballistics_column_1 := class(column_info):
    @editable Categories<override>: []category_info = array:
        category_info:
            Name := "SIDEARMS"
            Items := array:
                item_info:
                    WeaponType := "SIDEARM"
                    ItemType := RangerPistol_Common
                    Cost := 0
                item_info:
                    WeaponType := "SIDEARM"
                    ItemType := HandCannon_Common
                    Cost := 800
                item_info:
                    WeaponType := "SIDEARM"
                    ItemType := MachinePistol_Common
                    Cost := 500
    
        category_info:
            Name := "SHOTGUNS"
            Items := array:
                item_info:
                    WeaponType := "GUN"
                    ItemType := FrenzyAutoShotgun_Common
                    Cost := 1500
                item_info:
                    WeaponType := "GUN"
                    ItemType := HammerPumpShotgun_Common
                    Cost := 900


using { /Fortnite.com/Items/ThunderBurstSMG/Ballistic }
using { /Fortnite.com/Items/HyperSMG/Ballistic }
using { /Fortnite.com/Items/VeiledPrecisionSMG/Ballistic }
using { /Fortnite.com/Items/DrumGun/Ballistic }
using { /Fortnite.com/Items/ReaperSniperRifle/Ballistic }
using { /Fortnite.com/Items/SovereignSniper/Ballistic }
ballistics_column_2 := class(column_info):
    @editable Categories<override>: []category_info = array:
        category_info:
            Name := "SMGS"
            Items := array:
                item_info:
                    ItemType := ThunderBurstSMG_Common
                    Cost := 1100
                item_info:
                    ItemType := HyperSMG_Common
                    Cost := 1800
                item_info:
                    ItemType := VeiledPrecisionSMG_Common
                    Cost := 2300
                item_info:
                    ItemType := DrumGun_Common
                    Cost := 3200
    
        category_info:
            Name := "RANGED"
            Items := array:
                item_info:
                    ItemType := ReaperSniperRifle_Common
                    Cost := 4500
                item_info:
                    ItemType := SovereignSniper_Common
                    Cost := 1500

using { /Fortnite.com/Items/NemesisAR/Ballistic }
using { /Fortnite.com/Items/EnforcerAR/Ballistic }
using { /Fortnite.com/Items/StrikerAR/Ballistic }
using { /Fortnite.com/Items/BurstAR/Ballistic }
ballistics_column_3 := class(column_info):
    @editable Categories<override>: []category_info = array:
        category_info:
            Name := "RIFLES"
            Items := array:
                item_info:
                    ItemType := NemesisAR_Common
                    Cost := 2700
                item_info:
                    ItemType := EnforcerAR_Common
                    Cost := 2000
                item_info:
                    ItemType := StrikerAR_Common
                    Cost := 2700
                item_info:
                    ItemType := BurstAR_Common
                    Cost := 2300


using { /Fortnite.com/Items/Flashbang/Ballistic }
using { /Fortnite.com/Items/SmokeGrenade/Ballistic }
using { /Fortnite.com/Items/SmallShieldPotion/BattleRoyale/CH5S1 }
using { /Fortnite.com/Items/BlizzardGrenade/BattleRoyale/CH6S1 }
ballistics_column_4 := class(column_info):
    
    @editable Categories<override>: []category_info = array:
        category_info:
            Name := "Consumable"
            Items := array:
                item_info:
                    MaxQuantity:=2
                    WeaponType := "FLASH"
                    ItemType := Flashbang_Common
                    Cost := 300
                item_info:
                    MaxQuantity:=2
                    WeaponType := "SMOKE"
                    ItemType := SmokeGrenade_Common
                    Cost := 300
<#                 item_info:
                    MaxQuantity:=2
                    WeaponType := "GRENADE"
                    ItemType := BlizzardGrenade_Rare
                    Cost := 300 #>
    
        category_info:
            Name := "Shields"
            Items := array:
                shield_item:
                    MaxQuantity:=2
                    WeaponType := "HEAL"
                    ItemType := SmallShieldPotion_Uncommon
                    Cost := 500

<# column_info := class:
    @editable Categories : []category_info = array:

category_info := class:
    @editable Name: string = ""
    @editable Items : []item_info = array{}


item_info := class:
    @editable WeaponType : string = "GUN"
    @editable ItemType : concrete_subtype(entity)
    @editable OverrideItemTexture : ?texture = false
    @editable Cost : int = 500 #>