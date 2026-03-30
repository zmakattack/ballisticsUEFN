using { /Verse.org/Simulation }
using { /Verse.org/SceneGraph }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Itemization }
using { /Verse.org/Presentation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/ControlInput }
using { /Verse.org/Input/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }

(Agent : agent).GetCredits()<transacts>: int = 9999

(Agent : agent).SetCredits(NewCredits : int) : void = {}

(Agent : agent).GetFlexGadgetIndex()<transacts>: int = 0 #Used to show what flex gadget the agent has




(Agent : agent).GetWeaponOfType(Type : string)<transacts>: entity =
    if (Inventory := GetRootInventory[Agent]):
        for (Item : Inventory.FindItems(),PurchasedComp := Item.GetComponent[purchased_item_component],PurchasedComp.Type = Type):
            return Item
    return Agent

GetRootInventory<public>(Agent:agent)<decides><transacts>:inventory_component =
    Inventory := (for (I : Agent.FindDescendantComponents(inventory_component)) { I })[0]




EmptyMessage<localizes> : message = "N?A"
column_info := class:
    @editable Categories : []category_info = array:

category_info := class:
    @editable Name: string = ""
    @editable Items : []item_info = array{}


(InventoryEntity:entity).FindItem(ItemEntity:subtype(entity))<computes><reads><decides>:item_component =
    Items := InventoryEntity.GetComponent[inventory_component].FindItems()
    FoundItems := 
        for:
            Item : Items
            ItemEntity[Item]
        do: 
            Item
    FoundItems[0].GetComponent[item_component]

