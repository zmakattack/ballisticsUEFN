<img width="977" height="744" alt="image" src="https://github.com/user-attachments/assets/f1dc226d-96f3-46be-9d44-35a2cf24ad55" /># ballisticsUEFN
Here is a brief tutorial on how to set up my balistics shop in your fortnite maps
before you import anything into the project make sure custom items and inventories is enabled otherwise this will not work
<img width="1257" height="863" alt="image" src="https://github.com/user-attachments/assets/132a3b01-350e-4666-a5a0-f884b2417db0" />


once you put the file in your content drawer make sure you resave all

<img width="355" height="349" alt="image" src="https://github.com/user-attachments/assets/6e47ee8b-d0f9-4e4f-a367-a086a31cbb72" />

If you don't know where to find your project right click the level and select show in explorer
then you can download the github repo to there
<img width="484" height="309" alt="image" src="https://github.com/user-attachments/assets/f9328ba3-76f3-40e8-8d3d-0b9c8cf9bd96" />


Now make sure you compile verse code
<img width="977" height="744" alt="image" src="https://github.com/user-attachments/assets/9c107a0a-687e-474b-8dbf-e60accdacb26" />


Once that is all done you can open the Ballistics folder and drag in the default shop entity into the level and launch a session, you should be able to load into a game and purchase items from it
<img width="1917" height="1071" alt="image" src="https://github.com/user-attachments/assets/385b77d2-831e-4cf7-846c-affa9b0303af" />


By default you will see that no flex gadget shows up in your player info panel and your currency isn't being spent
I have purpousley left these blank so you can integrate it with your existing systems, say you had your own currency system you could put your code in there and it will automatically link up and work with the shop
and the same with the flex gadgets, since this is only a shop and not a flex gadget selector I left that empty incase you want to set up your own
<img width="953" height="434" alt="image" src="https://github.com/user-attachments/assets/f97dac36-9f9f-4a53-b403-87d839b89e9a" />
you can find the functions ontop of the ballistics_shop_component.verse file


if you want to add different items to the shop you can do so by modifying the items in the different columns
<img width="736" height="333" alt="image" src="https://github.com/user-attachments/assets/3f0e56c4-0ef6-421f-8fa1-a91abd0b8535" />
ItemType: the item you will get when purchasing

WeaponType: the identifier the weapon uses to make sure a player can only have one of them,e.g make sure a player can only have one main gun and one sub weapon
default labels for weaponType is "GUN" this refers to main weapons like rifles and shotguns, and "SIDEARM" which is used for pistols you can make them anything, but "GUN" and "SIDEARM" is used for the player icons

OverrideItemTexture: by default it will use the icon the weapon has in the hotbar, which is different to how they look in ballistics shop, so by using this you can set your own texture for an item

Cost: how many credits this item costs

MaxQuantity: this only works for items that stack but it allows you to purchase multiple

you can also check out the `presets.verse` file to see some of the presets I made to mimic the ballistics shop
<img width="595" height="583" alt="image" src="https://github.com/user-attachments/assets/ba2d0cb3-ef2a-4857-9124-4c871bd70def" />


now have fun messing around with this make sure you customize the widget blueprints to look nice!
and mention @UEFNZmakattack when you make something with it, I want to see
