/*Lista brakuj�cych rzeczy w drzwiach:
* Niedoko�czona komenda /drzwi I TYLKO TYLE*/

#define TYPE_DOOR		1
#define TYPE_HOUSE		2
#define TYPE_BANKOMAT	3

new Iterator:Doors<MAX_DOORS>;

enum dDoors
{
	dID,
	dName[32],
	dText[64],
	dColor[10],
	dType,
	dEnterVW,
	dEnterInt,
	Float:dEnterX,
	Float:dEnterY,
	Float:dEnterZ,
	dExitVW,
	dExitInt,
	Float:dExitX,
	Float:dExitY,
	Float:dExitZ,
	dPickup,
	dLock,
	dFee,
	dOwner,
	dOwnerType,
	dPickupID,
	dPickupHide,
	dSAMPid,
	dParent,
	dBuy,
	dDrive,
	dFreeze,
	dMagazine
}
new DoorCache[MAX_DOORS][dDoors];

enum intInfo
{
	intUniverse,
	Float:intPozX,
	Float:intPozY,
	Float:intPozZ,
	Float:intPozA,
	intNazwa[64]
};

	new Interiory2[][intInfo] = {
 		{ 4, 291.7626, -80.1306, 1001.5156, 290.2195, "Ammu-nation (version 3)" },
        { 4, 449.0172, -88.9894, 999.5547, 89.6608, "Jay's Diner" },
        { 4, -27.844, -26.6737, 1003.5573, 184.3118, "24/7 (version 5)" },
        { 0, 2135.2004, -2276.2815, 20.6719, 318.59, "Warehouse 3" },
        { 4, 306.1966, 307.819, 1003.3047, 203.1354, "Michelle's Love Nest*" },
        { 10, 24.3769, 1341.1829, 1084.375, 8.3305, "Burglary House X14" },
        { 1, 963.0586, 2159.7563, 1011.0303, 175.313, "Sindacco Abatoir" },
        { 0, 2548.4807, 2823.7429, 10.8203, 270.6003, "K.A.C.C. Military Fuels Depot" },
        { 0, 215.1515, 1874.0579, 13.1406, 177.5538, "Area 69" },
        { 4, 221.6766, 1142.4962, 1082.6094, 184.9618, "Burglary House X13" },
        { 12, 2323.7063, -1147.6509, 1050.7101, 206.5352, "Unused Safe House" },
        { 6, 344.9984, 307.1824, 999.1557, 193.643, "Millie's Bedroom" },
        { 12, 411.9707, -51.9217, 1001.8984, 173.3449, "Barber Shop" },
        { 4, -1421.5618, -663.8262, 1059.5569, 170.9341, "Dirtbike Stadium" },
        { 6, 773.8887, -47.7698, 1000.5859, 10.7161, "Cobra Gym" },
        { 6, 246.6695, 65.8039, 1003.6406, 7.9562, "Los Santos Police Department" },
        { 14, -1864.9434, 55.7325, 1055.5276, 85.8541, "Los Santos Airport" },
        { 4, -262.1759, 1456.6158, 1084.3672, 82.459, "Burglary House X15" },
        { 5, 22.861, 1404.9165, 1084.4297, 349.6158, "Burglary House X16" },
        { 5, 140.3679, 1367.8837, 1083.8621, 349.2372, "Burglary House X17" },
        { 3, 1494.8589, 1306.48, 1093.2953, 196.065, "Bike School" },
        { 14, -1813.213, -58.012, 1058.9641, 335.3199, "Francis International Airport" },
        { 16, -1401.067, 1265.3706, 1039.8672, 178.6483, "Vice Stadium" },
        { 6, 234.2826, 1065.229, 1084.2101, 4.3864, "Burglary House X18" },
        { 6, -68.5145, 1353.8485, 1080.2109, 3.5742, "Burglary House X19" },
        { 6, -2240.1028, 136.973, 1035.4141, 269.0954, "Zero's RC Shop" },
        { 6, 297.144, -109.8702, 1001.5156, 20.2254, "Ammu-nation (version 4)" },
        { 6, 316.5025, -167.6272, 999.5938, 10.3031, "Ammu-nation (version 5)" },
        { 15, -285.2511, 1471.197, 1084.375, 85.6547, "Burglary House X20" },
        { 6, -26.8339, -55.5846, 1003.5469, 3.9528, "24/7 (version 6)" },
        { 6, 442.1295, -52.4782, 999.7167, 177.9394, "Secret Valley Diner" },
        { 2, 2182.2017, 1628.5848, 1043.8723, 224.8601, "Rosenberg's Office in Caligulas" },
        { 6, 748.4623, 1438.2378, 1102.9531, 0.6069, "Fanny Batter's Whore House" },
        { 8, 2807.3604, -1171.7048, 1025.5703, 193.7117, "Colonel Furhberger's" },
        { 9, 366.0002, -9.4338, 1001.8516, 160.528, "Cluckin' Bell" },
        { 1, 2216.1282, -1076.3052, 1050.4844, 86.428, "The Camel's Toe Safehouse" },
        { 1, 2268.5156, 1647.7682, 1084.2344, 99.7331, "Caligula's Roof" },
        { 2, 2236.6997, -1078.9478, 1049.0234, 2.5706, "Old Venturas Strip Casino" },
        { 3, -2031.1196, -115.8287, 1035.1719, 190.1877, "Driving School" },
        { 8, 2365.1089, -1133.0795, 1050.875, 177.3947, "Verdant Bluffs Safehouse" },
        { 0, 1168.512, 1360.1145, 10.9293, 196.5933, "Bike School" },
        { 9, 315.4544, 976.5972, 1960.8511, 359.6368, "Andromada" },
        { 10, 1893.0731, 1017.8958, 31.8828, 86.1044, "Four Dragons' Janitor's Office" },
        { 11, 501.9578, -70.5648, 998.7578, 171.5706, "Bar" },
        { 8, -42.5267, 1408.23, 1084.4297, 172.068, "Burglary House X21" },
        { 11, 2283.3118, 1139.307, 1050.8984, 19.7032, "Willowfield Safehouse" },
        { 9, 84.9244, 1324.2983, 1083.8594, 159.5582, "Burglary House X22" },
        { 9, 260.7421, 1238.2261, 1084.2578, 84.3084, "Burglary House X23" },
        { 0, -1658.1656, 1215.0002, 7.25, 103.9074, "Otto's Autos" },
        { 0, -1961.6281, 295.2378, 35.4688, 264.4891, "Wang Cars" }
	};

	new Interiory[][intInfo] = {
		{ 11, 2003.1178, 1015.1948, 33.008, 351.5789, "Four Dragons' Managerial" },
        { 5, 770.8033, -0.7033, 1000.7267, 22.8599, "Ganton Gym" },
        { 3, 974.0177, -9.5937, 1001.1484, 22.6045, "Brothel" },
        { 3, 961.9308, -51.9071, 1001.1172, 95.5381, "Brothel2" },
        { 3, 830.6016, 5.9404, 1004.1797, 125.8149, "Inside Track Betting" },
        { 3, 1037.8276, 0.397, 1001.2845, 353.9335, "Blastin' Fools Records" },
        { 3, 1212.1489, -28.5388, 1000.9531, 170.5692, "The Big Spread Ranch" },
        { 18, 1290.4106, 1.9512, 1001.0201, 179.9419, "Warehouse 1" },
        { 1, 1412.1472, -2.2836, 1000.9241, 114.661, "Warehouse 2" },
        { 3, 1527.0468, -12.0236, 1002.0971, 350.0013, "B Dup's Apartment" },
        { 2, 1523.5098, -47.8211, 1002.2699, 262.7038, "B Dup's Crack Palace" },
        { 3, 612.2191, -123.9028, 997.9922, 266.5704, "Wheel Arch Angels" },
        { 3, 512.9291, -11.6929, 1001.5653, 198.7669, "OG Loc's House" },
        { 3, 418.4666, -80.4595, 1001.8047, 343.2358, "Barber Shop" },
        { 3, 386.5259, 173.6381, 1008.3828, 63.7399, "Planning Department" },
        { 3, 288.4723, 170.0647, 1007.1794, 22.0477, "Las Venturas Police Department" },
        { 3, 206.4627, -137.7076, 1003.0938, 10.9347, "Pro-Laps" },
        { 3, -100.2674, -22.9376, 1000.7188, 17.285, "Sex Shop" },
        { 3, -201.2236, -43.2465, 1002.2734, 45.8613, "Las Venturas Tattoo parlor" },
        { 17, -202.9381, -6.7006, 1002.2734, 204.2693, "Lost San Fierro Tattoo parlor" },
        { 17, -25.7220, -187.8216, 1003.5469, 5.0760, "24/7 (version 1)" },
        { 5, 454.9853, -107.2548, 999.4376, 309.0195, "Diner 1" },
        { 5, 372.5565, -131.3607, 1001.4922, 354.2285, "Pizza Stack" },
        { 17, 378.026, -190.5155, 1000.6328, 141.0245, "Rusty Brown's Donuts" },
        { 7, 315.244, -140.8858, 999.6016, 7.4226, "Ammu-nation" },
        { 5, 225.0306, -9.1838, 1002.218, 85.5322, "Victim" },
        { 2, 611.3536, -77.5574, 997.9995, 320.9263, "Loco Low Co" },
        { 10, 246.0688, 108.9703, 1003.2188, 0.2922, "San Fierro Police Department" },
        { 10, 6.0856, -28.8966, 1003.5494, 5.0365, "24/7 (version 2 - large)" },
        { 7, 773.7318, -74.6957, 1000.6542, 5.2304, "Below The Belt Gymr" },
        { 1, 621.4528, -23.7289, 1000.9219, 15.6789, "Transfenders" },
        { 1, 445.6003, -6.9823, 1000.7344, 172.2105, "World of Coq" },
        { 1, 285.8361, -39.0166, 1001.5156, 0.7529, "Ammu-nation (version 2)" },
        { 1, 204.1174, -46.8047, 1001.8047, 357.5777, "SubUrban" },
        { 1, 245.2307, 304.7632, 999.1484, 273.4364, "Denise's Bedroom" },
        { 3, 290.623, 309.0622, 999.1484, 89.9164, "Helena's Barn" },
        { 5, 322.5014, 303.6906, 999.1484, 8.1747, "Barbara's Love nest" },
        { 1, -2041.2334, 178.3969, 28.8465, 156.2153, "San Fierro Garage" },
        { 1, -1402.6613, 106.3897, 1032.2734, 105.1356, "Oval Stadium" },
        { 7, -1403.0116, -250.4526, 1043.5341, 355.8576, "8-Track Stadium" },
        { 2, 1204.6689, -13.5429, 1000.9219, 350.0204, "The Pig Pen (strip club 2)" },
        { 10, 2016.1156, 1017.1541, 996.875, 88.0055, "Four Dragons" },
        { 1, -741.8495, 493.0036, 1371.9766, 71.7782, "Liberty City" },
        { 2, 2447.8704, -1704.4509, 1013.5078, 314.5253, "Ryder's house" },
        { 1, 2527.0176, -1679.2076, 1015.4986, 260.9709, "Sweet's House" },
        { 10, -1129.8909, 1057.5424, 1346.4141, 274.5268, "RC Battlefield" },
        { 3, 2496.0549, -1695.1749, 1014.7422, 179.2174, "The Johnson House" },
        { 10, 366.0248, -73.3478, 1001.5078, 292.0084, "Burger shot" },
        { 1, 2233.9363, 1711.8038, 1011.6312, 184.3891, "Caligula's Casino" },
        { 2, 269.6405, 305.9512, 999.1484, 215.6625, "Katie's Lovenest" },
        { 2, 414.2987, -18.8044, 1001.8047, 41.4265, "Barber Shop 2 (Reece's)" },
        { 2, 1.1853, -3.2387, 999.4284, 87.5718, "Angel \"Pine Trailer\"" },
        { 18, -30.9875, -89.6806, 1003.5469, 359.8401, "24/7 (version 3)" },
        { 18, 161.4048, -94.2416, 1001.8047, 0.7938, "Zip" },
        { 3, -2638.8232, 1407.3395, 906.4609, 94.6794, "The Pleasure Domes" },
        { 5, 1267.8407, -776.9587, 1091.9063, 231.3418, "Madd Dogg's Mansion" },
        { 2, 2536.5322, -1294.8425, 1044.125, 254.9548, "Big Smoke's Crack Palace" },
        { 5, 2350.1597, -1181.0658, 1027.9766, 99.1864, "Burning Desire Building" },
        { 1, -2158.6731, 642.09, 1052.375, 86.5402, "Wu-Zi Mu's" },
        { 10, 419.8936, 2537.1155, 10.0, 67.6537, "Abandoned AC tower" },
        { 14, 256.9047, -41.6537, 1002.0234, 85.8774, "Wardrobe/Changing room" },
        { 14, 204.1658, -165.7678, 1000.5234, 181.7583, "Didier Sachs" },
        { 12, 1133.35, -7.8462, 1000.6797, 165.8482, "Casino (Redsands West)" },
        { 14, -1420.4277, 1616.9221, 1052.5313, 159.1255, "Kickstart Stadium" },
        { 17, 493.1443, -24.2607, 1000.6797, 356.9864, "Club" },
        { 18, 1727.2853, -1642.9451, 20.2254, 172.4193, "Atrium" },
        { 16, -202.842, -24.0325, 1002.2734, 252.8154, "Los Santos Tattoo Parlor" },
        { 5, 2233.6919, -1112.8107, 1050.8828, 8.6483, "Safe House group 1" },
        { 6, 1211.2484, 1049.0234, 359.941, 170.9341, "Safe House group 2" },
        { 9, 2319.1272, -1023.9562, 1050.2109, 167.3959, "Safe House group 3" },
        { 10, 2261.0977, -1137.8833, 1050.6328, 266.88, "Safe House group 4" },
        { 17, -944.2402, 1886.1536, 5.0051, 179.8548, "Sherman Dam" },
        { 16, -26.1856, -140.9164, 1003.5469, 2.9087, "24/7 (version 4)" },
        { 15, 2217.281, -1150.5349, 1025.7969, 273.7328, "Jefferson Motel" },
        { 1, 1.5491, 23.3183, 1199.5938, 359.9054, "Jet Interior" },
        { 1, 681.6216, -451.8933, -25.6172, 166.166, "The Welcome Pump" },
        { 3, 234.6087, 1187.8195, 1080.2578, 349.4844, "Burglary House X1" },
        { 2, 225.5707, 1240.0643, 1082.1406, 96.2852, "Burglary House X2" },
        { 1, 224.288, 1289.1907, 1082.1406, 359.868, "Burglary House X3" },
        { 5, 239.2819, 1114.1991, 1080.9922, 270.2654, "Burglary House X4" },
        { 15, 207.5219, -109.7448, 1005.1328, 358.62, "Binco" },
        { 15, 295.1391, 1473.3719, 1080.2578, 352.9526, "4 Burglary houses" },
        { 15, -1417.8927, 932.4482, 1041.5313, 0.7013, "Blood Bowl Stadium" },
        { 12, 446.3247, 509.9662, 1001.4195, 330.5671, "Budget Inn Motel Room" },
        { 0, 2306.3826, -15.2365, 26.7496, 274.49, "Palamino Bank" },
        { 0, 2331.8984, 6.7816, 26.5032, 100.2357, "Palamino Diner" },
        { 0, 663.0588, -573.6274, 16.3359, 264.9829, "Dillimore Gas Station" },
        { 18, -227.5703, 1401.5544, 27.7656, 269.2978, "Lil' Probe Inn" },
        { 0, -688.1496, 942.0826, 13.6328, 177.6574, "Torreno's Ranch" },
        { 0, -1916.1268, 714.8617, 46.5625, 152.2839, "Zombotech - lobby area" },
        { 0, 818.7714, -1102.8689, 25.794, 91.1439, "Crypt in LS cemetery (temple)" },
        { 0, 255.2083, -59.6753, 1.5703, 1.4645, "Blueberry Liquor Store" },
        { 2, 446.626, 1397.738, 1084.3047, 343.9647, "Pair of Burglary Houses" },
        { 5, 227.3922, 1114.6572, 1080.9985, 267.459, "Crack Den" },
        { 5, 227.7559, 1114.3844, 1080.9922, 266.2624, "Burglary House X11" },
        { 4, 261.1165, 1287.2197, 1080.2578, 178.9149, "Burglary House X12" }
	};
	

