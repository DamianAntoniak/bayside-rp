// modules/commands_player.pwn

/*AVAILABLE COMMANDS: 
1. b;
2. l, local;
3. s, c, szept, cicho;
4. k, krzyk;
5. me, ja;
6. do;
7. sprobuj;

@Wax: wszystkie wyœwietlenia w konsoli s¹ tylko jako debug i zostan¹³ zast¹pione logami.

*/

CMD:b(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /b [wiadomoœæ]");
	
	new string[128];
	
	ucfirst(params);
	
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];
	 	
		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "[ID:%d] %s: (( %s... ))", playerid, Player[playerid][NameSpace], stext);
		SendClientMessageEx(11.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "[ID:%d] %s: (( ...%s ))", playerid, Player[playerid][NameSpace], stext);
		SendClientMessageEx(11.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
		format(string, sizeof(string), "[ID:%d] %s: (( %s ))", playerid, Player[playerid][NameSpace], params);
		SendClientMessageEx(11.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}

	printf("[ID:%d] %s: (( %s ))", playerid, Player[playerid][Name], params);
	return 1;
}

CMD:l(playerid, params[]) return cmd_local(playerid, params);

CMD:local(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /l(ocal) [Wiadomoœæ]");
	
	new string[128];
	
	ucfirst(params);
	capitalize(params);
	
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];

		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "%s mówi: %s...", Player[playerid][NameSpace], stext);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "%s mówi: ...%s", Player[playerid][NameSpace], stext);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
		format(string, sizeof(string), "%s mówi: %s", Player[playerid][NameSpace], params);
		SendClientMessageEx(6.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	printf("%s mówi: %s.", Player[playerid][Name], params);
	return 1;
}

CMD:s(playerid, params[]) return cmd_szept(playerid, params);
CMD:c(playerid, params[]) return cmd_szept(playerid, params);
CMD:cicho(playerid, params[]) return cmd_szept(playerid, params);

CMD:szept(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /s(zept) [Wiadomoœæ]");
	
	new string[128];
	
	ucfirst(params);
	capitalize(params);
	
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];

		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "%s szepcze: %s...", Player[playerid][NameSpace], stext);
		SendClientMessageEx(4.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "%s szepcze: ...%s", Player[playerid][NameSpace], stext);
		SendClientMessageEx(4.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
		format(string, sizeof(string), "%s szepcze: %s", Player[playerid][NameSpace], params);
		SendClientMessageEx(4.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	printf("%s szepcze: %s.", Player[playerid][Name], params);
	return 1;
}

CMD:k(playerid, params[]) return cmd_krzyk(playerid, params);

CMD:krzyk(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /k(rzyk) [Wiadomoœæ]");
	
	new string[128];
	
	ucfirst(params);
	capitalize(params);
	
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];

		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "%s krzyczy: %s...", Player[playerid][NameSpace], stext);
		SendClientMessageEx(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "%s krzyczy: ...%s!!", Player[playerid][NameSpace], stext);
		SendClientMessageEx(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
	}
	else
	{
		format(string, sizeof(string), "%s krzyczy: %s!!", Player[playerid][NameSpace], params);
		SendClientMessageEx(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
	}
	printf("%s krzyczy: %s!!", Player[playerid][Name], params);
	return 1;
}

CMD:ja(playerid, params[]) return cmd_me(playerid, params);

CMD:me(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /me [akcja]");
	
	ServerMe(playerid, params, 1);
	
	printf("[ME]* %s %s", Player[playerid][Name], params);
	return 1;
}

CMD:ame(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /ame [akcja]");
	
	new string[128];
	//format(string, sizeof(string), "** %s %s."
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];
		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "** %s %s...", Player[playerid][NameSpace], stext);
		SendClientMessage(playerid, COLOR_PURPLE, string);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "** ...%s ((%s))", stext, Player[playerid][NameSpace]);
		SendClientMessage(playerid, COLOR_PURPLE, string);
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.0, 4000);
	}
	else
	{
		format(string, sizeof(string), "** %s %s", params, Player[playerid][NameSpace]);
		SendClientMessage(playerid, COLOR_PURPLE, string);
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.0, 4000);
	}
	printf("[AME]* %s %s", Player[playerid][Name], params);
	return 1;
}

CMD:sprobuj(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /sprobuj [Akcja].");

	switch(random(4)+1)
	{
		case 1: format(params, 128, "*** %s spróbowa³ %s i uda³o mu siê.", Player[playerid][NameSpace], params);
		case 2: format(params, 128, "*** %s spróbowa³ %s i nie uda³o mu siê.", Player[playerid][NameSpace], params);
		case 3: format(params, 128, "*** %s spróbowa³ %s i nie uda³o mu siê.", Player[playerid][NameSpace], params);
		case 4: format(params, 128, "*** %s spróbowa³ %s i uda³o mu siê.", Player[playerid][NameSpace], params);
	}
	SendClientMessageEx(10.0, playerid, params, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "U¯YJ: /do [Akcja].");
	
	new string[128];
	
	if(strlen(params) > SPLIT_TEXT_LIMIT)
	{
		new stext[128];

		strmid(stext, params, SPLIT_TEXT1_FROM, SPLIT_TEXT1_TO, 255);
		format(string, sizeof(string), "* %s... ((%s))", stext, Player[playerid][NameSpace]);
		SendClientMessageEx(10.0, playerid, string, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE);

		strmid(stext, params, SPLIT_TEXT2_FROM, SPLIT_TEXT2_TO, 255);
		format(string, sizeof(string), "* ...%s ((%s))", stext, Player[playerid][NameSpace]);
		SendClientMessageEx(10.0, playerid, string, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE);
	}
	else
	{
		format(string, sizeof(string), "* %s ((%s))", params, Player[playerid][NameSpace]);
		SendClientMessageEx(10.0, playerid, string, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE, COLOR_DO_BLUE);
	}
	
	printf("[DO]* %s %s", Player[playerid][Name], params);
	return 1;
}

/*CMD:info(playerid, params[])
{
	
	return 1;
}*/
