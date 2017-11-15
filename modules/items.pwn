// modules/items.pwn

#define MAX_ITEMS 10000
#define MAX_GUN   5

#define FLAG_ITEM_PLACE_GROUND 1
#define FLAG_ITEM_PLACE_APLAYER 2

#define DIALOG_ITEM_LIST 40
#define DIALOG_ITEM_LIST_MORE 41
#define DIALOG_ITEM_ADD_AMMO 42
#define DIALOG_ITEM_ADD_MAGAZINE 43
#define DIALOG_ITEM_RAISE 44

/*
TODO: grill, mo¿liwoœc pieczenia jedzenia. Czas pieczenia zale¿ny od iloœci hp ile doda. 
*/


enum iItems
{
	iUID,
	iType,
	iName[36],
	iOwner,
	iOwnerType,
	iValue1, //e.g id weapons 
	iValue2, //e.g ammo
	iValue3, //weight
	iValue4, //e.g id object in-game
	iValue5, // e.g dmg
	iValue6[36], //e.g name magazine in weapon
	iValue7, //e.g max ammo we w³o¿onym do broni magazynku
	iSlot,
	iPlace,
	Float:iPosX,
	Float:iPosY,
	Float:iPosZ,
	iVW,
	iUsed,
	iBase,
	iObjectID,
	Text3D:iTextID
};

new Item[MAX_ITEMS][iItems];
new Iterator:Item<MAX_ITEMS>;

new WeaponSlot[47] = {
	0, 0, 
	1, 1, 1, 1, 1, 1, 1, 1,
	10, 10, 10, 10, 10, 10,
	8, 8, 8, 
	-1, -1, -1, 
	2, 2, 2,
	3, 3, 3,
	4, 4,
	5, 5,
	4,
	6, 6,
	7, 7, 7, 7,
	8, 
	12,
	9, 9, 9,
	11, 11, 11
};