stock GetFreeIndexDoors()
{
	for(new i = 1; i < MAX_DOORS; i++)
	{
		if(DoorCache[i][dID] == 0) return i;
	}
	return 0;
}	

stock GetDoorIndexByUID(uid)
{
	foreach(new i : Doors)
	{
		if(DoorCache[i][dID] == uid) return i;
	}
	return 0;
}

	
CallBack:CreateDoors(name[], type, entervw, enterint, Float:enterx, Float:entery, Float:enterz, exitvw, exitint, Float:exitx, Float:exity, Float:exitz, parent)
{
	new sql[ 512 ];
	format(sql, sizeof(sql), "INSERT INTO "prefix"doors\
	(`name` ,\
	`text` ,\
	`color` ,\
	`type` ,\
	`enterVw`,\
	`enterInt`,\
	`enterX`,\
	`enterY`,\
	`enterZ`,\
	`exitVw`,\
	`exitInt`,\
	`exitX`,\
	`exitY`,\
	`exitZ`,\
	`pickup`,\
	`lock`,\
	`fee`,\
	`owner`,\
	`ownertype`,\
	`pickuphide`,\
	`parent`,\
	`buy`,\
	`drive`,\
	`freeze`,\
	`magazine`)\
	VALUES ('%s', '%s', '0xFFFFFFAA', '%d', '%d', '%d', '%f', '%f', '%f', '%d', '%d', '%f', '%f', '%f', '1239', '0', '0', '0', '0', '0', '%d', '0', '0', '0', '0')",
	name, name, type, entervw, enterint, enterx, entery, enterz, exitvw, exitint, exitx, exity, exitz, parent);
	mysql_query(sql);
	if( mysql_errno( ) ) print( sql );

	new uid = GetFreeIndexDoors();

	//DoorCache[uid][dID] = uid;
	format(DoorCache[uid][dName], 32, name);
	format(DoorCache[uid][dText], 64, name);
	format(DoorCache[uid][dColor], 10, "0xFFFFFFAA");
	DoorCache[uid][dType] = type;
	DoorCache[uid][dEnterVW] = entervw;
	DoorCache[uid][dEnterInt] = enterint;
	DoorCache[uid][dEnterX] = enterx;
	DoorCache[uid][dEnterY] = entery;
	DoorCache[uid][dEnterZ] = enterz;
	DoorCache[uid][dExitVW] = exitvw;
	DoorCache[uid][dExitInt] = exitint;
	DoorCache[uid][dExitX] = exitx;
	DoorCache[uid][dExitY] = exity;
	DoorCache[uid][dExitZ] = exitz;
	DoorCache[uid][dPickup] = 1239;
	DoorCache[uid][dLock] = 0;
	DoorCache[uid][dFee] = 0;
	DoorCache[uid][dOwner] = 0;
	DoorCache[uid][dOwnerType] = 0;
	DoorCache[uid][dPickupHide] = 0;
	DoorCache[uid][dParent] = parent;
	DoorCache[uid][dBuy] = 0;
	DoorCache[uid][dDrive] = 0;
	DoorCache[uid][dFreeze] = 0;
	DoorCache[uid][dMagazine] = 0;
	
	//if(DoorCache[uid][dPickupHide] == 0) 
	
	DoorCache[uid][dPickupID] = CreatePickup(DoorCache[uid][dPickup], 1, DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ], DoorCache[uid][dEnterVW]);
	Iter_Add(Doors, uid);
	mysql_free_result();
	return uid;
}

