//	modules/variables.pwn

new yesorno[2][5] = {"Nie", "Tak"};

enum sSettings 
{
	Float:Spawn[4],
	SpawnVw,
 	SpawnInt
 
};

new Settings[sSettings];

enum pInfo
{
	Name[MAX_PLAYER_NAME],
	NameSpace[MAX_PLAYER_NAME],
	UID,
	GlobalName[32],
	GUID,
	Salt[12],
	Text3D:Nick,
	Cash,
	Admin,
	Skin,
	Float:HP,
	Age,
	Float:Weight,
	Growth,
	Logged,
	VehSpawned,
	CheckPoint,
	Door,
	AutomaticGun,
	BW,
	BWTime,
	PhaseBW,
	Float:posX,
	Float:posY,
	Float:posZ,
	VW,
	Interior,
	bool:Spawned,
	
	//weapon skill
	Float:Skill_First,	Float:Skill_Second,		Float:Skill_Third,		Float:Skill_Additional, 	
	Float:Skill_Rifle,	Float:Skill_Shotgun,	Float:Skill_Sniper,		Float:Skill_Machine_Pistol,
	Float:Skill_Pistol,	Float:Skill_Revolver,
	
	InVehicle,
	bool:Cuffed
	
};

new Player[MAX_PLAYERS][pInfo];
//new InPlayerVehicles[MAX_VEHICLES];
//WEAPON SYSTEM
new Gun[MAX_PLAYERS][GUN_LIMIT][3];
new wepp[MAX_PLAYERS] = -1, weps[12];

new Main_Timer, Main_Min_Timer/*, test*/;
new PlayerText:drzwitd[MAX_PLAYERS], Text:EngineVehicles, Text:RedRadar, Text:OverallSpeedCounter[8], PlayerText:SpeedCounter[5][MAX_PLAYERS];
new TworzenieDrzwi[MAX_PLAYERS] = false;
