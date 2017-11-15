 #include <a_samp>
#include <a_mysql> //R5 by G-sTyLeZzZ
#include <md5>
#include <zcmd>
#include <sscanf2>
#include <gvar>
#include <PStreamer7>
#include <foreach>
//#include <physics.inc>
#include <FCNPC>
#include <streamer>


#include "modules/defines.pwn"
#include "modules/variables.pwn"
#include "modules/groups.pwn"
#include "modules/commands_chat.pwn"
#include "modules/object.pwn"
#include "modules/textdraws.pwn"
#include "modules/database.pwn"
#include "modules/doors.pwn"
#include "modules/vehicles.pwn"
#include "modules/items.pwn"
#include "modules/stocks.pwn"
//#include "modules/train.pwn"


//ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);


main()
{
	print("\n----------------------------------");
	print(" Bayside Role Play v"VERSION" loaded.");
	print("----------------------------------\n");
}

CallBack:MySQLConnect(sqlhost[], sqluser[], sqlpass[], sqldb[])
{
	print("MYSQL: Attempting to connect to server...");
	mysql_connect(sqlhost, sqluser, sqldb, sqlpass);


	if(mysql_ping())
	{
		print("MYSQL: Database connection established.");
		return 1;
	}
	else
	{
		print("MYSQL: Connection error, retrying...");
		mysql_connect(sqlhost, sqluser, sqldb, sqlpass);
		if(mysql_ping())
		{
			print("MYSQL: Reconnection successful. We can continue as normal.");
			return 1;
		}
		else
		{
			print("MYSQL: Could not reconnect to server, terminating server...");
			SendRconCommand("exit");
			return 0;
		}
	}
}

public OnGameModeInit()
{
	new startTime = GetTickCount();
	
	MySQLConnect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
	mysql_query("SET NAMES 'cp1250'");
	//AntyDeAMX();
	AllowInteriorWeapons(1);//
	ShowPlayerMarkers(0);
    ShowNameTags(0);
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
	EnableVehicleFriendlyFire();
    ManualVehicleEngineAndLights();
	
	
	mysql_debug(1);
	ChechIfTableExists();
	
	SendRconCommand("weburl www.bs-rp.pl");
	SendRconCommand("mapname "CITY_NAME"");
	SetGameModeText("BS-RP: v"VERSION"");
	
	Iter_Add(Vehicle, 0);
	
	LoadSettings();
	LoadVehicles(VEHICLES_WITHOUT_OWNERS);
	LoadItems();
	Objects(); // Only for debug
	CreateTextDraws();
	LoadDoors();
	
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	
	//CreateStreamObject(14000, Settings[Spawn][0], Settings[Spawn][1], Settings[Spawn][2], 0.0, 0.0, 0.0, 50.0, -1, 0);
	
//	test = SetTimer("testt", 1000, false);
	Main_Timer = SetTimer("MainTimer", 1000, true);
	Main_Min_Timer = SetTimer("MainMinTimer", 60000, true);
	
	//DLA BOTA
	/*Iter_Add(Vehicle, 1);
	Vehicle[1][vUID] = 99999999;
	Iter_Add(Vehicle, 2);
	Vehicle[2][vUID] = 99999999;
	Iter_Add(Vehicle, 3);
	Vehicle[3][vUID] = 99999999;
	Iter_Add(Vehicle, 4);
	Vehicle[4][vUID] = 99999999;*/
	
	printf("South Central Life successfully loaded (in %.3f seconds)\r\n", float(GetTickCount() - startTime) / 1000);
	return 1;
}

