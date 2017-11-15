#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <a_mysql>
#include <dini>

#if defined FILTERSCRIPT

#define MAX_USERS 50

#define B_COLOR 0x0080D1FF

//MySQL
#define DB_HOST 	"host"
#define DB_USER 	"user"
#define DB_DATABASE "bilard_database"
#define DB_PASSWORD "password"

//Dini
#define DATABASE_PATH "Bilard"

#define MAX_BILARDS 25
#define MAX_BALLS 16
#define MAX_POINT 12

#define BALL_NONE 0
#define BALL_FULL 1
#define BALL_HALF 2
#define BALL_WHITE 14
#define BALL_BLACK 15

#define SPEED_NO_CHANGE 0

#define DIST_TABLE_Z 0.9333

#define FACTOR_COLL_TABLE 0.8 //wspolczynnik utraty predkosci po odbiciu bili od bandy
#define FACTOR_COLL_BALL  0.7 //wspolczynnik utraty predkosci po odbiciu bil
#define FACTOR_LOSS_SPEED 0.78 //wspolczynnik utraty predkosci podczas toczenia sie bili

#define BILARD_LIMIT_END -1 //skonczyl sie limit bilardow
#define BILARD_NO_SPACE  -2 //w poblizu znajduje sie jakis bilard, nastepny stol nalezy stworzyc troche dalej

#define MAX_DIRECTION_CUE 16

//definicje dotyczace kija bilardowego (predkosci uderzania)
#define DEFAULT_CUE_SPEED 1
#define MIN_CUE_SPEED     0.1
#define MAX_CUE_SPEED     1.5

#define STR_AWAITING_FOR_PLAYER "Brak gracza"

enum EnumBilard
{
	bool:created,
	bool:running,
	bool:movingballs,
	bool:importantball,
	virtualWorld,
	lastBall,
	objID,
	Float:bX,
	Float:bY,
	Float:bZ,
	Float:bA,
	User_1,
	User_2
};

enum EnumBall
{
	bool:enabled,
	objID,
	touchID,
	Float:destX,
	Float:destY,
	Float:pA,
	Float:speed
};

new Symbol[3][] =
{
	{"NULL"},
	{"(0)"},
	{"(-)"}
};

enum EnumPoint
{
	Float:hX,
	Float:hY,
};

enum EnumPlayer
{
	bool:joined,
	bool:sighting,
	bool:turn,
	Float:pA,
	direction,
	bilardID,
	balltype,
	points,
	uPoints,
	Float:speedCue,
	Text:box,
	Text:speedBox
};

enum EnumCueDirect
{
	DIRECTION_LEFT,
	DIRECTION_RIGHT
};

enum EnumCueSpeed
{
	SPEED_MORE,
	SPEED_LESS
};

new Bilard[MAX_BILARDS][EnumBilard];
new Ball[MAX_BILARDS][MAX_BALLS][EnumBall];
new Point[MAX_BILARDS][MAX_POINT][EnumPoint];
new User[MAX_USERS][EnumPlayer];

forward bool:IsBilardExists(bilardid);
forward bool:IsBilardRunning(bilardid);
forward bool:IsBallEnabled(bilardid, bid);
forward bool:AreBallsMoving(bilardid);
forward bool:AreBallsStoped(bilardid);
forward bool:IsPlayerInAnyBilard(playerid);
forward bool:IsSighting(playerid);
forward bool:IsTurn(playerid);
forward bool:CanJoinToBilard(bilardid, playerid, &slot);
forward bool:CanDirectCue(playerid, EnumCueDirect:direct);
forward bool:CanChangeSpeedCue(playerid, EnumCueSpeed:cSpeed);
forward Float:GetBallSpeed(bilardid, bid);
forward GetPlayerBallType(playerid);

forward Float:GetDistance(Float:fx, Float:fy, Float:tx, Float:ty);
forward Float:GetDistance3D(Float:fx, Float:fy, Float:fz, Float:tx, Float:ty, Float:tz);
forward Float:GetVectorDistance_OB(obj, obj2);
forward Float:GetVectorDistance_PL(playerid, obj);
forward Float:GetVectorAngle(obj, obj2);
forward Float:GetVectorAngle_XY(Float:fx, Float:fy, Float:tx, Float:ty);
forward Float:FixAngle(Float:angle);

forward Bilard_Collision();
forward Bilard_Properties();

new collision_timer = -1;
new prop_timer      = -1;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Bilard filterscript v2");
	print("--------------------------------------\n");
	
	collision_timer = SetTimer("Bilard_Collision",50,1);
	prop_timer      = SetTimer("Bilard_Properties",500,1);
	
	ResetAllPlayers();
	
	//LoadBilard_INI();
	LoadBilard_MySQL();
	return 1;
}

public OnFilterScriptExit()
{
	//SaveBilard_INI();
	SaveBilard_MySQL();

	DestroyAllBilards();
	DestroyAllPlayersTextdraws();
	
	if(collision_timer != -1)
		KillTimer(collision_timer);
		
	if(prop_timer != -1)
		KillTimer(prop_timer);
		
	return 1;
}
#endif

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerInAnyBilard(playerid) == true)
		LeaveFromBilard(playerid);
		
	SaveBilard_MySQL();
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerInAnyBilard(playerid) == true)
		LeaveFromBilard(playerid);
		
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public Bilard_Collision()
{
	for(new i = 0; i < MAX_BILARDS; i++)
	{
	    if(IsBilardExists(i) == true)
	    {
	        for(new k = 0; k < MAX_BALLS; k++)
	        {
	            if(IsBallEnabled(i,k) == true)
	            {
	           	    if(GetBallSpeed(i,k) > 0.001)
	            	{
						for(new j = 0; j < MAX_POINT; j++)
    					{
        					if(j < MAX_POINT - 1) //j < 11
        					{
            					if(CheckCollision_Table(i,k,j,j + 1) == 1)
            					{
    		            			if(j == 0 || j == 2 || j == 4 || j == 6 || j == 8 || j == 10)
										PutBallInLeak(i,k);
									else
										RespondCollision_Table(i,k,j);

									break;
   			        			}
        					}
        					else
       						{
            					if(CheckCollision_Table(i,k,0,11) == 1)
									RespondCollision_Table(i,k,j);
        					}
						}
				
						//Balls collision
						for(new j = 0; j < MAX_BALLS; j++)
						{
						    if(IsBallEnabled(i,j) == true)
						    {
				    			if(CheckCollision_Ball(i,k,j) == 1)
				    	    		RespondCollision_Ball(i,k,j);
							}
						}
					}
				
					Ball[i][k][touchID] = -1;
				}
			}
			
			if(IsBilardRunning(i) == true)
			{
	    	    if(AreBallsMoving(i) == true)
	    	    {
	    	   	 	if(AreBallsStoped(i) == true)
		       	 	{
		       	 	    new buff[100];
		       	 	    
						Bilard[i][movingballs] = false;

						if(Bilard[i][importantball] == false) //jezeli wczesniej nie wpadla biala bila
						{
						    new eBall = GetLastBall(i);
						    
						    if(eBall != -1) //jesli jakas bila wpadla
						    {
								if(IsTurn(Bilard[i][User_1]) == true) //czy to kolejka gracza z pierwszego slotu
								{
							   		new bType = GetPlayerBallType(Bilard[i][User_1]);
							    	if(bType == BALL_FULL) //jesli gracza bile sa cale
							    	{
							        	if(eBall >= 7) //a ostatnia bila jaka wpadla byla polowka to zmieniamy kolej if(eBall >= 7 || eBall == -1)
							        	{
											User[Bilard[i][User_1]][turn] = false;
											User[Bilard[i][User_2]][turn] = true;
										
											format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_2]));
											GameTextForPlayer(Bilard[i][User_1],buff,5000,4);
											GameTextForPlayer(Bilard[i][User_2],"~g~Teraz twoja kolej!",5000,4);
							       		}
							    	}
							    	else if(bType == BALL_HALF) //jesli gracza bile sa polowki
							    	{
							        	if(eBall < 7) //a ostatnia bila jaka wpadla byla cala to zmieniamy kolej if(eBall < 7 || eBall == -1)
							        	{
											User[Bilard[i][User_1]][turn] = false;
											User[Bilard[i][User_2]][turn] = true;
										
											format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_2]));
											GameTextForPlayer(Bilard[i][User_1],buff,5000,4);
											GameTextForPlayer(Bilard[i][User_2],"~g~Teraz twoja kolej!",5000,4);
							       	 	}
							    	}
								}
								else //czy to kolejka gracza z drugiego slotu
								{
							    	new bType = GetPlayerBallType(Bilard[i][User_2]);
							    	if(bType == BALL_FULL) //jesli gracza bile sa cale
							    	{
							        	if(eBall >= 7) //a ostatnia bila jaka wpadla byla polowka to zmieniamy kolej if(eBall >= 7 || eBall == -1)
							        	{
											User[Bilard[i][User_1]][turn] = true;
											User[Bilard[i][User_2]][turn] = false;

											GameTextForPlayer(Bilard[i][User_1],"~g~Teraz twoja kolej!",5000,4);
										
											format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_1]));
											GameTextForPlayer(Bilard[i][User_2],buff,5000,4);
							        	}
							    	}
							    	else if(bType == BALL_HALF) //jesli gracza bile sa polowki
							    	{
							        	if(eBall < 7) //a ostatnia bila jaka wpadla byla cala to zmieniamy kolej if(eBall < 7 || eBall == -1)
							        	{
											User[Bilard[i][User_1]][turn] = true;
											User[Bilard[i][User_2]][turn] = false;

											GameTextForPlayer(Bilard[i][User_1],"~g~Teraz twoja kolej!",5000,4);
										
											format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_1]));
											GameTextForPlayer(Bilard[i][User_2],buff,5000,4);
							        	}
							    	}
								}
							}
							else //jezeli zadna bila nie wpadla, nastepuje zmiana kolejki
							{
							    if(IsTurn(Bilard[i][User_1]) == true)
								{
									format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_2]));
									GameTextForPlayer(Bilard[i][User_1],buff,5000,4);
									GameTextForPlayer(Bilard[i][User_2],"~g~Teraz twoja kolej!",5000,4);

									User[Bilard[i][User_1]][turn] = false;
									User[Bilard[i][User_2]][turn] = true;
								}
								else
								{
									GameTextForPlayer(Bilard[i][User_1],"~g~Teraz twoja kolej!",5000,4);
									
									format(buff,sizeof(buff),"~y~Teraz kolej %s.",GetName(Bilard[i][User_1]));
									GameTextForPlayer(Bilard[i][User_2],buff,5000,4);

									User[Bilard[i][User_1]][turn] = true;
									User[Bilard[i][User_2]][turn] = false;
								}
							}
						}
						else //jezeli wczesniej wpadla biala bila
						    Bilard[i][importantball] = false;
						    
                        Bilard[i][lastBall] = -1;
	        		}
	        	}
	        	else
	        	{
	            	if(AreBallsStoped(i) == false)
	            	    Bilard[i][movingballs] = true;
	        	}
	        }
		}
	}
}