CallBack:LoadDoors()
{
	new result[512], uid = 1;
	mysql_query("SELECT * FROM `"prefix"doors`");
	mysql_store_result();
	while(mysql_fetch_row_format(result))
	{
		sscanf(result,  "p<|>ds[32]s[64]s[10]dddfffddfffddddddddddd", 		
		DoorCache[uid][dID],
		DoorCache[uid][dName],
		DoorCache[uid][dText],
		DoorCache[uid][dColor],
		DoorCache[uid][dType],
		DoorCache[uid][dEnterVW],
		DoorCache[uid][dEnterInt],
		DoorCache[uid][dEnterX],
		DoorCache[uid][dEnterY],
		DoorCache[uid][dEnterZ],
		DoorCache[uid][dExitVW],
		DoorCache[uid][dExitInt],
		DoorCache[uid][dExitX],
		DoorCache[uid][dExitY],
		DoorCache[uid][dExitZ],
		DoorCache[uid][dPickup],
		DoorCache[uid][dLock],
		DoorCache[uid][dFee],
		DoorCache[uid][dOwner],
		DoorCache[uid][dOwnerType],
		DoorCache[uid][dPickupHide],
		DoorCache[uid][dParent],
		DoorCache[uid][dBuy],
		DoorCache[uid][dDrive],
		DoorCache[uid][dFreeze],
		DoorCache[uid][dMagazine]);	
		
		//if(DoorCache[uid][dPickupHide] == 0) 
		

		DoorCache[uid][dPickupID] = CreatePickup(DoorCache[uid][dPickup], 1, DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ], DoorCache[uid][dEnterVW]);	
		Iter_Add(Doors, uid);
		
		printf("%s [%f, %f, %f] [%f, %f, %f] %d", DoorCache[uid][dName], DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ], DoorCache[uid][dExitX], DoorCache[uid][dExitY], DoorCache[uid][dExitZ], DoorCache[uid][dMagazine]);
		uid++;
	}
	printf("##[DOORS] Loaded count: %d", uid);
	mysql_free_result();
	return 1;
}

