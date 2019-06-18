Scriptname PovertyMCM extends SKI_ConfigBase
{Script created by Evrymetul with help from ReDragon}


;---------------------------------------------------------------------------------------------


;------------ STANDARD GLOBALS ----------------------------
  GlobalVariable PROPERTY pIngredient                     auto 
  GlobalVariable PROPERTY pHarvestIngredientsFlora        auto 
  GlobalVariable PROPERTY pHarvestIngredientsNPC          auto 
  GlobalVariable PROPERTY pPotion                         auto        
  GlobalVariable PROPERTY pAmmo                           auto        
  GlobalVariable PROPERTY pAmmoNPC                        auto 
  GlobalVariable PROPERTY pArmor                          auto  
  GlobalVariable PROPERTY pWeapon                         auto
  GlobalVariable PROPERTY pBook                           auto
  GlobalVariable PROPERTY pBookSpell                      auto
  GlobalVariable PROPERTY pClutter                        auto
  GlobalVariable PROPERTY pResource                       auto
  GlobalVariable PROPERTY pHarvestResourceNPC             auto
  GlobalVariable PROPERTY pSoulGem                        auto
  GlobalVariable PROPERTY pDrink                          auto
  GlobalVariable PROPERTY pFood                           auto
  GlobalVariable PROPERTY pHarvestFoodFlora               auto
  GlobalVariable PROPERTY pHarvestFoodFloraHanging        auto
  GlobalVariable PROPERTY pHarvestFoodNPC                 auto
  GlobalVariable PROPERTY pGold                           auto
  GlobalVariable PROPERTY pMerchantGold                   auto
  
  
;------------------ PATCHER GLOBALS --------------------------- 

  GlobalVariable PROPERTY pAmmoPatcher                    auto
  GlobalVariable PROPERTY pArmorPatcher                   auto
  GlobalVariable PROPERTY pBookPatcher                    auto
  GlobalVariable PROPERTY pIngredientPatcher              auto
  GlobalVariable PROPERTY pMiscItemPatcher                auto
  GlobalVariable PROPERTY pPotionPatcher                  auto
  GlobalVariable PROPERTY pScrollPatcher                  auto
  GlobalVariable PROPERTY pSoulGemPatcher                 auto
  GlobalVariable PROPERTY pWeaponPatcher                  auto
  
  
  
  

  Int[] a   



;--------------------------------------------------
FUNCTION myF_ADD(Int n, String s, GlobalVariable g)  
;--------------------------------------------------
    AddHeaderOption(s)
    a[n] = AddSliderOption("", g.GetValue(), "{0}")        
;    AddEmptyOption()        
ENDFUNCTION



;------------------------------------
FUNCTION myF_Dialog(GlobalVariable g)
;------------------------------------

    SetSliderDialogStartValue( g.GetValue() )    
    SetSliderDialogDefaultValue(0)
    SetSliderDialogRange(0, 100)
    SetSliderDialogInterval(1)
ENDFUNCTION


;-------------------------------------------------
FUNCTION myF_SET(Int n, Float f, GlobalVariable g)  
;-------------------------------------------------


    SetSliderOptionValue(a[n], f, "{0}%")
    g.SetValue(f) 	
ENDFUNCTION


; -- EVENTs -- 3

;===================
EVENT OnConfigInit()
;===================
    a = new Int[30]                    
    Pages = new String[1]
    Pages[0] = "Removal Percentages"
ENDEVENT



;=============================
EVENT OnPageReset(String page)
;=============================
    SetCursorFillMode(TOP_TO_BOTTOM)
    SetCursorPosition(0)

    myF_ADD(0,  "Alchemy Ingredients",                                                         pIngredient)
	myF_ADD(1,  "Flora Ingredients",                                                           pHarvestIngredientsFlora)
	myF_ADD(2,  "Creature Ingredients/Poison",                                                 pHarvestIngredientsNPC)
	myF_ADD(3,  "Potions",                                                                     pPotion)
	myF_ADD(4,  "Arrows",                                                                      pAmmo)   
    myF_ADD(5,  "NPC Arrows",                                                                  pAmmoNPC)	
    myF_ADD(6,  "Armor",                                                                       pArmor)
    myF_ADD(7,  "Weapons",                                                                     pWeapon)	
    myF_ADD(8,  "Books",                                                                       pBook)
    myF_ADD(9,  "Spellbook/Scrolls",                                                           pBookSpell)
    myF_ADD(10, "Clutter ",                                                                    pClutter)
    myF_ADD(11, "Crafting Materials",                                                          pResource)
	myF_ADD(12, "Animal Crafting Materials",                                                   pHarvestResourceNPC)
    myF_ADD(13, "Soul Gems ",                                                                  pSoulGem)		
	myF_ADD(14, "Alcohol",                                                                     pDrink)        
    myF_ADD(15, "Food",                                                                        pFood)
    myF_ADD(16, "Crops",                                                                       pHarvestFoodFlora)
	myF_ADD(17, "Hanging Food",                                                                pHarvestFoodFloraHanging)
    myF_ADD(18, "Animal Meat",                                                                 pHarvestFoodNPC)	
    myF_ADD(19, "Gold ",                                                                       pGold)
    myF_ADD(20, "Merchant Gold",                                                               pMerchantGold)
    myF_ADD(21, "Patcher: Ammo",                                                               pAmmoPatcher)
    myF_ADD(22, "Patcher: Armor",                                                              pArmorPatcher)
    myF_ADD(23, "Patcher: Book",                                                               pBookPatcher)
    myF_ADD(24, "Patcher: Ingredient",                                                         pIngredientPatcher)
    myF_ADD(25, "Patcher: Misc Item",                                                          pMiscItemPatcher)
    myF_ADD(26, "Patcher: Potion",                                                             pPotionPatcher)
    myF_ADD(27, "Patcher: Scroll",                                                             pScrollPatcher)
    myF_ADD(28, "Patcher: Soul Gem",                                                           pSoulGemPatcher)
    myF_ADD(29, "Patcher: Weapon",                                                             pWeaponPatcher)	