item_info := class:
    #FindItem[ItemType{}]
    @editable ItemType : concrete_subtype(entity)
    
    @editable WeaponType : string = "GUN"
    
    @editable OverrideItemTexture : ?texture = false
    @editable Cost : int = 500
    @editable MaxQuantity : type {_X:int where 1 <= _X, _X <= 3} = 1



    var ItemInfo : ?tuple(message,texture) = false
    GetQuantity(Agent : agent)<transacts>: int = GetRootInventory[Agent].Entity.FindItem[ItemType].Entity.GetComponent[stackable_component].StackSize or 0
    GetItemInfo() : tuple(message,texture) =
        ItemInfo? or block:
            NewItem := ItemType{}
            Result := if (Desc := NewItem.GetComponent[description_component].Name,Icon := OverrideItemTexture? or NewItem.GetComponent[icon_component].Icon):
                R := (Desc,Icon)
                R
            else:
                (EmptyMessage,Screenshot_20260328_132316)
            set ItemInfo = option{Result}

            Result

    CreatePurchaseUI(Agent : agent,CloseEvent : event(),MainComponent : ballistics_shop_component) : widget =
        PurchaseScreen := WBP_ItemPurchase{}
        QuantityTrackers := if (MaxQuantity <= 1){array{}}else. for (I := 1..MaxQuantity){QuantityControl.WBP_QuantityTracker{}}
        Info :=GetItemInfo()
        spawn:
            Agent.ControlPurchase(PurchaseScreen,CloseEvent,QuantityTrackers,MainComponent)
        set PurchaseScreen.Icon = Info(1)
        set PurchaseScreen.Name = Info(0)
        set PurchaseScreen.Cost = Cost
        if (OverrideItemTexture?):
        else:
            set PurchaseScreen.IconWidth = 84
            set PurchaseScreen.IconHeight = 84
        return overlay:
            Slots := array:
                overlay_slot:
                    Widget := PurchaseScreen
                overlay_slot:
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top:=8.0,Right:=8.0}
                    Widget := stack_box:
                        Orientation := orientation.Vertical

                        Slots := for (Tracker : QuantityTrackers):
                            stack_box_slot:
                                Widget := Tracker
                                Padding := margin{Bottom:=2.0}


    (Agent : agent).ControlPurchase(Widget : WBP_ItemPurchase,CloseEvent : event(),QuantityWidgets : []QuantityControl.WBP_QuantityTracker,MainComponent : ballistics_shop_component)<suspends> : void =
        race:
            CloseEvent.Await()
            loop:
                Quantity := GetQuantity(Agent)
                if (Quantity > 0):
                    for (I := 1..Quantity,QuantityWidget := QuantityWidgets[I-1]):
                        set QuantityWidget.Selected = true
                Widget.SelectedEvent.Await()
                PurchaseItem(Agent)
                MainComponent.UpdatePlayer(Agent)


    PurchaseItem(Agent : agent) : logic =
        if ((Agent.GetCredits() + (if (Comp := Agent.GetWeaponOfType(WeaponType).GetComponent[purchased_item_component],Comp.CanRefund[Agent]){Comp.RefundCost}else{0})) >= Cost):
            if (GetQuantity(Agent) < MaxQuantity):
                Agent.SetCredits(Agent.GetCredits()-Cost)
                PurchasedItem(Agent)
                Print("Purchased")
                return true
            else:
                Print("too greedy")
        else:
            Print("No funds")
        return false

    PurchasedItem(Agent : agent) : void =
        if (Inventory := GetRootInventory[Agent]):
            
            NewItem := ItemType{}
            if (NewStackable := NewItem.GetComponent[stackable_component]):
                NewStackable.SetMaxStackSize(option{MaxQuantity},?ClampStackSize:=false)
                Print("Adjusted stack size  stack size of {NewStackable.MaxStackSize? or -1}")
            else:
                Print("Unable to adjust stack size")
            var FoundSelfItem : ?entity = false
            for (Item : Inventory.FindItems(),PurchasedComp := Item.GetComponent[purchased_item_component],PurchasedComp.Type = WeaponType):
                if (NewItem.GetComponent[stackable_component].CanMergeInto[Item]): #If the new stackable can merge into the old Item
                    Print("Item " + ToDiagnostic(NewItem) + "Can merge into existing item of " + ToDiagnostic(Item))
                    set FoundSelfItem = option{Item}
                else:
                    Inventory.RemoveItem(Item)
                    if (PurchasedComp.Purchaser = Agent):
                        PurchasedComp.RefundItem(Agent)

            if (Stackable := FoundSelfItem?,NewStackable := NewItem.GetComponent[stackable_component]):
                Print("Existing item found with a stack size of {NewStackable.MaxStackSize? or -1}")
                if (Stackable.GetComponent[stackable_component].StackSize < MaxQuantity):
                    if (NewStackable.MergeInto[Stackable]):
                Print("Existing item found with a stack size of {NewStackable.MaxStackSize? or -1}")
            else:
                PurchasedComponent := purchased_item_component:
                    Entity := NewItem
                    Type := WeaponType
                    Purchaser := Agent
                    RefundCost := Cost
                NewItem.AddComponents(array{PurchasedComponent})
                
                Inventory.AddItemDistribute(NewItem)

        else:
            Print("No inventory?")





shield_item := class(item_info):
    @editable Strength : float = 50.0
    GetQuantity<override>(Agent : agent)<transacts>: int =
        Result := Floor[if (FC := Agent.GetFortCharacter[].GetShield()){FC/50.0}else{0.0}] or 0
        return Result
    PurchasedItem<override>(Agent : agent) : void =
        NewShield := (GetQuantity(Agent)+1)*Strength
        if (FC := Agent.GetFortCharacter[]):
            FC.SetShield(NewShield)

    ShieldMessage<localizes>(Amount : int) : message = "{Amount} SHIELD"
    GetItemInfo<override>() : tuple(message,texture) =
        ItemInfo? or block:
            NewItem := ItemType{}
            Result := if (Icon := OverrideItemTexture? or NewItem.GetComponent[icon_component].Icon):
                R := (ShieldMessage(Floor[Strength] or 0),Icon)
                R
            else:
                (ShieldMessage(Floor[Strength] or 0),Screenshot_20260328_132316)
            set ItemInfo = option{Result}

            Result