CMD:ap(playerid, params[])
{
	if(Player[playerid][Admin] < 3) return GameTextForPlayer(playerid, "~r~Brak autoryzacji!", 3000, 3);
	new command[32], option[30];
	if(sscanf(params, "s[32]S()[30]", command, option)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /aitems [create]");
	
	if(!strcmp(command, "create", true))//CreateItem(type, name[36], owner, ownertype, value1, value2, value3, value4, value5, place, Float:x, Float:y, Float:z, vw)
	{
		new type, name[36], names[36], owner, ownertype, value1, value2, value3, value4, value5, place, equipment;
		if(sscanf(option, "ds[36]ddddddddd", type, name, owner, ownertype, value1, value2, value3, value4, value5, place, equipment)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /aitems [type] [name] [owner] [ownertype] [value1] [value2] [value3] [value4] [value5] [place] [equipment]");
		mysql_real_escape_string(name, names);
		
		if(type > 0 && type < 20 && owner > 0 && ownertype > 0) return SendClientMessage(playerid, COLOR_GRAD1, "Wyst¹pi³ b³¹d podczas tworzenia przedmiotu!");
		SendClientMessage(playerid, COLOR_LORANGE, "Przedmiot stworzony!");
		
		if(place == FLAG_ITEM_PLACE_GROUND)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			//CreateItem(type, names, owner, ownertype, value1, value2, value3, value4, value5, value6, place, x, y, z, GetPlayerVirtualWorld(playerid));
		}
		
		//CreateItem(type, names, owner, ownertype, value1, value2, value3, value4, value5, place, 0, 0, 0, 0);
		
	}
	return 1;
}	
CMD:p(playerid, params[])
{
	new command[32]/*, string[512]*/, option[30]; //query[256]
	if(sscanf(params, "s[32]S()[30]", command, option)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /przedmioty [lista]");
   	
	if(!strcmp(command, "lista", true))
	{
		ListPlayerItem(playerid);
		/*new x = 1;
		foreach(new i : Item)
		{
			if(Item[i][iOwner] == Player[playerid][UID])
			{
				if(Item[i][iUsed]) format(string, sizeof(string), "%s%d.{0099ff} %s{000000}(%d, %d)\t\t", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2]);
				else format(string, sizeof(string), "%s%d. %s{000000}(%d, %d)\t\t", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2]);
				
				if(Item[i][iValue3] > 1000) format(string, sizeof(string), "%s%0.1fkg\t\t%d\n", string, floatdiv(float(Item[i][iValue3]), 1000), Item[i][iUID]);
				else format(string, sizeof(string), "%s%ddag\t\t%d\n", string, Item[i][iValue3], Item[i][iUID]);
				x++;
			}
		}
		if(x - 1 == 0) return GameTextForPlayer(playerid, "~r~Nie posiadasz zadnych przedmiotow!", 3000, 3);
		else return ShowPlayerDialog(playerid, DIALOG_ITEM_LIST, DIALOG_STYLE_LIST, "{4876FF}Przedmioty{a9c4e4} » Lista", string, "U¿yj", "Wiêcej");*/
	}
	return 1;
}

CallBack:ListPlayerItem(playerid)
{
	new x = 1, string[1000];
	format(string, sizeof(string), "» Poka¿ pobliskie przedmioty\n» Funkcja zaznaczania przedmiotów\n- -------------------\n");
	foreach(new i : Item)
	{
		if(Item[i][iOwner] == Player[playerid][UID] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER)//use: 0099ff
		{
			if(Item[i][iUsed]) format(string, sizeof(string), "%s{ffffff}%d. %s{000000}(%d, %d)\t\t", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2]);
			else format(string, sizeof(string), "%s{cdcdcd}%d. %s{000000}(%d, %d)\t\t", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2]);
				
			if(Item[i][iValue3] > 1000) format(string, sizeof(string), "%s%0.1fkg\t\t%d\n", string, floatdiv(float(Item[i][iValue3]), 1000), Item[i][iUID]);
			else format(string, sizeof(string), "%s%ddag\t\t%d\n", string, Item[i][iValue3], Item[i][iUID]);
			x++;
		}
	}
	if(x - 1 == 0) strcat(string, "{990033}Nie posiadasz ¿adnych przedmiotów");
	return ShowPlayerDialog(playerid, DIALOG_ITEM_LIST, DIALOG_STYLE_LIST, "{4876FF}Przedmioty{a9c4e4} » Lista", string, "Wybierz", "Zamknij");
}

CallBack:LoadItems()
{
	new query[612], index;
	format(query, sizeof(query), "SELECT * FROM `"prefix"items` WHERE `place` = '%d' AND `owner` = '0'", FLAG_ITEM_PLACE_GROUND);
	mysql_query(query);
	mysql_store_result();
	print(query);
	
	while(mysql_fetch_row_format(query, "|"))
	{
		index = GetFreeIndexItems();
		sscanf(query, "p<|>dds[36]{d}dddddds[36]d{d}fffdd{d}",
			Item[index][iUID], 		Item[index][iType], 		Item[index][iName],
			/*Item[index][iOwner],*/ 	Item[index][iOwnerType], 	Item[index][iValue1],
			Item[index][iValue2], 	Item[index][iValue3], 		Item[index][iValue4], 		Item[index][iValue5], Item[index][iValue6], 	Item[index][iValue7],
			/*Item[index][iPlace],*/ 	Item[index][iPosX],			Item[index][iPosY],			Item[index][iPosZ],
			Item[index][iVW], 		Item[index][iSlot]/*, 		Item[index][iUsed]*/);//used
			
		Item[index][iOwner] = 0; 	Item[index][iPlace] = FLAG_ITEM_PLACE_GROUND; 	Item[index][iUsed] = 0;
		printf("%d, %d, %s, %d, %d, %d, %d", Item[index][iUID], Item[index][iType], Item[index][iName], Item[index][iOwner], Item[index][iPlace], Item[index][iSlot]);
			
		Iter_Add(Item, index);	
		//CreateStreamObject(Item[index][iValue1], Item[index][iPosX],	Item[index][iPosY],	Item[index][iPosZ], 0.0, 0.0, 0.0, 50.0, -1, Item[index][iVW])
		if(Item[index][iType] == ITEM_WEAPON) Item[index][iObjectID] = CreateStreamObject(Item[index][iValue4], Item[index][iPosX], Item[index][iPosY], Item[index][iPosZ] - 0.9, -90.0, 0.0, 0.0, 80.0, _, Item[index][iVW]);
		Item[index][iTextID] = CreateDynamic3DTextLabel(Item[index][iName], COLOR_GRAD1, Item[index][iPosX], Item[index][iPosY], Item[index][iPosZ] - 1.0, 2.0, _, _, _, Item[index][iVW]);
	}
	printf("Server: Loaded %d items", index);
}

