// modules/vehicles.pwn
/*
	- Przypisywanie
	- holowanie
	- przyczepki
	- oferowanie
	- tuning
*/

#define DIALOG_VEHICLES_LIST 30
#define DIALOG_VEHICLES_LIST_2 31

#define LimitPlayerVehicles 5
#define LimitPlayerVehiclesSpawned 3

#define TYPE_OWNER_PLAYER 1

#define FUEL_TYPE_PETROL 1
#define FUEL_TYPE_DIESEL 2

#define FLAG_UNSPAWNED  1
#define FLAG_SPAWNED  2
#define FLAG_DESTROYED 4


#define WAX_VEH 55 //only in debug!


new VehiclesName[212][18] = {
  "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck",
  "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance",
  "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection",
  "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks",
  "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
  "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo",
  "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer",
  "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
  "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina",
  "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
  "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact",
  "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer", "Hotring Racer",
  "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle",
  "Cropdust", "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
  "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
  "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
  "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
  "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor",
  "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger",
  "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper",
  "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer",
  "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer", "Trailer", "Andromeda", "Dodo", "RC Cam",
  "Launch", "Police Car", "Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T. Van",
  "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer", "Luggage Trailer", "Stair Trailer",
  "Boxville", "Farm Plow", "Utility Trailer"
};

enum v
{
  vID, //id in-game || unused
  vUID, //global uid
  vName[24], // We can set your vehicle name?
  vOwner,
  vOwnerType,
  vModel,
  Float:vX,
  Float:vY,
  Float:vZ,
  Float:vA,
  Float:vXx, //only for Distance
  Float:vYy,
  Float:vZz, // @UP
  vColor1,
  vColor2,
  vLocked,
  Float:vHealth,
  vSpawned,
  vUrl[128],
  vAudio,
  vPlay,
  vPanels,
  vDoors,
  vLights,
  vTires,
  vNrPlate[20],
  vEngine,
  Float:vDistance,
  Float:vFuel, 
  Float:vFuelConsumption,
  vFuelType, //0 - petrol, 1 - diesel 
  Float:vFuelMax,
  vFlags,
  vMaxPassengers,
  vPassengers
};

new Vehicle[MAX_VEHICLES+1][v];
new Iterator:Vehicle<MAX_VEHICLES>;