public Bilard_Properties()
{
	for(new i = 0; i < MAX_BILARDS; i++)
	{
        if(IsBilardExists(i) == true)
	    {
	        for(new j = 0; j < MAX_BALLS; j++)
	        {
	            new Float:bSpeed = GetBallSpeed(i,j);
	        	if(bSpeed > 0.001)
	        	{
	        	    if(bSpeed > 0.1)
	        	    	bSpeed = bSpeed * FACTOR_LOSS_SPEED;
					else
					   	bSpeed = bSpeed * 0.2; //zmniejszenie o polowe powolnej predkosci
					   	
					SetBallSpeed(i,j,bSpeed);
	        	}
	        	else
	        	    StopBall(i,j);
	        }
	    }
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 128)
	{
	    if(IsPlayerInAnyBilard(playerid) == true)
	    {
	        new bilardid = GetPlayerBilard(playerid);
	        
			//Bilard[bilardid][running] = true;
			//User[playerid][turn] = true;
	        
	    	if(IsBilardRunning(bilardid) == true && IsSighting(playerid) == false && IsTurn(playerid) == true && AreBallsStoped(bilardid) == true)
	    	{
	        	new Float:dist = GetVectorDistance_PL(playerid,Ball[bilardid][BALL_WHITE][objID]);
	    		if(GetPlayerWeapon(playerid) == 7 && dist < 1.6)
	        	{
	        		new Float:pos[6];
	        		GetObjectPos(Ball[bilardid][BALL_WHITE][objID],pos[0],pos[1],pos[2]);
					GetPlayerPos(playerid,pos[3],pos[4],pos[5]);

					new Float:angle = GetVectorAngle_XY(pos[3],pos[4],pos[0],pos[1]);
					
					User[playerid][sighting] = true;

					if(0.9 <= dist && dist <= 1.2)
					{
				    	pos[3] += floatsin(-angle + 180,degrees) * 0.5; //0.3
				    	pos[4] += floatcos(-angle + 180,degrees) * 0.5; //0.3
					}
					else if(dist < 0.9)
					{
					    pos[3] += floatsin(-angle + 180,degrees) * 0.8; //0.6
					    pos[4] += floatcos(-angle + 180,degrees) * 0.8; //0.6
					}
					
					SetPlayerPos(playerid,pos[3],pos[4],pos[5]);
					SetPlayerFacingAngle(playerid,angle);

					User[playerid][direction] = 0;
    			    User[playerid][pA] = angle + 180;
					
					new Float:camPos[2];
					camPos[0] = pos[0];
					camPos[1] = pos[1];
					
					camPos[0] += floatsin(-User[playerid][pA],degrees) * 0.5;
					camPos[1] += floatcos(-User[playerid][pA],degrees) * 0.5;

					SetPlayerCameraPos(playerid,camPos[0],camPos[1],pos[2] + 0.3);
					SetPlayerCameraLookAt(playerid,pos[0],pos[1],pos[2] + 0.1);

			    	ApplyAnimation(playerid,"POOL","POOL_Med_Start",1,0,0,0,1,0,1);
			    	
			    	User[playerid][speedCue] = DEFAULT_CUE_SPEED;
			    	
			    	new buff[50];
			    	format(buff,sizeof(buff),"Predkosc: %.1f",User[playerid][speedCue]);
			    	TextDrawSetString(User[playerid][speedBox],buff);
			    	TextDrawShowForPlayer(playerid,User[playerid][speedBox]);
	    		}
	    	}
	    }
	}
	else if(oldkeys & 128)
	{
	    if(IsSighting(playerid) == true)
    	{
            SetCameraBehindPlayer(playerid);
	    	ApplyAnimation(playerid,"POOL","POOL_Med_Shot_O",4.1,0,1,1,1,1,1);
            TextDrawHideForPlayer(playerid,User[playerid][speedBox]);
            
			User[playerid][sighting] = false;
		}
	}
	
	if(newkeys & KEY_FIRE)
	{
	    if(IsSighting(playerid) == true)
	    {
			User[playerid][sighting] = false;
			
			new bilardid = GetPlayerBilard(playerid);
			
			new Float:pos[3];
			GetObjectPos(Ball[bilardid][BALL_WHITE][objID],pos[0],pos[1],pos[2]);
			
			new Float:angle;
			GetPlayerFacingAngle(playerid,angle);
			
			Ball[bilardid][BALL_WHITE][pA] = User[playerid][pA] + 180;

			pos[0] += floatsin(-Ball[bilardid][BALL_WHITE][pA],degrees) * 2;
			pos[1] += floatcos(-Ball[bilardid][BALL_WHITE][pA],degrees) * 2;
			
			MoveBall(bilardid,BALL_WHITE,pos[0],pos[1],User[playerid][speedCue]);
			
	   	    SetCameraBehindPlayer(playerid);
			ApplyAnimation(playerid,"POOL","POOL_Med_Shot",4.0,0,0,0,0,0,0);
			
			TextDrawHideForPlayer(playerid,User[playerid][speedBox]);
	    }
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(IsSighting(playerid) == true)
	{
	    new key[3];
    	GetPlayerKeys(playerid,key[0],key[1],key[2]);
    	
    	if(key[2] == KEY_LEFT && CanDirectCue(playerid,DIRECTION_LEFT) == true)
    	{
			new bilardid = GetPlayerBilard(playerid);
			DirectCue(bilardid,playerid,DIRECTION_LEFT);
    	}
    	else if(key[2] == KEY_RIGHT && CanDirectCue(playerid,DIRECTION_RIGHT) == true)
    	{
			new bilardid = GetPlayerBilard(playerid);
			DirectCue(bilardid,playerid,DIRECTION_RIGHT);
    	}
    	else if(key[1] == KEY_UP && CanChangeSpeedCue(playerid,SPEED_MORE) == true)
		{
			User[playerid][speedCue] = User[playerid][speedCue] + 0.10;
			
			new buff[100];
			format(buff,100,"Predkosc: %.1f",User[playerid][speedCue]);
			TextDrawSetString(User[playerid][speedBox],buff);
		}
		else if(key[1] == KEY_DOWN && CanChangeSpeedCue(playerid,SPEED_LESS) == true)
		{
		    User[playerid][speedCue] = User[playerid][speedCue] - 0.10;

			new buff[100];
			format(buff,100,"Predkosc: %.1f",User[playerid][speedCue]);
			TextDrawSetString(User[playerid][speedBox],buff);
		}
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/b", cmdtext, true, 10) == 0)
	{
		new Float:pos[3];
		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
		CreateBilard(pos[0] + 2,pos[1],pos[2] - 1,0);
		return 1;
	}
	if(strcmp("/dolacz", cmdtext, true, 10) == 0)
	{
		new bilardid = GetNearestBilard(playerid);

		if(bilardid >= 0)
			JoinToBilard(bilardid,playerid);
			
	    return 1;
	}
	if(strcmp("/dolacz2", cmdtext, true, 10) == 0)
	{
		new bilardid = GetNearestBilard(playerid);

		Bilard[bilardid][User_2] = 1;

		Bilard[bilardid][running] = true;
		User[Bilard[bilardid][User_1]][turn] = true;

	    return 1;
	}
	if(strcmp("/opusc", cmdtext, true, 10) == 0)
	{
	    if(IsPlayerInAnyBilard(playerid) == true)
	    	LeaveFromBilard(playerid);
	    	
	    return 1;
	}
	return 0;
}

stock CheckCollision_Table(bilardid, bid, fP, sP) //bilardid, ballid, firstPoint, secondPoint
{
	new Float:pos[3];
    GetObjectPos(Ball[bilardid][bid][objID],pos[0],pos[1],pos[2]);

	//0.15
    if(PointInLong(0.15,pos[0],pos[1],Point[bilardid][fP][hX],Point[bilardid][fP][hY],Point[bilardid][sP][hX],Point[bilardid][sP][hY]))
        return 1;
        
    return 0;
}

stock RespondCollision_Table(bilardid, bid, fP) //fp = firstPoint
{
	if(fP == 1 || fP == 3 || fP == 7 || fP == 9) //pionowe, 360 - angle
	    Ball[bilardid][bid][pA] = 360 - Ball[bilardid][bid][pA];
	else if(fP == 5 || fP == 11) //poziome, 180 - angle
		Ball[bilardid][bid][pA] = 180 - Ball[bilardid][bid][pA];
	
	new Float:pos[3];
	GetObjectPos(Ball[bilardid][bid][objID],pos[0],pos[1],pos[2]);

	pos[0] += floatsin(-Ball[bilardid][bid][pA],degrees) * 0.02; //0.03
	pos[1] += floatcos(-Ball[bilardid][bid][pA],degrees) * 0.02; //0.03

	StopObject(Ball[bilardid][bid][objID]);
	SetObjectPos(Ball[bilardid][bid][objID],pos[0],pos[1],Bilard[bilardid][bZ] + DIST_TABLE_Z);
	
	pos[0] += floatsin(-Ball[bilardid][bid][pA],degrees) * 2;
	pos[1] += floatcos(-Ball[bilardid][bid][pA],degrees) * 2;

	//MoveObject(Ball[bilardid][bid][objID],pos[0],pos[1],Bilard[bilardid][bZ] + DIST_TABLE_Z,1);
	MoveBall(bilardid,bid,pos[0],pos[1],GetBallSpeed(bilardid,bid) * FACTOR_COLL_TABLE);
}

stock CheckCollision_Ball(bilardid, fbid, sbid) //bilardid, firstBall, secondBall
{
    if(fbid != sbid) //k = first ball, j = second ball
	{
	    if(Ball[bilardid][fbid][touchID] != sbid && Ball[bilardid][sbid][touchID] != fbid)
	    {
			if(GetVectorDistance_OB(Ball[bilardid][fbid][objID],Ball[bilardid][sbid][objID]) < 0.09) //k = fbid, sbid = j
			    return 1;
 	    }
  	}
  	return 0;
}

stock RespondCollision_Ball(bilardid, fBid, sBid)
{
	new i = bilardid;
	new k = fBid;
	new j = sBid;

    Ball[i][k][touchID] = j;
    Ball[i][j][touchID] = k;

	Ball[i][k][pA] = GetVectorAngle(Ball[i][k][objID],Ball[i][j][objID]);
	Ball[i][j][pA] = GetVectorAngle(Ball[i][j][objID],Ball[i][k][objID]);

	Ball[i][k][pA] += 180;
	Ball[i][j][pA] += 180;

	new Float:firstPos[3];
	new Float:secondPos[3];

	GetObjectPos(Ball[i][k][objID],firstPos[0],firstPos[1],firstPos[2]);
	GetObjectPos(Ball[i][j][objID],secondPos[0],secondPos[1],secondPos[2]);

	firstPos[0] += floatsin(-Ball[i][k][pA],degrees) * 2;
	firstPos[1] += floatcos(-Ball[i][k][pA],degrees) * 2;

	secondPos[0] += floatsin(-Ball[i][j][pA],degrees) * 2;
	secondPos[1] += floatcos(-Ball[i][j][pA],degrees) * 2;

	new Float:firSpeed = GetBallSpeed(i,k);
	new Float:secSpeed = GetBallSpeed(i,j);

	if(firSpeed > secSpeed)
	{
		MoveBall(i,k,firstPos[0],firstPos[1],firSpeed * FACTOR_COLL_BALL);
		MoveBall(i,j,secondPos[0],secondPos[1],firSpeed * 0.85); //nie
	}
	else
	{
		MoveBall(i,k,firstPos[0],firstPos[1],secSpeed * 0.85); //nie
		MoveBall(i,j,secondPos[0],secondPos[1],secSpeed * FACTOR_COLL_BALL);
	}
}

stock CreateBilard(Float:x, Float:y, Float:z, virWorld)
{
	for(new i = 0; i < MAX_BILARDS; i++)
	{
	    if(IsBilardExists(i) == false)
		{
		    for(new j = 0; j < MAX_BILARDS; j++)
		    {
		        if(IsBilardExists(j) == true)
		        {
					if(GetDistance3D(Bilard[j][bX],Bilard[j][bY],Bilard[j][bZ],x,y,z) <= 4)
					    return BILARD_NO_SPACE;
		        }
		    }
		    
			Bilard[i][created] = true;
			Bilard[i][running] = false;
			Bilard[i][movingballs] = false;
			Bilard[i][importantball] = false;
			Bilard[i][virtualWorld] = virWorld;
			Bilard[i][lastBall] = -1;
			Bilard[i][objID] = CreateObject(2964,x,y,z,0,0,270);
			Bilard[i][bX] = x;
			Bilard[i][bY] = y;
			Bilard[i][bZ] = z;
			
			ResetBalls(i); //balls
			ResetBilardPlayers(i); //players
			
			InitTableCollisions(i); //collisions
			return i;
		}
	}
	return BILARD_LIMIT_END;
}

stock CreatePlayerTextdraws(playerid)
{
    User[playerid][box] = TextDrawCreate(460.000000,313.000000,"Brak gracza: 0 (0 pkt)~n~Brak gracza: 0 (0 pkt)");
   	TextDrawUseBox(User[playerid][box],1);
   	TextDrawTextSize(User[playerid][box],635.000000,0.000000);
   	TextDrawLetterSize(User[playerid][box],0.359999,1.100000);
	TextDrawSetShadow(User[playerid][box],1);
	TextDrawColor(User[playerid][box],227275519);
   	TextDrawBoxColor(User[playerid][box],227275314);
   	
    User[playerid][speedBox] = TextDrawCreate(460.000000,345.000000,"Predkosc: 0"); //353
    TextDrawUseBox(User[playerid][speedBox],1);
    TextDrawTextSize(User[playerid][speedBox],602.000000,0.000000);
    TextDrawLetterSize(User[playerid][speedBox],0.359999,1.100000);
    TextDrawSetShadow(User[playerid][speedBox],1);
   	TextDrawColor(User[playerid][speedBox],227275519);
   	TextDrawBoxColor(User[playerid][speedBox],227275314);
}

stock ResetAllPlayers()
{
	for(new i = 0; i < MAX_USERS; i++)
	{
	    User[i][joined]    = false;
	    User[i][sighting]  = false;
	    User[i][turn]      = false;
	    User[i][direction] = 0;
	    User[i][bilardID]  = -1;
	    User[i][balltype]  = BALL_NONE;
	    User[i][uPoints]   = 0;
	    
	    CreatePlayerTextdraws(i);
	}
}

stock DestroyAllPlayersTextdraws()
{
    for(new i = 0; i < MAX_USERS; i++)
    {
		TextDrawDestroy(User[i][box]);
		TextDrawDestroy(User[i][speedBox]);
	}
}

stock ResetBilardPlayers(bilardid)
{
	Bilard[bilardid][User_1] = -1;
	Bilard[bilardid][User_2] = -1;
}

stock ResetBalls(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	{
	    new Float:x, Float:y, Float:z;
	    new Float:pos[2];
	    new i;
	    
	    x = Bilard[bilardid][bX];
	    y = Bilard[bilardid][bY];
	    z = Bilard[bilardid][bZ];

		i = bilardid;
		
		ResetPropertiesBalls(bilardid);

		//Cale

		//Ball[0]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 71.4670 + 270,degrees) * 0.6094;
		pos[1] += floatcos(-Bilard[i][bA] + 71.4670 + 270,degrees) * 0.6094;
		Ball[i][0][objID] = CreateObject(3100,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - granatowa

		//Ball[1]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 74.4274 + 270,degrees) * 0.5256;
		pos[1] += floatcos(-Bilard[i][bA] + 74.4274 + 270,degrees) * 0.5256;
		Ball[i][1][objID] = CreateObject(3101,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - czerwona

		//Ball[2]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 265.7946 + 270,degrees) * 0.5077;
		pos[1] += floatcos(-Bilard[i][bA] - 265.7946 + 270,degrees) * 0.5077;
		Ball[i][2][objID] = CreateObject(3102,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - fioletowa

		//Ball[3]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 264.8326 + 270,degrees) * 0.3740;
		pos[1] += floatcos(-Bilard[i][bA] - 264.8326 + 270,degrees) * 0.3740;
		Ball[i][3][objID] = CreateObject(3103,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - pomaranczowa

		//Ball[4]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 79.0008 + 270,degrees) * 0.4481;
		pos[1] += floatcos(-Bilard[i][bA] + 79.0008 + 270,degrees) * 0.4481;
		Ball[i][4][objID] = CreateObject(3104,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - zielona

		//Ball[5]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 262.2294 + 270,degrees) * 0.5805;
		pos[1] += floatcos(-Bilard[i][bA] - 262.2294 + 270,degrees) * 0.5805;
		Ball[i][5][objID] = CreateObject(3105,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala - ciemna czerowna

		//Ball[6]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 87.8788 + 270,degrees) * 0.3100;
		pos[1] += floatcos(-Bilard[i][bA] + 87.8788 + 270,degrees) * 0.3100;
		Ball[i][6][objID] = CreateObject(3002,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //cala zolta


		//Polowki

		//Ball[7]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 81.7571 + 270,degrees) * 0.3771;
		pos[1] += floatcos(-Bilard[i][bA] + 81.7571 + 270,degrees) * 0.3771;
		Ball[i][7][objID] = CreateObject(2995,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka zolta

		//Ball[8]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 256.4263 + 270,degrees) * 0.5206;
		pos[1] += floatcos(-Bilard[i][bA] - 256.4263 + 270,degrees) * 0.5206;
		Ball[i][8][objID] = CreateObject(2996,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka granatowa

		//Ball[9]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 253.9338 + 270,degrees) * 0.5967;
		pos[1] += floatcos(-Bilard[i][bA] - 253.9338 + 270,degrees) * 0.5967;
		Ball[i][9][objID] = CreateObject(2997,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka czerwona

	    //Ball[10]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 79.5219 + 270,degrees) * 0.5886;
		pos[1] += floatcos(-Bilard[i][bA] + 79.5219 + 270,degrees) * 0.5886;
		Ball[i][10][objID] = CreateObject(2998,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka fioletowa

	    //Ball[11]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 84.2105 + 270,degrees) * 0.5118;
		pos[1] += floatcos(-Bilard[i][bA] + 84.2105 + 270,degrees) * 0.5118;
		Ball[i][11][objID] = CreateObject(2999,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka pomaranczowa

		//Ball[12]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 89.2841 + 270,degrees) * 0.5764;
		pos[1] += floatcos(-Bilard[i][bA] + 89.2841 + 270,degrees) * 0.5764;
		Ball[i][12][objID] = CreateObject(3000,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka zielona

		//Ball[13]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 260.0651 + 270,degrees) * 0.4429;
		pos[1] += floatcos(-Bilard[i][bA] - 260.0651 + 270,degrees) * 0.4429;
		Ball[i][13][objID] = CreateObject(3001,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //polowka

		//Biala Ball[14]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 91.5850 + 270 + 180,degrees) * 0.6354;
		pos[1] += floatcos(-Bilard[i][bA] + 91.5850 + 270 + 180,degrees) * 0.6354;
		Ball[i][BALL_WHITE][objID] = CreateObject(3003,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //biala

		//Czarna Ball[15]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 88.9996 + 270,degrees) * 0.4404;
		pos[1] += floatcos(-Bilard[i][bA] + 88.9996 + 270,degrees) * 0.4404;
		Ball[i][BALL_BLACK][objID] = CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0); //czarna
	}
}

stock ResetPropertiesBalls(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	{
	    for(new i = 0; i < MAX_BALLS; i++)
	 	{
	 	    if(IsBallEnabled(bilardid,i) == true)
	 	        RemoveBall(bilardid,i);
	 	    
	 	    Ball[bilardid][i][enabled] = true;
	    	Ball[bilardid][i][touchID] = -1;
	    	Ball[bilardid][i][speed]   = 0;
  		}
	}
}

stock InitTableCollisions(bilardid)
{
    if(IsBilardExists(bilardid) == true)
	{
	    new Float:x, Float:y; //, Float:z;
	    new Float:pos[2];
	    new i;
	    
	    x = Bilard[bilardid][bX];
		y = Bilard[bilardid][bY];
		//z = Bilard[bilardid][bZ];
		
		i = bilardid;

		//Point[0]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 67.1339 + 90,degrees) * 1.0532;
		pos[1] += floatcos(-Bilard[i][bA] + 67.1339 + 90,degrees) * 1.0532;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][0][hX] = pos[0];
		Point[i][0][hY] = pos[1];

		//Point[1]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 58.5638 + 90,degrees) * 1.0029;
		pos[1] += floatcos(-Bilard[i][bA] + 58.5638 + 90,degrees) * 1.0029;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][1][hX] = pos[0];
		Point[i][1][hY] = pos[1];

		//Point[2]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 10.0509 + 90,degrees) * 0.5470;
		pos[1] += floatcos(-Bilard[i][bA] + 10.0509 + 90,degrees) * 0.5470;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][2][hX] = pos[0];
		Point[i][2][hY] = pos[1];

		//Point[3]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 9.4056 + 90,degrees) * 0.5501; //0.5201
		pos[1] += floatcos(-Bilard[i][bA] - 9.4056 + 90,degrees) * 0.5501;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][3][hX] = pos[0];
		Point[i][3][hY] = pos[1];

		//Point[4]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 56.8738 + 90,degrees) * 1.0118;
		pos[1] += floatcos(-Bilard[i][bA] - 56.8738 + 90,degrees) * 1.0118;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][4][hX] = pos[0];
		Point[i][4][hY] = pos[1];

		//Point[5]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] - 66.9162 + 90,degrees) * 1.0465;
		pos[1] += floatcos(-Bilard[i][bA] - 66.9162 + 90,degrees) * 1.0465;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][5][hX] = pos[0];
		Point[i][5][hY] = pos[1];

		//Point[6]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 247.6231 + 90,degrees) * 1.0499;
		pos[1] += floatcos(-Bilard[i][bA] + 247.6231 + 90,degrees) * 1.0499;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][6][hX] = pos[0];
		Point[i][6][hY] = pos[1];

        //Point[7]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 237.9056 + 90,degrees) * 1.0127;
		pos[1] += floatcos(-Bilard[i][bA] + 237.9056 + 90,degrees) * 1.0127;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][7][hX] = pos[0];
		Point[i][7][hY] = pos[1];

		//Point[8]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 188.4499 + 90,degrees) * 0.5333;
		pos[1] += floatcos(-Bilard[i][bA] + 188.4499 + 90,degrees) * 0.5333;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][8][hX] = pos[0];
		Point[i][8][hY] = pos[1];

		//Point[9]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 170.7394 + 90,degrees) * 0.5419;
		pos[1] += floatcos(-Bilard[i][bA] + 170.7394 + 90,degrees) * 0.5419;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][9][hX] = pos[0];
		Point[i][9][hY] = pos[1];

		//Point[10]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 121.6019 + 90,degrees) * 1.0234;
		pos[1] += floatcos(-Bilard[i][bA] + 121.6019 + 90,degrees) * 1.0234;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][10][hX] = pos[0];
		Point[i][10][hY] = pos[1];

		//Point[11]
		pos[0] = x;
		pos[1] = y;
		pos[0] += floatsin(-Bilard[i][bA] + 112.1066 + 90,degrees) * 1.0589;
		pos[1] += floatcos(-Bilard[i][bA] + 112.1066 + 90,degrees) * 1.0589;
		//CreateObject(3106,pos[0],pos[1],z + DIST_TABLE_Z,0,0,0);
		Point[i][11][hX] = pos[0];
		Point[i][11][hY] = pos[1];
	}
}

stock PutBallInLeak(bilardid, bid)
{
	Bilard[bilardid][lastBall] = bid;

	if(bid == BALL_WHITE)
	{
    	StopBall(bilardid,bid);
    	
    	new Float:pos[2];
    	pos[0] = Bilard[bilardid][bX];
    	pos[1] = Bilard[bilardid][bY];
    	pos[0] += floatsin(-Bilard[bilardid][bA] + 91.5850 + 270 + 180,degrees) * 0.6354;
		pos[1] += floatcos(-Bilard[bilardid][bA] + 91.5850 + 270 + 180,degrees) * 0.6354;
		SetObjectPos(Ball[bilardid][bid][objID],pos[0],pos[1],Bilard[bilardid][bZ] + DIST_TABLE_Z);
	}
	else
	    RemoveBall(bilardid,bid);
	    
	new buff[100];
	    
	if(bid >= 0 && bid < 7) //cala
	{
	    //jezeli pierwsza bila ktora wpadla jest cala
	    if(GetPlayerBallType(Bilard[bilardid][User_1]) == BALL_NONE || GetPlayerBallType(Bilard[bilardid][User_2]) == BALL_NONE)
	    {
			if(IsTurn(Bilard[bilardid][User_1]) == true)
			{
				User[Bilard[bilardid][User_1]][balltype] = BALL_FULL;
				User[Bilard[bilardid][User_2]][balltype] = BALL_HALF;
			}
			else
			{
			    User[Bilard[bilardid][User_1]][balltype] = BALL_HALF;
				User[Bilard[bilardid][User_2]][balltype] = BALL_FULL;
			}
			
			SetPlayerPoints(Bilard[bilardid][User_1],7);
			SetPlayerPoints(Bilard[bilardid][User_2],7);
		}
		
		if(GetPlayerBallType(Bilard[bilardid][User_1]) == BALL_FULL)
		{
			new pPts = GetPlayerPoints(Bilard[bilardid][User_1]) - 1;
			SetPlayerPoints(Bilard[bilardid][User_1],pPts);
			
			new uPts = GetUserPoints(Bilard[bilardid][User_1]) + 1;
			SetUserPoints(Bilard[bilardid][User_1],uPts);
		}
		else if(GetPlayerBallType(Bilard[bilardid][User_2]) == BALL_FULL)
		{
		    new pPts = GetPlayerPoints(Bilard[bilardid][User_2]) - 1;
			SetPlayerPoints(Bilard[bilardid][User_2],pPts);
			
			new uPts = GetUserPoints(Bilard[bilardid][User_2]) + 1;
			SetUserPoints(Bilard[bilardid][User_2],uPts);
		}
		
		
		format(buff,sizeof(buff),"%s %s: %d (%d pkt)~n~%s %s: %d (%d pkt)",GetName(Bilard[bilardid][User_1]),
																		   Symbol[GetPlayerBallType(Bilard[bilardid][User_1])],
																		   GetPlayerPoints(Bilard[bilardid][User_1]),
																		   GetUserPoints(Bilard[bilardid][User_1]),
      																	   GetName(Bilard[bilardid][User_2]),
																  		   Symbol[GetPlayerBallType(Bilard[bilardid][User_2])],
																           GetPlayerPoints(Bilard[bilardid][User_2]),
																		   GetUserPoints(Bilard[bilardid][User_2]));

		TextDrawSetString(User[Bilard[bilardid][User_1]][box],buff);
		TextDrawSetString(User[Bilard[bilardid][User_2]][box],buff);
	}
	else if(bid >= 7 && bid < 14) //polowka
	{
	    //jezeli pierwsza bila ktora wpadla jest polowka
	    if(GetPlayerBallType(Bilard[bilardid][User_1]) == BALL_NONE || GetPlayerBallType(Bilard[bilardid][User_2]) == BALL_NONE)
	    {
			if(IsTurn(Bilard[bilardid][User_1]) == true)
			{
				User[Bilard[bilardid][User_1]][balltype] = BALL_HALF;
				User[Bilard[bilardid][User_2]][balltype] = BALL_FULL;
			}
			else
			{
			    User[Bilard[bilardid][User_1]][balltype] = BALL_FULL;
				User[Bilard[bilardid][User_2]][balltype] = BALL_HALF;
			}
			
			SetPlayerPoints(Bilard[bilardid][User_1],7);
			SetPlayerPoints(Bilard[bilardid][User_2],7);
		}
		
		if(GetPlayerBallType(Bilard[bilardid][User_1]) == BALL_HALF)
		{
			new pts = GetPlayerPoints(Bilard[bilardid][User_1]) - 1;
			SetPlayerPoints(Bilard[bilardid][User_1],pts);
			
			new uPts = GetUserPoints(Bilard[bilardid][User_1]) + 1;
			SetUserPoints(Bilard[bilardid][User_1],uPts);
		}
		else if(GetPlayerBallType(Bilard[bilardid][User_2]) == BALL_HALF)
		{
		    new pts = GetPlayerPoints(Bilard[bilardid][User_2]) - 1;
			SetPlayerPoints(Bilard[bilardid][User_2],pts);
			
			new uPts = GetUserPoints(Bilard[bilardid][User_2]) + 1;
			SetUserPoints(Bilard[bilardid][User_2],uPts);
		}
		
		format(buff,sizeof(buff),"%s %s: %d (%d pkt)~n~%s %s: %d (%d pkt)",GetName(Bilard[bilardid][User_1]),
																		   Symbol[GetPlayerBallType(Bilard[bilardid][User_1])],
																		   GetPlayerPoints(Bilard[bilardid][User_1]),
																		   GetUserPoints(Bilard[bilardid][User_1]),
        	                                             			   	   GetName(Bilard[bilardid][User_2]),
																		   Symbol[GetPlayerBallType(Bilard[bilardid][User_2])],
																		   GetPlayerPoints(Bilard[bilardid][User_2]),
																		   GetUserPoints(Bilard[bilardid][User_2]));

		TextDrawSetString(User[Bilard[bilardid][User_1]][box],buff);
		TextDrawSetString(User[Bilard[bilardid][User_2]][box],buff);
	}
	else if(bid == BALL_WHITE) //biala
	{
		if(IsTurn(Bilard[bilardid][User_1]) == true)
		{
			format(buff,sizeof(buff),"~r~Wpadla biala bila, teraz uderza %s.",GetName(Bilard[bilardid][User_2]));
			GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
			GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);
			
			Bilard[bilardid][importantball] = true;
			User[Bilard[bilardid][User_1]][turn] = false;
			User[Bilard[bilardid][User_2]][turn] = true;
		}
		else
		{
		    format(buff,sizeof(buff),"~r~Wpadla biala bila, teraz uderza %s.",GetName(Bilard[bilardid][User_1]));
			GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
			GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);

            Bilard[bilardid][importantball] = true;
			User[Bilard[bilardid][User_1]][turn] = true;
			User[Bilard[bilardid][User_2]][turn] = false;
		}
	}
	else //czarna
	{
	    if(IsTurn(Bilard[bilardid][User_1]) == true) //Gracz na pierwszym slocie
		{
		    new bType = GetPlayerBallType(Bilard[bilardid][User_1]);

			if(GetNumberOfEnabledBalls(bilardid,bType) != 0) //jezeli jego bile jeszcze stoja w grze, to uznajemy go za przegranego i konczymy gre
			{
			    GameTextForPlayer(Bilard[bilardid][User_1],"~r~Wpadla czarna bila zanim wbiles swoje bile, przegrywasz!",5000,4);
			    
			    format(buff,sizeof(buff),"~g~%s wbil czarna zanim wbil swoje bile, wygrywasz!",GetName(Bilard[bilardid][User_1]));
			    GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);
			}
			else //jezeli nie ma zadnych jego bil w grze, to uznajemy go za wygranego i konczymy gre
			{
			    GameTextForPlayer(Bilard[bilardid][User_1],"~g~Wbiles ostatnia bile, wygrywasz!",5000,4);
			    
			    format(buff,sizeof(buff),"~r~%s wbil ostatnia bile, przegrywasz!",GetName(Bilard[bilardid][User_1]));
			    GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);
			}
 		}
 		else //Gracz na drugim slocie
 		{
 		    new bType = GetPlayerBallType(Bilard[bilardid][User_2]);

			if(GetNumberOfEnabledBalls(bilardid,bType) != 0) //jezeli jego bile jeszcze stoja w grze, to uznajemy go za przegranego i konczymy gre
			{
			    GameTextForPlayer(Bilard[bilardid][User_2],"~r~Wpadla czarna bila zanim wbiles swoje bile, przegrywasz!",5000,4);

			    format(buff,sizeof(buff),"~g~%s wbil czarna zanim wbil swoje bile, wygrywasz gre!",GetName(Bilard[bilardid][User_2]));
			    GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
			}
			else //jezeli nie ma zadnych jego bil w grze, to uznajemy go za wygranego i konczymy gre
			{
			    GameTextForPlayer(Bilard[bilardid][User_2],"~g~Wbiles ostatnia bile, wygrywasz!",5000,4);

			    format(buff,sizeof(buff),"~r~%s wbil ostatnia bile, przegrywasz!",GetName(Bilard[bilardid][User_2]));
			    GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
			}
 		}
 		
 		//Procedura konczenia gry
		FinishBilard(bilardid);
	}
}

stock MoveBall(bilardid, bid, Float:x, Float:y, Float:bSpeed)
{
	if(bSpeed > 0.001)
	{
		Ball[bilardid][bid][destX] = x;
		Ball[bilardid][bid][destY] = y;
		Ball[bilardid][bid][speed] = bSpeed;
		
    	MoveObject(Ball[bilardid][bid][objID],Ball[bilardid][bid][destX],Ball[bilardid][bid][destY],Bilard[bilardid][bZ] + DIST_TABLE_Z,Ball[bilardid][bid][speed]);
    }
    else if(bSpeed == SPEED_NO_CHANGE)
    {
        if(GetBallSpeed(bilardid,bid) > 0.001)
        {
            Ball[bilardid][bid][destX] = x;
			Ball[bilardid][bid][destY] = y;
			
            MoveObject(Ball[bilardid][bid][objID],Ball[bilardid][bid][destX],Ball[bilardid][bid][destY],Bilard[bilardid][bZ] + DIST_TABLE_Z,Ball[bilardid][bid][speed]);
   		}
    }
}

stock SetBallSpeed(bilardid, bid, Float:bSpeed)
{
	if(bSpeed > 0.001)
	{
	    Ball[bilardid][bid][speed] = bSpeed;
	    MoveObject(Ball[bilardid][bid][objID],Ball[bilardid][bid][destX],Ball[bilardid][bid][destY],Bilard[bilardid][bZ] + DIST_TABLE_Z,Ball[bilardid][bid][speed]);
	}
	else
	{
	    Ball[bilardid][bid][speed] = 0;
		StopObject(Ball[bilardid][bid][objID]);
	}
}

stock Float:GetBallSpeed(bilardid, bid)
{
	return Ball[bilardid][bid][speed];
}

stock StopBall(bilardid, bid)
{
	Ball[bilardid][bid][speed] = 0;
	SetBallSpeed(bilardid,bid,0);
}

stock GetNearestBilard(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:pos[3];
		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
		
		for(new i = 0; i < MAX_BILARDS; i++)
		{
	    	if(IsBilardExists(i) == true)
	    	{
	    	    if(GetDistance3D(Bilard[i][bX],Bilard[i][bY],Bilard[i][bZ],pos[0],pos[1],pos[2]) <= 2)
	    	        return i;
	    	}
		}
	}
	return -1;
}