CallBack:SaveItems(index)
{
	new query[512];
	format(query, sizeof(query), "UPDATE `"prefix"items` SET `id` = '%d', `type` = '%d', `name` = '%s', `owner` = '%d', `ownertype` = '%d', `value1` = '%d', `value2` = '%d', \
															 `value3` = '%d', `value4` = '%d', `value5` = '%d', `value6` = '%s', `value7` = '%d', `place` = '%d', `x` = '%f', `y` = '%f', `z` = '%f', `vw` = '%d', `slot` = '%d', `used` = '%d' WHERE `id` = '%d'",
			Item[index][iUID], 		Item[index][iType], 		Item[index][iName],
			Item[index][iOwner], 	Item[index][iOwnerType], 	Item[index][iValue1],
			Item[index][iValue2], 	Item[index][iValue3], 		Item[index][iValue4], 		Item[index][iValue5],	Item[index][iValue6], Item[index][iValue7],
			Item[index][iPlace], 	Item[index][iPosX],			Item[index][iPosY],			Item[index][iPosZ],
			Item[index][iVW], 		Item[index][iSlot],			Item[index][iUsed],	 		Item[index][iUID]);				
	//print(query);
	mysql_query(query);
	mysql_store_result();
}

CallBack:LoadItemsPlayer(playerid)
{
	new query[612], index, i = 1;
	format(query, sizeof(query), "SELECT * FROM `"prefix"items` WHERE `owner` = '%d' AND `place` = '%d'", Player[playerid][UID], FLAG_ITEM_PLACE_APLAYER);
	mysql_query(query);
	mysql_store_result();
	print(query);
	
	while(mysql_fetch_row_format(query, "|"))
	{
		index = GetFreeIndexItems();
		sscanf(query, "p<|>dds[36]ddddddds[36]ddfffddd",
			Item[index][iUID], 		Item[index][iType], 		Item[index][iName],
			Item[index][iOwner], 	Item[index][iOwnerType], 	Item[index][iValue1],
			Item[index][iValue2], 	Item[index][iValue3], 		Item[index][iValue4], Item[index][iValue5], 	Item[index][iValue6], 	Item[index][iValue7],
			Item[index][iPlace], 	Item[index][iPosX],			Item[index][iPosY],			Item[index][iPosZ],
			Item[index][iVW], 		Item[index][iSlot], 		Item[index][iUsed]);
		printf("uid: %d, name: %s, wight: %d, used: %d", Item[index][iUID], Item[index][iName], Item[index][iValue3], Item[index][iUsed]);
		Iter_Add(Item, index);
		i++;
	}
	printf("server: Loaded %d items player %s(uid: %d)", i - 1, Player[playerid][Name], Player[playerid][UID]);
}

