/**
 *	(C) 2013, Pamdex aka Pamir
 *		PStreamer Object Plugin on SA:MP
 *
 *
 *				 Edited by AXV (added hooking).
 *
 *	All rights reserved.
 * ------------------------------------------- */
 
#if defined _included_pstreamer_
  #endinput
#else
	#define _included_pstreamer_
#endif

#pragma library "PStreamer"

// debug hooking
#define DEBUG_MODE_HOOKING 	false

// Native(s) main
native PStreamer_Init(mode = 0);
native PStreamer_Exit();
native PStreamer_TickRate(rate = 100);
native PStreamer_CountStreamObject();

// Native(s) per player
native PStreamer_PlayerInit(playerid);
native PStreamer_PlayerExit(playerid);
native PStreamer_OnPlayerEditObject(playerid, playerobject, object, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
native CreatePlayerStreamObject(playerid, PSobject, Float:x, Float:y, Float:z, Float:xrot, Float:yrot, Float:zrot, Float:distance = 300.000, interior = 0, virtualworld = 0);
native EditStreamObject(playerid, PSobject);
native IsObjectStreamedForPlayer(playerid, PSobject);

// Native(s) per vehicle
native AttachStreamObjectToVehicle(PSobject, vehicleid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ);

// Native(s) per objects
native CreateStreamObject(PSobject, Float:x, Float:y, Float:z, Float:xrot, Float:yrot, Float:zrot, Float:distance = 300.000, interior = 0, virtualworld = 0);
native DestroyStreamObject(PSobject);
native StopStreamObject(PSobject); 
native GetStreamObjectRot(PSobject, &Float:x, &Float:y, &Float:z);
native GetStreamObjectPos(PSobject, &Float:x, &Float:y, &Float:z);
native SetStreamObjectRot(PSobject, Float:x, Float:y, Float:z);
native SetStreamObjectPos(PSobject, Float:x, Float:y, Float:z);
native MoveStreamObject(PSobject, Float:posx, Float:posy, Float:posz, Float:speed, Float:rotx = -1000.0, Float:roty = -1000.0, Float:rotz = -1000.0);
native SetStreamObjectMaterial(PSobject, materialindex, modelid, txdname[], texturename[], materialcolor);   
native SetStreamObjectMaterialText(PSobject,text[],materialindex = 0, materialsize = OBJECT_MATERIAL_SIZE_256x128, fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0);

// Callbacks
forward public OnStreamObjectMoved(objectid);        
forward public OnStreamObjectStreamIn(objectid, forplayerid);   
forward public OnStreamObjectStreamOut(objectid, forplayerid);      
forward public OnStreamObjectEdited(playerid, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);  
forward public PStreamer_InvokeFunction();

// ALS Hooking
static stock
	pstreamer_INIT = 0xFFFFFFFF,
	pstreamer_EXIT,
	pstreamer_OPC,
	pstreamer_OPD,
	pstreamer_OPEO
;

public 
	OnFilterScriptInit()
	{
		#if DEBUG_MODE_HOOKING == true
			printf("OnFilterScriptInit hook");
		#endif
		
		PStreamer_Init(0);
		pstreamer_INIT = funcidx("PSTREAMER_OnGameModeInit") != -1;
		pstreamer_EXIT = funcidx("PSTREAMER_OnGameModeExit") != -1;
		pstreamer_OPC = funcidx("PSTREAMER_OnPlayerConnect") != -1;
		pstreamer_OPD = funcidx("PSTREAMER_OnPlayerDisconnect") != -1;
		pstreamer_OPEO = funcidx("PSTREAMER_OnPlayerEditObject") != -1;
		
		return CallLocalFunction("PSTREAMER_OnFilterScriptInit", "");
	}
	
#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit PSTREAMER_OnFilterScriptInit

forward OnFilterScriptInit();

public 
	OnFilterScriptExit()
	{
		#if DEBUG_MODE_HOOKING == true
			printf("OnFilterScriptExit hook");
		#endif
		return CallLocalFunction("PSTREAMER_OnFilterScriptExit", "");
	}

#if defined _ALS_OnFilterScriptExit
	#undef OnFilterScriptExit
#else
	#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit PSTREAMER_OnFilterScriptExit

forward OnFilterScriptExit();


public 
	OnPlayerConnect(playerid) 
	{
		#if DEBUG_MODE_HOOKING == true
			printf("OnPlayerConnect(%d) hook", playerid);
		#endif
		
		PStreamer_PlayerInit(playerid);
		if (pstreamer_OPC)
			return CallLocalFunction("PSTREAMER_OnPlayerConnect", "d", playerid);
			
		return 1;
	}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect PSTREAMER_OnPlayerConnect

forward OnPlayerConnect(playerid);

public 
	OnPlayerDisconnect(playerid, reason) 
	{
		#if DEBUG_MODE_HOOKING == true
			printf("OnPlayerDisconnect(%d, %d) hook", playerid, reason);
		#endif
		
		PStreamer_PlayerExit(playerid);
		if (pstreamer_OPD)
			return CallLocalFunction("PSTREAMER_OnPlayerDisconnect", "dd", playerid, reason);
			
		return 1;
	}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect PSTREAMER_OnPlayerDisconnect

forward OnPlayerDisconnect(playerid, reason);

public 
	OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
	{
		#if DEBUG_MODE_HOOKING == true
			printf("OnPlayerEditObject(%d, %d, %d, %d, %.0f, %.0f, %.0f, %.0f, %.0f, %.0f) hook", playerid, playerobject, objectid, response, fX, fY, fZ, fRotX, fRotY, fRotZ);
		#endif
		
		PStreamer_OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
		if (pstreamer_OPEO)
			return CallLocalFunction("PSTREAMER_OnPlayerEditObject", "ddddffffff", 
						playerid, playerobject, objectid, response,
						fX, fY, fZ, fRotX, fRotY, fRotZ
					);
			
		return 1;
	}

#if defined _ALS_OnPlayerEditObject
	#undef OnPlayerEditObject
#else
	#define _ALS_OnPlayerEditObject
#endif
#define OnPlayerEditObject PSTREAMER_OnPlayerEditObject

forward OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
	
public 	
	OnGameModeInit() 
	{
		if (pstreamer_INIT == -1) 
		{
			printf("PStreamer GameMode Hook...");
			PStreamer_Init(1);
			pstreamer_INIT = funcidx("PSTREAMER_OnGameModeInit") != -1;
			pstreamer_EXIT = funcidx("PSTREAMER_OnGameModeExit") != -1;
			pstreamer_OPC = funcidx("PSTREAMER_OnPlayerConnect") != -1;
			pstreamer_OPD = funcidx("PSTREAMER_OnPlayerDisconnect") != -1;
			pstreamer_OPEO = funcidx("PSTREAMER_OnPlayerEditObject") != -1;
		}
		
		if (pstreamer_INIT)
			return CallLocalFunction("PSTREAMER_OnGameModeInit", "");
			
		return 1;
	}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit PSTREAMER_OnGameModeInit

forward OnGameModeInit();

public 
	OnGameModeExit() 
	{
		PStreamer_Exit();
		
		if (pstreamer_EXIT)
			return CallLocalFunction("PSTREAMER_OnGameModeExit", "");
			
		return 1;
	}

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit PSTREAMER_OnGameModeExit

forward OnGameModeExit();

public 
	PStreamer_InvokeFunction()
	{
		new 
			Float:fVar
		;
		GetMaxPlayers();
		GetPlayerPos(0, fVar, fVar, fVar);
		GetPlayerFacingAngle(0, fVar);
		GetPlayerInterior(0);
		GetPlayerState(0);
		IsPlayerConnected(0);
		IsPlayerInVehicle(0,0);
		IsPlayerInAnyVehicle(0);
		GetPlayerVirtualWorld(0);
		GetVehiclePos(0, fVar, fVar, fVar);
		GetVehicleZAngle(0, fVar);
		CreatePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		SetPlayerObjectPos(0, 0, 0.0, 0.0, 0.0);
		GetPlayerObjectPos(0, 0, fVar, fVar, fVar);
		GetPlayerObjectRot(0, 0, fVar, fVar, fVar);
		SetPlayerObjectRot(0, 0, 0.0, 0.0, 0.0);
		IsValidPlayerObject(0, 0);
		DestroyPlayerObject(0, 0);
		MovePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		StopPlayerObject(0, 0);
		SetPlayerObjectMaterial(0, 0, 0, 0, "", "", 0);
		EditPlayerObject(0, 0);
		SetPlayerObjectMaterialText(0, 0, "", 0, 0, "", 0, 0, 0, 0, 0);
		AttachPlayerObjectToVehicle(0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		return 1;
	}