CMD:av(playerid, params[])
{
	if(Player[playerid][Admin] < 3) return GameTextForPlayer(playerid, "~r~Brak autoryzacji!", 3000, 3);
	
	new command[32], string[128], option[30], option2[30], vehicleid;
	if(sscanf(params, "s[32]S()[30]S()[30]", command, option, option2)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /av [goto, color, hp]");
	
	if(!strcmp(command, "goto", true))
	{
	    if(sscanf(option, "d", vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /av goto [VehicleUID]");
			
		vehicleid = GetVehicleIndexByUID(vehicleid);

		if(vehicleid == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd nie zosta³ zespawnowany.");

		new Float:vehx, Float:vehy, Float:vehz;
        GetVehiclePos(vehicleid, vehx, vehy, vehz);

		SetPlayerPos(playerid, vehx, vehy, vehz + 1.5);
		format(string, sizeof(string), "Teleportowa³eœ siê do: %s(%d)", VehiclesName[Vehicle[vehicleid][vModel] - 400], Vehicle[vehicleid][vModel]);
		SendClientMessage(playerid, COLOR_GRAD1, string);
		return 1;
	}
	if(!strcmp(command, "forme", true))
	{
	    if(sscanf(option, "d", vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /av forme [VehicleUID]");
			
		vehicleid = GetVehicleIndexByUID(vehicleid);
		
		if(vehicleid == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd nie zosta³ zespawnowany.");

		new Float:pos[4];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayerFacingAngle(playerid, pos[3]);

		new Float:ax[2];
		GetXYInFrontOfPos(pos[0], pos[1], pos[3], ax[0], ax[1], 3.0);
		SetVehiclePos(vehicleid, ax[0], ax[1], pos[2]);
		
		format(string, sizeof(string), "Teleportowa³eœ siê do: %s(%d)", VehiclesName[Vehicle[vehicleid][vModel] - 400], Vehicle[vehicleid][vModel]);
		SendClientMessage(playerid, COLOR_GRAD1, string);
		return 1;
	}
	else if(!strcmp(command, "color", true))
	{
	    new color1, color2;
	    if(sscanf(option, "ddd", vehicleid, color1, color2))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /av color [VehicleUID] [Color1] [Color2]");
			
		vehicleid = GetVehicleIndexByUID(vehicleid);
		
		if(vehicleid == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd nie zosta³ zespawnowany.");
		
		Vehicle[vehicleid][vColor1] = color1;
		Vehicle[vehicleid][vColor2] = color2;
		
		ChangeVehicleColor(vehicleid, color1, color2);
  		format(string, sizeof(string), "Zmieni³eœ kolory wozu: %s(UID: %d || Model: %d), kolor1: %d, kolor2: %d.", VehiclesName[Vehicle[vehicleid][vModel] - 400], Vehicle[vehicleid][vUID], Vehicle[vehicleid][vModel], color1, color2);
		SendClientMessage(playerid, COLOR_GRAD1, string);
		return 1;
	}
	return 1;
}

stock GetXYInFrontOfPos(Float:PosX, Float:PosY, Float:a, &Float:x, &Float:y, Float:distance)
{
	x = PosX;
	y = PosY;
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return 1;
}

CMD:v(playerid, params[])
{
	new command[32], string[128], option[30], query[256], vehicleid, index;
	if(sscanf(params, "s[32]S()[30]", command, option)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /pojazd(/v) [lista, spawn, unspawn, zaparkuj, namierz, zamknij, silnik, swiatla, maska, bagaznik]");
   	  
	if(!strcmp(command, "lista", true))
	{
	    new vmodel;
	    format(query, sizeof(query), "SELECT `id`, `model` FROM `"prefix"vehicles` WHERE `owner` = '%d' ORDER BY `id`", Player[playerid][UID]);
    	mysql_query(query);
    	mysql_store_result();

		new str[128];
		format(str, sizeof(str), "{a9c4e4}ID\tModel\tNazwa{ffffff}\n");
		
		if(mysql_num_rows() > 0)
    	{
    		while(mysql_fetch_row_format(query, "|"))
      		{
	    		sscanf(query, "p<|>dd", index, vmodel);

                if(GetVehicleIndexByUID(index) > 0)
                {
                    if(Vehicle[index][vFlags] & FLAG_DESTROYED)	format(str, sizeof(str), "%s%d\t%d\t{99ff66}%s{a7a7a7}(Zniszczony){ffffff}\n", str, index, vmodel, VehiclesName[vmodel - 400]);
					else format(str, sizeof(str), "%s%d\t%d\t{99ff66}%s{ffffff}\n", str, index, vmodel, VehiclesName[vmodel - 400]);
				}
				else format(str, sizeof(str), "%s%d\t%d\t%s\n", str, index, vmodel, VehiclesName[vmodel - 400]);
				ShowPlayerDialog(playerid, DIALOG_VEHICLES_LIST, DIALOG_STYLE_LIST, "{4876FF}Pojazdy{a9c4e4} » Lista", str, "Wybierz", "Zamknij");
			}
		}
		else return GameTextForPlayer(playerid, "~r~Nie posiadasz zadnych pojazdow!", 3000, 3);
		mysql_free_result();
		return 1;
    }
	else if(!strcmp(command, "spawn", true))
	{
	    if(sscanf(option, "d", vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /v spawn [IdPojazdu]");

    	if(!IsVehicleOwner(playerid, vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ w³aœcicielem tego pojazdu.");

		if(GetVehicleIndexByUID(vehicleid) > 0) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd zosta³ ju¿ zespawnowany.");

    	if(Player[playerid][VehSpawned] >= LimitPlayerVehiclesSpawned)
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie mo¿esz zespawnowaæ wiêkszej iloœci pojazdów.");

    	new vehid = SpawnVehicle(vehicleid);
		printf("eloo: %d", vehid);
        if(Vehicle[vehid][vHealth] < 260.0)
		{
		    SetVehicleHealth(vehid, 270.0);
			SendClientMessage(playerid, COLOR_LORANGE, "Ten pojazd jest zniszczony i nie nadaje siê do jazdy.");
			Vehicle[vehid][vFlags] |= FLAG_DESTROYED;
		}

    	format(string, sizeof(string), "%s (ID: %d) zespawnowa³ siê na miejscu parkingowym.", VehiclesName[GetVehicleModel(vehid) - 400], vehicleid);
    	SendClientMessage(playerid, COLOR_WHITE, string);

    	Player[playerid][VehSpawned]++;
		return 1;
	}
	else if(!strcmp(command, "unspawn", true))
	{
	    if(sscanf(option, "d", vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /v unspawn [IdPojazdu]");

		index = GetVehicleIndexByUID(vehicleid);
		
    	if(Vehicle[index][vUID] == -1 || Vehicle[index][vOwner] != Player[playerid][UID])
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ w³aœcicielem tego pojazdu.");

		if(IsAnyPlayerInVehicle(index) != -1) return SendClientMessage(playerid, COLOR_GRAD1, "Ktoœ jest w tym pojeŸdzie.");

		if(!(Vehicle[index][vFlags] & FLAG_SPAWNED)) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd nie zosta³ zespawnowany.");
		
		Vehicle[index][vFlags] &=~ FLAG_SPAWNED;
		new model = UnSpawnVehicle(vehicleid, true);
		format(string, sizeof(string), "%s (ID: %d) zosta³ unspawnowany.", VehiclesName[model - 400], vehicleid);
		SendClientMessage(playerid, COLOR_WHITE, string);
    	Player[playerid][VehSpawned]--;
		return 1;
	}
	else if(!strcmp(command, "zaparkuj", true))
	{
		index = GetPlayerVehicleID(playerid);
		
    	if(Vehicle[index][vUID] == -1 || Vehicle[index][vOwner] != Player[playerid][UID])
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ w³aœcicielem tego pojazdu.");
			
    	GetVehiclePos(index, Vehicle[index][vX], Vehicle[index][vY], Vehicle[index][vZ]);
    	GetVehicleZAngle(index, Vehicle[index][vA]);

		format(query, sizeof(query), "SELECT `id` FROM `"prefix"vehicles` WHERE (SQRT(ABS(x - %f)) + SQRT(ABS(y - %f)) + SQRT(ABS(z - %f)) < 2.9) AND `id` <> %d LIMIT 1",
																						    					       Vehicle[index][vX], Vehicle[index][vY], Vehicle[index][vZ], Vehicle[index][vUID]);
    	mysql_query(query);
    	mysql_store_result();
    	new collision = mysql_num_rows();
    	mysql_free_result();
    	
    	if(collision > 0)
			return SendClientMessage(playerid, COLOR_GRAD1, "To miejsce parkingowe jest ju¿ zajête.");
    	
    	format(string, sizeof(string), "%s (ID: %d) zosta³ zaparkowany.", VehiclesName[GetVehicleModel(index) - 400], Vehicle[index][vUID]);
    	SendClientMessage(playerid, COLOR_WHITE, string);
		
    	format(query, sizeof(query), "UPDATE `"prefix"vehicles` SET `x` = '%f', `y` = '%f', `z` = '%f', `a` = '%f' WHERE `id` = '%d'",
										 										   Vehicle[index][vX], Vehicle[index][vY], Vehicle[index][vZ], Vehicle[index][vA], Vehicle[index][vUID]);
	    print(query);
    	mysql_query(query);
    	return 1;
    }
	else if(!strcmp(command, "namierz", true))
	{
		if(sscanf(option, "d", vehicleid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /v namierz [IdPojazdu]");
		
		index = GetVehicleIndexByUID(vehicleid);
		
  		if(Vehicle[index][vUID] == -1 || Vehicle[index][vOwner] != Player[playerid][UID])
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ w³aœcicielem tego pojazdu.");
		
        if(!(Vehicle[index][vFlags] & FLAG_SPAWNED)) return SendClientMessage(playerid, COLOR_GRAD1, "Ten pojazd nie zosta³ zespawnowany.");
        
		if(IsAnyPlayerInVehicle(index) != -1) return SendClientMessage(playerid, COLOR_GRAD1, "Ktoœ jest w tym pojeŸdzie.");
		
        new Float:X, Float:Y, Float:Z;
		GetVehiclePos(index, X, Y, Z);
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, X, Y, Z, 4.0);
		Player[playerid][CheckPoint] = 1;
		SendClientMessage(playerid, COLOR_GRAD1, "Pojazd zosta³ zaznaczony na mapie.");
		return 1;
	}
	else if(!strcmp(command, "zamknij", true))
	{
	    new engine, lights, alarm, doors, bonnet, boot, objective;
	    index = GetPlayerVehicleInRange(playerid, 4.0);
		GetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, boot, objective);

 		if(index == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Nie ma ciê w pobli¿u ¿adnego z Twoich pojazdów!");

 		if(Vehicle[index][vLocked])
 		{
  			Vehicle[index][vLocked] = false;
			GameTextForPlayer(playerid, "~w~Pojazd ~g~OTWARTY", 3000, 6);
			SetVehicleParamsEx(index, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
 		}
 		else
 		{
   			Vehicle[index][vLocked] = true;
			GameTextForPlayer(playerid, "~w~Pojazd ~r~ZAMKNIETY", 3000, 6);
			SetVehicleParamsEx(index, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
 		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 4.0, 0, 0, 0, 0, 0);
	    return 1;
	}
	else if(!strcmp(command, "silnik", true))
	{
   		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
   		{
      		index = GetPlayerVehicleID(playerid);
      		
      		if(index == INVALID_VEHICLE_ID) return 1;
      		
      		new engine, lights, alarm, doors, bonnet, boot, objective;
      		GetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, boot, objective);

      		if(engine == VEHICLE_PARAMS_OFF)
      		{
      		    if(Vehicle[index][vFlags] & FLAG_DESTROYED) return SendClientMessage(playerid, COLOR_GRAD1, "Pojazd jest zniszczony, przed uruchomieniem musisz go naprawiæ!");
				if(!Vehicle[index][vFuel]) return SendClientMessage(playerid, COLOR_GRAD1, "Bak pojazdu jest pusty!");
      			SetVehicleParamsEx(index, Vehicle[index][vEngine] = 1, lights, alarm, doors, bonnet, boot, objective);
				GetVehiclePos(index, Vehicle[index][vXx], Vehicle[index][vYy], Vehicle[index][vZz]);
				TextDrawHideForPlayer(playerid, EngineVehicles);
      		}
      		else
      		{
				SetVehicleParamsEx(index, Vehicle[index][vEngine] = 0, lights, alarm, doors, bonnet, boot, objective);
				TextDrawShowForPlayer(playerid, EngineVehicles);
			}
    	}
 		return 1;
	}
	else if(!strcmp(command, "swiatla", true))
	{
		if(GetPlayerState(playerid) == 2)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;
      		index = GetPlayerVehicleID(playerid); 
      		GetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, boot, objective);

     		if(index == INVALID_VEHICLE_ID) return 1;
    
      		if(lights == VEHICLE_PARAMS_OFF)
				SetVehicleParamsEx(index, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
      		else
				SetVehicleParamsEx(index, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
		}
	  	return 1;
	}
	else if(!strcmp(command, "maska", true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			index = GetPlayerVehicleInRange(playerid, 4.0);
			if(index == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Nie ma ciê w pobli¿u ¿adnego z Twoich pojazdów!");
		}
		else index = GetPlayerVehicleID(playerid);
		
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if(bonnet == VEHICLE_PARAMS_OFF)
        	SetVehicleParamsEx(index, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
      	else
			SetVehicleParamsEx(index, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
	 	return 1;
	}
	else if(!strcmp(command, "bagaznik", true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			index = GetPlayerVehicleInRange(playerid, 4.0);
			if(index == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Nie ma ciê w pobli¿u ¿adnego z Twoich pojazdów!");
		}
		else index = GetPlayerVehicleID(playerid);
		
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if(bonnet == VEHICLE_PARAMS_OFF)
        	SetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
      	else
			SetVehicleParamsEx(index, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
	 	return 1;
	}
	return 1;
}	


CallBack:LoadVehicles(owner)
{
	new query[500], q[80], index;
	//format(query, sizeof(query), "SELECT * FROM `"prefix"vehicles` WHERE `owner_type` <> '%d' AND `flags` = '%d' ORDER BY `id`", TYPE_OWNER_PLAYER, FLAG_SPAWNED);
	format(query, sizeof(query), "SELECT * FROM `"prefix"vehicles` WHERE ");// `flags` = '%d' ORDER BY `id`", TYPE_OWNER_PLAYER, FLAG_SPAWNED);
	if(owner >= 0) format(q, sizeof(q), "`owner` = '%d' AND `owner_type` = '%d' AND `flags` = '%d' ORDER BY `id`", Player[owner][UID], TYPE_OWNER_PLAYER, FLAG_SPAWNED);
	else format(q, sizeof(q), "`owner_type` <> '%d' AND `flags` = '%d' ORDER BY `id`", TYPE_OWNER_PLAYER, FLAG_SPAWNED);
	strcat(query, q);
	
	mysql_query(query);
	printf("testtttt: %s", query);
	
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
		index = Iter_Free(Vehicle);

		sscanf(query, "p<|>ddddffffdddfds[128]ddddds[20]fdfdffdd",
			Vehicle[index][vUID],		Vehicle[index][vModel],		Vehicle[index][vOwner],	
			Vehicle[index][vOwnerType], Vehicle[index][vX],			Vehicle[index][vY],
			Vehicle[index][vZ],			Vehicle[index][vA],			Vehicle[index][vColor1],
			Vehicle[index][vColor2], 	Vehicle[index][vLocked], 	Vehicle[index][vHealth],
			Vehicle[index][vAudio], 	Vehicle[index][vUrl], 		Vehicle[index][vPlay],
			Vehicle[index][vPanels], 	Vehicle[index][vDoors], 	Vehicle[index][vLights],
			Vehicle[index][vTires], 	Vehicle[index][vNrPlate], 	Vehicle[index][vDistance],
			Vehicle[index][vFlags], 	Vehicle[index][vFuel], 		Vehicle[index][vFuelType],
			Vehicle[index][vFuelConsumption], 						Vehicle[index][vFuelMax],
			Vehicle[index][vMaxPassengers], 						Vehicle[index][vPassengers]);
		
		Iter_Add(Vehicle, index);
		CreateVehicle(Vehicle[index][vModel], Vehicle[index][vX], Vehicle[index][vY], Vehicle[index][vZ], Vehicle[index][vA], Vehicle[index][vColor1], Vehicle[index][vColor2], -1);
		
		Vehicle[index][vFlags] |= FLAG_SPAWNED;
		Vehicle[index][vEngine] = false;
		
		if(Vehicle[index][vHealth] < 260.0)
		{
		    SetVehicleHealth(index, 270.0);
			Vehicle[index][vFlags] |= FLAG_DESTROYED;
		}

		SetVehicleHealth(index, Vehicle[index][vHealth]);
		SetVehicleParamsEx(index, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, Vehicle[index][vLocked], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, -1);
		UpdateVehicleDamageStatus(index, Vehicle[index][vPanels], Vehicle[index][vDoors], Vehicle[index][vLights], Vehicle[index][vTires]);	
	}
	printf("Server: Loaded %d vehicles", Iter_Count(Vehicle));
}



CallBack:SpawnVehicle(vehicleid)
{
    new str[500], rand = random((9999) - (1000) + (1)) + (1000);
    format(str, sizeof(str), "SELECT `model`, `owner`, `owner_type`, `x`, `y`, `z`, `a`, `color1`, `color2`, `locked`, `health`, `audio`, `url`, `play`, `panels`, `doors`, `lights`, `tires`, `nrplate`, `distance`, `flags`, `fuel`, `fueltype`, `fuelconsumption`, `fuelmax`, `maxpassengers`, `passengers` FROM `"prefix"vehicles` WHERE `id` = '%d' LIMIT 1", vehicleid);
	mysql_query(str);
	mysql_store_result();
	

	new index = Iter_Free(Vehicle);

	Iter_Add(Vehicle, index);
	while(mysql_fetch_row_format(str, "|"))
	{
		sscanf(str, "p<|>dddffffdddfds[128]ddddds[20]fdfdffdd",
			Vehicle[index][vModel],		Vehicle[index][vOwner],		Vehicle[index][vOwnerType], 
			Vehicle[index][vX],			Vehicle[index][vY], 		Vehicle[index][vZ],			
			Vehicle[index][vA],			Vehicle[index][vColor1],	Vehicle[index][vColor2], 	
			Vehicle[index][vLocked], 	Vehicle[index][vHealth],	Vehicle[index][vAudio], 
			Vehicle[index][vUrl], 		Vehicle[index][vPlay],		Vehicle[index][vPanels], 	
			Vehicle[index][vDoors], 	Vehicle[index][vLights],	Vehicle[index][vTires], 	
			Vehicle[index][vNrPlate], 	Vehicle[index][vDistance],	Vehicle[index][vFlags],
			Vehicle[index][vFuel], 		Vehicle[index][vFuelType], 	Vehicle[index][vFuelConsumption],
			Vehicle[index][vFuelMax], 	Vehicle[index][vMaxPassengers], Vehicle[index][vPassengers]);
			printf("indexside: %d", index);
		
		CreateVehicle(Vehicle[index][vModel], Vehicle[index][vX], Vehicle[index][vY], Vehicle[index][vZ], Vehicle[index][vA], Vehicle[index][vColor1], Vehicle[index][vColor2], -1);
		
		Vehicle[index][vFlags] |= FLAG_SPAWNED;
		Vehicle[index][vUID] = vehicleid;

		SetVehicleHealth(index, Vehicle[index][vHealth]);
		SetVehicleParamsEx(index, Vehicle[index][vEngine] = false, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, Vehicle[index][vLocked], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, -1);
		UpdateVehicleDamageStatus(index, Vehicle[index][vPanels], Vehicle[index][vDoors], Vehicle[index][vLights], Vehicle[index][vTires]);	
		
		if(isnull(Vehicle[index][vNrPlate])) //	Later to rewrite! 
		{
			format(str, 32, "{660000}SC{18161b} %d", rand);
			SetVehicleNumberPlate(index, str);
			format(Vehicle[index][vNrPlate], 20, "Brak");
		}
		else
		{
		    format(str, 32, "{660000}BS{18161b} %s", Vehicle[index][vNrPlate]);
			SetVehicleNumberPlate(index, str);
		}//to do
		
		if(Vehicle[index][vHealth] < 260.0)
		{
		    SetVehicleHealth(index, 270.0);
			Vehicle[index][vFlags] |= FLAG_DESTROYED;
		}
	}
	mysql_free_result();
	return index;
}


CallBack:UnSpawnVehicle(vehicleid, return_model)
{
	new veh = GetVehicleIndexByUID(vehicleid);
	//Vehicle[veh][vFlags] &=~ FLAG_SPAWNED;
    SaveVehicle(vehicleid);
    DestroyVehicle(veh);
	Iter_Remove(Vehicle, veh);
    
    
	new model;
    if(return_model) model = Vehicle[veh][vModel];
	
	for(new v:i; i != v; i++)
    {
 		Vehicle[veh][i] = 0;
 	}
 	return return_model == 1 ? model : 1;
}



CallBack:SaveVehicle(uid)
{
	new index = GetVehicleIndexByUID(uid);
	
	GetVehicleHealth(index, Vehicle[index][vHealth]);
	if(Vehicle[index][vHealth] <= 260.0)
	    Vehicle[index][vHealth] = 255.0;

	if(!strcmp("Brak", Vehicle[index][vNrPlate], false))//	Later to rewrite! 
	    Vehicle[index][vNrPlate] = EOS;
	

	GetVehicleDamageStatus(index, Vehicle[index][vPanels], Vehicle[index][vDoors], Vehicle[index][vLights], Vehicle[index][vTires]);

	new query[700], query2[30]; //Size4Url
	format(query, sizeof(query), "UPDATE `"prefix"vehicles` SET `model` = '%d', `owner` = '%d', `owner_type` = '%d', `x` = '%f', `y` = '%f', `z` = '%f', `a` = '%f', `color1` = '%d', `color2` = '%d', `locked` = '%d', `health` = '%.1f', `audio` = '%d', `url` = '%s', `play` = '%d', `panels` = '%d', `doors` = '%d', `lights` = '%d', `tires` = '%d', `nrplate` = '%s', `distance` = '%f', `flags` = '%d', `fuel` = '%f', `fueltype` = '%d', `fuelconsumption` = '%f', `fuelmax` = '%f', `maxpassengers` = '%d' ",
	Vehicle[index][vModel],		Vehicle[index][vOwner],		Vehicle[index][vOwnerType],
	Vehicle[index][vX],			Vehicle[index][vY],			Vehicle[index][vZ],
	Vehicle[index][vA],			Vehicle[index][vColor1],	Vehicle[index][vColor2],
	Vehicle[index][vLocked],	Vehicle[index][vHealth],	Vehicle[index][vAudio],
	Vehicle[index][vUrl],		Vehicle[index][vPlay],		Vehicle[index][vPanels],
	Vehicle[index][vDoors],		Vehicle[index][vLights],	Vehicle[index][vTires],
	Vehicle[index][vNrPlate],	Vehicle[index][vDistance],	Vehicle[index][vFlags], 
	Vehicle[index][vFuel],		Vehicle[index][vFuelType],	Vehicle[index][vFuelConsumption],
	Vehicle[index][vFuelMax], 	Vehicle[index][vMaxPassengers]);
	
	format(query2, sizeof(query2), "WHERE `id` = '%d' LIMIT 1", uid);
	strcat(query, query2);
	
	print(query);
	mysql_query(query);
	return 1;
}	

CallBack:CreateVeh(owner, owner_type, model, Float:posx, Float:posy, Float:posz, Float:posa, color1, color2)
{
	new query[196];
	format(query, sizeof(query), "INSERT INTO "prefix"vehicles (`model`, `owner`, `owner_type`, `x`, `y`, `z`, `a`, `color1`, `color2`) VALUES \
															   ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%d', '%d')", model, owner, owner_type, posx, posy, posz, posa, color1, color2);
	mysql_query(query);
	
	new id = mysql_insert_id();
	/*Vehicle[id][vUID] = id; 		Vehicle[id][vColor1] = color1;		Vehicle[id][vColor2] = color2;
  	Vehicle[id][vModel] = model;	Vehicle[UID][vOwner] = owner;		Vehicle[UID][vOwnerType] = owner_type;
    Vehicle[id][vHealth] = 1000.0; 	Vehicle[id][vX] = posx; 			Vehicle[id][vY] = posy;
    Vehicle[id][vZ] = posz;			Vehicle[id][vA] = posa; 			Vehicle[id][vSpawned] = 1;
	
    Iter_Add(Vehicle, CreateVehicle(Vehicle[id][vModel], Vehicle[id][vX], Vehicle[id][vY], Vehicle[id][vZ], Vehicle[id][vA], Vehicle[id][vColor1], Vehicle[id][vColor2], -1));
	THIS WAS A BAD IDEA!
	*/
	return id;
}


CallBack:UnSpawnVehiclesIf(uid)
{
	foreach(new i : Player)
	{
		if(Player[i][UID] == uid) return printf("gracz wszed³");
	}
	
	/*foreach(new veh : Vehicle)
	{
		if(Vehicle[veh][vOwner] == uid && (Vehicle[veh][vFlags] & FLAG_SPAWNED) && Vehicle[veh][vOwnerType] == TYPE_OWNER_PLAYER) UnSpawnVehicle(Vehicle[veh][vUID]);
	}*/
	
	foreach(new veh : Vehicle)
	{
		if(Vehicle[veh][vOwner] == uid && (Vehicle[veh][vFlags] & FLAG_SPAWNED) && Vehicle[veh][vOwnerType] == TYPE_OWNER_PLAYER) 
		{
			printf("pojazd uid: %d zostaj unspawnowany", Vehicle[veh][vUID]);
			new i = UnSpawnVehicle(Vehicle[veh][vUID], false);
			printf("i = %d", i);
			if(i) UnSpawnVehiclesIf(uid);
			else break;
		}
	}
	return 1;
}

CMD:wsiadz(playerid, params[])
{
	new Float:a, Float:b, Float:c;
	
	if(Player[playerid][InVehicle] > 0)
	{
		TogglePlayerSpectating(playerid, 0);
		return 1;
	}

	foreach(new veh : Vehicle)
	{
		GetVehiclePos(veh, a, b, c);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, a, b, c) && Vehicle[veh][vPassengers] < Vehicle[veh][vMaxPassengers] && !Vehicle[veh][vLocked])
		{
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, veh);
			Player[playerid][InVehicle] = veh;
			Vehicle[veh][vPassengers]++;
		}
	}
	return 1;
}

stock SendMessageToDrivers(playerid, const message[])
{
	foreach(new veh : Vehicle)
	{
		if(Vehicle[veh][vOwner] == Player[playerid][UID] && Vehicle[veh][vOwnerType] == TYPE_OWNER_PLAYER)
		{
			foreach(new i : Player)
			{
				if(GetPlayerVehicleID(i) == veh && GetPlayerState(i) == PLAYER_STATE_DRIVER)
				{
					SendClientMessage(i, COLOR_GRAD1, message);
				}
			}
		}
	}
	return 1;
}

stock IsVehicleOwner(playerid, vehicleid)
{
	new query[128];
	format(query, sizeof(query), "SELECT `id` FROM `"prefix"vehicles` WHERE `owner` = '%d' AND `id` = '%d' LIMIT 1", Player[playerid][UID], vehicleid);
	mysql_query(query);
	mysql_store_result();
	
	new rows = mysql_num_rows();
	mysql_free_result();
	return rows;
}


stock GetFreeIndexVehicles()
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(Vehicle[i][vUID] == 0) return i;
	}
	return 0;
}

stock GetVehicleIndexByUID(uid)
{
	foreach(new i : Vehicle)
	{
		if(Vehicle[i][vUID] == uid) return i;
	}
	return -1;
}

stock IsAnyPlayerInVehicle(vehicleid)
{
	foreach(new i : Player)
	{
		if(IsPlayerInVehicle(i, vehicleid)) return i;
	}
	return -1;
}

stock GetPlayerVehicleInRange(playerid, Float:range)
{
	foreach(new i : Vehicle)
	{
		if(i > 0 && Vehicle[i][vOwner] == Player[playerid][UID])
		{
			new Float:vx, Float:vy, Float:vz;
			GetVehiclePos(i, vx, vy, vz);

			if(IsPlayerInRangeOfPoint(playerid, range, vx, vy, vz) || (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == i)) return i;
    	}
  	}
	return -1;
}

CallBack:SpeedCounterUpDate(playerid, vehicleid)
{
	new string[76], string2[6], string4[24];	//25*3 = 75
	//for(new i = 0; i < 8; i++) TextDrawShowForPlayer(playerid, OverallSpeedCounter[i]);

	new Float:PercentFuel = (Vehicle[vehicleid][vFuel] * 100 / Vehicle[vehicleid][vFuelMax]) * 25 / 100; // (Ilosc posiadania paliwa * 100 / Max paliwa w aucie) || 25 - max ~n~ w TD
	
	for(new j; j != floatround(PercentFuel); j++) strcat(string, "~n~");
	PlayerTextDrawSetString(playerid, SpeedCounter[0][playerid], string);
	
	format(string2, sizeof(string2), "%0.1f", Vehicle[vehicleid][vFuel]);
	PlayerTextDrawSetString(playerid, SpeedCounter[1][playerid], string2);
	
	/*format(string3, sizeof(string3), "%d", GetVehicleSpeed(vehicleid));
	PlayerTextDrawSetString(playerid, SpeedCounter[3][playerid], string3);
	
	format(string5, sizeof(string5), "~r~ %.3f", Vehicle[vehicleid][vDistance]);
	PlayerTextDrawSetString(playerid, SpeedCounter[4][playerid], string5);*/
	
	//format(string4, sizeof(string4), "%s", VehiclesName[Vehicle[vehicleid][vModel] - 400]);
	format(string4, sizeof(string4), "%s", VehiclesName[GetVehicleModel(GetPlayerVehicleID(playerid)) - 400]);
	PlayerTextDrawSetString(playerid, SpeedCounter[2][playerid], string4);
}

CallBack:Vehicle_OnGameModeExit()
{
	foreach(new veh : Vehicle)
    {
		SaveVehicle(Vehicle[veh][vUID]);
		DestroyVehicle(veh);
		Iter_Remove(Vehicle, veh);
		for(new v:i; i != v; i++) Vehicle[veh][i] = 0;
    }
}

CallBack:Vehicle_OnPlayerDisconnect(playerid, reason)
{
	if(reason == 0)
 	{
  		SendMessageToDrivers(playerid, "W³aœciciel tego pojazdu opuœci³ grê w wyniku crasha. Pojazd bêdzie dostepny przez nastêpne 3 minuty");
		SendMessageToDrivers(playerid, "i zniknie jeœli jego w³aœciciel nie wróci w tym czasie do gry.");
  		SetTimerEx("UnSpawnVehiclesIf", 180000, 0, "d", Player[playerid][UID]);
 	}
 	else
 	{
  		SendMessageToDrivers(playerid, "W³aœciciel tego pojazdu opuœci³ grê.. Pojazd bêdzie dostepny przez nastêpn¹ minutê");
		SendMessageToDrivers(playerid, "i zniknie jeœli jego w³aœciciel nie wróci w tym czasie do gry.");
  		SetTimerEx("UnSpawnVehiclesIf", 60000, 0, "d", Player[playerid][UID]);
  	}
	
}

CallBack:Vehicle_OnPlayerStateChange(playerid, newstate, oldstate)
{
	new veh = GetPlayerVehicleID(playerid);
	
    if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
		if(!Vehicle[veh][vEngine]) TextDrawShowForPlayer(playerid, EngineVehicles);
		//Vehicle[veh][vDriver] = playerid;
		
		for(new i = 0; i < 8; i++) TextDrawShowForPlayer(playerid, OverallSpeedCounter[i]);
		printf("siedzisz w %d", veh);
		SpeedCounterUpDate(playerid, veh);
		
		for(new w = 0; w < 5; w++) PlayerTextDrawShow(playerid, SpeedCounter[w][playerid]);
	}
	
	if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER)
	{ 
		TextDrawHideForPlayer(playerid, EngineVehicles);
		for(new i = 0; i < 8; i++)  TextDrawHideForPlayer(playerid, OverallSpeedCounter[i]);
		for(new w = 0; w < 5; w++) PlayerTextDrawHide(playerid, SpeedCounter[w][playerid]);
		//Vehicle[veh][vDriver] = -1;
	}	
}

CallBack:Vehicle_OnPlayerUpdate(playerid)
{
	if(GetPlayerVehicleID(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new string3[4], string5[25], veh = GetPlayerVehicleID(playerid);
		format(string3, sizeof(string3), "%d", GetVehicleSpeed(veh));
		PlayerTextDrawSetString(playerid, SpeedCounter[3][playerid], string3);
	
		format(string5, sizeof(string5), "~r~ %.3f", Vehicle[veh][vDistance]/1000);
		PlayerTextDrawSetString(playerid, SpeedCounter[4][playerid], string5);
	}
}

CallBack:Vehicle_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_VEHICLES_LIST)
	{
	    if(response)
	    {
			new vehicleuid = strval(inputtext), string[126], title[126], query[64];
			new index = GetVehicleIndexByUID(vehicleuid);
			SetPVarInt(playerid, "vehicleuid", vehicleuid);
			
 			if(index > 0) 
			{
				format(title, sizeof(title), "{4876FF}Twoje pojazdy{a9c4e4} » %s (UID: %d)", VehiclesName[Vehicle[index][vModel] - 400], vehicleuid);
				format(string, sizeof(string), "Unspawnuj\nInformacje\nNamierz\n");
			}	
 			else
			{
			    format(query, sizeof(query), "SELECT `model` FROM `"prefix"vehicles` WHERE `id` = '%d'", vehicleuid);
				mysql_query(query);
				mysql_store_result();
				mysql_fetch_row_format(query);	
				new model = strval(query);
				mysql_free_result();

			    SetPVarInt(playerid, "vehmodel", model);
				format(title, sizeof(title), "{4876FF}Twoje pojazdy{a9c4e4} » %s (UID: %d)", VehiclesName[model - 400], vehicleuid);
				format(string, sizeof(string), "Spawnuj\n");
			}

 			format(string, sizeof(string), "%s---------------\nUsun(bezpowrotnie)\n", string);
 			ShowPlayerDialog(playerid, DIALOG_VEHICLES_LIST_2, DIALOG_STYLE_LIST, title, string, "Wybierz", "Zamknij");
	    }
	    return 1;
	}
	if(dialogid == DIALOG_VEHICLES_LIST_2)
	{
		new vehicleuid = GetPVarInt(playerid, "vehicleuid");
		new index = GetVehicleIndexByUID(vehicleuid);
		//new model = GetPVarInt(playerid, "vehmodel");
		printf("index: %d, vehuid: %d", index, vehicleuid);
	    new string[128], title[100], command[15];
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
				{
				    if(index >= 0)
				    {
						format(command, sizeof(command), "unspawn %d", vehicleuid);
						cmd_v(playerid, command);
					}
				    else
				    {
				        format(command, sizeof(command), "spawn %d", vehicleuid);
						cmd_v(playerid, command);
				    }
				}
				case 1: // Info
				{
					if(!(Vehicle[index][vFlags] & FLAG_SPAWNED)) return 1;
 					format(title, sizeof(title), "{4876FF}Twoje pojazdy{a9c4e4} » Informacje o %s (UID: %d)", VehiclesName[Vehicle[index][vModel] - 400], vehicleuid);
				    format(string, sizeof(string), "UID:\t\t%d\nModel:\t\t%d\n", vehicleuid, Vehicle[index][vModel]);
				    if(Vehicle[index][vHealth] > 260) format(string, sizeof(string), "%sHP:\t\t%.2f\n", string, Vehicle[index][vHealth]);
				    else format(string, sizeof(string), "%sHP:\t\t%.2f(Zniszczony)\n", string, Vehicle[index][vHealth]);
				    format(string, sizeof(string), "%sPrzebieg:\t%.3fkm\nZamkniêty:\t%s\nKolor 1:\t\t%d\nKolor 2:\t\t%d\nRejestracja:\t%s\n", string, Vehicle[index][vDistance]/1000, \
													YesOrNo(Vehicle[index][vLocked]), Vehicle[index][vColor1], Vehicle[index][vColor2], Vehicle[index][vNrPlate]);
					ShowPlayerDialog(playerid, NONE, DIALOG_STYLE_LIST, title, string, "Zamknij", "");
				}
				case 2: // Namierz || Usuñ
				{
					if(Vehicle[index][vFlags] & FLAG_SPAWNED)
				    {
						format(command, sizeof(command), "namierz %d", vehicleuid);
						cmd_v(playerid, command);
					}
				}
	        }
			return 1;
	    }
	}	
	return 1;
}



