ENDEVENT


;===================================
EVENT OnOptionSliderOpen(Int option)
;===================================


IF (option == a[0])    
    myF_Dialog(pIngredient)
    RETURN    ; - STOP - 1
ENDIF
;---------------------
IF (option == a[1])    
    myF_Dialog(pHarvestIngredientsFlora)
    RETURN    ; - STOP - 2
ENDIF
;---------------------
IF (option == a[2])    
    myF_Dialog(pHarvestIngredientsNPC)
    RETURN    ; - STOP - 3
ENDIF
;---------------------
IF (option == a[3])    
    myF_Dialog(pPotion)
    RETURN    ; - STOP - 4
ENDIF
;---------------------
IF (option == a[4])    
    myF_Dialog(pAmmo)
    RETURN    ; - STOP - 5
ENDIF
;---------------------
IF (option == a[5])    
    myF_Dialog(pAmmoNPC)
    RETURN    ; - STOP - 6
ENDIF
;---------------------
IF (option == a[6])     
    myF_Dialog(pArmor)
    RETURN    ; - STOP - 7
ENDIF
;---------------------
IF (option == a[7])    
    myF_Dialog(pWeapon)
    RETURN    ; - STOP - 8
ENDIF
;---------------------
IF (option == a[8])    
    myF_Dialog(pBook)
    RETURN    ; - STOP - 9
ENDIF
;---------------------
IF (option == a[9])     
    myF_Dialog(pBookSpell)
    RETURN    ; - STOP - 10
ENDIF
;---------------------
IF (option == a[10])     
    myF_Dialog(pClutter)
    RETURN    ; - STOP - 11
ENDIF
;---------------------
IF (option == a[11])     
    myF_Dialog(pResource)
    RETURN    ; - STOP - 12
ENDIF
;---------------------
IF (option == a[12])    
    myF_Dialog(pHarvestResourceNPC)
    RETURN    ; - STOP - 13
ENDIF
;---------------------
IF (option == a[13])    
    myF_Dialog(pSoulGem)
    RETURN    ; - STOP - 14
ENDIF
;---------------------
IF (option == a[14])    
    myF_Dialog(pDrink)
    RETURN    ; - STOP - 15
ENDIF
;---------------------
IF (option == a[15])    
    myF_Dialog(pFood)
    RETURN    ; - STOP - 16
ENDIF
;---------------------
IF (option == a[16])   
    myF_Dialog(pHarvestFoodFlora)
    RETURN    ; - STOP - 17
ENDIF
;---------------------
IF (option == a[17])   
    myF_Dialog(pHarvestFoodFloraHanging)
    RETURN    ; - STOP - 18
ENDIF
;---------------------
IF (option == a[18])   
    myF_Dialog(pHarvestFoodNPC)
    RETURN    ; - STOP - 19
ENDIF
;---------------------
IF (option == a[19])   
    myF_Dialog(pGold)
    RETURN    ; - STOP - 20
ENDIF
;---------------------
IF (option == a[20])    
    myF_Dialog(pMerchantGold)
    RETURN    ; - STOP - 21
ENDIF
;---------------------
IF (option == a[21])    
    myF_Dialog(pAmmoPatcher)
    RETURN    ; - STOP - 22
ENDIF
;---------------------
IF (option == a[22])    
    myF_Dialog(pArmorPatcher)
    RETURN    ; - STOP - 23
ENDIF
;---------------------
IF (option == a[23])    
    myF_Dialog(pBookPatcher)
    RETURN    ; - STOP - 24
ENDIF
;---------------------
IF (option == a[24])    
    myF_Dialog(pIngredientPatcher)
    RETURN    ; - STOP - 25
ENDIF
;---------------------
IF (option == a[25])    
    myF_Dialog(pMiscItemPatcher)
    RETURN    ; - STOP - 26
ENDIF
;---------------------
IF (option == a[26])    
    myF_Dialog(pPotionPatcher)
    RETURN    ; - STOP - 27