purchased_item_component := class<final_super>(component):
    Type : string
    Purchaser : agent
    RefundCost : int
    OnSimulate<override>()<suspends> : void =#Delete this if you want players to be able to hold multiple of the same types of weapon
        if (Item :=  Entity.GetComponent[item_component],Inventory :=Item.GetParentInventory[]): 
            loop:
                Result := Inventory.AddItemEvent.Await()
                for (NewItem : Result.AddedItems,PurchasedComp :=NewItem.GetComponent[purchased_item_component],PurchasedComp<>Self):
                    if (PurchasedComp.Type = Type):
                        Item.Unequip()
                        if:
                            Item.Drop[]
                            
    CanRefund(Agent : agent)<transacts><decides> : void = Purchaser = Agent

    RefundItem(Agent : agent) : void =
        Agent.SetCredits(Agent.GetCredits()+RefundCost)








ballistics_shop_component := class<final_super>(component):
    @editable FlexGadgetImages : []texture = array:
    @editable Columns : []column_info = array{}


    OnSimulate<override>()<suspends> : void =
        if (Interact := Entity.GetComponent[interactable_component]):
            loop:
                Sleep(-1.0)
                Agent :agent= Interact.SucceededEvent.Await()
                Result := CreateUI(Agent)
                
    
    GetName<localizes>(Agent : agent) : message = "{Agent}"


    UpdatePlayer(Agent : agent) : void =
        for (Pack : OtherDisplays[Agent]):
            Print("Updating player")
            WBP := Pack(1)
            set WBP.Name = GetName(Agent)
            set WBP.Credits = Agent.GetCredits()
            if (Icon := FlexGadgetImages[Agent.GetFlexGadgetIndex()]):
                set WBP.FlexTexture = Icon
                set WBP.HasFlexGadget = true
            else:
                set WBP.HasFlexGadget = false
            if (Icon := Agent.GetWeaponOfType("GUN").GetComponent[icon_component].Icon or Agent.GetWeaponOfType("SIDEARM").GetComponent[icon_component].Icon):
                set WBP.MainTexture = Icon
                set WBP.HasMainWeapon = true
            else:
                set WBP.HasMainWeapon = false
            
            if (Pack(0) = Agent):
                set WBP.IsOwner = 1
            if (FC := Agent.GetFortCharacter[]):
                Shield := FC.GetShield()
                ShieldA := Shield /FC.GetMaxShield()
                set WBP.Shield = Floor[Shield] or 00
                set WBP.ShieldA = ShieldA
                if (Icon := FC.GetEntity[].GetComponent[icon_component].Icon):
                    set WBP.CharacterTexture = Icon


                    
    var SelfDisplays : [agent][]WBP_PlayerInfo = map{} #Shows all the widgets currently shown to the player
    var OtherDisplays : [agent][]tuple(agent,WBP_PlayerInfo) = map{} #contains all of the widgets that reference the player and the agent that is viewing them

    CreateUI<public>(Agent : agent) : tuple(canvas,event()) =
        Backdrop := WBP_Backdrop{}
        CloseEvent := Backdrop.ClosedEvent
        var PlayerWidgets : []widget = array{}
        if (Playspace := Entity.GetPlayspaceForEntity[].GetTeamCollection()):
            PlayerDisplayWidgets := for (Teammate : Playspace.GetAgents[Playspace.GetTeam[Agent]]):
                WBP := WBP_PlayerInfo{}
                set PlayerWidgets += array{WBP}
                set WBP.Name = GetName(Teammate)
                set WBP.Credits = Teammate.GetCredits()
                if (Icon := FlexGadgetImages[Teammate.GetFlexGadgetIndex()]):
                    set WBP.FlexTexture = Icon
                    set WBP.HasFlexGadget = true
                else:
                    set WBP.HasFlexGadget = false
                if (Icon := Teammate.GetWeaponOfType("GUN").GetComponent[icon_component].Icon or Teammate.GetWeaponOfType("SIDEARM").GetComponent[icon_component].Icon):
                    set WBP.MainTexture = Icon
                    set WBP.HasMainWeapon = true
                else:
                    set WBP.HasMainWeapon = false
                if (Teammate = Agent):
                    set WBP.IsOwner = 1
                if (FC := Teammate.GetFortCharacter[]):
                    Shield := FC.GetShield()
                    ShieldA := Shield /FC.GetMaxShield()
                    set WBP.Shield = Floor[Shield] or 00
                    set WBP.ShieldA = ShieldA
                    if (Icon := FC.GetEntity[].GetComponent[icon_component].Icon):
                        set WBP.CharacterTexture = Icon
                if:
                    set OtherDisplays[Teammate] = (OtherDisplays[Teammate]+ array{(Agent,WBP)}) or array{(Agent,WBP)}
                then:
                    Print("Assigned other display")
                else:
                    Print("Failed")
                WBP
            if:
                set SelfDisplays[Agent] = PlayerDisplayWidgets
                
        Canvas := canvas:
            Slots := array:
                canvas_slot:
                    SizeToContent := true
                    Widget := Backdrop
                    Anchors := anchors{Minimum:=vector2{X:=0.0,Y:=0.0},Maximum:=vector2{X:=1.0,Y:=1.0}}
                canvas_slot:
                    SizeToContent := true
                    Anchors := anchors{Minimum:=vector2{X:=0.5,Y:=0.5},Maximum:=vector2{X:=0.5,Y:=0.5}}
                    Offsets := margin{Top:=-480.0,Left:=-470.0}
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := for (Column : Columns):
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Widget := Agent.CreateColumn(Column,CloseEvent)
                                Padding := margin{Right:=12.0}
                canvas_slot:
                    SizeToContent := true
                    Anchors := anchors{Minimum:=vector2{X:=0.0,Y:=0.0},Maximum:=vector2{X:=0.0,Y:=0.0}}
                    Offsets := margin{Top:=150.0,Left:=70.0}
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := for (Teammate : PlayerWidgets):
                            stack_box_slot:
                                Widget := Teammate
                                Padding := margin{Bottom:=20.0}
        spawn:
            ManageUI(Agent,CloseEvent,Canvas)
        set Backdrop.DisplayCredits = Agent.GetCredits()
        (Canvas,CloseEvent)




    ManageUI(Agent : agent,CancelEvent : event(),Canvas : canvas)<suspends> : void =
        if(PlayerInput := GetPlayerInput[player[Agent]]):
            if (Player:=player[Agent], PlayerUI:=GetPlayerUI[Player]):
                PlayerInput.AddInputMapping(MenuNavigationMapping)
                PlayerUI.AddWidget(Canvas,player_ui_slot{InputMode:=ui_input_mode.All})
                CancelEvent.Await()
                PlayerUI.RemoveWidget(Canvas)
                PlayerInput.RemoveInputMapping(MenuNavigationMapping)
        for (Key ->Other : OtherDisplays):
            var NewArray : []tuple(agent,WBP_PlayerInfo) = array{}
            for (OtherWidgets : Other):
                WBP := OtherWidgets(1)
                OtherAgent := OtherWidgets(0)
                if (OtherAgent <> Agent):
                    set NewArray += array{OtherWidgets}
            if:
                set OtherDisplays[Key] = NewArray
        if:
            set SelfDisplays[Agent] = array{}

    StM<localizes>(S : string) : message = "{S}"
    (Agent : agent).CreateColumn(Column : column_info,CloseEvent : event()) : stack_box =
        var Widgets : []widget = array{}
        for (Category : Column.Categories):
            W := WBP_BallisticsCategoryHeader{}
            set W.Name = StM(Category.Name)
            W
            set Widgets += array{W}
            for (Item : Category.Items):
                PurchaseWidget := Item.CreatePurchaseUI(Agent,CloseEvent,Self)
                
                set Widgets += array{PurchaseWidget}
                

        StackBox := stack_box:
            Orientation := orientation.Vertical
            Slots := for (Widget :Widgets):
                stack_box_slot:
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Widget := Widget
                    Padding := margin{Bottom:=12.0}
        
        if (Player:=player[Agent], PlayerUI:=GetPlayerUI[Player]):
            PlayerUI.SetFocus(Widgets[0] or color_block{})
        return StackBox