/*CallBack:SaveItemsPlayer(playerid, index)
{
	new query[512];
	format(query, sizeof(query), "UPDATE `"prefix"items` SET `id` = '%d', `type` = '%d', `name` = '%d', `owner` = '%d', `ownertype` = '%d', `value1` = '%d', `value2` = '%d', \
															 `value3` = '%d', `value4` = '%d', `place` = '%d', `x` = '%f', `y` = '%f', `z` = '%f', `vw` = '%d', `used` = '%d' WHERE `owner` = '%d'",
			Item[index][iUID], 		Item[index][iType], 		Item[index][iName],
			Item[index][iOwner], 	Item[index][iOwnerType], 	Item[index][iValue1],
			Item[index][iValue2], 	Item[index][iValue3], 		Item[index][iValue4],
			Item[index][iPosX],		Item[index][iPosY],			Item[index][iPosZ],
			Item[index][iVW], 		Item[index][iUsed],		 	Player[playerid][UID]);							
}*/

CallBack:OnPlayerUseItem(playerid, itemuid)
{
	new index = GetIndexItemByUID(itemuid), string[128], x = 1, query[128];
	//printf("DEBUG: %s(%d) chcial uzyc: %s(%d)", Player[playerid][Name], Player[playerid][UID], Item[index][iName], itemuid);
	if(Item[index][iOwner] != Player[playerid][UID]) return printf("ERROR_TIEM: %s(%d) chcial uzyc: %s(%d)", Player[playerid][Name], Player[playerid][UID], Item[index][iName], itemuid);
	
	if(Item[index][iType] == ITEM_WEAPON)
	{
		if(!Item[index][iUsed] || Item[index][iUsed] && Item[index][iBase]) //Przedmiot nie u¿ywany lub przedmiot u¿ywany przed wyjœciem gracza
		{
			if(Item[index][iValue2] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "Ta broñ nie posiada amunicji!");
			if(IDWeaponBySlot(playerid, WeaponSlot[Item[index][iValue1]]) && (Item[index][iValue1] != 22 || Item[index][iValue1] != 28 ||Item[index][iValue1] != 29 ||Item[index][iValue1] != 32)) return SendClientMessage(playerid, COLOR_GRAD2, "U¿ywasz ju¿ tego typu broñ!");
		
			switch(Item[index][iSlot])
			{
				case FIRST_WEAPON: if(Gun[playerid][FIRST_WEAPON][gun_id] > 0) return SendClientMessage(playerid, COLOR_GRAD2, "U¿ywasz ju¿ jednej g³ównej broni!");
				case SECOND_WEAPON: if(Gun[playerid][SECOND_WEAPON][gun_id] > 0) return SendClientMessage(playerid, COLOR_GRAD2, "U¿ywasz ju¿ jednej pobocznej broni!");
				case THIRD_WEAPON: if(Gun[playerid][THIRD_WEAPON][gun_id] > 0) return SendClientMessage(playerid, COLOR_GRAD2, "U¿ywasz ju¿ jednej bia³ej broni!");
				case ADDITIONAL_WEAPON: if(Gun[playerid][ADDITIONAL_WEAPON][gun_id] > 0) return SendClientMessage(playerid, COLOR_GRAD2, "U¿ywasz ju¿ jednej dodatkowej broni!");
			}
			
			if(Player[playerid][AutomaticGun] && !Gun[playerid][ADDITIONAL_WEAPON][gun_id])//left
			{
				if(Item[index][iSlot] == SECOND_WEAPON)
				{
					SetPlayerAttachedObject(playerid, ADDITIONAL_WEAPON, Item[index][iValue4], 5, 0.023881, 0.032546, -0.031955, 329.643127, 169.763153, 175.414199, 1.000000, 1.000000, 1.000000);
					
					Gun[playerid][ADDITIONAL_WEAPON][gun_id] = Item[index][iValue1];
					Gun[playerid][ADDITIONAL_WEAPON][gun_model] = Item[index][iValue4];
					Gun[playerid][ADDITIONAL_WEAPON][gun_index] = index;
					
					SetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON", 1);
				}
			}
			else if(Item[index][iValue4] > 0)//right
			{
				SetPlayerAttachedObject(playerid, Item[index][iSlot], Item[index][iValue4], 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000);
				switch(Item[index][iSlot])
				{
					case FIRST_WEAPON: SetPVarInt(playerid, "AttachedWeapon_FIRST_WEAPON", 1);
					case SECOND_WEAPON: SetPVarInt(playerid, "AttachedWeapon_SECOND_WEAPON", 1);
					case THIRD_WEAPON: SetPVarInt(playerid, "AttachedWeapon_THIRD_WEAPON", 1);
					case ADDITIONAL_WEAPON: SetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON", 1);
				}
				
				Gun[playerid][Item[index][iSlot]][gun_id] = Item[index][iValue1];
				Gun[playerid][Item[index][iSlot]][gun_model] = Item[index][iValue4];
				Gun[playerid][Item[index][iSlot]][gun_index] = index;
			}	
			
			if(Item[index][iValue1] == 22 || Item[index][iValue1] == 28 ||Item[index][iValue1] == 29 ||Item[index][iValue1] == 32 && !Player[playerid][AutomaticGun])
			{
				Player[playerid][AutomaticGun] = 1;
			}
			
			GivePlayerWeapon(playerid, Item[index][iValue1], Item[index][iValue2]);

			Item[index][iUsed] = 1;	
			Item[index][iBase] = 0;
			
			format(query, sizeof(query), "UPDATE `"prefix"items` SET `used` = '%d' WHERE `id` = '%d' LIMIT 1", Item[index][iUsed], Item[index][iUID]);
			mysql_query(query);
			mysql_store_result();
		}
		else if(Item[index][iUsed])
		{
			if(!isnull(Item[index][iValue6])) Item[index][iValue2] = GetWeaponAmmo(playerid, Item[index][iValue1]);
			RemovePlayerWeapon(playerid, Item[index][iValue1]);
			
			if(Item[index][iValue4] > 0)
			{
				switch(Item[index][iSlot])
				{
					case FIRST_WEAPON: 
					{	
						SetPVarInt(playerid, "AttachedWeapon_FIRST_WEAPON", 0);		
						RemovePlayerAttachedObject(playerid, FIRST_WEAPON);	
						ClearArrayGun(playerid, FIRST_WEAPON);
					}
					case SECOND_WEAPON: 
					{	
						SetPVarInt(playerid, "AttachedWeapon_SECOND_WEAPON", 0);		
						RemovePlayerAttachedObject(playerid, SECOND_WEAPON);	
						ClearArrayGun(playerid, SECOND_WEAPON);
					}
					case THIRD_WEAPON: 
					{	
						SetPVarInt(playerid, "AttachedWeapon_THIRD_WEAPON", 0);		
						RemovePlayerAttachedObject(playerid, THIRD_WEAPON);	
						ClearArrayGun(playerid, THIRD_WEAPON);
					}
					case ADDITIONAL_WEAPON: 
					{	
						SetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON", 0);		
						RemovePlayerAttachedObject(playerid, ADDITIONAL_WEAPON);	
						ClearArrayGun(playerid, ADDITIONAL_WEAPON);
					}
				}
			}	
			Item[index][iUsed] = 0;	
			
			format(query, sizeof(query), "UPDATE `"prefix"items` SET `used` = '%d' WHERE `id` = '%d' LIMIT 1", Item[index][iUsed], Item[index][iUID]);
			mysql_query(query);
			mysql_store_result();
		}
	}
	
	if(Item[index][iType] == ITEM_MAGAZINE)//iValue1 = id broni, ivalue2 - ilosc amunicji, ivalue5 - maxymalna ilosc amunicji
	{
		if(Item[index][iValue2] <= 0) return SendClientMessage(playerid, COLOR_GRAD2, "Ten magazynek jest pusty!");
		SetPVarInt(playerid, "magazine", index);
		foreach(new i : Item)
		{
			if(Item[i][iOwner] == Player[playerid][UID] && Item[index][iValue1] == Item[i][iValue1] && Item[i][iType] == ITEM_WEAPON /*&& Item[i][iValue2] < Item[i][iValue5]*/)
			{
				format(string, sizeof(string), "%s%d. %s{000000}(%d, %d)\t\t%d\n", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2], Item[i][iUID]);
				x++;
			}
		}
		if(x - 1 == 0) return GameTextForPlayer(playerid, "~r~Nie posiadasz broni do tego magazynku!", 3000, 3);
		else return ShowPlayerDialog(playerid, DIALOG_ITEM_ADD_MAGAZINE, DIALOG_STYLE_LIST, "{4876FF}Przedmioty{a9c4e4} » Lista » Broñ", string, "W³ó¿", "Anuluj");
	}
	
	if(Item[index][iType] == ITEM_AMMO)//iValue1 - id broni, ivalue2 - ilosc amunicji, 
	{
		if(!Item[index][iValue2]) return 1;
		
		SetPVarInt(playerid, "i_ammo", index);
		//SetPVarInt(playerid, "i_magazine", index);

		foreach(new i : Item)
		{
			if(Item[i][iOwner] == Player[playerid][UID] && Item[index][iValue1] == Item[i][iValue1] && Item[i][iValue2] < Item[i][iValue5])
			{
				format(string, sizeof(string), "%s%d. %s{000000}(%d, %d)\t\t%d\n", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2], Item[i][iUID]);
				x++;
			}
		}
		if(x - 1 == 0) return GameTextForPlayer(playerid, "~r~Nie posiadasz zadnych pustych magazynkow!", 3000, 3);
		else return ShowPlayerDialog(playerid, DIALOG_ITEM_ADD_AMMO, DIALOG_STYLE_LIST, "{4876FF}Przedmioty{a9c4e4} » Lista » Amunicja", string, "Za³aduj", "Anuluj");
	}
	
	if(Item[index][iType] == ITEM_FOOD)//iValue1 = iloœæ dodawania HP
	{
		if(Player[playerid][HP] >= 20)
		{
			new Float:health;
			GetPlayerHealth(playerid, health);
			Player[playerid][HP] += Item[index][iValue1];
			SetPlayerHealth(playerid, Player[playerid][HP]);
			
			format(string, sizeof(string), "* %s spo¿ywa %s", Player[playerid][NameSpace], Item[index][iName]);
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.0, 2500);
		}
		else
		{
			print("w takim stanie nie pomoze ci ladowanie hp");
		}
		//DeleteItem(index);
	}
	if(Item[index][iType] == ITEM_CUFFS)
	{
		Item[index][iUsed] = 1;
	}

	if(Item[index][iType] == ITEM_PHONE)
	{
		if(Item[index][iUsed]) Item[index][iUsed] = 0;
		else Item[index][iUsed] = 1;
	}
	return 1;
}