CallBack:SaveDoors(uid)
{
	new sql[512];
	format(sql, 512, "UPDATE `"prefix"doors` SET `name`='%s', `text`='%s', `color`='%s', `type`='%d', `enterVw`='%d', `enterInt`='%d', `enterX`='%f',\
	`enterY`='%f', `enterZ`='%f', `exitVw`='%d', `exitInt`='%d', `exitX`='%f', `exitY`='%f', `exitZ`='%f', `pickup`='%d', `lock`='%d', `fee`='%d',\
	`owner`='%d', `ownertype`='%d', `pickuphide`='%d', `parent`='%d', `buy`='%d', `drive`='%d', `freeze`='%d', `magazine`='%d' WHERE `id`='%d'",
	DoorCache[uid][dName], DoorCache[uid][dText], DoorCache[uid][dColor], DoorCache[uid][dType],
	DoorCache[uid][dEnterVW], DoorCache[uid][dEnterInt], DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ],
	DoorCache[uid][dExitVW], DoorCache[uid][dExitInt], DoorCache[uid][dExitX], DoorCache[uid][dExitZ], DoorCache[uid][dPickup], DoorCache[uid][dLock], 
	DoorCache[uid][dFee], DoorCache[uid][dOwner], DoorCache[uid][dOwnerType], DoorCache[uid][dPickupHide], DoorCache[uid][dParent], DoorCache[uid][dBuy], DoorCache[uid][dDrive],
	DoorCache[uid][dFreeze], DoorCache[uid][dMagazine], uid);
	mysql_query(sql);
	return 1;
}

