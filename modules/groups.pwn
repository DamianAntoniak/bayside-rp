// modules/groups.pwn

#define TYPE_PD 1
#define TYPE_SAMERS 2
#define TYPE_GANG 3


enum gGroup
{
	gUID,
	gType,
	gName[32],
	gTag[10],
	gColor[10],
	gMemberRank,
	bool:gChat
};

new Group[MAX_PLAYERS][MAX_GROUPS][gGroup];


CMD:ag(playerid, params[])
{
	if(Player[playerid][Admin] < 3) return GameTextForPlayer(playerid, "~r~Brak autoryzacji!", 3000, 3);
	
	new str1[32], str2[64];
	
	if(sscanf(params, "s[32]S()[32]", str1, str2))
        return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /ag(roups) [stworz, usun, invite].");
	
	if(!strcmp(str1, "stworz", true))
		return ShowPlayerDialog(playerid, DIALOG_CREATE_GROUPS_1, DIALOG_STYLE_INPUT, "{4876FF}"servername"{a9c4e4} » Admin » Grupy", "Podaj nazwe nowej grupy:", "Dalej", "Zamknij");

	else if(!strcmp(str1, "usun", true))
	{
		new uid, query[128], string[128];
		if(sscanf(str2, "d", uid))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /ag(roups) usun [IdGrupy]");
			
		format(query, sizeof(query), "DELETE  FROM "prefix"groups_serverWHERE `id` = '%d'", uid);
		mysql_query(query);
		
		format(query, sizeof(query), "DELETE  FROM "prefix"groups_members WHERE `group` = '%d'", uid);
		mysql_query(query);
		
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				for(new id; id != MAX_GROUPS; id++)
				{	
					if(Group[i][id][gUID] == uid)
					{
						format(string, sizeof(string), "Grupa: %s, do której nale¿a³eœ zosta³a skasowana.", Group[i][id][gName]);
						SendClientMessage(i, COLOR_LORANGE, string);
						for(new gGroup:j; j != gGroup; j++) Group[i][id][j] = 0;
					}
				}
			}	
		}
		return 1;
	}
	else if(!strcmp(str1, "invite", true))
	{
		new string[128], member, group, rank;
		if(sscanf(str2, "ddd", group, member, rank))
			return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /ag(roups) invite [IdGrupy] [IdGracza] [IdRangi]");
			
		new id = GetFreeSlot(member);
		if(id < 0) return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz nie posiada wolnych slotów.");
		
		id = IsPlayerGroup(member, group);
		if(id != 0) return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz ju¿ jest w tej grupie.");
		
		InviteMember(member, group);
		
		ReLoadGroupForPlayer(member);
		
		id = IsPlayerGroup(member, group);
		format(string, sizeof(string), "Doda³eœ %s(ID: %d) do grupy: %s(UID: %d).", Player[member][Name], member, Group[member][id][gName], group);
		SendClientMessage(playerid, COLOR_LORANGE, string);	
		
		format(string, sizeof(string), " %s(ID: %d) doda³ cie do grupy: %s.", Player[playerid][Name], playerid, Group[member][id][gName]);
		SendClientMessage(member, COLOR_LORANGE, string);	
	}
	return 1;
}

CMD:g(playerid, params[])
{
	return cmd_groups(playerid, "lista");
}