stock bool:IsBallEnabled(bilardid, bid)
{
	return Ball[bilardid][bid][enabled];
}

stock bool:AreBallsMoving(bilardid)
{
	return Bilard[bilardid][movingballs];
}

stock bool:AreBallsStoped(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	{
	    for(new i = 0; i < MAX_BALLS; i++)
	    {
	        if(GetBallSpeed(bilardid,i) > 0)
				return false;
	    }
	    return true;
	}
	return false;
}

stock GetPlayerBallType(playerid)
{
	return User[playerid][balltype];
}

stock GetNumberOfEnabledBalls(bilardid, bType)
{
	new amount = 0;
	if(bType == BALL_FULL)
	{
	    for(new i = 0; i < 7; i++) //0 - 6 cale
	    {
	        if(IsBallEnabled(bilardid,i) == true)
	            amount++;
	    }
	}
	else if(bType == BALL_HALF)
	{
	    for(new i = 7; i < 14; i++) //7 - 13 polowki
	    {
	        if(IsBallEnabled(bilardid,i) == true)
	            amount++;
	    }
	}
	return amount;
}

stock GetLastBall(bilardid)
{
	return Bilard[bilardid][lastBall];
}

stock RemoveBall(bilardid, bid)
{
	if(IsBilardExists(bilardid) == true)
	{
	    if(IsBallEnabled(bilardid,bid) == true)
	    {
	        Ball[bilardid][bid][enabled] = false;
	        DestroyObject(Ball[bilardid][bid][objID]);
	    }
	}
}

