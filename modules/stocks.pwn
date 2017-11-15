//	modules/stock.pwn

stock GetVehicleSpeed(vehicleid)
{
        if(vehicleid != INVALID_VEHICLE_ID)
        {
                new Float:Pos[3], Float:VS;
                GetVehicleVelocity(vehicleid, Pos[0], Pos[1], Pos[2]);
                VS = floatsqroot(Pos[0] * Pos[0] + Pos[1] * Pos[1] + Pos[2] * Pos[2]) * 200;
                return floatround(VS, floatround_round);
        }
        return INVALID_VEHICLE_ID;
}
stock SetVehicleSpeed(vehicleid,mph) 
{
	new Float:Vx,Float:Vy,Float:Vz,Float:DV,Float:multiple;
	GetVehicleVelocity(vehicleid,Vx,Vy,Vz);
	
	DV = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
	
	if(DV > 0) 
	{
		multiple = (mph / (DV * 100)); //Multiplying DV by 100 calculates speed in MPH
		return SetVehicleVelocity(vehicleid,Vx*multiple,Vy*multiple,Vz*multiple);
	}
	return 0;
}

stock PreloadAnimations(playerid)
{
	if(!GetPVarInt(playerid, "PreLoad"))
	{
   		PreloadAnimLib(playerid, "BOMBER");
   		PreloadAnimLib(playerid, "RAPPING");
    	PreloadAnimLib(playerid, "SHOP");
   		PreloadAnimLib(playerid, "BEACH");
   		PreloadAnimLib(playerid, "SMOKING");
    	PreloadAnimLib(playerid, "FOOD");
    	PreloadAnimLib(playerid, "ON_LOOKERS");
    	PreloadAnimLib(playerid, "DEALER");
		PreloadAnimLib(playerid, "CRACK");
		PreloadAnimLib(playerid, "CARRY");
		PreloadAnimLib(playerid, "COP_AMBIENT");
		PreloadAnimLib(playerid, "PARK");
		PreloadAnimLib(playerid, "INT_HOUSE");
		PreloadAnimLib(playerid, "INT_OFFICE");
		PreloadAnimLib(playerid, "FOOD");
		PreloadAnimLib(playerid, "PED");
		PreloadAnimLib(playerid, "POLICE");
		PreloadAnimLib(playerid, "CAR");
		PreloadAnimLib(playerid, "CAR_CHAT");
		PreloadAnimLib(playerid, "MEDIC");
		PreloadAnimLib(playerid, "GANGS");
		PreloadAnimLib(playerid, "BENCHPRESS");
		PreloadAnimLib(playerid, "HEIST9");
		PreloadAnimLib(playerid, "MISC");
		PreloadAnimLib(playerid, "OTB");
		PreloadAnimLib(playerid, "PAULNMAC");
		PreloadAnimLib(playerid, "SWEET");
		PreloadAnimLib(playerid, "GRAFFITI");
		PreloadAnimLib(playerid, "FIGHT_C");
		PreloadAnimLib(playerid, "FIGHT_B");
		PreloadAnimLib(playerid, "FIGHT_D");
		PreloadAnimLib(playerid, "WAYFARER");
		PreloadAnimLib(playerid, "BASEBALL");
		PreloadAnimLib(playerid, "GRENADE");
		PreloadAnimLib(playerid, "BSKTBALL");
		PreloadAnimLib(playerid, "RIOT");
		PreloadAnimLib(playerid, "BD_FIRE");
		SetPVarInt(playerid, "PreLoad", 1);
	}
}

stock PreloadAnimLib(playerid, animlib[]) return ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);

stock capitalize(t[]) 
{
	for(new i = 0; i < strlen(t); ++i)
	if(t[i] == 46 && t[i + 1] >= 97 && t[i + 1] << 122) t[i + 1] -= 32;
	else if(i > 0 && t[i] == 32 && t[i - 1] == 46 && t[i + 1] >= 97 && t[i + 1] << 122)
	t[i + 1] -= 32;
	return t;
} 	

stock UnderscoreToSpace(name[])
{
	new pos = strfind(name, "_", true);
	if(pos != -1) name[pos] = ' ';
	return 1;
}

stock ServerMe(playerid, text[], dot = 0, Float:distance = 10.0)
{
  new string[128];

  dcfirst(text);

  if(strlen(text) > SPLIT_TEXT_LIMIT)
  {
		new stext[128];

		strmid(stext, text, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "** %s %s...", Player[playerid][NameSpace], stext);
		SendClientMessageEx(distance, playerid, string,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		strmid(stext, text, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		
		if(dot && text[strlen(text)-1] != '.')
		{
			format(string, sizeof(string), "** ...%s. ((%s))", stext, Player[playerid][NameSpace]);
		}
		else
		{
			format(string, sizeof(string), "** ...%s ((%s))", stext, Player[playerid][NameSpace]);
		}
		SendClientMessageEx(distance, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	}
	else
	{
		if(dot && text[strlen(text)-1] != '.')
		{
			format(string, sizeof(string), "** %s %s.", Player[playerid][NameSpace], text);
		}
		else
		{
			format(string, sizeof(string), "** %s %s", Player[playerid][NameSpace], text);
		}
		SendClientMessageEx(distance, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	}
  
  printf("* %s %s", Player[playerid][Name], text);
  return 1;
}

stock SendClientMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, echo = 0)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
					if(echo == 0)
					{
	        		
						GetPlayerPos(i, posx, posy, posz);
						tempposx = (oldposx -posx);
						tempposy = (oldposy -posy);
						tempposz = (oldposz -posz);
					
						if(((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
							SendClientMessage(i, col1, string);
						else if(((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
							SendClientMessage(i, col2, string);
						else if(((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
							SendClientMessage(i, col3, string);
						else if(((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
							SendClientMessage(i, col4, string);
						else if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
							SendClientMessage(i, col5, string);

					}
					else if(echo == 1)
					{
						if(i != playerid)
						{
							GetPlayerPos(i, posx, posy, posz);
							tempposx = (oldposx -posx);
							tempposy = (oldposy -posy);
							tempposz = (oldposz -posz);
						
							if(((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
								SendClientMessage(i, col1, string);
							else if(((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
								SendClientMessage(i, col2, string);
							else if(((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
								SendClientMessage(i, col3, string);
							else if(((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
								SendClientMessage(i, col4, string);
							else if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
								SendClientMessage(i, col5, string);
						}
					}
				}
			}
		}
	}	
	return 1;
}

stock AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

stock DInfo(playerid, text[])
{
	ShowPlayerDialog(playerid, DUMMY, DIALOG_STYLE_MSGBOX, ""DIALOG_SERVER_NAME" Informacja", text, "Ok", "");
	return 1;
}
stock BSRPDialog(playerid, dialogid, style, caption1[], caption2[], text[], button1[], button2[])
{
	new caption3[64];
	format(caption3, 64, "{4876FF}%s{a9c4e4} » %s", caption1, caption2);
	ShowPlayerDialog(playerid, dialogid, style, caption3, text, button1, button2);
	return 1;
}