CMD:groups(playerid, params[])
{
    new str1[64], str2[64], x = 0;

    if(sscanf(params, "s[64]S()[64]", str1, str2))
        return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /groups [lista, zaproœ, wyrzuæ, dajrange, chat].");

    if(!strcmp(str1, "lista", true) || !strcmp(str1, "l", true))
    {
        new string[256]; 
		format(string, sizeof(string), "{a9c4e4}Slot\tUID\tNazwa{ffffff}\n", string);
    	for(new i; i != MAX_GROUPS; i++)
		{
			if(!Group[playerid][i][gUID]) continue;

			format(string, sizeof(string), "%s%d\t%d\t{%s}%s{a9c4e4}\n", string, i, Group[playerid][i][gUID], Group[playerid][i][gColor], Group[playerid][i][gName]);
			x++;
		}
		if(x == 0) return GameTextForPlayer(playerid, "~r~Nie nalezysz do zadnej grupy!", 3000, 3);
		else ShowPlayerDialog(playerid, DIALOG_GROUPS_LIST_1, DIALOG_STYLE_LIST, "{4876FF}"servername"{a9c4e4} » Grupy » Lista", string, "Wiêcej", "Zamknij");
    }
	else if(!strcmp(str1, "zapros", true) || !strcmp(str1, "invite", true))
    {
        new groupid, victimid, /*uid,*/string[256];

		if(sscanf(str2, "du", groupid, victimid))
			return SendClientMessage(playerid, COLOR_GRAD1, "Wpisz: /g(rupy) zapros [slot] [IdGracza]");

		if(Group[playerid][groupid][gMemberRank] != 255)
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ liderem tej grupy!");

   		if(!IsPlayerConnected(victimid))
			return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz jest niedostepny!");

		if(IsPlayerGroup(victimid, Group[playerid][groupid][gUID]))
			return SendClientMessage(playerid, COLOR_GRAD1, "Gracz jest ju¿ w tej grupie!");

		if(Group[victimid][MAX_GROUPS-1][gUID])
			return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz osi¹gn¹³ ju¿ limit grup.");

		InviteMember(victimid, Group[playerid][groupid][gUID]);

		/*uid = GetFreeSlot(playerid);

		Group[victimid][uid][gUID] = Group[playerid][groupid][gUID];
		//Group[victimid][uid][oMember] = Player[playerid][UID];
    	Group[victimid][uid][gMemberRank] = 0;

    	format(Group[victimid][uid][gName], 32, Group[playerid][groupid][gName]);
    	format(Group[victimid][uid][gColor], 10, Group[playerid][groupid][gColor]);
    	format(Group[victimid][uid][gTag], 10, Group[playerid][groupid][gTag]);
		*/
		ReLoadGroupForPlayer(victimid);
    	format(string, sizeof(string), "Zosta³eœ przyjêty do %s przez %s(ID: %d).", Group[playerid][groupid][gName], Player[playerid][Name], playerid);
		SendClientMessage(victimid, COLOR_LORANGE, string);

		format(string, sizeof(string), "Przyj¹³eœ: %s (ID: %d) do grupy: %s", Player[victimid][Name], victimid, Group[playerid][groupid][gName]);
		SendClientMessage(playerid, COLOR_LORANGE, string);
    }
	else if(!strcmp(str1, "wyrzuc", true) || !strcmp(str1, "uninvite", true) || !strcmp(str1, "zwolnij", true))
    {
		new groupid, victimid, string[128];

		if(sscanf(str2, "du", groupid, victimid))
			return SendClientMessage(playerid, COLOR_GRAD1, "Wpisz: /grupy wypros [slot] [IdGracza]");

		if(Group[playerid][groupid][gMemberRank] != 255)
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ liderem tej grupy!");

        if(!IsPlayerConnected(victimid))
   			return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz jest niedostepny!");

		if(!IsPlayerGroup(victimid, Group[playerid][groupid][gUID]))
			return SendClientMessage(playerid, COLOR_GRAD1, "Gracz nie jest w twojej grupie!");

		RemoveMemberFromGrup(victimid, Group[playerid][groupid][gUID]);

		format(string, sizeof(string), "%s(ID: %d) wyrzuci³ Cie z %s", Player[playerid][NameSpace], playerid, Group[playerid][groupid][gName]);
		SendClientMessage(victimid, COLOR_GRAD1, string);

		format(string, sizeof(string), "Wyrzuci³eœ: %s(ID: %d) z grupy: %s", Player[victimid][NameSpace], victimid, Group[playerid][groupid][gName]);
		SendClientMessage(playerid, COLOR_GRAD1, string);
		
		ReLoadGroupForPlayer(playerid);
	}
	else if(!strcmp(str1, "giverank", true) || !strcmp(str1, "dajrange", true))
	{
		new groupid, rank, victimid, string[128];

		if(sscanf(str2, "ddu", groupid, victimid))
			return SendClientMessage(playerid, COLOR_GRAD1, "Wpisz: /grupy dajrange [slot] [ranga] [IdGracza]");

		if(Group[playerid][groupid][gMemberRank] != 255)
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ liderem tej grupy!");

        if(!IsPlayerConnected(victimid))
   			return SendClientMessage(playerid, COLOR_GRAD1, "Ten gracz jest niedostepny!");
			
		new slot = IsPlayerGroup(victimid, Group[playerid][groupid][gUID]);
		
		if(!slot)
			return SendClientMessage(playerid, COLOR_GRAD1, "Gracz nie jest w twojej grupie!");
			
		GiveRank(victimid, Group[playerid][groupid][gUID], rank);
		
		if(Group[victimid][slot][gMemberRank] > rank)
		{
			format(string, sizeof(string), "%s(ID: %d) zdegradowa³ Cie na %d range.", Player[playerid][NameSpace], playerid, rank);
			SendClientMessage(victimid, COLOR_GRAD1, string);

			format(string, sizeof(string), "Zdegradowa³eœ: %s(ID: %d) na %d range.", Player[victimid][NameSpace], victimid, rank);
			SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		else
		{
			format(string, sizeof(string), "%s(ID: %d) awansowa³ Cie na %d range.", Player[playerid][NameSpace], playerid, rank);
			SendClientMessage(victimid, COLOR_LORANGE, string);

			format(string, sizeof(string), "Awansowa³eœ: %s(ID: %d) na %d range.", Player[victimid][NameSpace], victimid, rank);
			SendClientMessage(playerid, COLOR_LORANGE, string);
		}		
		Group[victimid][slot][gMemberRank] = rank;
		return 1;
	}
	else if(!strcmp(str1, "chat", true) || !strcmp(str1, "czat", true))
	{
		new slot, chat[3];

		if(sscanf(str2, "ds[3]", slot, chat))
			return SendClientMessage(playerid, COLOR_GRAD1, "Wpisz: /g czat [slot] [on/off]");
			
		if(Group[playerid][slot][gMemberRank] != 255)
			return SendClientMessage(playerid, COLOR_GRAD1, "Nie jesteœ liderem tej grupy!");
		
		ChatGroupsON(playerid, slot, chat);
		return 1;
	}
	return 1;
}

//commands

CMD:skuj(playerid, params[])//if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);
{
	new giveplayerid, Float:x, Float:y, Float:z, string[50];
	if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_GRAD1, "U¯YJ: /skuj [ID gracza]");
	
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "Ta osoba jest niedostêpna.");
	
	if(!Player[giveplayerid][Logged]) return SendClientMessage(playerid, COLOR_GREY, "Ta osoba nie jest zalogowana.");
	
	if(!Player[giveplayerid][Spawned]) return SendClientMessage(playerid, COLOR_GREY, "Ta osoba nie jest zespawnowana.");
	
	if(giveplayerid == playerid) return SendClientMessage(playerid, COLOR_GREY, "Nie mo¿esz skuæ samego siebie.");
	
	
	GetPlayerPos(playerid, x, y, z);
	
	if(GetPlayerDistanceFromPoint(giveplayerid, x, y, z) > 5.0) return SendClientMessage(playerid, COLOR_GREY, "Ta osoba jest zbyt daleko od Ciebie.");
	
	if(!IsPlayerHasItem(playerid, ITEM_CUFFS)) return SendClientMessage(playerid, COLOR_GREY, "Nie posiadasz odpowiedniego przedmiotu w swoim ekwipunku.");
	
	format(string, sizeof(string), "skuwa %s.", Player[giveplayerid][NameSpace]);
	ServerMe(playerid, string, 1);
	
	Player[giveplayerid][Cuffed] = true;
	SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(giveplayerid, 9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977,-81.700035, 0.891999, 1.000000, 1.168000);
	return 1;
}

