CallBack:DeleteDoors(id)
{
	new sql[256];
	format(sql, 256, "DELETE FROM `doors` WHERE `id`='%d'", id);
	mysql_query(sql);
	
	new uid = GetDoorIndexByUID(id);

	DoorCache[uid][dID] = 0;
	DoorCache[uid][dType] = 0;
	DoorCache[uid][dEnterVW] = 0;
	DoorCache[uid][dEnterInt] = 0;
	DoorCache[uid][dEnterX] = 0;
	DoorCache[uid][dEnterY] = 0;
	DoorCache[uid][dEnterZ] = 0;
	DoorCache[uid][dExitVW] = 0;
	DoorCache[uid][dExitInt] = 0;
	DoorCache[uid][dExitX] = 0;
	DoorCache[uid][dExitY] = 0;
	DoorCache[uid][dExitZ] = 0;
	DoorCache[uid][dPickup] = 0;
	DoorCache[uid][dLock] = 0;
	DoorCache[uid][dFee] = 0;
	DoorCache[uid][dOwner] = 0;
	DoorCache[uid][dOwnerType] = 0;
	DoorCache[uid][dPickupHide] = 0;
	DoorCache[uid][dParent] = 0;
	
	DestroyPickup(DoorCache[uid][dPickupID]);
	
	Iter_Remove(Doors, uid);
	
	printf("[MYSQL] DOOR[ID:%d] deleted", uid);
	return 1;
}