stock DestroyBilard(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	{
	    Bilard[bilardid][created] = false;
	    Bilard[bilardid][running] = false;
	    Bilard[bilardid][movingballs] = false;
	    Bilard[bilardid][importantball] = false;
	    Bilard[bilardid][virtualWorld] = -1;
	    Bilard[bilardid][User_1] = -1;
	    Bilard[bilardid][User_2] = -1;
	    
	    DestroyObject(Bilard[bilardid][objID]);
	    
	    for(new i = 0; i < MAX_BALLS; i++)
			DestroyObject(Ball[bilardid][i][objID]);
	}
}

stock DestroyAllBilards()
{
	for(new i = 0; i < MAX_BILARDS; i++)
	{
	    if(IsBilardExists(i) == true)
	        DestroyBilard(i);
	}
}

stock GetBilardVirtualWorld(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	    return Bilard[bilardid][virtualWorld];
	    
	return -1;
}

stock bool:IsBilardExists(bilardid)
{
	return Bilard[bilardid][created];
}

stock bool:IsBilardRunning(bilardid)
{
	return Bilard[bilardid][running];
}

stock bool:IsPlayerInAnyBilard(playerid)
{
	return User[playerid][joined];
}

stock bool:IsSighting(playerid)
{
	return User[playerid][sighting];
}

