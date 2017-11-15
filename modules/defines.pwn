// modules/defines.pwn

#define MYSQL_HOST "localhost" 
#define MYSQL_USER "root"
#define MYSQL_PASS "wax"
#define MYSQL_DB  "bsrp"

#define CallBack:%1(%2) \
 	forward %1(%2); public %1(%2)
	
#define ucfirst(%1) \
  %1[0] = toupper(%1[0])

#define dcfirst(%1) \  
 %1[0] = tolower(%1[0])

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	
#define YesOrNo(%1) yesorno[((%1 == 0 || %1 == 2) ? %1 : 1)]
#define NONE DUMMY

#define IsKeyJustDown(%1,%2,%3) ((%2 & %1) && !(%3 & %1))

#define foreachEx(%2,%1) 				for(new %2 = 0; %2 < %1; %2++)


#undef MAX_PLAYERS
#define MAX_PLAYERS 150
#define MAX_GROUPS 30
#define MAX_DOORS 2000


#define VEHICLES_WITHOUT_OWNERS -1

	
#define prefix "bsrp_"
#define prefix_forum "ipb_"
#define CITY_NAME "Los Santos"
#define servername "South Central RP"
#define longerservername "South Central Role Play"
#define www "www.sc-life.pl"
#define VERSION "0.1"

#define DIALOG_SERVER_NAME "sc-Life.pl ::"

#define SPLIT_TEXT_LIMIT	80
#define SPLIT_TEXT1_FROM    0
#define SPLIT_TEXT1_TO      65
#define SPLIT_TEXT2_FROM    65
#define SPLIT_TEXT2_TO      130

#define COLOR_WHITE			0xFFFFFFAA
#define COLOR_GRAD1			0xB4B5B7FF
#define COLOR_GRAD2			0xBFC0C2FF
#define COLOR_GREY          0xAFAFAFAA
#define COLOR_LORANGE		0xE87732FF
#define COLOR_LIGHTGREEN	0x9ACD32AA
#define COLOR_FADE1         0xE6E6E6E6 // k, l, b
#define COLOR_FADE2         0xC8C8C8C8
#define COLOR_FADE3         0xAAAAAAAA
#define COLOR_FADE4         0x8C8C8C8C
#define COLOR_FADE5         0x6E6E6E6E // --
#define COLOR_PURPLE        0xC2A2DAAA //ME
#define COLOR_DO_BLUE       0xA3A1C8AA //DO


#define DOOR_DEFAULT_COLOR	0xFFFFFFAA


#define DIALOG_LOGIN_GLOBAL 1
#define DIALOG_LOGIN 2
#define DIALOG_REGISTER 3
#define DIALOG_NO_CHARACTERS 4
#define DIALOG_CREATE_GROUPS_1 5
#define DIALOG_CREATE_GROUPS_2 6
#define DIALOG_CREATE_GROUPS_3 7
#define DIALOG_CREATE_GROUPS_4 8
#define DIALOG_GROUPS_LIST_1 9
#define DIALOG_GROUPS_LIST_2 10
#define DIALOG_GROUPS_LIST_3 11

//DIALOG ID 30-39 Vehicles
//DIALOG ID 40-70 Items



#define DUMMY	1000 // tu siê nic nie dzieje

//Drzwi 100-199(id)
#define DIALOG_DOORS_CREATE1	100
#define DIALOG_DOORS_CREATE2	101
#define DIALOG_DOORS_CREATE3	102
#define DIALOG_DOORS			103
#define DIALOG_DOORS_NAME		104
#define DIALOG_DOORS_TEXT		105
#define DIALOG_DOORS_GROUP		106
#define DIALOG_DOORS_BUY		107
#define DIALOG_DOORS_MAGAZINE	108
#define DIALOG_DOORS_FEE		109
#define DIALOG_DOORS_OWNER		110
#define DIALOG_DOORS_FREEZE		111
#define DIALOG_DOORS_MUSIC		112
#define DIALOG_DOORS_TEXT3D		113
#define DIALOG_TELEPORT			114
#define DIALOG_TELEPORT2		115


//type bw
#define BW_OfTheDriver 		1
#define BW_ThePassenger		2
#define BW_MeleeWeapons 	3


//Time bw(x * 60)
#define TIME_BW_OfTheDriver 	13
#define TIME_BW_ThePassenger	15
#define TIME_BW_MeleeWeapons	10


//W-E-A-P-O-N 	S-Y-S-T-E-M
#define GUN_LIMIT 5

#define gun_id 0
#define gun_model 1
#define gun_index 2

#define FIRST_WEAPON		0
#define SECOND_WEAPON		1
#define THIRD_WEAPON		2
#define ADDITIONAL_WEAPON	3


//ITEMS
//value3  = waga;
#define ITEM_WEAPON 	1 //bron (value1 = id_broni | value2 = amunicja | value4 = id_modelu | value5 = dmg | value6 = nazwa magazynka wlozonego | value7 = ilosc max ammo we wlozonym magazynku)
#define ITEM_AMMO 		2 //amunicja (value1 = id broni | value2 = ilosc amunicji)
#define ITEM_MAGAZINE 	3 //iValue1 = id broni, ivalue2 - ilosc amunicji, ivalue5 - maxymalna ilosc amunicji | value6)
#define ITEM_FOOD 		4 //jedzenie(iValue1 = iloœc HP, iValue2 - typ HP)
#define ITEM_CUFFS		5 //none
#define ITEM_PHONE      6 //value1 = numer | value2 = w³¹czony/wy³¹czony | value3 = TODO