CallBack:OnPlayerDropItem(playerid, itemuid)
{	
	new index = GetIndexItemByUID(itemuid);
	
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new Float:PosX, Float:PosY, Float:PosZ, query[200], vw = GetPlayerVirtualWorld(playerid);

		GetPlayerPos(playerid, PosX, PosY, PosZ);
		ServerMe(playerid, "coœ odk³ada", 1);

		format(query, sizeof(query), "UPDATE `"prefix"items` SET `owner` = '0', `place` = '%d', `x` = '%f', `y` = '%f', `z` = '%f', `vw` = '%d', `used` = '0' WHERE `id` = '%d' LIMIT 1", FLAG_ITEM_PLACE_GROUND, PosX, PosY, PosZ, vw, itemuid);
		mysql_query(query);
		mysql_store_result();
		print(query);
		
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		
		Item[index][iOwner] = 0;
		Item[index][iPosX] = PosX;
		Item[index][iPosY] = PosY;
		Item[index][iPosZ] = PosZ;
		Item[index][iVW] = vw;
		Item[index][iPlace] = FLAG_ITEM_PLACE_GROUND;
		if(Item[index][iType] == ITEM_WEAPON)
		{
			Item[index][iObjectID] = CreateStreamObject(Item[index][iValue4], PosX, PosY, PosZ - 0.9, -90.0, 0.0, 0.0, 80.0, GetPlayerInterior(playerid), vw);
			Item[index][iTextID] = CreateDynamic3DTextLabel(Item[index][iName], COLOR_GRAD1, PosX, PosY, PosZ - 1.0, 2.0, _, _, _, vw);
		}
		
		
	}
	return 1;
}