//end


CallBack:LoadGroupForPlayer(playerid)
{
	new query[256], uid = 1;
	format(query, sizeof(query), "SELECT "prefix"groups_members.group, "prefix"groups_members.rank, "prefix"groups.name, "prefix"groups.tag, "prefix"groups.color, "prefix"groups.chat FROM "prefix"groups_serverJOIN "prefix"groups_members ON "prefix"groups_members.group = "prefix"groups.id AND "prefix"groups_members.member = '%d'", Player[playerid][UID]);
	mysql_query(query);
	mysql_store_result();
	
	while(mysql_fetch_row_format(query))
	{
		sscanf(query, "p<|>dds[32]s[10]s[10]d",
	    Group[playerid][uid][gUID],
		Group[playerid][uid][gMemberRank],
		Group[playerid][uid][gName],
		Group[playerid][uid][gTag],
		Group[playerid][uid][gColor],
		Group[playerid][uid][gChat]);
		
		uid++;
	}
	mysql_free_result();
   	return 1;
}

CallBack:RemoveMemberFromGrup(playerid, group)
{
	new query[128];
	format(query, sizeof(query), "DELETE  FROM "prefix"groups_members WHERE `member` = '%d' AND `group` = '%d'", Player[playerid][UID], group);
	mysql_query(query);
   	return 1;
}