CallBack:OnPlayerEnterDoors(playerid, uid)
{
	if(!DoorCache[uid][dLock])
	{
		if(!Player[playerid][Admin])
		{
		    if(GetPlayerMoney(playerid) >= DoorCache[uid][dFee])
		    {
		        GivePlayerMoney(playerid, -DoorCache[uid][dFee]);
				//GiveGroupCashFromDoors(id, Drzwi[id][dFee]);
	    		SetPlayerPos( playerid, DoorCache[uid][dExitX], DoorCache[uid][dExitY], DoorCache[uid][dExitZ]);
	    		SetPlayerInterior(playerid, DoorCache[uid][dExitInt]);
	    		SetPlayerVirtualWorld(playerid, DoorCache[uid][dExitVW]);
				/*if(DoorCache[uid][dFreeze])
				{
					TogglePlayerControllable(playerid, 0);
					SetTimerEx("DoorFreeze", 5000, 0, "d", playerid);
				}*/
	    		Player[playerid][Door] = uid;
			}
			else
			    return DInfo(playerid, "Nie sta� Ci� na wej�cie do �rodka.");
		}
		else
		{
	    	SetPlayerPos( playerid, DoorCache[uid][dExitX], DoorCache[uid][dExitY], DoorCache[uid][dExitZ]);
	    	SetPlayerInterior(playerid, DoorCache[uid][dExitInt]);
	    	SetPlayerVirtualWorld(playerid, DoorCache[uid][dExitVW]);			
	    	Player[playerid][Door] = uid;
		}
	}
	else
	{
	    if(Player[playerid][Admin])
	    {
	    	SetPlayerPos( playerid, DoorCache[uid][dExitX], DoorCache[uid][dExitY], DoorCache[uid][dExitZ]);
	    	SetPlayerInterior(playerid, DoorCache[uid][dExitInt]);
	    	SetPlayerVirtualWorld(playerid, DoorCache[uid][dExitVW]);			
	    	Player[playerid][Door] = uid;
		}
		else DInfo(playerid, "Drzwi s� zamkni�te.");
	}
	return 1;
}

CallBack:OnPlayerExitDoors(playerid, uid)
{
	if(!DoorCache[uid][dLock])
	{
	    SetPlayerPos( playerid, DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ]);
	    SetPlayerInterior(playerid, DoorCache[uid][dEnterInt]);
	    SetPlayerVirtualWorld(playerid, DoorCache[uid][dEnterVW]);		
		new parent = DoorCache[uid][dParent];
	    Player[playerid][Door] = parent;
	}
	else
	{
	    if(Player[playerid][Admin])
	    {
			SetPlayerPos( playerid, DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ]);
			SetPlayerInterior(playerid, DoorCache[uid][dEnterInt]);
			SetPlayerVirtualWorld(playerid, DoorCache[uid][dEnterVW]);		
			new parent = DoorCache[uid][dParent];
			Player[playerid][Door] = parent;
		}
		else DInfo(playerid, "Drzwi s� zamkni�te.");
	}
	return 1;
}

CallBack:DoorFreeze(playerid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}