stock bool:IsTurn(playerid)
{
	return User[playerid][turn];
}

stock bool:CanJoinToBilard(bilardid, playerid, &slot)
{
	if(IsBilardExists(bilardid) == true)
	{
	    if(IsPlayerInAnyBilard(playerid) == false)
	    {
	    	if(Bilard[bilardid][User_1] != playerid && Bilard[bilardid][User_2] != playerid)
	    	{
	  	    	if(Bilard[bilardid][User_1] == -1)
	  	    	{
					slot = 1;
	        		return true;
       			}
       			else if(Bilard[bilardid][User_2] == -1)
       			{
       		    	slot = 2;
       		    	return true;
       			}
     		}
     	}
	}
	return false;
}

stock bool:CanDirectCue(playerid, EnumCueDirect:direct)
{
	if(IsPlayerConnected(playerid))
	{
	    if(direct == DIRECTION_LEFT)
	    {
	        if(User[playerid][direction] > -MAX_DIRECTION_CUE)
	            return true;
	    }
	    else if(direct == DIRECTION_RIGHT)
	    {
	        if(User[playerid][direction] < MAX_DIRECTION_CUE)
	            return true;
	    }
	}
	return false;
}

stock bool:CanChangeSpeedCue(playerid, EnumCueSpeed:cSpeed)
{
    if(IsPlayerConnected(playerid))
	{
	    if(cSpeed == SPEED_MORE)
	    {
	        if(User[playerid][speedCue] < MAX_CUE_SPEED)
	            return true;
	    }
	    else if(cSpeed == SPEED_LESS)
	    {
	        if(User[playerid][speedCue] > MIN_CUE_SPEED)
	            return true;
	    }
	}
	return false;
}