CallBack:OnPlayerRaiseItem(playerid, itemid)
{
	printf("%s podniós³ przedmiot %s[%d]", Player[playerid][Name], Item[itemid][iName], Item[itemid][iUID]);
	if(!Item[itemid][iOwner] && Item[itemid][iPlace] == FLAG_ITEM_PLACE_GROUND)
	{
		new string[52];
		Item[itemid][iOwner] = Player[playerid][UID];
		Item[itemid][iPlace] = FLAG_ITEM_PLACE_APLAYER;
		
		SaveItems(itemid);
		
		format(string, sizeof(string), "podnosi przedmiot %s", Item[itemid][iName]);
		ServerMe(playerid, string);
		
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		
		DestroyDynamic3DTextLabel(Item[itemid][iTextID]);
		DestroyStreamObject(Item[itemid][iObjectID]);
	}
	return 1;
}

CallBack:ListPlayerNearItems(playerid, Float:radius)
{
	ServerMe(playerid, "rozgl¹da siê.");
	ApplyAnimation(playerid, "ped", "XPRESSscratch", 4.0, 0, 0, 0, 0, 0);
	
	new string[256], x = 1;
	foreach(new i : Item)
	{
		if(!Item[i][iOwner] && Item[i][iPlace] == FLAG_ITEM_PLACE_GROUND && IsPlayerInRangeOfPoint(playerid, radius, Item[i][iPosX], Item[i][iPosY], Item[i][iPosZ]) && Item[i][iVW] == GetPlayerVirtualWorld(playerid))
		{
			format(string, sizeof(string), "%s%d. %s{000000}(%d, %d)\t\t", string, x, Item[i][iName], Item[i][iValue1], Item[i][iValue2]);
				
			if(Item[i][iValue3] > 1000) format(string, sizeof(string), "%s%0.1fkg\t\t%d\n", string, floatdiv(float(Item[i][iValue3]), 1000), Item[i][iUID]);
			else format(string, sizeof(string), "%s%ddag\t\t%d\n", string, Item[i][iValue3], Item[i][iUID]);
			x++;
		}
	}
	if(x - 1 == 0) return GameTextForPlayer(playerid, "~r~Nie znaleziono zadnych przedmiotow!", 3000, 3);
	else return ShowPlayerDialog(playerid, DIALOG_ITEM_RAISE, DIALOG_STYLE_LIST, "{4876FF}Przedmioty{a9c4e4} » Szukaj ", string, "Podnieœ", "Zamknij");
}