public OnGameModeExit()
{
	Vehicle_OnGameModeExit();
	
	foreach(new object : Item)
	{
		SaveItems(object);
		Iter_Remove(Item, object);
		for(new iItems:i; i != iItems; i++) Item[object][i] = 0;
	}
	
 	KillTimer(Main_Timer);
 	KillTimer(Main_Min_Timer);
	mysql_close();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	//SetPlayerCameraPos(playerid, -2323.59, 2125.24, 62.95);
	//SetPlayerCameraLookAt(playerid, -2422.9106, 2326.8025, 4.9823);
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	
	/*RemoveBuildingForPlayer(playerid, 9260, -2291.6094, 2311.5313, 9.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 9301, -2530.3516, 2346.2031, 7.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 9373, -2530.3516, 2346.2031, 7.9688, 0.25);	
	RemoveBuildingForPlayer(playerid, 9380, -2291.6094, 2311.5313, 9.0938, 0.25);	
	RemoveBuildingForPlayer(playerid, 9381, -2235.5547, 2361.7734, 15.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 9382, -2251.6484, 2380.0938, 10.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2550.3672, 2320.4766, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2553.0547, 2320.4844, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2548.9922, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1689, -2544.5547, 2348.0156, 13.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2539.6172, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -2531.3438, 2336.8516, 4.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2527.2422, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2520.7188, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2524.0625, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2510.5469, 2335.7578, 7.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -2503.3125, 2341.3672, 4.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2451.4063, 2321.0234, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 715, -2511.0469, 2510.0313, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2279.3750, 2327.1484, 3.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1635, -2226.0625, 2360.8281, 6.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -2244.2344, 2361.2031, 4.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2247.6328, 2364.8594, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2246.7734, 2364.4922, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2246.8125, 2365.7578, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1431, -2245.7109, 2363.3047, 4.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 9245, -2235.5547, 2361.7734, 15.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2253.5391, 2372.5469, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2254.0859, 2371.0313, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2252.5391, 2371.0234, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 9247, -2251.6484, 2380.0938, 10.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1431, -2254.7969, 2385.4609, 4.5000, 0.25);*/
	RemoveBuildingForPlayer(playerid, 9260, -2291.6094, 2311.5313, 9.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 9301, -2530.3516, 2346.2031, 7.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 9330, -2481.0000, 2497.6797, 16.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 9373, -2530.3516, 2346.2031, 7.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 9380, -2291.6094, 2311.5313, 9.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 9381, -2235.5547, 2361.7734, 15.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 9382, -2251.6484, 2380.0938, 10.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 9411, -2418.3281, 2454.8438, 18.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 9412, -2477.2578, 2455.9609, 21.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 9414, -2461.8672, 2487.3359, 17.5781, 0.25);	
	RemoveBuildingForPlayer(playerid, 9419, -2423.5859, 2488.2734, 13.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 9432, -2481.0000, 2497.6797, 16.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 9434, -2476.8672, 2454.7109, 15.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2550.3672, 2320.4766, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2553.0547, 2320.4844, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2548.9922, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1689, -2544.5547, 2348.0156, 13.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2539.6172, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -2531.3438, 2336.8516, 4.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2527.2422, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2520.7188, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2524.0625, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2510.5469, 2335.7578, 7.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -2503.3125, 2341.3672, 4.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2451.4063, 2321.0234, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 715, -2511.0469, 2510.0313, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 647, -2475.1406, 2446.0625, 16.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 9324, -2477.2578, 2455.9609, 21.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 9331, -2476.8672, 2454.7109, 15.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 647, -2468.0391, 2450.6875, 16.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 9238, -2461.8672, 2487.3359, 17.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1358, -2462.1484, 2512.7422, 16.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2461.1016, 2507.9688, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2459.7031, 2508.6719, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2461.1016, 2509.3828, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2460.1406, 2509.7422, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 9319, -2418.3281, 2454.8438, 18.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 9323, -2423.5859, 2488.2734, 13.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2279.3750, 2327.1484, 3.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1635, -2226.0625, 2360.8281, 6.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -2244.2344, 2361.2031, 4.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2247.6328, 2364.8594, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2246.7734, 2364.4922, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2246.8125, 2365.7578, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1431, -2245.7109, 2363.3047, 4.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 9245, -2235.5547, 2361.7734, 15.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2253.5391, 2372.5469, 4.7578, 0.25);	
	RemoveBuildingForPlayer(playerid, 1264, -2254.0859, 2371.0313, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, -2252.5391, 2371.0234, 4.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 9247, -2251.6484, 2380.0938, 10.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1431, -2254.7969, 2385.4609, 4.5000, 0.25);
	
	
	drzwitd[playerid] = CreatePlayerTextDraw(playerid, 445.500000, 196.583358, "~b~Drzwi ~w~Testowe~n~~n~~g~Koszt wejscia: ~w~ 20$~n~Wcisnij klawisz ~y~sprintu~w~ aby wejsc");
	PlayerTextDrawLetterSize(playerid, drzwitd[playerid], 0.331499, 1.156666);
	PlayerTextDrawTextSize(playerid, drzwitd[playerid], 641.500000, 28.000000);
	PlayerTextDrawAlignment(playerid, drzwitd[playerid], 1);
	PlayerTextDrawColor(playerid, drzwitd[playerid], -1);
	PlayerTextDrawUseBox(playerid, drzwitd[playerid], true);
	PlayerTextDrawBoxColor(playerid, drzwitd[playerid], 120);
	PlayerTextDrawSetShadow(playerid, drzwitd[playerid], 0);
	PlayerTextDrawSetOutline(playerid, drzwitd[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, drzwitd[playerid], 51);
	PlayerTextDrawFont(playerid, drzwitd[playerid], 1);
	PlayerTextDrawSetProportional(playerid, drzwitd[playerid], 1);

	new query[128], string[412];
	//if(IsPlayerNPC(playerid)) return Kick(playerid);
	
	GetPlayerName(playerid, Player[playerid][GlobalName], MAX_PLAYER_NAME);
	
	//myBB
	//format(query, sizeof(query), "SELECT `username`, `uid`, `salt` FROM mybb_users WHERE username = '%s' LIMIT 1", Player[playerid][GlobalName]); 
	//IPB
	format(query, sizeof(query), "SELECT `member_id`, `members_pass_salt` FROM "prefix_forum"members WHERE name = '%s'", Player[playerid][GlobalName]);
    mysql_query(query);
    mysql_store_result();
    
   	if(mysql_num_rows() != 0)
   	{
		mysql_fetch_row_format(query);
	    sscanf(query, "p<|>ds[12]", Player[playerid][GUID], Player[playerid][Salt]);
	    mysql_free_result();
   	    format(string, sizeof(string), "{336699}Witaj na "longerservername", nowym serwerze z zasadami.\nStawiamy poprzeczkê wy¿ej dla siebie i dla konkurencji!{a9c4e4}\n\nKonto o nicku {ffffff}%s{a9c4e4} ju¿ istnieje.\n", Player[playerid][GlobalName]);
		strcat(string, "1.\tJest Twoje? WprowadŸ has³o i zaloguj siê!\n2.\tNie posiadasz konta globalnego? WejdŸ na "www"!\n3.\tKonto nie jest Twoje? Kliknij {ffffff}ZMIEÑ.");
        ShowPlayerDialog(playerid, DIALOG_LOGIN_GLOBAL, DIALOG_STYLE_PASSWORD, "{4876FF}"longerservername"{a9c4e4} » Logowanie", string, "Zaloguj", "ZMIEÑ");
   	}
   	else
   	{
   	    format(string, sizeof(string), "{336699}Witaj na "longerservername", nowym serwerze z zasadami.\nStawiamy poprzeczkê wy¿ej dla siebie i dla konkurencji!{a9c4e4}\n\nKonto o nicku {ffffff}%s{a9c4e4} nie istnieje.\n", Player[playerid][GlobalName]);
		strcat(string, "1.\tNie posiadasz konta globalnego? WejdŸ na "www"!\n2.\tKonto nie jest Twoje? Kliknij {ffffff}ZMIEÑ.");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{4876FF}"longerservername"{a9c4e4} » Logowanie", string, "Zmieñ", "ZMIEÑ");
   	}
   	mysql_free_result();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Vehicle_OnPlayerDisconnect(playerid, reason);
	
	Delete3DTextLabel(Player[playerid][Nick]);
	OnPlayerSave(playerid);
	
	/*foreach(new i : Item)
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
	}	*/
	ClearArrayItemPlayer(playerid);
	
	if(Player[playerid][InVehicle] > 0) Vehicle[Player[playerid][InVehicle]][vPassengers]--;
	
	for(new pInfo:i; i != pInfo; i++)
    {
 		Player[playerid][i] = 0;
 	}
	for(new i = 0; i < GUN_LIMIT; i++) ClearArrayGun(playerid, i);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!Player[playerid][Logged]) return Kick(playerid);
	
	if(Player[playerid][InVehicle] > 0)
	{
		new Float:a, Float:b, Float:c, Float:angle, Float:distance = 3.0; 
		
		GetVehicleZAngle(Player[playerid][InVehicle], angle); 
		GetVehiclePos(Player[playerid][InVehicle], a, b, c);
		a -= (distance * floatsin(-angle, degrees));
		b -= (distance * floatcos(-angle, degrees));
		
		SetPlayerPos(playerid, a, b, c);
		SetPlayerFacingAngle(playerid, -angle);
		Vehicle[Player[playerid][InVehicle]][vPassengers]--;
		
		Player[playerid][InVehicle] = 0;
		return 1;
	}
	
	
	
	SetCameraBehindPlayer(playerid);
	SetPlayerPos(playerid, Settings[Spawn][0], Settings[Spawn][1], Settings[Spawn][2]);
	SetPlayerInterior(playerid, Settings[SpawnInt]);
	SetPlayerFacingAngle(playerid, Settings[Spawn][3]);
	SetPlayerVirtualWorld(playerid, Settings[SpawnVw]);
	//SetPlayerSkin(playerid, Player[playerid][Skin]);
	
	if(Player[playerid][BW] >= 1 && Player[playerid][BWTime] > 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Zosta³eœ ciê¿ko pobity i musisz poczekaæ na pomoc medyczn¹!");
		SendClientMessage(playerid, COLOR_GREY, "Aby zaakceptowaæ œmieræ u¿yj: /akceptujsmierc (konto zostanie zablokowane)"); 
		
		SetPlayerPos(playerid, Player[playerid][posX], Player[playerid][posY], Player[playerid][posZ] + 0.3);
        SetPlayerVirtualWorld(playerid, Player[playerid][VW]);
        SetPlayerInterior(playerid, Player[playerid][Interior]);
		
		TogglePlayerControllable(playerid, 0);
		
		SetPlayerCameraPos(playerid, Player[playerid][posX], Player[playerid][posY] + 2, Player[playerid][posZ] + 10);
		SetPlayerCameraLookAt(playerid, Player[playerid][posX], Player[playerid][posY], Player[playerid][posZ]);
		
	}
	Player[playerid][Spawned] = true;
	PreloadAnimations(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		if(GetPlayerVehicleSeat(playerid) == 0)
		{
			Player[playerid][BWTime] = TIME_BW_OfTheDriver * 60;
		}
		else if(GetPlayerVehicleSeat(playerid) > 0)
		{
			Player[playerid][BWTime] = TIME_BW_ThePassenger * 60;
		}
		else if(reason >= 0 && reason <= 15)
		{
			Player[playerid][BWTime] = TIME_BW_ThePassenger * 60;
		}
		
		
	    GetPlayerPos(playerid, Player[playerid][posX], Player[playerid][posY], Player[playerid][posZ]);
	
	    Player[playerid][BW] = 1;
	    Player[playerid][Interior] = GetPlayerInterior(playerid);
	    Player[playerid][VW] = GetPlayerVirtualWorld(playerid);
		return 1;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(Player[playerid][BW] != 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "Jesteœ nieprzytomny, nie mo¿esz rozmawiaæ oraz u¿ywaæ animacji.");
	    return 0;
	}
	
	if(strlen(text) < 3)
	{
		if((strcmp(":)", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":)")))
		{
			ServerMe(playerid, "uœmiecha siê.");
			return 0;
		}
		else if((strcmp(":/", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":/")))
		{
			ServerMe(playerid, "krzywi siê.");
			return 0;
		}
		else if((strcmp(":(", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":(")))
		{
			ServerMe(playerid, "robi smutn¹ minê.");
			return 0;
		}
		else if((strcmp(":o", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":o")))
		{
			ServerMe(playerid, "robi wielkie oczy.");
			return 0;
		}
		else if((strcmp(":*", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":*")))
		{
			ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, -1);
			return 0;
		}
		else if((strcmp(":D", text, true, strlen(text)) == 0) && (strlen(text) == strlen(":D")))
		{
			ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 0, 0, 0, 0, 0);
			ServerMe(playerid, "œmieje siê.");
			return 0;
		}
	}
	if(text[0] == '$')
	{
		OnPlayerCommandText(playerid, text);
		return 0;
	}
	
	new string[128];
	ucfirst(text);
	capitalize(text);
	
	if(strlen(text) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];

		strmid(stext, text, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "%s mówi: %s...", Player[playerid][NameSpace], stext);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

		strmid(stext, text, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "%s mówi: ...%s", Player[playerid][NameSpace], stext);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
		format(string, sizeof(string), "%s mówi: %s", Player[playerid][NameSpace], text);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/dupa", cmdtext, true, 10) == 0)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
		SetPlayerAttachedObject(playerid, 9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977,-81.700035, 0.891999, 1.000000, 1.168000);
		return 1;
	}
	
	if(8 >= strval(cmdtext[1]) > 0) return ChatGroups(playerid, cmdtext);	
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	Vehicle_OnPlayerStateChange(playerid, newstate, oldstate);
	
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(Player[playerid][CheckPoint] == 1)
	{
		DisablePlayerCheckpoint(playerid);
		Player[playerid][CheckPoint] = 0;
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	foreach(new id : Doors)
	{
		if(pickupid == DoorCache[id][dPickupID])
		{
			ShowDoorTextDraw(playerid, id);
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsKeyJustDown(KEY_HANDBRAKE,newkeys,oldkeys))
	{
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_BEER
		&& GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_WINE) return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	}
	if(PRESSED(KEY_ACTION + KEY_FIRE)) return cmd_v(playerid, "silnik");
	
	if((newkeys == KEY_SPRINT) && (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT))
    {
        foreach(new i : Doors)
        {
            if(GetPlayerVirtualWorld(playerid) == DoorCache[i][dEnterVW])
            {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[i][dEnterX], DoorCache[i][dEnterY], DoorCache[i][dEnterZ]))
                    return OnPlayerEnterDoors(playerid, i);
            }
			
            if(Player[playerid][Door] == i)
            {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[i][dExitX], DoorCache[i][dExitY], DoorCache[i][dExitZ]))
                    return OnPlayerExitDoors(playerid, i);
            }
        }
    }
	#define KEY_PPM     128
	if(newkeys & KEY_PPM && GetPlayerWeapon(playerid) >= 22  && GetPlayerWeaponState(playerid) != WEAPONSTATE_RELOADING)
	{
	    SetPlayerDrunkLevel(playerid, 2500);
	}
 	else if(oldkeys & KEY_PPM)
	{
		//SetPlayerDrunkLevel(playerid, 0);
		if(Player[playerid][PhaseBW] > 0) SetPlayerDrunkLevel(playerid, Player[playerid][PhaseBW]);
		else SetPlayerDrunkLevel(playerid, 0);
	}
	if(PRESSED(KEY_JUMP + KEY_CROUCH)) 
	{
		print("wciskam jupm");
		cmd_wsiadz(playerid, "/1");
	}
	if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}