stock GetPlayerBilard(playerid)
{
	if(IsPlayerInAnyBilard(playerid) == true)
	    return User[playerid][bilardID];

	return -1;
}

stock FinishBilard(bilardid)
{
	if(IsBilardExists(bilardid) == true)
	{
        if(Bilard[bilardid][User_1] != -1 && IsSighting(Bilard[bilardid][User_1]) == true)
			SetCameraBehindPlayer(Bilard[bilardid][User_1]);

		else if(Bilard[bilardid][User_2] != -1 && IsSighting(Bilard[bilardid][User_2]) == true)
	   		SetCameraBehindPlayer(Bilard[bilardid][User_2]);

        User[Bilard[bilardid][User_1]][joined]   = false;
		User[Bilard[bilardid][User_1]][sighting] = false;
		User[Bilard[bilardid][User_1]][turn]     = false;
		User[Bilard[bilardid][User_1]][bilardID] = -1;
		User[Bilard[bilardid][User_1]][uPoints]  = 0;
		TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][box]);
		TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][speedBox]);

		User[Bilard[bilardid][User_2]][joined]   = false;
		User[Bilard[bilardid][User_2]][sighting] = false;
		User[Bilard[bilardid][User_2]][turn]     = false;
		User[Bilard[bilardid][User_2]][bilardID] = -1;
		User[Bilard[bilardid][User_2]][uPoints]  = 0;
		TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][box]);
		TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][speedBox]);

		Bilard[bilardid][running]     = false;
		Bilard[bilardid][movingballs] = false;

		Bilard[bilardid][User_1]      = -1;
		Bilard[bilardid][User_2]      = -1;

		ResetBalls(bilardid);
	}
}