CallBack:DeleteItem(index)
{
	new query[50];
	format(query, sizeof(query), "DELETE FROM `"prefix"items` WHERE `id` = '%d'", Item[index][iUID]); 
	mysql_query(query);
	mysql_store_result();
	Iter_Remove(Item, index);
	for(new iItems:i; i != iItems; i++) Item[index][i] = 0;
	return 1;
}

stock CreateItem(type, name[], owner, ownertype, value1, value2, value3, value4 = 0, value5 = 0, value6[] = EOS, place, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, vw = 0)
{
	new query[358];
	format(query, sizeof(query), "INSERT INTO `"prefix"items`(`type`, `name`, `owner`, `ownertype`, `value1`, `value2`, `value3`, `value4`, `value5`, `value6`, `place`, `x`, `y`, `z`, `vw`) VALUES \
								('%d', '%s', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%s', '%d', '%f', '%f', '%f', '%d')", type, name, owner, ownertype, value1, value2, value3, value4, value5, value6, place, x, y, z, vw); 
	mysql_query(query);
	mysql_store_result();
	
	new uid = mysql_insert_id();
	new index = GetFreeIndexItems();
	
	Item[index][iUID] = uid;		Item[index][iType] = type;		Item[index][iOwner] = owner;	Item[index][iOwnerType] = ownertype;	
	Item[index][iValue1] = value1; 	Item[index][iValue2] = value2;	Item[index][iValue3] = value3; 	Item[index][iValue4]= value4;	Item[index][iValue5] = value5;	
	Item[index][iPosX] = x;			Item[index][iPosY] = y;			Item[index][iPosZ] = z;			Item[index][iVW] = vw;
	Item[index][iUsed] = 0;			format(Item[index][iName], 36, name); format(Item[index][iValue6], 36, value6);
	return uid;
}

