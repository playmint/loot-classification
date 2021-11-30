// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
LootCLassification.sol
Lootverse Utility contract to classifyitems found in Loot (For Adventurers) Bags.

See OG Loot Contract for lists of all possible items.
https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7

All functions are made public incase they are useful but the expected use is through the main
3 classification functions:

- getRank()
- getClass()
- getMaterial()

Each of these take an item 'Type' (weapon, chest, head etc.) 
and an index into the list of all possible items of that type as found in the OG Loot contract.

The LootComponents contract can be used to get item indexes from Loot bag tokenIDs.
So a typical use might be:

// get weapon classification for loot bag# 1234
{
    LootComponents components = 
        LootComponents(0x3eb43b1545a360d1D065CB7539339363dFD445F3);
    LootClassification classification = 
        LootClassification(_TBD_);

    uint256[5] memory weaponComponents = components.weaponComponents(1234);
    uint256 index = weaponComponents[0];

    LootClassification.Type itemType = LootClassification.Type.Weapon;
    LootClassification.Class class = classification.getClass(itemType, index);
    LootClassification.Material material = classification.getMaterial(itemType, index);
    uint256 rank = classification.getRank(itemType, index);
}
*/
contract LootClassification
{
    enum Type
    {
        Weapon,
        Chest,
        Head,
        Waist,
        Foot,
        Hand,
        Neck,
        Ring
    }
    
    enum Material
    {
        Heavy,
        Medium,
        Dark,
        Light,
        Cloth,
        Hide,
        Metal,
        Jewellery
    }
    
    enum Class
    {
        Warrior,
        Hunter,
        Mage,
        Any
    }
    
    uint256 constant public WeaponLastHeavyIndex = 4;
    uint256 constant public WeaponLastMediumIndex = 9;
    uint256 constant public WeaponLastDarkIndex = 13;
    
    function getWeaponMaterial(uint256 index) pure public returns(Material)
    {
        if (index <= WeaponLastHeavyIndex)
            return Material.Heavy;
        
        if (index <= WeaponLastMediumIndex)
            return Material.Medium;
        
        if (index <= WeaponLastDarkIndex)
            return Material.Dark;
        
        return Material.Light;
    }
    
    function getWeaponRank(uint256 index) pure public returns (uint256)
    {
        if (index <= WeaponLastHeavyIndex)
            return index + 1;
        
        if (index <= WeaponLastMediumIndex)
            return index - 4;
        
        if (index <= WeaponLastDarkIndex)
            return index - 9;
        
        return index -13;
    }
    
    uint256 constant public ChestLastClothIndex = 4;
    uint256 constant public ChestLastLeatherIndex = 9;
    
    function getChestMaterial(uint256 index) pure public returns(Material)
    {
        if (index <= ChestLastClothIndex)
            return Material.Cloth;
        
        if (index <= ChestLastLeatherIndex)
            return Material.Hide;
        
        return Material.Metal;
    }
    
    function getChestRank(uint256 index) pure public returns (uint256)
    {
        if (index <= ChestLastClothIndex)
            return index + 1;
        
        if (index <= ChestLastLeatherIndex)
            return index - 4;
        
        return index - 9;
    }
    
    // Head, waist, foot and hand items all follow the same classification pattern,
    // so they are generalised as armour.
    uint256 constant public ArmourLastMetalIndex = 4;
    uint256 constant public ArmourLasLeatherIndex = 9;
    
    function getArmourMaterial(uint256 index) pure public returns(Material)
    {
        if (index <= ArmourLastMetalIndex)
            return Material.Metal;
        
        if (index <= ArmourLasLeatherIndex)
            return Material.Hide;
        
        return Material.Cloth;
    }
    
    function getArmourRank(uint256 index) pure public returns (uint256)
    {
        if (index <= ArmourLastMetalIndex)
            return index + 1;
        
        if (index <= ArmourLasLeatherIndex)
            return index - 4;
        
        return index - 9;
    }
    
    function getRingRank(uint256 index) pure public returns (uint256)
    {
        return index + 1;
    }
    
    function getNeckRank(uint256 index) pure public returns (uint256)
    {
        return 3 - index;
    }
    
    function getMaterial(Type lootType, uint256 index) pure public returns (Material)
    {
         if (lootType == Type.Weapon)
            return getWeaponMaterial(index);
            
        if (lootType == Type.Chest)
            return getChestMaterial(index);
            
        if (lootType == Type.Head ||
            lootType == Type.Waist ||
            lootType == Type.Foot ||
            lootType == Type.Hand)
        {
            return getArmourMaterial(index);
        }
            
        return Material.Jewellery;
    }
    
    function getClass(Type lootType, uint256 index) pure public returns (Class)
    {
        Material material = getMaterial(lootType, index);
        return getClassFromMaterial(material);
    }

    function getClassFromMaterial(Material material) pure public returns (Class)
    {   
        if (material == Material.Heavy || material == Material.Metal)
            return Class.Warrior;
            
        if (material == Material.Medium || material == Material.Hide)
            return Class.Hunter;
            
        if (material == Material.Dark || material == Material.Light || material == Material.Cloth)
            return Class.Mage;
            
        return Class.Any;
        
    }
    
    function getRank(Type lootType, uint256 index) pure public returns (uint256)
    {
        if (lootType == Type.Weapon)
            return getWeaponRank(index);
            
        if (lootType == Type.Chest)
            return getChestRank(index);
        
        if (lootType == Type.Head ||
            lootType == Type.Waist ||
            lootType == Type.Foot ||
            lootType == Type.Hand)
        {
            return getArmourRank(index);
        }
        
        if (lootType == Type.Ring)
            return getRingRank(index);
            
        return getNeckRank(index);  
    }
}