stock JoinToBilard(bilardid, playerid)
{
	new slot = 0;
	if(CanJoinToBilard(bilardid,playerid,slot) == true)
	{
	    if(slot == 1)
	        Bilard[bilardid][User_1] = playerid;
		else if(slot == 2)
		    Bilard[bilardid][User_2] = playerid;
		    
		User[playerid][joined]   = true;
		User[playerid][bilardID] = bilardid;
		GivePlayerWeapon(playerid,7,1);
		SetPlayerSkin(playerid,29);
		    
		new u1_name[24];
		new u2_name[24];
		
		if(Bilard[bilardid][User_1] != -1)
		    u1_name = GetName(Bilard[bilardid][User_1]);
		else
			strcat(u1_name,STR_AWAITING_FOR_PLAYER); //"oczekiwanie na gracza"
			
        if(Bilard[bilardid][User_2] != -1)
		    u2_name = GetName(Bilard[bilardid][User_2]);
		else
			strcat(u2_name,STR_AWAITING_FOR_PLAYER); //"oczekiwanie na gracza"
	
	    new buff[100];
     	format(buff,sizeof(buff),"%s: %d (0 pkt)~n~%s: %d (0 pkt)",u1_name,0,u2_name,0);

  		if(Bilard[bilardid][User_1] == playerid)
  		{
  		    TextDrawSetString(User[Bilard[bilardid][User_1]][box],buff);
     		TextDrawShowForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][box]);
     		GameTextForPlayer(Bilard[bilardid][User_1],"~g~Dolaczyles do rozgrywki.",5000,4);
     		
     		if(Bilard[bilardid][User_2] != -1)
     		{
     		    TextDrawSetString(User[Bilard[bilardid][User_2]][box],buff);
		   		TextDrawShowForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][box]);
		   		
		   		format(buff,sizeof(buff),"~g~%s dolaczyl do rozgrywki.",GetName(Bilard[bilardid][User_1]));
     	        GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);
     		}
  		}
  		else if(Bilard[bilardid][User_2] == playerid)
  		{
  		    TextDrawSetString(User[Bilard[bilardid][User_2]][box],buff);
     		TextDrawShowForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][box]);
     		GameTextForPlayer(Bilard[bilardid][User_2],"~g~Dolaczyles do rozgrywki.",5000,4);
     		
     		if(Bilard[bilardid][User_1] != -1)
     		{
     		    TextDrawSetString(User[Bilard[bilardid][User_1]][box],buff);
		   		TextDrawShowForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][box]);

		   		format(buff,sizeof(buff),"~g~%s dolaczyl do rozgrywki.",GetName(Bilard[bilardid][User_2]));
     	        GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
     		}
  		}
  		
  		if(Bilard[bilardid][User_1] != -1 && Bilard[bilardid][User_2] != -1)
  		{
  		    Bilard[bilardid][running] = true;
  		    Bilard[bilardid][movingballs] = false;
  		    Bilard[bilardid][importantball] = false;
   			Bilard[bilardid][lastBall] = -1;
  		    
  		    User[Bilard[bilardid][User_1]][turn] = true;
  		    
  		    User[Bilard[bilardid][User_1]][balltype] = BALL_NONE;
  		    User[Bilard[bilardid][User_2]][balltype] = BALL_NONE;
    	}
	}
}

stock LeaveFromBilard(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerInAnyBilard(playerid) == true)
	    {
	        new bilardid = GetPlayerBilard(playerid);
			
			if(Bilard[bilardid][User_1] != -1 && IsSighting(Bilard[bilardid][User_1]) == true)
			    SetCameraBehindPlayer(Bilard[bilardid][User_1]);
			    
			else if(Bilard[bilardid][User_2] != -1 && IsSighting(Bilard[bilardid][User_2]) == true)
			   SetCameraBehindPlayer(Bilard[bilardid][User_2]);
			
			new buff[100];
			
			if(Bilard[bilardid][User_1] == playerid)
			{
			    User[Bilard[bilardid][User_1]][joined]   = false;
				User[Bilard[bilardid][User_1]][sighting] = false;
				User[Bilard[bilardid][User_1]][turn]     = false;
				User[Bilard[bilardid][User_1]][bilardID] = -1;
				User[Bilard[bilardid][User_1]][uPoints]  = 0;
				
				GameTextForPlayer(Bilard[bilardid][User_1],"~y~Opusciles stol, rozgrywka zostaje przerwana.",5000,4);
				TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][box]);
				TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][speedBox]);
				
				if(Bilard[bilardid][User_2] != -1)
				{
				    User[Bilard[bilardid][User_2]][joined]   = false;
					User[Bilard[bilardid][User_2]][sighting] = false;
					User[Bilard[bilardid][User_2]][turn]     = false;
					User[Bilard[bilardid][User_2]][bilardID] = -1;
					User[Bilard[bilardid][User_2]][uPoints]  = 0;

					format(buff,sizeof(buff),"~y~%s opuscil bilard, rozgrywka zostaje przerwana.",GetName(Bilard[bilardid][User_1]));
					GameTextForPlayer(Bilard[bilardid][User_2],buff,5000,4);
					TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][box]);
					TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][speedBox]);
				}
			}
			else if(Bilard[bilardid][User_2] == playerid)
			{
			    User[Bilard[bilardid][User_2]][joined]   = false;
				User[Bilard[bilardid][User_2]][sighting] = false;
				User[Bilard[bilardid][User_2]][turn]     = false;
				User[Bilard[bilardid][User_2]][bilardID] = -1;
				User[Bilard[bilardid][User_2]][uPoints]  = 0;
				
				GameTextForPlayer(Bilard[bilardid][User_2],"~y~Opusciles stol, rozgrywka zostaje przerwana.",5000,4);
				TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][box]);
				TextDrawHideForPlayer(Bilard[bilardid][User_2],User[Bilard[bilardid][User_2]][speedBox]);
				
				if(Bilard[bilardid][User_1] != -1)
				{
				    User[Bilard[bilardid][User_1]][joined]   = false;
					User[Bilard[bilardid][User_1]][sighting] = false;
					User[Bilard[bilardid][User_1]][turn]     = false;
					User[Bilard[bilardid][User_1]][bilardID] = -1;
					User[Bilard[bilardid][User_1]][uPoints]  = 0;
					
					format(buff,sizeof(buff),"~y~%s opuscil bilard, rozgrywka zostaje przerwana.",GetName(Bilard[bilardid][User_2]));
					GameTextForPlayer(Bilard[bilardid][User_1],buff,5000,4);
					TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][box]);
					TextDrawHideForPlayer(Bilard[bilardid][User_1],User[Bilard[bilardid][User_1]][speedBox]);
				}
			}
			
			Bilard[bilardid][running]       = false;
			Bilard[bilardid][movingballs]   = false;
			Bilard[bilardid][importantball] = false;
			Bilard[bilardid][lastBall]      = -1;
			
			Bilard[bilardid][User_1] = -1;
			Bilard[bilardid][User_2] = -1;
			
			ResetBalls(bilardid);
	    }
	}
}

