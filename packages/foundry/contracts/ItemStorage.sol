// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ItemStorage {
  struct Item {
    string _id;
    string address_;
    string builder_id;
    string date;
    string img_data;
    string name;
    uint256 rarity;
    string itemType;
  }

  struct ItemGroup {
    Item BACKGROUND;
    Item HEAD;
    Item WEAPON;
    Item ARMOR;
  }

  mapping(uint256 => ItemGroup) public items;
  uint256 public itemCount;

  function storeItem(Item memory background, Item memory head, Item memory weapon, Item memory armor) public {
    items[itemCount] = ItemGroup(background, head, weapon, armor);
    itemCount++;
  }
}