CallBack:ChatGroupsON(playerid, slot, chat[])
{
	new result, string[128];
	if(!strcmp(chat, "on", true))
	{
		result = 1;
		foreach(new i : Player)
		{
			for(new id = 1; id < MAX_GROUPS; id++)
			{
				if(Group[i][id][gUID] == Group[playerid][slot][gUID])
				{
					format(string, sizeof(string), "Czat ooc grupy %s[$%d] zosta³ w³¹czony przez %s(%d).", Group[i][id][gName], id, Player[playerid][NameSpace], playerid);
					SendClientMessage(i, COLOR_GRAD1, string);
				}
				
			}	
		}
	}
	else if(!strcmp(chat, "off", true))
	{
		result = 0;
		foreach(new i : Player)
		{
			for(new id = 1; id < MAX_GROUPS; id++)
			{
				if(Group[i][id][gUID] == Group[playerid][slot][gUID])
				{
					format(string, sizeof(string), "{%s}Czat ooc grupy %s[$%d] zosta³ wy³¹czony przez %s(%d).", Group[playerid][slot][gColor], Group[playerid][slot][gName], id, Player[playerid][NameSpace], playerid);
					SendClientMessage(i, COLOR_GRAD1, string);
				}
			}	
		}
	}
	new query[128];
	format(query, sizeof(query), "UPDATE "prefix"groups_serverSET `chat` = '%d' WHERE `id` = '%d'", result, Group[playerid][slot][gUID]);
	mysql_query(query);
	return 1;
}

CallBack:GiveRank(playerid, group, rank)
{
	new query[128];
	format(query, sizeof(query), "UPDATE "prefix"groups_members SET `rank` = '%d' WHERE `member` = '%d' AND `group` = '%d'", rank, Player[playerid][UID], group);
	mysql_query(query);
   	return 1;
}

CallBack:InviteMember(playerid, group)
{
	new query[128];
	format(query, sizeof(query), "INSERT INTO "prefix"groups_members (`member`, `group`) VALUES ('%d', '%d')", Player[playerid][UID], group);
	mysql_query(query);
	return 1;
}

CallBack:ChatGroups(playerid, params[])
{
	new string[128], start, end;
	new slot = strval(params[1]);
	
	if(!Group[playerid][slot][gUID])
			return GameTextForPlayer(playerid, "~r~Niepoprawny slot grupy!", 3000, 3);
			
	strdel(params, 0, 2);
	DeleteFreeSpace(params, start, end);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			for(new id = 1; id < MAX_GROUPS; id++)
			{	
				if(Group[i][id][gUID] == Group[playerid][slot][gUID]) 
				{
					//format(string, sizeof(string), "{%s}[$%d, %s]: ((%s[%d]: %s))", Group[playerid][slot][gColor], id, Group[playerid][slot][gTag], Player[playerid][Name], playerid, params);
					//SendClientMessage(i, COLOR_GRAD1, string); 
					
					if(strlen(params) > SPLIT_TEXT_LIMIT)
					{
						new stext[128];

						strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
						format(string, sizeof(string), "{%s}[$%d, %s]: ((%s[%d]: %s...", Group[playerid][slot][gColor], id, Group[playerid][slot][gTag], Player[playerid][Name], playerid,  stext);
						SendClientMessage(i, COLOR_GRAD1, string); 

						strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
						format(string, sizeof(string), "{%s}[$%d, %s]: ((%s[%d]: ...%s))", Group[playerid][slot][gColor], id, Group[playerid][slot][gTag], Player[playerid][Name], playerid, stext);
						SendClientMessage(i, COLOR_GRAD1, string); 
					}
					else
					{
						format(string, sizeof(string), "{%s}[$%d, %s]: ((%s[%d]: %s))", Group[playerid][slot][gColor], id, Group[playerid][slot][gTag], Player[playerid][Name], playerid, params);
						SendClientMessage(i, COLOR_GRAD1, string); 
					}
				}
			}
		}
	}	
	return 1;
}

stock ReLoadGroupForPlayer(playerid)
{
	for(new i; i != MAX_GROUPS; i++)
	{
		for(new gGroup:j; j != gGroup; j++) Group[playerid][i][j] = 0;
	}
		
	LoadGroupForPlayer(playerid);
}

stock IsPlayerGroup(playerid, uid)
{
   for(new id; id != MAX_GROUPS; id++)
   {
       if(Group[playerid][id][gUID] == uid)
           return id;
   }
   return 0;
}

stock GetFreeSlot(playerid)
{
	for(new id = 1; id != MAX_GROUPS; id++)
	{
		if(Group[playerid][id][gUID] == 0)
		return id;
	}
	return -1;
}

stock DeleteFreeSpace(string[], &start, &end) 
{
    new count_space;
    for (new i, j = strlen (string); i < j; i++) 
	{
        if (string[i] == 0x20 && string[i + 1] < 0x30) count_space++;
    }
    strdel(string, start, end + count_space + 1);
    return string;
}