stock IsPlayerHasItem(playerid, item_type, how_many = 0)
{
	new result = 0;
	foreach(new i : Item)
	{
		/*if(how_many)
		{
			if(Item[i][iType] == item_type && Item[i][iOwner] == Player[playerid][UID] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER) result++;
		}
		else if(Item[i][iType] == item_type && Item[i][iOwner] == Player[playerid][UID] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER) return i;*/
		
		if(Item[i][iType] == item_type && Item[i][iOwner] == Player[playerid][UID] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER)
		{
			if(how_many) result++;
			else return i;
		}
	}
	if(result > 0) return result;
	else return 0;
}

stock GetWeaponAmmo(playerid, weaponid)
{
	new ammo;
    GetPlayerWeaponData(playerid, WeaponSlot[weaponid], weaponid, ammo);
    return ammo;
}

stock IDWeaponBySlot(playerid, slot)
{
    new weapon[2];
    GetPlayerWeaponData(playerid, slot, weapon[0], weapon[1]);
    if(weapon[0] >= 0 && weapon[1] > 0) return 1;
    return 0;
}

stock GetUIDByString(string[]) 
{ 
	for(new text = strlen(string) - 1; text != 0; text--) 
	{  
		if(string[text] == '\t') return strval(string[text]);  
	} 
	return -1;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
    new plyWeapons[12];
    new plyAmmo[12];

    for(new slot = 0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);
    	if(wep != weaponid)
    	{
    	    GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
    	}
	}

    ResetPlayerWeapons(playerid);
    for(new slot = 0; slot != 12; slot++)
    {
    	GivePlayerWeapon(playerid, plyWeapons[slot], plyAmmo[slot]);
    }
}

stock GetFreeIndexItems()
{
	for(new i = 1; i < MAX_ITEMS; i++)
	{
		if(Item[i][iUID] == 0) return i;
	}
	return -1;
}

stock GetIndexItemByUID(uid)
{
	foreach(new i : Item)
	{
		if(Item[i][iUID] == uid) return i;
	}
	return 0;
}

stock GetFreeGunSlot(playerid)
{
	for(new i = 0; i < GUN_LIMIT; i++)
	{
		if(Gun[playerid][i][0] == 0 && Gun[playerid][i][1] == 0) return i;
	}
	return -1;
}

stock GetWeaponForSlot(playerid, weaponid)
{
	for(new i = 0; i < GUN_LIMIT; i++)
	{
		if(Gun[playerid][i][gun_id] == weaponid) return i;
	}
	return -1;
}

stock ClearArrayGun(playerid, slot)
{
	for(new i = 0; i < 2; i++) Gun[playerid][slot][i] = 0;
}

stock ClearArrayItemPlayer(playerid)
{
	foreach(new i : Item)
	{
		if(Item[i][iOwner] == Player[playerid][UID] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER)
		{
			new next;
			if(Item[i][iType] == ITEM_WEAPON && Item[i][iUsed] == 1)
			{
				Item[i][iValue2] = GetWeaponAmmo(playerid, Item[i][iValue1]);
			}
			SaveItems(i);
			for(new iItems:j; j != iItems; j++) Item[i][j] = 0;
			Iter_SafeRemove(Item, i, next);
			i = next;
		}	
	}	
}

stock ReLoadItemsPlayer(playerid)
{
	ClearArrayItemPlayer(playerid);
	LoadItemsPlayer(playerid);
}
