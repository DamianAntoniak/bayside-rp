
stock CreateTextDraws()
{
	EngineVehicles = TextDrawCreate(499.000000, 105.000000, "Aby wlaczyc silnik~n~uzyj ~r~L.Ctrl + L.Alt");
	TextDrawBackgroundColor(EngineVehicles, 255);
	TextDrawFont(EngineVehicles, 1);
	TextDrawLetterSize(EngineVehicles, 0.350000, 1.100000);
	TextDrawColor(EngineVehicles, -1);
	TextDrawSetOutline(EngineVehicles, 0);
	TextDrawSetProportional(EngineVehicles, 1);
	TextDrawSetShadow(EngineVehicles, 1);
	TextDrawUseBox(EngineVehicles, 1);
	TextDrawBoxColor(EngineVehicles, 101);
	TextDrawTextSize(EngineVehicles, 606.000000, 0.000000);
	
	RedRadar = TextDrawCreate(18.000000, 326.000000, "LD_BEAT:chit");
	TextDrawBackgroundColor(RedRadar, 255);
	TextDrawFont(RedRadar, 4);
	TextDrawLetterSize(RedRadar, 0.500000, 1.000000);
	TextDrawColor(RedRadar, 0xFF000066);
	TextDrawSetOutline(RedRadar, 0);
	TextDrawSetProportional(RedRadar, 1);
	TextDrawSetShadow(RedRadar, 1);
	TextDrawUseBox(RedRadar, 1);
	TextDrawBoxColor(RedRadar, 0xFF000066);
	TextDrawTextSize(RedRadar, 138.000000, 113.000000);
	
	OverallSpeedCounter[0] = TextDrawCreate(593.000000, 341.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(OverallSpeedCounter[0], 255);
	TextDrawFont(OverallSpeedCounter[0], 1);
	TextDrawLetterSize(OverallSpeedCounter[0], 0.449999, 1.200000);
	TextDrawColor(OverallSpeedCounter[0], -1);
	TextDrawSetOutline(OverallSpeedCounter[0], 0);
	TextDrawSetProportional(OverallSpeedCounter[0], 1);
	TextDrawSetShadow(OverallSpeedCounter[0], 1);
	TextDrawUseBox(OverallSpeedCounter[0], 1);
	TextDrawBoxColor(OverallSpeedCounter[0], 64);
	TextDrawTextSize(OverallSpeedCounter[0], 608.000000, 0.000000);

	OverallSpeedCounter[1] = TextDrawCreate(594.000000, 342.000000, "~n~");
	TextDrawBackgroundColor(OverallSpeedCounter[1], 255);
	TextDrawFont(OverallSpeedCounter[1], 1);
	TextDrawLetterSize(OverallSpeedCounter[1], 0.519999, 7.000000);
	TextDrawColor(OverallSpeedCounter[1], -1);
	TextDrawSetOutline(OverallSpeedCounter[1], 0);
	TextDrawSetProportional(OverallSpeedCounter[1], 1);
	TextDrawSetShadow(OverallSpeedCounter[1], 1);
	TextDrawUseBox(OverallSpeedCounter[1], 1);
	TextDrawBoxColor(OverallSpeedCounter[1], -7012272);
	TextDrawTextSize(OverallSpeedCounter[1], 607.000000, 1.000000);

	OverallSpeedCounter[2] = TextDrawCreate(542.000000, 355.000000, "~n~~n~~n~");
	TextDrawBackgroundColor(OverallSpeedCounter[2], 255);
	TextDrawFont(OverallSpeedCounter[2], 1);
	TextDrawLetterSize(OverallSpeedCounter[2], 0.500000, 1.299999);
	TextDrawColor(OverallSpeedCounter[2], -1);
	TextDrawSetOutline(OverallSpeedCounter[2], 0);
	TextDrawSetProportional(OverallSpeedCounter[2], 1);
	TextDrawSetShadow(OverallSpeedCounter[2], 1);
	TextDrawUseBox(OverallSpeedCounter[2], 1);
	TextDrawBoxColor(OverallSpeedCounter[2], 80);
	TextDrawTextSize(OverallSpeedCounter[2], 589.000000, -2.000000);

	OverallSpeedCounter[3] = TextDrawCreate(542.000000, 341.000000, "~n~");
	TextDrawBackgroundColor(OverallSpeedCounter[3], 255);
	TextDrawFont(OverallSpeedCounter[3], 1);
	TextDrawLetterSize(OverallSpeedCounter[3], 0.500000, 1.000000);
	TextDrawColor(OverallSpeedCounter[3], -1);
	TextDrawSetOutline(OverallSpeedCounter[3], 0);
	TextDrawSetProportional(OverallSpeedCounter[3], 1);
	TextDrawSetShadow(OverallSpeedCounter[3], 1);
	TextDrawUseBox(OverallSpeedCounter[3], 1);
	TextDrawBoxColor(OverallSpeedCounter[3], 80);
	TextDrawTextSize(OverallSpeedCounter[3], 589.000000, -2.000000);

	OverallSpeedCounter[4] = TextDrawCreate(542.000000, 395.000000, "~n~");
	TextDrawBackgroundColor(OverallSpeedCounter[4], 255);
	TextDrawFont(OverallSpeedCounter[4], 1);
	TextDrawLetterSize(OverallSpeedCounter[4], 0.500000, 1.100000);
	TextDrawColor(OverallSpeedCounter[4], -1);
	TextDrawSetOutline(OverallSpeedCounter[4], 0);
	TextDrawSetProportional(OverallSpeedCounter[4], 1);
	TextDrawSetShadow(OverallSpeedCounter[4], 1);
	TextDrawUseBox(OverallSpeedCounter[4], 1);
	TextDrawBoxColor(OverallSpeedCounter[4], 80);
	TextDrawTextSize(OverallSpeedCounter[4], 589.000000, -2.000000);

	OverallSpeedCounter[5] = TextDrawCreate(557.000000, 380.000000, "km/h");
	TextDrawBackgroundColor(OverallSpeedCounter[5], 255);
	TextDrawFont(OverallSpeedCounter[5], 1);
	TextDrawLetterSize(OverallSpeedCounter[5], 0.239999, 1.000000);
	TextDrawColor(OverallSpeedCounter[5], 96);
	TextDrawSetOutline(OverallSpeedCounter[5], 0);
	TextDrawSetProportional(OverallSpeedCounter[5], 1);
	TextDrawSetShadow(OverallSpeedCounter[5], 0);

	OverallSpeedCounter[6] = TextDrawCreate(594.000000, 399.000000, "gallons");
	TextDrawBackgroundColor(OverallSpeedCounter[6], 255);
	TextDrawFont(OverallSpeedCounter[6], 1);
	TextDrawLetterSize(OverallSpeedCounter[6], 0.119999, 0.699999);
	TextDrawColor(OverallSpeedCounter[6], 80);
	TextDrawSetOutline(OverallSpeedCounter[6], 0);
	TextDrawSetProportional(OverallSpeedCounter[6], 1);
	TextDrawSetShadow(OverallSpeedCounter[6], 0);

	OverallSpeedCounter[7] = TextDrawCreate(579.000000, 395.000000, "km");
	TextDrawBackgroundColor(OverallSpeedCounter[7], 255);
	TextDrawFont(OverallSpeedCounter[7], 1);
	TextDrawLetterSize(OverallSpeedCounter[7], 0.180000, 1.000000);
	TextDrawColor(OverallSpeedCounter[7], 96);
	TextDrawSetOutline(OverallSpeedCounter[7], 0);
	TextDrawSetProportional(OverallSpeedCounter[7], 1);
	TextDrawSetShadow(OverallSpeedCounter[7], 0);
	
}

stock CreatePlayerTextDrawns(playerid)
{
	
	SpeedCounter[0][playerid] = CreatePlayerTextDraw(playerid, 594.000000, 408.000000, "~n~~n~~n~~n~");//fuel++++
	PlayerTextDrawBackgroundColor(playerid, SpeedCounter[0][playerid], 255);
	PlayerTextDrawFont(playerid, SpeedCounter[0][playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedCounter[0][playerid], 0.519999, -0.299999);
	PlayerTextDrawColor(playerid, SpeedCounter[0][playerid], -1);
	PlayerTextDrawSetOutline(playerid, SpeedCounter[0][playerid], 0);
	PlayerTextDrawSetProportional(playerid, SpeedCounter[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, SpeedCounter[0][playerid], 1);
	PlayerTextDrawUseBox(playerid, SpeedCounter[0][playerid], 1);
	PlayerTextDrawBoxColor(playerid, SpeedCounter[0][playerid], -7012272);
	PlayerTextDrawTextSize(playerid, SpeedCounter[0][playerid], 607.000000, 1.000000);

	SpeedCounter[1][playerid] = CreatePlayerTextDraw(playerid, 594.000000, 369.000000, " ");//48.7
	PlayerTextDrawBackgroundColor(playerid, SpeedCounter[1][playerid], 255);
	PlayerTextDrawFont(playerid, SpeedCounter[1][playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedCounter[1][playerid], 0.170000, 0.800000);
	PlayerTextDrawColor(playerid, SpeedCounter[1][playerid], 80);
	PlayerTextDrawSetOutline(playerid, SpeedCounter[1][playerid], 0);	
	PlayerTextDrawSetProportional(playerid, SpeedCounter[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid, SpeedCounter[1][playerid], 0);

	SpeedCounter[2][playerid] = CreatePlayerTextDraw(playerid, 549.000000, 340.000000, " ");//Infernus
	PlayerTextDrawBackgroundColor(playerid, SpeedCounter[2][playerid], 255);
	PlayerTextDrawFont(playerid, SpeedCounter[2][playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedCounter[2][playerid], 0.239999, 1.000000);
	PlayerTextDrawColor(playerid, SpeedCounter[2][playerid], -1);
	PlayerTextDrawSetOutline(playerid, SpeedCounter[2][playerid], 0);
	PlayerTextDrawSetProportional(playerid, SpeedCounter[2][playerid], 1);
	PlayerTextDrawSetShadow(playerid, SpeedCounter[2][playerid], 1);

	SpeedCounter[3][playerid] = CreatePlayerTextDraw(playerid, 549.000000, 357.000000, " ");//196
	PlayerTextDrawBackgroundColor(playerid, SpeedCounter[3][playerid], 255);
	PlayerTextDrawFont(playerid, SpeedCounter[3][playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedCounter[3][playerid], 0.569998, 2.699999);
	PlayerTextDrawColor(playerid, SpeedCounter[3][playerid], -1);
	PlayerTextDrawSetOutline(playerid, SpeedCounter[3][playerid], 1);
	PlayerTextDrawSetProportional(playerid, SpeedCounter[3][playerid], 1);

	SpeedCounter[4][playerid] = CreatePlayerTextDraw(playerid, 553.000000, 395.000000, " ");//~r~2345.987
	PlayerTextDrawBackgroundColor(playerid, SpeedCounter[4][playerid], 255);
	PlayerTextDrawFont(playerid, SpeedCounter[4][playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedCounter[4][playerid], 0.149998, 1.000000);
	PlayerTextDrawColor(playerid, SpeedCounter[4][playerid], 128);
	PlayerTextDrawSetOutline(playerid, SpeedCounter[4][playerid], 0);
	PlayerTextDrawSetProportional(playerid, SpeedCounter[4][playerid], 1);
	PlayerTextDrawSetShadow(playerid, SpeedCounter[4][playerid], 0);
	
}