ENDIF
;---------------------
IF (option == a[27])     
    myF_Dialog(pScrollPatcher)
    RETURN    ; - STOP - 28
ENDIF
;---------------------
IF (option == a[28])    
    myF_Dialog(pSoulGemPatcher)
    RETURN    ; - STOP - 29
ENDIF
;---------------------
IF (option == a[29])    
    myF_Dialog(pWeaponPatcher)
;;;    RETURN    ; - STOP - 30
ENDIF



ENDEVENT

;==================================================
EVENT OnOptionSliderAccept(Int option, Float value)
;==================================================


IF (option == a[0])    
    myF_SET(0, value, pIngredient)
    RETURN    ; - STOP - 1
ENDIF
;---------------------
IF (option == a[1])    
    myF_SET(1, value, pHarvestIngredientsFlora)
    RETURN    ; - STOP - 2
ENDIF
;---------------------
IF (option == a[2])    
    myF_SET(2, value, pHarvestIngredientsNPC)
    RETURN    ; - STOP - 3
ENDIF
;---------------------
IF (option == a[3])    
    myF_SET(3, value, pPotion)
    RETURN    ; - STOP - 4
ENDIF
;---------------------
IF (option == a[4])    
    myF_SET(4, value, pAmmo)
    RETURN    ; - STOP - 5
ENDIF
;---------------------
IF (option == a[5])    
    myF_SET(5, value, pAmmoNPC)
    RETURN    ; - STOP - 6
ENDIF
;---------------------
IF (option == a[6])     
    myF_SET(6, value, pArmor)
    RETURN    ; - STOP - 7
ENDIF
;---------------------
IF (option == a[7])    
    myF_SET(7, value, pWeapon)
    RETURN    ; - STOP - 8
ENDIF
;---------------------
IF (option == a[8])   
    myF_SET(8, value, pBook)
    RETURN    ; - STOP - 9
ENDIF
;---------------------
IF (option == a[9])    
    myF_SET(9, value, pBookSpell)
    RETURN    ; - STOP - 10
ENDIF
;---------------------
IF (option == a[10])    
    myF_SET(10, value, pClutter)
    RETURN    ; - STOP - 11
ENDIF
;---------------------
IF (option == a[11])    
    myF_SET(11, value, pResource)
    RETURN    ; - STOP - 12
ENDIF
;---------------------
IF (option == a[12])    
    myF_SET(12, value, pHarvestResourceNPC)
    RETURN    ; - STOP - 13
ENDIF
;---------------------
IF (option == a[13])    
    myF_SET(13, value, pSoulGem)
    RETURN    ; - STOP - 14
ENDIF
;---------------------
IF (option == a[14])    
    myF_SET(14, value, pDrink)
    RETURN    ; - STOP - 15
ENDIF
;---------------------
IF (option == a[15])    
    myF_SET(15, value, pFood)
    RETURN    ; - STOP - 16
ENDIF
;---------------------
IF (option == a[16])   
    myF_SET(16, value, pHarvestFoodFlora)
    RETURN    ; - STOP - 17
ENDIF
;---------------------
IF (option == a[17])   
    myF_SET(17, value, pHarvestFoodFloraHanging)
    RETURN    ; - STOP - 18
ENDIF
;---------------------
IF (option == a[18])   
    myF_SET(18, value, pHarvestFoodNPC)
    RETURN    ; - STOP - 19
ENDIF
;---------------------
IF (option == a[19])   
    myF_SET(19, value, pGold)
    RETURN    ; - STOP - 20
ENDIF
;---------------------
IF (option == a[20])    
    myF_SET(20, value, pMerchantGold)
    RETURN    ; - STOP - 21
ENDIF
;---------------------
IF (option == a[21])    
    myF_SET(21, value, pAmmoPatcher)
    RETURN    ; - STOP - 22
ENDIF
;---------------------
IF (option == a[22])    
    myF_SET(22, value, pArmorPatcher)
    RETURN    ; - STOP - 23
ENDIF
;---------------------
IF (option == a[23])    
    myF_SET(23, value, pBookPatcher)
    RETURN    ; - STOP - 24
ENDIF
;---------------------
IF (option == a[24])    
    myF_SET(24, value, pIngredientPatcher)
    RETURN    ; - STOP - 25
ENDIF
;---------------------
IF (option == a[25])    
    myF_SET(25, value, pMiscItemPatcher)
    RETURN    ; - STOP - 26
ENDIF
;---------------------
IF (option == a[26])    
    myF_SET(26, value, pPotionPatcher)
    RETURN    ; - STOP - 27
ENDIF
;---------------------
IF (option == a[27])     
    myF_SET(27, value, pScrollPatcher)
    RETURN    ; - STOP - 28
ENDIF
;---------------------
IF (option == a[28])    
    myF_SET(28, value, pSoulGemPatcher)
    RETURN    ; - STOP - 29
ENDIF
;---------------------
IF (option == a[29])   
    myF_SET(29, value, pWeaponPatcher)
;;;   RETURN    ; - STOP - 30
ENDIF

ENDEVENT