public OnPlayerUpdate(playerid)
{
	Vehicle_OnPlayerUpdate(playerid);
	
	if(wepp[playerid] != GetPlayerWeapon(playerid)) for(new ac = 0; ac < 12; ac++)
	{
        GetPlayerWeaponData(playerid, ac, weps[ac], weps[6]);
		new slot = GetWeaponForSlot(playerid, weps[ac]), hold_gun;
		switch(slot)
		{
			case FIRST_WEAPON:
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, FIRST_WEAPON)) 
				{
					hold_gun = GetPVarInt(playerid, "AttachedWeapon_FIRST_WEAPON");
					if(GetPlayerWeapon(playerid) == Item[Gun[playerid][FIRST_WEAPON][gun_index]][iValue1] && IsPlayerAttachedObjectSlotUsed(playerid, FIRST_WEAPON) && Player[playerid][Spawned] && !hold_gun)
					{
						RemovePlayerAttachedObject(playerid, FIRST_WEAPON);
						SetPlayerAttachedObject(playerid, FIRST_WEAPON, Gun[playerid][FIRST_WEAPON][gun_model], 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_FIRST_WEAPON", 1);
					}
					else if(GetPlayerWeapon(playerid) != Item[Gun[playerid][FIRST_WEAPON][gun_index]][iValue1] && hold_gun)
					{
						RemovePlayerAttachedObject(playerid, FIRST_WEAPON);
						SetPlayerAttachedObject(playerid, FIRST_WEAPON, Gun[playerid][FIRST_WEAPON][gun_model], 1, -0.130044, -0.127836, 0.025491, 2.044970, 6.239807, 6.833646, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_FIRST_WEAPON", 0);
					}
				}
			}
			case SECOND_WEAPON:
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, SECOND_WEAPON)) 
				{
					hold_gun = GetPVarInt(playerid, "AttachedWeapon_SECOND_WEAPON");
					if(GetPlayerWeapon(playerid) == Item[Gun[playerid][SECOND_WEAPON][gun_index]][iValue1] && IsPlayerAttachedObjectSlotUsed(playerid, SECOND_WEAPON) && Player[playerid][Spawned] && !hold_gun)
					{
						RemovePlayerAttachedObject(playerid, SECOND_WEAPON);
						SetPlayerAttachedObject(playerid, SECOND_WEAPON, Gun[playerid][SECOND_WEAPON][gun_model], 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_SECOND_WEAPON", 1);
					}
					else if(GetPlayerWeapon(playerid) != Item[Gun[playerid][SECOND_WEAPON][gun_index]][iValue1] && hold_gun)
					{
						RemovePlayerAttachedObject(playerid, SECOND_WEAPON);
						SetPlayerAttachedObject(playerid, SECOND_WEAPON, Gun[playerid][SECOND_WEAPON][gun_model], 1, -0.130044, -0.127836, 0.025491, 2.044970, 6.239807, 6.833646, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_SECOND_WEAPON", 0);
					}
				}
			}
			case THIRD_WEAPON:
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, THIRD_WEAPON)) 
				{
					hold_gun = GetPVarInt(playerid, "AttachedWeapon_THIRD_WEAPON");
					if(GetPlayerWeapon(playerid) == Item[Gun[playerid][THIRD_WEAPON][gun_index]][iValue1] && IsPlayerAttachedObjectSlotUsed(playerid, THIRD_WEAPON) && Player[playerid][Spawned] && !hold_gun)
					{
						RemovePlayerAttachedObject(playerid, THIRD_WEAPON);
						SetPlayerAttachedObject(playerid, THIRD_WEAPON, Gun[playerid][THIRD_WEAPON][gun_model], 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_THIRD_WEAPON", 1);
					}
					else if(GetPlayerWeapon(playerid) != Item[Gun[playerid][THIRD_WEAPON][gun_index]][iValue1] && hold_gun)
					{
						RemovePlayerAttachedObject(playerid, THIRD_WEAPON);
						SetPlayerAttachedObject(playerid, THIRD_WEAPON, Gun[playerid][THIRD_WEAPON][gun_model], 1, -0.130044, -0.127836, 0.025491, 2.044970, 6.239807, 6.833646, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_THIRD_WEAPON", 0);
					}
				}
			}
			case ADDITIONAL_WEAPON: 
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, ADDITIONAL_WEAPON)) 
				{
					hold_gun = GetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON");
					if(GetPlayerWeapon(playerid) == Item[Gun[playerid][ADDITIONAL_WEAPON][gun_index]][iValue1] && IsPlayerAttachedObjectSlotUsed(playerid, THIRD_WEAPON) && Player[playerid][Spawned] && !hold_gun)
					{
						RemovePlayerAttachedObject(playerid, ADDITIONAL_WEAPON);
						SetPlayerAttachedObject(playerid, ADDITIONAL_WEAPON, Gun[playerid][ADDITIONAL_WEAPON][gun_model], 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON", 1);
					}
					else if(GetPlayerWeapon(playerid) != Item[Gun[playerid][ADDITIONAL_WEAPON][gun_index]][iValue1] && hold_gun)
					{
						RemovePlayerAttachedObject(playerid, ADDITIONAL_WEAPON);
						SetPlayerAttachedObject(playerid, ADDITIONAL_WEAPON, Gun[playerid][ADDITIONAL_WEAPON][gun_model], 1, -0.130044, -0.127836, 0.025491, 2.044970, 6.239807, 6.833646, 1.000000, 1.000000, 1.000000);
						SetPVarInt(playerid, "AttachedWeapon_ADDITIONAL_WEAPON", 0);
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_LOGIN_GLOBAL)
	{
		if(!response) return 1;
		new password[64], query[512], pass[256], string[256];

		mysql_real_escape_string(inputtext, password);
		format(pass, sizeof(pass), "%s%s", MD5_Hash(Player[playerid][Salt]), MD5_Hash(password));
		//myBB: format(query, sizeof(query), "SELECT `uid` FROM  mybb_users WHERE password = md5('%s') AND uid = %d", pass, Player[playerid][GUID]);
		format(query, sizeof(query), "SELECT `member_id` FROM  "prefix_forum"members WHERE members_pass_hash = md5('%s') AND `member_id` = %d", pass, Player[playerid][GUID]);
		mysql_query(query);
		mysql_store_result();

		if(mysql_num_rows())
		{
			mysql_free_result();
			
			format(query, sizeof(query), "SELECT `nick`, `id` FROM  "prefix"user_data WHERE `guid` = '%d'", Player[playerid][GUID]);
			mysql_query(query);
			mysql_store_result();

			if(mysql_num_rows())
			{
				new i = 1;
				while(mysql_fetch_row_format(query, "|"))
				{
					sscanf(query, "p<|>s[32]d",
					Player[playerid][Name],
					Player[playerid][UID]);
					
					format(Player[playerid][NameSpace], MAX_PLAYER_NAME, Player[playerid][Name]);
					
					UnderscoreToSpace(Player[playerid][NameSpace]);
					format(string, sizeof(string), "%s%d\t%s\n", string, Player[playerid][UID], Player[playerid][NameSpace]);
					i++;
				}
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_LIST, "{4876FF}"longerservername"{a9c4e4} » Logowanie", string, "Wybierz", "");
			}
			else
			{		
				format(string, sizeof(string), "Pod to konto globalne nie jest przypisana {ffffff}¿adna{a9c4e4} postaæ!\n\n1.\tChcesz stworzyæ postaæ? Kliknij {ffffff}STWÓRZ.{a9c4e4}\n2.\tKliknij {ffffff}wyjdŸ{a9c4e4}, by opuœciæ gre.");
				ShowPlayerDialog(playerid, DIALOG_NO_CHARACTERS, DIALOG_STYLE_MSGBOX, "{4876FF}"longerservername"{a9c4e4} » Logowanie", string, "STWÓRZ", "WyjdŸ");
			}	
			mysql_free_result();
	    }
	    else
	    {
	     	ShowPlayerDialog(playerid, DIALOG_LOGIN_GLOBAL, DIALOG_STYLE_INPUT, "{4876FF}"longerservername"{a9c4e4} » Logowanie", "Podane has³o nie jest zgodne z tym, zapisanym w bazie danych.", "Zaloguj", "WyjdŸ");
	    }
		mysql_free_result();
	}
	
	if(dialogid == DIALOG_LOGIN)
	{
        OnPlayerLogin(playerid, strval(inputtext));
	}
	
	if(dialogid == DIALOG_CREATE_GROUPS_1)
	{
		if(!response) return 1;
		
		new name[32];
		mysql_real_escape_string(inputtext, name);
		SetGVarString("create_groups_name", name, playerid);
		ShowPlayerDialog(playerid, DIALOG_CREATE_GROUPS_2, DIALOG_STYLE_INPUT, "{4876FF}"servername"{a9c4e4} » Admin » Grupy", "Pod tag nowej grupy:", "Dalej", "Zamknij");
	}
	
	if(dialogid == DIALOG_CREATE_GROUPS_2)
	{
		if(!response) return 1;
		
		new tag[10];
		mysql_real_escape_string(inputtext, tag);
		SetGVarString("create_groups_tag", tag, playerid);
		ShowPlayerDialog(playerid, DIALOG_CREATE_GROUPS_3, DIALOG_STYLE_INPUT, "{4876FF}"servername"{a9c4e4} » Admin » Grupy", "Podaj kolor nowej grupy:", "Dalej", "Zamknij");
	}
	
	if(dialogid == DIALOG_CREATE_GROUPS_3)
	{
		if(!response) return 1;
		
		new color[10];
		mysql_real_escape_string(inputtext, color);
		SetGVarString("create_groups_color", color, playerid);
		ShowPlayerDialog(playerid, DIALOG_CREATE_GROUPS_4, DIALOG_STYLE_LIST, "{4876FF}"servername"{a9c4e4} » Admin » Grupy", "{6633ff}#Wybierz typ nowej grupy{a9c4e4}\n\n1.PD\n2.SAM-ERS\n3.Gang", "Stwórz", "Zamknij");
	}
	
	if(dialogid == DIALOG_CREATE_GROUPS_4)
	{
		if(!response) return 1;
		
		new color[10], tag[10], name[32], query[128], string[64];
		
		GetGVarString("create_groups_name", name, sizeof(name), playerid);
		GetGVarString("create_groups_tag", tag, sizeof(tag), playerid);
		GetGVarString("create_groups_color", color, sizeof(color), playerid);
		
		if(strval(inputtext) == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Wyst¹pi³ b³¹d podczas tworzenia grupy(ERROR: #001)");

		format(query, sizeof(query), "INSERT INTO "prefix"groups(`name`, `tag`, `color`, `type`) VALUES ( '%s', '%s', '%s', '%d')", name, tag, color, strval(inputtext));
		mysql_query(query);
		
		format(string, sizeof(string), "Utworzy³eœ now¹ grupe: %s.", name);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
	}
	if(dialogid == DIALOG_GROUPS_LIST_1)
	{
		if(!response) return 1;
		new slot = strval(inputtext), title[64];
		SetPVarInt(playerid, "group_list_slot", slot);
		
		format(title, sizeof(title), "{4876FF}Twoje grupy{a9c4e4} » %s (UID: %d)", Group[playerid][slot][gName], Group[playerid][slot][gUID]);
		ShowPlayerDialog(playerid, DIALOG_GROUPS_LIST_2, DIALOG_STYLE_LIST, title, "1. On-line\n2. tujakiesopcje", "Wybierz", "Zamknij");
		return 1;
	}
	if(dialogid == DIALOG_GROUPS_LIST_2)
	{
		new slot = GetPVarInt(playerid, "group_list_slot"), string[256], title[64];
		switch(listitem)
		{
			case 0: //0nline
			{
				format(title, sizeof(title), "{4876FF}Twoje grupy{a9c4e4} » %s (UID: %d)", Group[playerid][slot][gName], Group[playerid][slot][gUID]);
				format(string, sizeof(string), "{a9c4e4}Lp.\tNazwa(ID){ffffff}\n", string);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						for(new id = 1; id < MAX_GROUPS; id++) 
						{
							if(Group[i][id][gUID] == Group[playerid][slot][gUID]) format(string, sizeof(string), "%s%d\t%s(%d)\n", string, i + 1, Player[i][NameSpace], i);
						}
					}
				}	
				ShowPlayerDialog(playerid, DIALOG_GROUPS_LIST_3, DIALOG_STYLE_LIST, title, string, "Zamknij", "");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DOORS_CREATE1)
	{
		if(!response) return 1;
		SetPVarString(playerid, "TworzenieDrzwiNazwa", inputtext);
		ShowPlayerDialog(playerid, DIALOG_DOORS_CREATE2, DIALOG_STYLE_LIST, "{4876FF}Drzwi{a9c4e4} » Tworzenie", "1. Drzwi\n2. Dom\n3. Bankomat", "Dalej", "Anuluj");
	}
	if(dialogid == DIALOG_DOORS_CREATE2)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "TworzenieDrzwiTyp", strval(inputtext));
		new str[256];
		format(str, 256, "Nazwa: %s\nVirtual World(Zewnêtrzny): %d\nVirtual World(Wewnêtrzny): %d", inputtext, GetPVarInt(playerid, "TworzenieDrzwiVW2"), GetPVarInt(playerid, "TworzenieDrzwiVW"));
		ShowPlayerDialog(playerid, DIALOG_DOORS_CREATE3, DIALOG_STYLE_MSGBOX, "{4876FF}Drzwi{a9c4e4} » Tworzenie", str, "Akceptuj", "Anuluj");		
	}
	if(dialogid == DIALOG_DOORS_CREATE2)
	{
		if(!response) return 1;
		new str[256];
		new str2[64];
		GetPVarString(playerid, "TworzenieDrzwiNazwa", str2, 64);
		format(str, 256, "Nazwa: %s\nVirtual World(Zewnêtrzny): %d\nVirtual World(Wewnêtrzny): %d", inputtext, GetPVarInt(playerid, "TworzenieDrzwiVW2"), GetPVarInt(playerid, "TworzenieDrzwiVW"));
		CreateDoors(str2, GetPVarInt(playerid, "TworzenieDrzwiTyp"), GetPVarInt(playerid, "TworzenieDrzwiVW2"), GetPVarInt(playerid, "TworzenieDrzwiInt2"),
		GetPVarFloat(playerid, "TworzenieDrzwiX2"), GetPVarFloat(playerid, "TworzenieDrzwiY2"), GetPVarFloat(playerid, "TworzenieDrzwiZ2"), GetPVarInt(playerid, "TworzenieDrzwiVW"), GetPVarInt(playerid, "TworzenieDrzwiInt"), 
		GetPVarFloat(playerid, "TworzenieDrzwiX"), GetPVarFloat(playerid, "TworzenieDrzwiY"), GetPVarFloat(playerid, "TworzenieDrzwiZ"), Player[playerid][Door]);
		DInfo(playerid, str);
	}	
	
	Vehicle_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	
	if(dialogid == DIALOG_ITEM_LIST)
	{
		new title[64];
		new itemuid, index;
		if(!response) return 1;
		
		switch(listitem)
		{
			case 0: ListPlayerNearItems(playerid, 2.0);
			case 1: print("!!!!!!!!!!!!!!zazanczanie");
			case 2: print("!!!!!!!!!!!!!!--------------------");
			
			default:
			{
				itemuid = GetUIDByString(inputtext); 
				index = GetIndexItemByUID(itemuid);
			}
		}	
		
		if(response && itemuid > 0)
	    {
			SetPVarInt(playerid, "INDEX_item", index);
			SetPVarInt(playerid, "UID_item", itemuid);
			format(title, sizeof(title), "{4876FF}Przedmioty{a9c4e4} » %s[%d]", Item[index][iName], itemuid);
			if(Item[index][iType] == ITEM_WEAPON && !isnull(Item[index][iValue6])) ShowPlayerDialog(playerid, DIALOG_ITEM_LIST_MORE, DIALOG_STYLE_LIST, title, "1. U¿yj ten przedmiot\n2. Od³ó¿ przedmiot\n3. Wyci¹gnij magazynek\n4. Informacje", "Wybierz", "Zamknij");
			//else if(Item[index][iType] == ITEM_PHONE) ShowPlayerDialog(playerid, DIALOG_ITEM_LIST_MORE, DIALOG_STYLE_LIST, title, "1. U¿yj tego przedmiotu\n2. Od³ó¿ przedmiot\n3. Informacje\n", "Wybierz", "Zamknij");
 			else ShowPlayerDialog(playerid, DIALOG_ITEM_LIST_MORE, DIALOG_STYLE_LIST, title, "1. U¿yj przedmiot\n2. Od³ó¿ przedmiot\n3. Informacje\n", "Wybierz", "Zamknij");
		}
		//else if(itemuid > 0) OnPlayerUseItem(playerid, itemuid);
		
		
	}
	if(dialogid == DIALOG_ITEM_LIST_MORE)
	{
		if(!response) return 1;
		
		new i = GetPVarInt(playerid, "INDEX_item"), u = GetPVarInt(playerid, "UID_item");
		
		switch(listitem)
		{
			case 0: 
			{	
				OnPlayerUseItem(playerid, u);
				//printf("MORE_MORE_: Przedmiot: %s(uid: %d) zosta³ u¿yty przez: %s(%d)", Item[i][iName], u, Player[playerid][Name], playerid);
			}
			case 1: OnPlayerDropItem(playerid, u);
			case 2:
			{
				
				if(Item[i][iType] == ITEM_WEAPON && !isnull(Item[i][iValue6]))
				{
					new ammo = GetWeaponAmmo(playerid, Item[i][iValue1]);
					CreateItem(ITEM_MAGAZINE, Item[i][iValue6], Item[i][iOwner], Item[i][iOwnerType], Item[i][iValue1], ammo, 200 + ammo * 5, _, Item[i][iValue7], _, FLAG_ITEM_PLACE_APLAYER);
					
					Item[i][iValue2] = 0;
					Item[i][iValue6] = EOS;
					Item[i][iValue7] = 0;
					OnPlayerUseItem(playerid, u);
					ReLoadItemsPlayer(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_ITEM_ADD_AMMO)
	{
		if(!response) return 1;
		
		new itemuid = GetUIDByString(inputtext); 
		new index = GetIndexItemByUID(itemuid); // magazine
		printf("index1: %d, amo: %d, max: %d", GetPVarInt(playerid, "i_ammo"), Item[GetPVarInt(playerid, "i_ammo")][iValue2], Item[index][iValue5]);
		//if(Item[GetPVarInt(playerid, "i_ammo")][iValue2] > Item[index][iValue5])
		new difference = Item[GetPVarInt(playerid, "i_ammo")][iValue2] + Item[index][iValue2];
		new diff = Item[index][iValue5] - difference;
		if(diff > 0)
		{
			Item[index][iValue2] = difference;
			Item[GetPVarInt(playerid, "i_ammo")][iValue2] = diff;
		}
		else if(diff < 0)
		{
			Item[GetPVarInt(playerid, "i_ammo")][iValue2] = diff * (-1);
			Item[index][iValue2] = Item[index][iValue5];
		}

	}
	
	if(dialogid == DIALOG_ITEM_ADD_MAGAZINE)
	{
		if(!response) return 1;
		new itemuid = GetUIDByString(inputtext); 
		new index = GetIndexItemByUID(itemuid); // id broni
		 
		if(Item[index][iUsed])
		{
			Item[index][iValue2] = GetWeaponAmmo(playerid, Item[index][iValue1]);
			Item[index][iValue2] += Item[GetPVarInt(playerid, "magazine")][iValue2];
			GivePlayerWeapon(playerid, Item[index][iValue1], Item[index][iValue2]);
		}
		else if(!Item[index][iUsed])
		{
			Item[index][iValue2] += Item[GetPVarInt(playerid, "magazine")][iValue2];
		}
		
		format(Item[index][iValue6], 32, Item[GetPVarInt(playerid, "magazine")][iName]);
		//Item[GetPVarInt(playerid, "magazine")][iValue2] = 0;
		
		DeleteItem(GetPVarInt(playerid, "magazine"));
		GameTextForPlayer(playerid, "~b~ Magazynek zaladowany!", 3000, 3);
	}	
	if(dialogid == DIALOG_ITEM_RAISE)
	{
		if(!response) return 1;
		
		new itemuid = GetUIDByString(inputtext); 
		new index = GetIndexItemByUID(itemuid);
		
		OnPlayerRaiseItem(playerid, index);
		
		return 1;
	}	
	if(dialogid == DIALOG_DOORS)
	{
		if(!response) return 1;
		new id = Player[playerid][Door];
		switch(listitem)
		{
			case 0: // Zmiana nazwy systemowej
			{
				ShowPlayerDialog(playerid, DIALOG_DOORS_NAME, DIALOG_STYLE_INPUT, "{4876FF}Drzwi{a9c4e4} » Edycja", "{FFFFFF}Wpisz poni¿ej now¹ nazwê systemow¹ drzwi", "Ok", "Anuluj");
			}
			case 1: // Nazwa wyœwietlana
			{
				ShowPlayerDialog(playerid, DIALOG_DOORS_TEXT, DIALOG_STYLE_INPUT, "{4876FF}Drzwi{a9c4e4} » Edycja", "{FFFFFF}Wpisz poni¿ej now¹ nazwê wyœwietlan¹ drzwi", "Ok", "Anuluj");
			}
			case 2: //Informacje
			{
				new str[128];
				format(str, 128, "Nazwa drzwi: \t%s\nW³aœciciel: \t%d\nKoszt wejœcia: \t%d$", DoorCache[id][dName], DoorCache[id][dOwner], DoorCache[id][dFee]);
				BSRPDialog(playerid, DUMMY, DIALOG_STYLE_LIST, "Drzwi", "Edycja", str, "Ok", "");
			}
			case 3: //przypisywanie
			{
				BSRPDialog(playerid, DIALOG_DOORS_GROUP, DIALOG_STYLE_LIST, "Drzwi", "Edycja", "ojnotutajwaxiumusizgrupamitozrobicnom", "Ok", "Anuluj");
			}
			case 4: //, 5, 6
			{
				if(DoorCache[id][dBuy] == 0) DoorCache[id][dBuy] = 1;
				else DoorCache[id][dBuy] = 0;
				DInfo(playerid, "W³¹czy³eœ samoobs³ugê.");
			}
			case 5:
			{
				if(DoorCache[id][dDrive] == 0) DoorCache[id][dDrive] = 1;
				else DoorCache[id][dDrive] = 0;
				DInfo(playerid, "W³¹czy³eœ przejazd.");
			}
			case 7: //Koszt wejœcia
			{
				BSRPDialog(playerid, DIALOG_DOORS_FEE, DIALOG_STYLE_INPUT, "Drzwi", "Edycja", "Wpisz poni¿ej nowy koszt wejœcia dla drzwi.", "Ok", "Anuluj");
			}
			case 8: //Ustawianie w³aœciciela
			{
				BSRPDialog(playerid, DIALOG_DOORS_OWNER, DIALOG_STYLE_INPUT, "Drzwi", "Edycja", "Wpisz poni¿ej UID nowego w³aœciciela drzwi.", "Ok", "Anuluj");
			}
			case 9: // 10, 11
			{
				if(DoorCache[id][dFreeze] == 0)
				{
					DoorCache[id][dFreeze] = 1;
					DInfo(playerid, "W³¹czy³eœ zamra¿anie po wejœciu.");
				}
				else{
					DoorCache[id][dFreeze] = 0;
					DInfo(playerid, "Wy³¹czy³eœ zamra¿anie po wejœciu.");
				}
				SaveDoors(id);
				
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DOORS_NAME)
	{
		if(!response) return 1;
		new id = Player[playerid][Door];
		format(DoorCache[id][dName], 32, "%s", inputtext);
		SaveDoors(id);
	}
	if(dialogid == DIALOG_DOORS_TEXT)
	{
		if(!response) return 1;
		new id = Player[playerid][Door];
		format(DoorCache[id][dText], 64, "%s", inputtext);
		SaveDoors(id);
	}
	if(dialogid == DIALOG_DOORS_FEE)
	{
		if(!response) return 1;
		new id = Player[playerid][Door];
		DoorCache[id][dFee] = strval(inputtext);
		SaveDoors(id);
	}
	if(dialogid == DIALOG_DOORS_OWNER)
	{
		if(!response) return 1;
		new id = Player[playerid][Door];
		DoorCache[id][dOwner] = strval(inputtext);
		SaveDoors(id);
	}
	if( dialogid == DIALOG_TELEPORT )
	{
	    if( !response )
		{
 			new big_str[ 2048 ];

			for( new i = 1; i < sizeof( Interiory2 ); i++ )
	    		format( big_str, sizeof( big_str ), "%s\n%d\t\t%s", big_str, i, Interiory2[ i ][ intNazwa ] );
	    	ShowPlayerDialog(playerid, DIALOG_TELEPORT2, DIALOG_STYLE_LIST, "Interiory", big_str, "Wybierz", "Anuluj");
			return 1;
		}
		listitem++;
		SetPlayerInterior( playerid, Interiory[ listitem ][ intUniverse ] );
		SetPlayerPos( playerid, Interiory[ listitem ][ intPozX ], Interiory[ listitem ][ intPozY ],
		Interiory[ listitem ][ intPozZ ]);
	}
	if( dialogid == DIALOG_TELEPORT2 )
	{
	    if( !response ) return 1;
		listitem++;
		SetPlayerInterior( playerid, Interiory2[ listitem ][ intUniverse ] );
		SetPlayerPos( playerid, Interiory2[ listitem ][ intPozX ], Interiory2[ listitem ][ intPozY ],
		Interiory2[ listitem ][ intPozZ ]);
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	TextDrawShowForPlayer(playerid, RedRadar);
	Player[playerid][HP] -= amount;
	SetTimerEx("HideRadar", 1500, false, "d", playerid);
	
	printf("%s(%d) otrzymal obrazenia(%0.2f) od %s(%d) z %d(bron)", Player[playerid][Name], playerid, amount, Player[issuerid][Name], issuerid, weaponid);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
	printf("#%s(%d) zadal obrazenia(%0.2f) %s(%d) z %d(bron)", Player[playerid][Name], playerid, amount, Player[damagedid][Name], damagedid, weaponid);
	return 1;
}

CallBack:MainMinTimer()
{
	//printf("timeeeeeeeeeeeeeeeeeer min");
	foreach(new i : Player)
	{	
		if(Player[i][PhaseBW] > 0)
		{
			Player[i][PhaseBW] -= 500;
		}
		/*if(Player[i][BW])
		{
			new string[25];
			Player[i][BWTime]--;
			if(Player[i][BWTime] <= 60) format(string, sizeof(string), "~w~Pozostalo ~r~%d ~y~sec", Player[i][BWTime]);
			else format(string, sizeof(string), "~w~Pozostalo ~r~%d ~w~minut", Player[i][BWTime] / 60);
			GameTextForPlayer(i, string, 9999, 3); 
		 	ApplyAnimation(i, "CRACK", "crckidle2", 4.0, 1, 1, 1, 1, 1);
			if(Player[i][BWTime] <= 0)
			{
				Player[i][BWTime] = 0;
				Player[i][BW] = 0;
				ClearAnimations(i, 1);
			}
		}*/
	}	
}

CallBack:MainTimer()
{
	new Float:vpos[3], Float:VehicleHealth, vehid;
	
	//printf("timer sec");
	
	foreach(new i : Player)
	{	
		vehid = GetPlayerVehicleID(i);
		if(vehid >= 0)
		{
			SpeedCounterUpDate(i, vehid);
			
			GetVehicleHealth(vehid, VehicleHealth);
			if(VehicleHealth < Vehicle[vehid][vHealth])
			{
				SetVehicleHealth(vehid, VehicleHealth);
				Vehicle[vehid][vHealth] = VehicleHealth;
				TextDrawShowForPlayer(i, RedRadar);
				SetTimerEx("HideRadar", 2000, false, "d", i);
				if(VehicleHealth < 260.0)
				{
					SetVehicleHealth(vehid, 270.0);
					SetVehicleParamsEx(vehid, Vehicle[vehid][vEngine] = 0, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, Vehicle[vehid][vLocked], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, -1);
					Vehicle[vehid][vFlags] |= FLAG_DESTROYED;
				}
			}
		}
		
		if(Player[i][BW] > 0 && Player[i][BWTime] > 0)
		{
			new string[32];
			Player[i][BWTime]--;
		
			if(Player[i][BWTime] <= 60) format(string, sizeof(string), "~w~Pozostalo ~r~%d ~y~sec", Player[i][BWTime]);
			else format(string, sizeof(string), "~w~Pozostalo ~r~%d ~w~min", Player[i][BWTime] / 60);
			GameTextForPlayer(i, string, 9999, 3); 
		 	ApplyAnimation(i, "CRACK", "crckidle2", 4.0, 1, 1, 1, 1, 1);
			if(Player[i][BWTime] <= 0)
			{
				Player[i][BWTime] = 0;
				Player[i][BW] = 0;
				
				//SetPlayerInterior(i, 0); FIX
				//SetPlayerVirtualWorld(i, 0);
				SetCameraBehindPlayer(i);

				SetPlayerDrunkLevel(i, 7000);
				Player[i][PhaseBW] = 7000;

				TogglePlayerControllable(i, true);
				ClearAnimations(i, 1);
			}
		}
	
		//if(Player[i][BW] >= 1) ApplyAnimation(i, "CRACK", "crckidle2", 4.0, 1, 1, 1, 1, 1);

		/*
		if(GetPlayerVehicleSeat(i) == 0)
		{
			SetPVarInt(i, "invehicle", 1);
			//SetPVarInt(i, "invehicleID", GetPlayerVehicleID(i));
			//SetGVarInt(GetPlayerVehicleID(i), , i);
			SetGVarInt("ttt", i, GetPlayerVehicleID(i));
		}
		else 
		{
			//SetPVarInt(i, "invehicle", 0);
			//SetPVarInt(i, "invehicleID", 0);
			SetGVarInt("ttt", -1, GetPlayerVehicleID(i));
		}
		*/
		//InPlayerVehicles[GetPlayerVehicleID(i)] = ;
	}

	foreach(new veh : Vehicle)
	{
		if(Vehicle[veh][vEngine])
		{
			GetVehiclePos(veh, vpos[0], vpos[1], vpos[2]);
			Vehicle[veh][vDistance] += floatsqroot(floatpower(vpos[0] - Vehicle[veh][vXx], 2) + floatpower(vpos[1] - Vehicle[veh][vYy], 2) + floatpower(vpos[2] - Vehicle[veh][vZz], 2));
			Vehicle[veh][vXx] = vpos[0];
			Vehicle[veh][vYy] = vpos[1];
			Vehicle[veh][vZz] = vpos[2];
			
			if(!Vehicle[veh][vFuelType]) Vehicle[veh][vFuel] -= Vehicle[veh][vFuelConsumption]; /*Vehicle[veh][vFuel] -= 0.0095;*/
			else Vehicle[veh][vFuel] -= Vehicle[veh][vFuelConsumption];	
			
			
			if(Vehicle[veh][vFuel] < 0.0) Vehicle[veh][vFuel] = 0.0;
			if(Vehicle[veh][vFuel] == 0)
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);
				
				SetVehicleParamsEx(veh, Vehicle[veh][vEngine] = 0, lights, alarm, doors, bonnet, boot, objective);	
			}
			new y = IsAnyPlayerInVehicle(veh);
			if(y >= 0) SpeedCounterUpDate(y, veh);
		}
			
		//if(InPlayerVehicles[veh] != -1 && GetPlayerVehicleID(InPlayerVehicles[veh]) >= 1)
		/*if(GetGVarInt("ttt", veh) > 0)
		{
			printf("testujemy pojazdy: %d, %d", InPlayerVehicles[veh], veh);
			//SpeedCounterUpDate(GetGVarInt("ttt", veh), veh);
			
			GetVehicleHealth(veh, VehicleHealth);
			if(VehicleHealth < Vehicle[veh][vHealth])
			{
				SetVehicleHealth(veh, VehicleHealth);
				Vehicle[veh][vHealth] = VehicleHealth;
				TextDrawShowForPlayer(InPlayerVehicles[veh], RedRadar);
				SetTimerEx("HideRadar", 2000, false, "d", InPlayerVehicles[veh]);
				if(VehicleHealth < 260.0)
				{
					SetVehicleHealth(veh, 270.0);
					SetVehicleParamsEx(veh, Vehicle[veh][vEngine] = 0, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, Vehicle[veh][vLocked], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, -1);
					Vehicle[veh][vFlags] |= FLAG_DESTROYED;
				}
			}
		}*/
	}	
}

CallBack:testt()
{
	print("yyyy");
}

CallBack:KickPlayer(playerid) return Kick(playerid);

CallBack:HideRadar(playerid) return TextDrawHideForPlayer(playerid, RedRadar);


CallBack:LoadSettings()
{
	new query[256];
    mysql_query("SELECT `spawnx`, `spawny`, `spawnz`, `spawna`, `spawnvw`, `spawnint` FROM `"prefix"settings`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
		sscanf(query, "p<|>ffffdd",
		Settings[Spawn][0],
	 	Settings[Spawn][1],
	 	Settings[Spawn][2],
	 	Settings[Spawn][3],
	 	Settings[SpawnVw],
	 	Settings[SpawnInt]);
	}
	mysql_free_result();
	print("Ustawienia zosta³y wczytane.");
}

CallBack:OnPlayerLogin(playerid, uid)
{
	new query[256], string[MAX_PLAYER_NAME];
	format(query, sizeof(query), "SELECT `guid`, `nick`, `admin`, `cash`, `skin`, `hp`, `age`, `weight`, `growth`, `bw`, `bwtime`, `x`, `y`, `z`, `vw`, `int` FROM `"prefix"user_data` WHERE `id` = '%d'", uid);
    mysql_query(query);
    mysql_store_result();
    	
	Player[playerid][Name] = 0;
	
	
	if(mysql_num_rows() != 0)
	{
  		mysql_fetch_row_format(query, "|");
		sscanf(query, "p<|>ds[20]dddfdfdddfffdd",
		    Player[playerid][GUID],		Player[playerid][Name],		Player[playerid][Admin],
			Player[playerid][Cash],		Player[playerid][Skin],		Player[playerid][HP],
			Player[playerid][Age],		Player[playerid][Weight], 	Player[playerid][Growth],
			Player[playerid][BW], 		Player[playerid][BWTime], 	Player[playerid][posX], 
			Player[playerid][posY], 	Player[playerid][posZ],		Player[playerid][VW], 	
			Player[playerid][Interior]
			);
			
		mysql_free_result();
		
		Player[playerid][UID] = uid;
		ResetPlayerMoney(playerid);
		Player[playerid][Logged] = 1;
		
		LoadItemsPlayer(playerid);
		format(Player[playerid][NameSpace], MAX_PLAYER_NAME, Player[playerid][Name]);
		UnderscoreToSpace(Player[playerid][NameSpace]);
		
		format(query, sizeof(query), "{0099ff}Witaj, {FFFFFF}%s {0099ff}na postaci: {FFFFFF}%s {999999}(UID %d, ID %d, GUID %d).{0099ff} Mi³ej gry!", Player[playerid][GlobalName], Player[playerid][NameSpace], Player[playerid][UID], playerid, Player[playerid][GUID]);
		SendClientMessage(playerid, COLOR_WHITE, query);
		
		SetPlayerName(playerid, Player[playerid][Name]);
		SetPlayerHealth(playerid, Player[playerid][HP]);
		
		format(string, sizeof(string), "%s (%d)", Player[playerid][Name], playerid);
		Player[playerid][Nick] = Create3DTextLabel(string, COLOR_GRAD1, 30.0, 40.0, 50.0, 14.0, 1);
		Attach3DTextLabelToPlayer(Player[playerid][Nick], playerid, 0.0, 0.0, 0.17);
		
		CreatePlayerTextDrawns(playerid);
		LoadGroupForPlayer(playerid);
		LoadVehicles(playerid);
		SetTimerEx("SpawnItem", 3800, false, "d", playerid);
		
		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999); // DEBUG
		
		format(query, sizeof(query), "SELECT `first`, `second`, `third`, `additional`, `rifle`, `shotgun`, `sniper`, `pistol`, `machine_pistol` FROM `"prefix"user_weapons_skill` WHERE `owner` = '%d'", Player[playerid][GUID]);    
		mysql_query(query);
		mysql_store_result();

		if(mysql_num_rows())
		{
			mysql_fetch_row_format(query, "|");
			sscanf(query, "p<|>ffffffffff",
		    Player[playerid][Skill_First],			Player[playerid][Skill_Second],		Player[playerid][Skill_Third],		Player[playerid][Skill_Additional],	
			Player[playerid][Skill_Rifle],			Player[playerid][Skill_Shotgun],	Player[playerid][Skill_Sniper],		Player[playerid][Skill_Pistol],
			Player[playerid][Skill_Machine_Pistol], Player[playerid][Skill_Revolver]);
			
			SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, floatround(Player[playerid][Skill_Sniper])); 
			
			SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, floatround(Player[playerid][Skill_Rifle])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, floatround(Player[playerid][Skill_Rifle])); 
			
			SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, floatround(Player[playerid][Skill_Shotgun])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, floatround(Player[playerid][Skill_Shotgun])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, floatround(Player[playerid][Skill_Shotgun])); 
			
			SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, floatround(Player[playerid][Skill_Machine_Pistol])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, floatround(Player[playerid][Skill_Machine_Pistol])); // ?
			
			SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, floatround(Player[playerid][Skill_Revolver])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, floatround(Player[playerid][Skill_Pistol])); 
			SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, floatround(Player[playerid][Skill_Pistol])); 

		}
		mysql_free_result();
		
		printf("%s(id: %d) zalogowa³ siê pomyœlnie.", Player[playerid][Name], playerid);
		SpawnPlayer(playerid);
	}	
	return 1;
}