stock ShowDoorTextDraw(playerid, uid)
{
	//drzwitd[i] = TextDrawCreate(445.500000, 196.583358, "~b~Drzwi ~w~Testowe~n~~n~~g~Koszt wejscia: ~w~ 20$~n~Wcisnij klawisz ~y~sprintu~w~ aby wejsc");
	new str[512];
	if(DoorCache[uid][dLock] == 0)
	{
		format(str, 512, "~b~%s~n~~n~~g~Koszt wejscia: ~w~ %d$~n~Wcisnij klawisz ~y~sprintu~w~ aby wejsc",
		DoorCache[uid][dText], DoorCache[uid][dFee]);
	}
	else
	{
		format(str, 512, "~b~%s~n~~n~~g~Koszt wejscia: ~w~ %d$~n~~r~ZAMKNIETE",
		DoorCache[uid][dText], DoorCache[uid][dFee]);
	}
	PlayerTextDrawSetString(playerid, drzwitd[playerid], str);
	PlayerTextDrawShow(playerid, drzwitd[playerid]);
	SetTimerEx("DrzwiTD", 5000, 1, "d", playerid);
	return 1;
}

CallBack:DrzwiTD(playerid)
{
	PlayerTextDrawHide(playerid, drzwitd[playerid]);
	return 1;
}

CMD:drzwi(playerid, params[])
{
	new opcja[16];
	new drzwi = Player[playerid][Door];
	if(sscanf(params, "s[16]", opcja))
	{
    	if(Player[playerid][Admin] >= 3)
	    {
			if(drzwi)
			{
	        	ShowPlayerDialog(playerid, DIALOG_DOORS, DIALOG_STYLE_LIST, "{4876FF}Drzwi{a9c4e4} � Edycja � Lista",
	        	"1.\tZmie� nazw� systemow�\n\
	        	2.\tZmie� nazw� wy�wietlan�\n\
	        	3.\tWy�wietl informacje\n\
	        	4.\tPrzypisz pod grup�\n\
				5.\tW��cz / wy��cz samoobs�ug�\n\
				6.\tW��cz / wy��cz przejazd\n\
				7.\tSchowek\n\
				8.\tKoszt wej�cia\n\
				9.\tUstaw w�a�ciciela\n\
				10.\tZamra�aj przy wej�ciu\n\
				11.\tUstaw muzyk�\n\
				12.\tUstaw tekst na drzwiach", "Wybierz", "Anuluj");
			}
		}
		else
		{
			if(DoorCache[drzwi][dOwner] == Player[playerid][UID])
			{
		    	ShowPlayerDialog(playerid, DIALOG_DOORS, DIALOG_STYLE_LIST, "{4876FF}Drzwi{a9c4e4} � Edycja � Lista",
		    	"2.\tZmie� nazw� wy�wietlan�\n\
	        	3.\tWy�wietl informacje\n\
	        	4.\tPrzypisz pod grup�\n\
				5.\tW��cz / wy��cz samoobs�ug�\n\
				6.\tW��cz / wy��cz przejazd\n\
				7.\tSchowek\n\
				8.\tKoszt wej�cia\n\
				9.\tUstaw w�a�ciciela\n\
				10.\tZamra�aj przy wej�ciu\n\
				11.\tUstaw muzyk�\n\
				12.\tUstaw tekst na drzwiach", "Wybierz", "Anuluj");
			}
			else DInfo(playerid, "Nie znajdujesz si� w budynku, kt�ry mo�esz edytowa�.");
		}
	}
	else
	{
	    if(!strcmp(opcja, "zamknij", true))
	    {
			foreach(new uid : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 5.0, DoorCache[uid][dEnterX], DoorCache[uid][dEnterY], DoorCache[uid][dEnterZ]) ||
				IsPlayerInRangeOfPoint(playerid, 5.0, DoorCache[uid][dExitX], DoorCache[uid][dExitY], DoorCache[uid][dExitZ]))
				{
					if(Player[playerid][Admin] >= 1 || DoorCache[uid][dOwner] == Player[playerid][UID])
					{
						if(DoorCache[uid][dLock] == 0)
						{
							ServerMe(playerid, "zamyka drzwi na klucz.");
							DoorCache[uid][dLock] = 1;
							SaveDoors(uid);
						}
						else
						{
							ServerMe(playerid, "otwiera drzwi kluczem.");
							DoorCache[uid][dLock] = 0;
							SaveDoors(uid);
						}
					}
				}

			}
		}
	}
	return 1;
}