stock DirectCue(bilardid, playerid, EnumCueDirect:direct)
{
	if(IsBilardExists(bilardid) == true)
	{
	    if(IsPlayerInAnyBilard(playerid) == true)
	    {
    		new Float:pos[3];
    	   	GetObjectPos(Ball[bilardid][BALL_WHITE][objID],pos[0],pos[1],pos[2]);
	        
	       	new Float:camPos[2];
   	    	camPos[0] = pos[0];
   	    	camPos[1] = pos[1];
	        
        	if(direct == DIRECTION_LEFT)
	       	{
	           	User[playerid][direction]--;
    	 	   	User[playerid][pA] =  User[playerid][pA] - 2;
	       	}
	       	else if(direct == DIRECTION_RIGHT)
	       	{
	            User[playerid][direction]++;
    	 	    User[playerid][pA] =  User[playerid][pA] + 2;
	       	}
	        
       		camPos[0] += floatsin(-User[playerid][pA],degrees) * 0.5;
   	    	camPos[1] += floatcos(-User[playerid][pA],degrees) * 0.5;
    	    
   	    	SetPlayerCameraPos(playerid,camPos[0],camPos[1],pos[2] + 0.3);
			SetPlayerCameraLookAt(playerid,pos[0],pos[1],pos[2] + 0.1);
	    }
	}
}

//ile zdobyto punktow
stock SetUserPoints(playerid, pts)
{
	User[playerid][uPoints] = pts;
}

stock GetUserPoints(playerid)
{
	return User[playerid][uPoints];
}

//ile bil zostalo
stock SetPlayerPoints(playerid, pts)
{
	User[playerid][points] = pts;
}

stock GetPlayerPoints(playerid)
{
	return User[playerid][points];
}

stock SaveBilard_MySQL()
{
    new handle = mysql_connect(DB_HOST,DB_USER,DB_DATABASE,DB_PASSWORD);
	if(handle)
	{
	    new query[100];
	    mysql_query("DELETE FROM bilard_table");
	    
	    for(new i = 0; i < MAX_BILARDS; i++)
	    {
			if(IsBilardExists(i) == true)
			{
			    format(query,sizeof(query),"INSERT INTO bilard_table VALUES (%f, %f, %f)",Bilard[i][bX],Bilard[i][bY],Bilard[i][bZ]);
	    		mysql_query(query);
	    	}
	    }
	    mysql_close();
	}
	else
	    printf("Could not connect to bilard database.");
}

stock LoadBilard_MySQL()
{
    new handle = mysql_connect(DB_HOST,DB_USER,DB_DATABASE,DB_PASSWORD);
	if(handle)
	{
        new result[100];
	    mysql_query("SELECT * FROM bilard_table");
	    mysql_store_result();

		new Float:pos[3];
		new virWorld = 0;
		new index = 0;
		
	    while(mysql_fetch_row_format(result))
	    {
			sscanf(result,"p<|>fffd",pos[0],pos[1],pos[2],virWorld);
			CreateBilard(pos[0],pos[1],pos[2],virWorld);
	    	index++;
	    }
	    
	    if(index)
	        printf("SERVER: Loaded %d biliard tables.",index);
		else
		    printf("SERVER: Database does not contain any biliard tables.");

	    mysql_free_result();
	    mysql_close();
	}
	else
	    printf("Could not connect to bilard database.");
}

stock SaveBilard_INI()
{
   	new buff[100];

	for(new i = 0; i < MAX_BILARDS; i++)
	{
	    format(buff,sizeof(buff),"%s\\bilard_%d.ini",DATABASE_PATH,i);
	    if(dini_Exists(buff))
	        dini_Remove(buff);
	
	    if(IsBilardExists(i) == true)
    	{
			dini_Create(buff);
		
			dini_FloatSet(buff,"bX",Bilard[i][bX]);
			dini_FloatSet(buff,"bY",Bilard[i][bY]);
			dini_FloatSet(buff,"bZ",Bilard[i][bZ]);
		}
	}
}

stock LoadBilard_INI()
{
	new buff[100];
	
	for(new i = 0; i < MAX_BILARDS; i++)
	{
		format(buff,sizeof(buff),"%s\\bilard_%d.ini",DATABASE_PATH,i);
		
		if(dini_Exists(buff))
		{
			new Float:pos[3];
			pos[0] = dini_Float(buff,"bX");
			pos[1] = dini_Float(buff,"bY");
			pos[2] = dini_Float(buff,"bZ");
			
			CreateBilard(pos[0],pos[1],pos[2]);
		}
	}
}

stock Float:GetDistance(Float:fx, Float:fy, Float:tx, Float:ty)
{
	return floatsqroot(floatpower(tx - fx,2) + floatpower(ty - fy,2));
}

stock Float:GetDistance3D(Float:fx, Float:fy, Float:fz, Float:tx, Float:ty, Float:tz)
{
	return floatsqroot(floatpower(tx - fx,2) + floatpower(ty - fy,2) + floatpower(tz - fz,2));
}

stock Float:GetVectorDistance_OB(obj, obj2)
{
	new Float:pos[6];
	GetObjectPos(obj,pos[0],pos[1],pos[2]);
	GetObjectPos(obj2,pos[3],pos[4],pos[5]);
	return floatsqroot(floatpower(pos[3] - pos[0],2) + floatpower(pos[4] - pos[1],2) + floatpower(pos[5] - pos[2],2));
}

stock Float:GetVectorDistance_PL(playerid, obj)
{
    new Float:pos[6];
	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	GetObjectPos(obj,pos[3],pos[4],pos[5]);
	return floatsqroot(floatpower(pos[3] - pos[0],2) + floatpower(pos[4] - pos[1],2) + floatpower(pos[5] - pos[2],2));
}

stock Float:GetVectorAngle(obj, obj2)
{
	new Float:vector[3];
	new Float:pos[6];
	GetObjectPos(obj,pos[0],pos[1],pos[2]);
	GetObjectPos(obj2,pos[3],pos[4],pos[5]);
	vector[0] = pos[3] - pos[0];
	vector[1] = pos[4] - pos[1];
	vector[2] = atan(-(vector[0] / vector[1]));
	if(vector[1] < 0)
	    vector[2] = vector[2] >= 180 ? vector[2] - 180 : vector[2] + 180;

	return vector[2];
}

stock Float:GetVectorAngle_XY(Float:fx, Float:fy, Float:tx, Float:ty)
{
	new Float:vector[3];
	vector[0] = tx - fx;
	vector[1] = ty - fy;
	vector[2] = atan(-(vector[0] / vector[1]));
	if(vector[1] < 0)
	    vector[2] = vector[2] >= 180 ? vector[2] - 180 : vector[2] + 180;

	return vector[2];
}

stock PointInLong(Float:size, Float:px,Float:py, Float:px1,Float:py1, Float:px2,Float:py2)
{
	new Float:vec[3];
	vec[0] = GetDistance(px1,py1,px2,py2);
	if((vec[1] = GetDistance(px,py,px1,py1)) < vec[0] && (vec[2] = GetDistance(px,py,px2,py2)) < vec[0])
	{
	    new Float:opt[2];
		opt[0] = (vec[0] + vec[1] + vec[2]) / 2;
	    opt[1] = floatsqroot(opt[0] * (opt[0] - vec[0]) * (opt[0] - vec[1]) * (opt[0] - vec[2]));
		opt[1] = ((opt[1] * 2) / vec[0]) * 2;
		if(opt[1] < size)
		    return 1;
	}
	return 0;
}

stock Float:FixAngle(Float:angle)
{
	if(angle < 0)
		angle = 360 + angle;
	else if(angle > 360)
	    angle = angle - 360;
	
	return angle;
}

stock GetName(playerid)
{
	new name[24];
	GetPlayerName(playerid,name,24);
	return name;
}