CallBack:SpawnItem(playerid)
{
	foreach(new i : Item)
	{
		if(Item[i][iOwner] == Player[playerid][UID] && Item[i][iUsed] && Item[i][iPlace] == FLAG_ITEM_PLACE_APLAYER)
		{
			Item[i][iBase] = 1;
			OnPlayerUseItem(playerid, Item[i][iUID]);
		}
	}	
	return 1;
}

CallBack:OnPlayerSave(playerid)
{
    if(!Player[playerid][Logged]) return 1;

	GetPlayerHealth(playerid, Player[playerid][HP]);
	
	new query[256];
	format(query, sizeof(query), "UPDATE `"prefix"user_data` SET `admin` = '%d', `cash` = '%d', `hp` = '%f', `age` = '%d', `weight` = '%f', `growth` = '%d', `bw` = '%d', `bwtime` = '%d', `x` = '%f', `y` = '%f', `z` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'",
	        Player[playerid][Admin],	Player[playerid][Cash],		Player[playerid][HP],
			Player[playerid][Age],		Player[playerid][Weight], 	Player[playerid][Growth],
			Player[playerid][BW], 		Player[playerid][BWTime], 	Player[playerid][posX],
			Player[playerid][posY], 	Player[playerid][posZ],		Player[playerid][VW],
			Player[playerid][Interior],
			Player[playerid][UID]);

    mysql_query(query);
	return 1;
}

CMD:skin2(playerid, params[])
{
	//printf("/elo %d", SetPlayerAttachedObject( playerid, 0, 14001, 6, 0.029348, 0.029951, -0.006411, 13.892402, 2.592877, 7.434365, 1.000000, 1.000000, 1.000000 ));
	//GivePlayerWeapon(playerid, 25, 10);
	SetPlayerSkin(playerid, 105);
	return 1;
}

CMD:skin1(playerid, params[])
{
	SetPlayerSkin(playerid, 106);
	return 1;
}

CMD:skin3(playerid, params[])
{
	SetPlayerSkin(playerid, 103);//269
	return 1;
}

CMD:skin4(playerid, params[])
{
	SetPlayerSkin(playerid, 102);//270
	return 1;
}