CMD:adoors(playerid, params[])
{
	if(Player[playerid][Admin] < 3) return DInfo(playerid, "ERROR[403]: Forbidden\n{FF0000}Brak uprawnie� do komendy");
	new	typ[32], reszta[128];
	if(sscanf(params, "s[32]S()[128]", typ, reszta))
	{
		DInfo(playerid, "Wskaz�wka[/adoors]:\nstworz, usun, pickup, entervw, exitvw");
		return 1;
	}
	else if(!strcmp(typ, "stworz", true))
	{
		if(!TworzenieDrzwi[playerid])
		{
			ShowPlayerDialog(playerid, DUMMY, DIALOG_STYLE_MSGBOX, "Tworzenie drzwi", "Znajdujesz si� aktualnie w kreatorze drzwi. Po zamkni�ciu tego komunikatu, udaj si� do punktu, gdzie drzwi maj� prowadzi�.\nInteriory znajdziesz pod komend�: {FF0000}/interiors{FFFFFF}.\nGdy b�dziesz ju� w miejscu wej�cia, wpisz: {FF0000}/adoors stworz{FFFFFF}.",
			"Ok", "Anuluj");
			TworzenieDrzwi[playerid] = true;
			new Float:xx, Float:yy, Float:zz;
			GetPlayerPos(playerid, xx, yy, zz);
			SetPVarInt(playerid, "TworzenieDrzwiVW2", GetPlayerVirtualWorld(playerid));
			SetPVarFloat(playerid, "TworzenieDrzwiX2", xx);
			SetPVarFloat(playerid, "TworzenieDrzwiY2", yy);
			SetPVarFloat(playerid, "TworzenieDrzwiZ2", zz);
			SetPVarFloat(playerid, "TworzenieDrzwiInt2", GetPlayerInterior(playerid));
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_DOORS_CREATE1, DIALOG_STYLE_INPUT, ""DIALOG_SERVER_NAME" Tworzenie drzwi", "Wpisz poni�ej nazwe drzwi\nNp.: 24/7 Mullholand", "Dalej", "Anuluj");
			new Float:xx, Float:yy, Float:zz;
			GetPlayerPos(playerid, xx, yy, zz);
			SetPVarInt(playerid, "TworzenieDrzwiVW", GetPlayerVirtualWorld(playerid));
			SetPVarFloat(playerid, "TworzenieDrzwiX", xx);
			SetPVarFloat(playerid, "TworzenieDrzwiY", yy);
			SetPVarFloat(playerid, "TworzenieDrzwiZ", zz);
			SetPVarFloat(playerid, "TworzenieDrzwiInt", GetPlayerInterior(playerid));
			TworzenieDrzwi[playerid] = false;
		}	
	}
	else if(!strcmp(typ, "usun", true))
	{
		new uid;
		if(sscanf(reszta, "d", uid))
		{
			DInfo(playerid, "/adoors usun [uid]");
			return 1;
		}
		else
		{
			new index = GetDoorIndexByUID(uid);
			DeleteDoors(uid);
			new string[128];
			format(string, 128, "Usun��e� drzwi %s[%d]", DoorCache[index][dName], uid);
			DInfo(playerid, string);
		}
	}
	else if(!strcmp(typ, "pickup", true))
	{
		new uid, pickupid;
		if(sscanf(reszta, "dd", uid, pickupid))
		{
			DInfo(playerid, "/adoors pickup [uid] [pickupid]");
			return 1;
		}
		else
		{
			new index = GetDoorIndexByUID(uid);
			DoorCache[index][dPickupID] = pickupid;
			SaveDoors(uid);
			DInfo(playerid, "Zmieni�e� pickupa drzwi.");
		}
	}
	else if(!strcmp(typ, "entervw", true))
	{
		new uid, vw;
		if(sscanf(reszta, "dd", uid, vw))
		{
			DInfo(playerid, "/adoors entervw [uid] [vw]");
			return 1;
		}
		else
		{
			new index = GetDoorIndexByUID(uid);
			DoorCache[index][dEnterVW] = vw;
			SaveDoors(uid);
			DInfo(playerid, "Zmieni�e� Virtual World wej�cia drzwi.");
		}
	}
	else if(!strcmp(typ, "exitvw", true))
	{
		new uid, vw;
		if(sscanf(reszta, "dd", uid, vw))
		{
			DInfo(playerid, "/adoors exitvw [uid] [vw]");
			return 1;
		}
		else
		{
			new index = GetDoorIndexByUID(uid);
			DoorCache[index][dExitVW] = vw;
			SaveDoors(uid);
			DInfo(playerid, "Zmieni�e� Virtual World wyj�cia drzwi.");
		}
	}
	else if(!strcmp(typ, "zmienna", true))
	{
		BSRPDialog(playerid, DUMMY, DIALOG_STYLE_MSGBOX, "Drzwi", "Info", Player[playerid][Door], "Ok", "Anuluj");
	}
	return 1;
}

CMD:interiors( playerid, cmdtext[ ] )
{
	new
		big_str[ 2048 ]
	;
	
	for( new i = 1; i < sizeof( Interiory ); i++ )
	    format( big_str, sizeof( big_str ), "%s\n%d\t\t%s", big_str, i, Interiory[ i ][ intNazwa ] );
	    
	ShowPlayerDialog( playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Interiory",
	big_str, "Teleportuj", "Dalej" );
	
	return 1;
}