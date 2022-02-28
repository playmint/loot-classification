# LootClassification.sol

This is a Lootverse utility contract to classify items found in Loot (For Adventurers) Bags.

See the [original Loot Contract](https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7) for lists of all possible items.

See [loot.foundation](https://loot.foundation/) for an explanation of the classifications used.


## Intended Use

This contract is deployed to ethereum mainnent with addresses tracked in the table below.

The intention is that other Lootverse contracts can directly reefrence the deployed version of this and interact with it's public interface.

## Modification

If new functionality is required,

1. Make a PR to this repository.
2. Deploy the contract to mainnet to work with your project.
3. Make another PR to this repository with the deploy address added to the table below.

In future, a this code could be modified to be an upgradeable contract so that existing contracts can receive updates when the lore is updated. At this point some consideration will need to be made to avoid making breaking changes.

## Authorised Updates

Updates to this contract can be discussed in this GitHub repo and/or in the Loot Builders discord https://discord.gg/5HApxRqbAW

In future ownership of this repository and the latest deployed contract should be transferred to a Loot DAO.


## How to Use

All functions are made public incase they are useful but the expected use is through the main
3 classification functions:
- getRank()
- getClass()
- getMaterial()

and 3 stats functions:
- getLevel()
- getGreatness()
- getRating()

Each of these take an item 'Type' (weapon, chest, head etc.) 
and an index into the list of all possible items of that type as found in the OG Loot contract.

The [LootComponents contract](https://etherscan.io/address/0x3eb43b1545a360d1D065CB7539339363dFD445F3#code) can be used to get item indexes from Loot bag tokenIDs.
The code from LootComponents is also copied into this contract and rewritten for gas efficiency, which may be preferable to use if the classification functions are required in a transaction call.

So a typical use in your own lootverse Solidity contract might be:
```
// instantiate contract object
LootClassification classification = 
    LootClassification(0xC6Df003DC044582A45e712BA219719410013ad63);

// get component array for loot bag# 1234
uint256[5] memory weaponComponents = classification.weaponComponents(1234);

// get weapon index as first element of component array (we're ignoring suffixes and prefixes here)
uint256 index = weaponComponents[0];

// class, material and rank can now all be derived from the index for Type Weapon
LootClassification.Class class = classification.getClass(LootClassification.Type.Weapon, index);
LootClassification.Material material = classification.getMaterial( LootClassification.Type.Weapon, index);
uint256 rank = classification.getRank( LootClassification.Type.Weapon, index);

// greatness, level, and rating can be all derived from just tokenId
uint256 level = classification.getLevel(itemType, 1234);
uint256 greatness = classification.getGreatness(itemType, 1234);
uint256 rating = classification.getRating(itemType, 1234);
```

## Deploy History

| Project | Commit | Deployed address link |
|---------|---------------------|-----------------------|
| The Crypt: Chapter one | [a254244aaebdbe8ca5e4b2e28fc9138cfa529f51](https://github.com/playmint/loot-classification/tree/a254244aaebdbe8ca5e4b2e28fc9138cfa529f51)| [0xC6Df003DC044582A45e712BA219719410013ad63](https://etherscan.io/address/0xC6Df003DC044582A45e712BA219719410013ad63) |
| The Genesis Project v2  | [f8d64e4ea071585cbb505ed795491573ad5f9135](https://github.com/playmint/loot-classification/tree/f8d64e4ea071585cbb505ed795491573ad5f9135)| [0x04190EF3D7C91C881D335725B6BB5d45236B22AE](https://etherscan.io/address/0x04190EF3D7C91C881D335725B6BB5d45236B22AE) |

