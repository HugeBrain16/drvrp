/*
	DeathRow Vatos RolePlay
	An abandoned SA:MP gamemode source from like a year ago

	Author: HugeBrain16
	Project url: https://github.com/HugeBrain16/drvrp
*/

/*
	if i can't find any libraries that i use when i was developing this gamemode
	i will just put the include or plugin files that i use to `plugins` or `include` folder
	because i found most of them on SA:MP forums that is no longer available
*/

#include <a_samp> /* samp-stdlib */
#include <float> /* pawn-stdlib */
#include <izcmd> /* https://github.com/YashasSamaga/I-ZCMD */
#include <Dini> /* https://dracoblue.net/files/dini_1_6.zip */
#include <alogger>

/* YSI Config*/
#define YSI_NO_HEAP_MALLOC
#define YSI_NO_MODE_CACHE

/* YSI */
/* https://github.com/pawn-lang/YSI-Includes */
#include <YSI_Storage\y_ini>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_malloc>
//#include <YSI_Core\y_utils>
//#include <YSI_Extra\y_files>

#include <streamer> /* https://github.com/samp-incognito/samp-streamer-plugin */
#include <color>
#include <sscanf2> /* https://github.com/Y-Less/sscanf */
#include <regex>
#include <uf> /* https://github.com/Kaperstone/uf.inc */
#include <EVF>
#include <mSelection>
#include <foreach> /* https://github.com/karimcambridge/samp-foreach/blob/master/foreach.inc */
#include <jit> /* https://github.com/Zeex/samp-plugin-jit */

/* Server Config */

#define NO_CALL

/* EOS */

/* Useful Definition */
#define func:%0(%1) forward %0(%1); public %0(%1)
#define VERSION "1.0.0-beta"

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define PRESSING(%0,%1) \
	(%0 & (%1))

	/* Body Parts */
#define BODY_PART_TORSO 3
#define BODY_PART_GROIN 4
#define BODY_PART_LEFT_ARM 5
#define BODY_PART_RIGHT_ARM 6
#define BODY_PART_RIGHT_LEG 8
#define BODY_PART_LEFT_LEG 7
#define BODY_PART_HEAD 9

/* Definition */
#define PLAYER_ACCOUNT "drvrp/player/account/%s.ini"
#define PLAYER_ACCS "drvrp/player/accs/%s/%d.ini"
#define PLAYER_ACCS_DIR "drvrp/player/accs/%s"
#define PLAYER_INVENTORY "drvrp/player/inventory/%s.ini"
#define PLAYER_FOOD "drvrp/player/food/%s.ini"
#define PLAYER_STATS "drvrp/player/stats/%s.ini"
#define PLAYER_STATUS "drvrp/player/status/%s.ini"
#define PLAYER_POSITION "drvrp/player/position/%s.ini"
#define PLAYER_VEHICLE "drvrp/player/vehicle/%s.ini"
#define PLAYER_INTERIOR	"drvrp/player/interior/%s.ini"
#define PLAYER_WEAPON "drvrp/player/weapon/%s.ini"
#define PLAYER_PHONE "drvrp/player/phone/%s.ini"
#define PLAYER_PHONE_SMS "drvrp/player/phone/sms/%s.ini"
#define PLAYER_JOB "drvrp/player/job/%s.ini"

#define BIZ_ELECTRONIC "drvrp/server/business/electronic/%d.ini"
#define BIZ_TOOL "drvrp/server/business/tool/%d.ini"
#define BIZ_CLOTHES	"drvrp/server/business/clothes/%d.ini"
#define BIZ_RESTAURANT "drvrp/server/business/restaurant/%d.ini"

#define PHONE_NUMBER_DIR "drvrp/server/number/%d"
#define AD_LOG_DIR "drvrp/server/log/ad.ini"
#define PM_LOG_DIR "drvrp/server/log/pm.log"
#define CMD_LOGFILE_PATH "drvrp/server/log/commands.log"
#define CHANNEL_DIR "drvrp/server/channel.ini"
#define TICKET_DIR "drvrp/server/ticket.txt"

/* model selection Definition */
#define MODEL_DATA_SKIN "drvrp/server/modeldata/skin.txt"
#define MODEL_DATA_DUTYSKIN_MECHANIC "drvrp/server/modeldata/dutyskin/mechanic.txt"
#define MODEL_DATA_MECHANIC_TUNE_WHEEL "/drvrp/server/modeldata/job-feature/mechanic/tune/wheel.txt"

/* dialog Definition */
#define DIALOG_LOGIN 0
#define DIALOG_REGISTER 1
#define DIALOG_MAKEGUN 2
#define DIALOG_SWEEPER_INFO 3
#define DIALOG_SPAREPART 4
#define DIALOG_BIZINFO 5
#define DIALOG_SHOP_ELECTRONIC 6
#define DIALOG_PHONE 7
#define DIALOG_PHONE_CALL 8
#define DIALOG_PHONE_BUYCREDIT 9
#define DIALOG_PHONE_SMS 10
#define DIALOG_PHONE_AD 11
#define DIALOG_RESTOCK_ELECTRONIC 12
#define DIALOG_BOOMBOX_SET 13
#define DIALOG_SPRICE_ELECTRONIC 14
#define DIALOG_SPRICE_ELECTRONIC_PHONE 15
#define DIALOG_SPRICE_ELECTRONIC_BOOMBOX 16
#define DIALOG_SPRICE_CLOTHES 17
#define DIALOG_MECHANIC_TUNE 18
#define DIALOG_BUS_INFO 19
#define DIALOG_BUS_ROUTE 20
#define DIALOG_PHONE_AD_LOG 21
#define DIALOG_MOWER_INFO 22
#define DIALOG_LOG_PM 23
#define DIALOG_WEAPON 24
#define DIALOG_WEAPON_EQUIP 25
#define DIALOG_MAKEAMMO 26
#define DIALOG_REPAIRGUN 27
#define DIALOG_WEAPON_DISCARD 28
#define DIALOG_SELL_BIZ 29
#define DIALOG_TICKET 30
#define DIALOG_DEALERSHIP 31
#define DIALOG_DEALERSHIP_SELECT 32
#define DIALOG_ACCS_INDEX 33
#define DIALOG_ACCS_OPT 34
#define DIALOG_ACCS_EDIT 35
#define DIALOG_ACCS_BUY 36
#define DIALOG_ACCS_EDIT_BONES 37
#define DIALOG_CHECKENG 38
#define DIALOG_SELLVEH 39
#define DIALOG_TRADEVEH 40
#define DIALOG_SEARCHID 41
#define DIALOG_SPRICE_TOOL 42
#define DIALOG_SPRICE_TOOL_SCREW 43
#define DIALOG_SPRICE_TOOL_ROD 44
#define DIALOG_SPRICE_TOOL_REPAIRKIT 45
#define DIALOG_RESTOCK_TOOL 46
#define DIALOG_SHOP_TOOL 47
#define DIALOG_TOOL 48
#define DIALOG_FOOD 49
#define DIALOG_SHOP_RESTAURANT 50
#define DIALOG_STATUS 51

/* Limit */
#define MAX_ZONE 1000
#define MAX_STORE 1000
#define MAX_RESTAURANT 1000
#define MAX_ELECTRONIC 1000
#define MAX_TOOL 1000
#define MAX_CLOTHES 1000
#define MAX_PHONE_NUMBER 99999999
#define MAX_RENTVEH_FAGGIO 5000
#define MAX_WEAPON_DROP 1000
#define MAX_TICKET 500
#define MAX_ACCS 10
#define MAX_MONEY_DROP 1000

/* Define From Other Script */
#define COLOR_FADE1 (0xE6E6E6E6)
#define COLOR_FADE2 (0xC8C8C8C8)
#define COLOR_FADE3 (0xAAAAAAAA)
#define COLOR_FADE4 (0x8C8C8C8C)

/* Service Number */
#define NUMBER_TAXI 144
#define NUMBER_MECHANIC 444
#define NUMBER_EMERGENCY 911

/* Dropgun ID */
#define DROPGUN_COLT45 1
#define DROPGUN_DEAGLE 2
#define DROPGUN_SHOTGUN 3
#define DROPGUN_RIFLE 4

/* DropAmmo ID */
#define DROPAMMO_COLT45 1
#define DROPAMMO_DEAGLE 2
#define DROPAMMO_SHOTGUN 3
#define DROPAMMO_RIFLE 4

/* Biz Type */
#define BUSINESS_ELECTRONIC 1
#define BUSINESS_TOOL 2
#define BUSINESS_CLOTHES 3
#define BUSINESS_RESTAURANT 4

/* Public Building World ID */
#define WORLD_BASE 500
#define WORLD_DRIVING_LICENSE (WORLD_BASE + 1)

/* player obj */
#define OBJECT_BASE 100
#define OBJECT_INDEX_ROD (OBJECT_BASE + 1)
#define OBJECT_INDEX_SCREW (OBJECT_BASE + 2)

/* Drunk Level */
#define DL_NONE 0
#define DL_TIRED 400

/* pragmas */
#pragma unused ret_memcpy
#pragma warning disable 239, 213

/* Player Variables and Their Enumeration */

enum E_BIZSELL
{
	Offering,
	OfferedBy,
	Price,
	BizType,
	BizID
};

new pBizSell[MAX_PLAYERS][E_BIZSELL];

enum E_VEHSELL
{
	Offering,
	OfferedBy,
	Price
};

new pVehSell[MAX_PLAYERS][E_VEHSELL];

enum E_CALLINFO
{
	CalledNumber,
	bool:IsServiceNumber,
	CalledID
}

new pCallInfo[MAX_PLAYERS][E_CALLINFO];

enum E_CALLED
{
	Taxi,
	Mechanic,
	Emergency
}

new pCallText[MAX_PLAYERS][E_CALLED];

enum E_TAXICALL
{
	loc[800],
	dest[800],
	payforv
}

new pTaxiCall[MAX_PLAYERS][E_TAXICALL];

enum E_POS
{
	Float:pX,
	Float:pY,
	Float:pZ,
	Float:pRot,
	InteriorID,
	WorldID,
	SkinID
};

new pPosition[MAX_PLAYERS][E_POS];

enum E_ACCOUNT
{
	Password[80],
	bool:VIP1,
	bool:VIP2,
	bool:VIP3,
	bool:Admin,
	bool:Helper,
	LevelCount,
	XP,
	XPMax,
	bool:Banned,
	LastLogin[3]
};

new pAccount[MAX_PLAYERS][E_ACCOUNT];

enum E_STATUS
{
	Float:Health,
	Float:Armour,
	Float:Hunger,
	Float:Thirst,
	Float:Energy
};

new pStatus[MAX_PLAYERS][E_STATUS];

enum E_WEAPON
{
	Weapon1,
	Weapon1a,
	Weapon2,
	Weapon2a,
	Weapon3,
	Weapon3a,
	Weapon4,
	Weapon4a,
	Weapon5,
	Weapon5a,
	Weapon6,
	Weapon6a,
	Weapon7,
	Weapon7a,
	Weapon8,
	Weapon8a,
	Weapon9,
	Weapon9a,
	Weapon10,
	Weapon10a,
	Weapon11,
	Weapon11a,
	Weapon12,
	Weapon12a,

	/* Civil Weapon */
	bool:Colt,
	ColtAmmo,
	Float:ColtDurability,
	bool:Deagle,
	DeagleAmmo,
	Float:DeagleDurability,
	bool:Shotgun,
	ShotgunAmmo,
	Float:ShotgunDurability,
	bool:Rifle,
	RifleAmmo,
	Float:RifleDurability
};

new pWeapon[MAX_PLAYERS][E_WEAPON];

enum E_EQUIP
{
	bool:Colt,
	bool:Deagle,
	bool:Shotgun,
	bool:Rifle,
	bool:IsEquip
};

new pWeaponEquip[MAX_PLAYERS][E_EQUIP];

enum E_STATS
{
	Money,
	Score,
	PhoneNumber
};

new pStat[MAX_PLAYERS][E_STATS];

enum E_INV_TOOL
{
	Rod,
	Screwdriver
}

enum E_INV_FISH
{
	Weigth,
	Count
}

enum E_INVENTORY
{
	Material,
	GunPart,
	Product,
	Component,
	bool:Phone,
	bool:Boombox,
	bool:License,
	LicenseDate[3],

	bool:Rod,
	bool:Screwdriver,
	bool:Gascan,
	bool:Repairkit,

	ToolDurability[E_INV_TOOL],

	Fish[E_INV_FISH],
	Bait
};

enum E_FOOD_TYPE
{
	Sprunk,
	Water,
	Fish,
	Chicken
}

enum E_FOOD
{
	bool:Empty,
	FoodText[30],
	bool:Food[E_FOOD_TYPE]
}

new pFood[MAX_PLAYERS][5][E_FOOD];

new pInventory[MAX_PLAYERS][E_INVENTORY];

enum E_STAFF_DUTY
{
	bool:Admin,
	bool:Helper
};

new pStaffDuty[MAX_PLAYERS][E_STAFF_DUTY];

enum E_MISSION
{
	bool:Material,
	bool:Sweeper,
	bool:Product,
	bool:Component,
	bool:BusDriver,
	bool:Mower,
	bool:License,
	bool:Trucker
};

new pMission[MAX_PLAYERS][E_MISSION];

enum E_CHECKPOINT
{
	Material,
	Sweeper,
	BusDriver,
	Mower,
	License
};

new pCheckpoint[MAX_PLAYERS][E_CHECKPOINT];

enum E_JOB
{
	bool:Gunmaker,
	bool:Trucker,
	bool:Mechanic,
	bool:Taxi
};

new pJob[MAX_PLAYERS][E_JOB];

enum E_FAC
{
	bool:Police,
	bool:EMS,
	bool:SAFD,
	bool:SAN
};

new pFac[MAX_PLAYERS][E_FAC];

enum E_JDUTY
{
	bool:Mechanic,
	bool:Taxi
};

new pJobDuty[MAX_PLAYERS][E_JDUTY];

enum E_TIMER
{
	Level
};

new pTimer[MAX_PLAYERS][E_TIMER];

enum E_RPTEXT
{
	Text3D:AME,
	Text3D:ADO
};

new pRpText[MAX_PLAYERS][E_RPTEXT];

enum E_PHONE
{
	Credit
};

new pPhone[MAX_PLAYERS][E_PHONE];

new pSMS[MAX_PLAYERS][30][400];

enum E_STATE
{
	bool:CraftingGun,
	bool:OnCall,
	bool:OnRing,
	bool:Fishing,
	bool:Eat,
	bool:Drink
};

new pState[MAX_PLAYERS][E_STATE];

enum E_BOOMBOX
{
	bool:Placed,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Obj,
	Text3D:Label
};

new pBoombox[MAX_PLAYERS][E_BOOMBOX];

enum E_OFFER
{
	bool:IsOffering,
	OfferedBy,
	bool:MechanicTune
};

new pOffer[MAX_PLAYERS][E_OFFER];

new Float:g_Fuel[MAX_VEHICLES] = {100.0,...};

enum E_V_WEAPON
{
	COLT,
	DEAGLE,
	SHOTGUN,
	RIFLE,
	Float:COLT_D,
	Float:DEAGLE_D,
	Float:SHOTGUN_D,
	Float:RIFLE_D
};

enum E_V_AMMO
{
	COLT,
	DEAGLE,
	SHOTGUN,
	RIFLE
};

enum E_V_STORAGE
{
	Material,
	GunPart
};

enum E_V_DAMAGESTATUS
{
	DAMAGE_STATUS_PANEL,
	DAMAGE_STATUS_DOOR,
	DAMAGE_STATUS_LIGHT,
	DAMAGE_STATUS_TIRE
};

enum E_V
{
	ID,
	Owner[80],
	Color[2],
	Model,
	Plate[32],
	Float:ParkPos[4],
	Float:LastPos[4],
	Float:Health,
	Float:Fuel,
	bool:Lock,
	vWeapon[E_V_WEAPON],
	vAmmo[E_V_AMMO],
	vStorage[E_V_STORAGE],
	DamageStatus[E_V_DAMAGESTATUS],
	UpgradeWheel,
	UpgradeSpoiler,
	UpgradeRoof,
	UpgradeExhaust,
	UpgradeHood,
	UpgradeFB,
	UpgradeRB,
	UpgradeLamp,
	UpgradeSkirt,
	UpgradeNitro,
	UpgradeH,
	UpgradeLV,
	UpgradeRV,
	Paintjob,

	Radiator,
	Float:RadiatorHealth,
	Float:Heat,
	Float:Oil,
	Float:Battery
};

new pVehicle[MAX_PLAYERS][E_V];

new pTradeVehicle[MAX_PLAYERS][E_V];

enum E_ACCS
{
	Name[24],
	Model,
	Bone,
	Float:Offset[3],
	Float:Rot[3],
	Float:Scale[3],
	bool:IsAttached,
	bool:IsEmpty
}

new pAccs[MAX_PLAYERS][MAX_ACCS][E_ACCS];

enum E_VEHICLE_INDICATOR
{
	MainBox,
	Speed,
	Health,
	Fuel,
	Heat
}

new PlayerText:VehicleIndicator[MAX_PLAYERS][E_VEHICLE_INDICATOR];

enum E_OBJ
{
	Rod,
	Screwdriver
}

new pObj[MAX_PLAYERS][E_OBJ];


enum E_TOOL_EQUIP
{
	Equip,
	Rod,
	Screwdriver
}

new bool:pToolEquip[MAX_PLAYERS][E_TOOL_EQUIP];
/* EOS */

/* Bool Checking */
new
	bool:IsAME[MAX_PLAYERS],
	bool:IsADO[MAX_PLAYERS],
	bool:IsPlayerDeath[MAX_PLAYERS],
	bool:IsNewAccount[MAX_PLAYERS],
	bool:FirstSpawn[MAX_PLAYERS],
	bool:IsPlayerLoggedIn[MAX_PLAYERS],
	bool:UsingAnim[MAX_PLAYERS],
	bool:ToggleMapTP[MAX_PLAYERS],
	bool:IsRefueling[MAX_PLAYERS],
	bool:IsLoadingTruck[MAX_PLAYERS],
	Float:pSpeedLimit[MAX_PLAYERS];
/* EOS */

/* Server Variables and their Enumeration */

new Float:GasStation[][3] = 
{
	{1940.9287,-1772.8115,13.6406},
	{1004.6555,-936.7225,42.3281},
	{655.6094,-565.0397,16.3359},
	{1382.3445,460.1272,20.3452},
	{606.0972,1701.6957,7.1875},
	{612.9851,1691.6481,7.1875},
	{619.8057,1681.8363,7.1875},
	{-1611.3909,-2720.4355,48.9453},
	{-1601.4163,-2707.2131,48.9453},
	{-2244.1821,-2560.8755,31.9219},
	{-1327.9785,2685.7344,50.4688},
	{-1330.1476,2669.3877,50.4688},
	{-1675.9065,412.7929,7.1797},
	{-2410.0371,976.2839,45.4255},
	{2114.8179,919.9590,10.8203},
	{2202.6028,2475.0398,10.8203},
	{1595.9497,2199.4265,10.8203},
	{-90.6157,-1168.0428,2.4246}
};

enum E_DROPGUN
{
	bool:Drop,
	Float:dropgunpos[3],
	dropgunid,
	Text3D:dropgunlabel,
	dropgunobj,
	Float:dura,
	intid,
	vworld
}

new sWeaponDrop[MAX_WEAPON_DROP][E_DROPGUN];

enum E_DROPAMMO
{
	bool:Drop,
	Float:dropammopos[3],
	dropammoid,
	Text3D:dropammolabel,
	dropammoobj,
	droppedammo,
	intid,
	vworld
}

new sAmmoDrop[MAX_WEAPON_DROP][E_DROPAMMO];

enum E_DROPMONEY
{
	bool:Drop,
	droppedmoney,
	dropmoneyobj,
	Float:dropmoneypos[3],
	Text3D:dropmoneylabel,
	intid,
	vworld
}

new sMoneyDrop[MAX_MONEY_DROP][E_DROPMONEY];

new SweeperVeh[11];
new MowVeh[4];

new ZoneID[MAX_ZONE];

enum E_ZONE
{
	Name[128],
	Float:ZMINX,
	Float:ZMINY,
	Float:ZMAXX,
	Float:ZMAXY
};

new sZone[][E_ZONE] = {
	{"Farm Zone",-1201.0,-1065.0,-1004.0,-908.0}
};

enum E_ELECTRONIC
{
	Owner[80],
	ShopName[100],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	Price,
	WorldID,
	Pickup,
	Text3D:Label,
	Phone,
	Boombox,
	PhonePrice,
	BoomboxPrice,
	Balance
};

new bizElectronic[MAX_ELECTRONIC][E_ELECTRONIC];

enum E_TOOL_PRICE
{
	Repairkit,
	Gascan,
	Screwdriver,
	Fishingrod
}

enum E_TOOL
{
	Owner[80],
	ShopName[100],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	Price,
	WorldID,
	Pickup,
	Text3D:Label,
	Repairkit,
	Gascan,
	Screwdriver,
	Crowbar,
	Fishingrod,
	Rope,

	ToolPrice[E_TOOL_PRICE],

	Balance
};

new bizTool[MAX_TOOL][E_TOOL];

enum E_CLOTHES
{
	Owner[80],
	ShopName[100],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	Price,
	WorldID,
	Pickup,
	Text3D:Label,
	ClothesPrice,
	Stock,
	Balance
};

new possibleVehiclePlates[][] =
	{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

new bizClothes[MAX_CLOTHES][E_CLOTHES];

enum E_RESTAURANT
{
	Owner[80],
	ShopName[100],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	Price,
	WorldID,
	Pickup,
	Text3D:Label,
	Sprunk,
	Water,
	Fish,
	Chicken,
	SprunkPrice,
	WaterPrice,
	FishPrice,
	ChickenPrice,
	SprunkName[30],
	WaterName[30],
	FishName[30],
	ChickenName[30],
	Balance
};

new bizRestaurant[MAX_RESTAURANT][E_RESTAURANT];

enum E_RENT
{
	ID,
	Owner[80],
	RentTime,
	bool:Rented,
	bool:Locked
};

enum E_MODEL_SEL
{
	Skin,
	MechanicDutySkin,
	MechanicTuneWheel
};

new sModelSel[E_MODEL_SEL];

new vRent[MAX_RENTVEH_FAGGIO][E_RENT];

enum V_BUSJOB
{
	Owner[80],
	ID
}

new vBus[7][V_BUSJOB];

new sAdLog[60][1000];

enum E_PCHANNEL
{
	bool:qna,
	bool:ooc
}

new sPChannel[E_PCHANNEL];

enum E_TICKET
{
	bool:Created,
	Queue,
	TicketMsg[200]
}

new Ticket[MAX_PLAYERS][E_TICKET];

enum E_DEALERSHIP_DATA
{
	eDealershipType,
	eDealershipCategory,

	eDealershipModel[128],
	eDealershipModelID,

	eDealershipPrice
}

new CatDealershipHolder[MAX_PLAYERS], SubDealershipHolder[MAX_PLAYERS];
new SubDealershipHolderArr[MAX_PLAYERS][200];

enum
{
	DEALERSHIP_CATEGORY_AIRCRAFTS,
	DEALERSHIP_CATEGORY_BOATS,
	DEALERSHIP_CATEGORY_BIKES,
	DEALERSHIP_CATEGORY_TWODOOR,
	DEALERSHIP_CATEGORY_FOURDOOR,
	DEALERSHIP_CATEGORY_CIVIL,
	DEALERSHIP_CATEGORY_HEAVY,
	DEALERSHIP_CATEGORY_VANS,
	DEALERSHIP_CATEGORY_SUV,
	DEALERSHIP_CATEGORY_MUSCLE,
	DEALERSHIP_CATEGORY_RACERS
}

new g_aDealershipData[][E_DEALERSHIP_DATA] = {
	{2, DEALERSHIP_CATEGORY_BIKES, "Bike", 509, 300},
	{2, DEALERSHIP_CATEGORY_BIKES, "BMX", 481, 300},
	{2, DEALERSHIP_CATEGORY_BIKES, "Mountain Bike", 510, 500},
	{2, DEALERSHIP_CATEGORY_BIKES, "Faggio", 462, 1000},
	{2, DEALERSHIP_CATEGORY_BIKES, "FCR-900", 521, 8000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Freeway", 463, 4500},
	{2, DEALERSHIP_CATEGORY_BIKES, "Sanchez", 468, 6000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Wayfarer", 586, 4500},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Alpha", 602, 12000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Blista Compact", 496, 10000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Bravura", 401, 9000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Buccaneer", 518, 6000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Cadrona", 527, 15000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Club", 589, 14000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Esperanto", 419, 17000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Euros", 587, 25000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Feltzer", 533, 35000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Fortune", 526, 40000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Hermes", 474, 45000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Hustler", 545, 38000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Majestic", 517, 45000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Manana", 410, 10000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Picador", 600, 35000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Previon", 436, 10000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Stallion", 439, 45000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Tampa", 549, 20000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Virgo", 491, 50000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Blade", 536, 40000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Broadway", 575, 59000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Remington", 534, 45000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Slamvan", 535, 75000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Tornado", 576, 65000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Voodoo", 412, 40000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Admiral", 445, 40000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Glendale", 604, 35000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Elegant", 507, 60000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Greenwood", 492, 15000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Intruder", 546, 19000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Merit", 551, 50000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Nebula", 516, 20000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Oceanic", 467, 35000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Premier", 426, 100000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Primo", 547, 35000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Sentinel", 405, 90000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Stafford", 580, 120000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Stretch", 409, 250000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Sunrise", 550, 110000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Tahoma", 566, 55000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Vincent", 540, 40000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Washington", 421, 60000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Willard", 529, 15000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Savanna", 567, 80000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Taxi", 420, 5800},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Cab", 438, 5000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Benson", 499, 6000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Boxville", 609, 4000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Mule", 414, 5000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Yankee", 456, 8000},
	{7, DEALERSHIP_CATEGORY_VANS, "Berkley's RC Van", 459, 50000},
	{7, DEALERSHIP_CATEGORY_VANS, "Bobcat", 422, 15000},
	{7, DEALERSHIP_CATEGORY_VANS, "Burrito", 482, 70000},
	{7, DEALERSHIP_CATEGORY_VANS, "Sadler", 605, 16000},
	{7, DEALERSHIP_CATEGORY_VANS, "Moonbeam", 418, 20000},
	{7, DEALERSHIP_CATEGORY_VANS, "Pony", 413, 15000},
	{7, DEALERSHIP_CATEGORY_VANS, "Rumpo", 440, 30000},
	{7, DEALERSHIP_CATEGORY_VANS, "Sadler", 543, 10000},
	{7, DEALERSHIP_CATEGORY_VANS, "Walton", 478, 40000},
	{7, DEALERSHIP_CATEGORY_VANS, "Yosemite", 554, 90000},
	{8, DEALERSHIP_CATEGORY_SUV, "Huntley", 579, 200000},
	{8, DEALERSHIP_CATEGORY_SUV, "Landstalker", 400, 120000},
	{8, DEALERSHIP_CATEGORY_SUV, "Perennial", 404, 60000},
	{8, DEALERSHIP_CATEGORY_SUV, "Rancher", 489, 35000},
	{8, DEALERSHIP_CATEGORY_SUV, "Regina", 479, 40000},
	{8, DEALERSHIP_CATEGORY_SUV, "Romero", 442, 50000},
	{8, DEALERSHIP_CATEGORY_SUV, "Solair", 458, 45000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Buffalo", 402, 130000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Clover", 542, 25000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Phoenix", 603, 90000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Sabre", 475, 50000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Banshee", 429, 60000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Bullet", 541, 350000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Cheetah", 415, 450000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Comet", 480, 120000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Elegy", 562, 85000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Flash", 565, 70000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Jester", 559, 40000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Stratum", 561, 50000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Sultan", 560, 250000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Super GT", 506, 130000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Uranus", 558, 69000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Windsor", 555, 100000},
	{10, DEALERSHIP_CATEGORY_RACERS, "ZR-350", 477, 100000}
};

static const g_aDealershipCategory[][] = {
	{"Aircrafts"},
	{"Boats"},
	{"Bikes"},
	{"2-Door & Compact cars"},
	{"4-Door & Luxury cars"},
	{"Civil Service"},
	{"Heavy & Utility Trucks"},
	{"Light trucks & Vans"},
	{"SUVs & Wagons"},
	{"Muscle Cars"},
	{"Street Racers"}
};

enum AttachmentEnum
{
    attachmodel,
    attachname[24]
}

new AttachmentObjects[][AttachmentEnum] = {
{18632, "FishingRod"},
{18633, "GTASAWrench1"},
{18634, "GTASACrowbar1"},
{18635, "GTASAHammer1"},
{18636, "PoliceCap1"},
{18637, "PoliceShield1"},
{18638, "HardHat1"},
{18639, "BlackHat1"},
{18640, "Hair1"},
{18975, "Hair2"},
{19136, "Hair4"},
{19274, "Hair5"},
{18641, "Flashlight1"},
{18642, "Taser1"},
{18643, "LaserPointer1"},
{19080, "LaserPointer2"},
{19081, "LaserPointer3"},
{19082, "LaserPointer4"},
{19083, "LaserPointer5"},
{19084, "LaserPointer6"},
{18644, "Screwdriver1"},
{18645, "MotorcycleHelmet1"},
{18865, "MobilePhone1"},
{18866, "MobilePhone2"},
{18867, "MobilePhone3"},
{18868, "MobilePhone4"},
{18869, "MobilePhone5"},
{18870, "MobilePhone6"},
{18871, "MobilePhone7"},
{18872, "MobilePhone8"},
{18873, "MobilePhone9"},
{18874, "MobilePhone10"},
{18875, "Pager1"},
{18890, "Rake1"},
{18891, "Bandana1"},
{18892, "Bandana2"},
{18893, "Bandana3"},
{18894, "Bandana4"},
{18895, "Bandana5"},
{18896, "Bandana6"},
{18897, "Bandana7"},
{18898, "Bandana8"},
{18899, "Bandana9"},
{18900, "Bandana10"},
{18901, "Bandana11"},
{18902, "Bandana12"},
{18903, "Bandana13"},
{18904, "Bandana14"},
{18905, "Bandana15"},
{18906, "Bandana16"},
{18907, "Bandana17"},
{18908, "Bandana18"},
{18909, "Bandana19"},
{18910, "Bandana20"},
{18911, "Mask1"},
{18912, "Mask2"},
{18913, "Mask3"},
{18914, "Mask4"},
{18915, "Mask5"},
{18916, "Mask6"},
{18917, "Mask7"},
{18918, "Mask8"},
{18919, "Mask9"},
{18920, "Mask10"},
{18921, "Beret1"},
{18922, "Beret2"},
{18923, "Beret3"},
{18924, "Beret4"},
{18925, "Beret5"},
{18926, "Hat1"},
{18927, "Hat2"},
{18928, "Hat3"},
{18929, "Hat4"},
{18930, "Hat5"},
{18931, "Hat6"},
{18932, "Hat7"},
{18933, "Hat8"},
{18934, "Hat9"},
{18935, "Hat10"},
{18936, "Helmet1"},
{18937, "Helmet2"},
{18938, "Helmet3"},
{18939, "CapBack1"},
{18940, "CapBack2"},
{18941, "CapBack3"},
{18942, "CapBack4"},
{18943, "CapBack5"},
{18944, "HatBoater1"},
{18945, "HatBoater2"},
{18946, "HatBoater3"},
{18947, "HatBowler1"},
{18948, "HatBowler2"},
{18949, "HatBowler3"},
{18950, "HatBowler4"},
{18951, "HatBowler5"},
{18952, "BoxingHelmet1"},
{18953, "CapKnit1"},
{18954, "CapKnit2"},
{18955, "CapOverEye1"},
{18956, "CapOverEye2"},
{18957, "CapOverEye3"},
{18958, "CapOverEye4"},
{18959, "CapOverEye5"},
{18960, "CapRimUp1"},
{18961, "CapTrucker1"},
{18962, "CowboyHat2"},
{18963, "CJElvisHead"},
{18964, "SkullyCap1"},
{18965, "SkullyCap2"},
{18966, "SkullyCap3"},
{18967, "HatMan1"},
{18968, "HatMan2"},
{18969, "HatMan3"},
{18970, "HatTiger1"},
{18971, "HatCool1"},
{18972, "HatCool2"},
{18973, "HatCool3"},
{18974, "MaskZorro1"},
{18976, "MotorcycleHelmet2"},
{18977, "MotorcycleHelmet3"},
{18978, "MotorcycleHelmet4"},
{18979, "MotorcycleHelmet5"},
{19006, "GlassesType1"},
{19007, "GlassesType2"},
{19008, "GlassesType3"},
{19009, "GlassesType4"},
{19010, "GlassesType5"},
{19011, "GlassesType6"},
{19012, "GlassesType7"},
{19013, "GlassesType8"},
{19014, "GlassesType9"},
{19015, "GlassesType10"},
{19016, "GlassesType11"},
{19017, "GlassesType12"},
{19018, "GlassesType13"},
{19019, "GlassesType14"},
{19020, "GlassesType15"},
{19021, "GlassesType16"},
{19022, "GlassesType17"},
{19023, "GlassesType18"},
{19024, "GlassesType19"},
{19025, "GlassesType20"},
{19026, "GlassesType21"},
{19027, "GlassesType22"},
{19028, "GlassesType23"},
{19029, "GlassesType24"},
{19030, "GlassesType25"},
{19031, "GlassesType26"},
{19032, "GlassesType27"},
{19033, "GlassesType28"},
{19034, "GlassesType29"},
{19035, "GlassesType30"},
{19036, "HockeyMask1"},
{19037, "HockeyMask2"},
{19038, "HockeyMask3"},
{19039, "WatchType1"},
{19040, "WatchType2"},
{19041, "WatchType3"},
{19042, "WatchType4"},
{19043, "WatchType5"},
{19044, "WatchType6"},
{19045, "WatchType7"},
{19046, "WatchType8"},
{19047, "WatchType9"},
{19048, "WatchType10"},
{19049, "WatchType11"},
{19050, "WatchType12"},
{19051, "WatchType13"},
{19052, "WatchType14"},
{19053, "WatchType15"},
{19085, "EyePatch1"},
{19086, "ChainsawDildo1"},
{19090, "PomPomBlue"},
{19091, "PomPomRed"},
{19092, "PomPomGreen"},
{19093, "HardHat2"},
{19094, "BurgerShotHat1"},
{19095, "CowboyHat1"},
{19096, "CowboyHat3"},
{19097, "CowboyHat4"},
{19098, "CowboyHat5"},
{19099, "PoliceCap2"},
{19100, "PoliceCap3"},
{19101, "ArmyHelmet1"},
{19102, "ArmyHelmet2"},
{19103, "ArmyHelmet3"},
{19104, "ArmyHelmet4"},
{19105, "ArmyHelmet5"},
{19106, "ArmyHelmet6"},
{19107, "ArmyHelmet7"},
{19108, "ArmyHelmet8"},
{19109, "ArmyHelmet9"},
{19110, "ArmyHelmet10"},
{19111, "ArmyHelmet11"},
{19112, "ArmyHelmet12"},
{19113, "SillyHelmet1"},
{19114, "SillyHelmet2"},
{19115, "SillyHelmet3"},
{19116, "PlainHelmet1"},
{19117, "PlainHelmet2"},
{19118, "PlainHelmet3"},
{19119, "PlainHelmet4"},
{19120, "PlainHelmet5"},
{19137, "CluckinBellHat1"},
{19138, "PoliceGlasses1"},
{19139, "PoliceGlasses2"},
{19140, "PoliceGlasses3"},
{19141, "SWATHelmet1"},
{19142, "SWATArmour1"},
{19160, "HardHat3"},
{19161, "PoliceHat1"},
{19162, "PoliceHat2"},
{19163, "GimpMask1"},
{19317, "bassguitar01"},
{19318, "flyingv01"},
{19319, "warlock01"},
{19330, "fire_hat01"},
{19331, "fire_hat02"},
{19346, "hotdog01"},
{19347, "badge01"},
{19348, "cane01"},
{19349, "monocle01"},
{19350, "moustache01"},
{19351, "moustache02"},
{19352, "tophat01"},
{19487, "tophat02"},
{19488, "HatBowler6"},
{19513, "whitephone"},
{19578, "Banana"},
{19418, "HandCuff"}
};

new AttachmentBones[][24] = {
{"Spine"},
{"Head"},
{"Left upper arm"},
{"Right upper arm"},
{"Left hand"},
{"Right hand"},
{"Left thigh"},
{"Right thigh"},
{"Left foot"},
{"Right foot"},
{"Right calf"},
{"Left calf"},
{"Left forearm"},
{"Right forearm"},
{"Left clavicle"},
{"Right clavicle"},
{"Neck"},
{"Jaw"}
};

enum E_LIC
{
	bool:OnTest,
	TestID
}

new sLicense[E_LIC];

enum E_PVEH
{
	DrivingLicense
}

new publicVehicle[E_PVEH];

static const Float:TruckDest[][3] = 
{
	{2746.1050,-2447.0601,13.6484},
	{-1722.1173,-117.9447,3.5489},
	{1052.9111,2087.6174,10.8203}
};

enum E_TRUCK
{
	ID,
	bool:Loaded
}

enum E_GTX
{
	Countdown
}

new Text:GlobalTextdraw[E_GTX];

new sTruck[MAX_VEHICLES][E_TRUCK];

/* Bool Checking */
new bool:CountdownC;
new CountdownCount;
/* EOS */

/* stock functions */

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}

stock SendClientMessageToAllEx(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.pri args
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format

        #emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) {
			SendClientMessage(i, color, string);
		}
		return 1;
	}
	return SendClientMessageToAll(color, str);
}

stock MoneyFormat(integer)
{
	new value[20], string[20];

	valstr(value, integer);

	new charcount;

	for(new i = strlen(value); i >= 0; i --)
	{
		format(string, sizeof(string), "%c%s", value[i], string);
		if(charcount == 3)
		{
			if(i != 0)
				format(string, sizeof(string), ",%s", string);
			charcount = 0;
		}
		charcount ++;
	}

	return string;
}

stock strrep(const str[],const find,const replace)
{
	if(isnull(str) || isnull(find) || isnull(replace)) return 0;
	for(new i; i < strlen(str); i++)
	{
		if(str[i] == find) {
			str[i] = replace;
			return 1;
		}
	}
	return 0;
}

stock GivePlayerHealth(playerid, Float:health)
{
	new Float:_h;
	GetPlayerHealth(playerid, _h);
	SetPlayerHealth(playerid, (_h + health));
	return 1;
}

stock Float:RetVehicleHealth(vehicleid)
{
	new Float:health;
	GetVehicleHealth(vehicleid, health);
	return health;
}

stock ReturnWeaponsModel(weaponid)
{
    new WeaponModels[] =
    {
        0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
        325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
        353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
        367, 368, 368, 371
    };
    return WeaponModels[weaponid];
}
stock ReturnWeaponName(weaponid)
{
	new weapon[22];
    switch(weaponid)
    {
        case 0: weapon = "Fists";
        case 18: weapon = "Molotov Cocktail";
        case 44: weapon = "Night Vision Goggles";
        case 45: weapon = "Thermal Goggles";
		case 54: weapon = "Fall";
        default: GetWeaponName(weaponid, weapon, sizeof(weapon));
    }
    return weapon;
}

stock StripLine(string[])
{
	new l = strlen(string);

	if (string[l - 2] == '\r')
		string[l - 2] = '\0';

	if (string[l - 1] == '\n')
		string[l - 1] = '\0';
}

stock SendTaxiMessage(color,const text[])
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(pJob[i][Taxi]) {
			SendClientMessage(i, color, text);
		}
	}
	return 1;
}

stock SendTaxiRequest(playerid, const location[], const destination[], payfor)
{
	new ftx[800];
	format(ftx,sizeof(ftx),"{FF0000}========{FFFF00}[TAXI REQUEST]{FF0000}========{FFFFFF}\n");
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	format(ftx,sizeof(ftx),"{FFFF00}Current Location:{FFFFFF} %s", location);
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	format(ftx,sizeof(ftx),"{FFFF00}Destination:{FFFFFF} %s", destination);
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	format(ftx,sizeof(ftx),"{FFFF00}Will Pay For: {008000}$%d", payfor);
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	format(ftx,sizeof(ftx),"{FFFF00}Contact:{FFFFFF} %d", pStat[playerid][PhoneNumber]);
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	format(ftx,sizeof(ftx),"{FF0000}==============================");
	SendTaxiMessage(-1,ftx);
	SendClientMessage(playerid, -1, ftx);
	return 1;
}

stock ParkVehicle(playerid)
{
	new Float:pos[4];
	GetVehiclePos(pVehicle[playerid][ID], pos[0], pos[1], pos[2]);
	GetVehicleZAngle(pVehicle[playerid][ID], pos[3]);
	for(new i; i < 4; i++)
	{
		pVehicle[playerid][ParkPos][i] = pos[i];
	}
}

stock SpawnParkVehicle(playerid)
{
	new F[200];
	format(F,sizeof(F),PLAYER_VEHICLE,RetPname(playerid));
	if(!fexist(F)) {
		ftouch(F);
		printf("No Vehicle Data: %d",playerid);
	}
	else {
		INI_ParseFile(F,"LoadPlayerVehicle", .bExtra = true, .extra = playerid);

		pVehicle[playerid][ID] = CreateVehicle(
			pVehicle[playerid][Model],

			pVehicle[playerid][ParkPos][0],
			pVehicle[playerid][ParkPos][1],
			pVehicle[playerid][ParkPos][2],
			pVehicle[playerid][ParkPos][3],

			pVehicle[playerid][Color][0],
			pVehicle[playerid][Color][1],

			-1
		);
		
		SetVehicleNumberPlate(pVehicle[playerid][ID], pVehicle[playerid][Plate]);

		SetVehicleHealth(pVehicle[playerid][ID], 260.0);
		g_Fuel[ pVehicle[playerid][ID] ] = pVehicle[playerid][Fuel];

		UpdateVehicleDamageStatus(
			pVehicle[playerid][ID],

			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL],
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR],
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT], 
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE]
		);

		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeWheel]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeNitro]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeExhaust]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeSkirt]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeSpoiler]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeLV]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRV]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeFB]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRB]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRoof]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeHood]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeH]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeLamp]);
	}
}

stock UpdateVehicleData(playerid)
{
	new Float:pos[4];
	new col[2];
	new Float:h;
	new ds[4];
	GetVehiclePos(pVehicle[playerid][ID], pos[0], pos[1], pos[2]);
	GetVehicleZAngle(pVehicle[playerid][ID], pos[3]);
	GetVehicleColor(pVehicle[playerid][ID], col[0], col[1]);
	GetVehicleHealth(pVehicle[playerid][ID], h);

	for(new i; i < 4; i++)
	{
		pVehicle[playerid][LastPos][i] = pos[i];
	}

	pVehicle[playerid][Color][0] = col[0];
	pVehicle[playerid][Color][1] = col[1];
	pVehicle[playerid][Model] = GetVehicleModel(pVehicle[playerid][ID]);
	pVehicle[playerid][Health] = h;
	pVehicle[playerid][Fuel] = g_Fuel[ pVehicle[playerid][ID] ];
	pVehicle[playerid][UpgradeWheel] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_WHEELS);
	pVehicle[playerid][UpgradeSpoiler] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_SPOILER);
	pVehicle[playerid][UpgradeNitro] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_NITRO);
	pVehicle[playerid][UpgradeH] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_HYDRAULICS);
	pVehicle[playerid][UpgradeHood] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_HOOD);
	pVehicle[playerid][UpgradeRoof] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_ROOF);
	pVehicle[playerid][UpgradeFB] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_FRONT_BUMPER);
	pVehicle[playerid][UpgradeRB] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_REAR_BUMPER);
	pVehicle[playerid][UpgradeExhaust] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_EXHAUST);
	pVehicle[playerid][UpgradeLamp] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_LAMPS);
	pVehicle[playerid][UpgradeSkirt] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_SIDESKIRT);
	pVehicle[playerid][UpgradeRV] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_VENT_RIGHT);
	pVehicle[playerid][UpgradeLV] = GetVehicleComponentInSlot(pVehicle[playerid][ID], CARMODTYPE_VENT_LEFT);
	pVehicle[playerid][Paintjob] = GetVehiclePaintjob(pVehicle[playerid][Paintjob]);

	GetVehicleDamageStatus(pVehicle[playerid][ID], ds[0], ds[1], ds[2], ds[3]);
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL] = ds[0];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR] = ds[1];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT] = ds[2];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE] = ds[3];
}

stock DeleteVehicle(playerid)
{
	pVehicle[playerid][Color][0] = EOS;
	pVehicle[playerid][Color][1] = EOS;
	pVehicle[playerid][Plate] = EOS;
	pVehicle[playerid][Model] = EOS;
	pVehicle[playerid][Health] = EOS;
	pVehicle[playerid][Fuel] = EOS;
	pVehicle[playerid][UpgradeWheel] = EOS;
	pVehicle[playerid][UpgradeSpoiler] = EOS;
	pVehicle[playerid][UpgradeHood] = EOS;
	pVehicle[playerid][UpgradeRoof] = EOS;
	pVehicle[playerid][UpgradeH] = EOS;
	pVehicle[playerid][UpgradeSkirt] = EOS;
	pVehicle[playerid][UpgradeNitro] = EOS;
	pVehicle[playerid][UpgradeFB] = EOS;
	pVehicle[playerid][UpgradeRB] = EOS;
	pVehicle[playerid][UpgradeLV] = EOS;
	pVehicle[playerid][UpgradeRV] = EOS;
	pVehicle[playerid][UpgradeLamp] = EOS;
	pVehicle[playerid][UpgradeExhaust] = EOS;
	pVehicle[playerid][Paintjob] = EOS;
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL] = EOS;
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR] = EOS;
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT] = EOS;
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE] = EOS;
	pVehicle[playerid][vWeapon][COLT] = EOS;
	pVehicle[playerid][vWeapon][DEAGLE] = EOS;
	pVehicle[playerid][vWeapon][SHOTGUN] = EOS;
	pVehicle[playerid][vWeapon][RIFLE] = EOS;
	pVehicle[playerid][Lock] = EOS;
	pVehicle[playerid][vAmmo][COLT] = EOS;
	pVehicle[playerid][vAmmo][DEAGLE] = EOS;
	pVehicle[playerid][vAmmo][SHOTGUN] = EOS;
	pVehicle[playerid][vAmmo][RIFLE] = EOS;
	pVehicle[playerid][vStorage][Material] = EOS;
	pVehicle[playerid][vStorage][GunPart] = EOS;
	pVehicle[playerid][Oil] = EOS;
	pVehicle[playerid][Radiator] = EOS;
	pVehicle[playerid][Heat] = EOS;
	pVehicle[playerid][RadiatorHealth] = EOS;
	pVehicle[playerid][Battery] = EOS;
	for(new i; i < 4; i++)
	{
		pVehicle[playerid][LastPos][i] = EOS;
		pVehicle[playerid][ParkPos][i] = EOS;
	}
}

stock GiveVehicle(playerid, to)
{
	pVehicle[to][Color][0] =								pVehicle[playerid][Color][0];
	pVehicle[to][Color][1] = 								pVehicle[playerid][Color][1];
	pVehicle[to][Plate] = 									pVehicle[playerid][Plate];
	pVehicle[to][Model] = 									pVehicle[playerid][Model]; 
	pVehicle[to][Health] = 									pVehicle[playerid][Health];
	pVehicle[to][Fuel] = 									pVehicle[playerid][Fuel];
	pVehicle[to][UpgradeWheel] = 							pVehicle[playerid][UpgradeWheel];
	pVehicle[to][UpgradeSpoiler] = 							pVehicle[playerid][UpgradeSpoiler];
	pVehicle[to][UpgradeHood] = 							pVehicle[playerid][UpgradeHood];
	pVehicle[to][UpgradeRoof] = 							pVehicle[playerid][UpgradeRoof]; 
	pVehicle[to][UpgradeH] = 								pVehicle[playerid][UpgradeH];
	pVehicle[to][UpgradeSkirt] = 							pVehicle[playerid][UpgradeSkirt];
	pVehicle[to][UpgradeNitro] = 							pVehicle[playerid][UpgradeNitro];
	pVehicle[to][UpgradeFB] = 								pVehicle[playerid][UpgradeFB];
	pVehicle[to][UpgradeRB] = 								pVehicle[playerid][UpgradeRB];
	pVehicle[to][UpgradeLV] = 								pVehicle[playerid][UpgradeLV];
	pVehicle[to][UpgradeRV] = 								pVehicle[playerid][UpgradeRV];
	pVehicle[to][UpgradeLamp] = 							pVehicle[playerid][UpgradeLamp]; 
	pVehicle[to][UpgradeExhaust] = 							pVehicle[playerid][UpgradeExhaust]; 
	pVehicle[to][Paintjob] = 								pVehicle[playerid][Paintjob];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE];
	pVehicle[to][vWeapon][COLT] = 							pVehicle[playerid][vWeapon][COLT];
	pVehicle[to][vWeapon][DEAGLE] = 						pVehicle[playerid][vWeapon][DEAGLE];
	pVehicle[to][vWeapon][SHOTGUN] = 						pVehicle[playerid][vWeapon][SHOTGUN];
	pVehicle[to][vWeapon][RIFLE] = 							pVehicle[playerid][vWeapon][RIFLE];
	pVehicle[to][Lock] = 									pVehicle[playerid][Lock];
	pVehicle[to][vAmmo][COLT] = 							pVehicle[playerid][vAmmo][COLT];
	pVehicle[to][vAmmo][DEAGLE] = 							pVehicle[playerid][vAmmo][DEAGLE];
	pVehicle[to][vAmmo][SHOTGUN] = 							pVehicle[playerid][vAmmo][SHOTGUN];
	pVehicle[to][vAmmo][RIFLE] = 							pVehicle[playerid][vAmmo][RIFLE];
	pVehicle[to][vStorage][Material] = 						pVehicle[playerid][vStorage][Material];
	pVehicle[to][vStorage][GunPart] = 						pVehicle[playerid][vStorage][GunPart];
	pVehicle[to][Oil] = 									pVehicle[playerid][Oil];
	pVehicle[to][Radiator] = 								pVehicle[playerid][Radiator];
	pVehicle[to][Heat] = 									pVehicle[playerid][Heat];
	pVehicle[to][RadiatorHealth] = 							pVehicle[playerid][RadiatorHealth];
	pVehicle[to][Battery] = 								pVehicle[playerid][Battery];
	for(new i; i < 4; i++)
	{
		pVehicle[to][LastPos][i] = pVehicle[playerid][LastPos][i];
		pVehicle[to][ParkPos][i] = pVehicle[playerid][ParkPos][i];
	}
	DestroyVehicle(pVehicle[to][ID]);
	SaveVehicle(to);
	LoadVehicle(to);
	DeleteVehicle(playerid);
	SaveVehicle(playerid);
	LoadVehicle(playerid);
}

stock TradeVehicle(playerid, to)
{	
	//set
	pTradeVehicle[to][Color][0] =								pVehicle[to][Color][0];
	pTradeVehicle[to][Color][1] = 								pVehicle[to][Color][1];
	pTradeVehicle[to][Plate] = 									pVehicle[to][Plate];
	pTradeVehicle[to][Model] = 									pVehicle[to][Model]; 
	pTradeVehicle[to][Health] = 									pVehicle[to][Health];
	pTradeVehicle[to][Fuel] = 									pVehicle[to][Fuel];
	pTradeVehicle[to][UpgradeWheel] = 							pVehicle[to][UpgradeWheel];
	pTradeVehicle[to][UpgradeSpoiler] = 							pVehicle[to][UpgradeSpoiler];
	pTradeVehicle[to][UpgradeHood] = 							pVehicle[to][UpgradeHood];
	pTradeVehicle[to][UpgradeRoof] = 							pVehicle[to][UpgradeRoof]; 
	pTradeVehicle[to][UpgradeH] = 								pVehicle[to][UpgradeH];
	pTradeVehicle[to][UpgradeSkirt] = 							pVehicle[to][UpgradeSkirt];
	pTradeVehicle[to][UpgradeNitro] = 							pVehicle[to][UpgradeNitro];
	pTradeVehicle[to][UpgradeFB] = 								pVehicle[to][UpgradeFB];
	pTradeVehicle[to][UpgradeRB] = 								pVehicle[to][UpgradeRB];
	pTradeVehicle[to][UpgradeLV] = 								pVehicle[to][UpgradeLV];
	pTradeVehicle[to][UpgradeRV] = 								pVehicle[to][UpgradeRV];
	pTradeVehicle[to][UpgradeLamp] = 							pVehicle[to][UpgradeLamp]; 
	pTradeVehicle[to][UpgradeExhaust] = 							pVehicle[to][UpgradeExhaust]; 
	pTradeVehicle[to][Paintjob] = 								pVehicle[to][Paintjob];
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL] = 		pVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL];
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR] = 		pVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR];
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT] = 		pVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT];
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE] = 		pVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE];
	pTradeVehicle[to][vWeapon][COLT] = 							pVehicle[to][vWeapon][COLT];
	pTradeVehicle[to][vWeapon][DEAGLE] = 						pVehicle[to][vWeapon][DEAGLE];
	pTradeVehicle[to][vWeapon][SHOTGUN] = 						pVehicle[to][vWeapon][SHOTGUN];
	pTradeVehicle[to][vWeapon][RIFLE] = 							pVehicle[to][vWeapon][RIFLE];
	pTradeVehicle[to][Lock] = 									pVehicle[to][Lock];
	pTradeVehicle[to][vAmmo][COLT] = 							pVehicle[to][vAmmo][COLT];
	pTradeVehicle[to][vAmmo][DEAGLE] = 							pVehicle[to][vAmmo][DEAGLE];
	pTradeVehicle[to][vAmmo][SHOTGUN] = 							pVehicle[to][vAmmo][SHOTGUN];
	pTradeVehicle[to][vAmmo][RIFLE] = 							pVehicle[to][vAmmo][RIFLE];
	pTradeVehicle[to][vStorage][Material] = 						pVehicle[to][vStorage][Material];
	pTradeVehicle[to][vStorage][GunPart] = 						pVehicle[to][vStorage][GunPart];
	pTradeVehicle[to][Oil] = 									pVehicle[to][Oil];
	pTradeVehicle[to][Radiator] = 								pVehicle[to][Radiator];
	pTradeVehicle[to][Heat] = 									pVehicle[to][Heat];
	pTradeVehicle[to][RadiatorHealth] = 							pVehicle[to][RadiatorHealth];
	pTradeVehicle[to][Battery] = 								pVehicle[to][Battery];
	for(new i; i < 4; i++)
	{
		pTradeVehicle[to][LastPos][i] = pVehicle[playerid][LastPos][i];
		pTradeVehicle[to][ParkPos][i] = pVehicle[playerid][ParkPos][i];
	}
	pTradeVehicle[playerid][Color][0] =								pVehicle[playerid][Color][0];
	pTradeVehicle[playerid][Color][1] = 								pVehicle[playerid][Color][1];
	pTradeVehicle[playerid][Plate] = 									pVehicle[playerid][Plate];
	pTradeVehicle[playerid][Model] = 									pVehicle[playerid][Model]; 
	pTradeVehicle[playerid][Health] = 									pVehicle[playerid][Health];
	pTradeVehicle[playerid][Fuel] = 									pVehicle[playerid][Fuel];
	pTradeVehicle[playerid][UpgradeWheel] = 							pVehicle[playerid][UpgradeWheel];
	pTradeVehicle[playerid][UpgradeSpoiler] = 							pVehicle[playerid][UpgradeSpoiler];
	pTradeVehicle[playerid][UpgradeHood] = 							pVehicle[playerid][UpgradeHood];
	pTradeVehicle[playerid][UpgradeRoof] = 							pVehicle[playerid][UpgradeRoof]; 
	pTradeVehicle[playerid][UpgradeH] = 								pVehicle[playerid][UpgradeH];
	pTradeVehicle[playerid][UpgradeSkirt] = 							pVehicle[playerid][UpgradeSkirt];
	pTradeVehicle[playerid][UpgradeNitro] = 							pVehicle[playerid][UpgradeNitro];
	pTradeVehicle[playerid][UpgradeFB] = 								pVehicle[playerid][UpgradeFB];
	pTradeVehicle[playerid][UpgradeRB] = 								pVehicle[playerid][UpgradeRB];
	pTradeVehicle[playerid][UpgradeLV] = 								pVehicle[playerid][UpgradeLV];
	pTradeVehicle[playerid][UpgradeRV] = 								pVehicle[playerid][UpgradeRV];
	pTradeVehicle[playerid][UpgradeLamp] = 							pVehicle[playerid][UpgradeLamp]; 
	pTradeVehicle[playerid][UpgradeExhaust] = 							pVehicle[playerid][UpgradeExhaust]; 
	pTradeVehicle[playerid][Paintjob] = 								pVehicle[playerid][Paintjob];
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL];
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR];
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT];
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE] = 		pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE];
	pTradeVehicle[playerid][vWeapon][COLT] = 							pVehicle[playerid][vWeapon][COLT];
	pTradeVehicle[playerid][vWeapon][DEAGLE] = 						pVehicle[playerid][vWeapon][DEAGLE];
	pTradeVehicle[playerid][vWeapon][SHOTGUN] = 						pVehicle[playerid][vWeapon][SHOTGUN];
	pTradeVehicle[playerid][vWeapon][RIFLE] = 							pVehicle[playerid][vWeapon][RIFLE];
	pTradeVehicle[playerid][Lock] = 									pVehicle[playerid][Lock];
	pTradeVehicle[playerid][vAmmo][COLT] = 							pVehicle[playerid][vAmmo][COLT];
	pTradeVehicle[playerid][vAmmo][DEAGLE] = 							pVehicle[playerid][vAmmo][DEAGLE];
	pTradeVehicle[playerid][vAmmo][SHOTGUN] = 							pVehicle[playerid][vAmmo][SHOTGUN];
	pTradeVehicle[playerid][vAmmo][RIFLE] = 							pVehicle[playerid][vAmmo][RIFLE];
	pTradeVehicle[playerid][vStorage][Material] = 						pVehicle[playerid][vStorage][Material];
	pTradeVehicle[playerid][vStorage][GunPart] = 						pVehicle[playerid][vStorage][GunPart];
	pTradeVehicle[playerid][Oil] = 									pVehicle[playerid][Oil];
	pTradeVehicle[playerid][Radiator] = 								pVehicle[playerid][Radiator];
	pTradeVehicle[playerid][Heat] = 									pVehicle[playerid][Heat];
	pTradeVehicle[playerid][RadiatorHealth] = 							pVehicle[playerid][RadiatorHealth];
	pTradeVehicle[playerid][Battery] = 								pVehicle[playerid][Battery];
	for(new i; i < 4; i++)
	{
		pTradeVehicle[playerid][LastPos][i] = pVehicle[playerid][LastPos][i];
		pTradeVehicle[playerid][ParkPos][i] = pVehicle[playerid][ParkPos][i];
	}

	//get
	pVehicle[to][Color][0] =								pTradeVehicle[playerid][Color][0];
	pVehicle[to][Color][1] = 								pTradeVehicle[playerid][Color][1];
	pVehicle[to][Plate] = 									pTradeVehicle[playerid][Plate];
	pVehicle[to][Model] = 									pTradeVehicle[playerid][Model]; 
	pVehicle[to][Health] = 									pTradeVehicle[playerid][Health];
	pVehicle[to][Fuel] = 									pTradeVehicle[playerid][Fuel];
	pVehicle[to][UpgradeWheel] = 							pTradeVehicle[playerid][UpgradeWheel];
	pVehicle[to][UpgradeSpoiler] = 							pTradeVehicle[playerid][UpgradeSpoiler];
	pVehicle[to][UpgradeHood] = 							pTradeVehicle[playerid][UpgradeHood];
	pVehicle[to][UpgradeRoof] = 							pTradeVehicle[playerid][UpgradeRoof]; 
	pVehicle[to][UpgradeH] = 								pTradeVehicle[playerid][UpgradeH];
	pVehicle[to][UpgradeSkirt] = 							pTradeVehicle[playerid][UpgradeSkirt];
	pVehicle[to][UpgradeNitro] = 							pTradeVehicle[playerid][UpgradeNitro];
	pVehicle[to][UpgradeFB] = 								pTradeVehicle[playerid][UpgradeFB];
	pVehicle[to][UpgradeRB] = 								pTradeVehicle[playerid][UpgradeRB];
	pVehicle[to][UpgradeLV] = 								pTradeVehicle[playerid][UpgradeLV];
	pVehicle[to][UpgradeRV] = 								pTradeVehicle[playerid][UpgradeRV];
	pVehicle[to][UpgradeLamp] = 							pTradeVehicle[playerid][UpgradeLamp]; 
	pVehicle[to][UpgradeExhaust] = 							pTradeVehicle[playerid][UpgradeExhaust]; 
	pVehicle[to][Paintjob] = 								pTradeVehicle[playerid][Paintjob];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL] = 		pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR] = 		pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT] = 		pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT];
	pVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE] = 		pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE];
	pVehicle[to][vWeapon][COLT] = 							pTradeVehicle[playerid][vWeapon][COLT];
	pVehicle[to][vWeapon][DEAGLE] = 						pTradeVehicle[playerid][vWeapon][DEAGLE];
	pVehicle[to][vWeapon][SHOTGUN] = 						pTradeVehicle[playerid][vWeapon][SHOTGUN];
	pVehicle[to][vWeapon][RIFLE] = 							pTradeVehicle[playerid][vWeapon][RIFLE];
	pVehicle[to][Lock] = 									pTradeVehicle[playerid][Lock];
	pVehicle[to][vAmmo][COLT] = 							pTradeVehicle[playerid][vAmmo][COLT];
	pVehicle[to][vAmmo][DEAGLE] = 							pTradeVehicle[playerid][vAmmo][DEAGLE];
	pVehicle[to][vAmmo][SHOTGUN] = 							pTradeVehicle[playerid][vAmmo][SHOTGUN];
	pVehicle[to][vAmmo][RIFLE] = 							pTradeVehicle[playerid][vAmmo][RIFLE];
	pVehicle[to][vStorage][Material] = 						pTradeVehicle[playerid][vStorage][Material];
	pVehicle[to][vStorage][GunPart] = 						pTradeVehicle[playerid][vStorage][GunPart];
	pVehicle[to][Oil] = 									pTradeVehicle[playerid][Oil];
	pVehicle[to][Radiator] = 								pTradeVehicle[playerid][Radiator];
	pVehicle[to][Heat] = 									pTradeVehicle[playerid][Heat];
	pVehicle[to][RadiatorHealth] = 							pTradeVehicle[playerid][RadiatorHealth];
	pVehicle[to][Battery] = 								pTradeVehicle[playerid][Battery];
	for(new i; i < 4; i++)
	{
		pVehicle[to][LastPos][i] = pTradeVehicle[playerid][LastPos][i];
		pVehicle[to][ParkPos][i] = pTradeVehicle[playerid][ParkPos][i];
	}
	pVehicle[playerid][Color][0] =								pTradeVehicle[to][Color][0];
	pVehicle[playerid][Color][1] = 								pTradeVehicle[to][Color][1];
	pVehicle[playerid][Plate] = 									pTradeVehicle[to][Plate];
	pVehicle[playerid][Model] = 									pTradeVehicle[to][Model]; 
	pVehicle[playerid][Health] = 									pTradeVehicle[to][Health];
	pVehicle[playerid][Fuel] = 									pTradeVehicle[to][Fuel];
	pVehicle[playerid][UpgradeWheel] = 							pTradeVehicle[to][UpgradeWheel];
	pVehicle[playerid][UpgradeSpoiler] = 							pTradeVehicle[to][UpgradeSpoiler];
	pVehicle[playerid][UpgradeHood] = 							pTradeVehicle[to][UpgradeHood];
	pVehicle[playerid][UpgradeRoof] = 							pTradeVehicle[to][UpgradeRoof]; 
	pVehicle[playerid][UpgradeH] = 								pTradeVehicle[to][UpgradeH];
	pVehicle[playerid][UpgradeSkirt] = 							pTradeVehicle[to][UpgradeSkirt];
	pVehicle[playerid][UpgradeNitro] = 							pTradeVehicle[to][UpgradeNitro];
	pVehicle[playerid][UpgradeFB] = 								pTradeVehicle[to][UpgradeFB];
	pVehicle[playerid][UpgradeRB] = 								pTradeVehicle[to][UpgradeRB];
	pVehicle[playerid][UpgradeLV] = 								pTradeVehicle[to][UpgradeLV];
	pVehicle[playerid][UpgradeRV] = 								pTradeVehicle[to][UpgradeRV];
	pVehicle[playerid][UpgradeLamp] = 							pTradeVehicle[to][UpgradeLamp]; 
	pVehicle[playerid][UpgradeExhaust] = 							pTradeVehicle[to][UpgradeExhaust]; 
	pVehicle[playerid][Paintjob] = 								pTradeVehicle[to][Paintjob];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL] = 		pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR] = 		pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT] = 		pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT];
	pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE] = 		pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE];
	pVehicle[playerid][vWeapon][COLT] = 							pTradeVehicle[to][vWeapon][COLT];
	pVehicle[playerid][vWeapon][DEAGLE] = 						pTradeVehicle[to][vWeapon][DEAGLE];
	pVehicle[playerid][vWeapon][SHOTGUN] = 						pTradeVehicle[to][vWeapon][SHOTGUN];
	pVehicle[playerid][vWeapon][RIFLE] = 							pTradeVehicle[to][vWeapon][RIFLE];
	pVehicle[playerid][Lock] = 									pTradeVehicle[to][Lock];
	pVehicle[playerid][vAmmo][COLT] = 							pTradeVehicle[to][vAmmo][COLT];
	pVehicle[playerid][vAmmo][DEAGLE] = 							pTradeVehicle[to][vAmmo][DEAGLE];
	pVehicle[playerid][vAmmo][SHOTGUN] = 							pTradeVehicle[to][vAmmo][SHOTGUN];
	pVehicle[playerid][vAmmo][RIFLE] = 							pTradeVehicle[to][vAmmo][RIFLE];
	pVehicle[playerid][vStorage][Material] = 						pTradeVehicle[to][vStorage][Material];
	pVehicle[playerid][vStorage][GunPart] = 						pTradeVehicle[to][vStorage][GunPart];
	pVehicle[playerid][Oil] = 									pTradeVehicle[to][Oil];
	pVehicle[playerid][Radiator] = 								pTradeVehicle[to][Radiator];
	pVehicle[playerid][Heat] = 									pTradeVehicle[to][Heat];
	pVehicle[playerid][RadiatorHealth] = 							pTradeVehicle[to][RadiatorHealth];
	pVehicle[playerid][Battery] = 								pTradeVehicle[to][Battery];
	for(new i; i < 4; i++)
	{
		pVehicle[playerid][LastPos][i] = pTradeVehicle[to][LastPos][i];
		pVehicle[playerid][ParkPos][i] = pTradeVehicle[to][ParkPos][i];
	}

	//reset
	pTradeVehicle[playerid][Color][0] = EOS;
	pTradeVehicle[playerid][Color][1] = EOS;
	pTradeVehicle[playerid][Plate] = EOS;
	pTradeVehicle[playerid][Model] = EOS;
	pTradeVehicle[playerid][Health] = EOS;
	pTradeVehicle[playerid][Fuel] = EOS;
	pTradeVehicle[playerid][UpgradeWheel] = EOS;
	pTradeVehicle[playerid][UpgradeSpoiler] = EOS;
	pTradeVehicle[playerid][UpgradeHood] = EOS;
	pTradeVehicle[playerid][UpgradeRoof] = EOS;
	pTradeVehicle[playerid][UpgradeH] = EOS;
	pTradeVehicle[playerid][UpgradeSkirt] = EOS;
	pTradeVehicle[playerid][UpgradeNitro] = EOS;
	pTradeVehicle[playerid][UpgradeFB] = EOS;
	pTradeVehicle[playerid][UpgradeRB] = EOS;
	pTradeVehicle[playerid][UpgradeLV] = EOS;
	pTradeVehicle[playerid][UpgradeRV] = EOS;
	pTradeVehicle[playerid][UpgradeLamp] = EOS;
	pTradeVehicle[playerid][UpgradeExhaust] = EOS;
	pTradeVehicle[playerid][Paintjob] = EOS;
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL] = EOS;
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR] = EOS;
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT] = EOS;
	pTradeVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE] = EOS;
	pTradeVehicle[playerid][vWeapon][COLT] = EOS;
	pTradeVehicle[playerid][vWeapon][DEAGLE] = EOS;
	pTradeVehicle[playerid][vWeapon][SHOTGUN] = EOS;
	pTradeVehicle[playerid][vWeapon][RIFLE] = EOS;
	pTradeVehicle[playerid][Lock] = EOS;
	pTradeVehicle[playerid][vAmmo][COLT] = EOS;
	pTradeVehicle[playerid][vAmmo][DEAGLE] = EOS;
	pTradeVehicle[playerid][vAmmo][SHOTGUN] = EOS;
	pTradeVehicle[playerid][vAmmo][RIFLE] = EOS;
	pTradeVehicle[playerid][vStorage][Material] = EOS;
	pTradeVehicle[playerid][vStorage][GunPart] = EOS;
	pTradeVehicle[playerid][Oil] = EOS;
	pTradeVehicle[playerid][Radiator] = EOS;
	pTradeVehicle[playerid][Heat] = EOS;
	pTradeVehicle[playerid][RadiatorHealth] = EOS;
	pTradeVehicle[playerid][Battery] = EOS;
	for(new i; i < 4; i++)
	{
		pTradeVehicle[playerid][LastPos][i] = EOS;
		pTradeVehicle[playerid][ParkPos][i] = EOS;
	}
	pTradeVehicle[to][Color][0] = EOS;
	pTradeVehicle[to][Color][1] = EOS;
	pTradeVehicle[to][Plate] = EOS;
	pTradeVehicle[to][Model] = EOS;
	pTradeVehicle[to][Health] = EOS;
	pTradeVehicle[to][Fuel] = EOS;
	pTradeVehicle[to][UpgradeWheel] = EOS;
	pTradeVehicle[to][UpgradeSpoiler] = EOS;
	pTradeVehicle[to][UpgradeHood] = EOS;
	pTradeVehicle[to][UpgradeRoof] = EOS;
	pTradeVehicle[to][UpgradeH] = EOS;
	pTradeVehicle[to][UpgradeSkirt] = EOS;
	pTradeVehicle[to][UpgradeNitro] = EOS;
	pTradeVehicle[to][UpgradeFB] = EOS;
	pTradeVehicle[to][UpgradeRB] = EOS;
	pTradeVehicle[to][UpgradeLV] = EOS;
	pTradeVehicle[to][UpgradeRV] = EOS;
	pTradeVehicle[to][UpgradeLamp] = EOS;
	pTradeVehicle[to][UpgradeExhaust] = EOS;
	pTradeVehicle[to][Paintjob] = EOS;
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_PANEL] = EOS;
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_DOOR] = EOS;
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_LIGHT] = EOS;
	pTradeVehicle[to][DamageStatus][DAMAGE_STATUS_TIRE] = EOS;
	pTradeVehicle[to][vWeapon][COLT] = EOS;
	pTradeVehicle[to][vWeapon][DEAGLE] = EOS;
	pTradeVehicle[to][vWeapon][SHOTGUN] = EOS;
	pTradeVehicle[to][vWeapon][RIFLE] = EOS;
	pTradeVehicle[to][Lock] = EOS;
	pTradeVehicle[to][vAmmo][COLT] = EOS;
	pTradeVehicle[to][vAmmo][DEAGLE] = EOS;
	pTradeVehicle[to][vAmmo][SHOTGUN] = EOS;
	pTradeVehicle[to][vAmmo][RIFLE] = EOS;
	pTradeVehicle[to][vStorage][Material] = EOS;
	pTradeVehicle[to][vStorage][GunPart] = EOS;
	pTradeVehicle[to][Oil] = EOS;
	pTradeVehicle[to][Radiator] = EOS;
	pTradeVehicle[to][Heat] = EOS;
	pTradeVehicle[to][RadiatorHealth] = EOS;
	pTradeVehicle[to][Battery] = EOS;
	for(new i; i < 4; i++)
	{
		pTradeVehicle[to][LastPos][i] = EOS;
		pTradeVehicle[to][ParkPos][i] = EOS;
	}

	//action
	DestroyVehicle(pVehicle[to][ID]);
	DestroyVehicle(pVehicle[playerid][ID]);
	
	//save
	SaveVehicle(to);
	LoadVehicle(to);
	SaveVehicle(playerid);
	LoadVehicle(playerid);
}

stock SaveFood(playerid)
{
	new F[200];
	new F_p[200];
	format(F,sizeof(F),PLAYER_FOOD,RetPname(playerid));
	if(!fexist(F)) ftouch(F);
	for(new i; i < 5; i++)
	{
		format(F_p,sizeof(F_p),"foodname_%d",i);
		dini_Set(F,F_p,pFood[playerid][i][FoodText]);
		format(F_p,sizeof(F_p),"sprunk_%d",i);
		dini_BoolSet(F,F_p,pFood[playerid][i][Food][Sprunk]);
		format(F_p,sizeof(F_p),"water_%d",i);
		dini_BoolSet(F,F_p,pFood[playerid][i][Food][Water]);
		format(F_p,sizeof(F_p),"fish_%d",i);
		dini_BoolSet(F,F_p,pFood[playerid][i][Food][Fish]);
		format(F_p,sizeof(F_p),"chicken_%d",i);
		dini_BoolSet(F,F_p,pFood[playerid][i][Food][Chicken]);
	}
}

stock LoadFood(playerid)
{
	new F[200];
	new F_p[200];
	format(F,sizeof(F),PLAYER_FOOD,RetPname(playerid));
	if(!fexist(F)) ftouch(F);
	for(new i; i < 5; i++)
	{
		format(F_p,sizeof(F_p),"foodname_%d",i);
		format(pFood[playerid][i][FoodText],30,"%s",dini_Get(F,F_p));
		format(F_p,sizeof(F_p),"sprunk_%d",i);
		pFood[playerid][i][Food][Sprunk] = dini_Bool(F,F_p);
		format(F_p,sizeof(F_p),"water_%d",i);
		pFood[playerid][i][Food][Water] = dini_Bool(F,F_p);
		format(F_p,sizeof(F_p),"fish_%d",i);
		pFood[playerid][i][Food][Fish]= dini_Bool(F,F_p);
		format(F_p,sizeof(F_p),"chicken_%d",i);
		pFood[playerid][i][Food][Chicken]= dini_Bool(F,F_p);
	}
}

stock InitFood(playerid)
{
	for(new i; i < 5; i++)
	{
		if(strlen(pFood[playerid][i][FoodText]) <= 0 || isnull(pFood[playerid][i][FoodText])) pFood[playerid][i][Empty] = true;
	}
}

stock DeleteFood(playerid, slot)
{
	pFood[playerid][slot][Empty] = true;
	pFood[playerid][slot][FoodText] = EOS;
	for(new i; i < 5; i++)
	{
		pFood[playerid][slot][Food][i] = false;
	}
}

stock SaveVehicle(playerid)
{
	new F[200];
	new INI:FH;
	format(F,sizeof(F),PLAYER_VEHICLE,RetPname(playerid));
	if(!fexist(F)) {
		ftouch(F);

		FH = INI_Open(F);

		INI_WriteInt(FH, "color1", pVehicle[playerid][Color][0]);
		INI_WriteInt(FH, "color2", pVehicle[playerid][Color][1]);
		INI_WriteInt(FH, "model", pVehicle[playerid][Model]);

		INI_WriteString(FH, "plate",pVehicle[playerid][Plate]);

		INI_WriteFloat(FH, "parkposx", pVehicle[playerid][ParkPos][0]);
		INI_WriteFloat(FH, "parkposy", pVehicle[playerid][ParkPos][1]);
		INI_WriteFloat(FH, "parkposz", pVehicle[playerid][ParkPos][2]);
		INI_WriteFloat(FH, "parkposr", pVehicle[playerid][ParkPos][3]);

		INI_WriteFloat(FH, "lastposx", pVehicle[playerid][LastPos][0]);
		INI_WriteFloat(FH, "lastposy", pVehicle[playerid][LastPos][1]);
		INI_WriteFloat(FH, "lastposz", pVehicle[playerid][LastPos][2]);
		INI_WriteFloat(FH, "lastposr", pVehicle[playerid][LastPos][3]);

		INI_WriteFloat(FH, "health", pVehicle[playerid][Health]);
		INI_WriteFloat(FH, "fuel", pVehicle[playerid][Fuel]);

		INI_WriteBool(FH, "lock", pVehicle[playerid][Lock]);

		INI_WriteBool(FH, "coltv", pVehicle[playerid][vWeapon][COLT]);
		INI_WriteBool(FH, "deaglev", pVehicle[playerid][vWeapon][DEAGLE]);
		INI_WriteBool(FH, "shotgunv", pVehicle[playerid][vWeapon][SHOTGUN]);
		INI_WriteBool(FH, "riflev", pVehicle[playerid][vWeapon][RIFLE]);

		INI_WriteFloat(FH, "coltvd", pVehicle[playerid][vWeapon][COLT_D]);
		INI_WriteFloat(FH, "deaglevd", pVehicle[playerid][vWeapon][DEAGLE_D]);
		INI_WriteFloat(FH, "shotgunvd", pVehicle[playerid][vWeapon][SHOTGUN_D]);
		INI_WriteFloat(FH, "riflevd", pVehicle[playerid][vWeapon][RIFLE_D]);

		INI_WriteInt(FH, "coltva", pVehicle[playerid][vAmmo][COLT]);
		INI_WriteInt(FH, "deagleva", pVehicle[playerid][vAmmo][DEAGLE]);
		INI_WriteInt(FH, "shotgunva", pVehicle[playerid][vAmmo][SHOTGUN]);
		INI_WriteInt(FH, "rifleva", pVehicle[playerid][vAmmo][RIFLE]);

		INI_WriteInt(FH, "materialv", pVehicle[playerid][vStorage][Material]);
		INI_WriteInt(FH, "gunpartv", pVehicle[playerid][vStorage][GunPart]);

		INI_WriteInt(FH, "dspanel", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL]);
		INI_WriteInt(FH, "dsdoor", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR]);
		INI_WriteInt(FH, "dslight", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT]);
		INI_WriteInt(FH, "dstire", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE]);

		INI_WriteInt(FH, "wheel", pVehicle[playerid][UpgradeWheel]);
		INI_WriteInt(FH, "spoiler", pVehicle[playerid][UpgradeSpoiler]);
		INI_WriteInt(FH, "nitro", pVehicle[playerid][UpgradeNitro]);
		INI_WriteInt(FH, "fb", pVehicle[playerid][UpgradeFB]);
		INI_WriteInt(FH, "rb", pVehicle[playerid][UpgradeRB]);
		INI_WriteInt(FH, "hydra", pVehicle[playerid][UpgradeH]);
		INI_WriteInt(FH, "hood", pVehicle[playerid][UpgradeHood]);
		INI_WriteInt(FH, "roof", pVehicle[playerid][UpgradeRoof]);
		INI_WriteInt(FH, "skirt", pVehicle[playerid][UpgradeSkirt]);
		INI_WriteInt(FH, "lv", pVehicle[playerid][UpgradeLV]);
		INI_WriteInt(FH, "rv", pVehicle[playerid][UpgradeRV]);
		INI_WriteInt(FH, "lamp", pVehicle[playerid][UpgradeLamp]);
		INI_WriteInt(FH, "exhaust", pVehicle[playerid][UpgradeExhaust]);
		INI_WriteInt(FH, "paintjob", pVehicle[playerid][Paintjob]);

		INI_WriteInt(FH,"radiator", pVehicle[playerid][Radiator]);
		INI_WriteFloat(FH,"radiatorhealth", pVehicle[playerid][RadiatorHealth]);
		INI_WriteFloat(FH, "heat", pVehicle[playerid][Heat]);
		INI_WriteFloat(FH, "oil", pVehicle[playerid][Oil]);
		INI_WriteFloat(FH, "battery", pVehicle[playerid][Battery]);

		INI_Close(FH);
	}
	else {
		FH = INI_Open(F);

		INI_WriteInt(FH, "color1", pVehicle[playerid][Color][0]);
		INI_WriteInt(FH, "color2", pVehicle[playerid][Color][1]);
		INI_WriteInt(FH, "model", pVehicle[playerid][Model]);

		INI_WriteString(FH, "plate",pVehicle[playerid][Plate]);

		INI_WriteFloat(FH, "parkposx", pVehicle[playerid][ParkPos][0]);
		INI_WriteFloat(FH, "parkposy", pVehicle[playerid][ParkPos][1]);
		INI_WriteFloat(FH, "parkposz", pVehicle[playerid][ParkPos][2]);
		INI_WriteFloat(FH, "parkposr", pVehicle[playerid][ParkPos][3]);

		INI_WriteFloat(FH, "lastposx", pVehicle[playerid][LastPos][0]);
		INI_WriteFloat(FH, "lastposy", pVehicle[playerid][LastPos][1]);
		INI_WriteFloat(FH, "lastposz", pVehicle[playerid][LastPos][2]);
		INI_WriteFloat(FH, "lastposr", pVehicle[playerid][LastPos][3]);

		INI_WriteFloat(FH, "health", pVehicle[playerid][Health]);
		INI_WriteFloat(FH, "fuel", pVehicle[playerid][Fuel]);

		INI_WriteBool(FH, "lock", pVehicle[playerid][Lock]);

		INI_WriteBool(FH, "coltv", pVehicle[playerid][vWeapon][COLT]);
		INI_WriteBool(FH, "deaglev", pVehicle[playerid][vWeapon][DEAGLE]);
		INI_WriteBool(FH, "shotgunv", pVehicle[playerid][vWeapon][SHOTGUN]);
		INI_WriteBool(FH, "riflev", pVehicle[playerid][vWeapon][RIFLE]);

		INI_WriteFloat(FH, "coltvd", pVehicle[playerid][vWeapon][COLT_D]);
		INI_WriteFloat(FH, "deaglevd", pVehicle[playerid][vWeapon][DEAGLE_D]);
		INI_WriteFloat(FH, "shotgunvd", pVehicle[playerid][vWeapon][SHOTGUN_D]);
		INI_WriteFloat(FH, "riflevd", pVehicle[playerid][vWeapon][RIFLE_D]);

		INI_WriteInt(FH, "coltva", pVehicle[playerid][vAmmo][COLT]);
		INI_WriteInt(FH, "deagleva", pVehicle[playerid][vAmmo][DEAGLE]);
		INI_WriteInt(FH, "shotgunva", pVehicle[playerid][vAmmo][SHOTGUN]);
		INI_WriteInt(FH, "rifleva", pVehicle[playerid][vAmmo][RIFLE]);

		INI_WriteInt(FH, "materialv", pVehicle[playerid][vStorage][Material]);
		INI_WriteInt(FH, "gunpartv", pVehicle[playerid][vStorage][GunPart]);

		INI_WriteInt(FH, "dspanel", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL]);
		INI_WriteInt(FH, "dsdoor", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR]);
		INI_WriteInt(FH, "dslight", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT]);
		INI_WriteInt(FH, "dstire", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE]);

		INI_WriteInt(FH, "wheel", pVehicle[playerid][UpgradeWheel]);
		INI_WriteInt(FH, "spoiler", pVehicle[playerid][UpgradeSpoiler]);
		INI_WriteInt(FH, "nitro", pVehicle[playerid][UpgradeNitro]);
		INI_WriteInt(FH, "fb", pVehicle[playerid][UpgradeFB]);
		INI_WriteInt(FH, "rb", pVehicle[playerid][UpgradeRB]);
		INI_WriteInt(FH, "hydra", pVehicle[playerid][UpgradeH]);
		INI_WriteInt(FH, "hood", pVehicle[playerid][UpgradeHood]);
		INI_WriteInt(FH, "roof", pVehicle[playerid][UpgradeRoof]);
		INI_WriteInt(FH, "skirt", pVehicle[playerid][UpgradeSkirt]);
		INI_WriteInt(FH, "lv", pVehicle[playerid][UpgradeLV]);
		INI_WriteInt(FH, "rv", pVehicle[playerid][UpgradeRV]);
		INI_WriteInt(FH, "lamp", pVehicle[playerid][UpgradeLamp]);
		INI_WriteInt(FH, "exhaust", pVehicle[playerid][UpgradeExhaust]);
		INI_WriteInt(FH, "paintjob", pVehicle[playerid][Paintjob]);

		INI_WriteInt(FH,"radiator", pVehicle[playerid][Radiator]);
		INI_WriteFloat(FH,"radiatorhealth", pVehicle[playerid][RadiatorHealth]);
		INI_WriteFloat(FH, "heat", pVehicle[playerid][Heat]);
		INI_WriteFloat(FH, "oil", pVehicle[playerid][Oil]);
		INI_WriteFloat(FH, "battery", pVehicle[playerid][Battery]);

		INI_Close(FH);
	}
}

//hehe
func:LoadPlayerVehicle(playerid, name[], value[])
{
	INI_Int("color1", pVehicle[playerid][Color][0]);
	INI_Int("color2", pVehicle[playerid][Color][1]);
	INI_Int("model", pVehicle[playerid][Model]);

	INI_String("plate",pVehicle[playerid][Plate]);

	INI_Float("parkposx", pVehicle[playerid][ParkPos][0]);
	INI_Float("parkposy", pVehicle[playerid][ParkPos][1]);
	INI_Float("parkposz", pVehicle[playerid][ParkPos][2]);
	INI_Float("parkposr", pVehicle[playerid][ParkPos][3]);

	INI_Float("lastposx", pVehicle[playerid][LastPos][0]);
	INI_Float("lastposy", pVehicle[playerid][LastPos][1]);
	INI_Float("lastposz", pVehicle[playerid][LastPos][2]);
	INI_Float("lastposr", pVehicle[playerid][LastPos][3]);

	INI_Float("health", pVehicle[playerid][Health]);
	INI_Float("fuel", pVehicle[playerid][Fuel]);

	INI_Bool("lock", pVehicle[playerid][Lock]);

	INI_Bool("coltv", pVehicle[playerid][vWeapon][COLT]);
	INI_Bool("deaglev", pVehicle[playerid][vWeapon][DEAGLE]);
	INI_Bool("shotgunv", pVehicle[playerid][vWeapon][SHOTGUN]);
	INI_Bool("riflev", pVehicle[playerid][vWeapon][RIFLE]);

	INI_Float("coltvd", pVehicle[playerid][vWeapon][COLT_D]);
	INI_Float("deaglevd", pVehicle[playerid][vWeapon][DEAGLE_D]);
	INI_Float("shotgunvd", pVehicle[playerid][vWeapon][SHOTGUN_D]);
	INI_Float("riflevd", pVehicle[playerid][vWeapon][RIFLE_D]);

	INI_Int("coltva", pVehicle[playerid][vAmmo][COLT]);
	INI_Int("deagleva", pVehicle[playerid][vAmmo][DEAGLE]);
	INI_Int("shotgunva", pVehicle[playerid][vAmmo][SHOTGUN]);
	INI_Int("rifleva", pVehicle[playerid][vAmmo][RIFLE]);

	INI_Int("materialv", pVehicle[playerid][vStorage][Material]);
	INI_Int("gunpartv", pVehicle[playerid][vStorage][GunPart]);

	INI_Int("dspanel", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL]);
	INI_Int("dsdoor", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR]);
	INI_Int("dslight", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT]);
	INI_Int("dstire", pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE]);

	INI_Int("wheel", pVehicle[playerid][UpgradeWheel]);
	INI_Int("spoiler", pVehicle[playerid][UpgradeSpoiler]);
	INI_Int("nitro", pVehicle[playerid][UpgradeNitro]);
	INI_Int("fb", pVehicle[playerid][UpgradeFB]);
	INI_Int("rb", pVehicle[playerid][UpgradeRB]);
	INI_Int("hydra", pVehicle[playerid][UpgradeH]);
	INI_Int("hood", pVehicle[playerid][UpgradeHood]);
	INI_Int("roof", pVehicle[playerid][UpgradeRoof]);
	INI_Int("skirt", pVehicle[playerid][UpgradeSkirt]);
	INI_Int("lv", pVehicle[playerid][UpgradeLV]);
	INI_Int("rv", pVehicle[playerid][UpgradeRV]);
	INI_Int("lamp", pVehicle[playerid][UpgradeLamp]);
	INI_Int("exhaust", pVehicle[playerid][UpgradeExhaust]);
	INI_Int("paintjob", pVehicle[playerid][Paintjob]);

	INI_Int("radiator", pVehicle[playerid][Radiator]);
	INI_Float("radiatorhealth", pVehicle[playerid][RadiatorHealth]);
	INI_Float( "heat", pVehicle[playerid][Heat]);
	INI_Float( "oil", pVehicle[playerid][Oil]);
	INI_Float( "battery", pVehicle[playerid][Battery]);
	return 1;
}

stock LoadVehicle(playerid)
{
	new F[200];
	format(F,sizeof(F),PLAYER_VEHICLE,RetPname(playerid));
	if(!fexist(F)) {
		ftouch(F);
	}
	else {
		INI_ParseFile(F,"LoadPlayerVehicle", .bExtra = true, .extra = playerid);

		pVehicle[playerid][ID] = CreateVehicle(
			pVehicle[playerid][Model],

			pVehicle[playerid][LastPos][0],
			pVehicle[playerid][LastPos][1],
			pVehicle[playerid][LastPos][2],
			pVehicle[playerid][LastPos][3],

			pVehicle[playerid][Color][0],
			pVehicle[playerid][Color][1],

			-1
		);

		SetVehicleNumberPlate(pVehicle[playerid][ID], pVehicle[playerid][Plate]);

		SetVehicleHealth(pVehicle[playerid][ID], pVehicle[playerid][Health]);
		g_Fuel[ pVehicle[playerid][ID] ] = pVehicle[playerid][Fuel];

		UpdateVehicleDamageStatus(
			pVehicle[playerid][ID],

			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_PANEL],
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_DOOR],
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_LIGHT], 
			pVehicle[playerid][DamageStatus][DAMAGE_STATUS_TIRE]
		);

		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeWheel]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeNitro]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeExhaust]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeSkirt]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeSpoiler]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeLV]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRV]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeFB]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRB]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeRoof]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeHood]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeH]);
		AddVehicleComponent(pVehicle[playerid][ID], pVehicle[playerid][UpgradeLamp]);
	}
}

stock IsTruck(vehicleid)
{
	new c = GetVehicleModel(vehicleid);
	switch(c)
	{
		case 499,609,414,456: return 1;
		default: return 0;
	}
	return 0;
}

stock SaveAccs(playerid)
{
	new 
		D[200],
		F[200];
	format(D,sizeof(D),PLAYER_ACCS_DIR,RetPname(playerid));
	//dcreate(D);
	for(new i; i < MAX_ACCS; i++)
	{
		format(F,sizeof(F),PLAYER_ACCS,RetPname(playerid),i);
		if(!fexist(F))
		{
			ftouch(F);
		}
		dini_Set(F,"name",pAccs[playerid][i][Name]);

		dini_IntSet(F,"model",pAccs[playerid][i][Model]);
		dini_IntSet(F,"bone",pAccs[playerid][i][Bone]);

		dini_FloatSet(F,"ofx",pAccs[playerid][i][Offset][0]);
		dini_FloatSet(F,"ofy",pAccs[playerid][i][Offset][1]);
		dini_FloatSet(F,"ofz",pAccs[playerid][i][Offset][2]);

		dini_FloatSet(F,"rotx",pAccs[playerid][i][Rot][0]);
		dini_FloatSet(F,"roty",pAccs[playerid][i][Rot][1]);
		dini_FloatSet(F,"rotz",pAccs[playerid][i][Rot][2]);

		dini_FloatSet(F,"scax",pAccs[playerid][i][Scale][0]);
		dini_FloatSet(F,"scay",pAccs[playerid][i][Scale][1]);
		dini_FloatSet(F,"scaz",pAccs[playerid][i][Scale][2]);

		dini_BoolSet(F,"attached",pAccs[playerid][i][IsAttached]);
	}
}

stock LoadGSData()
{
	new count;
	for(new i; i < sizeof(GasStation); i++)
	{
		CreateDynamicPickup(1239, 0, GasStation[i][0], GasStation[i][1], GasStation[i][2]);
		CreateDynamic3DTextLabel("[Refuel Point]\n{AAAAAA}Type /refuel to refuel", 0xFF0000AA, GasStation[i][0], GasStation[i][1], GasStation[i][2], 15.0);
		count++;
	}
	printf("[DEBUG][GS]: %d Gas Station Loaded.",count);
}

stock ShowVehicleIndicator(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 0;
	PlayerTextDrawShow(playerid, VehicleIndicator[playerid][MainBox]);
	PlayerTextDrawShow(playerid, VehicleIndicator[playerid][Speed]);
	PlayerTextDrawShow(playerid, VehicleIndicator[playerid][Health]);
	PlayerTextDrawShow(playerid, VehicleIndicator[playerid][Fuel]);
	PlayerTextDrawShow(playerid, VehicleIndicator[playerid][Heat]);
	return 1;
}

stock HideVehicleIndicator(playerid)
{
	PlayerTextDrawHide(playerid, VehicleIndicator[playerid][MainBox]);
	PlayerTextDrawHide(playerid, VehicleIndicator[playerid][Speed]);
	PlayerTextDrawHide(playerid, VehicleIndicator[playerid][Health]);
	PlayerTextDrawHide(playerid, VehicleIndicator[playerid][Fuel]);
	PlayerTextDrawHide(playerid, VehicleIndicator[playerid][Heat]);
	return 1;
}

stock LoadAccs(playerid)
{
	new 
		D[200],
		F[200];
	format(D,sizeof(D),PLAYER_ACCS_DIR,RetPname(playerid));
	if(!dir_exists(D))
	{
		printf("[DEBUG]: Directory didn't exist, creating dir %s", D);
		dir_create(D);
		printf("[DEBUG]: Directory has been created");
	}
	for(new i; i < MAX_ACCS; i++)
	{
		format(F,sizeof(F),PLAYER_ACCS,RetPname(playerid),i);
		if(!fexist(F))
		{
			ftouch(F);
		}
		else {
			printf("[DEBUG][ACCS][LOAD-FILE]: Loading Accs Data from File: %s",F);
			strcpy(pAccs[playerid][i][Name],dini_Get(F,"name"));

			pAccs[playerid][i][Model] = dini_Int(F,"model");
			pAccs[playerid][i][Bone] = dini_Int(F,"bone");

			pAccs[playerid][i][Offset][0] = dini_Float(F,"ofx");
			pAccs[playerid][i][Offset][1] = dini_Float(F,"ofy");
			pAccs[playerid][i][Offset][2] = dini_Float(F,"ofz");

			pAccs[playerid][i][Rot][0] = dini_Float(F,"rotx");
			pAccs[playerid][i][Rot][1] = dini_Float(F,"roty");
			pAccs[playerid][i][Rot][2] = dini_Float(F,"rotz");

			pAccs[playerid][i][Scale][0] = dini_Float(F,"scax");
			pAccs[playerid][i][Scale][1] = dini_Float(F,"scay");
			pAccs[playerid][i][Scale][2] = dini_Float(F,"scaz");

			pAccs[playerid][i][IsAttached] = dini_Bool(F,"attached");

			if(pAccs[playerid][i][IsAttached]) {
				printf("[DEBUG][ACCS][INIT]: Accs slot %d 'Attach' Data is true",i);
				SetPlayerAttachedObject(playerid, i,
					pAccs[playerid][i][Model], 
					pAccs[playerid][i][Bone],
					
					pAccs[playerid][i][Offset][0],
					pAccs[playerid][i][Offset][1],
					pAccs[playerid][i][Offset][2], 

					pAccs[playerid][i][Rot][0],
					pAccs[playerid][i][Rot][1],
					pAccs[playerid][i][Rot][2],

					pAccs[playerid][i][Scale][0],
					pAccs[playerid][i][Scale][1],
					pAccs[playerid][i][Scale][2]
				);
			}
		}
	}
}

stock DeleteAccs(playerid, index)
{
	new i = index;
	pAccs[playerid][i][Name] = EOS;

	pAccs[playerid][i][Model] = EOS;
	pAccs[playerid][i][Bone] = EOS;

	pAccs[playerid][i][Offset][0] = EOS;
	pAccs[playerid][i][Offset][1] = EOS;
	pAccs[playerid][i][Offset][2] = EOS;

	pAccs[playerid][i][Rot][0] = EOS;
	pAccs[playerid][i][Rot][1] = EOS;
	pAccs[playerid][i][Rot][2] = EOS;

	pAccs[playerid][i][Scale][0] = EOS;
	pAccs[playerid][i][Scale][1] = EOS;
	pAccs[playerid][i][Scale][2] = EOS;

	pAccs[playerid][i][IsAttached] = EOS;
	pAccs[playerid][i][IsEmpty] = EOS;
	printf("[DEBUG][ACCS][DELETE]: Accs Index %d Has Been Deleted.",index);
}

stock LoadLicense(playerid)
{
	new f[200];
	format(f,sizeof(f),PLAYER_INVENTORY,RetPname(playerid));
	pInventory[playerid][License] = dini_Bool(f,"license");
	pInventory[playerid][LicenseDate][0] = dini_Int(f,"licensed");
	pInventory[playerid][LicenseDate][1] = dini_Int(f,"licensem");
	pInventory[playerid][LicenseDate][2] = dini_Int(f,"licensey");
}

stock DeleteLicense(playerid)
{
	new f[200];
	format(f,sizeof(f),PLAYER_INVENTORY,RetPname(playerid));
	dini_BoolSet(f,"license",false);
	pInventory[playerid][License] = EOS;
	pInventory[playerid][LicenseDate][0] = EOS;
	pInventory[playerid][LicenseDate][1] = EOS;
	pInventory[playerid][LicenseDate][2] = EOS;
}

stock ShowLicense(playerid, to)
{
	SendClientMessage(to,-1," ");
	SendClientMessage(to,-1,"{FF0000}Driving License");
	SendClientMessage(to,-1,"{FF0000}======================");
	SendClientMessageEx(to,-1,"Name: {FFFF00}%s",RetPname(playerid));
	SendClientMessageEx(to,-1,"Date Created: {FFFF00}%02d/%02d/%d",pInventory[playerid][LicenseDate][0],pInventory[playerid][LicenseDate][1],pInventory[playerid][LicenseDate][2]);
	SendClientMessage(to,-1,"Expiration: {FFFF00}1 month after this license created");
	SendClientMessage(to,-1,"{FF0000}======================");
	SendClientMessage(to,-1," ");
}

stock InitAccs(playerid)
{
	for(new i; i < MAX_ACCS; i++)
	{
		if(pAccs[playerid][i][Model] == 0) {
			pAccs[playerid][i][IsEmpty] = true;
			printf("[DEBUG][ACCS][INIT]: Slot %d Initialized as an empty slot.",i);
		}
	}
}

stock HasNoEngine(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 481, 509, 510: return 1;
	}
	return 0;
}

stock bool:IsPlayerInRangeOfPlayer(playerid, playerid2, Float:range)
{
	new Float:pos[3];
	GetPlayerPos(playerid2,pos[0],pos[1],pos[2]);
	if(IsPlayerConnected(playerid) && IsPlayerConnected(playerid2)) {
		if(IsPlayerInRangeOfPoint(playerid,range,pos[0],pos[1],pos[2])) return 1;
		else return 0;
	}
	return 0;
}

stock bool:IsVehicleInRangeOfPoint(vehicleid, Float:range, Float:x, Float:y, Float:z)
{
	if(GetVehicleDistanceFromPoint(vehicleid, x, y, z) <= range) return 1;
	else return 0;
}

stock GetPlayerDistanceFromPlayer(playerid, playerid2, &Float:distance)
{
	new Float:pos[3];
	GetPlayerPos(playerid2, pos[0], pos[1], pos[2]);
	if(IsPlayerConnected(playerid) && IsPlayerConnected(playerid)) {
		distance = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);
		return 1;
	}
	else return 0;
}

stock ApplyPlayerAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    ApplyAnimation(playerid, animlib, "null", fDelta, loop, lockx, locky, freeze, time, forcesync); // Pre-load animation library
    return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
}

stock RetPname(playerid, und = 0)
{
	new pname[100];
	if(!IsPlayerConnected(playerid)) return pname;
	GetPlayerName(playerid, pname, sizeof(pname));
	if(und == 1) for(new i; i < strlen(pname); i++)
	{
		if(pname[i] == '_') pname[i] = ' ';
	}
	return pname;
}

stock ProxMsg(Float:radius, playerid, string[], color)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerInRangeOfPoint(i, radius, x, y, z))
        {
            SendClientMessage(i, color, string);
        }
    }
    return 1;
}

stock ProxMsg2(Float:radius, playerid, string[], color1, color2, color3, color4)
{
	new
		Float:playerPos[3],
		Float:loopPos[3],
		Float:pos[3];
	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
	for(new i; i < MAX_PLAYERS; i++)
	{
		GetPlayerPos(i, loopPos[0], loopPos[1], loopPos[2]);
		for(new p; p < 3; p++)
		{
			pos[p] = (playerPos[p] - loopPos[p]);
		}

		if(((pos[0] < radius/16) && (pos[0] > -radius/16)) && ((pos[1] < radius/16) && (pos[1] > -radius/16)) && ((pos[2] < radius/16) && (pos[2] > -radius/16))) {
			SendClientMessage(i, color1, string);
		}
		else if(((pos[0] < radius/8) && (pos[0] > -radius/8)) && ((pos[1] < radius/8) && (pos[1] > -radius/8)) && ((pos[2] < radius/8) && (pos[2] > -radius/8))) {
			SendClientMessage(i, color2, string);
		}
		else if(((pos[0] < radius/4) && (pos[0] > -radius/4)) && ((pos[1] < radius/4) && (pos[1] > -radius/4)) && ((pos[2] < radius/4) && (pos[2] > -radius/4))) {
			SendClientMessage(i, color3, string);
		}
		else if(((pos[0] < radius/2) && (pos[0] > -radius/2)) && ((pos[1] < radius/2) && (pos[1] > -radius/2)) && ((pos[2] < radius/2) && (pos[2] > -radius/2))) {
			SendClientMessage(i, color4, string);
		}
	}
	return 1;
}

stock SetSweeperToRespawn()
{
	for(new i; i < sizeof(SweeperVeh); i++)
	{
		if(!IsVehicleInUse(SweeperVeh[i])) {
			SetVehicleToRespawn(SweeperVeh[i]);
			return 1;
		}
	}
	return 0;
}

stock LoadElectronicBiz()
{
	new fh[200];
	new label[280];
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		format(fh,sizeof(fh),BIZ_ELECTRONIC,i);
		if(fexist(fh)) {
			strcpy(bizElectronic[i][Owner], dini_Get(fh,"owner"));
			strcpy(bizElectronic[i][ShopName], dini_Get(fh,"shopname"));
			bizElectronic[i][EnterX] = dini_Float(fh,"enterx");
			bizElectronic[i][EnterY] = dini_Float(fh,"entery");
			bizElectronic[i][EnterZ] = dini_Float(fh,"enterz");
			bizElectronic[i][Price] = dini_Int(fh,"price");
			bizElectronic[i][WorldID] = dini_Int(fh,"worldid");
			bizElectronic[i][Phone] = dini_Int(fh,"phone");
			bizElectronic[i][Boombox] = dini_Int(fh,"boombox");
			bizElectronic[i][PhonePrice] = dini_Int(fh,"phoneprice");
			bizElectronic[i][BoomboxPrice] = dini_Int(fh,"boomboxprice");
			bizElectronic[i][Balance] = dini_Int(fh,"balance");
			if(bizElectronic[i][PhonePrice] < 1) bizElectronic[i][PhonePrice] = 200;
			if(bizElectronic[i][BoomboxPrice] < 1) bizElectronic[i][BoomboxPrice] = 400;
			/* Formating things */
			if(strcmp(bizElectronic[i][Owner],"None")) {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Electronic Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
					i,
					bizElectronic[i][ShopName],
					bizElectronic[i][Owner]
				);
			}
			else {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Electronic Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
					i,
					bizElectronic[i][ShopName],
					bizElectronic[i][Owner],
					bizElectronic[i][Price]
				);
			}
			bizElectronic[i][Pickup] = CreateDynamicPickup(1274,0,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ]);
			bizElectronic[i][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ],10.0);
			dini_IntSet(fh,"pickup",bizElectronic[i][Pickup]);
			dini_IntSet(fh,"label",bizElectronic[i][Label]);
			printf("Electronic Business Loaded: %d",i);
		}
	}
	return 1;
}

stock LoadToolBiz()
{
	new
		fh[200],
		label[280];
	for(new i; i < MAX_TOOL; i++)
	{
		format(fh,sizeof(fh),BIZ_TOOL,i);
		if(fexist(fh)) {
			strcpy(bizTool[i][Owner], dini_Get(fh,"owner"));
			strcpy(bizTool[i][ShopName], dini_Get(fh,"shopname"));
			bizTool[i][EnterX] = dini_Float(fh,"enterx");
			bizTool[i][EnterY] = dini_Float(fh,"entery");
			bizTool[i][EnterZ] = dini_Float(fh,"enterz");
			bizTool[i][Price] = dini_Int(fh,"price");
			bizTool[i][WorldID] = dini_Int(fh,"worldid");
			bizTool[i][Repairkit] = dini_Int(fh,"repairkit");
			bizTool[i][Screwdriver] = dini_Int(fh,"screwdriver");
			bizTool[i][Crowbar] = dini_Int(fh,"crowbar");
			bizTool[i][Fishingrod] = dini_Int(fh,"fishingrod");
			bizTool[i][Rope] = dini_Int(fh,"rope");
			bizTool[i][ToolPrice][Repairkit] = dini_Int(fh,"repairkitprice");
			bizTool[i][ToolPrice][Fishingrod] = dini_Int(fh,"fishingrodprice");
			bizTool[i][ToolPrice][Screwdriver] = dini_Int(fh,"screwdriverprice");
			bizTool[i][Balance] = dini_Int(fh,"balance");
			if(strcmp(bizTool[i][Owner],"None",false)) {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Tool Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
					i,
					bizTool[i][ShopName],
					bizTool[i][Owner]
				);
			}
			else {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Tool Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000} For Sale $%d",
					i,
					bizTool[i][ShopName],
					bizTool[i][Owner],
					bizTool[i][Price]
				);
			}
			bizTool[i][Pickup] = CreateDynamicPickup(1274,0,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ]);
			bizTool[i][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ],10.0);
			dini_IntSet(fh,"pickup",bizTool[i][Pickup]);
			dini_IntSet(fh,"label",bizTool[i][Label]);
			printf("Tool Business Loaded: %d",i);
		}
	}
	return 1;
}

stock LoadClothesBiz()
{
	new
		fh[200],
		label[200];
	for(new i; i < MAX_CLOTHES; i++)
	{
		format(fh,sizeof(fh),BIZ_CLOTHES,i);
		if(fexist(fh)) {
			strcpy(bizClothes[i][Owner], dini_Get(fh,"owner"));
			strcpy(bizClothes[i][ShopName], dini_Get(fh,"shopname"));
			bizClothes[i][EnterX] = dini_Float(fh,"enterx");
			bizClothes[i][EnterY] = dini_Float(fh,"entery");
			bizClothes[i][EnterZ] = dini_Float(fh,"enterz");
			bizClothes[i][Price] = dini_Int(fh,"price");
			bizClothes[i][WorldID] = dini_Int(fh,"worldid");
			bizClothes[i][ClothesPrice] = dini_Int(fh,"clothesprice");
			bizClothes[i][Stock] = dini_Int(fh,"stock");
			bizClothes[i][Balance] = dini_Int(fh,"balance");
			if(strcmp(bizClothes[i][Owner],"None",false)) {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Clothes Shop\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
					i,
					bizClothes[i][ShopName],
					bizClothes[i][Owner]
				);
			}
			else {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Clothes Shop\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
					i,
					bizClothes[i][ShopName],
					bizClothes[i][Owner],
					bizClothes[i][Price]
				);
			}
			bizClothes[i][Pickup] = CreateDynamicPickup(1274,0,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ]);
			bizClothes[i][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ],10.0);
			dini_IntSet(fh,"pickup",bizClothes[i][Pickup]);
			dini_IntSet(fh,"label",bizClothes[i][Label]);
			printf("Clothes Business Loaded: %d",i);
		}
	}
}

stock LoadRestaurantBiz()
{
	new
		fh[200],
		label[200];
	for(new i; i < MAX_RESTAURANT; i++)
	{
		format(fh,sizeof(fh),BIZ_RESTAURANT,i);
		if(fexist(fh)) {
			strcpy(bizRestaurant[i][Owner], dini_Get(fh,"owner"));
			strcpy(bizRestaurant[i][ShopName], dini_Get(fh,"shopname"));
			bizRestaurant[i][EnterX] = dini_Float(fh,"enterx");
			bizRestaurant[i][EnterY] = dini_Float(fh,"entery");
			bizRestaurant[i][EnterZ] = dini_Float(fh,"enterz");
			bizRestaurant[i][Price] = dini_Int(fh,"price");
			bizRestaurant[i][WorldID] = dini_Int(fh,"worldid");
			bizRestaurant[i][Sprunk] = dini_Int(fh,"sprunk");
			bizRestaurant[i][Water] = dini_Int(fh,"water");
			bizRestaurant[i][Fish] = dini_Int(fh,"fish");
			bizRestaurant[i][Chicken] = dini_Int(fh,"chicken");
			bizRestaurant[i][SprunkPrice] = dini_Int(fh,"sprunkp");
			bizRestaurant[i][WaterPrice] = dini_Int(fh,"waterp");
			bizRestaurant[i][FishPrice] = dini_Int(fh,"fishp");
			bizRestaurant[i][ChickenPrice] = dini_Int(fh,"chickenp");
			format(bizRestaurant[i][SprunkName],30,"%s",dini_Get(fh,"sprunkn"));
			format(bizRestaurant[i][WaterName],30,"%s",dini_Get(fh,"watern"));
			format(bizRestaurant[i][FishName],30,"%s",dini_Get(fh,"fishn"));
			format(bizRestaurant[i][ChickenName],30,"%s",dini_Get(fh,"chickenn"));
			bizRestaurant[i][Balance] = dini_Int(fh,"balance");
			if(strcmp(bizRestaurant[i][Owner],"None",false)) {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Restaurant\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
					i,
					bizRestaurant[i][ShopName],
					bizRestaurant[i][Owner]
				);
			}
			else {
				format(label,
					sizeof(label),
					"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Restaurant\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
					i,
					bizRestaurant[i][ShopName],
					bizRestaurant[i][Owner],
					bizRestaurant[i][Price]
				);
			}
			bizRestaurant[i][Pickup] = CreateDynamicPickup(1274,0,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ]);
			bizRestaurant[i][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ],10.0);
			dini_IntSet(fh,"pickup",bizRestaurant[i][Pickup]);
			dini_IntSet(fh,"label",bizRestaurant[i][Label]);
			printf("Restaurant Business Loaded: %d",i);
		}
	}
}

stock SaveElectronicBiz()
{
	new biz_fh[200];
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		format(biz_fh,sizeof(biz_fh),BIZ_ELECTRONIC,i);
		if(fexist(biz_fh)) {
			dini_Set(biz_fh,"owner",bizElectronic[i][Owner]);
			dini_Set(biz_fh,"shopname",bizElectronic[i][ShopName]);
			dini_FloatSet(biz_fh,"enterx",bizElectronic[i][EnterX]);
			dini_FloatSet(biz_fh,"entery",bizElectronic[i][EnterY]);
			dini_FloatSet(biz_fh,"enterz",bizElectronic[i][EnterZ]);
			dini_IntSet(biz_fh,"price",bizElectronic[i][Price]);
			dini_IntSet(biz_fh,"worldid",bizElectronic[i][WorldID]);
			dini_IntSet(biz_fh,"pickup",bizElectronic[i][Pickup]);
			dini_IntSet(biz_fh,"label",bizElectronic[i][Label]);
			dini_IntSet(biz_fh,"phone",bizElectronic[i][Phone]);
			dini_IntSet(biz_fh,"boombox",bizElectronic[i][Boombox]);
			dini_IntSet(biz_fh,"phoneprice",bizElectronic[i][PhonePrice]);
			dini_IntSet(biz_fh,"boomboxprice",bizElectronic[i][BoomboxPrice]);
			dini_IntSet(biz_fh,"balance",bizElectronic[i][Balance]);
		}
	}
	return 1;
}

stock SaveToolBiz()
{
	new fh[200];
	for(new i; i < MAX_TOOL; i++)
	{
		format(fh,sizeof(fh),BIZ_TOOL,i);
		if(fexist(fh)) {
			dini_Set(fh,"owner",bizTool[i][Owner]);
			dini_Set(fh,"shopname",bizTool[i][ShopName]);
			dini_FloatSet(fh,"enterx",bizTool[i][EnterX]);
			dini_FloatSet(fh,"entery",bizTool[i][EnterY]);
			dini_FloatSet(fh,"enterz",bizTool[i][EnterZ]);
			dini_IntSet(fh,"price",bizTool[i][Price]);
			dini_IntSet(fh,"worldid",bizTool[i][WorldID]);
			dini_IntSet(fh,"pickup",bizTool[i][Pickup]);
			dini_IntSet(fh,"label",bizTool[i][Label]);
			dini_IntSet(fh,"repairkit",bizTool[i][Repairkit]);
			dini_IntSet(fh,"screwdriver",bizTool[i][Screwdriver]);
			dini_IntSet(fh,"crowbar",bizTool[i][Crowbar]);
			dini_IntSet(fh,"fishingrod",bizTool[i][Fishingrod]);
			dini_IntSet(fh,"rope",bizTool[i][Rope]);
			dini_IntSet(fh,"fishingrodprice",bizTool[i][ToolPrice][Fishingrod]);
			dini_IntSet(fh,"screwdriverprice",bizTool[i][ToolPrice][Screwdriver]);
			dini_IntSet(fh,"repairkitprice",bizTool[i][ToolPrice][Repairkit]);
			dini_IntSet(fh,"balance",bizTool[i][Balance]);
		}
	}
}

stock SaveClothesBiz()
{
	new biz_fh[200];
	for(new i; i < MAX_CLOTHES; i++)
	{
		format(biz_fh,sizeof(biz_fh),BIZ_CLOTHES,i);
		if(fexist(biz_fh)) {
			dini_Set(biz_fh,"owner",bizClothes[i][Owner]);
			dini_Set(biz_fh,"shopname",bizClothes[i][ShopName]);
			dini_FloatSet(biz_fh,"enterx",bizClothes[i][EnterX]);
			dini_FloatSet(biz_fh,"entery",bizClothes[i][EnterY]);
			dini_FloatSet(biz_fh,"enterz",bizClothes[i][EnterZ]);
			dini_IntSet(biz_fh,"price",bizClothes[i][Price]);
			dini_IntSet(biz_fh,"worldid",bizClothes[i][WorldID]);
			dini_IntSet(biz_fh,"pickup",bizClothes[i][Pickup]);
			dini_IntSet(biz_fh,"label",bizClothes[i][Label]);
			dini_IntSet(biz_fh,"clothesprice",bizClothes[i][ClothesPrice]);
			dini_IntSet(biz_fh,"stock",bizClothes[i][Stock]);
			dini_IntSet(biz_fh,"balance",bizClothes[i][Balance]);
		}
	}
}

stock SaveRestaurantBiz()
{
	new biz_fh[200];
	for(new i; i < MAX_RESTAURANT; i++)
	{
		format(biz_fh,sizeof(biz_fh),BIZ_RESTAURANT,i);
		if(fexist(biz_fh)) {
			dini_Set(biz_fh,"owner",bizRestaurant[i][Owner]);
			dini_Set(biz_fh,"shopname",bizRestaurant[i][ShopName]);
			dini_FloatSet(biz_fh,"enterx",bizRestaurant[i][EnterX]);
			dini_FloatSet(biz_fh,"entery",bizRestaurant[i][EnterY]);
			dini_FloatSet(biz_fh,"enterz",bizRestaurant[i][EnterZ]);
			dini_IntSet(biz_fh,"price",bizRestaurant[i][Price]);
			dini_IntSet(biz_fh,"worldid",bizRestaurant[i][WorldID]);
			dini_IntSet(biz_fh,"pickup",bizRestaurant[i][Pickup]);
			dini_IntSet(biz_fh,"label",bizRestaurant[i][Label]);
			dini_IntSet(biz_fh,"sprunk",bizRestaurant[i][Sprunk]);
			dini_IntSet(biz_fh,"water",bizRestaurant[i][Water]);
			dini_IntSet(biz_fh,"fish",bizRestaurant[i][Fish]);
			dini_IntSet(biz_fh,"chicken",bizRestaurant[i][Chicken]);
			dini_IntSet(biz_fh,"sprunkp",bizRestaurant[i][SprunkPrice]);
			dini_IntSet(biz_fh,"waterp",bizRestaurant[i][WaterPrice]);
			dini_IntSet(biz_fh,"fishp",bizRestaurant[i][FishPrice]);
			dini_IntSet(biz_fh,"chickenp",bizRestaurant[i][ChickenPrice]);
			dini_IntSet(biz_fh,"balance",bizRestaurant[i][Balance]);
			dini_Set(biz_fh,"sprunkn",bizRestaurant[i][SprunkName]);
			dini_Set(biz_fh,"watern",bizRestaurant[i][WaterName]);
			dini_Set(biz_fh,"fishn",bizRestaurant[i][FishName]);
			dini_Set(biz_fh,"chickenn",bizRestaurant[i][ChickenName]);
		}
	}
}

stock isNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

stock LoadAdLog()
{
	new
		parsev[100];

	for(new i; i < 60; i++)
	{
		format(parsev,sizeof(parsev),"ad%d",i);
		if(!fexist(AD_LOG_DIR)) {
			ftouch(AD_LOG_DIR);
			strcpy(sAdLog[i]," ");
		}
		else {
			strcpy(sAdLog[i],dini_Get(AD_LOG_DIR,parsev));
		}
	}
	printf("[AD-LOG][LOAD/SAVE]: Ad Log has been loaded");
	return 1;
}

stock SaveAdLog()
{
	new
		parsev[100];

	for(new i; i < 60; i++)
	{
		format(parsev,sizeof(parsev),"ad%d",i);
		if(!fexist(AD_LOG_DIR)) {
			ftouch(AD_LOG_DIR);
			strcpy(sAdLog[i]," ");
			dini_Set(AD_LOG_DIR,parsev,sAdLog[i]);
		}
		else {
			dini_Set(AD_LOG_DIR,parsev,sAdLog[i]);
		}
	}
	printf("[AD-LOG][LOAD/SAVE]: Ad Log has been saved");
	return 1;
}

stock AdLogger(text[])
{
	for(new i; i < 60; i++)
	{
		if(!strcmp(sAdLog[i]," ",false)) {
			strcpy(sAdLog[i],text);
			printf("[AD-LOG][LOGGER]: An Ad Has Been Logged Into Logger File");
			break;
		}
		else if(strcmp(sAdLog[i]," ",false) && i == 59) {
			for(new adc; adc < 60; adc++)
			{
				strcpy(sAdLog[adc]," ");
			}
			strcpy(sAdLog[i],text);
			printf("[AD-LOG][LOGGER /w RESET LOGGER]: An Ad Has Been Logged Into Logger File");
			break;
		}
		else continue;
	}
	return 1;
}

stock ResetAdLog()
{
	for(new adc; adc < 60; adc++)
	{
		strcpy(sAdLog[adc]," ");
	}
	printf("[AD-LOG][RESET]: Ad log has been reseted");
	return 1;
}

stock RefreshAdLog()
{
	SaveAdLog();
	ResetAdLog();
	LoadAdLog();
}

stock SendAdMessage(playerid, color, text[])
{
	new msg[800];
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) {
			format(msg,sizeof(msg),"[Advertisement]: %s", text);
			SendClientMessage(i, color, msg);
			format(msg,sizeof(msg),"[Contact Phone]: %d", pStat[playerid][PhoneNumber]);
			SendClientMessage(i, color, msg);
			return 1;
		}
	}
	return 1;
}

stock UpdateElectronicBizLabel(electronicid, const owner[] = "None",const shopname[] = "None")
{
	new
		label[800],
		fh[200];
	format(fh,sizeof(fh),BIZ_ELECTRONIC,electronicid);
	if(!fexist(fh)) return 0;
	else if(fexist(fh)) {
		strcpy(bizElectronic[electronicid][Owner],owner);
		strcpy(bizElectronic[electronicid][ShopName],shopname);
		DestroyDynamic3DTextLabel(dini_Int(fh,"label"));
		if(strcmp(owner,"None",false)) {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Electronic Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
				electronicid,
				bizElectronic[electronicid][ShopName],
				bizElectronic[electronicid][Owner]
			);
		}
		else {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Electronic Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
				electronicid,
				bizElectronic[electronicid][ShopName],
				bizElectronic[electronicid][Owner],
				bizElectronic[electronicid][Price]
			);
		}
		bizElectronic[electronicid][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizElectronic[electronicid][EnterX],bizElectronic[electronicid][EnterY],bizElectronic[electronicid][EnterZ],10.0);
		dini_IntSet(fh,"label",bizElectronic[electronicid][Label]);
		return 1;
	}
	return 0;
}

stock UpdateToolBizLabel(toolid, const owner[] = "None", const shopname[] = "None")
{
	new
		label[800],
		fh[200];
	format(fh,sizeof(fh),BIZ_TOOL,toolid);
	if(!fexist(fh)) return 0;
	else if(fexist(fh)) {
		strcpy(bizTool[toolid][Owner],owner);
		strcpy(bizTool[toolid][ShopName],shopname);
		DestroyDynamic3DTextLabel(dini_Int(fh,"label"));
		if(strcmp(owner,"None",false)) {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Tool Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
				toolid,
				bizTool[toolid][ShopName],
				bizTool[toolid][Owner]
			);
		}
		else {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Tool Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000} For Sale $%d",
				toolid,
				bizTool[toolid][ShopName],
				bizTool[toolid][Owner],
				bizTool[toolid][Price]
			);
		}
		bizTool[toolid][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizTool[toolid][EnterX],bizTool[toolid][EnterY],bizTool[toolid][EnterZ],10.0);
		dini_IntSet(fh,"label",bizTool[toolid][Label]);
		return 1;
	}
	return 0;
}

stock UpdateClothesBizLabel(clothesid, const owner[] = "None", const shopname[] = "None")
{
	new
		label[400],
		fh[200];
	format(fh,sizeof(fh),BIZ_CLOTHES,clothesid);
	if(!fexist(fh)) return 0;
	else if(fexist(fh)) {
		strcpy(bizClothes[clothesid][Owner],owner);
		strcpy(bizClothes[clothesid][ShopName],shopname);
		DestroyDynamic3DTextLabel(dini_Int(fh,"label"));
		if(strcmp(owner,"None",false)) {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Clothes Shop\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
				clothesid,
				bizClothes[clothesid][ShopName],
				bizClothes[clothesid][Owner]
			);
		}
		else {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Clothes Shop\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
				clothesid,
				bizClothes[clothesid][ShopName],
				bizClothes[clothesid][Owner],
				bizClothes[clothesid][Price]
			);
		}
		bizClothes[clothesid][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizClothes[clothesid][EnterX],bizClothes[clothesid][EnterY],bizClothes[clothesid][EnterZ],10.0);
		dini_IntSet(fh,"label",bizClothes[clothesid][Label]);
		return 1;
	}
	return 0;
}

stock UpdateRestaurantBizLabel(restid, const owner[] = "None", const shopname[] = "None")
{
	new
		label[400],
		fh[200];
	format(fh,sizeof(fh),BIZ_RESTAURANT,restid);
	if(!fexist(fh)) return 0;
	else if(fexist(fh)) {
		strcpy(bizRestaurant[restid][Owner],owner);
		strcpy(bizRestaurant[restid][ShopName],shopname);
		DestroyDynamic3DTextLabel(dini_Int(fh,"label"));
		if(strcmp(owner,"None",false)) {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Restaurant\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter",
				restid,
				bizRestaurant[restid][ShopName],
				bizRestaurant[restid][Owner]
			);
		}
		else {
			format(label,
				sizeof(label),
				"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Restaurant\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
				restid,
				bizRestaurant[restid][ShopName],
				bizRestaurant[restid][Owner],
				bizRestaurant[restid][Price]
			);
		}
		bizRestaurant[restid][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,bizRestaurant[restid][EnterX],bizRestaurant[restid][EnterY],bizRestaurant[restid][EnterZ],10.0);
		dini_IntSet(fh,"label",bizRestaurant[restid][Label]);
		return 1;
	}
	return 0;
}

stock UpdateRestaurantFoodName(restid, foodtype, const name[])
{
	new
		label[400],
		fh[200];
	format(fh,sizeof(fh),BIZ_RESTAURANT,restid);
	if(!fexist(fh)) return 0;
	else if(fexist(fh)) {
		if(foodtype > 3 || foodtype < 0) return 1;
		switch(foodtype)
		{
			case 0: // sprunk
			{
				format(bizRestaurant[restid][SprunkName],30,"%s",name);
				if(isnull(name)) format(bizRestaurant[restid][SprunkName],30,"NULL");
			}
			case 1: // water
			{
				format(bizRestaurant[restid][WaterName],30,"%s",name);
				if(isnull(name)) format(bizRestaurant[restid][WaterName],30,"NULL");
			}
			case 2: // fish
			{
				format(bizRestaurant[restid][FishName],30,"%s",name);
				if(isnull(name)) format(bizRestaurant[restid][FishName],30,"NULL");
			}
			case 3:
			{
				format(bizRestaurant[restid][ChickenName],30,"%s",name);
				if(isnull(name)) format(bizRestaurant[restid][ChickenName],30,"NULL");
			}
		}
		return 1;
	}
	return 0;
}

stock CheckValidName(playerid, const name[])
{
	if(regex_match(name,"^[A-Za-z]*[_]*[A-Za-z]$")) {
		SendClientMessage(playerid, 0xFF000000, "Your Username Is Incorrect, Correct Example: Firstname_Lastname");
		Kick2(playerid,1000);
		return 0;
	}
	return 1;
}

stock BlockObj()
{
	CreateDynamicObject(971, 720.06940, -462.57724, 15.39299,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1042.84998, -1026.01123, 31.09643,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1025.36536, -1029.33276, 31.63884,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -1420.50977, 2591.11279, 56.94583,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(971, 2386.68213, 1043.31189, 9.92575,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8167, 2645.81055, -2039.32849, 12.56419,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8167, 2645.81055, -2039.32849, 15.00648,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, -1935.82751, 238.56221, 33.64063,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -1904.62756, 277.66324, 42.39743,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -2716.14404, 216.72392, 3.81582,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 1843.31055, -1855.03943, 12.37510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 2005.17334, 2303.33716, 9.81711,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1968.37793, 2162.65747, 12.66515,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(971, 2393.19873, 1483.32202, 12.39729,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -99.80347, 1111.46582, 20.85815,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -2425.07886, 1027.89941, 51.84350,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(971, 2071.52344, -1831.55835, 13.00516,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 488.63022, -1735.32129, 10.59052,   0.00000, 0.00000, -8.46000);
	return 1;
}

stock ToolshopObj()
{
	CreateDynamicObject(18981, 143.20140, 1698.66223, 1000.63629,   0.00000, -90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19445, 131.41640, 1707.36047, 1002.65430,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19445, 131.40825, 1697.72766, 1002.65430,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(1209, 131.90987, 1709.46790, 1001.13458,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19445, 135.72769, 1693.13965, 1002.65430,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19445, 145.11429, 1693.13904, 1002.65430,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19445, 149.40813, 1697.56848, 1002.65430,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19445, 147.15585, 1701.94348, 1002.65430,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19445, 142.43573, 1706.68042, 1002.65430,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19383, 140.75162, 1711.27844, 1002.65430,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19445, 134.40767, 1711.28113, 1002.65430,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(18981, 143.86020, 1699.70251, 1004.87628,   0.00000, -90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(1569, 139.98860, 1711.23523, 1000.99432,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2400, 131.82756, 1704.07397, 1001.19568,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(3761, 138.22919, 1696.98218, 1001.57410,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(939, 143.55930, 1694.40698, 1001.64203,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19815, 142.34419, 1706.77380, 1003.27441,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(19815, 142.32114, 1703.60742, 1003.27441,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(337, 132.07310, 1704.50391, 1003.14368,   177.00000, 90.00000, -97.00000,.interiorid = 1);
	CreateDynamicObject(0, 132.09250, 1706.18384, 1003.14368,   177.00000, 90.00000, -97.00000,.interiorid = 1);
	CreateDynamicObject(2314, 141.85019, 1704.63232, 1001.12329,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(2314, 141.85953, 1707.71594, 1001.12329,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(18635, 142.03564, 1704.84863, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18635, 141.73378, 1704.87195, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18635, 142.01134, 1704.22607, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18635, 141.65071, 1704.22571, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18635, 141.59135, 1703.53186, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18635, 144.11320, 1696.95496, 1001.12610,   90.00000, 0.00000, 321.00000,.interiorid = 1);
	CreateDynamicObject(18635, 141.99159, 1703.51758, 1001.62610,   90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18634, 141.68460, 1707.51038, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18634, 142.04504, 1707.56799, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18634, 141.95889, 1706.72827, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18634, 141.82645, 1706.14136, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18634, 141.86331, 1706.39478, 1001.68597,   30.00000, 90.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(2695, 137.41550, 1711.17126, 1003.44531,   0.00000, 3.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(3119, 142.25829, 1701.63367, 1001.42603,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(1893, 134.28622, 1707.11243, 1004.33911,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(1893, 137.89612, 1707.25891, 1004.33911,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(1893, 140.75298, 1696.47742, 1004.33911,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(1893, 136.10976, 1697.05237, 1004.33911,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(1238, 141.90590, 1708.86865, 1001.44849,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(1238, 141.84770, 1709.16858, 1001.44849,   0.00000, 40.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(2641, 149.27130, 1698.82056, 1003.17041,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(2641, 149.27090, 1694.07776, 1003.17041,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(19285, 137.73239, 1707.38416, 1003.78491,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19285, 141.45847, 1706.46240, 1001.13446,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19281, 137.72859, 1707.89209, 1003.75574,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19281, 134.43793, 1707.84668, 1003.73730,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19281, 136.06776, 1698.29260, 1003.75226,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19281, 140.64905, 1697.64246, 1003.83521,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19826, 139.46480, 1711.16919, 1002.79907,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2729, 133.99950, 1711.17175, 1003.45978,   0.00000, 4.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(337, 138.38820, 1710.75000, 1001.46503,   0.00000, 30.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(337, 138.94847, 1710.74622, 1001.46503,   0.00000, 30.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(2009, 148.83994, 1699.39551, 1001.12451,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(1959, 148.87404, 1699.34009, 1001.93768,   0.00000, 0.00000, 180.00000,.interiorid = 1);
	CreateDynamicObject(1950, 147.64200, 1699.42615, 1002.11731,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19899, 147.54370, 1693.65796, 1001.13458,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(19370, 137.80156, 1705.60681, 1001.06232,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19370, 137.79559, 1702.41907, 1001.06232,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19370, 134.31320, 1702.44275, 1001.06232,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19370, 134.31567, 1705.62781, 1001.06232,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2000, 132.04559, 1702.38232, 1001.10388,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(2000, 132.04559, 1703.12231, 1001.10388,   0.00000, 0.00000, 90.00000,.interiorid = 1);
	CreateDynamicObject(18638, 132.29289, 1706.95483, 1002.83679,   -90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18638, 132.29965, 1706.35754, 1002.83679,   -90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18638, 132.27991, 1705.17444, 1002.83679,   -90.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2314, 135.85661, 1710.71301, 1001.12329,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2314, 133.11562, 1710.71423, 1001.12329,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19445, 131.40825, 1697.72766, 1002.65430,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(1886, 131.83260, 1693.66528, 1004.54260,   10.00000, 0.00000, 160.00000,.interiorid = 1);
	CreateDynamicObject(1886, 148.86833, 1693.97302, 1004.64832,   10.00000, 0.00000, 210.00000,.interiorid = 1);
	CreateDynamicObject(1430, 141.92740, 1710.33191, 1001.45612,   0.00000, 0.00000, -90.00000,.interiorid = 1);
	CreateDynamicObject(337, 132.14426, 1706.19189, 1003.14368,   177.00000, 90.00000, -97.00000,.interiorid = 1);
	CreateDynamicObject(3761, 134.15401, 1696.84436, 1001.57410,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 135.82140, 1710.93713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 136.36140, 1710.93713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 137.08141, 1710.93713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 137.56140, 1710.93713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 137.56140, 1710.55713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 137.02139, 1710.55713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 136.36140, 1710.55713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18644, 135.84140, 1710.55713, 1001.64600,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18638, 134.71471, 1710.85034, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 134.09470, 1710.85034, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 133.53470, 1710.85034, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 132.93469, 1710.85034, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 132.93469, 1710.49036, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 133.51469, 1710.49036, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 134.09470, 1710.49036, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18638, 134.71471, 1710.49036, 1001.70599,   0.00000, -90.00000, -180.00000,.interiorid = 1);
	CreateDynamicObject(18632, 137.59850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 137.73849, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 137.89850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.05850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.19850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.31850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.43851, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.55850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.67850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.81850, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18632, 138.93851, 1700.21667, 1001.39551,   190.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(19324, 145.08090, 1701.52148, 1001.77692,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(2314, 133.37389, 1700.25806, 1001.12329,   0.00000, 0.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 134.93510, 1700.11414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 134.41510, 1700.11414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 133.91510, 1700.11414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 133.37511, 1700.11414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 133.37511, 1700.49414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 133.91510, 1700.49414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 134.41510, 1700.49414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	CreateDynamicObject(18641, 134.93510, 1700.49414, 1001.64520,   0.00000, 90.00000, 0.00000,.interiorid = 1);
	return 1;
}

stock LoadElectronicItemObj()
{
	CreateDynamicObject(18869, -2236.96631, 127.79252, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18869, -2236.70630, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18869, -2236.42627, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18869, -2236.10620, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18867, -2235.58618, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18867, -2235.30640, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18867, -2235.00635, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18867, -2234.64624, 127.79250, 1035.46399,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(2028, -2231.81104, 127.77340, 1035.59448,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2226, -2235.28638, 129.41631, 1035.47986,   0.00000, 0.00000, -120.00000);
	CreateDynamicObject(2226, -2236.08618, 129.41631, 1035.47986,   0.00000, 0.00000, -120.00000);
	CreateDynamicObject(2226, -2234.42627, 129.41631, 1035.47986,   0.00000, 0.00000, -120.00000);
	CreateDynamicObject(1781, -2228.45703, 130.95360, 1036.00439,   0.00000, 0.00000, -33.00000);
	CreateDynamicObject(1781, -2227.23706, 130.95360, 1036.00439,   0.00000, 0.00000, -33.00000);
	CreateDynamicObject(19807, -2237.30664, 137.79880, 1035.53870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19807, -2237.02661, 137.79880, 1035.53870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19807, -2236.76660, 137.79880, 1035.53870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19807, -2236.52661, 137.79880, 1035.53870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19807, -2236.28662, 137.79880, 1035.53870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2099, -2230.93115, 138.02121, 1034.37671,   0.00000, 0.00000, -33.00000);
	CreateDynamicObject(18871, -2236.97729, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18871, -2236.79736, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18871, -2236.59741, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18871, -2236.41724, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18871, -2236.21729, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(18871, -2235.99731, 127.61670, 1035.79126,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(2103, -2228.60181, 133.66570, 1036.00464,   0.00000, 0.00000, -26.00000);
	CreateDynamicObject(2103, -2227.51099, 133.75337, 1036.00464,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(2149, -2237.95483, 134.54311, 1036.16431,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2149, -2237.95483, 133.86310, 1036.16431,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2149, -2237.95483, 133.24310, 1036.16431,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2149, -2237.95483, 132.66310, 1036.16431,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2232, -2232.84497, 127.95030, 1035.02405,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2232, -2233.74512, 127.95030, 1035.02405,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1785, -2229.57910, 136.79010, 1036.11255,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2190, -2241.02222, 130.55769, 1035.47998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2190, -2241.02222, 131.33771, 1035.47998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2190, -2241.02222, 132.13770, 1035.47998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2695, -2231.91724, 127.35710, 1036.89270,   0.00000, -5.00000, 0.00000);
	CreateDynamicObject(2641, -2222.01172, 144.32721, 1036.89685,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2641, -2235.29932, 138.14149, 1036.89685,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2641, -2232.09937, 138.14149, 1036.89685,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19893, -2240.77539, 133.84290, 1035.48022,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19893, -2240.77539, 134.46291, 1035.48022,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19893, -2240.77539, 135.06290, 1035.48022,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19893, -2240.77539, 135.60291, 1035.48022,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18875, -2233.47168, 137.81740, 1036.40649,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18875, -2233.23169, 137.81740, 1036.40649,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18875, -2233.73169, 137.81740, 1036.40649,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18875, -2233.99170, 137.81740, 1036.40649,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18875, -2234.25171, 137.81740, 1036.40649,   0.00000, 0.00000, 0.00000);
	return 1;
}

stock MechanicCenterObj()
{
	CreateDynamicObject(19447, 2914.74146, -800.24908, 11.76040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2909.35718, -800.23694, 11.76040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2914.74146, -828.88910, 15.24040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2914.74146, -828.88910, 11.76040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2909.33813, -800.24908, 15.24040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19379, 2909.33813, -804.98077, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2914.29614, -804.98077, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2914.29614, 0.36080, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2914.29614, -814.60083, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2909.33813, -814.60083, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2914.29614, -824.16083, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 2909.33813, -824.16083, 17.06220,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19447, 2909.33813, -828.88910, 15.24040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2909.33813, -828.88910, 11.76040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2914.74146, -800.24908, 15.24040,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, 2919.31738, -804.92664, 10.70080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19447, 2919.33936, -814.53607, 10.70080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19447, 2919.33911, -819.48572, 10.70080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19447, 2919.33911, -824.14569, 10.70080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8674, 2919.24878, -805.50677, 13.91280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8674, 2919.24878, -805.50677, 15.51280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8674, 2919.24878, -815.78680, 13.91280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8674, 2919.24878, -815.78680, 15.51280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4538, 2948.41406, -951.76563, -28.52344,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8674, 2919.24878, -823.62677, 13.91280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8674, 2919.24878, -823.62677, 15.51280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3666, 2904.27539, -828.89911, 10.54560,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3666, 2904.31592, -800.25500, 10.54470,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19899, 2917.49976, -800.77881, 10.04150,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19899, 2914.57959, -800.77881, 10.04150,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19872, 2910.25171, -823.51691, 8.26160,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19872, 2910.25171, -816.51691, 8.26160,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19872, 2910.25171, -809.51691, 8.26160,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19872, 2910.25171, -803.51691, 8.26160,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1080, 2919.09253, -803.06519, 10.48440,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1075, 2919.09253, -804.32520, 10.48440,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19903, 2913.39160, -821.38062, 10.04060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19903, 2913.39160, -807.66089, 10.04060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19903, 2913.39160, -814.52087, 10.04060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19903, 2912.49634, -801.40454, 10.04060,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(939, 2918.02246, -825.67950, 12.46340,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19815, 2919.22754, -808.62781, 11.75670,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1368, 2918.56567, -821.47028, 10.72360,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1368, 2918.56567, -818.47028, 10.72360,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1209, 2918.90869, -815.81628, 10.03490,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1893, 2911.27051, -805.86462, 16.95080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19285, 2911.52979, -806.13361, 16.37148,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1893, 2911.27051, -810.86462, 16.95080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19285, 2911.08130, -805.91431, 16.38924,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1893, 2911.27051, -815.86462, 16.95080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19285, 2916.76294, -810.09247, 16.96740,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1893, 2911.27051, -820.86462, 16.95080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19285, 2911.07422, -815.90979, 16.36310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1893, 2911.27051, -825.86462, 16.95080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19285, 2919.24634, -821.63794, 16.59645,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1139, 2918.73950, -801.64093, 10.98430,   0.00000, -70.00000, 0.00000);
	CreateDynamicObject(1139, 2917.86743, -802.23340, 10.24430,   90.00000, 0.00000, -30.00000);
	CreateDynamicObject(2690, 2919.16992, -810.81842, 11.80770,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3465, 2913.69238, -828.31848, 11.34130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3465, 2910.43237, -828.31848, 11.34130,   0.00000, 0.00000, 90.00000);
	return 1;
}

stock Float:GetVehicleSpeed(vehicleid)
{
    new
        Float:x,
        Float:y,
        Float:z;

    if(GetVehicleVelocity(vehicleid, x, y, z))
    {
        return floatsqroot((x * x) + (y * y) + (z * z)) * 181.5;
    }

    return 0.0;
}

stock SetVehicleSpeed(vehicleid, Float:speed)
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:a;
    GetVehicleVelocity(vehicleid, x1, y1, z1);
    GetVehiclePos(vehicleid, x2, y2, z2);
    GetVehicleZAngle(vehicleid, a); a = 360 - a;
    x1 = (floatsin(a, degrees) * (speed/181) + floatcos(a, degrees) * 0 + x2) - x2;
    y1 = (floatcos(a, degrees) * (speed/181) + floatsin(a, degrees) * 0 + y2) - y2;
    SetVehicleVelocity(vehicleid, x1, y1, z1);
}


stock SetPlayerSkin2(playerid, skinid)
{
    SetPVarInt(playerid, "SetSkin2", skinid);
    SetTimerEx("ChangeSkin", 100, 0, "d", playerid);
    return 1;
}

stock BusStationObj()
{
	CreateDynamicObject(3749, 1264.34082, -2047.71179, 64.25500,   0.00000, 2.00000, 0.00000);
	CreateDynamicObject(984, 1249.11523, -2045.59021, 59.51070,   1.80000, 0.00000, 90.00000);
	CreateDynamicObject(984, 1279.94141, -2040.13867, 58.81770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 1279.94141, -2027.33875, 58.81770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1276.72510, -2046.54248, 58.84960,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 1244.93518, -2045.59021, 59.57070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 1279.94141, -2014.53870, 58.81770,   0.00000, 0.00000, 0.00000);
	//CreateDynamicObject(3578, 1263.83813, -2045.99438, 58.97420,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4641, 1271.98132, -2041.80396, 59.79790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(968, 1270.08521, -2041.68713, 58.21790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4641, 1255.80127, -2041.80396, 59.79790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(968, 1257.78516, -2041.68713, 58.21790,   0.00000, 0.00000, 0.00000);
	//CreateDynamicObject(3666, 1263.85278, -2040.65479, 58.74120,   0.00000, 0.00000, 0.00000);
	return 1;
}

stock LoadSMSLog(playerid)
{
	new smsdat[200];
	new format_f[100];
	format(format_f,sizeof(format_f),PLAYER_PHONE_SMS,RetPname(playerid));
	for(new i; i < 30; i++)
	{
		if(fexist(format_f)) {
			format(smsdat,sizeof(smsdat),"sms%d",i);
			strcpy(pSMS[playerid][i],dini_Get(format_f,smsdat));
		}
		else {
			strcpy(pSMS[playerid][i]," ");
		}
	}
	printf("[SMS-LOG]: %s's SMS log has been loaded",RetPname(playerid));
	return 1;
}

stock NormalizeHeat(playerid)
{
	pVehicle[playerid][Heat] = 45.0;
	pVehicle[playerid][RadiatorHealth] = 100.0;
	pVehicle[playerid][Oil] = 100.0;
	pVehicle[playerid][Battery] = 100.0;
	return 1;
}

/* EOS */

/* Forwaded Function */
func:LoadBiz()
{
	/* Loading Business */
	LoadElectronicBiz();
	LoadToolBiz();
	LoadClothesBiz();
	LoadRestaurantBiz();
	return 1;
}

func:UpdateStatus(playerid)
{
	new Float:_g[4];
	_g[0] = pStatus[playerid][Hunger];
	_g[1] = pStatus[playerid][Thirst];
	_g[2] = pStatus[playerid][Energy];
	GetPlayerHealth(playerid, _g[3]);
	if(_g[0] > 0.0) {
		pStatus[playerid][Hunger] -= 0.50;
	}
	if(_g[1] > 0.0) {
		pStatus[playerid][Thirst] -= 0.80;
	}
	if(_g[2] > 0.0) {
		pStatus[playerid][Energy] -= 1.50;
	}
	if(_g[0] <= 0.0) {
		//FreezePlayer(playerid, 3000);
		SetPlayerHealth(playerid, (_g[3] - 5));
		ApplyAnimation(playerid, "PED", "DAM_STOMACH_FRMFT", 4.0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You are hungry go get some food");
	}
	if(_g[1] <= 0.0) {
		//FreezePlayer(playerid, 3000);
		SetPlayerHealth(playerid, (_g[3] - 3));
		ApplyAnimation(playerid, "PED", "DAM_STOMACH_FRMFT", 4.0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You are thirsty go drink some fluid");
	}
	if(_g[2] <= 0.0) {
		SetPlayerHealth(playerid, (_g[3] - 1));
		SetPlayerDrunkLevel(playerid, DL_TIRED);
		SendClientMessage(playerid, -1, "You feel tired eat foods or drink fluid to refill your energy");
	}
	return 1;
}

func:SetRandomWeather()
{
	new rng = random(18);
	SetWeather(rng);
	return 1;
}

func:FishingTimer(playerid)
{
	new rng_fish[2];
	rng_fish[0] = minrand(1,1000);
	rng_fish[1] = random(10);
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid,1);
	pState[playerid][Fishing] = false;
	if(pInventory[playerid][ToolDurability][Rod] <= 0) {
		pInventory[playerid][Rod] = false;
		pInventory[playerid][ToolDurability][Rod] = 0;
		pToolEquip[playerid][Rod] = false;
		pToolEquip[playerid][Equip] = false;
		RemovePlayerAttachedObject(playerid, OBJECT_INDEX_ROD);
		SendClientMessage(playerid, -1, "You fishing rod is broken!");
	}
	switch(rng_fish[1]) {
		case 2,4,6,8:
		{
			pInventory[playerid][Fish][Count] += 1;
			pInventory[playerid][Fish][Weigth] += rng_fish[0];
			SendClientMessageEx(playerid, -1, "{00FFFF}[FISHING]{FFFFFF}: You have caught a fish, Weigth: {FFFF00}%d grams",rng_fish[0]);
		}
		default:
		{
			SendClientMessage(playerid, -1, "{00FFFF}[FISHING]{FFFFFF}: You have caught a junk");
		}
	}
	return 1;
}

func:CountdownTimer()
{
	new str[80];
	if(CountdownCount > 0) {
		CountdownCount--;
		format(str,sizeof(str),"Countdown: ~w~%i",CountdownCount);
		TextDrawSetString(GlobalTextdraw[Countdown], str);
	}
	if(CountdownCount == 0) {
		CountdownC = false;
		TextDrawHideForAll(GlobalTextdraw[Countdown]);
	}
	return 1;
}

func:UnloadTruck(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SendClientMessage(playerid, -1, "Truck unloaded");
	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
	{
		case 499: //6
		{
			GivePlayerMoney(playerid, 120);
			SendClientMessage(playerid, -1, "You got paid {008000}$120{FFFFFF} for delivering the goods");
		}
		case 609: //4
		{
			GivePlayerMoney(playerid, 80);
			SendClientMessage(playerid, -1, "You got paid {008000}$80{FFFFFF} for delivering the goods");
		}
		case 414: //5
		{
			GivePlayerMoney(playerid, 100);
			SendClientMessage(playerid, -1, "You got paid {008000}$100{FFFFFF} for delivering the goods");
		}
		case 456: //8
		{
			GivePlayerMoney(playerid, 140);
			SendClientMessage(playerid, -1, "You got paid {008000}$140{FFFFFF} for delivering the goods");
		}
	}
	sTruck[GetPlayerVehicleID(playerid)][Loaded] = false;
	pMission[playerid][Trucker] = false;
	return 1;
}

func:LoadTruck(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, 1);
	IsLoadingTruck[playerid] = false;
	pMission[playerid][Trucker] = true;
	sTruck[vehicleid][ID] = vehicleid;
	sTruck[vehicleid][Loaded] = true;
	new ri = random(sizeof(TruckDest));
	SetPlayerCheckpoint(playerid, TruckDest[ri][0], TruckDest[ri][1], TruckDest[ri][2], 4.0);
	SendClientMessage(playerid, -1, "Deliver the goods to the checkpoint");
	return 1;
}

func:RefuelTime(playerid)
{
	TogglePlayerControllable(playerid, 1);
	g_Fuel[GetPlayerVehicleID(playerid)] = 100.0;
	IsRefueling[playerid] = false;
	SendClientMessage(playerid, -1, "Vehicle Refilled");
	return 1;
}

func:HeatUpdate()
{
	new engine, lights, alarm, doors, bonnet, boot, objective, Float:health;
	foreach(new i : Player)
	{
		GetVehicleHealth(pVehicle[i][ID], health);
		UpdateVehicleData(i);
		GetVehicleParamsEx(pVehicle[i][ID], engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine == 1 && pVehicle[i][Heat] > 30.0 && GetVehicleSpeed(pVehicle[i][ID]) < 30.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] -= 0.1;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] -= 0.3;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] -= 0.5;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] -= 0.7;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] -= 0.9;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] -= 1.0;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.005;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.007;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.05;
		}
		else if(engine == 0 && pVehicle[i][Heat] > 30.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] -= 0.3;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] -= 0.5;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] -= 0.7;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] -= 0.9;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] -= 1.0;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] -= 1.3;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.005;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.007;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.05;
		}

		if(engine == 1 && (GetVehicleSpeed(pVehicle[i][ID]) > 50.0 && GetVehicleSpeed(pVehicle[i][ID]) < 80.0) && pVehicle[i][RadiatorHealth] > 0.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] += 0.05;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] += 0.03;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] += 0.01;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] += 0.009;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] += 0.007;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] += 0.005;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.007;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.05;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.07;
			if(pVehicle[i][RadiatorHealth] > 0.0) pVehicle[i][RadiatorHealth] -= 0.04;
		}
		else if(engine == 1 && (GetVehicleSpeed(pVehicle[i][ID]) > 80.0 && GetVehicleSpeed(pVehicle[i][ID]) < 120.0) && pVehicle[i][RadiatorHealth] > 0.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] += 0.07;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] += 0.05;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] += 0.03;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] += 0.01;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] += 0.009;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] += 0.007;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.007;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.05;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.07;
			if(pVehicle[i][RadiatorHealth] > 0.0) pVehicle[i][RadiatorHealth] -= 0.06;
		}
		else if(engine == 1 && (GetVehicleSpeed(pVehicle[i][ID]) > 120.0 && GetVehicleSpeed(pVehicle[i][ID]) < 160.0) && pVehicle[i][RadiatorHealth] > 0.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] += 0.3;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] += 0.1;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] += 0.09;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] += 0.07;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] += 0.05;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] += 0.03;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.007;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.05;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.07;
			if(pVehicle[i][RadiatorHealth] > 0.0) pVehicle[i][RadiatorHealth] -= 0.08;
		}
		else if(engine == 1 && GetVehicleSpeed(pVehicle[i][ID]) > 160.0 && pVehicle[i][RadiatorHealth] > 0.0) {
			if(pVehicle[i][Radiator] == 0) pVehicle[i][Heat] += 0.5;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Heat] += 0.3;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Heat] += 0.1;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Heat] += 0.09;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Heat] += 0.07;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Heat] += 0.06;

			if(pVehicle[i][Radiator] == 0) pVehicle[i][Battery] -= 0.009;
			else if(pVehicle[i][Radiator] == 1) pVehicle[i][Battery] -= 0.01;
			else if(pVehicle[i][Radiator] == 2) pVehicle[i][Battery] -= 0.03;
			else if(pVehicle[i][Radiator] == 3) pVehicle[i][Battery] -= 0.05;
			else if(pVehicle[i][Radiator] == 4) pVehicle[i][Battery] -= 0.07;
			else if(pVehicle[i][Radiator] == 5) pVehicle[i][Battery] -= 0.09;
			if(pVehicle[i][RadiatorHealth] > 0.0) pVehicle[i][RadiatorHealth] -= 0.1;
		}
		if(engine == 1 && pVehicle[i][Heat] >= 180.0) {
			SetVehicleParamsEx(pVehicle[i][ID], 0, lights, alarm, doors, bonnet, boot, objective);
			if(IsPlayerInVehicle(i, pVehicle[i][ID]))GameTextForPlayer(i, "~r~Engine Overheated", 3000, 5);
		}
		if(engine == 1 && pVehicle[i][RadiatorHealth] <= 0.0)
		{
			new rcha = random(5);
			SetVehicleParamsEx(pVehicle[i][ID], 0, lights, alarm, doors, bonnet, boot, objective);
			if(IsPlayerInVehicle(i, pVehicle[i][ID])) {
				GameTextForPlayer(i, "~r~Engine Overheated", 3000, 5);
			}
			if(pVehicle[i][Radiator] > 0) {
				switch(rcha) {
					case 1:
					{
						pVehicle[i][Radiator] -= 1;
						SendClientMessage(i, -1, "Your vehicle radiator has been automatically downgraded, because of the radiator is broken");
					}
				}
			}
		}
		if(engine == 1 && pVehicle[i][Oil] > 0.0) {
			pVehicle[i][Oil] -= 0.01;
		}
		else if(engine == 1 && pVehicle[i][Oil] > 0.0 && health < 300.0) {
			pVehicle[i][Oil] -= 0.05;
		}
		if(pVehicle[i][Oil] <= 0.0 && engine == 1) {
			SetVehicleParamsEx(pVehicle[i][ID], 0, lights, alarm, doors, bonnet, boot, objective);
			if(IsPlayerInVehicle(i, pVehicle[i][ID])) {
				GameTextForPlayer(i, "~r~Engine Dies", 3000, 5);
				SendClientMessage(i, -1, "The oil is dry, ask mechanics to refill the oil");
			}
		}
		if(engine == 1 && pVehicle[i][Fuel] > 0.0) {
			new vid;
			for(new v; v < MAX_VEHICLES; v++)
			{
				if(v == pVehicle[i][ID]) vid = v;
			}
			if(GetVehicleSpeed(pVehicle[i][ID]) < 80.0) g_Fuel[vid] -= 0.01;
			else if(GetVehicleSpeed(pVehicle[i][ID]) > 80.0) g_Fuel[vid] -= 0.03;
		}
		if(engine == 1 && pVehicle[i][Fuel] <= 0.0) {
			SetVehicleParamsEx(pVehicle[i][ID], 0, lights, alarm, doors, bonnet, boot, objective);
			if(IsPlayerInVehicle(i, pVehicle[i][ID])) {
				GameTextForPlayer(i, "~r~Out of Fuel", 3000, 5);
			}
		}
		if(engine == 1 && pVehicle[i][Battery] <= 0.0) {
			SetVehicleParamsEx(pVehicle[i][ID], 0, lights, alarm, doors, bonnet, boot, objective);
			if(IsPlayerInVehicle(i, pVehicle[i][ID])) {
				GameTextForPlayer(i, "~r~Battery Dies", 3000, 5);
			}
		}
	}
}

func:EngineRandomDies()
{
	new Float:h;
	new engine, lights, alarm, doors, bonnet, boot, objective;
	new rcha[2];
	rcha[0] = random(10);
	rcha[1] = random(5);
	foreach(new i : Player)
	{
		for(new v; v < MAX_VEHICLES; v++)
		{
			GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
			if(GetPlayerVehicleID(i) == v && GetPlayerState(i) == PLAYER_STATE_DRIVER && engine == 1) {
				GetVehicleHealth(v, h);
				if(h < 400.0) {
					switch(rcha[0]) {
						case 1,3,5,7,9:
						{
							return 1;
						}
						case 2,4,6,8:
						{
							SetVehicleParamsEx(v, 0, lights, alarm, doors, bonnet, boot, objective);
							GameTextForPlayer(i, "~r~Engine Dies", 3000, 5);
						} 
					}
				}
				else if(h < 300.0) {
					switch(rcha[0]) {
						case 1,2,3:
						{
							return 1;
						}
						case 4:
						{
							SetVehicleParamsEx(v, 0, lights, alarm, doors, bonnet, boot, objective);
							GameTextForPlayer(i, "~r~Engine Dies", 3000, 5);
						}
					}
				} 
			}
		}
	}
	return 1;
}

func:UpdateTime()
{
	new
		h,
		m;
	gettime(h,m);
	SetWorldTime(h);
	return 1;
}

func:ChangeSkin(playerid)
{
    SetPlayerSkin(playerid, GetPVarInt(playerid, "SetSkin2"));
    return 1;
}

func:FreezePlayer(playerid, time) { 
    if(0 < time) { 
        SetTimerEx("FreezePlayer", time, false, "ii", playerid, 0); 
    } 
    TogglePlayerControllable(playerid, !time); 
}

func:Kick2(playerid, delay) {
	if(0 < delay) {
		SetTimerEx("Kick2", delay, false, "ii", playerid, 0);
	}
	else Kick(playerid);
}

func:NoExplodingVeh()
{
	new
		Float:vh;
	for(new i; i < MAX_VEHICLES; i++)
	{
		GetVehicleHealth(i,vh);
		if(vh < 250) {
			SetVehicleHealth(i, 260);
		}
	}
	return 1;
}

func:SetSweeperToRespawn2(delay) {
	if(0 < delay) {
		SetTimerEx("SetSweeperToRespawn2", delay, false, "i", 0);
	}
	else SetSweeperToRespawn();
}

func:GunCraft(playerid)
{
	new chance = random(2);
	switch(chance) {
		case 0:
		{
			ClearAnimations(playerid);
			pInventory[playerid][GunPart] += 1;
			SendClientMessage(playerid, -1, "You {008000}Successfully{FFFFFF} Crafted 1 Gun Part");
			pState[playerid][CraftingGun] = false;
		}
		case 1:
		{
			ClearAnimations(playerid);
			SendClientMessage(playerid, -1, "You {FF0000}Failed{FFFFFF} Crafted 1 Gun Part, You lost 3 Materials");
			pState[playerid][CraftingGun] = false;
		}
	}
	return 1;
}

func:LevelCalculate(playerid) {
	new msg[200];
	if(pAccount[playerid][LevelCount] > 0) {
		pAccount[playerid][LevelCount] -= 1;
	}
	else if(pAccount[playerid][LevelCount] <= 0) {
		pAccount[playerid][LevelCount] = 60;
		pAccount[playerid][XP] += 1;
		if(pAccount[playerid][XP] >= pAccount[playerid][XPMax]) {
			pAccount[playerid][XP] = 0;
			pAccount[playerid][XPMax] += 1;
			SetPlayerScore(playerid, (GetPlayerScore(playerid) + 1));
			SendClientMessage(playerid, -1, "{00AAAA}[LEVEL]{FFFFFF} You have leveled up!");
		}
		format(msg,sizeof(msg),"{00FFFF}[LEVEL]{FFFFFF} You have %d XP, you need %d XP to level up", pAccount[playerid][XP], pAccount[playerid][XPMax]);
		SendClientMessage(playerid, -1, msg);
	}
}

func:UpdateRentTime()
{
	for(new i; i < MAX_RENTVEH_FAGGIO; i++)
	{
		if(vRent[i][Rented])
		{
			if(vRent[i][RentTime] > 0) {
				vRent[i][RentTime] -= 1;
			}
			else if(vRent[i][RentTime] == 0) {
				DestroyVehicle(vRent[i][ID]);
				vRent[i][Owner] = EOS;
				vRent[i][Rented] = false;
			}
		}
	}
	return 1;
}

/* EOS */

/* Fetch Value Y_ini */

func:LoadPlayerPosition_position(playerid, name[], value[])
{
	INI_Float("posx", pPosition[playerid][pX]);
	INI_Float("posy", pPosition[playerid][pY]);
	INI_Float("posz", pPosition[playerid][pZ]);
	INI_Float("posrot", pPosition[playerid][pRot]);
	INI_Int("interior", pPosition[playerid][InteriorID]);
	INI_Int("world", pPosition[playerid][WorldID]);
	INI_Int("skin", pPosition[playerid][SkinID]);
	return 1;
}

func:LoadPlayerStatus_status(playerid, name[], value[])
{
	INI_Float("health", pStatus[playerid][Health]);
	INI_Float("armour", pStatus[playerid][Armour]);
	INI_Float("hunger",pStatus[playerid][Hunger]);
	INI_Float("thirst",pStatus[playerid][Thirst]);
	INI_Float("energy",pStatus[playerid][Energy]);
	return 1;
}

func:LoadPlayerStats_stats(playerid, name[], value[])
{
	INI_Int("money",pStat[playerid][Money]);
	INI_Int("score",pStat[playerid][Score]);
	INI_Int("number",pStat[playerid][PhoneNumber]);
	return 1;
}

func:LoadPlayerInventory_inventory(playerid, name[], value[])
{
	INI_Int("material",pInventory[playerid][Material]);
	INI_Int("gunpart",pInventory[playerid][GunPart]);
	INI_Int("product",pInventory[playerid][Product]);
	INI_Int("component",pInventory[playerid][Component]);
	INI_Bool("phone",pInventory[playerid][Phone]);
	INI_Bool("boombox",pInventory[playerid][Boombox]);
	INI_Bool("rod",pInventory[playerid][Rod]);
	INI_Bool("screwdriver",pInventory[playerid][Screwdriver]);
	INI_Bool("repairkit",pInventory[playerid][Repairkit]);
	INI_Int("rodd",pInventory[playerid][ToolDurability][Rod]);
	INI_Int("screwdriverd",pInventory[playerid][ToolDurability][Screwdriver]);
	INI_Int("bait",pInventory[playerid][Bait]);
	INI_Int("fish",pInventory[playerid][Fish][Count]);
	INI_Int("fishw",pInventory[playerid][Fish][Weigth]);
	return 1;
}

func:LoadPlayerJob_job(playerid, name[], value[])
{
	INI_Bool("gunmaker",pJob[playerid][Gunmaker]);
	INI_Bool("mechanic",pJob[playerid][Mechanic]);
	INI_Bool("trucker", pJob[playerid][Trucker]);
	return 1;
}

func:LoadPlayerWeapon_weapon(playerid, name[], value[])
{
	/* Main Weapon */
	INI_Int("w1",pWeapon[playerid][Weapon1]);
	INI_Int("w2",pWeapon[playerid][Weapon2]);
	INI_Int("w3",pWeapon[playerid][Weapon3]);
	INI_Int("w4",pWeapon[playerid][Weapon4]);
	INI_Int("w5",pWeapon[playerid][Weapon5]);
	INI_Int("w6",pWeapon[playerid][Weapon6]);
	INI_Int("w7",pWeapon[playerid][Weapon7]);
	INI_Int("w8",pWeapon[playerid][Weapon8]);
	INI_Int("w9",pWeapon[playerid][Weapon9]);
	INI_Int("w10",pWeapon[playerid][Weapon10]);
	INI_Int("w11",pWeapon[playerid][Weapon11]);
	INI_Int("w12",pWeapon[playerid][Weapon12]);
	/* Ammo */
	INI_Int("w1a",pWeapon[playerid][Weapon1a]);
	INI_Int("w2a",pWeapon[playerid][Weapon2a]);
	INI_Int("w3a",pWeapon[playerid][Weapon3a]);
	INI_Int("w4a",pWeapon[playerid][Weapon4a]);
	INI_Int("w5a",pWeapon[playerid][Weapon5a]);
	INI_Int("w6a",pWeapon[playerid][Weapon6a]);
	INI_Int("w7a",pWeapon[playerid][Weapon7a]);
	INI_Int("w8a",pWeapon[playerid][Weapon8a]);
	INI_Int("w9a",pWeapon[playerid][Weapon9a]);
	INI_Int("w10a",pWeapon[playerid][Weapon10a]);
	INI_Int("w11a",pWeapon[playerid][Weapon11a]);
	INI_Int("w12a",pWeapon[playerid][Weapon12a]);

	/* Civil Weapon */
	INI_Bool("scolt", pWeapon[playerid][Colt]);
	INI_Bool("deagle",pWeapon[playerid][Deagle]);
	INI_Bool("shotgun",pWeapon[playerid][Shotgun]);
	INI_Bool("rifle",pWeapon[playerid][Rifle]);

	INI_Float("scoltd",pWeapon[playerid][ColtDurability]);
	INI_Float("deagled",pWeapon[playerid][DeagleDurability]);
	INI_Float("shotgund",pWeapon[playerid][ShotgunDurability]);
	INI_Float("rifled",pWeapon[playerid][RifleDurability]);

	INI_Int("scolta",pWeapon[playerid][ColtAmmo]);
	INI_Int("deaglea",pWeapon[playerid][DeagleAmmo]);
	INI_Int("shotguna",pWeapon[playerid][ShotgunAmmo]);
	INI_Int("riflea",pWeapon[playerid][RifleAmmo]);

	/* Civil Weapon Equips */
	INI_Bool("isequip", pWeaponEquip[playerid][IsEquip]);
	INI_Bool("scolte", pWeaponEquip[playerid][Colt]);
	INI_Bool("deaglee", pWeaponEquip[playerid][Deagle]);
	INI_Bool("shotgune", pWeaponEquip[playerid][Shotgun]);
	INI_Bool("riflee", pWeaponEquip[playerid][Rifle]);
	return 1;
}

func:LoadPlayerPhone_phone(playerid, name[], value[])
{
	INI_Int("credit",pPhone[playerid][Credit]);
	return 1;
}

/* EOS */

main()
{
	printf("[DeathRow Vatos Roleplay]\n");
	return 1;
}

public OnGameModeInit()
{
	new format_version[200];

	/* formatting version */
	format(format_version,sizeof(format_version),"DRV-RP v%s", VERSION);

	SetGameModeText(format_version);
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(10.0);
    ShowPlayerMarkers(0);
    DisableInteriorEnterExits();
    ManualVehicleEngineAndLights();
    EnableVehicleFriendlyFire();
    SetDeathDropAmount(1000);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	/* Channel Setup */
	sPChannel[qna] = dini_Bool(CHANNEL_DIR,"qna");
	sPChannel[ooc] = dini_Bool(CHANNEL_DIR,"ooc");

	/* Pickups */
	CreateDynamicPickup(19832,0,-12.9450,2350.7974,24.1406); //gun crafting point
	CreateDynamicPickup(2037,0,613.0717,1549.8906,5.0001); // material point
	CreateDynamicPickup(2044,0,-752.7269,-131.6847,65.8281); // gun making
	CreateDynamicPickup(1275,0,-757.2897,-133.7420,65.8281); // gun maker job take
	CreateDynamicPickup(1239,0,1313.1063,-875.3223,39.5781); // sweeper
	CreateDynamicPickup(1239,0,1271.9991,-2038.5074,59.0828); // bus
	CreateDynamicPickup(1239,0,764.2607,-1304.5879,13.5613); // mower
	CreateDynamicPickup(2037,0,2197.5491,-2661.5784,13.5469); // product point
	CreateDynamicPickup(1239,0,1562.2598,-2300.6880,13.5650); // rent vehicle Point
	CreateDynamicPickup(1239,0,1926.1271,-1788.2462,13.3906); // rent vehicle Point2
	CreateDynamicPickup(1275,0,2139.5847,-1733.7576,17.2891); // mechanic job pickup
	CreateDynamicPickup(1275,0,-49.8569,-269.3626,6.6332); // trucker job point
	CreateDynamicPickup(1275,0,2914.6526,-802.2943,11.0469); // mechanic duty point
	CreateDynamicPickup(2037,0,2286.4944,-2013.8217,13.5442); // getcomponent point
	CreateDynamicPickup(1239,0,-2237.0012,130.1817,1035.4141); // buypoint electronic
	CreateDynamicPickup(1239,0,148.2934,1698.5463,1002.1363); // buypoint tool
	CreateDynamicPickup(1318,0,-2240.7827,137.1640,1035.4141); // exit point electronic
	CreateDynamicPickup(1318,0,140.8128,1710.8275,1002.1363); // exit point tool
	CreateDynamicPickup(1239,0,161.6251,-83.2522,1001.8047); // buypoint clothes
	CreateDynamicPickup(1239,0,450.4843,-83.6519,999.5547); // restaurant buy point
	CreateDynamicPickup(1318,0,161.3896,-96.8334,1001.8047); // clothes exit point
	CreateDynamicPickup(1239,0,542.3506,-1292.6149,17.2422); // dealership
	CreateDynamicPickup(1239,0,-1880.4781,-1681.4792,21.7500); // vehicle destroy point
	CreateDynamicPickup(19605,0,1111.5823,-1796.9653,16.5938); // driving license
	CreateDynamicPickup(1239,0,01490.2838,1305.7026,1093.2964); // driving license point
	CreateDynamicPickup(1239,0,-14.6017,-270.7789,5.4297); // Load Truck point
	CreateDynamicPickup(1239,0,383.3073,-2080.4578,7.8359); // fishing area
	CreateDynamicPickup(1239,0,359.3359,-2032.1019,7.8359); // bait shop
	CreateDynamicPickup(1239,0,-50.6201,-233.6625,6.7646); // sellfish point

	/* 3D Text */
	CreateDynamic3DTextLabel("[Gun Parts Crafting Point]", 0xFFFFFFAA,-12.9450,2350.7974,24.1406,30.0);
	CreateDynamic3DTextLabel("[Materials Point]\n/getmaterial to buy 3 materials for {008000}$250",0xFFF157AA,613.0717,1549.8906,5.0001,30.0);
	CreateDynamic3DTextLabel("[Gun Maker Point]",0xFF0000AA,-752.7269,-131.6847,65.8281,10.0);
	CreateDynamic3DTextLabel("[Gun Maker Job Point]",0xFFFFFFAA,-757.2897,-133.7420,65.8281,10.0);
	CreateDynamic3DTextLabel("[Sweeper Sidejob]",0xFFF157AA,1313.1063,-875.3223,39.5781,10.0);
	CreateDynamic3DTextLabel("[Product Point]\n/getproduct to buy 1 product for {008000}$150",0xFFF157AA,2197.5491,-2661.5784,13.5469,30.0);
	CreateDynamic3DTextLabel("[Rent Vehicle Point]\n/rentveh to rent Faggio\nfor {008000}$60{FFF157} in {00AAAA}30 minutes",0xFFF157FF,1562.2598,-2300.6880,13.5650,30.0);
	CreateDynamic3DTextLabel("[Rent Vehicle Point]\n/rentveh to rent Faggio\nfor {008000}$60{FFF157} in {00AAAA}30 minutes",0xFFF157FF,1926.1271,-1788.2462,13.3906,30.0);
	CreateDynamic3DTextLabel("[Mechanic Job Point]", 0xFF0000AA,2139.5847,-1733.7576,17.2891,10.0);
	CreateDynamic3DTextLabel("[Mechanic Duty Point]",0xFFF157AA,2914.6526,-802.2943,11.0469,10.0);
	CreateDynamic3DTextLabel("[Component Point]\n/getcomponents to buy 10 components for {008000}$200",0xFFF157AA,2286.4944,-2013.8217,13.5442,10.0);
	CreateDynamic3DTextLabel("[Electronic Buy Point]",0x008000AA,-2237.0012,130.1817,1035.4141,10.0);
	CreateDynamic3DTextLabel("[Tool Buy Point]",0x008000AA,148.2934,1698.5463,1002.1363,10.0);
	CreateDynamic3DTextLabel("[Electronic Exit Point]",0xFFFFFFAA,-2240.7827,137.1640,1035.4141,10.0);
	CreateDynamic3DTextLabel("[Tool Exit Point]",0xFFFFFFAA,140.8128,1710.8275,1002.1363,10.0);
	CreateDynamic3DTextLabel("[Clothes Exit Point]",0xFFFFFFAA,161.3896,-96.8334,1001.8047,10.0);
	CreateDynamic3DTextLabel("[Clothes Buy Point]",0x008000AA,161.6251,-83.2522,1001.8047,10.0);
	CreateDynamic3DTextLabel("[Bus Driver Sidejob]",0xFFF157AA,1271.9991,-2038.5074,59.0828,10.0);
	CreateDynamic3DTextLabel("[Mower Sidejob]",0xFFF157AA,764.2607,-1304.5879,13.5613,10.0);
	CreateDynamic3DTextLabel("[Dealership Point]",0xAAAAAAAA,542.3506,-1292.6149,17.2422,10.0);
	CreateDynamic3DTextLabel("[Vehicle Delete Point]",0xFF0000AA,-1880.4781,-1681.4792,21.7500,10.0);
	CreateDynamic3DTextLabel("[Driving License Center]\n{AAAAAA}Type /enter to enter",0xFFFFFFAA,1111.5823,-1796.9653,16.5938,10.0);
	CreateDynamic3DTextLabel("[Driving License Point]\nType {FFFF00}/getlicense{FFFFFF} to get driving license for {008000}$100",0xAAAAAAAA,1490.2838,1305.7026,1093.2964,10.0);
	CreateDynamic3DTextLabel("[Loading Bay Point]\n{AAAAAA}Type /loadtruck to load truck",0xFFFFFFAA,-14.6017,-270.7789,5.4297,10.0);
	CreateDynamic3DTextLabel("[Trucker Job Point]",0xFF0000AA,-49.8569,-269.3626,6.6332,10.0);
	CreateDynamic3DTextLabel("[Fishing Area]\nRadius 50.0",0xFFFFFFAA,383.3073,-2080.4578,7.8359,10.0);
	CreateDynamic3DTextLabel("[Bait Shop]",0xFFFF00AA,359.3359,-2032.1019,7.8359,10.0);
	CreateDynamic3DTextLabel("[Sell Fish Point]",0xFFFFFFAA,-50.6201,-233.6625,6.7646,10.0);
	CreateDynamic3DTextLabel("[Restaurant Buy Point]",0x008000AA,450.4843,-83.6519,999.5547,10.0);
	CreateDynamic3DTextLabel("[Restaurant Exit Point]",0xFFFFFFAA,460.5504,-88.6155,999.5547,10.0);
	CreateDynamic3DTextLabel("[Driving License Center Exit Point]",0xFFFFFFAA,1494.4346,1303.5786,1093.2891,10.0);
	/* Vehicles */

		/* Sweeper Job */
	SweeperVeh[0] = CreateVehicle(574, 1306.1726, -875.7529, 39.3935, -90.0000, 1, 0, 100);
	SweeperVeh[1] = CreateVehicle(574, 1306.1902, -873.5123, 39.3935, -90.0000, 1, 0, 100);
	SweeperVeh[2] = CreateVehicle(574, 1306.1666, -871.2911, 39.3935, -90.0000, 1, 0, 100);
	SweeperVeh[3] = CreateVehicle(574, 1306.1667, -869.1107, 39.3935, -90.0000, 1, 0, 100);
	SweeperVeh[4] = CreateVehicle(574, 1306.1678, -866.8701, 39.3935, -90.0000, 1, 0, 100);
	SweeperVeh[5] = CreateVehicle(574, 1306.1694, -864.5900, 39.3935, -90.0000, 1, 0, 100);
	// SweeperVeh[6] = CreateVehicle(574, 1306.1919, -862.2700, 39.3935, -90.0000, 1, 0, 100);
	// SweeperVeh[7] = CreateVehicle(574, 1306.1853, -859.9795, 39.3935, -90.0000, 1, 0, 100);
	// SweeperVeh[8] = CreateVehicle(574, 1306.1591, -857.6996, 39.3935, -90.0000, 1, 0, 100);
	// SweeperVeh[9] = CreateVehicle(574, 1306.1473, -855.3951, 39.3935, -90.0000, 1, 0, 100);
	// SweeperVeh[10] = CreateVehicle(574, 1306.1609, -852.9522, 39.3935, -90.0000, 1, 0, 100);

		/* Bus Job */
	vBus[0][ID] = CreateVehicle(437, 1244.9365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[1][ID] = CreateVehicle(437, 1250.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[2][ID] = CreateVehicle(437, 1255.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[3][ID] = CreateVehicle(437, 1260.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[4][ID] = CreateVehicle(437, 1265.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[5][ID] = CreateVehicle(437, 1270.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);
	vBus[6][ID] = CreateVehicle(437, 1275.0365, -2013.4041, 59.8729, 180.0000, 6, 7, 100);

		/* Mower Job */
	MowVeh[0] = CreateVehicle(572, 767.8790, -1307.7762, 13.1944, 0.0000, 3, 0, 100);
	MowVeh[1] = CreateVehicle(572, 771.1190, -1307.7563, 13.1944, 0.0000, 3, 0, 100);
	MowVeh[2] = CreateVehicle(572, 774.1190, -1307.7563, 13.1944, 0.0000, 3, 0, 100);
	MowVeh[3] = CreateVehicle(572, 777.3190, -1307.7563, 13.1944, 0.0000, 3, 0, 100);
	
	new
		sweeperplate[200],
		busplate[200];
	for(new i; i < 7; i++)
	{
		format(busplate,sizeof(busplate),"BUS-%d",i);
		SetVehicleNumberPlate(vBus[i][ID], busplate);
	}
	for(new i; i < sizeof(SweeperVeh); i++)
	{
		if(IsVehicleConnected(SweeperVeh[i])) {
			format(sweeperplate,sizeof(sweeperplate),"SWEEP-%d",i);
			SetVehicleNumberPlate(SweeperVeh[i], sweeperplate);
		}
	}

	for(new i; i < 7; i++)
	{
		strcpy(vBus[i][Owner],"None");
	}

	/* Zones */
	ZoneID[0] = CreateDynamicRectangle(sZone[0][ZMINX], sZone[0][ZMINY], sZone[0][ZMAXX], sZone[0][ZMAXY]); // farm zone

	//public veh
	publicVehicle[DrivingLicense] = CreateVehicle(445, 1098.4841,-1795.9338,13.6049,2.0079, 1, 1, 100);
	SetVehicleNumberPlate(publicVehicle[DrivingLicense], "{FF0000}-TEST-");
	sLicense[TestID] = -1;

	SetTimer("LoadBiz",3000,0);

	/* Override */
	UpdateTime();
	SetRandomWeather();

	/* Textdraw */
	GlobalTextdraw[Countdown] = TextDrawCreate(245.973587, 6.416685, "Countdown:");
	TextDrawLetterSize(GlobalTextdraw[Countdown], 0.449999, 1.600000);
	TextDrawAlignment(GlobalTextdraw[Countdown], 1);
	TextDrawColor(GlobalTextdraw[Countdown], -5963521);
	TextDrawSetShadow(GlobalTextdraw[Countdown], 0);
	TextDrawSetOutline(GlobalTextdraw[Countdown], 1);
	TextDrawBackgroundColor(GlobalTextdraw[Countdown], 51);
	TextDrawFont(GlobalTextdraw[Countdown], 2);
	TextDrawSetProportional(GlobalTextdraw[Countdown], 1);

	/* Start Timer */
	SetTimer("UpdateRentTime", 60000, true);
	SetTimer("NoExplodingVeh", 500, true);
	SetTimer("UpdateTime",1000 * 60,true);
	SetTimer("EngineRandomDies",30000, true);
	SetTimer("HeatUpdate",1000,true);
	SetTimer("CountdownTimer",1000,true);
	SetTimer("SetRandomWeather",60000 * 120,true);

	/* Object */
	BlockObj();
	ToolshopObj();
	LoadElectronicItemObj();
	MechanicCenterObj();
	BusStationObj();

	/* Logger */
	LoadAdLog();

	//gs
	LoadGSData();

	/* Actors */
	//CreateDynamicActor(217,-2237.5220,128.5821,1035.4141,1.6202);
	//CreateDynamicActor(217,148.4586,1700.0210,1002.1363,134.9307);

	/* Model Selection */
	sModelSel[Skin] = LoadModelSelectionMenu(MODEL_DATA_SKIN);
	sModelSel[MechanicDutySkin] = LoadModelSelectionMenu(MODEL_DATA_DUTYSKIN_MECHANIC);
	sModelSel[MechanicTuneWheel] = LoadModelSelectionMenu(MODEL_DATA_MECHANIC_TUNE_WHEEL);
	return 1;
}

public OnGameModeExit()
{
	/* Save Business */
	SaveElectronicBiz();
	SaveToolBiz();
	SaveClothesBiz();
	SaveRestaurantBiz();

	/* Save others */
	SaveAdLog();

	/* Channel Setup */
	dini_BoolSet(CHANNEL_DIR,"qna",sPChannel[qna]);
	dini_BoolSet(CHANNEL_DIR,"ooc",sPChannel[ooc]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new homeless_man[16] =
    {
    	1,
    	2,
    	3,
    	4,
    	5,
    	6,
    	7,
    	8,
        78,
        79,
        134,
        135,
        137,
        212,
        230,
        239
    };

   	//SetSpawnInfo(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
    if(IsNewAccount[playerid]) {  /* To Check is file exist or not */
    	SetSpawnInfo(playerid,0,homeless_man[random(sizeof(homeless_man))],1643.9750,-2332.2830,13.5469,0.0455,0,0,0,0,0,0);
    	SpawnPlayer(playerid);
	}
	else { /* if the file did exist */
		SetSpawnInfo(playerid,0,pPosition[playerid][SkinID],pPosition[playerid][pX],pPosition[playerid][pY],pPosition[playerid][pZ],pPosition[playerid][pRot],0,0,0,0,0,0);
		SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	/* Uhhh.... */
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 0);
	Ticket[playerid][Queue] = -1;

	new format_file_account[300];
	new format_player_position[400];
	new format_player_status[400];
	new format_player_stats[400];
	new format_player_inventory[400];
	new format_player_job[400];
	new format_player_weapon[400];
	new format_player_phone[400];

	format(format_player_status,sizeof(format_player_status),PLAYER_STATUS,RetPname(playerid));
	format(format_player_stats,sizeof(format_player_stats),PLAYER_STATS,RetPname(playerid));
	format(format_player_position,sizeof(format_player_position),PLAYER_POSITION,RetPname(playerid));
	format(format_player_inventory,sizeof(format_player_inventory),PLAYER_INVENTORY,RetPname(playerid));
	format(format_player_job,sizeof(format_player_job),PLAYER_JOB,RetPname(playerid));
	format(format_player_weapon,sizeof(format_player_weapon),PLAYER_WEAPON,RetPname(playerid));
	format(format_player_phone,sizeof(format_player_phone),PLAYER_PHONE,RetPname(playerid));

	/* Parsing */
	INI_ParseFile(format_player_position,"LoadPlayerPosition_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_status,"LoadPlayerStatus_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_stats,"LoadPlayerStats_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_inventory,"LoadPlayerInventory_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_job,"LoadPlayerJob_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_weapon,"LoadPlayerWeapon_%s", .bExtra = true, .extra = playerid);
	INI_ParseFile(format_player_phone,"LoadPlayerPhone_%s", .bExtra=true, .extra=playerid);

	/* To give a sign that player haven't logged in */
	SetPlayerColor(playerid, 0x000000FF);

	/* formatting */
	format(format_file_account,sizeof(format_file_account),PLAYER_ACCOUNT,RetPname(playerid));

	TogglePlayerSpectating(playerid, 1); /* toggle a player to spectate mode */

	pAccount[playerid][Banned] = dini_Bool(format_file_account,"ban");
	if(pAccount[playerid][Banned]) {
		for(new i = 0; i < 50; i++)
	    {
	        SendClientMessage(playerid,-1,"");
	    }
		SendClientMessage(playerid, -1, "{FF0000}[SYSTEM] This Account or Username Is Banned!");
		SendClientMessageEx(playerid, -1, "{FF0000}Ban Reason: %s",dini_Get(format_file_account,"banreason"));
		Kick2(playerid,1000);
		return 1;
	}
	else {
		/* Login-Register System */
		for(new i = 0; i < 50; i++)
	    {
	        SendClientMessage(playerid,-1,"");
	    }
		if(!fexist(format_file_account)) {
			ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"Register","This Username Is Not Registered\nType Your Desired Password to Create Account","Register","Leave");
		}
		else {
			new pip[30];
			GetPlayerIp(playerid, pip, sizeof(pip));
			SendClientMessageEx(playerid, -1, "IP:{FFFF00} %s",pip);
			SendClientMessageEx(playerid, -1, "Last Login: {FFFF00}%02d/%02d/%d",
				dini_Int(format_file_account,"llday"),
				dini_Int(format_file_account,"llmonth"),
				dini_Int(format_file_account,"llyear")
			);
			ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","This Username Is Registered\nType Your Password In Order To Login","Login","Leave");
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	/* Job Duty */
	if(pJobDuty[playerid][Mechanic]) {
		pJobDuty[playerid][Mechanic] = false;
		SetPlayerSkin(playerid, GetPVarInt(playerid, "PrevSkinMechanic"));
	}

	/* Disconnect Message */
	new dcReason[3][] = {
        "Timeout/Crash", //reason = 0
        "Quit", //reason = 1
        "Banned/Kicked" // reason = 2
    };
	new disconnect_message[150];
	format(disconnect_message,sizeof(disconnect_message),"%s Has Disconnected From The Server (%s)", RetPname(playerid),dcReason[reason]);
	ProxMsg(30.0,playerid,disconnect_message,0xFFFFFFAA); /* Send A Disconnect Message To Player Within 30.0 Radius */
	/* EOS */

		/* Format variables */
	new format_player_position[400];
	new format_player_status[400];
	new format_player_stats[400];
	new format_player_account[400];
	new format_player_inventory[400];
	new format_player_job[400];
	new format_player_weapon[400];
	new format_player_phone[400];
	new format_player_sms[400];

		/* INI File handle */
	new INI:POS_FH;
	new INI:STATUS_FH;
	new INI:STATS_FH;
	new INI:INV_FH;
	new INI:JOB_FH;
	new INI:WEAP_FH;
	new INI:PHONE_FH;
	
		/* Formatting */
	format(format_player_position,sizeof(format_player_position),PLAYER_POSITION,RetPname(playerid));
	format(format_player_status,sizeof(format_player_status),PLAYER_STATUS,RetPname(playerid));
	format(format_player_stats,sizeof(format_player_stats),PLAYER_STATS,RetPname(playerid));
	format(format_player_account,sizeof(format_player_account),PLAYER_ACCOUNT,RetPname(playerid));
	format(format_player_inventory,sizeof(format_player_inventory),PLAYER_INVENTORY,RetPname(playerid));
	format(format_player_job,sizeof(format_player_job),PLAYER_JOB,RetPname(playerid));
	format(format_player_weapon,sizeof(format_player_weapon),PLAYER_WEAPON,RetPname(playerid));
	format(format_player_phone,sizeof(format_player_phone),PLAYER_PHONE,RetPname(playerid));
	format(format_player_sms,sizeof(format_player_sms),PLAYER_PHONE_SMS,RetPname(playerid));

	if(IsPlayerLoggedIn[playerid]) {
		new Float:pos[4];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayerFacingAngle(playerid, pos[3]);
		if(!fexist(format_player_position)) {
			ftouch(format_player_position);
			POS_FH = INI_Open(format_player_position);
			INI_SetTag(POS_FH,"position");
			INI_WriteFloat(POS_FH, "posx", pos[0]);
			INI_WriteFloat(POS_FH, "posy", pos[1]);
			INI_WriteFloat(POS_FH, "posz", pos[2]);
			INI_WriteFloat(POS_FH, "posrot", pos[3]);
			INI_WriteInt(POS_FH,"interior",GetPlayerInterior(playerid));
			INI_WriteInt(POS_FH,"world",GetPlayerVirtualWorld(playerid));
			INI_WriteInt(POS_FH,"skin",GetPlayerSkin(playerid));
			INI_Close(POS_FH);
		}
		else {
			POS_FH = INI_Open(format_player_position);
			INI_SetTag(POS_FH,"position");
			INI_WriteFloat(POS_FH, "posx", pos[0]);
			INI_WriteFloat(POS_FH, "posy", pos[1]);
			INI_WriteFloat(POS_FH, "posz", pos[2]);
			INI_WriteFloat(POS_FH, "posrot", pos[3]);
			INI_WriteInt(POS_FH,"interior",GetPlayerInterior(playerid));
			INI_WriteInt(POS_FH,"world",GetPlayerVirtualWorld(playerid));
			INI_WriteInt(POS_FH,"skin",GetPlayerSkin(playerid));
			INI_Close(POS_FH);
		}
		/* EOS */

		/* Save Status */
		new Float:status_player[2];
		GetPlayerHealth(playerid, status_player[0]);
		GetPlayerArmour(playerid, status_player[1]);
		if(!fexist(format_player_status)) {
			ftouch(format_player_status);
			STATUS_FH = INI_Open(format_player_status);
			INI_SetTag(STATUS_FH,"status");
			INI_WriteFloat(STATUS_FH,"health",status_player[0]);
			INI_WriteFloat(STATUS_FH,"armour",status_player[1]);
			INI_WriteFloat(STATUS_FH,"hunger",pStatus[playerid][Hunger]);
			INI_WriteFloat(STATUS_FH,"thirst",pStatus[playerid][Thirst]);
			INI_WriteFloat(STATUS_FH,"energy",pStatus[playerid][Energy]);
			INI_Close(STATUS_FH);
		}
		else {
			STATUS_FH = INI_Open(format_player_status);
			INI_SetTag(STATUS_FH,"status");
			INI_WriteFloat(STATUS_FH,"health",status_player[0]);
			INI_WriteFloat(STATUS_FH,"armour",status_player[1]);
			INI_WriteFloat(STATUS_FH,"hunger",pStatus[playerid][Hunger]);
			INI_WriteFloat(STATUS_FH,"thirst",pStatus[playerid][Thirst]);
			INI_WriteFloat(STATUS_FH,"energy",pStatus[playerid][Energy]);
			INI_Close(STATUS_FH);
		}
		/* EOS */

		/* Save Stats */
		if(!fexist(format_player_stats)) {
			ftouch(format_player_stats);
			STATS_FH = INI_Open(format_player_stats);
			INI_SetTag(STATS_FH,"stats");
			INI_WriteInt(STATS_FH,"money",GetPlayerMoney(playerid));
			INI_WriteInt(STATS_FH,"score",GetPlayerScore(playerid));
			INI_WriteInt(STATS_FH,"number",pStat[playerid][PhoneNumber]);
			INI_Close(STATS_FH);
		}
		else {
			STATS_FH = INI_Open(format_player_stats);
			INI_SetTag(STATS_FH,"stats");
			INI_WriteInt(STATS_FH,"money",GetPlayerMoney(playerid));
			INI_WriteInt(STATS_FH,"score",GetPlayerScore(playerid));
			INI_WriteInt(STATS_FH,"number",pStat[playerid][PhoneNumber]);
			INI_Close(STATS_FH);
		}
		/* EOS */

		/* Save Account Info (Dini) */
		if(fexist(format_player_account)) {
			new date[3];
			getdate(date[2], date[1], date[0]);
			for(new i; i < 3; i++)
			{
				pAccount[playerid][LastLogin][i] = date[i];
			}
			dini_BoolSet(format_player_account,"admin",pAccount[playerid][Admin]);
			dini_BoolSet(format_player_account,"helper",pAccount[playerid][Helper]);
			dini_IntSet(format_player_account,"levelcount",pAccount[playerid][LevelCount]);
			dini_IntSet(format_player_account,"xp",pAccount[playerid][XP]);
			dini_IntSet(format_player_account,"xpmax",pAccount[playerid][XPMax]);
			dini_IntSet(format_player_account,"llyear",pAccount[playerid][LastLogin][2]);
			dini_IntSet(format_player_account,"llmonth",pAccount[playerid][LastLogin][1]);
			dini_IntSet(format_player_account,"llday",pAccount[playerid][LastLogin][0]);
		}

		/* Save Inventory */
		if(!fexist(format_player_inventory)) {
			ftouch(format_player_inventory);
			INV_FH = INI_Open(format_player_inventory);
			INI_SetTag(INV_FH,"inventory");
			INI_WriteInt(INV_FH,"material",pInventory[playerid][Material]);
			INI_WriteInt(INV_FH,"gunpart",pInventory[playerid][GunPart]);
			INI_WriteInt(INV_FH,"product",pInventory[playerid][Product]);
			INI_WriteInt(INV_FH,"component",pInventory[playerid][Component]);
			INI_WriteBool(INV_FH,"phone",pInventory[playerid][Phone]);
			INI_WriteBool(INV_FH,"boombox",pInventory[playerid][Boombox]);
			INI_WriteBool(INV_FH,"rod",pInventory[playerid][Rod]);
			INI_WriteBool(INV_FH,"screwdriver",pInventory[playerid][Screwdriver]);
			INI_WriteBool(INV_FH,"repairkit",pInventory[playerid][Repairkit]);
			INI_WriteInt(INV_FH,"rodd",pInventory[playerid][ToolDurability][Rod]);
			INI_WriteInt(INV_FH,"screwdriverd",pInventory[playerid][ToolDurability][Screwdriver]);
			INI_WriteInt(INV_FH,"bait",pInventory[playerid][Bait]);
			INI_WriteInt(INV_FH,"fish",pInventory[playerid][Fish][Count]);
			INI_WriteInt(INV_FH,"fishw",pInventory[playerid][Fish][Weigth]);
			INI_Close(INV_FH);
		}
		else {
			INV_FH = INI_Open(format_player_inventory);
			INI_SetTag(INV_FH,"inventory");
			INI_WriteInt(INV_FH,"material",pInventory[playerid][Material]);
			INI_WriteInt(INV_FH,"gunpart",pInventory[playerid][GunPart]);
			INI_WriteInt(INV_FH,"product",pInventory[playerid][Product]);
			INI_WriteInt(INV_FH,"component",pInventory[playerid][Component]);
			INI_WriteBool(INV_FH,"phone",pInventory[playerid][Phone]);
			INI_WriteBool(INV_FH,"boombox",pInventory[playerid][Boombox]);
			INI_WriteBool(INV_FH,"rod",pInventory[playerid][Rod]);
			INI_WriteBool(INV_FH,"screwdriver",pInventory[playerid][Screwdriver]);
			INI_WriteBool(INV_FH,"repairkit",pInventory[playerid][Repairkit]);
			INI_WriteInt(INV_FH,"rodd",pInventory[playerid][ToolDurability][Rod]);
			INI_WriteInt(INV_FH,"screwdriverd",pInventory[playerid][ToolDurability][Screwdriver]);
			INI_WriteInt(INV_FH,"bait",pInventory[playerid][Bait]);
			INI_WriteInt(INV_FH,"fish",pInventory[playerid][Fish][Count]);
			INI_WriteInt(INV_FH,"fishw",pInventory[playerid][Fish][Weigth]);
			INI_Close(INV_FH);
		}

		/* Save Job */
		if(!fexist(format_player_job)) {
			ftouch(format_player_job);
			JOB_FH = INI_Open(format_player_job);
			INI_SetTag(JOB_FH,"job");
			INI_WriteBool(JOB_FH,"gunmaker",pJob[playerid][Gunmaker]);
			INI_WriteBool(JOB_FH,"mechanic",pJob[playerid][Mechanic]);
			INI_WriteBool(JOB_FH,"taxi", pJob[playerid][Taxi]);
			INI_WriteBool(JOB_FH,"trucker", pJob[playerid][Trucker]);
			INI_Close(JOB_FH);
		}
		else {
			JOB_FH = INI_Open(format_player_job);
			INI_SetTag(JOB_FH,"job");
			INI_WriteBool(JOB_FH,"gunmaker",pJob[playerid][Gunmaker]);
			INI_WriteBool(JOB_FH,"mechanic",pJob[playerid][Mechanic]);
			INI_WriteBool(JOB_FH,"taxi", pJob[playerid][Taxi]);
			INI_WriteBool(JOB_FH,"trucker", pJob[playerid][Trucker]);
			INI_Close(JOB_FH);
		}

		/* Save Weapon */

		/* Fetch Weapon Data */
		GetPlayerWeaponData(playerid, 1, pWeapon[playerid][Weapon1], pWeapon[playerid][Weapon1a]);
		GetPlayerWeaponData(playerid, 2, pWeapon[playerid][Weapon2], pWeapon[playerid][Weapon2a]);
		GetPlayerWeaponData(playerid, 3, pWeapon[playerid][Weapon3], pWeapon[playerid][Weapon3a]);
		GetPlayerWeaponData(playerid, 4, pWeapon[playerid][Weapon4], pWeapon[playerid][Weapon4a]);
		GetPlayerWeaponData(playerid, 5, pWeapon[playerid][Weapon5], pWeapon[playerid][Weapon5a]);
		GetPlayerWeaponData(playerid, 6, pWeapon[playerid][Weapon6], pWeapon[playerid][Weapon6a]);
		GetPlayerWeaponData(playerid, 7, pWeapon[playerid][Weapon7], pWeapon[playerid][Weapon7a]);
		GetPlayerWeaponData(playerid, 8, pWeapon[playerid][Weapon8], pWeapon[playerid][Weapon8a]);
		GetPlayerWeaponData(playerid, 9, pWeapon[playerid][Weapon9], pWeapon[playerid][Weapon9a]);
		GetPlayerWeaponData(playerid, 10, pWeapon[playerid][Weapon10], pWeapon[playerid][Weapon10a]);
		GetPlayerWeaponData(playerid, 11, pWeapon[playerid][Weapon11], pWeapon[playerid][Weapon11a]);
		GetPlayerWeaponData(playerid, 12, pWeapon[playerid][Weapon12], pWeapon[playerid][Weapon12a]);
		/* EOS */
		if(!fexist(format_player_weapon)) {
			ftouch(format_player_weapon);
			WEAP_FH = INI_Open(format_player_weapon);
			INI_SetTag(WEAP_FH,"weapon");
				/* Save Main Weapon */
			INI_WriteInt(WEAP_FH,"w1", pWeapon[playerid][Weapon1]);
			INI_WriteInt(WEAP_FH,"w2", pWeapon[playerid][Weapon2]);
			INI_WriteInt(WEAP_FH,"w3", pWeapon[playerid][Weapon3]);
			INI_WriteInt(WEAP_FH,"w4", pWeapon[playerid][Weapon4]);
			INI_WriteInt(WEAP_FH,"w5", pWeapon[playerid][Weapon5]);
			INI_WriteInt(WEAP_FH,"w6", pWeapon[playerid][Weapon6]);
			INI_WriteInt(WEAP_FH,"w7", pWeapon[playerid][Weapon7]);
			INI_WriteInt(WEAP_FH,"w8", pWeapon[playerid][Weapon8]);
			INI_WriteInt(WEAP_FH,"w9", pWeapon[playerid][Weapon9]);
			INI_WriteInt(WEAP_FH,"w10", pWeapon[playerid][Weapon10]);
			INI_WriteInt(WEAP_FH,"w11", pWeapon[playerid][Weapon11]);
			INI_WriteInt(WEAP_FH,"w12", pWeapon[playerid][Weapon12]);
				/* Save Weapon Ammo */
			INI_WriteInt(WEAP_FH,"w1a", pWeapon[playerid][Weapon1a]);
			INI_WriteInt(WEAP_FH,"w2a", pWeapon[playerid][Weapon2a]);
			INI_WriteInt(WEAP_FH,"w3a", pWeapon[playerid][Weapon3a]);
			INI_WriteInt(WEAP_FH,"w4a", pWeapon[playerid][Weapon4a]);
			INI_WriteInt(WEAP_FH,"w5a", pWeapon[playerid][Weapon5a]);
			INI_WriteInt(WEAP_FH,"w6a", pWeapon[playerid][Weapon6a]);
			INI_WriteInt(WEAP_FH,"w7a", pWeapon[playerid][Weapon7a]);
			INI_WriteInt(WEAP_FH,"w8a", pWeapon[playerid][Weapon8a]);
			INI_WriteInt(WEAP_FH,"w9a", pWeapon[playerid][Weapon9a]);
			INI_WriteInt(WEAP_FH,"w10a", pWeapon[playerid][Weapon10a]);
			INI_WriteInt(WEAP_FH,"w11a", pWeapon[playerid][Weapon11a]);
			INI_WriteInt(WEAP_FH,"w12a", pWeapon[playerid][Weapon12a]);

			/* Civil Weapon */
			INI_WriteBool(WEAP_FH,"scolt", pWeapon[playerid][Colt]);
			INI_WriteBool(WEAP_FH,"deagle",pWeapon[playerid][Deagle]);
			INI_WriteBool(WEAP_FH,"shotgun",pWeapon[playerid][Shotgun]);
			INI_WriteBool(WEAP_FH,"rifle",pWeapon[playerid][Rifle]);

			INI_WriteFloat(WEAP_FH,"scoltd",pWeapon[playerid][ColtDurability]);
			INI_WriteFloat(WEAP_FH,"deagled",pWeapon[playerid][DeagleDurability]);
			INI_WriteFloat(WEAP_FH,"shotgund",pWeapon[playerid][ShotgunDurability]);
			INI_WriteFloat(WEAP_FH,"rifled",pWeapon[playerid][RifleDurability]);

			INI_WriteInt(WEAP_FH,"scolta",pWeapon[playerid][ColtAmmo]);
			INI_WriteInt(WEAP_FH,"deaglea",pWeapon[playerid][DeagleAmmo]);
			INI_WriteInt(WEAP_FH,"shotguna",pWeapon[playerid][ShotgunAmmo]);
			INI_WriteInt(WEAP_FH,"riflea",pWeapon[playerid][RifleAmmo]);

			/* Civil Weapon Equips */
			INI_WriteBool(WEAP_FH,"isequip", pWeaponEquip[playerid][IsEquip]);
			INI_WriteBool(WEAP_FH,"scolte", pWeaponEquip[playerid][Colt]);
			INI_WriteBool(WEAP_FH,"deaglee", pWeaponEquip[playerid][Deagle]);
			INI_WriteBool(WEAP_FH,"shotgune", pWeaponEquip[playerid][Shotgun]);
			INI_WriteBool(WEAP_FH,"riflee", pWeaponEquip[playerid][Rifle]);

			INI_Close(WEAP_FH);
		}
		else {
			WEAP_FH = INI_Open(format_player_weapon);
			INI_SetTag(WEAP_FH,"weapon");
				/* Save Main Weapon */
			INI_WriteInt(WEAP_FH,"w1", pWeapon[playerid][Weapon1]);
			INI_WriteInt(WEAP_FH,"w2", pWeapon[playerid][Weapon2]);
			INI_WriteInt(WEAP_FH,"w3", pWeapon[playerid][Weapon3]);
			INI_WriteInt(WEAP_FH,"w4", pWeapon[playerid][Weapon4]);
			INI_WriteInt(WEAP_FH,"w5", pWeapon[playerid][Weapon5]);
			INI_WriteInt(WEAP_FH,"w6", pWeapon[playerid][Weapon6]);
			INI_WriteInt(WEAP_FH,"w7", pWeapon[playerid][Weapon7]);
			INI_WriteInt(WEAP_FH,"w8", pWeapon[playerid][Weapon8]);
			INI_WriteInt(WEAP_FH,"w9", pWeapon[playerid][Weapon9]);
			INI_WriteInt(WEAP_FH,"w10", pWeapon[playerid][Weapon10]);
			INI_WriteInt(WEAP_FH,"w11", pWeapon[playerid][Weapon11]);
			INI_WriteInt(WEAP_FH,"w12", pWeapon[playerid][Weapon12]);
				/* Save Weapon Ammo */
			INI_WriteInt(WEAP_FH,"w1a", pWeapon[playerid][Weapon1a]);
			INI_WriteInt(WEAP_FH,"w2a", pWeapon[playerid][Weapon2a]);
			INI_WriteInt(WEAP_FH,"w3a", pWeapon[playerid][Weapon3a]);
			INI_WriteInt(WEAP_FH,"w4a", pWeapon[playerid][Weapon4a]);
			INI_WriteInt(WEAP_FH,"w5a", pWeapon[playerid][Weapon5a]);
			INI_WriteInt(WEAP_FH,"w6a", pWeapon[playerid][Weapon6a]);
			INI_WriteInt(WEAP_FH,"w7a", pWeapon[playerid][Weapon7a]);
			INI_WriteInt(WEAP_FH,"w8a", pWeapon[playerid][Weapon8a]);
			INI_WriteInt(WEAP_FH,"w9a", pWeapon[playerid][Weapon9a]);
			INI_WriteInt(WEAP_FH,"w10a", pWeapon[playerid][Weapon10a]);
			INI_WriteInt(WEAP_FH,"w11a", pWeapon[playerid][Weapon11a]);
			INI_WriteInt(WEAP_FH,"w12a", pWeapon[playerid][Weapon12a]);

			/* Civil Weapon */
			INI_WriteBool(WEAP_FH,"scolt", pWeapon[playerid][Colt]);
			INI_WriteBool(WEAP_FH,"deagle",pWeapon[playerid][Deagle]);
			INI_WriteBool(WEAP_FH,"shotgun",pWeapon[playerid][Shotgun]);
			INI_WriteBool(WEAP_FH,"rifle",pWeapon[playerid][Rifle]);

			INI_WriteFloat(WEAP_FH,"scoltd",pWeapon[playerid][ColtDurability]);
			INI_WriteFloat(WEAP_FH,"deagled",pWeapon[playerid][DeagleDurability]);
			INI_WriteFloat(WEAP_FH,"shotgund",pWeapon[playerid][ShotgunDurability]);
			INI_WriteFloat(WEAP_FH,"rifled",pWeapon[playerid][RifleDurability]);

			INI_WriteInt(WEAP_FH,"scolta",pWeapon[playerid][ColtAmmo]);
			INI_WriteInt(WEAP_FH,"deaglea",pWeapon[playerid][DeagleAmmo]);
			INI_WriteInt(WEAP_FH,"shotguna",pWeapon[playerid][ShotgunAmmo]);
			INI_WriteInt(WEAP_FH,"riflea",pWeapon[playerid][RifleAmmo]);

			/* Civil Weapon Equips */
			INI_WriteBool(WEAP_FH,"isequip", pWeaponEquip[playerid][IsEquip]);
			INI_WriteBool(WEAP_FH,"scolte", pWeaponEquip[playerid][Colt]);
			INI_WriteBool(WEAP_FH,"deaglee", pWeaponEquip[playerid][Deagle]);
			INI_WriteBool(WEAP_FH,"riflee", pWeaponEquip[playerid][Rifle]);

			INI_Close(WEAP_FH);
		}

		if(!fexist(format_player_phone)) {
			ftouch(format_player_phone);
			PHONE_FH = INI_Open(format_player_phone);
			INI_SetTag(PHONE_FH,"phone");
			INI_WriteInt(PHONE_FH,"credit", pPhone[playerid][Credit]);
			INI_Close(PHONE_FH);
		}
		else {
			PHONE_FH = INI_Open(format_player_phone);
			INI_SetTag(PHONE_FH,"phone");
			INI_WriteInt(PHONE_FH,"credit", pPhone[playerid][Credit]);
			INI_Close(PHONE_FH);
		}

		/* SMS Logging */
		new smsdat[100];

		for(new i; i < 30; i++)
		{
			if(!fexist(format_player_sms)) {
				ftouch(format_player_sms);

				/* PARSE */
				format(smsdat,sizeof(smsdat),"sms%d",i);
				dini_Set(format_player_sms,smsdat,pSMS[playerid][i]);
			}
			else {
				format(smsdat,sizeof(smsdat),"sms%d",i);
				dini_Set(format_player_sms,smsdat,pSMS[playerid][i]);
			}
		}
		UpdateVehicleData(playerid);
		SaveVehicle(playerid);
		DeleteVehicle(playerid); // as reset, not deleting vehicle
		DestroyVehicle(pVehicle[playerid][ID]);

		//accs
		SaveAccs(playerid);

		//food
		SaveFood(playerid);

		IsPlayerLoggedIn[playerid] = false;
	}
	/* EOS */

	/* Fixing Player Variables */
	if(pMission[playerid][Material]) {
		pMission[playerid][Material] = false;
		DisablePlayerCheckpoint(playerid);
	}
	if(pMission[playerid][Product]) {
		pMission[playerid][Product] = false;
		DisablePlayerCheckpoint(playerid);
	}
	if(pMission[playerid][Sweeper]) {
		pMission[playerid][Sweeper] = false;	
		RemovePlayerFromVehicle(playerid);
	}
	if(pMission[playerid][Component]) {
		pMission[playerid][Component] = false;
		DisablePlayerCheckpoint(playerid);
	}
	if(pMission[playerid][Mower]) {
		pMission[playerid][Mower] = false;
		pCheckpoint[playerid][Mower] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	if(pMission[playerid][BusDriver]) {
		for(new i; i < 7; i++)
		{
			if(!strcmp(vBus[i][Owner],RetPname(playerid),false)) {
				strcpy(vBus[i][Owner],"None");
				pMission[playerid][BusDriver] = false;
				DisablePlayerCheckpoint(playerid);
				return 1;
			}
		}
		return 1;
	}
	DestroyDynamicObject(pBoombox[playerid][Obj]);
	DestroyDynamic3DTextLabel(pBoombox[playerid][Label]);
	pBoombox[playerid][Placed] = false;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, pBoombox[playerid][PosX],pBoombox[playerid][PosY],pBoombox[playerid][PosZ])) {
			StopAudioStreamForPlayer(i);
		}
	}
	pBoombox[playerid][PosX] = 1000000000000.0;
	pBoombox[playerid][PosY] = 1000000000000.0;
	pBoombox[playerid][PosZ] = 1000000000000.0;
	UsingAnim[playerid] = false;
	/* EOS */

	/* Timer Kill */
	KillTimer(pTimer[playerid][Level]);

	/* AME & ADO */
	if(IsADO[playerid]) {
		DestroyDynamic3DTextLabel(pRpText[playerid][ADO]);
		IsADO[playerid] = false;
	}
	else if(IsAME[playerid]) {
		Delete3DTextLabel(pRpText[playerid][AME]);
		IsAME[playerid] = false;
	}

	/* Offers */
	if(pOffer[playerid][OfferedBy] > -1) {
		pOffer[playerid][MechanicTune] = false;
		pOffer[pOffer[playerid][OfferedBy]][IsOffering] = false;
		pOffer[playerid][OfferedBy] = -1;
	}

	pSpeedLimit[playerid] = 0.0;

	UsingAnim[playerid] = false;

	return 1;
}

public OnPlayerSpawn(playerid)
{
	/* Connected Message || Player Firts Spawn */
	if(FirstSpawn[playerid]) {
		new connect_message[150];
		format(connect_message,sizeof(connect_message),"%s Has Connected To The Server", RetPname(playerid));
		foreach(new i : Player)
		{
			if(IsPlayerLoggedIn[i]) SendClientMessage(i,0xFFFF00FF,connect_message);
		}
		FreezePlayer(playerid,1000);
		SetPlayerInterior(playerid, pPosition[playerid][InteriorID]);
		SetPlayerVirtualWorld(playerid, pPosition[playerid][WorldID]);
		/* give gun */
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon1], pWeapon[playerid][Weapon1a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon2], pWeapon[playerid][Weapon2a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon3], pWeapon[playerid][Weapon3a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon4], pWeapon[playerid][Weapon4a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon5], pWeapon[playerid][Weapon5a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon6], pWeapon[playerid][Weapon6a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon7], pWeapon[playerid][Weapon7a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon8], pWeapon[playerid][Weapon8a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon9], pWeapon[playerid][Weapon9a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon10], pWeapon[playerid][Weapon10a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon11], pWeapon[playerid][Weapon11a]);
		GivePlayerWeapon(playerid,pWeapon[playerid][Weapon12], pWeapon[playerid][Weapon12a]);
		/* EOS */

		/* Fetching Staff Privilege */
		new format_player_account[400];

			/* Formatting */
		format(format_player_account,sizeof(format_player_account),PLAYER_ACCOUNT,RetPname(playerid));

			/* Fetching Values */
		pAccount[playerid][Admin] = dini_Bool(format_player_account,"admin");
		pAccount[playerid][Helper] = dini_Bool(format_player_account,"helper");
		/* EOS */

			/* Fetching Level System */
		pAccount[playerid][LevelCount] = dini_Int(format_player_account,"levelcount");
		pAccount[playerid][XP] = dini_Int(format_player_account,"xp");
		pAccount[playerid][XPMax] = dini_Int(format_player_account,"xpmax");
		/* EOS */

		SetPlayerHealth(playerid, pStatus[playerid][Health]);
		SetPlayerArmour(playerid, pStatus[playerid][Armour]);
		GivePlayerMoney(playerid, pStat[playerid][Money]);
		SetPlayerScore(playerid, pStat[playerid][Score]);

		pTimer[playerid][Level] = SetTimerEx("LevelCalculate", 60_000, 1, "i", playerid);
		SetTimerEx("UpdateStatus",60_000,1,"i",playerid);

		/* PVARS */
		SetPVarInt(playerid, "PreviousPM", -1);

		/* Variables thing */
		pBizSell[playerid][Offering] = -1;
		pVehSell[playerid][Offering] = -1;
		if(!pInventory[playerid][Phone]) pStat[playerid][PhoneNumber] = -1;

		/* Additional Messages */
		SendClientMessage(playerid, -1, "Use /qna for asking questions or answering questions");

		/* Load SMS Log */
		LoadSMSLog(playerid);

		//vehicle
		LoadVehicle(playerid);

		//license
		LoadLicense(playerid);

		//accs
		//LoadAccs(playerid);
		InitAccs(playerid);

		//food
		LoadFood(playerid);
		InitFood(playerid);

		/* Object Removal */
		RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
		RemoveBuildingForPlayer(playerid, 2489, -2237.6328, 127.5547, 1035.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 2481, -2237.6328, 127.5781, 1036.7969, 0.25);
		RemoveBuildingForPlayer(playerid, 2490, -2237.6406, 127.5547, 1036.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 2495, -2237.6406, 127.5547, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2488, -2237.6328, 127.5547, 1035.3281, 0.25);
		RemoveBuildingForPlayer(playerid, 2483, -2236.5078, 127.5625, 1036.6094, 0.25);
		RemoveBuildingForPlayer(playerid, 2504, -2235.0859, 127.6406, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2503, -2235.5703, 127.6406, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2501, -2234.6328, 127.6406, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2513, -2236.5313, 127.6641, 1035.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 2490, -2229.7188, 127.5547, 1036.5391, 0.25);
		RemoveBuildingForPlayer(playerid, 2495, -2229.0938, 127.5547, 1036.5313, 0.25);
		RemoveBuildingForPlayer(playerid, 2477, -2223.5703, 128.2422, 1036.4922, 0.25);
		RemoveBuildingForPlayer(playerid, 928, -2225.1406, 128.2969, 1034.6719, 0.25);
		RemoveBuildingForPlayer(playerid, 926, -2224.2500, 128.4141, 1034.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 14558, -2223.3438, 128.4219, 1035.2031, 0.25);
		RemoveBuildingForPlayer(playerid, 2484, -2240.8125, 131.0781, 1036.3047, 0.25);
		RemoveBuildingForPlayer(playerid, 2362, -2238.3281, 129.2656, 1035.4453, 0.25);
		RemoveBuildingForPlayer(playerid, 2497, -2237.2266, 131.1328, 1037.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 2493, -2233.3516, 129.2734, 1035.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2510, -2233.6406, 129.2344, 1037.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 2494, -2233.6094, 129.5234, 1035.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2492, -2233.1016, 129.5234, 1035.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2491, -2233.1016, 129.7734, 1034.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2496, -2233.3516, 129.7734, 1035.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2486, -2234.4531, 131.7500, 1035.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 2459, -2234.7031, 131.9922, 1034.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 2484, -2233.9922, 132.1016, 1036.8281, 0.25);
		RemoveBuildingForPlayer(playerid, 2474, -2234.1250, 132.1172, 1035.1484, 0.25);
		RemoveBuildingForPlayer(playerid, 2487, -2226.1641, 129.7500, 1037.5469, 0.25);
		RemoveBuildingForPlayer(playerid, 2499, -2231.4766, 130.3203, 1037.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 2471, -2228.0547, 130.3281, 1035.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 2470, -2227.4141, 130.6875, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2469, -2228.4688, 130.7188, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2503, -2223.5391, 131.0703, 1035.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2501, -2223.5391, 131.6406, 1035.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2469, -2237.9063, 133.1953, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2470, -2237.8750, 134.2500, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2487, -2238.1719, 135.7969, 1037.5469, 0.25);
		RemoveBuildingForPlayer(playerid, 2504, -2236.8516, 137.8906, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2501, -2237.3047, 137.8906, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2486, -2233.4766, 132.4453, 1035.8047, 0.25);
		RemoveBuildingForPlayer(playerid, 2498, -2231.9453, 132.8125, 1037.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 2512, -2235.9922, 133.4375, 1037.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2459, -2234.7031, 135.0625, 1034.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 2464, -2233.9844, 135.1641, 1036.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 2474, -2234.1250, 135.8672, 1035.1484, 0.25);
		RemoveBuildingForPlayer(playerid, 2498, -2232.3281, 136.2422, 1037.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 2471, -2235.3672, 137.8516, 1035.9063, 0.25);
		RemoveBuildingForPlayer(playerid, 2503, -2236.3672, 137.8906, 1035.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 2466, -2235.2969, 137.9609, 1036.5547, 0.25);
		RemoveBuildingForPlayer(playerid, 2513, -2235.1875, 137.9297, 1036.2500, 0.25);
		RemoveBuildingForPlayer(playerid, 2467, -2235.5391, 137.9609, 1034.4141, 0.25);
		RemoveBuildingForPlayer(playerid, 2474, -2235.4453, 138.2109, 1035.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 2511, -2229.2734, 132.2813, 1037.8594, 0.25);
		RemoveBuildingForPlayer(playerid, 2503, -2223.5391, 132.4375, 1035.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2501, -2223.5391, 133.0078, 1035.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2486, -2228.5469, 133.3984, 1035.6641, 0.25);
		RemoveBuildingForPlayer(playerid, 2474, -2227.8984, 133.7656, 1035.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 2484, -2228.0938, 133.7734, 1036.8281, 0.25);
		RemoveBuildingForPlayer(playerid, 2486, -2227.5703, 134.0938, 1035.2813, 0.25);
		RemoveBuildingForPlayer(playerid, 2512, -2226.4922, 134.0156, 1037.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 2499, -2230.1563, 135.2578, 1037.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 2478, -2226.3750, 136.9922, 1034.8281, 0.25);
		RemoveBuildingForPlayer(playerid, 2474, -2229.6797, 137.1406, 1036.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 2465, -2227.9219, 137.0234, 1036.8594, 0.25);
		RemoveBuildingForPlayer(playerid, 2480, -2226.3672, 137.0781, 1036.4922, 0.25);

		RemoveBuildingForPlayer(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 0.25);
		RemoveBuildingForPlayer(playerid, 5340, 2644.8594, -2039.2344, 14.0391, 0.25);
		RemoveBuildingForPlayer(playerid, 5422, 2071.4766, -1831.4219, 14.5625, 0.25);
		RemoveBuildingForPlayer(playerid, 5856, 1024.9844, -1029.3516, 33.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 5779, 1041.3516, -1025.9297, 32.6719, 0.25);
		RemoveBuildingForPlayer(playerid, 6400, 488.2813, -1734.6953, 12.3906, 0.25);
		RemoveBuildingForPlayer(playerid, 10575, -2716.3516, 217.4766, 5.3828, 0.25);
		RemoveBuildingForPlayer(playerid, 11313, -1935.8594, 239.5313, 35.3516, 0.25);
		RemoveBuildingForPlayer(playerid, 11319, -1904.5313, 277.8984, 42.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 9625, -2425.7266, 1027.9922, 52.2813, 0.25);
		RemoveBuildingForPlayer(playerid, 9093, 2386.6563, 1043.6016, 11.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 8957, 2393.7656, 1483.6875, 12.7109, 0.25);
		RemoveBuildingForPlayer(playerid, 7709, 2006.0000, 2303.7266, 11.3125, 0.25);
		RemoveBuildingForPlayer(playerid, 7891, 1968.7422, 2162.4922, 12.0938, 0.25);
		RemoveBuildingForPlayer(playerid, 3294, -1420.5469, 2591.1563, 57.7422, 0.25);
		RemoveBuildingForPlayer(playerid, 3294, -100.0000, 1111.4141, 21.6406, 0.25);
		RemoveBuildingForPlayer(playerid, 13028, 720.0156, -462.5234, 16.8594, 0.25);

		//textdraw
		VehicleIndicator[playerid][MainBox] = CreatePlayerTextDraw(playerid, 634.503662, 365.500000, "MainBox");
		PlayerTextDrawLetterSize(playerid, VehicleIndicator[playerid][MainBox], 0.000000, 7.914812);
		PlayerTextDrawTextSize(playerid, VehicleIndicator[playerid][MainBox], 531.645690, 0.000000);
		PlayerTextDrawAlignment(playerid, VehicleIndicator[playerid][MainBox], 1);
		PlayerTextDrawColor(playerid, VehicleIndicator[playerid][MainBox], 0);
		PlayerTextDrawUseBox(playerid, VehicleIndicator[playerid][MainBox], true);
		PlayerTextDrawBoxColor(playerid, VehicleIndicator[playerid][MainBox], 102);
		PlayerTextDrawSetShadow(playerid, VehicleIndicator[playerid][MainBox], 0);
		PlayerTextDrawSetOutline(playerid, VehicleIndicator[playerid][MainBox], 0);
		PlayerTextDrawFont(playerid, VehicleIndicator[playerid][MainBox], 0);

		VehicleIndicator[playerid][Speed] = CreatePlayerTextDraw(playerid, 538.331176, 364.583190, "Speed:");
		PlayerTextDrawLetterSize(playerid, VehicleIndicator[playerid][Speed], 0.287891, 1.570831);
		PlayerTextDrawAlignment(playerid, VehicleIndicator[playerid][Speed], 1);
		PlayerTextDrawColor(playerid, VehicleIndicator[playerid][Speed], -1);
		PlayerTextDrawSetShadow(playerid, VehicleIndicator[playerid][Speed], 0);
		PlayerTextDrawSetOutline(playerid, VehicleIndicator[playerid][Speed], 1);
		PlayerTextDrawBackgroundColor(playerid, VehicleIndicator[playerid][Speed], 51);
		PlayerTextDrawFont(playerid, VehicleIndicator[playerid][Speed], 1);
		PlayerTextDrawSetProportional(playerid, VehicleIndicator[playerid][Speed], 1);

		VehicleIndicator[playerid][Health] = CreatePlayerTextDraw(playerid, 537.862792, 382.083465, "Health:");
		PlayerTextDrawLetterSize(playerid, VehicleIndicator[playerid][Health], 0.279457, 1.594162);
		PlayerTextDrawAlignment(playerid, VehicleIndicator[playerid][Health], 1);
		PlayerTextDrawColor(playerid, VehicleIndicator[playerid][Health], -1);
		PlayerTextDrawSetShadow(playerid, VehicleIndicator[playerid][Health], 0);
		PlayerTextDrawSetOutline(playerid, VehicleIndicator[playerid][Health], 1);
		PlayerTextDrawBackgroundColor(playerid, VehicleIndicator[playerid][Health], 51);
		PlayerTextDrawFont(playerid, VehicleIndicator[playerid][Health], 1);
		PlayerTextDrawSetProportional(playerid, VehicleIndicator[playerid][Health], 1);

		VehicleIndicator[playerid][Fuel] = CreatePlayerTextDraw(playerid, 536.925964, 400.166625, "Fuel:");
		PlayerTextDrawLetterSize(playerid, VehicleIndicator[playerid][Fuel], 0.447188, 1.477498);
		PlayerTextDrawAlignment(playerid, VehicleIndicator[playerid][Fuel], 1);
		PlayerTextDrawColor(playerid, VehicleIndicator[playerid][Fuel], -1);
		PlayerTextDrawSetShadow(playerid, VehicleIndicator[playerid][Fuel], 0);
		PlayerTextDrawSetOutline(playerid, VehicleIndicator[playerid][Fuel], 1);
		PlayerTextDrawBackgroundColor(playerid, VehicleIndicator[playerid][Fuel], 51);
		PlayerTextDrawFont(playerid, VehicleIndicator[playerid][Fuel], 1);
		PlayerTextDrawSetProportional(playerid, VehicleIndicator[playerid][Fuel], 1);

		VehicleIndicator[playerid][Heat] = CreatePlayerTextDraw(playerid, 536.457214, 418.833374, "Temp:");
		PlayerTextDrawLetterSize(playerid, VehicleIndicator[playerid][Heat], 0.414860, 1.459999);
		PlayerTextDrawAlignment(playerid, VehicleIndicator[playerid][Heat], 1);
		PlayerTextDrawColor(playerid, VehicleIndicator[playerid][Heat], -1);
		PlayerTextDrawSetShadow(playerid, VehicleIndicator[playerid][Heat], 0);
		PlayerTextDrawSetOutline(playerid, VehicleIndicator[playerid][Heat], 1);
		PlayerTextDrawBackgroundColor(playerid, VehicleIndicator[playerid][Heat], 51);
		PlayerTextDrawFont(playerid, VehicleIndicator[playerid][Heat], 1);
		PlayerTextDrawSetProportional(playerid, VehicleIndicator[playerid][Heat], 1);

		CheckValidName(playerid,RetPname(playerid));

		FirstSpawn[playerid] = false;

	}
	/* EOS */

	if(IsNewAccount[playerid]) { 
		GivePlayerMoney(playerid, 500);
		SetPlayerHealth(playerid, 100.0);
		pStatus[playerid][Energy] = 100.0;
		pStatus[playerid][Hunger] = 100.0;
		pStatus[playerid][Thirst] = 100.0;
		IsNewAccount[playerid] = false;
	}
	if(IsPlayerDeath[playerid]) {
		SetPlayerPos(playerid, 2035.5458,-1413.7125,16.9922);
        SetPlayerFacingAngle(playerid, 132.4680);
        FreezePlayer(playerid, 3000);
	}
	return 1;
}

public OnPlayerDeath(playerid)
{
	IsPlayerDeath[playerid] = true;
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(!pState[playerid][OnCall]) {
		new say_msg[200];
		format(say_msg,sizeof(say_msg), "%s says: %s", RetPname(playerid, 1), text);
		ProxMsg2(30.0,playerid,say_msg,0xFFFFFFFF,0xAAAAAAFF,0x808080FF,0x3F3F3FFF);
		SetPlayerChatBubble(playerid, text, -1, 10.0, 5000);
	}
	else if(pState[playerid][OnCall]) {
		if(!pCallInfo[playerid][IsServiceNumber]) {
			new callms[800];
			if(GetPlayerSpecialAction(pCallInfo[playerid][CalledID]) != SPECIAL_ACTION_USECELLPHONE) SendClientMessage(playerid, -1, "They have not picked up your call yet");
			format(callms,sizeof(callms),"[Phone] %s says: %s", RetPname(playerid, 1));
			ProxMsg2(30.0,playerid,callms,0xFFFFFFFF,0xAAAAAAFF,0x808080FF,0x3F3F3FFF);
			ProxMsg2(30.0,pCallInfo[playerid][CalledID],callms,0xFFFFFFFF,0xAAAAAAFF,0x808080FF,0x3F3F3FFF);
		}
		new phone_msg[200];
		format(phone_msg,sizeof(phone_msg), "[Phone] %s says: %s", RetPname(playerid, 1), text);
		ProxMsg2(30.0,playerid,phone_msg,0xFFFFFFFF,0xAAAAAAFF,0x808080FF,0x3F3F3FFF);
		if(pCallInfo[playerid][IsServiceNumber]) {
			switch(pCallInfo[playerid][CalledNumber]) {
				case NUMBER_TAXI:
				{
					if(pCallText[playerid][Taxi]==0) {
						pCallText[playerid][Taxi]=1;
						format(pTaxiCall[playerid][loc],800,"%s", text);
						SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FFFF00}[TAXI]{FFFFFF}: Okay, Now tell us your destination...");
					}
					else if(pCallText[playerid][Taxi]==1) {
						pCallText[playerid][Taxi]=2;
						format(pTaxiCall[playerid][dest],800,"%s", text);
						SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FFFF00}[TAXI]{FFFFFF}: Alright, How Much You Want To Pay?");
					}
					else if(pCallText[playerid][Taxi]==2) {
						if(!isNumeric(text)) {
							SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FFFF00}[TAXI]{FFFFFF}: Sorry, Input must be a number, Now How Much You Want To Pay?");
						}
						else {
							pCallText[playerid][Taxi]=0;
							pTaxiCall[playerid][payforv] = strval(text);
							SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FFFF00}[TAXI]{FFFFFF}: Good, We Have Informed to All Taxi Driver, Wait Until They Arrived to Your Location");
							SendTaxiRequest(playerid, pTaxiCall[playerid][loc], pTaxiCall[playerid][dest], pTaxiCall[playerid][payforv]);
							pTaxiCall[playerid][dest] = EOS;
							pTaxiCall[playerid][loc] = EOS;
							pTaxiCall[playerid][payforv] = -1;
							pState[playerid][OnCall] = false;
							pCallInfo[playerid][CalledNumber] = -1;
							SendClientMessage(playerid, -1, "They've hung up...");
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						}
					}
				}
			}
		}
	}
	return 0;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) {
		HideVehicleIndicator(playerid);
		if(pMission[playerid][Sweeper]) {
			pMission[playerid][Sweeper] = false;
			DisablePlayerCheckpoint(playerid);
			RemovePlayerFromVehicle(playerid);
			SetSweeperToRespawn2(2000);
			SendClientMessage(playerid, -1, "job canceled");
		}
		if(pMission[playerid][BusDriver]) {
			for(new i; i < 7; i++)
			{
				if(!strcmp(vBus[i][Owner],RetPname(playerid),false)) {
					strcpy(vBus[i][Owner],"None");
					pMission[playerid][BusDriver] = false;
					DisablePlayerCheckpoint(playerid);
					SendClientMessage(playerid, -1, "Bus Driver Mission has been canceled");
					return 1;
				}
			}
			return 1;
		}
		if(pMission[playerid][Mower]) {
			pMission[playerid][Mower] = false;
			pCheckpoint[playerid][Mower] = 0;
			DisablePlayerCheckpoint(playerid);
			SendClientMessage(playerid, -1, "job canceled");
			return 1;
		}
		if(pMission[playerid][License]) {
			DisablePlayerCheckpoint(playerid);
			pCheckpoint[playerid][License]=0;
			pMission[playerid][License] = false;
			sLicense[OnTest] = false;
			sLicense[TestID] = -1;
			RemovePlayerFromVehicle(playerid);
			SetVehicleToRespawn(publicVehicle[DrivingLicense]);
			RepairVehicle(publicVehicle[DrivingLicense]);
			SendClientMessage(playerid, -1, "You have canceled the driving test");
		}
		if(pMission[playerid][Trucker]) {
			DisablePlayerCheckpoint(playerid);
			pMission[playerid][Trucker] = false;
			sTruck[GetPlayerVehicleID(playerid)][Loaded] = false;
			SendClientMessage(playerid, -1, "You have canceled the trucker job");
		}
	}
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) {
		if(IsPlayerInCar(playerid) || IsPlayerInTruck(playerid) || IsPlayerOnBike(playerid) || IsPlayerOnQuad(playerid)) ShowVehicleIndicator(playerid);

		new msg[128];
		for(new i; i < MAX_RENTVEH_FAGGIO; i++)
		{
			if(GetPlayerVehicleID(playerid) == vRent[i][ID]) {
				format(msg,sizeof(msg),"This Vehicle Rented By: {FFFF00}%s{FFFFFF}, Time Left: {00AAAA}%d{FFFFFF} minute(s)",vRent[i][Owner],vRent[i][RentTime]);
				SendClientMessage(playerid, -1, msg);
			}
		}
		foreach(new i : Player) {
			if(GetPlayerVehicleID(playerid) == pVehicle[i][ID]) {
				if(playerid != i) {
					SendClientMessageEx(playerid, -1, "{FF00FF}[VEHICLE]{FFFFFF} Vehicle Owner: {FFFF00}%s", RetPname(i,1));
				}
				else if(playerid == i)
				{
					SendClientMessage(playerid, -1, "{FF00FF}[VEHICLE]{FFFFFF} You are the owner of this vehicle");
				}
			}
		}
	}
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) 
	{
		for(new i; i < MAX_RENTVEH_FAGGIO; i++)
		{
			if(IsPlayerInVehicle(playerid, vRent[i][ID])) {
				if(vRent[i][Locked]) {
					SendClientMessage(playerid, -1, "You has been kicked because of suspicion of using cheat program");
					Kick2(playerid,100);
				}
			}
		}
		if(pMission[playerid][License] && sLicense[TestID] == playerid && IsPlayerInVehicle(playerid, publicVehicle[DrivingLicense])) {
			SetCameraBehindPlayer(playerid);
			RepairVehicle(publicVehicle[DrivingLicense]);
			pCheckpoint[playerid][License] = 0;
			SetPlayerCheckpoint(playerid, 1037.8618,-1787.9056,13.4229, 4.0);
			SendClientMessage(playerid,-1,"Follow the checkpoint to complete the driving test");
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_FOOD:
		{
			if(response)
			{
				new index = listitem;
				new Float:tmp;
				if(pState[playerid][Eat] || pState[playerid][Drink]) return SendClientMessage(playerid, -1, "ERROR: You're already eating food or drinking beverages, please wait...");
				if(pFood[playerid][index][Empty]) return SendClientMessage(playerid, -1, "ERROR: The slot is empty");
				if(pFood[playerid][index][Food][Sprunk]) //sprunk
				{
					if(pStatus[playerid][Thirst] >= 95.0) return SendClientMessage(playerid, -1, "ERROR: You can't drink more fluid, please wait for a while...");
					tmp = pStatus[playerid][Thirst];
					if((tmp + 15.0) > 100.0) pStatus[playerid][Thirst] = 100.0;
					else pStatus[playerid][Thirst] += 15.0;
					tmp = pStatus[playerid][Energy];
					if((tmp + 10.0) > 100.0) pStatus[playerid][Energy] = 100.0;
					else pStatus[playerid][Energy] += 10.0;
					pFood[playerid][index][Food][0] = false;
					pFood[playerid][index][FoodText] = EOS;
					pFood[playerid][index][Empty] = true;
					SetPlayerDrunkLevel(playerid, 0);
					GivePlayerHealth(playerid, 8.0);
					SendClientMessage(playerid, -1, "Thirst + 15.0 | Energy + 10.0");
					ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.0, 0, 0, 0, 0, 0);
				}
				else if(pFood[playerid][index][Food][Water])
				{
					if(pStatus[playerid][Thirst] >= 95.0) return SendClientMessage(playerid, -1, "ERROR: You can't drink more fluid, please wait for a while...");
					tmp = pStatus[playerid][Thirst];
					if((tmp + 8.0) > 100.0) pStatus[playerid][Thirst] = 100.0;
					else pStatus[playerid][Thirst] += 8.0;
					tmp = pStatus[playerid][Energy];
					if((tmp + 10.0) > 100.0) pStatus[playerid][Energy] = 100.0;
					else pStatus[playerid][Energy] += 10.0;
					pFood[playerid][index][Food][1] = false;
					pFood[playerid][index][FoodText] = EOS;
					pFood[playerid][index][Empty] = true;
					SetPlayerDrunkLevel(playerid, 0);
					GivePlayerHealth(playerid, 5.0);
					SendClientMessage(playerid, -1, "Thirst + 8.0 | Energy + 10.0");
					ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.0, 0, 0, 0, 0, 0);
				}
				if(pFood[playerid][index][Food][Fish])
				{
					if(pStatus[playerid][Hunger] >= 95.0) return SendClientMessage(playerid, -1, "ERROR: You can't eat more food, please wait for a while...");
					tmp = pStatus[playerid][Hunger];
					if((tmp + 20.0) > 100.0) pStatus[playerid][Hunger] = 100.0;
					else pStatus[playerid][Hunger] += 20.0;
					tmp = pStatus[playerid][Energy];
					if((tmp + 15.0) > 100.0) pStatus[playerid][Energy] = 100.0;
					else pStatus[playerid][Energy] += 15.0;
					pFood[playerid][index][Food][2] = false;
					pFood[playerid][index][FoodText] = EOS;
					pFood[playerid][index][Empty] = true;
					SetPlayerDrunkLevel(playerid, 0);
					GivePlayerHealth(playerid, 15.0);
					SendClientMessage(playerid, -1, "Hunger + 20.0 | Energy + 15.0");
					ApplyAnimation(playerid, "FOOD", "EAT_CHICKEN", 4.0, 0, 0, 0, 0, 0);
				}
				if(pFood[playerid][index][Food][Chicken])
				{
					if(pStatus[playerid][Hunger] >= 95.0) return SendClientMessage(playerid, -1, "ERROR: You can't eat more food, please wait for a while...");
					tmp = pStatus[playerid][Hunger];
					if((tmp + 25.0) > 100.0) pStatus[playerid][Hunger] = 100.0;
					else pStatus[playerid][Hunger] += 25.0;
					tmp = pStatus[playerid][Energy];
					if((tmp + 15.0) > 100.0) pStatus[playerid][Energy] = 100.0;
					else pStatus[playerid][Energy] += 15.0;
					pFood[playerid][index][Food][3] = false;
					pFood[playerid][index][FoodText] = EOS;
					pFood[playerid][index][Empty] = true;
					SetPlayerDrunkLevel(playerid, 0);
					GivePlayerHealth(playerid, 18.0);
					SendClientMessage(playerid, -1, "Hunger + 25.0 | Energy + 15.0");
					ApplyAnimation(playerid, "FOOD", "EAT_CHICKEN", 4.0, 0, 0, 0, 0, 0);
				}
			}
		}

		case DIALOG_SHOP_RESTAURANT:
		{
			if(response) {
				new id;
				new fco,fsl;
				for(new i; i < MAX_RESTAURANT; i++)
				{
					if(GetPlayerVirtualWorld(playerid) == bizRestaurant[i][WorldID]) id = i;
				}
				if(!strcmp(bizRestaurant[id][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You can't buy food from your own business");				
				switch(listitem) {
					case 0: // sprunk
					{
						if(bizRestaurant[id][Sprunk] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizRestaurant[id][SprunkPrice]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						for(new i; i < 5; i++)
						{
							if(!pFood[playerid][i][Empty]) fco++;
							else if(pFood[playerid][i][Empty]) {
								fsl=i;
								break;
							}
						}
						if(fco > 4) return SendClientMessage(playerid, -1, "ERROR: you can't buy more foods");
						pFood[playerid][fsl][Empty] = false;
						format(pFood[playerid][fsl][FoodText],30,"%s",bizRestaurant[id][SprunkName]);
						pFood[playerid][fsl][Food][Sprunk] = true;
						GivePlayerMoney(playerid, -bizRestaurant[id][SprunkPrice]);
						bizRestaurant[id][Sprunk] -= 1;
						bizRestaurant[id][Balance] += floatval((floatround((bizRestaurant[id][SprunkPrice] / 10.0),floatround_floor)));
						SendClientMessage(playerid, -1, "You bought the food");
					}
					case 1: // water
					{
						if(bizRestaurant[id][Water] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizRestaurant[id][WaterPrice]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						for(new i; i < 5; i++)
						{
							if(!pFood[playerid][i][Empty]) fco++;
							else if(pFood[playerid][i][Empty]) {
								fsl=i;
								break;
							}
						}
						if(fco > 4) return SendClientMessage(playerid, -1, "ERROR: you can't buy more foods");
						pFood[playerid][fsl][Empty] = false;
						format(pFood[playerid][fsl][FoodText],30,"%s",bizRestaurant[id][WaterName]);
						pFood[playerid][fsl][Food][Water] = true;
						GivePlayerMoney(playerid, -bizRestaurant[id][WaterPrice]);
						bizRestaurant[id][Water] -= 1;
						bizRestaurant[id][Balance] += floatval((floatround((bizRestaurant[id][WaterPrice] / 10.0),floatround_floor)));
						SendClientMessage(playerid, -1, "You bought the food");
					}
					case 2: // fish
					{
						if(bizRestaurant[id][Fish] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizRestaurant[id][FishPrice]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						for(new i; i < 5; i++)
						{
							if(!pFood[playerid][i][Empty]) fco++;
							else if(pFood[playerid][i][Empty]) {
								fsl=i;
								break;
							}
						}
						if(fco > 4) return SendClientMessage(playerid, -1, "ERROR: you can't buy more foods");
						pFood[playerid][fsl][Empty] = false;
						format(pFood[playerid][fsl][FoodText],30,"%s",bizRestaurant[id][FishName]);
						pFood[playerid][fsl][Food][Fish] = true;
						GivePlayerMoney(playerid, -bizRestaurant[id][FishPrice]);
						bizRestaurant[id][Fish] -= 1;
						bizRestaurant[id][Balance] += floatval((floatround((bizRestaurant[id][FishPrice] / 10.0),floatround_floor)));
						SendClientMessage(playerid, -1, "You bought the food");
					}
					case 3: // chicken
					{
						if(bizRestaurant[id][Chicken] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizRestaurant[id][ChickenPrice]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						for(new i; i < 5; i++)
						{
							if(!pFood[playerid][i][Empty]) fco++;
							else if(pFood[playerid][i][Empty]) {
								fsl=i;
								break;
							}
						}
						if(fco > 4) return SendClientMessage(playerid, -1, "ERROR: you can't buy more foods");
						pFood[playerid][fsl][Empty] = false;
						format(pFood[playerid][fsl][FoodText],30,"%s",bizRestaurant[id][ChickenName]);
						pFood[playerid][fsl][Food][Chicken] = true;
						GivePlayerMoney(playerid, -bizRestaurant[id][ChickenPrice]);
						bizRestaurant[id][Chicken] -= 1;
						bizRestaurant[id][Balance] += floatval((floatround((bizRestaurant[id][ChickenPrice] / 10.0),floatround_floor)));
						SendClientMessage(playerid, -1, "You bought the food");
					}
				}
			}
		}

		case DIALOG_SHOP_TOOL:
		{
			if(response) {
				new id;
				for(new i; i < MAX_TOOL; i++)
				{
					if(GetPlayerVirtualWorld(playerid) == bizTool[i][WorldID]) id = i;
				}
				if(!strcmp(bizTool[id][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You can't buy product from your own business");
				switch(listitem) {
					case 0: // repair
					{
						if(bizTool[id][Repairkit] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizTool[id][ToolPrice][Repairkit]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						if(pInventory[playerid][Repairkit]) return SendClientMessage(playerid, -1, "ERROR: You already have this");
						pInventory[playerid][Repairkit] = true;
						bizTool[id][Repairkit] -= 1;
						GivePlayerMoney(playerid, -bizTool[id][ToolPrice][Repairkit]);
						bizTool[id][Balance] += floatval((floatround((bizTool[id][ToolPrice][Repairkit] / 10.0),floatround_floor)));
					}
					case 1: // rod
					{
						if(bizTool[id][Fishingrod] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizTool[id][ToolPrice][Fishingrod]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						if(pInventory[playerid][Rod]) return SendClientMessage(playerid, -1, "ERROR: You already have this tool");
						pInventory[playerid][Rod] = true;
						pInventory[playerid][ToolDurability][Rod] = 100;
						bizTool[id][Fishingrod] -= 1;
						GivePlayerMoney(playerid, -bizTool[id][ToolPrice][Fishingrod]);
						bizTool[id][Balance] += floatval((floatround((bizTool[id][ToolPrice][Fishingrod] / 10.0),floatround_floor)));
					}
					case 2: // screw
					{
						if(bizTool[id][Screwdriver] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(GetPlayerMoney(playerid) < bizTool[id][ToolPrice][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						if(pInventory[playerid][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: You already have this tool");
						pInventory[playerid][Screwdriver] = true;
						pInventory[playerid][ToolDurability][Screwdriver] = 100;
						bizTool[id][Screwdriver] -= 1;
						GivePlayerMoney(playerid, -bizTool[id][ToolPrice][Screwdriver]);
						bizTool[id][Balance] += floatval((floatround((bizTool[id][ToolPrice][Screwdriver] / 10.0),floatround_floor)));
					}
				}
			}
		}

		case DIALOG_ACCS_BUY:
		{
			if(response)
			{
				for(new i; i < MAX_ACCS; i++)
				{
					if(pAccs[playerid][i][IsEmpty]) {
						pAccs[playerid][i][Name] = AttachmentObjects[listitem][attachname];
						pAccs[playerid][i][Model] = AttachmentObjects[listitem][attachmodel];
						pAccs[playerid][i][IsEmpty] = false;
						pAccs[playerid][i][IsAttached] = true;
						SetPlayerAttachedObject(playerid,
							i,
							
							pAccs[playerid][i][Model], 
							pAccs[playerid][i][Bone],
							
							pAccs[playerid][i][Offset][0],
							pAccs[playerid][i][Offset][1],
							pAccs[playerid][i][Offset][2], 

							pAccs[playerid][i][Rot][0],
							pAccs[playerid][i][Rot][1],
							pAccs[playerid][i][Rot][2],

							pAccs[playerid][i][Scale][0],
							pAccs[playerid][i][Scale][1],
							pAccs[playerid][i][Scale][2]
						);
						GivePlayerMoney(playerid, -15);
						printf("[DEBUG][ACCS]: Accs Name Of Slot %d: %s",i,pAccs[playerid][i][Name]);
						printf("[DEBUG][ACCS]: Accs Model of Slot %d: %d",i,pAccs[playerid][i][Model]);
						SendClientMessage(playerid, -1, "You bought the Accessories for {008000}$15");
						break;
					}
					else continue;
				}
			}
		}

		case DIALOG_ACCS_EDIT_BONES:
		{
			if(response)
			{
				RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AccsIndex"));
				pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Bone] = listitem+1;
				SetPlayerAttachedObject(playerid,
					GetPVarInt(playerid, "AccsIndex"),
					
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Model], 
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Bone],
					
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][0],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][1],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][2], 

					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][0],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][1],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][2],

					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][0],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][1],
					pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][2]
				);
				DeletePVar(playerid, "AccsIndex");
				InitAccs(playerid);
				SendClientMessage(playerid, -1, "Accessories Bone Updated");
			}
		}

		case DIALOG_ACCS_EDIT:
		{
			if(response) {
				switch(listitem)
				{
					case 0:
					{
						if(!pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][IsAttached]) return SendClientMessage(playerid, -1, "ERROR: Accessories is not attached");
						EditAttachedObject(playerid, GetPVarInt(playerid, "AccsIndex"));
						printf("[DEBUG][ACCS][EDIT]: Editing Accs Index %d, Model %d, Name %s",
							GetPVarInt(playerid, "AccsIndex"),
							pAccs[playerid][GetPVarInt(playerid,"AccsIndex")][Model], 
							pAccs[playerid][GetPVarInt(playerid,"AccsIndex")][Name]
						);
						DeletePVar(playerid, "AccsIndex");
					}
					case 1:
					{
						new str[400];
						for(new i; i < sizeof(AttachmentBones); i++)
						{
							format(str,sizeof(str),"%s%s\n",AttachmentBones[i]);
						}
						ShowPlayerDialog(playerid,DIALOG_ACCS_EDIT_BONES, DIALOG_STYLE_LIST, "Select Bones", str, "Select", "Close");
					}
				}
			}
		}

		case DIALOG_ACCS_OPT:
		{
			if(!response) DeletePVar(playerid, "AccsIndex");
			else {
				switch(listitem) {
					case 0:
					{
						if(pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][IsAttached]) {
							RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AccsIndex"));
							DeletePVar(playerid, "AccsIndex");
							SendClientMessage(playerid, -1, "Accessories Detached");
						}
						else {
							SetPlayerAttachedObject(playerid,
								GetPVarInt(playerid, "AccsIndex"),
								
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Model], 
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Bone],
								
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][0],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][1],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Offset][2], 

								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][0],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][1],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Rot][2],

								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][0],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][1],
								pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][Scale][2]
							);
							DeletePVar(playerid, "AccsIndex");
							SendClientMessage(playerid, -1, "Accessories Attached");
						}
					}
					case 1:
					{
						ShowPlayerDialog(playerid,DIALOG_ACCS_EDIT,DIALOG_STYLE_LIST,"Select Option","Edit Position\nEdit Bones","Select","Close");
					}
					case 2:
					{
						DeleteAccs(playerid, GetPVarInt(playerid, "AccsIndex"));
						SaveAccs(playerid);
						InitAccs(playerid);
						SendClientMessage(playerid, -1, "Accessories Deleted");
					}
				}
			}
		}

		case DIALOG_ACCS_INDEX:
		{
			if(response)
			{
				if(pAccs[playerid][ GetPVarInt(playerid, "AccsIndex") ][IsEmpty]) return SendClientMessage(playerid, -1, "Slot is empty");
				SetPVarInt(playerid, "AccsIndex", listitem);
				new str[200];
				strcat(str,"Attach/Detach\n");
				strcat(str,"Edit\n");
				strcat(str,"Discard\n");

				ShowPlayerDialog(playerid,DIALOG_ACCS_OPT,DIALOG_STYLE_LIST,"Options",str,"Select","Close");
			}
		}

		case DIALOG_DEALERSHIP_SELECT:
		{
			if(response) {
				SubDealershipHolder[playerid] = SubDealershipHolderArr[playerid][listitem];

				new
					i;

				i = SubDealershipHolder[playerid];
				if(GetPlayerMoney(playerid) < g_aDealershipData[i][eDealershipPrice]) return SendClientMessage(playerid, -1 ,"ERROR: Not enough money");

				if(g_aDealershipData[i][eDealershipModelID] == 420 || g_aDealershipData[i][eDealershipModelID] == 438) {
					if(!pJob[playerid][Taxi]) return SendClientMessage(playerid, -1, "ERROR: Only taxi driver can buy this vehicle");
				}

				pVehicle[playerid][ID] = CreateVehicle(g_aDealershipData[i][eDealershipModelID], 563.2501,-1278.6127,17.2422,15.6344, 1, 1, -1);
				new 
					plates[32],
					randset[3];

				randset[0] = random(sizeof(possibleVehiclePlates));
				randset[1] = random(sizeof(possibleVehiclePlates));
				randset[2] = random(sizeof(possibleVehiclePlates));

				format(plates, 32, "%d%s%s%s%d%d%d", random(9), possibleVehiclePlates[randset[0]], possibleVehiclePlates[randset[1]], possibleVehiclePlates[randset[2]], random(9), random(9));
				pVehicle[playerid][Plate] = plates;
				SetVehicleNumberPlate(pVehicle[playerid][ID],plates);
				GivePlayerMoney(playerid, -g_aDealershipData[i][eDealershipPrice]);
				ParkVehicle(playerid);
				NormalizeHeat(playerid);
				g_Fuel[ pVehicle[playerid][ID] ] = 100.0;
				UpdateVehicleData(playerid);
				SaveVehicle(playerid);
				PutPlayerInVehicle(playerid, pVehicle[playerid][ID], 0);
				SendClientMessage(playerid, -1, "You bought the vehicle and the vehicle data has been saved into database");
			}
			else {
				new larstr[200];
				for(new i = 0; i < sizeof(g_aDealershipCategory); i++)
				{
					format(larstr, sizeof(larstr), "%s%s\n", larstr, g_aDealershipCategory[i]);
				}
				ShowPlayerDialog(playerid, DIALOG_DEALERSHIP, DIALOG_STYLE_LIST, "Vehicle Categories", larstr, "Select", "Cancel");
			}
		}
		case DIALOG_DEALERSHIP:
		{
			if(response)
			{
				new larstr[600],
					counter = 0
				;

				CatDealershipHolder[playerid] = listitem;

				for(new i = 0; i < sizeof(g_aDealershipData); i++)
				{
					if(listitem == g_aDealershipData[i][eDealershipCategory])
					{
						format(larstr, sizeof(larstr), "%s%s\t\t\t$%s\n", larstr, g_aDealershipData[i][eDealershipModel], MoneyFormat(g_aDealershipData[i][eDealershipPrice]));

						SubDealershipHolderArr[playerid][counter] = i;
						counter++;
					}
				}

				ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_SELECT, DIALOG_STYLE_LIST, "Select Vehicles", larstr, "Select", "Back");
			}
			return 1;
		}

		case DIALOG_TRADEVEH:
		{
			if(response) {
				if(pVehicle[playerid][Model] == 0) {
					SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offer doesn't have a vehicle");
					return SendClientMessage(playerid, -1, "You don't have a vehicle");
				}
				if(!IsPlayerInRangeOfVehicle(playerid, pVehicle[playerid][ID],10.0)) {
					SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offer doesn't have their vehicle near by them");
					return SendClientMessage(playerid, -1, "Your vehicle is not near by you");
				}
				SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offered accepted your offer!");
				SendClientMessage(playerid, -1, "You trade the vehicle");
				TradeVehicle(pVehSell[playerid][OfferedBy], playerid);
				pVehSell[ pVehSell[playerid][OfferedBy] ][Offering] = -1;
				pVehSell[playerid][OfferedBy] = -1;
			}
			else {
				SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The Player declined your offer");
				SendClientMessage(playerid, -1, "You declined the offer");
				pVehSell[ pVehSell[playerid][OfferedBy] ][Offering] = -1;
				pVehSell[playerid][OfferedBy] = -1;
			}
		}

		case DIALOG_SELLVEH:
		{
			if(response) {
				if(GetPlayerMoney(playerid) < pVehSell[playerid][Price]) {
					SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offer doesn't have enough money");
					return SendClientMessage(playerid, -1, "You don't have enough money");
				}
				if(pVehicle[playerid][Model] > 0) {
					SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offer already have a vehicle");
					return SendClientMessage(playerid, -1, "You already have a vehicle");
				}
				GivePlayerMoney(playerid, -pVehSell[playerid][Price]);
				GivePlayerMoney(pVehSell[playerid][OfferedBy], pVehSell[playerid][Price]);
				SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The player that you offered accepted your offer!");
				SendClientMessage(playerid, -1, "You bought the vehicle");
				GiveVehicle(pVehSell[playerid][OfferedBy], playerid);
				pVehSell[playerid][Price] = EOS;
				pVehSell[ pVehSell[playerid][OfferedBy] ][Offering] = -1;
				pVehSell[playerid][OfferedBy] = -1;
			}
			else {
				SendClientMessage(pVehSell[playerid][OfferedBy], -1, "The Player declined your offer");
				SendClientMessage(playerid, -1, "You declined the offer");
				pVehSell[playerid][Price] = EOS;
				pVehSell[ pVehSell[playerid][OfferedBy] ][Offering] = -1;
				pVehSell[playerid][OfferedBy] = -1;
			}
		}

		case DIALOG_SELL_BIZ:
		{
			if(response) {
				if(GetPlayerMoney(playerid) < pBizSell[playerid][Price]) {
					SendClientMessage(pBizSell[playerid][OfferedBy], -1, "The Player that you offer doesn't have enough money");
					return SendClientMessage(playerid, -1, "You don't have enough money");
				}
				GivePlayerMoney(playerid, -pBizSell[playerid][Price]);
				GivePlayerMoney(pBizSell[playerid][OfferedBy], pBizSell[playerid][Price]);
				if(pBizSell[playerid][BizType] == BUSINESS_ELECTRONIC) {
					UpdateElectronicBizLabel(pBizSell[playerid][BizID],RetPname(playerid),bizElectronic[ pBizSell[playerid][BizID] ][ShopName]);
				}
				else if(pBizSell[playerid][BizType] == BUSINESS_TOOL) {
					UpdateToolBizLabel(pBizSell[playerid][BizID],RetPname(playerid),bizTool[ pBizSell[playerid][BizID] ][ShopName]);
				}
				else if(pBizSell[playerid][BizType] == BUSINESS_CLOTHES) {
					UpdateClothesBizLabel(pBizSell[playerid][BizID],RetPname(playerid),bizClothes[ pBizSell[playerid][BizID] ][ShopName]);
				}
				SendClientMessage(pBizSell[playerid][OfferedBy],-1,"the player that you offered accepted your offer!");
				SendClientMessage(playerid, -1, "You bought the property");
				pBizSell[playerid][Price] = EOS;
				pBizSell[playerid][BizID] = EOS;
				pBizSell[playerid][BizType] = EOS;
				pBizSell[ pBizSell[playerid][OfferedBy] ][Offering] = -1;
				pBizSell[playerid][OfferedBy] = -1;
			}
			else {
				SendClientMessage(pBizSell[playerid][OfferedBy], -1, "The Player declined your offer");
				SendClientMessage(playerid, -1, "You declined the offer");
				pBizSell[playerid][Price] = EOS;
				pBizSell[playerid][BizID] = EOS;
				pBizSell[playerid][BizType] = EOS;
				pBizSell[ pBizSell[playerid][OfferedBy] ][Offering] = -1;
				pBizSell[playerid][OfferedBy] = -1;
			}
		}

		case DIALOG_WEAPON_DISCARD:
		{
			if(response) {
				switch(listitem)
				{
					case 0: //silenced
					{
						if(!pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						pWeapon[playerid][Colt] = false;
						pWeapon[playerid][ColtDurability] = 0.0;
						SendClientMessage(playerid, -1, "Weapon Discarded");
					}
					case 1: //deagle
					{
						if(!pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						pWeapon[playerid][Deagle] = false;
						pWeapon[playerid][DeagleDurability] = 0.0;
						SendClientMessage(playerid, -1, "Weapon Discarded");
					}
					case 2: //rifle
					{
						if(!pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						pWeapon[playerid][Shotgun] = false;
						pWeapon[playerid][ShotgunDurability] = 0.0;
						SendClientMessage(playerid, -1, "Weapon Discarded");
					}
					case 3: //shotgun
					{
						if(!pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						pWeapon[playerid][Rifle] = false;
						pWeapon[playerid][RifleDurability] = 0.0;
						SendClientMessage(playerid, -1, "Weapon Discarded");
					}
				}
			}
		}

		case DIALOG_REPAIRGUN:
		{
			if(response) {
				switch(listitem) {
					case 0: //silenced
					{
						if(!pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][ColtDurability] = 100.0;
						SendClientMessage(playerid, -1, "Weapon Repaired");
					}
					case 1: //deagle
					{
						if(!pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][DeagleDurability] = 100.0;
						SendClientMessage(playerid, -1, "Weapon Repaired");
					}
					case 2: //rifle
					{
						if(!pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][RifleDurability] = 100.0;
						SendClientMessage(playerid, -1, "Weapon Repaired");
					}
					case 3: //shotgun
					{
						if(!pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "You don't have that weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][ShotgunDurability] = 100.0;
						SendClientMessage(playerid, -1, "Weapon Repaired");
					}
				}
			}
		}

		case DIALOG_MAKEAMMO:
		{
			if(response) {
				switch(listitem) {
					case 0: //silenced
					{
						if(pWeapon[playerid][ColtAmmo] >= 300) return SendClientMessage(playerid, -1, "You can't make more ammo of this weapon");
						if(pInventory[playerid][GunPart] < 1) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						pInventory[playerid][GunPart] -= 1;
						pWeapon[playerid][ColtAmmo] += 17;
						SendClientMessage(playerid, -1, "You Made 17 colt45 ammo using 1 gun parts");
					}
					case 1: //deagle
					{
						if(pWeapon[playerid][DeagleAmmo] >= 300) return SendClientMessage(playerid, -1, "You can't make more ammo of this weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][DeagleAmmo] += 7;
						SendClientMessage(playerid, -1, "You Made 7 Desert Eagle ammo using 3 gun parts");
					}
					case 2: //rifle
					{
						if(pWeapon[playerid][RifleAmmo] >= 120) return SendClientMessage(playerid, -1, "You can't make more ammo of this weapon");
						if(pInventory[playerid][GunPart] < 6) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						pInventory[playerid][GunPart] -= 6;
						pWeapon[playerid][RifleAmmo] += 4;
						SendClientMessage(playerid, -1, "You Made 4 Rifle ammo using 6 gun parts");
					}
					case 3: //shotgun
					{
						if(pWeapon[playerid][ShotgunAmmo] >= 120) return SendClientMessage(playerid, -1, "You can't make more ammo of this weapon");
						if(pInventory[playerid][GunPart] < 6) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						pInventory[playerid][GunPart] -= 6;
						pWeapon[playerid][ShotgunAmmo] += 8;
						SendClientMessage(playerid, -1, "You Made 8 Shotgun ammo using 6 gun parts");
					}
				}
			}
		}

		case DIALOG_WEAPON_EQUIP:
		{
			if(response) {
				switch(listitem) {
					case 0: //scol
					{
						if(!pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "{AAAAAA} You don't have that weapon");
						if(pWeapon[playerid][ColtDurability] <= 0.0) return SendClientMessage(playerid, -1, "{AAAAAA}That weapon is broken");
						pWeaponEquip[playerid][Colt] = true;
						pWeaponEquip[playerid][IsEquip] = true;
						SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} You equiped Colt45");
					}
					case 1:
					{
						if(!pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "{AAAAAA} You don't have that weapon");
						if(pWeapon[playerid][DeagleDurability] <= 0.0) return SendClientMessage(playerid, -1, "{AAAAAA}That weapon is broken");
						pWeaponEquip[playerid][Deagle] = true;
						pWeaponEquip[playerid][IsEquip] = true;
						SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} You equiped Deagle");
					}
					case 2:
					{
						if(!pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "{AAAAAA} You don't have that weapon");
						if(pWeapon[playerid][ShotgunDurability] <= 0.0) return SendClientMessage(playerid, -1, "{AAAAAA}That weapon is broken");
						pWeaponEquip[playerid][Shotgun] = true;
						pWeaponEquip[playerid][IsEquip] = true;
						SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} You equiped Shotgun");
					}
					case 3:
					{
						if(!pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "{AAAAAA} You don't have that weapon");
						if(pWeapon[playerid][RifleDurability] <= 0.0) return SendClientMessage(playerid, -1, "{AAAAAA}That weapon is broken");
						pWeaponEquip[playerid][Rifle] = true;
						pWeaponEquip[playerid][IsEquip] = true;
						SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} You equiped Rifle");
					}
				}
			}
		}

		case DIALOG_BUS_ROUTE:
		{
			new busid;
			for(new i; i < 7; i++)
			{
				if(!strcmp(vBus[i][Owner],"None",false)) {
					busid = i;
				}
				else return SendClientMessage(playerid, -1, "ERROR: This bus is already used by another player");
			}
			if(response) {
				switch(listitem) {
					case 0: //lv
					{
						pCheckpoint[playerid][BusDriver] = 0;
						strcpy(vBus[busid][Owner],RetPname(playerid));
						pMission[playerid][BusDriver] = true;
						SetPlayerCheckpoint(playerid,2140.5342,1434.3226,10.8203,10.0);
						SendClientMessage(playerid, -1, "drive to the checkpoint");
						SendClientMessage(playerid, -1, "use /cancel to cancel mission");
					}
					case 1: // sf
					{
						pCheckpoint[playerid][BusDriver] = 0;
						strcpy(vBus[busid][Owner],RetPname(playerid));
						pMission[playerid][BusDriver] = true;
						SetPlayerCheckpoint(playerid,-1980.0244,470.7214,35.1719, 10.0);
						SendClientMessage(playerid, -1, "drive to the checkpoint");
						SendClientMessage(playerid, -1, "use /cancel to cancel mission");
					}
					case 2: // red county
					{
						pCheckpoint[playerid][BusDriver] = 0;
						strcpy(vBus[busid][Owner],RetPname(playerid));
						pMission[playerid][BusDriver] = true;
						SetPlayerCheckpoint(playerid,68.3796,-245.4074,1.5781, 10.0);
						SendClientMessage(playerid, -1, "drive to the checkpoint");
						SendClientMessage(playerid, -1, "use /cancel to cancel mission");
					}
					case 3: // bone county
					{
						pCheckpoint[playerid][BusDriver] = 0;
						strcpy(vBus[busid][Owner],RetPname(playerid));
						pMission[playerid][BusDriver] = true;
						SetPlayerCheckpoint(playerid,67.4405,1174.8108,18.6641, 10.0);
						SendClientMessage(playerid, -1, "drive to the checkpoint");
						SendClientMessage(playerid, -1, "use /cancel to cancel mission");
					}
					case 4: // flint county
					{
						pCheckpoint[playerid][BusDriver] = 0;
						strcpy(vBus[busid][Owner],RetPname(playerid));
						pMission[playerid][BusDriver] = true;
						SetPlayerCheckpoint(playerid,-1552.7534,-2763.0420,48.6290, 10.0);
						SendClientMessage(playerid, -1, "drive to the checkpoint");
						SendClientMessage(playerid, -1, "use /cancel to cancel mission");
					}
				}
			}
		}

		case DIALOG_MECHANIC_TUNE:
		{
			if(response) {
				switch(listitem) {
					case 0:
					{
						ShowModelSelectionMenu(playerid, sModelSel[MechanicTuneWheel], "Select Wheels");
					}
				}
			}
		}

		case DIALOG_SPRICE_CLOTHES:
		{
			if(response) {
				new clothesid;
				new str_p;
				if(!isNumeric(inputtext)) ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC,DIALOG_STYLE_LIST,"Set Price - Clothes","{AA0000}Input is not numeric!{FFFFFF}\nType your desired price for all clothes,(min $10, max $1000)","Set","Close");
				str_p = strval(inputtext);
				if(str_p > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC,DIALOG_STYLE_LIST,"Set Price - Clothes","{AA0000}Price is too high!{FFFFFF}\nType your desired price for all clothes,(min $10, max $1000)","Set","Close");
				else if(str_p < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC,DIALOG_STYLE_LIST,"Set Price - Clothes","{AA0000}Price is too low!{FFFFFF}\nType your desired price for all clothes,(min $10, max $1000)","Set","Close");
				for(new i; i < MAX_CLOTHES; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
						clothesid = i;
					}
				}
				bizClothes[clothesid][ClothesPrice] = str_p;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_ELECTRONIC_BOOMBOX:
		{
			if(response) {
				new electronicid;
				new str_price;
				if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_BOOMBOX,DIALOG_STYLE_INPUT,"Set Price - Electronic - Boombox","{AA0000}input is not numeric!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				str_price = strval(inputtext);
				if(str_price > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_BOOMBOX,DIALOG_STYLE_INPUT,"Set Price - Electronic - Boombox","{AA0000}price is too high!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				else if(str_price < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_BOOMBOX,DIALOG_STYLE_INPUT,"Set Price - Electronic - Boombox","{AA0000}price is too low!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				for(new i; i < MAX_ELECTRONIC; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
						electronicid = i;
					}
				}
				bizElectronic[electronicid][BoomboxPrice] = str_price;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_ELECTRONIC_PHONE:
		{
			if(response) {
				new electronicid;
				new str_price;
				if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_PHONE,DIALOG_STYLE_INPUT,"Set Price - Electronic - Phone","{AA0000}input is not numeric!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				str_price = strval(inputtext);
				if(str_price > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_PHONE,DIALOG_STYLE_INPUT,"Set Price - Electronic - Phone","{AA0000}price is too high!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				else if(str_price < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_PHONE,DIALOG_STYLE_INPUT,"Set Price - Electronic - Phone","{AA0000}price is too low!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				for(new i; i < MAX_ELECTRONIC; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
						electronicid = i;
					}
				}
				bizElectronic[electronicid][PhonePrice] = str_price;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_ELECTRONIC:
		{
			if(response) {
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_PHONE,DIALOG_STYLE_INPUT,"Set Price - Electronic - Phone","Type your desired price for this product,(min $10, max $1000)","Set","Cancel");
					}
					case 1:
					{
						ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC_BOOMBOX,DIALOG_STYLE_INPUT,"Set Price - Electronic - Boombox","Type your desired price for this product,(min $10, max $1000)","Set","Cancel");
					}
				}
			}
		}

		case DIALOG_SPRICE_TOOL_REPAIRKIT:
		{
			if(response) {
				new id;
				new str_price;
				if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_REPAIRKIT,DIALOG_STYLE_INPUT,"Set Price - Tool - Repair kit","{AA0000}input is not numeric!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				str_price = strval(inputtext);
				if(str_price > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_REPAIRKIT,DIALOG_STYLE_INPUT,"Set Price - Tool - Repair kit","{AA0000}price is too high!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				else if(str_price < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_REPAIRKIT,DIALOG_STYLE_INPUT,"Set Price - Tool - Repair kit","{AA0000}price is too low!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				for(new i; i < MAX_TOOL; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
						id = i;
					}
				}
				bizTool[id][ToolPrice][Repairkit] = str_price;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_TOOL_ROD:
		{
			if(response) {
				new id;
				new str_price;
				if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_ROD,DIALOG_STYLE_INPUT,"Set Price - Tool - Fishing Rod","{AA0000}input is not numeric!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				str_price = strval(inputtext);
				if(str_price > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_ROD,DIALOG_STYLE_INPUT,"Set Price - Tool - Fishing Rod","{AA0000}price is too high!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				else if(str_price < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_ROD,DIALOG_STYLE_INPUT,"Set Price - Tool - Fishing Rod","{AA0000}price is too low!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				for(new i; i < MAX_TOOL; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
						id = i;
					}
				}
				bizTool[id][ToolPrice][Fishingrod] = str_price;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_TOOL_SCREW:
		{
			if(response) {
				new id;
				new str_price;
				if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_SCREW,DIALOG_STYLE_INPUT,"Set Price - Tool - Screwdriver","{AA0000}input is not numeric!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				str_price = strval(inputtext);
				if(str_price > 1000) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_SCREW,DIALOG_STYLE_INPUT,"Set Price - Tool - Screwdriver","{AA0000}price is too high!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				else if(str_price < 10) return ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_SCREW,DIALOG_STYLE_INPUT,"Set Price - Tool - Screwdriver","{AA0000}price is too low!{FFFFFF}\nType your desired price for this product,(min $10, max $1000)","Set","Cancel");
				for(new i; i < MAX_TOOL; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
						id = i;
					}
				}
				bizTool[id][ToolPrice][Screwdriver] = str_price;
				SendClientMessage(playerid, -1, "new price has been set");
			}
		}

		case DIALOG_SPRICE_TOOL:
		{
			if(response) {
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_REPAIRKIT,DIALOG_STYLE_INPUT,"Set Price - Tool - Repair kit","Type your desired price for this product,(min $10, max $1000)","Set","Cancel");
					}
					case 1:
					{
						ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_ROD,DIALOG_STYLE_INPUT,"Set Price - Tool - Fishing Rod","Type your desired price for this product,(min $10, max $1000)","Set","Cancel");
					}
					case 2:
					{
						ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL_SCREW,DIALOG_STYLE_INPUT,"Set Price - Tool - Screwdriver","Type your desired price for this product,(min $10, max $1000)","Set","Cancel");
					}
				}
			}
		}

		case DIALOG_BOOMBOX_SET:
		{
			if(response) {
				new url[250];
				strcpy(url,inputtext);
				for(new i; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerInRangeOfPoint(i,30.0,pBoombox[playerid][PosX],pBoombox[playerid][PosY],pBoombox[playerid][PosZ]))
					{
						PlayAudioStreamForPlayer(i, url,pBoombox[playerid][PosX],pBoombox[playerid][PosY],pBoombox[playerid][PosZ],30.0,1);
					}
				}
			}
		}

		case DIALOG_RESTOCK_ELECTRONIC:
		{
			if(response) {
				new electronicid;
				for(new i; i < MAX_ELECTRONIC; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
						electronicid = i;
					}
				}
				if(pInventory[playerid][Product] < 1) return SendClientMessage(playerid, -1, "ERROR: Not enough product, 1 product for each product restock");
				switch(listitem) {
					case 0: //phone
					{
						if(bizElectronic[electronicid][Phone] >= 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
						bizElectronic[electronicid][Phone] = 50;
						pInventory[playerid][Product] -= 1;
						SendClientMessage(playerid, -1, "Product has been restocked");
					}
					case 1: //boombox
					{
						if(bizElectronic[electronicid][Boombox] >= 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
						bizElectronic[electronicid][Boombox] = 50;
						pInventory[playerid][Product] -= 1;
						SendClientMessage(playerid, -1, "Product has been restocked");
					}
				}
			}
		}

		case DIALOG_RESTOCK_TOOL:
		{
			if(response) {
				new id;
				for(new i; i < MAX_TOOL; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
						id = i;
					}
				}
				if(pInventory[playerid][Product] < 1) return SendClientMessage(playerid, -1, "ERROR: Not enough product, 1 product for each product restock");
				switch(listitem) {
					case 0:
					{
						if(bizTool[id][Repairkit] >= 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
						bizTool[id][Repairkit] = 50;
						pInventory[playerid][Product] -= 1;
						SendClientMessage(playerid, -1, "Product has been restocked");
					}
					case 1:
					{
						if(bizTool[id][Fishingrod] >= 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
						bizTool[id][Fishingrod] = 50;
						pInventory[playerid][Product] -= 1;
						SendClientMessage(playerid, -1, "Product has been restocked");
					}
					case 2:
					{
						if(bizTool[id][Screwdriver] >= 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
						bizTool[id][Screwdriver] = 50;
						pInventory[playerid][Product] -= 1;
						SendClientMessage(playerid, -1, "Product has been restocked");
					}
				}
			}
		}

		case DIALOG_PHONE_AD:
		{
			if(response) {
				new
					msg[800],
					text[400];
				strcpy(text,inputtext);
				if(strlen(text) > 400) {
					ShowPlayerDialog(playerid,DIALOG_PHONE_AD,DIALOG_STYLE_INPUT,"Advertisement","{FF0000}Advertisement is too long{FFFFFF}\nType your Advertisement\nAd Fee: {008000}$100","Publish","Cancel");
				}
				else {
					if(GetPlayerMoney(playerid) < 100) return SendClientMessage(playerid, -1, "ERROR: Not enough money to pay ad fee");
					GivePlayerMoney(playerid, -100);
					SendAdMessage(playerid,0x00AAAAFF,text);
					format(msg,sizeof(msg),"%s, Contact: %d", text, pStat[playerid][PhoneNumber]);
					AdLogger(msg);
				}
			}
		}

		case DIALOG_PHONE_BUYCREDIT:
		{
			if(response) {
				switch(listitem) {
					case 0:
					{
						if(GetPlayerMoney(playerid) < 2) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						GivePlayerMoney(playerid, -2);
						pPhone[playerid][Credit] += 1;
					}
					case 1:
					{
						if(GetPlayerMoney(playerid) < 10) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						GivePlayerMoney(playerid, -10);
						pPhone[playerid][Credit] += 5;
					}
					case 2:
					{
						if(GetPlayerMoney(playerid) < 20) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
						GivePlayerMoney(playerid, -20);
						pPhone[playerid][Credit] += 10;
					}
				}
			}
		}

		case DIALOG_PHONE_SMS:
		{
			if(response)
			{
				if(listitem != 30) return SendClientMessage(playerid, -1, "ERROR: you can only be able to clear messages");
				else if(listitem == 30) {
					for(new i; i < 30; i++)
					{
						strcpy(pSMS[playerid][i]," ");
					}
					SendClientMessage(playerid, -1, "All Messages Has Been Cleared");
				}
			}
		}

		case DIALOG_PHONE:
		{
			if(response) {
				switch(listitem) {
					case 0: // smslog
					{
						new str_dat[500];
						strcat(str_dat,"Text\tNumber\n");
						for(new i; i < 30; i++)
						{
							format(str_dat,sizeof(str_dat),"%s%s\n",str_dat,pSMS[playerid][i]);
						}
						strcat(str_dat,"{FF0000}Clear Messages\n");
						ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_TABLIST_HEADERS, "SMS Inbox", str_dat, "Select", "Close");
					}
					case 1: // ad log
					{
						new str_adl[2000];
						for(new i; i < 60; i++)
						{
							format(str_adl,sizeof(str_adl),"%s%s\n", str_adl, sAdLog[i]);
						}
						ShowPlayerDialog(playerid, DIALOG_PHONE_AD_LOG, DIALOG_STYLE_LIST, "Advertisement Log", str_adl, "Close", "");
					}
					case 2:
					{
						ShowPlayerDialog(playerid,DIALOG_PHONE_AD,DIALOG_STYLE_INPUT,"Advertisement","Type your Advertisement\nAd Fee: {008000}$100","Publish","Cancel");
					}
					case 3: // buy credit
					{
						new str[800];
						strcat(str,"1 Credit\t$2\n");
						strcat(str,"5 Credits\t$10\n");
						strcat(str,"10 Credits\t$20\n");
						ShowPlayerDialog(playerid,DIALOG_PHONE_BUYCREDIT,DIALOG_STYLE_TABLIST,"Phone - Buy Phone Credit",str,"Buy","Cancel");
					}
				}
			}
		}

		case DIALOG_SHOP_ELECTRONIC:
		{
			if(response) {
				new
					phone_fh[200],
					electronicid;
				for(new i; i < MAX_ELECTRONIC; i++)
				{
					if(GetPlayerVirtualWorld(playerid) == bizElectronic[i][WorldID]) {
						electronicid = i;
					}
				}
				if(!strcmp(bizElectronic[electronicid][Owner],RetPname(playerid))) return SendClientMessage(playerid, -1, "ERROR: You can't buy products from your own business");
				switch(listitem) {
					case 0:
					{
						if(GetPlayerMoney(playerid) < bizElectronic[electronicid][PhonePrice]) return SendClientMessage(playerid,-1,"ERROR: Not Enough Money");
						if(bizElectronic[electronicid][Phone] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(pInventory[playerid][Phone]) return SendClientMessage(playerid,-1,"ERROR: You already have a phone");
						GivePlayerMoney(playerid, -bizElectronic[electronicid][PhonePrice]);
						bizElectronic[electronicid][Phone] -= 1;
						bizElectronic[electronicid][Balance] += floatval((floatround((bizElectronic[electronicid][PhonePrice] / 10.0),floatround_floor)));
						pInventory[playerid][Phone] = true;
						for(new i; i < MAX_PHONE_NUMBER; i++)
						{
							format(phone_fh,sizeof(phone_fh),PHONE_NUMBER_DIR,i);
							if(!fexist(phone_fh)) {
								ftouch(phone_fh);
								pStat[playerid][PhoneNumber] = i;
								SendClientMessage(playerid, -1, "type {00FFFF}/phone{FFFFFF} to check your phone number");
								break;
							}
							else if(fexist(phone_fh)) continue;
							else if(i == NUMBER_TAXI || i == NUMBER_MECHANIC || i == NUMBER_EMERGENCY) continue;
						}
					}
					case 1:
					{
						if(GetPlayerMoney(playerid) < bizElectronic[electronicid][BoomboxPrice]) return SendClientMessage(playerid,-1,"ERROR: Not Enough Money");
						if(bizElectronic[electronicid][Boombox] == 0) return SendClientMessage(playerid, -1, "ERROR: Out of stock");
						if(pInventory[playerid][Boombox]) return SendClientMessage(playerid,-1,"ERROR: You already have a boombox");
						GivePlayerMoney(playerid, -bizElectronic[electronicid][BoomboxPrice]);
						bizElectronic[electronicid][Boombox] -= 1;
						bizElectronic[electronicid][Balance] += floatval((floatround((bizElectronic[electronicid][BoomboxPrice] / 10.0),floatround_floor)));
						pInventory[playerid][Boombox] = true;
						SendClientMessage(playerid, -1, "Command For boombox is {00AAAA}/boombox");
					}
				}
			}
		}

		case DIALOG_MAKEGUN:
		{
			if(response) {
				if(!pToolEquip[playerid][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: You're not equiping screwdriver");
				switch(listitem) {
					case 0: //silenced
					{
						if(pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "You already have that weapon");
						if(pInventory[playerid][GunPart] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						if(pInventory[playerid][ToolDurability][Screwdriver] <= 0) {
							pInventory[playerid][Screwdriver] = false;
							pToolEquip[playerid][Screwdriver] = false;
							pToolEquip[playerid][Equip] = false;
							RemovePlayerAttachedObject(playerid, OBJECT_INDEX_SCREW);
							pInventory[playerid][ToolDurability][Screwdriver] = 0;
							SendClientMessage(playerid, -1, "Your Screwdriver is broken!");
						}
						pInventory[playerid][ToolDurability][Screwdriver] -= 1;
						pInventory[playerid][GunPart] -= 3;
						pWeapon[playerid][Colt] = true;
						pWeapon[playerid][ColtDurability] = 100.0;
						SendClientMessage(playerid, -1, "You Made Silenced colt45 using 3 gun parts");
					}
					case 1: //deagle
					{
						if(pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "You already have that weapon");
						if(pInventory[playerid][GunPart] < 7) return SendClientMessage(playerid, -1, "ERROR: Not Enough Gun Parts");
						if(pInventory[playerid][ToolDurability][Screwdriver] <= 0) {
							pInventory[playerid][Screwdriver] = false;
							pToolEquip[playerid][Screwdriver] = false;
							pToolEquip[playerid][Equip] = false;
							RemovePlayerAttachedObject(playerid, OBJECT_INDEX_SCREW);
							pInventory[playerid][ToolDurability][Screwdriver] = 0;
							SendClientMessage(playerid, -1, "Your Screwdriver is broken!");
						}
						pInventory[playerid][ToolDurability][Screwdriver] -= 1;
						pInventory[playerid][GunPart] -= 7;
						pWeapon[playerid][Deagle] = true;
						pWeapon[playerid][DeagleDurability] = 100.0;
						SendClientMessage(playerid, -1, "You Made Desert Eagle using 7 gun parts");
					}
					case 2: //rifle
					{
						if(pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "You already have that weapon");
						if(pInventory[playerid][GunPart] < 16) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						if(pInventory[playerid][ToolDurability][Screwdriver] <= 0) {
							pInventory[playerid][Screwdriver] = false;
							pToolEquip[playerid][Screwdriver] = false;
							pToolEquip[playerid][Equip] = false;
							RemovePlayerAttachedObject(playerid, OBJECT_INDEX_SCREW);
							pInventory[playerid][ToolDurability][Screwdriver] = 0;
							SendClientMessage(playerid, -1, "Your Screwdriver is broken!");
						}
						pInventory[playerid][ToolDurability][Screwdriver] -= 1;
						pInventory[playerid][GunPart] -= 16;
						pWeapon[playerid][Rifle] = true;
						pWeapon[playerid][RifleDurability] = 100.0;
						SendClientMessage(playerid, -1, "You Made Rifle using 16 gun parts");
					}
					case 3: //shotgun
					{
						if(pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "You already have that weapon");
						if(pInventory[playerid][GunPart] < 14) return SendClientMessage(playerid, -1, "ERROR: Not Enought Gun Parts");
						if(pInventory[playerid][ToolDurability][Screwdriver] <= 0) {
							pInventory[playerid][Screwdriver] = false;
							pToolEquip[playerid][Screwdriver] = false;
							pToolEquip[playerid][Equip] = false;
							RemovePlayerAttachedObject(playerid, OBJECT_INDEX_SCREW);
							pInventory[playerid][ToolDurability][Screwdriver] = 0;
							SendClientMessage(playerid, -1, "Your Screwdriver is broken!");
						}
						pInventory[playerid][ToolDurability][Screwdriver] -= 1;
						pInventory[playerid][GunPart] -= 14;
						pWeapon[playerid][Shotgun] = true;
						pWeapon[playerid][ShotgunDurability] = 100.0;
						SendClientMessage(playerid, -1, "You Made Shotgun using 14 gun parts");
					}
				}
			}
		}

		case DIALOG_LOGIN:
		{
			if(response) {
				new format_file_account[300];
				new fetch_pass[80];
				new get_pass[100];

				/* formatting */
				format(format_file_account,sizeof(format_file_account),PLAYER_ACCOUNT,RetPname(playerid));

				format(get_pass, sizeof(get_pass),"%s", inputtext);

				format(fetch_pass,sizeof(fetch_pass), "%s", dini_Get(format_file_account,"password"));

				pAccount[playerid][Password] = fetch_pass;

				if(strcmp(pAccount[playerid][Password],get_pass,false) || strlen(get_pass) <= 0) {
					ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","{AA0000}Password Incorrect!{FFFFFF}\nThis Username Is Registered\nType Your Password In Order To Login","Login","Leave");
				}
				else { /* if Password were Correct */
					TogglePlayerSpectating(playerid, 0);
					SetPlayerColor(playerid, 0xFFFFFFFF); /* Player Has Logged In */
					FirstSpawn[playerid] = true;
					IsPlayerLoggedIn[playerid] = true;
				}
			}
			else Kick(playerid);
		}

		case DIALOG_REGISTER:
		{
			new format_file_account[300];
			new fetch_pass[100];

			/* formatting */
			format(format_file_account,sizeof(format_file_account),PLAYER_ACCOUNT,RetPname(playerid));

			format(fetch_pass,sizeof(fetch_pass),"%s", inputtext);

			if(response)
			{
				if(strlen(fetch_pass) > 18) {
					ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"Register","{AA0000}Password Is Too Long(min 8 char, max 18 char){FFFFFF}\nThis Username Is Not Registered\nType Your Desired Password to Create Account","Register","Leave");
				}
				else if(strlen(fetch_pass) < 8) {
					ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"Register","{AA0000}Password Is Too Short(min 8 char, max 18 char){FFFFFF}\nThis Username Is Not Registered\nType Your Desired Password to Create Account","Register","Leave");
				}
				else { /* if Password were Correct */
					ftouch(format_file_account);
					dini_Set(format_file_account,"password",fetch_pass);
					SendClientMessage(playerid, -1, "{FFFF00}[DATABASE]{FFFFFF} Your account has been created and saved into database");
					TogglePlayerSpectating(playerid, 0);
					SetPlayerColor(playerid, 0xFFFFFFFF); /* Player Has Logged In */
					IsNewAccount[playerid] = true;
					FirstSpawn[playerid] = true;
					IsPlayerLoggedIn[playerid] = true;
					pAccount[playerid][LevelCount] = 60;
					pAccount[playerid][XPMax] = 1;
				}
			}
			else Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	new vitd[128];
	new id;
	new pkeys[3];
	new bool:ispv;
	foreach(new i : Player) {
		if(GetPlayerVehicleID(playerid) == pVehicle[i][ID]) {
			id = i;
			ispv = true;
		}
	}
	format(vitd,sizeof(vitd),"Speed: ~r~%.0fKm/h",GetVehicleSpeed(GetPlayerVehicleID(playerid)));
	PlayerTextDrawSetString(playerid, VehicleIndicator[playerid][Speed], vitd);
	format(vitd,sizeof(vitd),"Health: ~r~%.2f",RetVehicleHealth(GetPlayerVehicleID(playerid)));
	PlayerTextDrawSetString(playerid, VehicleIndicator[playerid][Health], vitd);
	if(ispv) format(vitd,sizeof(vitd),"Fuel: ~r~%.1f",pVehicle[id][Fuel]);
	else format(vitd,sizeof(vitd),"Fuel: ~r~-");
	PlayerTextDrawSetString(playerid, VehicleIndicator[playerid][Fuel], vitd);
	if(ispv) format(vitd,sizeof(vitd),"Temp: ~r~%.2f",pVehicle[id][Heat]);
	else format(vitd,sizeof(vitd),"Temp: ~r~-");
	PlayerTextDrawSetString(playerid, VehicleIndicator[playerid][Heat], vitd);

	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(pMission[playerid][Trucker]) {
		DisablePlayerCheckpoint(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnloadTruck", 15000, 0, "i", playerid);
		SendClientMessage(playerid, -1, "Your truck is being unloaded, please wait...");
		return 1;
	}

	if(pMission[playerid][License]) {
		if(pCheckpoint[playerid][License]==0)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1063.8724,-1396.6310,13.3202, 4.0);
			pCheckpoint[playerid][License]=1;
			return 1;
		}
		if(pCheckpoint[playerid][License]==1)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 638.7693,-1393.0518,13.2605, 4.0);
			pCheckpoint[playerid][License]=2;
			return 1;
		}
		if(pCheckpoint[playerid][License]==2)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 333.2494,-1645.6069,32.9534, 4.0);
			pCheckpoint[playerid][License]=3;
			return 1;
		}
		if(pCheckpoint[playerid][License]==3)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 627.6226,-1680.9847,15.2502, 4.0);
			pCheckpoint[playerid][License]=4;
			return 1;
		}
		if(pCheckpoint[playerid][License]==4)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 812.6509,-1676.9397,13.2069, 4.0);
			pCheckpoint[playerid][License]=5;
			return 1;
		}
		if(pCheckpoint[playerid][License]==5)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 916.2547,-1572.9487,13.2076, 4.0);
			pCheckpoint[playerid][License]=6;
			return 1;
		}
		if(pCheckpoint[playerid][License]==6)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1035.1119,-1574.8888,13.2149, 4.0);
			pCheckpoint[playerid][License]=7;
			return 1;
		}
		if(pCheckpoint[playerid][License]==7)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1032.7805,-1785.1420,13.3797, 4.0);
			pCheckpoint[playerid][License]=8;
			return 1;
		}
		if(pCheckpoint[playerid][License]==8)
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1095.9435,-1790.4817,13.4121, 4.0);
			pCheckpoint[playerid][License]=9;
			return 1;
		}
		if(pCheckpoint[playerid][License]==9)
		{
			new Float:DTH;
			new y,m,d;
			getdate(y, m, d);
			DisablePlayerCheckpoint(playerid);
			pCheckpoint[playerid][License]=0;
			pMission[playerid][License] = false;
			sLicense[OnTest] = false;
			sLicense[TestID] = -1;
			GetVehicleHealth(publicVehicle[DrivingLicense], DTH);
			RemovePlayerFromVehicle(playerid);
			SetVehicleToRespawn(publicVehicle[DrivingLicense]);
			RepairVehicle(publicVehicle[DrivingLicense]);
			if(DTH == 1000.0) {
				SendClientMessage(playerid, -1, "Test {00FF00}Success!{FFFFFF}, Congratulations!, You got your Driving License");
				pInventory[playerid][License] = true;
				pInventory[playerid][LicenseDate][0] = d;
				pInventory[playerid][LicenseDate][1] = m;
				pInventory[playerid][LicenseDate][2] = y;
				new f[200];
				format(f,sizeof(f),PLAYER_INVENTORY,RetPname(playerid));
				dini_BoolSet(f,"license",true);
				dini_IntSet(f,"licensed",d);
				dini_IntSet(f,"licensem",m);
				dini_IntSet(f,"licensey",y);
			}
			else if(DTH < 950.0) {
				SendClientMessage(playerid, -1, "Test {FF0000}Failed!{FFFFFF}, You Damaged the vehicle, However you can retry the test...");
			}
			return 1;
		}
	}

	if(pMission[playerid][Mower]) {
		if(pCheckpoint[playerid][Mower]==0) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,778.3362,-1261.4713,13.5700,2.0);
			pCheckpoint[playerid][Mower]=1;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==1) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,756.8885,-1261.6589,13.5594,2.0);
			pCheckpoint[playerid][Mower]=2;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==2) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,757.9849,-1299.0842,13.5625,2.0);
			pCheckpoint[playerid][Mower]=3;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==3) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,735.0977,-1300.8339,13.5719,2.0);
			pCheckpoint[playerid][Mower]=4;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==4) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,735.0601,-1261.1869,13.5578,2.0);
			pCheckpoint[playerid][Mower]=5;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==5) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,755.9155,-1261.0476,13.5582,2.0);
			pCheckpoint[playerid][Mower]=6;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==6) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,756.0299,-1220.8523,13.5534,2.0);
			pCheckpoint[playerid][Mower]=7;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==7) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,736.6465,-1220.5408,13.7910,2.0);
			pCheckpoint[playerid][Mower]=8;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==8) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,734.7372,-1259.1790,13.5568,2.0);
			pCheckpoint[playerid][Mower]=9;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==9) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,753.9909,-1259.3231,13.5559,2.0);
			pCheckpoint[playerid][Mower]=10;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==10) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,777.2738,-1261.6250,13.5687,2.0);
			pCheckpoint[playerid][Mower]=11;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==11) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,776.4459,-1219.1373,13.5469,2.0);
			pCheckpoint[playerid][Mower]=12;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==12) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,756.2017,-1219.4774,13.5469,2.0);
			pCheckpoint[playerid][Mower]=13;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==13) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,755.7710,-1257.1257,13.5636,2.0);
			pCheckpoint[playerid][Mower]=14;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==14) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,755.7124,-1298.7551,13.5625,2.0);
			pCheckpoint[playerid][Mower]=15;
			return 1;
		}
		if(pCheckpoint[playerid][Mower]==15) {
			DisablePlayerCheckpoint(playerid);
			pMission[playerid][Mower]=false;
			pCheckpoint[playerid][Mower]=0;
			GivePlayerMoney(playerid, 10);
			SendClientMessage(playerid, -1, "You got paid {008000}$10{FFFFFF} for finishing the job");
			RemovePlayerFromVehicle(playerid);
			return 1;
		}
	}
	if(pMission[playerid][BusDriver]) {
		if(pCheckpoint[playerid][BusDriver]==0) {
			pCheckpoint[playerid][BusDriver] = 1;
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1249.0411,-2029.5443,59.7376, 10.0);
			SendClientMessage(playerid, -1, "Go back to bus station to get paid");
			return 1;
		}
		if(pCheckpoint[playerid][BusDriver]==1) {
			pMission[playerid][BusDriver] = false;
			pCheckpoint[playerid][BusDriver] = 0;
			DisablePlayerCheckpoint(playerid);
			GivePlayerMoney(playerid, 45);
			SendClientMessage(playerid, -1, "You got paid {008000}$45{FFFFFF} for completing your job");
			for(new i; i < 7; i++)
			{
				if(!strcmp(vBus[i][Owner],RetPname(playerid))) {
					strcpy(vBus[i][Owner],"None");
					return 1;
				}
			}
			return 1;
		}
	}
	if(pMission[playerid][Material]) {
		pInventory[playerid][Material] += 3;
		SendClientMessage(playerid, -1, "You've collected 3 materials");
		pMission[playerid][Material] = false;
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pMission[playerid][Product]) {
		pInventory[playerid][Product] += 1;
		SendClientMessage(playerid, -1, "You've collected 1 product");
		pMission[playerid][Product] = false;
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pMission[playerid][Component]) {
		pInventory[playerid][Component] += 10;
		SendClientMessage(playerid, -1, "You've collected 10 components");
		pMission[playerid][Component] = false;
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pMission[playerid][Sweeper]) {
		if(pCheckpoint[playerid][Sweeper] == 0) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1336.9396,-927.3497,35.6945,8.0);
			pCheckpoint[playerid][Sweeper] = 1;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 1) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1259.6000,-926.6443,42.5513,8.0);
			pCheckpoint[playerid][Sweeper] = 2;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 2) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1260.1583,-1038.8713,31.7266,8.0);
			pCheckpoint[playerid][Sweeper] = 3;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 3) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1259.2603,-1144.9391,23.6563,8.0);
			pCheckpoint[playerid][Sweeper] = 4;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 4) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1216.2162,-1145.2080,23.4636,8.0);
			pCheckpoint[playerid][Sweeper] = 5;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 5) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1216.6553,-1280.6934,13.3828,8.0);
			pCheckpoint[playerid][Sweeper] = 6;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 6) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1196.8948,-1291.6854,13.3801,8.0);
			pCheckpoint[playerid][Sweeper] = 7;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 7) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1194.4907,-1400.3767,13.2385,8.0);
			pCheckpoint[playerid][Sweeper] = 8;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 8) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1357.7035,-1398.7662,13.2981,8.0);
			pCheckpoint[playerid][Sweeper] = 9;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 9) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1357.6914,-1281.1809,13.2830,8.0);
			pCheckpoint[playerid][Sweeper] = 10;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 10) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1359.5192,-1139.8307,23.6563,8.0);
			pCheckpoint[playerid][Sweeper] = 11;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 11) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1370.7501,-1036.1681,26.2208,8.0);
			pCheckpoint[playerid][Sweeper] = 12;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 12) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1378.7150,-935.6437,34.1875,8.0);
			pCheckpoint[playerid][Sweeper] = 13;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 13) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1336.9396,-927.3497,35.6945,8.0);
			pCheckpoint[playerid][Sweeper] = 14;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == 14) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid,1324.2096,-864.3158,39.5781,8.0);
			pCheckpoint[playerid][Sweeper] = -1;
			return 1;
		}
		if(pCheckpoint[playerid][Sweeper] == -1) {
			DisablePlayerCheckpoint(playerid);
			pMission[playerid][Sweeper] = false;
			RemovePlayerFromVehicle(playerid);
			SetSweeperToRespawn2(2000);
			SendClientMessage(playerid, -1, "job completed, you got {008000}$15{FFFFFF} for completing the job");
			GivePlayerMoney(playerid, 15);
			pCheckpoint[playerid][Sweeper] = 0;
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new
		Float:pos[3];
	for(new i; i < MAX_RENTVEH_FAGGIO; i++)
	{
		if(vRent[i][ID] == vehicleid) {
			if(vRent[i][Locked]) {
				GameTextForPlayer(playerid, "~r~Locked", 1000, 4);
				GetPlayerPos(playerid, pos[0],pos[1],pos[2]);
				SetPlayerPos(playerid, pos[0],pos[1],pos[2]);
			}
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) {
				SendClientMessage(playerid, -1, "You has been kicked because of suspicion of using cheat program");
				Kick2(playerid,100);
			}
		}
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(vehicleid == pVehicle[i][ID])
		{
			if(pVehicle[i][Lock]) {
				GameTextForPlayer(playerid, "~r~Locked", 1000, 5);
				ClearAnimations(playerid);
			}
		}
	}
	if(vehicleid == publicVehicle[DrivingLicense]) {
		if(sLicense[TestID] != playerid) {
			ClearAnimations(playerid);
			SendClientMessage(playerid,-1,"ERROR: You can't get in this driving test vehicle");
		}
	}
	if(vehicleid != publicVehicle[DrivingLicense] && sLicense[TestID] == playerid) {
		ClearAnimations(playerid);
		SendClientMessage(playerid,-1,"ERROR: You must get into the driving test car");
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	foreach(new i : Player)
	{
		if(vehicleid == pVehicle[i][ID]) {
			UpdateVehicleData(i);
			SaveVehicle(i);
			DestroyVehicle(pVehicle[i][ID]);
			SendClientMessage(i, -1, "Your vehicle was destroyed, vehicle will be respawned shortly on your vehicle park position");
			SpawnParkVehicle(i);
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    new Float:HP;
    GetPlayerHealth(playerid, Float:HP);

    if(weaponid == WEAPON_COLT45)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-10);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-25);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-8);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-8);
        }
    }

    if(weaponid == WEAPON_SILENCED)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, (HP-13));
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, (HP-27));
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, (HP-11));
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, (HP-11));
        }
    }

    if(weaponid == WEAPON_DEAGLE)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-20);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-32);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-13);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-13);
        }
    }

    if(weaponid == WEAPON_TEC9)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-8);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-15);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-4);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-4);
        }
    }

    if(weaponid == WEAPON_UZI)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-9);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-18);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-5);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-5);
        }
    }

    if(weaponid == WEAPON_MP5)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-10);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-25);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-8);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-8);
        }
    }

    if(weaponid == WEAPON_SHOTGUN)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-30);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-48);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-15);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-15);
        }
    }

    if(weaponid == WEAPON_SAWEDOFF)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-38);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-53);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-20);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-20);
        }
    }

    if(weaponid == WEAPON_SHOTGSPA)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-40);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-56);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-20);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-20);
        }
    }

    if(weaponid == WEAPON_AK47)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-40);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-56);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-24);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-24);
        }
    }

    if(weaponid == WEAPON_M4)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-43);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-60);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-25);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-25);
        }
    }

    if(weaponid == WEAPON_RIFLE)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-60);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-80);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-28);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-28);
        }
    }

    if(weaponid == WEAPON_SNIPER)
    {
        if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
        {
            SetPlayerHealth(playerid, HP-75);
        }
        if(bodypart == BODY_PART_HEAD)
        {
            SetPlayerHealth(playerid, HP-90);
        }
        if(bodypart == BODY_PART_LEFT_ARM || bodypart == BODY_PART_RIGHT_ARM)
        {
            SetPlayerHealth(playerid, HP-30);
        }
        if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
        {
            SetPlayerHealth(playerid, HP-30);
        }
    }
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	/* Civil Weapon Durability */
	if(weaponid == WEAPON_SILENCED)
    {
        if(pWeapon[playerid][ColtDurability] > 0.0) {
        	pWeapon[playerid][ColtDurability] -= 0.5;
        }
        else if(pWeapon[playerid][ColtDurability] <= 0.0) {
        	new broken_chance = random(2);
        	switch(broken_chance)
        	{
        		case 0:
        		{
        			pWeapon[playerid][Colt] = false;
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Silenced Colt45 is broken, unfortunately... you lost the gun");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        		case 1:
        		{
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Silenced Colt45 is broken, luckily... you can still repair it");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        	}
        }
    }
    if(weaponid == WEAPON_DEAGLE)
    {
        if(pWeapon[playerid][DeagleDurability] > 0.0) {
        	pWeapon[playerid][DeagleDurability] -= 0.8;
        }
        else if(pWeapon[playerid][DeagleDurability] <= 0.0) {
        	new broken_chance = random(2);
        	switch(broken_chance)
        	{
        		case 0:
        		{
        			pWeapon[playerid][Deagle] = false;
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Desert Eagle is broken, unfortunately... you lost the gun");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        		case 1:
        		{
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Desert Eagle is broken, luckily... you can still repair it");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        	}
        }
    }
    if(weaponid == WEAPON_SHOTGUN)
    {
        if(pWeapon[playerid][ShotgunDurability] > 0.0) {
        	pWeapon[playerid][ShotgunDurability] -= 1.0;
        }
        else if(pWeapon[playerid][ShotgunDurability] <= 0.0) {
        	new broken_chance = random(2);
        	switch(broken_chance)
        	{
        		case 0:
        		{
        			pWeapon[playerid][Shotgun] = false;
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Shotgun is broken, unfortunately... you lost the gun");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        		case 1:
        		{
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Shotgun is broken, luckily... you can still repair it");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        	}
        }
    }
    if(weaponid == WEAPON_RIFLE)
    {
        if(pWeapon[playerid][RifleDurability] > 0.0) {
        	pWeapon[playerid][RifleDurability] -= 1.2;
        }
        else if(pWeapon[playerid][RifleDurability] <= 0.0) {
        	new broken_chance = random(3);
        	switch(broken_chance)
        	{
        		case 0:
        		{
        			pWeapon[playerid][Rifle] = false;
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Rifle is broken, unfortunately... you lost the gun");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        		case 1,2:
        		{
        			SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{AAAAAA} Your Rifle is broken, luckily... you can still repair it");
        			pWeaponEquip[playerid][IsEquip] = false;
					ResetPlayerWeapons(playerid);
					if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
					if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
					if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
					if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
					SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
        		}
        	}
        }
    }
	if(hittype == BULLET_HIT_TYPE_VEHICLE)
    {
        new Float:vHelth;
        GetVehicleHealth(hitid, vHelth);
        if(weaponid == WEAPON_COLT45)
        {
            SetVehicleHealth(hitid, (vHelth - 35.0));
        }
        if(weaponid == WEAPON_SILENCED)
        {
            SetVehicleHealth(hitid, (vHelth - 38.0));
        }
        if(weaponid == WEAPON_DEAGLE)
        {
            SetVehicleHealth(hitid, (vHelth - 45.0));
        }
        if(weaponid == WEAPON_SHOTGUN)
        {
            SetVehicleHealth(hitid, (vHelth - 100.0));
        }
        if(weaponid == WEAPON_SAWEDOFF)
        {
            SetVehicleHealth(hitid, (vHelth - 130.0));
        }
        if(weaponid == WEAPON_SHOTGSPA)
        {
            SetVehicleHealth(hitid, (vHelth - 180.0));
        }
        if(weaponid == WEAPON_TEC9)
        {
            SetVehicleHealth(hitid, (vHelth - 40.0));
        }
        if(weaponid == WEAPON_UZI)
        {
            SetVehicleHealth(hitid, (vHelth - 48.0));
        }
        if(weaponid == WEAPON_MP5)
        {
            SetVehicleHealth(hitid, (vHelth - 53.0));
        }
        if(weaponid == WEAPON_AK47)
        {
            SetVehicleHealth(hitid, (vHelth - 68.0));
        }
        if(weaponid == WEAPON_M4)
        {
            SetVehicleHealth(hitid, (vHelth - 70.0));
        }
        if(weaponid == WEAPON_RIFLE)
        {
            SetVehicleHealth(hitid, (vHelth - 80.0));
        }
        if(weaponid == WEAPON_SNIPER)
        {
            SetVehicleHealth(hitid, (vHelth - 95.0));
        }
        if(weaponid == WEAPON_BRASSKNUCKLE)
        {
            SetVehicleHealth(hitid, (vHelth - 8.0));
        }
        if(weaponid == WEAPON_ROCKETLAUNCHER)
        {
            SetVehicleHealth(hitid, (vHelth - 1000.0));
        }
        if(weaponid == WEAPON_MINIGUN)
        {
            SetVehicleHealth(hitid, (vHelth - 10.0));
        }
        if(weaponid == WEAPON_GOLFCLUB)
        {
            SetVehicleHealth(hitid, (vHelth - 12.0));
        }
        if(weaponid == WEAPON_SHOVEL)
        {
            SetVehicleHealth(hitid, (vHelth - 12.0));
        }
        if(weaponid == WEAPON_NITESTICK)
        {
            SetVehicleHealth(hitid, (vHelth - 10.0));
        }
        if(weaponid == WEAPON_BAT)
        {
            SetVehicleHealth(hitid, (vHelth - 12.0));
        }
        if(weaponid == WEAPON_HEATSEEKER)
        {
            SetVehicleHealth(hitid, (vHelth - 1000.0));
        }
    }
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(ToggleMapTP[playerid]) {
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerAdmin(playerid) && GetPlayerInterior(playerid) == 0)
	    {
	    	if(!IsPlayerInAnyVehicle(playerid)) SetPlayerPos(playerid, fX, fY, fZ);
	    	else SetVehiclePos(vehicleid, fX, fY, fZ);
		}
	}
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if(oldinteriorid == 0 && newinteriorid > 0) FreezePlayer(playerid,1000);
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ )
{
	if(response) {
		new i = index;
		pAccs[playerid][i][Model] = modelid;
		pAccs[playerid][i][Bone] = boneid;

		pAccs[playerid][i][Offset][0] = fOffsetX;
		pAccs[playerid][i][Offset][1] = fOffsetY;
		pAccs[playerid][i][Offset][2] = fOffsetZ;

		pAccs[playerid][i][Rot][0] = fRotX;
		pAccs[playerid][i][Rot][1] = fRotY;
		pAccs[playerid][i][Rot][2] = fRotZ;

		pAccs[playerid][i][Scale][0] = fScaleX;
		pAccs[playerid][i][Scale][1] = fScaleY;
		pAccs[playerid][i][Scale][2] = fScaleZ;

		pAccs[playerid][i][IsAttached] = true;
		pAccs[playerid][i][IsEmpty] = false;
		
		SaveAccs(playerid);
		InitAccs(playerid);
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == sModelSel[Skin])
	{
		new clothesid;
		for(new i; i < MAX_CLOTHES; i++)
		{
			if(GetPlayerVirtualWorld(playerid) == bizClothes[i][WorldID]) {
				clothesid = i;
			}
		}
		if(response) {
			new
				INI:FH,
				f_msg[400],
				f_fo[400];
			format(f_fo,sizeof(f_fo),PLAYER_POSITION,RetPname(playerid));
			if(pJobDuty[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You cannot buy new clothes as you're wearing job uniform");
			format(f_msg,sizeof(f_msg),"ERROR: Not enough money, $%d for every clothes", bizClothes[clothesid][ClothesPrice]);
			if(GetPlayerMoney(playerid) < bizClothes[clothesid][ClothesPrice]) return SendClientMessage(playerid, -1, f_msg);
			if(pPosition[playerid][SkinID] == modelid) return SendClientMessage(playerid, -1, "ERROR: Skin Cannot be the same as previous skin");
			GivePlayerMoney(playerid, bizClothes[clothesid][ClothesPrice]);
			SetPlayerSkin(playerid, modelid);
			pPosition[playerid][SkinID] = modelid;
			bizClothes[clothesid][Stock] -= 1;
			bizClothes[clothesid][Balance] += floatval((floatround((bizClothes[clothesid][ClothesPrice] / 10.0),floatround_floor)));
			format(f_msg,sizeof(f_msg),"You bought new skin for {008000}$%d",bizClothes[clothesid][ClothesPrice]);
			SendClientMessage(playerid, -1, f_msg);
			FH = INI_Open(f_fo);
			INI_WriteInt(FH,"skin",modelid);
			INI_Close(FH);
		}
	}
	if(listid == sModelSel[MechanicDutySkin]) {
		if(response) {
			pJobDuty[playerid][Mechanic] = true;
			SetPVarInt(playerid, "PrevSkinMechanic", GetPlayerSkin(playerid));
			SetPlayerSkin2(playerid, modelid);
			SendClientMessage(playerid, -1, "You've been on duty as a mechanic");
			SetPlayerColor(playerid, 0xFF000000);
			return 1;
		}
	}
	if(listid == sModelSel[MechanicTuneWheel]) {
		if(!response) {
			pOffer[playerid][MechanicTune] = false;
			pOffer[pOffer[playerid][OfferedBy]][IsOffering] = false;
			pOffer[playerid][OfferedBy] = -1;
		}
		else {
			/* SOF */
			AddVehicleComponent(GetPlayerVehicleID(playerid), modelid);
			/* Reset Vars */
			pOffer[playerid][MechanicTune] = false;
			pOffer[pOffer[playerid][OfferedBy]][IsOffering] = false;
			pOffer[playerid][OfferedBy] = -1;
		}
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	new log[400];

	if(!success) SendClientMessageEx(playerid, -1, "{FF0000}[SERVER]: Unknown Command, type /help, or /qna to ask questions");

	format(log,sizeof(log),"%s Has sent a command: %s, Success: %d\r\n", RetPname(playerid),cmdtext,success);

	Logger(CMD_LOGFILE_PATH,log);

	return 1;
}

public OnVehicleCreated(vehicleid)
{
	if(!HasNoEngine(vehicleid)) SetVehicleParamsEx(vehicleid,0,0,0,0,0,0,0);
	else SetVehicleParamsEx(vehicleid,1,0,0,0,0,0,0);
	return 1;
}

/* Commands */
CMD:strhashint(playerid, params[])
{
	new str[12];
	if(sscanf(params, "s[256]", str)) return SendClientMessage(playerid, -1, "Usage: /strhashint [str]");
	if(strlen(str) > 12) return SendClientMessage(playerid, -1, "ERROR: max str size: 12");
	return SendClientMessageEx(playerid, -1, "Hashed: %d",bernstein(str));
}

CMD:needs(playerid, params[])
{
	SendClientMessageEx(playerid, -1, "Hunger: %.1f | Thirst: %.1f | Energy: %.1f",
		pStatus[playerid][Hunger],
		pStatus[playerid][Thirst],
		pStatus[playerid][Energy]
	);
	return 1;
}

CMD:discardfood(playerid, params[])
{
	new sl;
	if(sscanf(params, "i", sl)) return SendClientMessage(playerid, -1, "Usage: /discardfood [slot]");
	if(sl < 0 || sl > 4) return SendClientMessage(playerid, -1, "ERROR: Invalid slot");
	if(pFood[playerid][sl][Empty]) return SendClientMessage(playerid, -1, "ERROR: Slot is empty");
	SendClientMessage(playerid, -1, "You have discarded the food on the specified slot");
	DeleteFood(playerid, sl);
	return 1;
}

CMD:food(playerid, params[])
{
	new msg[280];
	for(new i; i < 5; i++)
	{
		if(!pFood[playerid][i][Empty]) format(msg,sizeof(msg),"%s%s\n",msg,pFood[playerid][i][FoodText]);
		else format(msg,sizeof(msg),"%sEmpty\n",msg);
	}
	ShowPlayerDialog(playerid,DIALOG_FOOD,DIALOG_STYLE_LIST,"Food",msg,"Use","Close");
	return 1;
}

CMD:sellfish(playerid, params[])
{
	if(pInventory[playerid][Fish][Count] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have any fishes");
	GivePlayerMoney(playerid, floatval( (floatround( (pInventory[playerid][Fish][Weigth] / 30) , floatround_floor ) ) ) );
	SendClientMessageEx(playerid, -1, "{00FFFF}[FISHING]{FFFFFF}: You have sold {FFFF00}%d{FFFFFF} Fishes, with total Weigth {FFFF00}%d grams{FFFFFF} for {008000}$%d{FFFFFF}",
		pInventory[playerid][Fish][Count],
		pInventory[playerid][Fish][Weigth],
		floatval(floatround((pInventory[playerid][Fish][Weigth] / 30),floatround_floor))
	);
	pInventory[playerid][Fish][Count] = 0;
	pInventory[playerid][Fish][Weigth] = 0;
	return 1;
}

CMD:mybaits(playerid, params[])
{
	SendClientMessageEx(playerid, -1, "You Have {00AAAA}%d{FFFFFF} Bait(s)", pInventory[playerid][Bait]);
	return 1;
}

CMD:buybait(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 1.5,359.3359,-2032.1019,7.8359)) return SendClientMessage(playerid, -1, "ERROR: You're not at bait shop");
	if(GetPlayerMoney(playerid) < 25) return SendClientMessage(playerid, -1, "ERROR: You need $25 to buy 10 baits");
	if(pInventory[playerid][Bait] >= 50) return SendClientMessage(playerid, -1, "ERROR: You can't buy more baits");
	pInventory[playerid][Bait] += 10;
	GivePlayerMoney(playerid, -25);
	SendClientMessage(playerid, -1, "You bought 10 baits");
	return 1;
}

CMD:myfish(playerid, params[])
{
	return SendClientMessageEx(playerid, -1, "Fish: {FFFF00}%d{FFFFFF} | Total Weigth: {FFFF00}%d grams", pInventory[playerid][Fish][Count],pInventory[playerid][Fish][Weigth]);
}

CMD:discardtool(playerid, params[])
{
	new opt[80];
	if(sscanf(params, "s[80]", opt)) return SendClientMessage(playerid, -1, "Usage: /equiptool [toolname]");

	if(!strcmp(opt,"fishingrod",false)) {
		if(!pInventory[playerid][Rod]) return SendClientMessage(playerid, -1, "ERROR: You don't have a fishing rod");
		pInventory[playerid][Rod] = false;
		pInventory[playerid][ToolDurability][Rod] = 0;
		return SendClientMessage(playerid, -1, "You have discarded the specified tool");
	}
	if(!strcmp(opt,"screwdriver",false)) {
		if(!pInventory[playerid][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: You don't have a screwdriver");
		pInventory[playerid][Screwdriver] = false;
		pInventory[playerid][ToolDurability][Screwdriver] = 0;
		return SendClientMessage(playerid, -1, "You have discarded the specified tool");
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid option");
}

CMD:equiptool(playerid, params[])
{
	new opt[80];
	if(sscanf(params, "s[80]", opt)) return SendClientMessage(playerid, -1, "Usage: /equiptool [toolname]");

	if(!strcmp(opt,"fishingrod",false)) {
		if(!pInventory[playerid][Rod]) return SendClientMessage(playerid, -1, "ERROR: You don't have a fishing rod");
		if(pToolEquip[playerid][Equip] && !pToolEquip[playerid][Rod]) return SendClientMessage(playerid, -1, "ERROR: You already equiping another tool");
		if(!pToolEquip[playerid][Rod]) {
			pToolEquip[playerid][Rod] = true;
			pToolEquip[playerid][Equip] = true;
			SendClientMessage(playerid, -1, "You have equiped a fishing rod");
			pObj[playerid][Rod] = SetPlayerAttachedObject(playerid, OBJECT_INDEX_ROD,18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
			return 1;
		}
		else if(pToolEquip[playerid][Rod]) {
			pToolEquip[playerid][Rod] = false;
			pToolEquip[playerid][Equip] = false;
			SendClientMessage(playerid, -1, "You have unequiped fishing rod");
			RemovePlayerAttachedObject(playerid, OBJECT_INDEX_ROD);
			RemovePlayerAttachedObject(playerid,pObj[playerid][Rod]);
			return 1;
		}
	}
	if(!strcmp(opt,"screwdriver",false)) {
		if(!pInventory[playerid][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: You don't have a screwdriver");
		if(pToolEquip[playerid][Equip] && !pToolEquip[playerid][Screwdriver]) return SendClientMessage(playerid, -1, "ERROR: You already equiping another tool");
		if(!pToolEquip[playerid][Screwdriver]) {
			pToolEquip[playerid][Screwdriver] = true;
			pToolEquip[playerid][Equip] = true;
			SendClientMessage(playerid, -1, "You have equiped a screwdriver");
			pObj[playerid][Screwdriver] = SetPlayerAttachedObject(playerid, OBJECT_INDEX_SCREW,18644,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
			return 1;
		}
		else if(pToolEquip[playerid][Screwdriver]) {
			pToolEquip[playerid][Screwdriver] = false;
			pToolEquip[playerid][Equip] = false;
			SendClientMessage(playerid, -1, "You have unequiped screwdriver");
			RemovePlayerAttachedObject(playerid, OBJECT_INDEX_SCREW);
			RemovePlayerAttachedObject(playerid,pObj[playerid][Screwdriver]);
			return 1;
		}
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid option");
}

CMD:fish(playerid, params[])
{
	if(!pToolEquip[playerid][Rod]) return SendClientMessage(playerid, -1, "ERROR: You're not equiping fishing rod");
	if(!IsPlayerInRangeOfPoint(playerid,50.0,383.3073,-2080.4578,7.8359)) return SendClientMessage(playerid, -1, "ERROR: You're not at fishing area");
	if(pState[playerid][Fishing]) return SendClientMessage(playerid, -1, "ERROR: You already fishing");
	if(pInventory[playerid][Bait] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have any baits");
	if(pInventory[playerid][Fish][Count] == 5) return SendClientMessage(playerid, -1, "ERROR: You can only carry 5 fishes");
	TogglePlayerControllable(playerid,0);
	ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1,1);
	SetTimerEx("FishingTimer", 30000, 0, "i", playerid);
	pInventory[playerid][Bait] -= 1;
	pInventory[playerid][ToolDurability][Rod] -= 1;
	pState[playerid][Fishing] = true;
	SendClientMessage(playerid, -1, "You have cast a line");
	return 1;
}

CMD:tools(playerid, params[])
{
	new str[2][280];
	strcat(str[0],"Tool\tDurability\n");
	strcat(str[0],"Fishing Rod\t%d\n");
	strcat(str[0],"Screwdriver\t%d\n");

	format(str[1],280,str[0],pInventory[playerid][ToolDurability][Rod],pInventory[playerid][ToolDurability][Screwdriver]);
	ShowPlayerDialog(playerid,DIALOG_TOOL,DIALOG_STYLE_TABLIST_HEADERS,"My Tools",str[1],"Close","");
	return 1;
}

CMD:jetpack(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	return 1;
}

CMD:rconweapon(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	GivePlayerWeapon(playerid, WEAPON_MP5, 120);
	GivePlayerWeapon(playerid, WEAPON_M4, 120);
	return 1;
}

CMD:id(playerid, params[])
{
	new key[80];
	new fmt_d[200];
	new bool:found[MAX_PLAYERS];
	new bool:foundid;
	if(sscanf(params, "s[80]", key)) return SendClientMessage(playerid, -1, "Usage: /id [part-of-name]");
	if(strlen(key) < 3) return SendClientMessage(playerid, -1, "ERROR: Minimum keyword is 3 letters");
	foreach(new i : Player) {
		if(!strfind(RetPname(i),key,true)) {
			foundid = true;
			found[i] = true;
		}
	}
	if(!foundid) return SendClientMessage(playerid, -1, "ERROR: No players found with that keyword");
	for(new i; i < MAX_PLAYERS; i++) {
		if(found[i]) format(fmt_d,sizeof(fmt_d),"%s%s(%d)\n",fmt_d,RetPname(i),i);
	}
	ShowPlayerDialog(playerid,DIALOG_SEARCHID,DIALOG_STYLE_LIST,"Found Players",fmt_d, "Close", "");
	return 1;
}

CMD:fixveh(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	RepairVehicle(GetPlayerVehicleID(playerid));
	return 1;
}

CMD:ccc(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(!CountdownC) return SendClientMessage(playerid, -1, "No countdown created");
		CountdownC = false;
		CountdownCount = 0;
		TextDrawHideForAll(GlobalTextdraw[Countdown]);
		SendClientMessage(playerid, -1, "Countdown Canceled");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:countdown(playerid, params[])
{
	new sec;
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(CountdownC) return SendClientMessage(playerid, -1, "Wait for current countdown to end");
		if(sscanf(params, "i", sec)) return SendClientMessage(playerid, -1, "Usage: /countdown [interval(second)]");
		if(sec < 3) return SendClientMessage(playerid, -1, "ERROR: Interval can't be lower than 3");
		CountdownC = true;
		CountdownCount = sec + 1;
		TextDrawShowForAll(GlobalTextdraw[Countdown]);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:tradeveh(playerid, params[])
{
	new id,msg[128];
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "Usage: /tradeveh [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(!IsPlayerInRangeOfPlayer(playerid,id,2.0)) return SendClientMessage(playerid, -1, "ERROR: that player is not near by you");
	if(id == playerid) return SendClientMessage(playerid, -1, "ERROR: Invalid id");
	if(pVehSell[playerid][Offering] > -1) return SendClientMessage(playerid, -1, "ERROR: You're already offering a player");
	if(pVehicle[playerid][Model] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have a vehicle");
	if(pVehicle[playerid][Model] == 420 || pVehicle[playerid][Model] == 438) return SendClientMessage(playerid, -1, "ERROR: You can't trade your vehicle");
	if(!IsPlayerInRangeOfVehicle(playerid,pVehicle[playerid][ID],10.0)) return SendClientMessage(playerid,-1,"ERROR: Your vehicle is not near by you");
	pVehSell[playerid][Offering] = id;
	pVehSell[id][OfferedBy] = playerid;
	format(msg,sizeof(msg),
		"{FFFFFF}Player ID %d offering to trade their vehicle with You, Would You accept their offer?",playerid);
	ShowPlayerDialog(id,DIALOG_TRADEVEH,DIALOG_STYLE_MSGBOX,"Trade Vehicle",msg,"Accept","Deny");
	SendClientMessage(playerid,	-1, "You have offered your vehicle to that player, wait for their response...");
	return 1;
}

CMD:sellveh(playerid, params[])
{
	new id,price,msg[128];
	if(sscanf(params, "ii", id, price)) return SendClientMessage(playerid, -1, "Usage: /sellveh [playerid] [price]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(!IsPlayerInRangeOfPlayer(playerid,id,2.0)) return SendClientMessage(playerid, -1, "ERROR: that player is not near by you");
	if(id == playerid) return SendClientMessage(playerid, -1, "ERROR: Invalid id");
	if(price <= 0) return SendClientMessage(playerid, -1, "ERROR: Invalid price");
	if(pVehSell[playerid][Offering] > -1) return SendClientMessage(playerid, -1, "ERROR: You're already offering a player");
	if(pVehicle[playerid][Model] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have a vehicle");
	if(pVehicle[playerid][Model] == 420 || pVehicle[playerid][Model] == 438) return SendClientMessage(playerid, -1, "ERROR: You can't trade your vehicle");
	if(!IsPlayerInRangeOfVehicle(playerid,pVehicle[playerid][ID],10.0)) return SendClientMessage(playerid,-1,"ERROR: Your vehicle is not near by you");
	pVehSell[playerid][Offering] = id;
	pVehSell[id][OfferedBy] = playerid;
	pVehSell[id][Price] = price;
	format(msg,sizeof(msg),
		"{FFFFFF}Player ID %d offering to sell their vehicle for $%s to You, Would You accept their offer?",playerid,MoneyFormat(price));
	ShowPlayerDialog(id,DIALOG_SELLVEH,DIALOG_STYLE_MSGBOX,"Sell Vehicle",msg,"Accept","Deny");
	SendClientMessage(playerid,	-1, "You have offered your vehicle to that player, wait for their response...");
	return 1;
}

CMD:loadtruck(playerid, params[])
{
	new bool:ispv;
	if(!pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You're not a trucker");
	if(IsLoadingTruck[playerid]) return SendClientMessage(playerid, -1, "ERROR: This truck is being loaded, please wait...");
	if(!IsVehicleInRangeOfPoint(GetPlayerVehicleID(playerid),5.0,-14.6017,-270.7789,5.4297)) return SendClientMessage(playerid, -1, "ERROR: You're not at loading bay");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in any vehicle");
	new vehicleid = GetPlayerVehicleID(playerid);
 	foreach(new i : Player) {
		if(GetPlayerVehicleID(playerid) == pVehicle[i][ID]) {
			ispv = true;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1, "ERROR: Only player vehicle can be used for trucking");
	if(!IsTruck(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, -1, "ERROR: This vehicle is not truck");
	if(GetPlayerVehicleID(playerid) != pVehicle[playerid][ID]) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this vehicle");
	if(sTruck[GetPlayerVehicleID(playerid)][Loaded]) return SendClientMessage(playerid, -1, "ERROR: This truck already loaded");
	if(GetPlayerMoney(playerid) < 20) return SendClientMessage(playerid, -1, "ERROR: You need $20 to load your truck");
	GivePlayerMoney(playerid, -20);
	TogglePlayerControllable(playerid, 0);
	IsLoadingTruck[playerid] = true;
	SetTimerEx("LoadTruck", 20000, 0, "ii", playerid, vehicleid);
	GameTextForPlayer(playerid, "Loading Truck...", 20000, 5);
	SetCameraBehindPlayer(playerid);
	SendClientMessage(playerid, -1, "Your truck is being loaded, please wait...");
	return 1;
}

CMD:refuel(playerid, params[])
{
	new bool:ispv;
	new bool:found;
	new engine, lights, alarm, doors, bonnet, boot, objective;
	if(IsRefueling[playerid]) return SendClientMessage(playerid, -1, "ERROR: You are already refueling, please wait...");
	for(new i; i < sizeof(GasStation); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, GasStation[i][0], GasStation[i][1], GasStation[i][2])) {
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not at any gas station");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in any vehicle");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "ERROR: You must be the driver of the vehicle");
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	if(engine == 1) return SendClientMessage(playerid, -1, "ERROR: Turn off the engine to refuel");
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVehicleID(playerid) == pVehicle[i][ID]) {
			ispv = true;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1, "ERROR: Only player vehicle can be refueled");
	if(g_Fuel[GetPlayerVehicleID(playerid)] == 100.0) return SendClientMessage(playerid, -1, "ERROR: Fuel is full");
	if(GetPlayerMoney(playerid) < 15) return SendClientMessage(playerid, -1, "ERROR: you need $15 to refuel your vehicle");
	GivePlayerMoney(playerid, -15);
	IsRefueling[playerid] = true;
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("RefuelTime", 10000, 0, "i", playerid);
	GameTextForPlayer(playerid, "Refueling...", 10000, 5);
	SetCameraBehindPlayer(playerid);
	SendClientMessage(playerid, -1, "Now Refueling...");
	return 1;
}

CMD:mrefuel(playerid, params[])
{
	new
		id;
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "Usage: /mrefuel [vehicleid]");
	new bool:ispv;
	foreach(new i : Player) {
		if(id == pVehicle[i][ID]) {
			ispv = true;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1,"ERROR: Only player vehicle can be refilled");
	if(!IsPlayerInRangeOfVehicle(playerid, id, 5.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that vehicle");
	if(pInventory[playerid][Component] < 5) return SendClientMessage(playerid, -1, "ERROR: You need 5 components to refuel oil");
	if(g_Fuel[id] == 100.0) return SendClientMessage(playerid, -1, "ERROR: Fuel is full");
	g_Fuel[id] = 100.0;
	pInventory[playerid][Component] -= 5;
	SendClientMessage(playerid, -1, "Vehicle Refilled");
	return 1;
}

CMD:refilloil(playerid, params[])
{
	new
		id;
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "Usage: /refilloil [vehicleid]");
	new bool:ispv;
	foreach(new i : Player) {
		if(id == pVehicle[i][ID]) {
			ispv = true;
			id = i;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1,"ERROR: Only player vehicle can be refilled");
	if(!IsPlayerInRangeOfVehicle(playerid, pVehicle[id][ID], 5.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that vehicle");
	if(pInventory[playerid][Component] < 8) return SendClientMessage(playerid, -1, "ERROR: You need 8 components to refill oil");
	if(pVehicle[id][Oil] == 100.0) return SendClientMessage(playerid, -1, "ERROR: Oil is full");
	pVehicle[id][Oil] = 100.0;
	pInventory[playerid][Component] -= 8;
	SendClientMessage(playerid, -1, "Oil Refilled");
	return 1;
}

CMD:repaircomp(playerid, params[])
{
	new
		opt[80],
		id;
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(sscanf(params, "p< >is[80]", id, opt)) return SendClientMessage(playerid, -1, "Usage: /repaircomp [vehicleid] [component]");
	new bool:ispv;
	foreach(new i : Player) {
		if(id == pVehicle[i][ID]) {
			ispv = true;
			id = i;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1,"ERROR: Only player vehicle can be repaired");
	if(!IsPlayerInRangeOfVehicle(playerid, pVehicle[id][ID], 5.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that vehicle");
	if(!strcmp(opt,"radiator",false)) {
		if(pInventory[playerid][Component] < 10) return SendClientMessage(playerid, -1, "ERROR: 10 components needed to repair this component");
		if(pVehicle[id][RadiatorHealth] == 100.0) return SendClientMessage(playerid, -1, "ERROR: Component is not broken");
		pInventory[playerid][Component] -= 10;
		pVehicle[id][RadiatorHealth] = 100.0;
		SendClientMessageEx(playerid, -1, "Component has been repaired");
		return 1;
	}
	if(!strcmp(opt,"battery",false)) {
		if(pInventory[playerid][Component] < 10) return SendClientMessage(playerid, -1, "ERROR: 10 components needed to repair this component");
		if(pVehicle[id][Battery] == 100.0) return SendClientMessage(playerid, -1, "ERROR: Component is not broken");
		pInventory[playerid][Component] -= 10;
		pVehicle[id][Battery] = 100.0;
		SendClientMessageEx(playerid, -1, "Component has been repaired");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Component name");
}

CMD:upgrade(playerid, params[])
{
	new
		opt[80],
		id;
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(sscanf(params, "p< >is[80]", id, opt)) return SendClientMessage(playerid, -1, "Usage: /upgrade [vehicleid] [component]");
	new bool:ispv;
	foreach(new i : Player) {
		if(id == pVehicle[i][ID]) {
			ispv = true;
			id = i;
			break;
		}
	}
	if(!ispv) return SendClientMessage(playerid, -1,"ERROR: Only player vehicle can be upgraded");
	if(!IsPlayerInRangeOfVehicle(playerid, pVehicle[id][ID], 5.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that vehicle");
	if(!strcmp(opt,"radiator",false)) {
		if(pInventory[playerid][Component] < 50) return SendClientMessage(playerid, -1, "ERROR: 50 components needed for every component upgrade");
		if(pVehicle[id][Radiator] == 5) return SendClientMessage(playerid, -1, "ERROR: Component has reached max level");
		pInventory[playerid][Component] -= 50;
		pVehicle[id][Radiator] += 1;
		SendClientMessageEx(playerid, -1, "Component has been upgraded to level %d", pVehicle[id][Radiator]);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Component name");
}

CMD:checkengine(playerid, params[])
{
	new bool:found,id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close by any player vehicle");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!bonnet) return SendClientMessage(playerid, -1, "ERROR: Hood is closed");
	new str[200];
	strcat(str,"Radiator Lv%d\t%%%.1f\n");
	strcat(str,"Oil\t%%%.1f\n");
	strcat(str,"Battery\t%%%.1f\n");
	new str_f[200];
	format(str_f,sizeof(str_f),str,pVehicle[id][Radiator],pVehicle[id][RadiatorHealth],pVehicle[id][Oil],pVehicle[id][Battery]);
	ShowPlayerDialog(playerid, DIALOG_CHECKENG, DIALOG_STYLE_TABLIST, "Vehicle Engine", str_f, "Close", "");
	return 1;
}

CMD:normheat(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	NormalizeHeat(playerid);
	return 1;
}

CMD:pickupmoney(playerid, params[])
{
	new
		bool:found,
		id;
	for(new i = 0; i < MAX_MONEY_DROP; i++)
	{
		if(!sMoneyDrop[i][Drop]) {
			continue;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.0, sMoneyDrop[i][dropmoneypos][0], sMoneyDrop[i][dropmoneypos][1], sMoneyDrop[i][dropmoneypos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == sMoneyDrop[i][vworld])
			{
				found = true;
				id = i;
			}
		}
	}
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the dropped money");
	DestroyDynamic3DTextLabel(sMoneyDrop[id][dropmoneylabel]);
	DestroyDynamicPickup(sMoneyDrop[id][dropmoneyobj]);
	GivePlayerMoney(playerid, sMoneyDrop[id][droppedmoney]);
	sMoneyDrop[id][Drop] = false;
	ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
	SendClientMessageEx(playerid, -1, "You've found {008000}$%s",MoneyFormat(sMoneyDrop[id][droppedmoney]));
	return 1;
}

CMD:dropmoney(playerid, params[])
{
	new
		msg[80],
		id,
		money;
	new
		Float:pos[3];
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(sscanf(params, "i", money)) return SendClientMessage(playerid, -1, "Usage: /dropmoney [money]");
	if(money <= 0) return SendClientMessage(playerid, -1, "ERROR: Invalid amount");
	if(GetPlayerMoney(playerid) < money) return SendClientMessage(playerid, -1, "ERROR: Not enough money specified");
	for(new i; i < MAX_MONEY_DROP; i++)
	{
		if(!sMoneyDrop[i][Drop]) {
			id = i;
			break;
		}
	}
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	format(msg,sizeof(msg),"$%s", MoneyFormat(money));
	sMoneyDrop[id][dropmoneylabel] = CreateDynamic3DTextLabel(
		msg,
		0xAAAAAAAA,
		pos[0],
		pos[1],
		pos[2] - 1.0,
		1.0,
		.testlos=1,
		.worldid=GetPlayerVirtualWorld(playerid),
		.interiorid=GetPlayerInterior(playerid)
	);
	sMoneyDrop[id][dropmoneyobj] = CreateDynamicPickup(
		1212,
		0,
		pos[0],
		pos[1],
		pos[2] - 1.0,
		GetPlayerVirtualWorld(playerid),
		GetPlayerInterior(playerid)
	);
	sMoneyDrop[id][Drop] = true;
	sMoneyDrop[id][droppedmoney] = money;
	sMoneyDrop[id][intid] = GetPlayerInterior(playerid);
	sMoneyDrop[id][vworld] = GetPlayerVirtualWorld(playerid);
	for(new i; i < 3; i++)
	{
		sMoneyDrop[id][dropmoneypos][i] = pos[i];
	}
	GivePlayerMoney(playerid, -money);
	ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
	SendClientMessageEx(playerid, -1, "You've dropped {008000}$%s",MoneyFormat(money));
	return 1;
}

CMD:discardlicense(playerid, params[])
{
	if(!pInventory[playerid][License]) return SendClientMessage(playerid, -1, "ERROR: You don't have a driving license");
	DeleteLicense(playerid);
	SendClientMessage(playerid, -1, "You have discarded your license");
	return 1;
}

CMD:mylicenses(playerid, params[])
{
	if(!pInventory[playerid][License]) return SendClientMessage(playerid, -1, "ERROR: You don't have a driving license");
	ShowLicense(playerid,playerid);
	return 1;
}

CMD:showlicenses(playerid, params[])
{
	new id;
	if(!pInventory[playerid][License]) return SendClientMessage(playerid, -1, "ERROR: You don't have a driving license");
	if(sscanf(params,"i",id)) return SendClientMessage(playerid, -1, "Usage: /showlicenses [playerid]");
	if(id == playerid) return SendClientMessage(playerid, -1,"ERROR: Invalid id");
	if(!IsPlayerInRangeOfPlayer(playerid,id,2.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that player");
	ShowLicense(playerid,id);
	SendClientMessage(playerid,-1,"You have shown your licenses to that player...");
	return 1;
}

CMD:getlicense(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 1.5, 1490.2838,1305.7026,1093.2964)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from driving license point");
	if(pInventory[playerid][License]) return SendClientMessage(playerid, -1, "ERROR: You already have a driving license");
	if(GetPlayerMoney(playerid) < 100) return SendClientMessage(playerid, -1, "ERROR: Not enough money to pay entry fee");
	if(sLicense[OnTest] && sLicense[TestID] != playerid) return SendClientMessage(playerid, -1, "ERROR: Someone is taking a test wait for them to complete the test");
	if(pMission[playerid][License] && sLicense[TestID] == playerid) return SendClientMessage(playerid, -1, "ERROR: You already taking the test");
	GivePlayerMoney(playerid, -100);
	sLicense[OnTest] = true;
	sLicense[TestID] = playerid;
	pMission[playerid][License] = true;
	SendClientMessage(playerid, -1, "Get outside to do the test");
	return 1;
}

CMD:getveh(playerid, params[])
{
	new id;
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "Usage: /getveh [playerid]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
		if(GetPlayerInterior(id) > 0 || GetPlayerVirtualWorld(id) > 0) return SendClientMessage(playerid, -1, "ERROR: That player is in interior");
		new Float:p[4];
		GetPlayerPos(id, p[0], p[1], p[2]);
		GetPlayerFacingAngle(id, p[3]);
		SetVehiclePos(pVehicle[id][ID], p[0], p[1], p[2]);
		SetVehicleZAngle(pVehicle[id][ID], p[3]);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:accs(playerid, params[])
{
	new str[280];
	for(new i; i < MAX_ACCS; i++)
	{
		if(strlen((pAccs[playerid][i][Name])) > 0) {
			printf("[DEBUG][ACCS][LOAD]: Accs Slot %d Has A String Data.",i);
			format(str,sizeof(str),"%s%d).%s\n", str, i+1, pAccs[playerid][i][Name]);
		}
		else {
			printf("[DEBUG][ACCS][LOAD]: Accs Slot %d Does Not Have a Data",i);
			format(str,sizeof(str),"%s%d).Empty\n", str, i+1);
		}
	}
	ShowPlayerDialog(playerid,DIALOG_ACCS_INDEX,DIALOG_STYLE_LIST,"Select Accessories Slot",str,"Select","Close");
	return 1;
}

CMD:deleteveh(playerid, params[])
{
	if(IsPlayerInRangeOfVehicle(playerid, pVehicle[playerid][ID],5.0) && IsPlayerInRangeOfPoint(playerid,5.0,-1880.4781,-1681.4792,21.7500)) {
		if(!IsPlayerInVehicle(playerid, pVehicle[playerid][ID])) return SendClientMessage(playerid,-1,"ERROR: You're not in your vehicle");
		DestroyVehicle(pVehicle[playerid][ID]);
		DeleteVehicle(playerid);
		SaveVehicle(playerid);
		pInventory[playerid][Material] += 5;
		pInventory[playerid][Component] += 20;
		SendClientMessage(playerid, -1, "Your vehicle has been deleted and you got 5 materials and 20 components");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Your vehicle is not on vehicle delete point");
}

CMD:takeitems(playerid, params[])
{
	new
		opt[120],
		amount;
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(sscanf(params, "p< >s[120]i", opt, amount)) return SendClientMessage(playerid, -1, "Usage: /putitems [item] [amount]");

	if(!strcmp(opt,"material",false)) {
		if(pVehicle[id][vStorage][Material] < amount) return SendClientMessage(playerid, -1, "ERROR: Not enough amount specified");
		if(pInventory[playerid][Material] >= 100) return SendClientMessage(playerid, -1, "ERROR: You can't put more of this item into the vehicle trunk");
		pInventory[playerid][Material] += amount;
		pVehicle[id][vStorage][Material] -= amount;
		SendClientMessage(playerid,-1,"You have taken the items into the vehicle trunk");
		return 1;
	}
	if(!strcmp(opt,"gunpart",false)) {
		if(pVehicle[id][vStorage][GunPart] < amount) return SendClientMessage(playerid, -1, "ERROR: Not enough amount specified");
		if(pInventory[playerid][GunPart] >= 50) return SendClientMessage(playerid, -1, "ERROR: You can't put more of this item into the vehicle trunk");
		pInventory[playerid][GunPart] += amount;
		pVehicle[id][vStorage][GunPart] -= amount;
		SendClientMessage(playerid,-1,"You have taken the items into the vehicle trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid item name");
}

CMD:putitems(playerid, params[])
{
	new
		opt[120],
		amount;
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(sscanf(params, "p< >s[120]i", opt, amount)) return SendClientMessage(playerid, -1, "Usage: /putitems [item] [amount]");

	if(!strcmp(opt,"material",false)) {
		if(pInventory[playerid][Material] < amount) return SendClientMessage(playerid, -1, "ERROR: Not enough amount specified");
		if(pVehicle[id][vStorage][Material] >= 1000) return SendClientMessage(playerid, -1, "ERROR: You can't put more of this item into the vehicle trunk");
		pInventory[playerid][Material] -= amount;
		pVehicle[id][vStorage][Material] += amount;
		SendClientMessage(playerid,-1,"You have put the items into the vehicle trunk");
		return 1;
	}
	if(!strcmp(opt,"gunpart",false)) {
		if(pInventory[playerid][GunPart] < amount) return SendClientMessage(playerid, -1, "ERROR: Not enough amount specified");
		if(pVehicle[id][vStorage][GunPart] >= 1000) return SendClientMessage(playerid, -1, "ERROR: You can't put more of this item into the vehicle trunk");
		pInventory[playerid][GunPart] -= amount;
		pVehicle[id][vStorage][GunPart] += amount;
		SendClientMessage(playerid,-1,"You have put the items into the vehicle trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid item name");
}

CMD:takeammo(playerid, params[])
{
	new
		opt[120],
		ammo;
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(sscanf(params, "p< >s[120]i", opt, ammo)) return SendClientMessage(playerid, -1, "Usage: /takeammo [weapon] [ammo]");

	if(!strcmp(opt,"colt45",false)) {
		if(pVehicle[id][vAmmo][COLT] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo specified");
		if(pWeapon[playerid][ColtAmmo] >= 300) return SendClientMessage(playerid,-1,"ERROR: You can't take more ammo of this weapon");
		pWeapon[playerid][ColtAmmo] += ammo;
		pVehicle[id][vAmmo][COLT] -= ammo;
		SendClientMessage(playerid,-1, "You have taken the ammo from the trunk");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(pVehicle[id][vAmmo][DEAGLE] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo specified");
		if(pWeapon[playerid][DeagleAmmo] >= 300) return SendClientMessage(playerid,-1,"ERROR: You can't take more ammo of this weapon");
		pWeapon[playerid][DeagleAmmo] += ammo;
		pVehicle[id][vAmmo][DEAGLE] -= ammo;
		SendClientMessage(playerid,-1, "You have taken the ammo from the trunk");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(pVehicle[id][vAmmo][SHOTGUN] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo specified");
		if(pWeapon[playerid][ShotgunAmmo] >= 120) return SendClientMessage(playerid,-1,"ERROR: You can't take more ammo of this weapon");
		pWeapon[playerid][ShotgunAmmo] += ammo;
		pVehicle[id][vAmmo][SHOTGUN] -= ammo;
		SendClientMessage(playerid,-1, "You have taken the ammo from the trunk");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(pVehicle[id][vAmmo][RIFLE] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo specified");
		if(pWeapon[playerid][RifleAmmo] >= 120) return SendClientMessage(playerid,-1,"ERROR: You can't take more ammo of this weapon");
		pWeapon[playerid][RifleAmmo] += ammo;
		pVehicle[id][vAmmo][RIFLE] -= ammo;
		SendClientMessage(playerid,-1, "You have taken the ammo from the trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");	
}


CMD:putammo(playerid, params[])
{
	new
		opt[120],
		ammo;
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(sscanf(params, "p< >s[120]i", opt, ammo)) return SendClientMessage(playerid, -1, "Usage: /putammo [weapon] [ammo]");

	if(!strcmp(opt,"colt45",false)) {
		if(pWeapon[playerid][ColtAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You have not enough ammo");
		if(pVehicle[id][vAmmo][COLT] >= 500) return SendClientMessage(playerid, -1, "ERROR: You can't put more ammo of this weapon into the trunk");
		pVehicle[id][vAmmo][COLT] += ammo;
		pWeapon[playerid][ColtAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have put the ammo into the vehicle trunk");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(pWeapon[playerid][DeagleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You have not enough ammo");
		if(pVehicle[id][vAmmo][DEAGLE] >= 500) return SendClientMessage(playerid, -1, "ERROR: You can't put more ammo of this weapon into the trunk");
		pVehicle[id][vAmmo][DEAGLE] += ammo;
		pWeapon[playerid][DeagleAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have put the ammo into the vehicle trunk");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(pWeapon[playerid][ShotgunAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You have not enough ammo");
		if(pVehicle[id][vAmmo][SHOTGUN] >= 500) return SendClientMessage(playerid, -1, "ERROR: You can't put more ammo of this weapon into the trunk");
		pVehicle[id][vAmmo][SHOTGUN] += ammo;
		pWeapon[playerid][ShotgunAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have put the ammo into the vehicle trunk");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(pWeapon[playerid][RifleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You have not enough ammo");
		if(pVehicle[id][vAmmo][RIFLE] >= 500) return SendClientMessage(playerid, -1, "ERROR: You can't put more ammo of this weapon into the trunk");
		pVehicle[id][vAmmo][RIFLE] += ammo;
		pWeapon[playerid][RifleAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have put the ammo into the vehicle trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");	
}

CMD:takeweapon(playerid, params[])
{
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(isnull(params)) return SendClientMessage(playerid, -1 ,"Usage: /takeweapon [weapon]");

	if(!strcmp(params,"colt45",false)) {
		if(pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		if(!pVehicle[id][vWeapon][COLT]) return SendClientMessage(playerid, -1, "ERROR: that weapon is not in the trunk");

		pWeapon[playerid][Colt] = true;
		pWeapon[playerid][ColtDurability] = pVehicle[id][vWeapon][COLT_D];
		
		pVehicle[id][vWeapon][COLT] = false;
		pVehicle[id][vWeapon][COLT_D] = 0.0;

		SendClientMessage(playerid, -1, "You have taken that weapon from the trunk");
		return 1;
	}
	if(!strcmp(params,"deagle",false)) {
		if(pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		if(!pVehicle[id][vWeapon][COLT]) return SendClientMessage(playerid, -1, "ERROR: that weapon is not in the trunk");

		pWeapon[playerid][Deagle] = true;
		pWeapon[playerid][DeagleDurability] = pVehicle[id][vWeapon][DEAGLE_D];
		
		pVehicle[id][vWeapon][DEAGLE] = false;
		pVehicle[id][vWeapon][DEAGLE_D] = 0.0;

		SendClientMessage(playerid, -1, "You have taken that weapon from the trunk");
		return 1;
	}
	if(!strcmp(params,"shotgun",false)) {
		if(pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		if(!pVehicle[id][vWeapon][SHOTGUN]) return SendClientMessage(playerid, -1, "ERROR: that weapon is not in the trunk");

		pWeapon[playerid][Shotgun] = true;
		pWeapon[playerid][ShotgunDurability] = pVehicle[id][vWeapon][RIFLE_D];
		
		pVehicle[id][vWeapon][SHOTGUN] = false;
		pVehicle[id][vWeapon][SHOTGUN_D] = 0.0;

		SendClientMessage(playerid, -1, "You have taken that weapon from the trunk");
		return 1;
	}
	if(!strcmp(params,"rifle",false)) {
		if(pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		if(!pVehicle[id][vWeapon][RIFLE]) return SendClientMessage(playerid, -1, "ERROR: that weapon is not in the trunk");

		pWeapon[playerid][Rifle] = true;
		pWeapon[playerid][RifleDurability] = pVehicle[id][vWeapon][RIFLE_D];
		
		pVehicle[id][vWeapon][RIFLE] = false;
		pVehicle[id][vWeapon][RIFLE_D] = 0.0;

		SendClientMessage(playerid, -1, "You have taken that weapon from the trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
}

CMD:putweapon(playerid, params[])
{
	new 
		bool:found,
		id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	if(isnull(params)) return SendClientMessage(playerid, -1 ,"Usage: /putweapon [weapon]");

	if(!strcmp(params,"colt45",false)) {
		if(!pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		if(pVehicle[id][vWeapon][COLT]) return SendClientMessage(playerid, -1, "ERROR: there's already that weapon in this vehicle trunk");
		
		pVehicle[id][vWeapon][COLT] = true;
		pVehicle[id][vWeapon][COLT_D] = pWeapon[playerid][ColtDurability];

		pWeapon[playerid][Colt] = false;
		pWeapon[playerid][ColtDurability] = 0.0;
		SendClientMessage(playerid, -1, "You have put that weapon inside the trunk");
		return 1;
	}
	if(!strcmp(params,"deagle",false)) {
		if(!pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		if(pVehicle[id][vWeapon][DEAGLE]) return SendClientMessage(playerid, -1, "ERROR: there's already that weapon in this vehicle trunk");
		
		pVehicle[id][vWeapon][DEAGLE] = true;
		pVehicle[id][vWeapon][DEAGLE_D] = pWeapon[playerid][DeagleDurability];

		pWeapon[playerid][Deagle] = false;
		pWeapon[playerid][DeagleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You have put that weapon inside the trunk");
		return 1;
	}
	if(!strcmp(params,"shotgun",false)) {
		if(!pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		if(pVehicle[id][vWeapon][SHOTGUN]) return SendClientMessage(playerid, -1, "ERROR: there's already that weapon in this vehicle trunk");
		
		pVehicle[id][vWeapon][SHOTGUN] = true;
		pVehicle[id][vWeapon][SHOTGUN_D] = pWeapon[playerid][ShotgunDurability];

		pWeapon[playerid][Shotgun] = false;
		pWeapon[playerid][ShotgunDurability] = 0.0;
		SendClientMessage(playerid, -1, "You have put that weapon inside the trunk");
		return 1;
	}
	if(!strcmp(params,"rifle",false)) {
		if(!pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		if(pVehicle[id][vWeapon][RIFLE]) return SendClientMessage(playerid, -1, "ERROR: there's already that weapon in this vehicle trunk");
		
		pVehicle[id][vWeapon][RIFLE] = true;
		pVehicle[id][vWeapon][RIFLE_D] = pWeapon[playerid][RifleDurability];

		pWeapon[playerid][Rifle] = false;
		pWeapon[playerid][RifleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You have put that weapon inside the trunk");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
}

CMD:parkv(playerid, params[])
{
	if(!IsPlayerInVehicle(playerid, pVehicle[playerid][ID])) return SendClientMessage(playerid, -1, "ERROR: You're not in your vehicle");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "ERROR: You must be the driver of the vehicle");
	ParkVehicle(playerid);
	UpdateVehicleData(playerid);
	SaveVehicle(playerid);
	SendClientMessage(playerid, -1, "Your vehicle has been parked on this position");
	return 1;
}

CMD:vstorage(playerid, params[])
{
	new bool:found,id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	SendClientMessage(playerid, -1, "============================");
	SendClientMessageEx(playerid, -1, "Materials: {FF0000}%d", pVehicle[id][vStorage][Material]);
	SendClientMessageEx(playerid, -1, "Gun Parts: {FF0000}%d", pVehicle[id][vStorage][GunPart]);
	SendClientMessage(playerid, -1, "============================");
	return 1;
}

CMD:vweapon(playerid, params[])
{
	new bool:found,id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(!boot) return SendClientMessage(playerid, -1, "ERROR: Trunk is closed");
	new str_weap[1200];
	strcat(str_weap,"Name\tDurability\tAmmo\n");
	strcat(str_weap,"Colt45\t%.1f\t%d\n");
	strcat(str_weap,"Deagle\t%.1f\t%d\n");
	strcat(str_weap,"Shotgun\t%.1f\t%d\n");
	strcat(str_weap,"Rifle\t%.1f\t%d\n");

	new str_wfor[4000];
	format(str_wfor,sizeof(str_wfor),str_weap,
		/*Silenced*/
		pVehicle[id][vWeapon][COLT_D],
		pVehicle[id][vAmmo][COLT],
		/*Deagle*/
		pVehicle[playerid][vWeapon][DEAGLE_D],
		pVehicle[playerid][vAmmo][DEAGLE],
		/*Shotgun*/
		pVehicle[playerid][vWeapon][SHOTGUN_D],
		pVehicle[playerid][vAmmo][SHOTGUN],
		/*Rifle*/
		pVehicle[playerid][vWeapon][RIFLE_D],
		pVehicle[playerid][vAmmo][RIFLE]);
	ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_TABLIST_HEADERS,"Trunk Weapons",str_wfor,"Close","");
	return 1;
}

CMD:hood(playerid, params[])
{
	new bool:found,id;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
		if(bonnet) {
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 0, boot, objective);
			return 1;
		}
		else if(bonnet == 0 || bonnet == VEHICLE_PARAMS_UNSET) {
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 1, boot, objective);
			return 1;
		}
	}
	else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		if(!found) return SendClientMessage(playerid, -1, "ERROR: No player vehicle found nearby");
		GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
		if(bonnet) {
			SetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, 0, boot, objective);
			return 1;
		}
		else if(bonnet == 0 || bonnet == VEHICLE_PARAMS_UNSET) {
			SetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, 1, boot, objective);
			return 1;
		}
	}
	return 1;
}

CMD:lights(playerid, params[])
{
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in vehicle");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "ERROR: You must be the driver");
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	if(lights) {
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 0, alarm, doors, bonnet, boot, objective);
		return 1;
	}
	else if(lights == 0 || lights == VEHICLE_PARAMS_UNSET) {
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective);
		return 1;
	}
	return 1;
}

CMD:trunk(playerid, params[])
{
	new bool:found,id;
	new
		engine,lights,alarm,doors,bonnet,boot,objective;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfVehicle(playerid, pVehicle[i][ID],5.0)) {
			id = i;
			found = true;
			break;
		}
	}
	if(pVehicle[id][Lock]) return SendClientMessage(playerid, -1, "ERROR: Vehicle is locked");
	if(id != playerid) return SendClientMessage(playerid, -1, "ERROR: You don't have the vehicle key to manage this vehicle");
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	GetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, boot, objective);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		if(!found) return SendClientMessage(playerid, -1, "ERROR: you're not close enough by any vehicle");
		if(boot) {
			SetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, 0, objective);
			return 1;
		}
		else if(boot == 0 || boot == VEHICLE_PARAMS_UNSET) {
			SetVehicleParamsEx(pVehicle[id][ID], engine, lights, alarm, doors, bonnet, 1, objective);
			return 1;
		}
	}
	else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		if(boot) {
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 0, objective);
			return 1;
		}
		else if(boot == 0 || boot == VEHICLE_PARAMS_UNSET) {
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 1, objective);
			return 1;
		}
	}
	return 1;
}

CMD:lockv(playerid, params[])
{
	if(!IsPlayerInRangeOfVehicle(playerid, pVehicle[playerid][ID],5.0)) return SendClientMessage(playerid, -1, "ERROR: You're no close enough from your vehicle");
	if(pVehicle[playerid][Lock]) {
		pVehicle[playerid][Lock] = false;
		GameTextForPlayer(playerid, "~g~Unlocked", 1000, 5);
		return 1;
	}
	else if(!pVehicle[playerid][Lock]) {
		pVehicle[playerid][Lock] = true;
		GameTextForPlayer(playerid, "~r~Locked", 1000, 5);
		return 1;
	}
	return 1;
}

CMD:buyveh(playerid, params[])
{
	new larstr[200];
	new f[200];
	format(f,sizeof(f),PLAYER_VEHICLE,RetPname(playerid));
	if(!IsPlayerInRangeOfPoint(playerid,2.0,542.3506,-1292.6149,17.2422)) return SendClientMessage(playerid, -1, "ERROR: You're not at dealership");
	if(pVehicle[playerid][Model] > 0 || dini_Int(f,"model")) return SendClientMessage(playerid, -1, "ERROR: You already have vehicle"); 
	for(new i = 0; i < sizeof(g_aDealershipCategory); i++)
	{
		format(larstr, sizeof(larstr), "%s%s\n", larstr, g_aDealershipCategory[i]);
	}
	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP, DIALOG_STYLE_LIST, "Vehicle Categories", larstr, "Select", "Cancel");
	return 1;
}

CMD:tickets(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		new
			File:F,
			buff[8000],
			fmt[10000];
		F = fopen(TICKET_DIR,io_read);
		while(fread(F,buff)) {
			format(fmt,sizeof(fmt),"%s%s\n",fmt,buff);
		}
		if(strlen(fmt) < 1) return SendClientMessage(playerid, -1, "ERROR: No tickets were created");
		ShowPlayerDialog(playerid,DIALOG_TICKET,DIALOG_STYLE_LIST,"Support Tickets",fmt,"Close", "");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:deleteticket(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		new
			File:F,
			on = -1;
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(Ticket[i][Created])
			{
				if(Ticket[i][Queue] == 0)
				{
					Ticket[i][Queue] = -1;
					Ticket[i][TicketMsg] = EOS;
					Ticket[i][Created] = false;
					SendClientMessageEx(i,-1,"{FFFF00}[TICKET]{FFFFFF} Your ticket has been deleted by admin %s", RetPname(playerid));
					on++;
				}
			}
		}
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(Ticket[i][Created])
			{
				if(Ticket[i][Queue] != 0)
				{
					Ticket[i][Queue] -= 1;
					if(Ticket[i][Queue] == 0) return SendClientMessage(playerid, -1, "Your ticket got shifted!");
				}
			}
		}
		if(on == -1) return SendClientMessage(playerid, -1, "No Tickets!");
		F = fopen(TICKET_DIR,io_write);
		fwrite(F,"\b");
		fclose(F);
		SendClientMessage(playerid, -1, "Ticket has been deleted");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:createticket(playerid, params[])
{
	new
		File:F,
		txt[200],
		msg[200],
		id;
	if(Ticket[playerid][Created]) return SendClientMessage(playerid, -1, "ERROR: You already have ticket on queue");
	if(sscanf(params, "s[200]", txt)) return SendClientMessage(playerid, -1, "Usage: /createticket [text]");
	Ticket[playerid][Created] = true;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(Ticket[i][Created] && Ticket[i][Queue] < MAX_PLAYERS) {
			id++;
		}
	}
	F = fopen(TICKET_DIR,io_append);
	Ticket[playerid][Queue] = id - 1;
	strcpy(Ticket[playerid][TicketMsg],txt);
	format(msg,sizeof(msg),"%s(%d), Text: %s\r\n",RetPname(playerid), playerid ,txt);
	fwrite(F, msg);
	fclose(F);
	SendClientMessage(playerid, -1, "Your ticket has been successfully created");
	return 1;
}

CMD:w(playerid, params[]) return cmd_whisper(playerid, params);

CMD:whisper(playerid, params[])
{
	new
		id,
		text[200];
	if(sscanf(params, "p< >is[200]", id, text)) return SendClientMessage(playerid, -1, "Usage: /whisper [playerid] [text]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(id == playerid) return SendClientMessage(playerid, -1, "ERROR: Invalid ID");
	if(!IsPlayerInRangeOfPlayer(playerid,id,3.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that player");
	SendClientMessageEx(id,-1,"{AAAAAA}[WHISPER] %s{FFFFFF}: %s",RetPname(playerid,1),text);
	SendClientMessageEx(playerid,-1,"{AAAAAA}[WHISPER] %s{FFFFFF}: %s", RetPname(playerid,1),text);
	return 1;
}

CMD:weather(playerid, params[])
{
	new
		id;
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "Usage: /weather [id]");
		SetWeather(id);
		SendClientMessageToAllEx(-1, "{00FF00}[ADMIN CMD]{AA0000}[WEATHER]{FFFFFF} Admin %s has set the weather to id: %d", RetPname(playerid), id);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:time(playerid, params[])
{
	new
		h,
		m,
		y,
		mo,
		d,
		msg[120];
	gettime(h,m);
	getdate(y, mo, d);
	format(msg,sizeof(msg),
		"~w~%02d~y~:~w~%02d~n~\
		~w~%d~y~/~w~%02d~y~/~w~%d",
		h,m,
		d,mo,y);
	GameTextForPlayer(playerid, msg, 3000, 1);
	return 1;
}

CMD:togchannel(playerid, params[])
{
	new
		opt[120];
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(sscanf(params, "s[120]", opt)) return SendClientMessage(playerid, -1, "Usage: /togchannel [channel]");
		
		if(!strcmp(opt,"qna",false)) {
			if(sPChannel[qna]) {
				if(!sPChannel[qna]) return SendClientMessage(playerid, -1, "ERROR: The channel already disabled");
				sPChannel[qna] = false;
				SendClientMessageToAllEx(-1,"{FFFF00}[SERVER]{FFFFFF}: QnA Channel has been disabled by Admin %s",RetPname(playerid));
				return 1;
			}
			else {
				if(sPChannel[qna]) return SendClientMessage(playerid, -1, "ERROR: The channel already enabled");
				sPChannel[qna] = true;
				SendClientMessageToAllEx(-1,"{FFFF00}[SERVER]{FFFFFF}: QnA Channel has been enabled by Admin %s",RetPname(playerid));
			}
			return 1;
		}
		if(!strcmp(opt,"ooc",false)) {
			if(sPChannel[ooc]) {
				if(!sPChannel[ooc]) return SendClientMessage(playerid, -1, "ERROR: The channel already disabled");
				sPChannel[ooc] = false;
				SendClientMessageToAllEx(-1,"{FFFF00}[SERVER]{FFFFFF}: Global OOC Channel has been disabled by Admin %s",RetPname(playerid));
				return 1;
			}
			else {
				if(sPChannel[qna]) return SendClientMessage(playerid, -1, "ERROR: The channel already enabled");
				sPChannel[ooc] = true;
				SendClientMessageToAllEx(-1,"{FFFF00}[SERVER]{FFFFFF}: Global OOC Channel has been enabled by Admin %s",RetPname(playerid));
			}
			return 1;
		}
		else return SendClientMessage(playerid, -1, "ERROR: Invalid channel name");
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:admins(playerid, params[])
{
	new on = -1;
	SendClientMessage(playerid,-1," ");
	SendClientMessage(playerid, -1, "List Of Online Administrators:");
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) {
			if(IsPlayerAdmin(i)) {
				SendClientMessageEx(playerid, -1, "{00FF00}RCON Administrator %s(%d)",RetPname(i),i);
				on++;
			}
			else if(pStaffDuty[i][Admin]) {
				SendClientMessageEx(playerid, -1, "{00FF00}Administrator %s(%d)",RetPname(i),i);
				on++;
			}
			else if(pAccount[i][Admin] && !pStaffDuty[i][Admin]) {
				SendClientMessageEx(playerid, -1, "{AAAAAA}Administrator %s(%d)",RetPname(i),i);
				on++;
			}
		}
	}
	if(on == -1) return SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}No online Admins at the moment");
	SendClientMessage(playerid,-1," ");
	return 1;
}

CMD:helpers(playerid, params[])
{
	new on = -1;
	SendClientMessage(playerid,-1," ");
	SendClientMessage(playerid, -1, "List Of Online Helpers:");
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) {
			if(pStaffDuty[i][Helper]) {
				SendClientMessageEx(playerid, -1, "{00FF00}Helper %s(%d)",RetPname(i),i);
				on++;
			}
			else if(pAccount[i][Helper] && !pStaffDuty[i][Helper]) {
				SendClientMessageEx(playerid, -1, "{AAAAAA}Helper %s(%d)",RetPname(i),i);
				on++;
			}
		}
	}
	if(on == -1) return SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}No online Helpers at the moment");
	SendClientMessage(playerid,-1," ");
	return 1;
}

CMD:ho(playerid, params[])
{
	new
		text[128];
	if(pStaffDuty[playerid][Helper]) {
		if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "Usage: /ao [text]");
		foreach(new i : Player) if(IsPlayerLoggedIn[playerid]) SendClientMessageEx(i,-1, "(( {AA00AA}Helper %s{FFFFFF}: %s ))", RetPname(playerid), text);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:ao(playerid, params[])
{
	new
		text[128];
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "Usage: /ao [text]");
		foreach(new i : Player) if(IsPlayerLoggedIn[playerid]) SendClientMessageEx(i,-1, "(( {00FF00}Administrator %s{FFFFFF}: %s ))", RetPname(playerid), text);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:dropweaponinfo(playerid, params[])
{
	new
		bool:found,
		msg[120],
		id;
	for(new i = 0; i < MAX_WEAPON_DROP; i++)
	{
		if(!sWeaponDrop[i][Drop])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 1.0, sWeaponDrop[i][dropgunpos][0], sWeaponDrop[i][dropgunpos][1], sWeaponDrop[i][dropgunpos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == sWeaponDrop[i][vworld])
			{
				found = true;
				id = i;
			}
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the dropped gun");
	if(sWeaponDrop[id][dropgunid] == DROPGUN_COLT45) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Weapon Name: {FFFF00}Colt45");
		format(msg,sizeof(msg),"Durability: {FFFF00}%.1f", sWeaponDrop[id][dura]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_DEAGLE) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Weapon Name: {FFFF00}Desert Eagle");
		format(msg,sizeof(msg),"Durability: {FFFF00}%.1f", sWeaponDrop[id][dura]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_SHOTGUN) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Weapon Name: {FFFF00}Shotgun");
		format(msg,sizeof(msg),"Durability: {FFFF00}%.1f", sWeaponDrop[id][dura]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_RIFLE) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Weapon Name: {FFFF00}Rifle");
		format(msg,sizeof(msg),"Durability: {FFFF00}%.1f", sWeaponDrop[id][dura]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	return 1;
}

CMD:dropammoinfo(playerid, params[])
{
	new
		bool:found,
		msg[120],
		id;
	for(new i = 0; i < MAX_WEAPON_DROP; i++)
	{
		if(!sAmmoDrop[i][Drop]) {
			continue;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.0, sAmmoDrop[i][dropammopos][0], sAmmoDrop[i][dropammopos][1], sAmmoDrop[i][dropammopos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == sAmmoDrop[i][vworld])
			{
				found = true;
				id = i;
			}
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the dropped ammo");
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_COLT45) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Ammo type: {FFFF00}Colt45");
		format(msg,sizeof(msg),"Bullet: {FFFF00}%d", sAmmoDrop[id][droppedammo]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_DEAGLE) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Ammo type: {FFFF00}Desert Eagle");
		format(msg,sizeof(msg),"Bullet: {FFFF00}%d", sAmmoDrop[id][droppedammo]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_SHOTGUN) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Ammo type: {FFFF00}Shotgun");
		format(msg,sizeof(msg),"Bullet: {FFFF00}%d", sAmmoDrop[id][droppedammo]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_RIFLE) {
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		SendClientMessage(playerid, -1, "Ammo type: {FFFF00}Rifle");
		format(msg,sizeof(msg),"Bullet: {FFFF00}%d", sAmmoDrop[id][droppedammo]);
		SendClientMessage(playerid,-1,msg);
		SendClientMessage(playerid, -1, "{AAAAAA}=_________________________=");
		return 1;
	}
	return 1;
}

CMD:pickupammo(playerid, params[])
{
	new
		bool:found,
		id;
	for(new i = 0; i < MAX_WEAPON_DROP; i++)
	{
		if(!sAmmoDrop[i][Drop]) {
			continue;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.0, sAmmoDrop[i][dropammopos][0], sAmmoDrop[i][dropammopos][1], sAmmoDrop[i][dropammopos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == sAmmoDrop[i][vworld])
			{
				found = true;
				id = i;
			}
		}
	}
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the dropped ammo");
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_COLT45) {
		if(pWeapon[playerid][ColtAmmo] > 300) return SendClientMessage(playerid, -1, "ERROR: You can't get more ammo of this weapon");
		sAmmoDrop[id][Drop] = false;
		DestroyDynamicObject(sAmmoDrop[id][dropammoobj]);
		Delete3DTextLabel(sAmmoDrop[id][dropammolabel]);
		pWeapon[playerid][ColtAmmo] += sAmmoDrop[id][droppedammo];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the ammo");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_DEAGLE) {
		if(pWeapon[playerid][DeagleAmmo] > 300) return SendClientMessage(playerid, -1, "ERROR: You can't get more ammo of this weapon");
		sAmmoDrop[id][Drop] = false;
		DestroyDynamicObject(sAmmoDrop[id][dropammoobj]);
		Delete3DTextLabel(sAmmoDrop[id][dropammolabel]);
		pWeapon[playerid][DeagleAmmo] += sAmmoDrop[id][droppedammo];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the ammo");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_SHOTGUN) {
		if(pWeapon[playerid][ShotgunAmmo] > 120) return SendClientMessage(playerid, -1, "ERROR: You can't get more ammo of this weapon");
		sAmmoDrop[id][Drop] = false;
		DestroyDynamicObject(sAmmoDrop[id][dropammoobj]);
		Delete3DTextLabel(sAmmoDrop[id][dropammolabel]);
		pWeapon[playerid][ShotgunAmmo] += sAmmoDrop[id][droppedammo];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the ammo");
		return 1;
	}
	if(sAmmoDrop[id][dropammoid] == DROPAMMO_RIFLE) {
		if(pWeapon[playerid][RifleAmmo] > 120) return SendClientMessage(playerid, -1, "ERROR: You can't get more ammo of this weapon");
		sAmmoDrop[id][Drop] = false;
		DestroyDynamicObject(sAmmoDrop[id][dropammoobj]);
		Delete3DTextLabel(sAmmoDrop[id][dropammolabel]);
		pWeapon[playerid][RifleAmmo] += sAmmoDrop[id][droppedammo];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the ammo");
		return 1;
	}
	return 1;
}

CMD:pickupweapon(playerid, params[])
{
	new
		bool:found,
		id;
	for(new i = 0; i < MAX_WEAPON_DROP; i++)
	{
		if(!sWeaponDrop[i][Drop])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 1.0, sWeaponDrop[i][dropgunpos][0], sWeaponDrop[i][dropgunpos][1], sWeaponDrop[i][dropgunpos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == sWeaponDrop[i][vworld])
			{
				found = true;
				id = i;
			}
		}
	}
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the dropped gun");
	if(sWeaponDrop[id][dropgunid] == DROPGUN_COLT45) {
		if(pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		sWeaponDrop[id][Drop] = false;
		DestroyDynamicObject(sWeaponDrop[id][dropgunobj]);
		Delete3DTextLabel(sWeaponDrop[id][dropgunlabel]);
		pWeapon[playerid][Colt] = true;
		pWeapon[playerid][ColtDurability] = sWeaponDrop[id][dura];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the weapon");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_DEAGLE) {
		if(pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		sWeaponDrop[id][Drop] = false;
		DestroyDynamicObject(sWeaponDrop[id][dropgunobj]);
		Delete3DTextLabel(sWeaponDrop[id][dropgunlabel]);
		pWeapon[playerid][Deagle] = true;
		pWeapon[playerid][DeagleDurability] = sWeaponDrop[id][dura];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the weapon");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_SHOTGUN) {
		if(pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		sWeaponDrop[id][Drop] = false;
		DestroyDynamicObject(sWeaponDrop[id][dropgunobj]);
		Delete3DTextLabel(sWeaponDrop[id][dropgunlabel]);
		pWeapon[playerid][Shotgun] = true;
		pWeapon[playerid][ShotgunDurability] = sWeaponDrop[id][dura];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the weapon");
		return 1;
	}
	if(sWeaponDrop[id][dropgunid] == DROPGUN_RIFLE) {
		if(pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "ERROR: You already have that weapon");
		sWeaponDrop[id][Drop] = false;
		DestroyDynamicObject(sWeaponDrop[id][dropgunobj]);
		Delete3DTextLabel(sWeaponDrop[id][dropgunlabel]);
		pWeapon[playerid][Rifle] = true;
		pWeapon[playerid][RifleDurability] = sWeaponDrop[id][dura];
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, -1, "You've picked up the weapon");
		return 1;
	}
	return 1;
}

CMD:dropammo(playerid, params[])
{
	new
		idx,
		msg[120],
		ammo,
		Float:pPos[4],
		opt[120];
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(sscanf(params, "p< >s[120]i", opt, ammo)) return SendClientMessage(playerid, -1, "Usage: /dropammo [weapon] [ammo]");
	if(ammo == 0) return SendClientMessage(playerid, -1, "ERROR: Invalid amount");
	if(!strcmp(opt,"colt45",false)) {
		if(pWeapon[playerid][ColtAmmo] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have that ammo");
		if(pWeapon[playerid][ColtAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo to drop");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sAmmoDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		sAmmoDrop[idx][dropammoid] = DROPAMMO_COLT45;
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		format(msg,sizeof(msg),"%d Colt45 Ammo",ammo);
		sAmmoDrop[idx][dropammolabel] = Create3DTextLabel(
			msg,
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sAmmoDrop[idx][Drop] = true;
		sAmmoDrop[idx][dropammopos][0] = pPos[0];
		sAmmoDrop[idx][dropammopos][1] = pPos[1];
		sAmmoDrop[idx][dropammopos][2] = pPos[2];
		sAmmoDrop[idx][droppedammo] = ammo;
		sAmmoDrop[idx][intid] = GetPlayerInterior(playerid);
		sAmmoDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sAmmoDrop[idx][dropammoobj] = CreateDynamicObject(
			19995,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			0.0,
			90.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		pWeapon[playerid][ColtAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have dropped the ammo");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(pWeapon[playerid][DeagleAmmo] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have that ammo");
		if(pWeapon[playerid][DeagleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo to drop");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sAmmoDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		sAmmoDrop[idx][dropammoid] = DROPAMMO_DEAGLE;
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		format(msg,sizeof(msg),"%d Desert Eagle Ammo",ammo);
		sAmmoDrop[idx][dropammolabel] = Create3DTextLabel(
			msg,
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sAmmoDrop[idx][Drop] = true;
		sAmmoDrop[idx][dropammopos][0] = pPos[0];
		sAmmoDrop[idx][dropammopos][1] = pPos[1];
		sAmmoDrop[idx][dropammopos][2] = pPos[2];
		sAmmoDrop[idx][droppedammo] = ammo;
		sAmmoDrop[idx][intid] = GetPlayerInterior(playerid);
		sAmmoDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sAmmoDrop[idx][dropammoobj] = CreateDynamicObject(
			19995,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			0.0,
			90.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		pWeapon[playerid][DeagleAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have dropped the ammo");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(pWeapon[playerid][ShotgunAmmo] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have that ammo");
		if(pWeapon[playerid][ShotgunAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo to drop");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sAmmoDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		sAmmoDrop[idx][dropammoid] = DROPAMMO_SHOTGUN;
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		format(msg,sizeof(msg),"%d Shotgun Ammo",ammo);
		sAmmoDrop[idx][dropammolabel] = Create3DTextLabel(
			msg,
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sAmmoDrop[idx][Drop] = true;
		sAmmoDrop[idx][dropammopos][0] = pPos[0];
		sAmmoDrop[idx][dropammopos][1] = pPos[1];
		sAmmoDrop[idx][dropammopos][2] = pPos[2];
		sAmmoDrop[idx][droppedammo] = ammo;
		sAmmoDrop[idx][intid] = GetPlayerInterior(playerid);
		sAmmoDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sAmmoDrop[idx][dropammoobj] = CreateDynamicObject(
			19995,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			0.0,
			90.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		pWeapon[playerid][ShotgunAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have dropped the ammo");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(pWeapon[playerid][RifleAmmo] == 0) return SendClientMessage(playerid, -1, "ERROR: You don't have that ammo");
		if(pWeapon[playerid][RifleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: Not enough ammo to drop");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sAmmoDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		sAmmoDrop[idx][dropammoid] = DROPAMMO_RIFLE;
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		format(msg,sizeof(msg),"%d Rifle Ammo",ammo);
		sAmmoDrop[idx][dropammolabel] = Create3DTextLabel(
			msg,
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sAmmoDrop[idx][Drop] = true;
		sAmmoDrop[idx][dropammopos][0] = pPos[0];
		sAmmoDrop[idx][dropammopos][1] = pPos[1];
		sAmmoDrop[idx][dropammopos][2] = pPos[2];
		sAmmoDrop[idx][droppedammo] = ammo;
		sAmmoDrop[idx][intid] = GetPlayerInterior(playerid);
		sAmmoDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sAmmoDrop[idx][dropammoobj] = CreateDynamicObject(
			19995,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			0.0,
			90.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		pWeapon[playerid][RifleAmmo] -= ammo;
		SendClientMessage(playerid, -1, "you have dropped the ammo");
		return 1;
	}
	else SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
	return 1;
}

CMD:dropweapon(playerid, params[])
{
	new
		idx,
		Float:pPos[4],
		opt[120];
	if(sscanf(params, "s[120]", opt)) return SendClientMessage(playerid, -1, "Usage: /dropweapon [weapon]");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't do this while in vehicle");
	if(pWeaponEquip[playerid][IsEquip]) return SendClientMessage(playerid, -1, "ERROR: You must have no equiped weapon in order to drop weapon");
	if(!strcmp(opt,"colt45",false)) {
		if(!pWeapon[playerid][Colt]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sWeaponDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		sWeaponDrop[idx][dropgunlabel] = Create3DTextLabel(
			ReturnWeaponName(WEAPON_COLT45),
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sWeaponDrop[idx][Drop] = true;
		sWeaponDrop[idx][dropgunpos][0] = pPos[0];
		sWeaponDrop[idx][dropgunpos][1] = pPos[1];
		sWeaponDrop[idx][dropgunpos][2] = pPos[2];
		sWeaponDrop[idx][dropgunid] = DROPGUN_COLT45;
		sWeaponDrop[idx][dura] = pWeapon[playerid][ColtDurability];
		sWeaponDrop[idx][intid] = GetPlayerInterior(playerid);
		sWeaponDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sWeaponDrop[idx][dropgunobj] = CreateDynamicObject(
			ReturnWeaponsModel(WEAPON_COLT45),
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			80.0,
			0.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);

		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);

		/* Reset gun */
		pWeapon[playerid][Colt] = false;
		pWeapon[playerid][ColtDurability] = 0.0;
		SendClientMessage(playerid, -1, "You've dropped the weapon");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(!pWeapon[playerid][Deagle]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sWeaponDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		sWeaponDrop[idx][dropgunlabel] = Create3DTextLabel(
			ReturnWeaponName(WEAPON_DEAGLE),
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sWeaponDrop[idx][Drop] = true;
		sWeaponDrop[idx][dropgunpos][0] = pPos[0];
		sWeaponDrop[idx][dropgunpos][1] = pPos[1];
		sWeaponDrop[idx][dropgunpos][2] = pPos[2];
		sWeaponDrop[idx][dropgunid] = DROPGUN_DEAGLE;
		sWeaponDrop[idx][dura] = pWeapon[playerid][DeagleDurability];
		sWeaponDrop[idx][intid] = GetPlayerInterior(playerid);
		sWeaponDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sWeaponDrop[idx][dropgunobj] = CreateDynamicObject(
			ReturnWeaponsModel(WEAPON_DEAGLE),
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			80.0,
			0.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);

		/* Reset gun */
		pWeapon[playerid][Deagle] = false;
		pWeapon[playerid][DeagleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You've dropped the weapon");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(!pWeapon[playerid][Shotgun]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sWeaponDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		sWeaponDrop[idx][dropgunlabel] = Create3DTextLabel(
			ReturnWeaponName(WEAPON_SHOTGUN),
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sWeaponDrop[idx][Drop] = true;
		sWeaponDrop[idx][dropgunpos][0] = pPos[0];
		sWeaponDrop[idx][dropgunpos][1] = pPos[1];
		sWeaponDrop[idx][dropgunpos][2] = pPos[2];
		sWeaponDrop[idx][dropgunid] = DROPGUN_SHOTGUN;
		sWeaponDrop[idx][dura] = pWeapon[playerid][ShotgunDurability];
		sWeaponDrop[idx][intid] = GetPlayerInterior(playerid);
		sWeaponDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sWeaponDrop[idx][dropgunobj] = CreateDynamicObject(
			ReturnWeaponsModel(WEAPON_SHOTGUN),
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			80.0,
			0.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);

		/* Reset gun */
		pWeapon[playerid][Shotgun] = false;
		pWeapon[playerid][ShotgunDurability] = 0.0;
		SendClientMessage(playerid, -1, "You've dropped the weapon");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(!pWeapon[playerid][Rifle]) return SendClientMessage(playerid, -1, "ERROR: You don't have that weapon");
		for(new i; i < MAX_WEAPON_DROP; i++)
		{
			if(!sWeaponDrop[i][Drop]) {
				idx = i;
				break;
			}
		}
		GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
		GetPlayerFacingAngle(playerid, pPos[3]);
		sWeaponDrop[idx][dropgunlabel] = Create3DTextLabel(
			ReturnWeaponName(WEAPON_RIFLE),
			0xAAAAAAAA,
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			2.0,
			GetPlayerVirtualWorld(playerid),
			1
		);
		sWeaponDrop[idx][Drop] = true;
		sWeaponDrop[idx][dropgunpos][0] = pPos[0];
		sWeaponDrop[idx][dropgunpos][1] = pPos[1];
		sWeaponDrop[idx][dropgunpos][2] = pPos[2];
		sWeaponDrop[idx][dropgunid] = DROPGUN_RIFLE;
		sWeaponDrop[idx][dura] = pWeapon[playerid][RifleDurability];
		sWeaponDrop[idx][intid] = GetPlayerInterior(playerid);
		sWeaponDrop[idx][vworld] = GetPlayerVirtualWorld(playerid);
		sWeaponDrop[idx][dropgunobj] = CreateDynamicObject(
			ReturnWeaponsModel(WEAPON_RIFLE),
			pPos[0],
			pPos[1],
			pPos[2] - 1.0,
			80.0,
			0.0,
			pPos[3],
			GetPlayerVirtualWorld(playerid),
			GetPlayerInterior(playerid)
		);
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);

		/* Reset gun */
		pWeapon[playerid][Rifle] = false;
		pWeapon[playerid][RifleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You've dropped the weapon");
		return 1;
	}
	else SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
	return 1;
}

CMD:tp(playerid, params[])
{
	new
		idx1,
		idx2,
		Float:pos[3];
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		if(sscanf(params, "ii", idx1, idx2)) return SendClientMessage(playerid, -1, "Usage: /tp [who] [where]");
		if(!IsPlayerConnected(idx1)) return SendClientMessage(playerid, -1, "ERROR: 'Who' ID Is Not Connected");
		if(!IsPlayerConnected(idx2)) return SendClientMessage(playerid, -1, "ERROR: 'Where' ID Is Not Connected");
		GetPlayerPos(idx2,pos[0],pos[1],pos[2]);
		SetPlayerPos(idx1,pos[0],pos[1],pos[2]);
		SetPlayerInterior(idx1,GetPlayerInterior(idx2));
		SetPlayerVirtualWorld(idx1,GetPlayerVirtualWorld(idx2));
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:giveammo(playerid, params[])
{
	new
		opt[120],
		ammo,
		idx;
	if(sscanf(params, "p< >is[120]i", idx, opt, ammo)) return SendClientMessage(playerid, -1, "Usage: /giveweapon [playerid] [weapon] [ammo]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(idx == playerid) return SendClientMessage(playerid, -1, "Invalid ID");
	if(!IsPlayerInRangeOfPlayer(playerid,idx,2.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that player");

	if(!strcmp(opt,"colt45",false)) {
		if(pWeapon[playerid][ColtAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You don't have enough ammo of that weapon");
		if(pWeapon[idx][ColtAmmo] >= 300) return SendClientMessage(playerid, -1, "ERROR: You can't give more ammo of this weapon to that player");
		pWeapon[playerid][ColtAmmo] -= ammo;
		pWeapon[idx][ColtAmmo] += ammo;
		SendClientMessage(playerid, -1, "You gave your ammo to that player");
		SendClientMessage(idx, -1, "you have been given ammo");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(pWeapon[playerid][DeagleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You don't have enough ammo of that weapon");
		if(pWeapon[idx][DeagleAmmo] >= 300) return SendClientMessage(playerid, -1, "ERROR: You can't give more ammo of this weapon to that player");
		pWeapon[playerid][DeagleAmmo] -= ammo;
		pWeapon[idx][DeagleAmmo] += ammo;
		SendClientMessage(playerid, -1, "You gave your ammo to that player");
		SendClientMessage(idx, -1, "you have been given ammo");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(pWeapon[playerid][ShotgunAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You don't have enough ammo of that weapon");
		if(pWeapon[idx][ShotgunAmmo] >= 120) return SendClientMessage(playerid, -1, "ERROR: You can't give more ammo of this weapon to that player");
		pWeapon[playerid][ShotgunAmmo] -= ammo;
		pWeapon[idx][ShotgunAmmo] += ammo;
		SendClientMessage(playerid, -1, "You gave your ammo to that player");
		SendClientMessage(idx, -1, "you have been given ammo");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(pWeapon[playerid][RifleAmmo] < ammo) return SendClientMessage(playerid, -1, "ERROR: You don't have enough ammo of that weapon");
		if(pWeapon[idx][RifleAmmo] >= 120) return SendClientMessage(playerid, -1, "ERROR: You can't give more ammo of this weapon to that player");
		pWeapon[playerid][RifleAmmo] -= ammo;
		pWeapon[idx][RifleAmmo] += ammo;
		SendClientMessage(playerid, -1, "You gave your ammo to that player");
		SendClientMessage(idx, -1, "you have been given ammo");
		return 1;
	}
	else SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
	return 1;
}

CMD:giveweapon(playerid, params[])
{
	new
		opt[120],
		idx;
	if(sscanf(params, "is[120]", idx, opt)) return SendClientMessage(playerid, -1, "Usage: /giveweapon [playerid] [weapon]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(idx == playerid) return SendClientMessage(playerid, -1, "Invalid ID");
	if(!IsPlayerInRangeOfPlayer(playerid,idx,2.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that player");

	if(!strcmp(opt,"colt45",false)) {
		if(pWeapon[idx][Colt]) return SendClientMessage(playerid, -1, "ERROR: That player already has that weapon");
		pWeapon[idx][Colt] = true;
		pWeapon[idx][ColtDurability] = pWeapon[playerid][ColtDurability];
		pWeapon[playerid][Colt] = false;
		pWeapon[playerid][ColtDurability] = 0.0;
		SendClientMessage(playerid, -1, "You gave your weapon to that player");
		SendClientMessage(idx, -1, "you have been given a weapon");
		return 1;
	}
	if(!strcmp(opt,"deagle",false)) {
		if(pWeapon[idx][Deagle]) return SendClientMessage(playerid, -1, "ERROR: That player already has that weapon");
		pWeapon[idx][Deagle] = true;
		pWeapon[idx][DeagleDurability] = pWeapon[playerid][DeagleDurability];
		pWeapon[playerid][Deagle] = false;
		pWeapon[playerid][DeagleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You gave your weapon to that player");
		SendClientMessage(idx, -1, "you have been given a weapon");
		return 1;
	}
	if(!strcmp(opt,"shotgun",false)) {
		if(pWeapon[idx][Shotgun]) return SendClientMessage(playerid, -1, "ERROR: That player already has that weapon");
		pWeapon[idx][Shotgun] = true;
		pWeapon[idx][ShotgunDurability] = pWeapon[playerid][ShotgunDurability];
		pWeapon[playerid][Shotgun] = false;
		pWeapon[playerid][ShotgunDurability] = 0.0;
		SendClientMessage(playerid, -1, "You gave your weapon to that player");
		SendClientMessage(idx, -1, "you have been given a weapon");
		return 1;
	}
	if(!strcmp(opt,"rifle",false)) {
		if(pWeapon[idx][Rifle]) return SendClientMessage(playerid, -1, "ERROR: That player already has that weapon");
		pWeapon[idx][Rifle] = true;
		pWeapon[idx][RifleDurability] = pWeapon[playerid][RifleDurability];
		pWeapon[playerid][Rifle] = false;
		pWeapon[playerid][RifleDurability] = 0.0;
		SendClientMessage(playerid, -1, "You gave your weapon to that player");
		SendClientMessage(idx, -1, "you have been given a weapon");
		return 1;
	}
	else SendClientMessage(playerid, -1, "ERROR: Invalid weapon name");
	return 1;
}

CMD:discardweapon(playerid, params[])
{
	ShowPlayerDialog(playerid,DIALOG_WEAPON_DISCARD,DIALOG_STYLE_LIST,"Discard Weapon", \
	"Colt45\n\
	Desert Eagle\n\
	Shotgun\n\
	Rifle\n","Discard","Close");
	return 1;
}

CMD:unload(playerid, params[])
{
	if(!pWeaponEquip[playerid][IsEquip]) return SendClientMessage(playerid, -1, "{AAAAAA}You are not equiping a weapon");
	if(pWeaponEquip[playerid][Colt]) {
		if(GetPlayerWeapon(playerid) != WEAPON_COLT45 || GetPlayerAmmo(playerid) == 0) return SendClientMessage(playerid, -1, "There's no bullet in this equiped weapon");
		if(GetPlayerWeapon(playerid) == WEAPON_COLT45) {
			ResetPlayerWeapons(playerid);
			pWeapon[playerid][ColtAmmo] += GetPlayerAmmo(playerid);
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		return 1;
	}
	if(pWeaponEquip[playerid][Deagle]) {
		if(GetPlayerWeapon(playerid) != WEAPON_DEAGLE || GetPlayerAmmo(playerid) == 0) return SendClientMessage(playerid, -1, "There's no bullet in this equiped weapon");
		if(GetPlayerWeapon(playerid) == WEAPON_DEAGLE) {
			ResetPlayerWeapons(playerid);
			pWeapon[playerid][DeagleAmmo] += GetPlayerAmmo(playerid);
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		return 1;
	}
	if(pWeaponEquip[playerid][Shotgun]) {
		if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN || GetPlayerAmmo(playerid) == 0) return SendClientMessage(playerid, -1, "There's no bullet in this equiped weapon");
		if(GetPlayerWeapon(playerid) == WEAPON_SHOTGUN) {
			ResetPlayerWeapons(playerid);
			pWeapon[playerid][ShotgunAmmo] += GetPlayerAmmo(playerid);
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		return 1;
	}
	if(pWeaponEquip[playerid][Rifle]) {
		if(GetPlayerWeapon(playerid) != WEAPON_RIFLE || GetPlayerAmmo(playerid) == 0) return SendClientMessage(playerid, -1, "There's no bullet in this equiped weapon");
		if(GetPlayerWeapon(playerid) == WEAPON_RIFLE) {
			ResetPlayerWeapons(playerid);
			pWeapon[playerid][RifleAmmo] += GetPlayerAmmo(playerid);
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_LOAD", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_CROUCHLOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		return 1;
	}
	return 1; 
}

CMD:reload(playerid, params[])
{
	new
		weapon,
		ammo;

	if(!pWeaponEquip[playerid][IsEquip]) return SendClientMessage(playerid, -1, "{AAAAAA}You are not equiping a weapon");
	if(pWeaponEquip[playerid][Colt]) {
		GetPlayerWeaponData(playerid, 2, weapon, ammo);
		if(GetPlayerAmmo(playerid) == 17 || (weapon == WEAPON_COLT45 && ammo == 17)) return SendClientMessage(playerid, -1, "Ammo is full");
		if(GetPlayerAmmo(playerid) < 17 && pWeapon[playerid][ColtAmmo] < 17 && GetPlayerWeapon(playerid) == WEAPON_COLT45 || (weapon == WEAPON_COLT45 && ammo < 17 && pWeapon[playerid][ColtAmmo] < 17)) return SendClientMessage(playerid, -1, "No Ammo Left For this weapon");
		if(pWeapon[playerid][ColtAmmo] >= 17) {
			pWeapon[playerid][ColtAmmo] += GetPlayerAmmo(playerid);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_COLT45, 17);
			pWeapon[playerid][ColtAmmo] -= 17;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][ColtAmmo] < 17 && pWeapon[playerid][ColtAmmo] > 0) {
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_COLT45, pWeapon[playerid][ColtAmmo]);
			pWeapon[playerid][ColtAmmo] = 0;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][ColtAmmo] <= 0) return SendClientMessage(playerid, -1, "{AAAAAA}You have no silenced colt45 ammo");
		return 1;
	}
	if(pWeaponEquip[playerid][Deagle]) {
		GetPlayerWeaponData(playerid, 2, weapon, ammo);
		if(GetPlayerAmmo(playerid) == 7 || (weapon == WEAPON_DEAGLE && ammo == 7)) return SendClientMessage(playerid, -1, "Ammo is full");
		if(GetPlayerAmmo(playerid) < 7 && pWeapon[playerid][DeagleAmmo] < 7 && GetPlayerWeapon(playerid) == WEAPON_DEAGLE || (weapon == WEAPON_DEAGLE && ammo < 7 && pWeapon[playerid][DeagleAmmo] < 7)) return SendClientMessage(playerid, -1, "No Ammo Left For this weapon");
		if(pWeapon[playerid][DeagleAmmo] >= 7) {
			pWeapon[playerid][DeagleAmmo] += GetPlayerAmmo(playerid);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 7);
			pWeapon[playerid][DeagleAmmo] -= 7;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][DeagleAmmo] < 7 && pWeapon[playerid][DeagleAmmo] > 0) {
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, pWeapon[playerid][DeagleAmmo]);
			pWeapon[playerid][DeagleAmmo] = 0;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "COLT45", "COLT45_CROUCHRELOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][DeagleAmmo] == 0) return SendClientMessage(playerid, -1, "{AAAAAA}You have no desert eagle ammo");
		return 1;
	}
	if(pWeaponEquip[playerid][Shotgun]) {
		GetPlayerWeaponData(playerid, 3, weapon, ammo);
		if(GetPlayerAmmo(playerid) == 8 || (weapon == WEAPON_SHOTGUN && ammo == 8)) return SendClientMessage(playerid, -1, "Ammo is full");
		if(GetPlayerAmmo(playerid) < 8 && pWeapon[playerid][ShotgunAmmo] < 8 && GetPlayerWeapon(playerid) == WEAPON_SHOTGUN || (weapon == WEAPON_SHOTGUN && ammo < 8 && pWeapon[playerid][ShotgunAmmo] < 8)) return SendClientMessage(playerid, -1, "No Ammo Left For this weapon");
		if(pWeapon[playerid][ShotgunAmmo] >= 8) {
			pWeapon[playerid][ShotgunAmmo] += GetPlayerAmmo(playerid);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 8);
			pWeapon[playerid][ShotgunAmmo] -= 8;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][ShotgunAmmo] < 8 && pWeapon[playerid][ShotgunAmmo] > 0) {
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_SHOTGUN, pWeapon[playerid][ShotgunAmmo]);
			pWeapon[playerid][ShotgunAmmo] = 0;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "SHOTGUN", "SHOTGUN_FIRE_POOR", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][ShotgunAmmo] <= 0) return SendClientMessage(playerid, -1, "{AAAAAA}You have no shotgun ammo");
		return 1;
	}
	if(pWeaponEquip[playerid][Rifle]) {
		GetPlayerWeaponData(playerid, 6, weapon, ammo);
		if(GetPlayerAmmo(playerid) == 1 || (weapon == WEAPON_RIFLE && ammo == 1)) return SendClientMessage(playerid, -1, "Ammo is full");
		if(pWeapon[playerid][RifleAmmo] > 0) {
			pWeapon[playerid][RifleAmmo] += GetPlayerWeapon(playerid);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_RIFLE, 1);
			pWeapon[playerid][RifleAmmo] -= 1;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_LOAD", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_CROUCHLOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][RifleAmmo] < 1 && pWeapon[playerid][RifleAmmo] > 0) {
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_RIFLE, pWeapon[playerid][RifleAmmo]);
			pWeapon[playerid][RifleAmmo] = 0;
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_LOAD", 4.0, 0, 0, 0, 0, 0);
			else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyPlayerAnimation(playerid, "RIFLE", "RIFLE_CROUCHLOAD", 4.0, 0, 0, 0, 0, 0);
			return 1;
		}
		else if(pWeapon[playerid][RifleAmmo] <= 0) return SendClientMessage(playerid, -1, "{AAAAAA}You have no rifle ammo");
		return 1;
	}
	return 1; 
}

CMD:unequip(playerid, params[])
{
	if(!pWeaponEquip[playerid][IsEquip]) return SendClientMessage(playerid, -1, "{AAAAAA}You are not equiping a weapon");
	pWeaponEquip[playerid][IsEquip] = false;
	ResetPlayerWeapons(playerid);
	if(pWeaponEquip[playerid][Colt]) pWeaponEquip[playerid][Colt] = false;
	if(pWeaponEquip[playerid][Deagle]) pWeaponEquip[playerid][Deagle] = false;
	if(pWeaponEquip[playerid][Shotgun]) pWeaponEquip[playerid][Shotgun] = false;
	if(pWeaponEquip[playerid][Rifle]) pWeaponEquip[playerid][Rifle] = false;
	SendClientMessage(playerid, -1, "{FFFF00}[WEAPON]{FFFFFF} Current equiped weapon has been unequiped");
	return 1; 
}

CMD:equip(playerid, params[])
{
	if(pWeaponEquip[playerid][IsEquip]) return SendClientMessage(playerid, -1, "{AAAAAA}You already equiping a weapon");
	ShowPlayerDialog(playerid,DIALOG_WEAPON_EQUIP,DIALOG_STYLE_LIST,"Equip Weapon", \
	"Colt45\n\
	Desert Eagle\n\
	Shotgun\n\
	Rifle\n","Equip","Close");
	return 1;
}

CMD:weapon(playerid, params[])
{
	new str_weap[1200];
	strcat(str_weap,"Name\tDurability\tAmmo\n");
	strcat(str_weap,"Colt45\t%.1f\t%d\n");
	strcat(str_weap,"Deagle\t%.1f\t%d\n");
	strcat(str_weap,"Shotgun\t%.1f\t%d\n");
	strcat(str_weap,"Rifle\t%.1f\t%d\n");

	new str_wfor[4000];
	format(str_wfor,sizeof(str_wfor),str_weap,
		/*Silenced*/
		pWeapon[playerid][ColtDurability],
		pWeapon[playerid][ColtAmmo],
		/*Deagle*/
		pWeapon[playerid][DeagleDurability],
		pWeapon[playerid][DeagleAmmo],
		/*Shotgun*/
		pWeapon[playerid][ShotgunDurability],
		pWeapon[playerid][ShotgunAmmo],
		/*Rifle*/
		pWeapon[playerid][RifleDurability],
		pWeapon[playerid][RifleAmmo]);
	ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_TABLIST_HEADERS,"Your Weapons",str_wfor,"Close","");
	return 1;
}

CMD:pickup(playerid, params[])
{
	if(!pState[playerid][OnCall]) return SendClientMessage(playerid, -1, "ERROR: You're not received a call");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SendClientMessage(pCallInfo[playerid][CalledID], -1, "They've picked up your call, now you can talk");
	SendClientMessage(playerid, -1, "type /hangup to hang up");
	return 1;
}

CMD:hangup(playerid, params[])
{
	if(pState[playerid][OnCall]) {
		pState[playerid][OnCall] = false;
		SendClientMessage(playerid, -1, "You've hung up...");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		if(!pCallInfo[playerid][IsServiceNumber]) {
			pState[ pCallInfo[playerid][CalledID] ][OnCall] = false;
			pCallInfo[ pCallInfo[playerid][CalledID] ][CalledNumber] = -1;
			pCallInfo[ pCallInfo[playerid][CalledID] ][ CalledID ] = -1;
			pState[ pCallInfo[playerid][CalledID] ][OnRing] = false;
			SendClientMessage(pCallInfo[playerid][CalledID], -1, "They've hung up");
			SetPlayerSpecialAction(pCallInfo[playerid][CalledID], SPECIAL_ACTION_STOPUSECELLPHONE);
			pCallInfo[playerid][CalledID] = -1;
			return 1;
		}
		pCallText[playerid][Taxi]=0;
		pCallInfo[playerid][CalledNumber] = -1;
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You're not on call");
}

CMD:call(playerid, params[])
{
	new
		bool:found,
		id,
		number;
	if(!pInventory[playerid][Phone]) return SendClientMessage(playerid, -1, "ERROR: You don't have a phone"); 
	if(pState[playerid][OnCall]) return SendClientMessage(playerid, -1, "ERROR: You're already on a call");
	if(sscanf(params, "i", number)) return SendClientMessage(playerid, -1, "Usage: /call [number]");
	if(number == NUMBER_TAXI) {
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		pCallInfo[playerid][IsServiceNumber] = true;
		pCallInfo[playerid][CalledNumber] = number;
		pState[playerid][OnCall] = true;
		pCallText[playerid][Taxi] = 0;
		SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FFFF00}[TAXI]{FFFFFF}: Hi, You Are Calling Taxi Service, Could you tell your current location?");
		return 1;
	}
	else {
		#if defined NO_CALL
			SendClientMessage(playerid, -1, "[SERVER]: Call system for players is currently disabled, however you can still call service number...");
			return SendClientMessage(playerid, -1, "or if you want to contact players use /sms instead");
		#endif
		if(number == pStat[playerid][PhoneNumber]) return SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FF0000}[OPERATOR]{FFFFFF}: Sorry You can't call this number at the moment");
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(pStat[i][PhoneNumber] == number) {
				found = true;
				id = i;
			}
		}
		printf("call found id: %d", id);
		if(!found) return SendClientMessage(playerid, -1, "{00AAAA}[CALL]{FF0000}[OPERATOR]{FFFFFF}: Sorry You can't call this number at the moment");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		pCallInfo[playerid][CalledNumber] = number;
		pState[playerid][OnCall] = true;
		pCallInfo[playerid][CalledID] = id;
		pCallInfo[id][CalledNumber] = pStat[playerid][PhoneNumber];
		pCallInfo[id][CalledID] = playerid;
		pState[id][OnCall] = true;
		SendClientMessage(id, -1, "{00AAAA}Your Phone Is Ringing, Type /pickup to pickup the call");
		SendClientMessage(playerid, -1, "{00AAAA}You have dialed this number please wait them to pickup your call...");
	}
	return 1;
}

CMD:stats(playerid, params[])
{
	return 1;
}

CMD:mower(playerid, params[])
{
	new bool:found;
	for(new i; i < 4; i++)
	{
		if(IsPlayerInVehicle(playerid, MowVeh[i])) {
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not in mower");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 572) return SendClientMessage(playerid, -1, "ERROR: You're not in mower");
	if(pMission[playerid][Mower]) return SendClientMessage(playerid, -1, "ERROR: You already taking this job");
	pMission[playerid][Mower] = true;
	pCheckpoint[playerid][Mower] = 0;
	SetPlayerCheckpoint(playerid, 778.5635,-1295.9993,13.5641, 2.0);
	SendClientMessage(playerid, -1, "Follow the checkpoints to finish the job");
	SendClientMessage(playerid, -1, "Use /cancel to cancel mission or job");
	return 1;
}

CMD:flipcoin(playerid, params[])
{
	new
		ranc,
		msg[128];
	ranc = random(2);
	if(GetPlayerMoney(playerid) < 1) return SendClientMessage(playerid, -1, "ERROR: You don't have a coin");
	switch(ranc) {
		case 0: {
			format(msg,sizeof(msg),"{D6A4D9}* %s Flips A Coin And Lands On {FFFF00}Head", RetPname(playerid,1));
			ProxMsg(30.0,playerid,msg,-1);
			return 1;
		}
		case 1: {
			format(msg,sizeof(msg),"{D6A4D9}* %s Flips A Coin And Lands On {FFFF00}Tail", RetPname(playerid,1));
			ProxMsg(30.0,playerid,msg,-1);
			return 1;
		}
	}
	return 0;
}

CMD:refreshadlog(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		SendClientMessageToAll(-1, "[SERVER]: Admin Has Executed Refresh Ad Log, May Cause Server Lags For A While...");
		RefreshAdLog();
		SendClientMessageToAll(-1,"[SERVER]: Ad Log Has Been Refresed By Admin");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:clearadlog(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pStaffDuty[playerid][Admin]) {
		ResetAdLog();
		SendClientMessageToAll(-1,"[SERVER]: Ad Log Has Been Cleared By Admin");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have any permissions to use this command");
}

CMD:sms(playerid, params[])
{
	if(!pInventory[playerid][Phone]) return SendClientMessage(playerid, -1, "ERROR: You don't have a cellphone");
	new
		msg[180],
		text[128],
		smsinfo[100],
		num;
	if(sscanf(params, "p< >is[128]", num, text)) return SendClientMessage(playerid, -1, "Usage: /sms [number] [text]");
	if(pPhone[playerid][Credit] < 1) return SendClientMessage(playerid, -1, "ERROR: Not enough credit, 1 credit needed for sms");
	else if(pPhone[playerid][Credit] > 0) {
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(num == pStat[i][PhoneNumber]) {
				format(msg,sizeof(msg),"{AAAA00}[SMS Outbox]: %s, To (%d).", text, num);
				SendClientMessage(playerid, -1, msg);
				format(msg,sizeof(msg),"{FFFF00}[SMS Inbox]: %s, From (%d).", text, pStat[playerid][PhoneNumber]);
				SendClientMessage(i, -1, msg);
				pPhone[playerid][Credit] -= 1;
				for(new sms; sms < 30; sms++)
				{
					if(!strcmp(pSMS[i][sms]," ",false)) {
						format(smsinfo,sizeof(smsinfo),"%s\t%d", text, pStat[playerid][PhoneNumber]);
						strcpy(pSMS[i][sms], smsinfo);
						printf("[SMS-LOG][DEBUG]: ID 1 Has Been Executed");
						break;
					}
					else if(strcmp(pSMS[i][sms]," ",false) && sms == 9) {
						format(smsinfo,sizeof(smsinfo),"%s\t%d", text, pStat[playerid][PhoneNumber]);
						for(new csms; csms < 30; csms++)
						{
							strcpy(pSMS[i][csms]," ");
						}
						strcpy(pSMS[i][0], smsinfo);
						printf("[SMS-LOG][DEBUG]: ID 2 Has Been Executed");
						break;
					}
					else continue;
				}
				return 1;
			}
			else if(num != pStat[i][PhoneNumber] && i == (MAX_PHONE_NUMBER - 1)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
		}
		return 1;
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new
		idx;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in vehicle");
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /eject [playerid]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(idx == playerid) return SendClientMessage(playerid, -1, "ERROR: You can't eject yourself");
	if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(idx)) return SendClientMessage(playerid, -1, "ERROR: That player is not inside your vehicle");
	RemovePlayerFromVehicle(idx);
	SendClientMessage(idx, -1, "You has been ejected by driver");
	SendClientMessage(playerid, -1, "Player ejected");
	return 1;
}

CMD:busdriver(playerid, params[])
{
	if(pMission[playerid][Material] || pMission[playerid][Product] || pMission[playerid][Sweeper] || pMission[playerid][Component]) return SendClientMessage(playerid, -1, "ERROR: You're already in another mission");
	if(pMission[playerid][BusDriver]) return SendClientMessage(playerid, -1, "You're already taking this job");
	for(new i; i < 7; i++)
	{
		if(IsPlayerInVehicle(playerid, vBus[i][ID])) {
			if(!strcmp(vBus[i][Owner],"None",false)) {
				new strb[400];
				strcat(strb,"{FF0000}Destination{FFFFFF}\n");
				strcat(strb,"Las Venturas\n");
				strcat(strb,"San Fierro\n");
				strcat(strb,"Red County\n");
				strcat(strb,"Bone County\n");
				strcat(strb,"Flint County\n");

				ShowPlayerDialog(playerid,DIALOG_BUS_ROUTE,DIALOG_STYLE_TABLIST_HEADERS,"Select Destination",strb,"Select","Cancel");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: This bus is already used by another player");
		}
		else if(!IsPlayerInVehicle(playerid, vBus[i][ID]) && i == 6) return SendClientMessage(playerid, -1, "ERROR: You're not in bus");
	}
	return 1;
}

CMD:canceloffer(playerid, params[])
{
	new
		msg[400],
		opt[200];
	if(sscanf(params, "s[200]", opt)) return SendClientMessage(playerid, -1, "Usage: /canceloffer [offername]");

	if(!strcmp("tune",opt,false)) {
		if(!pOffer[playerid][MechanicTune]) return SendClientMessage(playerid, -1, "ERROR: You're not get an offer of this");
		pOffer[playerid][MechanicTune] = false;
		pOffer[pOffer[playerid][OfferedBy]][IsOffering] = false;
		format(msg,sizeof(msg),"%s Has Canceled your offer",RetPname(playerid));
		SendClientMessage(pOffer[playerid][OfferedBy],-1,msg);
		SendClientMessage(playerid, -1, "You canceled the offer");
		pOffer[playerid][OfferedBy] = -1;
		return 1;
	}
	return 1;
}

CMD:accept(playerid, params[])
{
	new
		msg[400],
		opt[200];
	if(sscanf(params, "s[200]", opt)) return SendClientMessage(playerid, -1, "Usage: /accept [offername]");

	if(!strcmp("tune",opt,false)) {
		if(!pOffer[playerid][MechanicTune]) return SendClientMessage(playerid, -1, "ERROR: You're not get an offer of this");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in vehicle, get into a vehicle and try '/accept' again");
		if(GetVehicleType(GetPlayerVehicleID(playerid)) == VTYPE_CAR) {
			pOffer[playerid][MechanicTune] = false;
	 		format(msg,sizeof(msg),"{00AAAA}%s Has accepted your offer",RetPname(playerid));
	 		SendClientMessage(playerid, -1, "You accepted the offer");
	 		SendClientMessage(pOffer[playerid][OfferedBy], -1, msg);
	 		ShowPlayerDialog(playerid,
	 			DIALOG_MECHANIC_TUNE,
	 			DIALOG_STYLE_LIST,
	 			"Tune",
	 			"Wheel\n\
	 			Spoiler\n\
	 			Front Bumper\n\
	 			Rear Bumper\n\
	 			Exhaust\n\
	 			Hood\n\
	 			Roof\n\
	 			Sideskirt\n\
	 			Left Vent\n\
	 			Right Vent\n\
	 			Lamps\n",
	 			"Select",
	 			"Close");
	 		return 1;
 		}
 		else return SendClientMessage(playerid, -1, "ERROR: Unsupported vehicle type");
	}
	return 1;
}

CMD:tune(playerid, params[])
{
	new
		msg[128],
		idx;
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /tune [playerid]");
	if(pOffer[idx][MechanicTune]) return SendClientMessage(playerid, -1, "ERROR: That player already has an offer");
	if(pOffer[playerid][IsOffering]) return SendClientMessage(playerid, -1, "ERROR: You're already offering a player");
	format(msg,sizeof(msg),"{00AAAA}%s Has offered you to tune vehicle, type '/accept tune' to accept offer", RetPname(playerid));
	SendClientMessage(idx,-1,msg);
	format(msg,sizeof(msg),"{00AAAA}Your offer has been sent to that player, wait for their response");
	SendClientMessage(playerid, -1, msg);

	/* Set variables */
	pOffer[idx][MechanicTune] = true;
	pOffer[idx][OfferedBy] = playerid;
	pOffer[playerid][IsOffering] = true;
	return 1;
}

CMD:tpcoord(playerid, params[])
{
	new
		Float:pos[3];
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "p<,>fff", pos[0], pos[1], pos[2])) return SendClientMessage(playerid, -1, "Usage: /tpcoord [posx] [posy] [posz]");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	return 1;
}

CMD:clothesstock(playerid, params[])
{
	new
		cloid,
		msg[128];
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(GetPlayerVirtualWorld(playerid) == bizClothes[i][WorldID]) {
			cloid = i;
		}
	}
	if(strcmp(bizClothes[cloid][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You must inside of your on business to use this command");
	format(msg,sizeof(msg),"Clothes Stock: {008800}%d",bizClothes[cloid][Stock]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:buyaccs(playerid, params[])
{
	new
		str[14000];
	if(!IsPlayerInRangeOfPoint(playerid,1.5,161.6251,-83.2522,1001.8047)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from clothes buy point");
	for(new i; i < sizeof(AttachmentObjects); i++)
	{
		format(str,sizeof(str),"%s(%d) - %s\n",str,AttachmentObjects[i][attachmodel],AttachmentObjects[i][attachname]);
	}
	ShowPlayerDialog(playerid,DIALOG_ACCS_BUY,DIALOG_STYLE_LIST,"Buy Accessories",str,"Buy","Close");
	return 1;
}

CMD:buyclothes(playerid, params[])
{
	new
		cloid;
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(GetPlayerVirtualWorld(playerid) == bizClothes[i][WorldID]) {
			cloid = i;
		}
	}
	if(!IsPlayerInRangeOfPoint(playerid,1.5,161.6251,-83.2522,1001.8047)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from clothes buy point");
	if(!strcmp(bizClothes[cloid][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You can't buy clothes from your own business");
	if(bizClothes[cloid][Stock] < 1) return SendClientMessage(playerid, -1, "ERROR: Out of Stock");
	ShowModelSelectionMenu(playerid,sModelSel[Skin],"Clothes");
	return 1;
}

CMD:vcol(playerid, params[])
{
	new
		msg[128],
		color[2];
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You're not in vehicle");
	GetVehicleColor(GetPlayerVehicleID(playerid),color[0],color[1]);
	format(msg,sizeof(msg),"Vehicle Color of ID: %d, Color1: %d, Color2: %d", GetPlayerVehicleID(playerid), color[0], color[1]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}
	/* Animations */
CMD:crack(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /crack [1-2]");
    if(!strcmp(params, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:chat(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "MISC", "IDLE_CHAT_02", 2.0, 1, 0, 0, 0, 10000, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:hike(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","idle_taxi", 3.0, 0, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:caract(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","TAP_HAND",4.0, 1, 0 , 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:give(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"KISSING","gift_give",3.0,0,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:liftup(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:putdown(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:cry(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "GRAVEYARD", "MRNF_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:mourn(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "GRAVEYARD", "MRNM_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:endchat(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","endchat_01",8.0,0,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:show(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ON_LOOKERS", "point_loop", 4.0, 0, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:shoutanim(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "ON_LOOKERS", "shout_loop", 4.0, 0, 0, 0, 0, 0, 1);
    UsingAnim[playerid] = true;
	return 1;
}

CMD:look(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ON_LOOKERS", "lkup_loop", 4.0, 1, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:drunk(playerid, params[])
{
	ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:play(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /play [1-3]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_WIN", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_LOOSE", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:pee(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /pee [1-2]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "PISS_IN", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
        SetPlayerSpecialAction(playerid, 68);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:wank(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /wank [1-2]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "WANK_IN", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "WANK_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:sit(playerid, params[])
{

    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /sit [1-3]");
    if(!strcmp(params, "1", true))
    {
		ApplyPlayerAnimation(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
		ApplyPlayerAnimation(playerid, "MISC", "SEAT_TALK_01", 4.0, 1, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "3", true))
    {
		ApplyPlayerAnimation(playerid, "BEACH", "PARKSIT_M_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
	return 1;
}

CMD:bball(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /bball [1-6]");
    if(!strcmp(params, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_JUMP_SHOT", 4.0, 0, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_DEF_LOOP", 4.0, 1, 1, 0, 1, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "3", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_PICKUP", 4.0, 0, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "4", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_DNK", 4.0, 0, 0, 0, 0, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "5", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_IDLE", 4.0, 1, 0, 0, 1, 0, 1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "6", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_IDLE2", 4.0, 1, 0, 0, 1, 0, 1);
		UsingAnim[playerid] = true;
    }
	return 1;
}

CMD:scratch(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0, 1);
    UsingAnim[playerid] = true;
    return 1;
}

CMD:reloadanim(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 1);
    UsingAnim[playerid] = true;
    return 1;
}

CMD:injured(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:gsign(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /gsign [1-8]");
    if(!strcmp(params, "1", true))
    {
    	ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN1", 4.0, 0, 0, 0, 0, 0, 1);
    	UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
    	ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN2", 4.0, 0, 0, 0, 0, 0, 1);
    	UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN3", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "4", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN4", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "5", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN5", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "6", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN1LH", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "7", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN2LH", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "8", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN5LH", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:chill(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /chill [1-2]");
    if(!strcmp(params, "1", true))
    {
    	ApplyPlayerAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.1, 1, 1, 1, 1, 1, 1);
    	UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.1, 1, 1, 1, 1, 1, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:tag(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /tag [1-3]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "GRAFFITI", "GRAFFITI_CHKOUT", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "GRAFFITI", "SPRAYCAN_FIRE", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "SPRAYCAN", "SPRAYCAN_FULL", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:camera(playerid, params[])
{
    new
	give[5];

    if(sscanf(params, "s[5]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /camera [1-3]");
    if(!strcmp(give, "1", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "camcrch_cmon", 4.1, 0, 1, 1, 1, 1, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 0, 1, 1, 1, 1, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "PICCRCH_TAKE", 4.0, 1, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:rap(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"RAPPING","RAP_A_Loop",4.0,1,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:think(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 0, 1, 1, 1, 1, 1);\
	UsingAnim[playerid] = true;
	return 1;
}

CMD:box(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:tired(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:bar(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /bar [1-2]");
    if(!strcmp(give, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BAR", "Barserve_bottle", 2.0, 0, 0, 0, 0, 0,1);
		UsingAnim[playerid] = true;
    }
	else if(!strcmp(give, "2", true))
    {
		ApplyPlayerAnimation(playerid, "BAR", "Barserve_give", 2.0, 0, 0, 0, 0, 0,1);
		UsingAnim[playerid] = true;
    }
	return 1;
}

CMD:bat(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /bat [1-3]");
    if(!strcmp(give, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BASEBALL", "Bat_IDLE", 2.0, 0, 0, 0, 0, 0,1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
		ApplyPlayerAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 2.0, 0, 0, 0, 0, 0,1);
		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
		ApplyPlayerAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 2.0, 0, 0, 0, 0, 0,1);
		UsingAnim[playerid] = true;
    }
	return 1;
}

CMD:lean(playerid, params[])
{
	new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /lean [1-2]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0,1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid,"MISC","Plyrlean_loop",4.1,1,0,0,0,0);
   		UsingAnim[playerid] = true;
    }
	return 1;
}

CMD:dance(playerid, params[])
{
    new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /dance [1-5]");
    if(!strcmp(give, "1", true))
    {
   		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_A", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "3", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_B", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "4", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_D", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "5", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_E", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:searchfiles(playerid, params[])
{
    new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /searchfiles [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_IN", 4.0, 0, 1, 0, 1, 0, 1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_NOD", 4.0, 0, 1, 0, 1, 0, 1);
   		UsingAnim[playerid] = true;
    }
    if(!strcmp(give, "3", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_OUT", 4.0, 0, 1, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:kiss(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "BD_Fire", "grlfrd_kiss_03", 2.0, 0, 0, 0, 0, 0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:cpr(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
    UsingAnim[playerid] = true;
    return 1;
}

CMD:handsup(playerid, params[])
{
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:bomb(playerid, params[])
{
	ClearAnimations(playerid);
	ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1); // Place Bomb
	UsingAnim[playerid] = true;
	return 1;
}

CMD:getarrested(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1,1); // Gun Arrest
	UsingAnim[playerid] = true;
	return 1;
}

CMD:laugh(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0,1); // Laugh
	UsingAnim[playerid] = true;
	return 1;
}

CMD:lookout(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0,1); // Rob Lookout
	UsingAnim[playerid] = true;
	return 1;
}

CMD:aim(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0,1); // Rob
	UsingAnim[playerid] = true;
	return 1;
}

CMD:crossarms(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 1, 1, -1,1); // Arms crossed
	UsingAnim[playerid] = true;
	return 1;
}

CMD:car(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /car [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"CAR","Fixn_Car_Loop", 4.0, 1, 0, 0, 0, 0, 1);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CAR", "Fixn_Car_Out", 4.1, 1, 1, 1, 1, 1, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CAR", "flag_drop", 4.1, 1, 1, 1, 1, 1, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:lay(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /lay [1-4]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"BEACH","bather", 4.0, 1, 0, 0, 0, 0,1);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid,"BEACH","SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0,1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid,"CRACK","crckidle4", 4.0, 1, 0, 0, 0, 0,1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "4", true))
    {
        ApplyPlayerAnimation(playerid,"BEACH","PARKSIT_W_LOOP", 4.0, 1, 0, 0, 0, 0,1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:what(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /what [1-2]");
    if(!strcmp(give, "1", true))
    {
        ApplyPlayerAnimation(playerid,"RIOT","RIOT_ANGRY", 4.0, 0, 0, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid,"benchpress","gym_bp_celebrate", 4.0, 0, 0, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:hide(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:vomit(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0,1); // Vomit BAH!
	UsingAnim[playerid] = true;
	return 1;
}

CMD:eat(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:wave(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /wave [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0,1);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "KISSING", "GFWAVE2", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "KISSING", "BD_GF_WAVE", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:strip(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /strip [1-4]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "STRIP", "STRIP_A", 4.0, 1, 0, 0, 0, 0);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_A", 4.0, 1, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_B", 4.0, 1, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "4", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_C", 4.0, 1, 0, 0, 0, 0);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:chant(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:slap(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /slap [1-2]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0,1);
   		UsingAnim[playerid] = true;
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "FLOWERS", "FLOWER_ATTACK_M", 4.0, 0, 0, 0, 0, 0, 1);
        UsingAnim[playerid] = true;
    }
    return 1;
}

CMD:deal(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0,1); // Deal Drugs
	UsingAnim[playerid] = true;
 	return 1;
}

CMD:fucku(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","fucku",4.0,0,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:taichi(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PARK","Tai_Chi_Loop",4.0,0,0,0,0,0,1);
	UsingAnim[playerid] = true;
	return 1;
}

CMD:pay(playerid, params[])
{
	new
		msg[120],
		idx,
		money;
	if(sscanf(params, "p< >ii", idx, money)) return SendClientMessage(playerid, -1, "Usage: /pay [playerid] [amount]");
	if(!IsPlayerInRangeOfPlayer(playerid,idx,2.0)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from that player");
	if(GetPlayerMoney(playerid) < money) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
	if(idx == playerid) return SendClientMessage(playerid, -1, "ERROR: Invalid ID");
	GivePlayerMoney(playerid, -money);
	GivePlayerMoney(idx, money);
	format(msg,sizeof(msg),"{D6A4D9}* %s hands $%d to %s", RetPname(playerid,1), money, RetPname(idx,1));
	ProxMsg(30.0,playerid,msg,-1);
	return 1;
}

CMD:mycomponents(playerid, params[])
{
	new msg[128];
	format(msg,sizeof(msg),"You have {FFFF00}%d{FFFFFF} Component(s)",pInventory[playerid][Component]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:getcomponents(playerid, params[])
{
	new
		getco;
	getco = pInventory[playerid][Component];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(GetPlayerMoney(playerid) < 200) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
	if(pInventory[playerid][Component] == 100 || (getco += 10) >= 100) return SendClientMessage(playerid, -1, "ERROR: You can't get more component");
	if(pMission[playerid][Sweeper] || pMission[playerid][Product] || pMission[playerid][Material]) return SendClientMessage(playerid, -1, "ERROR: You're already in another mission");
	if(pMission[playerid][Component]) return SendClientMessage(playerid, -1, "ERROR: You're already taking this mission");
	pMission[playerid][Component] = true;
	GivePlayerMoney(playerid, -200);
	SetPlayerCheckpoint(playerid, 2354.5146,-2288.5325,17.4219, 4.0);
	SendClientMessage(playerid, -1, "Go to checkpoint to get your components, use /cancel to cancel mission");
	return 1;
}

CMD:removeinstall(playerid, params[])
{
	new
		idx,
		opt[80];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(sscanf(params, "p< >is[80]", opt)) return SendClientMessage(playerid, -1, "Usage: /removeinstall [component]");
	if(GetVehicleType(idx) == VTYPE_CAR || GetVehicleType(idx) == VTYPE_HEAVY) {
		if(!strcmp(opt,"hydraulics",false)) {
			if(pInventory[playerid][Component] < 2) return SendClientMessage(playerid, -1, "ERROR: You need 2 components to remove hydraulics");
			pInventory[playerid][Component] -= 2;
			RemoveVehicleComponent(idx, 1087);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component removed");
            return 1;
		}
		if(!strcmp(opt,"nitro2",false)) {
			if(pInventory[playerid][Component] < 2) return SendClientMessage(playerid, -1, "ERROR: You need 2 components to remove nitro 2x");
			pInventory[playerid][Component] -= 2;
			RemoveVehicleComponent(idx, 1009);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component removed");
            return 1;
		}
		if(!strcmp(opt,"nitro5",false)) {
			if(pInventory[playerid][Component] < 2) return SendClientMessage(playerid, -1, "ERROR: You need 2 components to remove nitro 5x");
			pInventory[playerid][Component] -= 2;
			RemoveVehicleComponent(idx, 1008);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component removed");
            return 1;
		}
		if(!strcmp(opt,"nitro10",false)) {
			if(pInventory[playerid][Component] < 2) return SendClientMessage(playerid, -1, "ERROR: You need 2 components to remove nitro 10x");
			pInventory[playerid][Component] -= 2;
			RemoveVehicleComponent(idx, 1010);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component removed");
            return 1;
		}
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Unsupported vehicle type");
}

CMD:install(playerid, params[])
{
	new
		idx,
		opt[80];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(sscanf(params, "p< >is[80]", idx, opt)) return SendClientMessage(playerid, -1, "Usage: /install [vehicleid] [component]");
	if(GetVehicleType(idx) == VTYPE_CAR || GetVehicleType(idx) == VTYPE_HEAVY) {
		if(!strcmp(opt,"hydraulics",false)) {
			if(pInventory[playerid][Component] < 12) return SendClientMessage(playerid, -1, "ERROR: You need 12 components to install hydraulics");
			pInventory[playerid][Component] -= 12;
			AddVehicleComponent(idx, 1087);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component installed");
            return 1;
		}
		if(!strcmp(opt,"nitro2",false)) {
			if(pInventory[playerid][Component] < 14) return SendClientMessage(playerid, -1, "ERROR: You need 14 component to install nitro 2x");
			pInventory[playerid][Component] -= 14;
			AddVehicleComponent(idx, 1009);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component installed");
            return 1;
		}
		if(!strcmp(opt,"nitro5",false)) {
			if(pInventory[playerid][Component] < 16) return SendClientMessage(playerid, -1, "ERROR: You need 16 component to install nitro 5x");
			pInventory[playerid][Component] -= 16;
			AddVehicleComponent(idx, 1008);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component installed");
            return 1;
		}
		if(!strcmp(opt,"nitro10",false)) {
			if(pInventory[playerid][Component] < 20) return SendClientMessage(playerid, -1, "ERROR: You need 14 component to install nitro 10x");
			pInventory[playerid][Component] -= 20;
			AddVehicleComponent(idx, 1010);
            for(new i; i < MAX_PLAYERS; i++)
            {
            	if(IsPlayerInRangeOfPlayer(i,playerid,1.5)) {
            		PlayerPlaySound(i, 1133, 0.0, 0.0, 0.0);
            	}
            }
            SendClientMessage(playerid, -1, "Component installed");
            return 1;
		}
		return 1;

	}
	else return SendClientMessage(playerid, -1, "ERROR: Unsupported vehicle type");
}

CMD:recolor(playerid, params[])
{
	new
		idx,
		color1,
		color2,
		Float:vpos[3];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(sscanf(params, "p< >iii", idx, color1, color2)) return SendClientMessage(playerid, -1, "Usage: /recolor [vehicleid] [color1] [color2]");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't use this command while on or in vehicle");
	if(pInventory[playerid][Component] < 6) return SendClientMessage(playerid, -1, "ERROR: You need 6 components to recolor vehicle");
	GetVehiclePos(idx, vpos[0], vpos[1], vpos[2]);
	if(!IsPlayerInRangeOfPoint(playerid,10.0, vpos[0], vpos[1], vpos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from that vehicle");
	pInventory[playerid][Component] -= 6;
	ChangeVehicleColor(idx, color1, color2);
	SendClientMessage(playerid, -1, "Vehicle has been recolored");
	return 1;
}

CMD:fixengine(playerid, params[])
{
	new
		idx,
		Float:vpos[3];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(sscanf(params,"i", idx)) return SendClientMessage(playerid, -1, "Usage: /fixengine [vehicleid]");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't use this command while on or in vehicle");
	if(pInventory[playerid][Component] < 3) return SendClientMessage(playerid, -1, "ERROR: You need 3 components to fix vehicle engine");
	GetVehiclePos(idx, vpos[0], vpos[1], vpos[2]);
	if(!IsPlayerInRangeOfPoint(playerid,10.0, vpos[0], vpos[1], vpos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from that vehicle");
	pInventory[playerid][Component] -= 3;
	SetVehicleHealth(idx, 1000.0);
	SendClientMessage(playerid, -1, "Engine has been fixed");
	return 1;
}

CMD:repair(playerid, params[])
{
	new
		idx,
		Float:vpos[3];
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(sscanf(params,"i", idx)) return SendClientMessage(playerid, -1, "Usage: /repair [vehicleid]");
	if(!IsPlayerInRangeOfPoint(playerid,65.0,2912.9553,-812.4323,11.0469)) return SendClientMessage(playerid, -1, "ERROR: You can only use this command when you were at mechanic center");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You can't use this command while on or in vehicle");
	if(pInventory[playerid][Component] < 5) return SendClientMessage(playerid, -1, "ERROR: You need 5 components to repair vehicle");
	GetVehiclePos(idx, vpos[0], vpos[1], vpos[2]);
	if(!IsPlayerInRangeOfPoint(playerid,10.0, vpos[0], vpos[1], vpos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from that vehicle");
	pInventory[playerid][Component] -= 5;
	RepairVehicle(idx);
	SendClientMessage(playerid, -1, "Vehicle has been repaired");
	return 1;
}

CMD:mechaduty(playerid, params[])
{
	if(pStaffDuty[playerid][Admin] || pStaffDuty[playerid][Helper]) return SendClientMessage(playerid, -1, "ERROR: You're on staff duty, go off duty first");
	if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not a mechanic");
	if(!IsPlayerInRangeOfPoint(playerid,1.5,2914.6526,-802.2943,11.0469)) return SendClientMessage(playerid,-1,"ERROR: You're not near by mechanic duty point");
	if(pJobDuty[playerid][Mechanic]) {
		pJobDuty[playerid][Mechanic] = false;
		SetPlayerSkin(playerid, GetPVarInt(playerid, "PrevSkinMechanic"));
		SendClientMessage(playerid, -1, "You've been off duty as a mechanic");
		SetPlayerColor(playerid, 0xFFFFFFFF);
		return 1;
	}
	else if(!pJobDuty[playerid][Mechanic]) return ShowModelSelectionMenu(playerid, sModelSel[MechanicDutySkin], "Select Duty Uniform");
	return 0;
}

CMD:l(playerid, params[]) return cmd_low(playerid, params);

CMD:s(playerid, params[]) return cmd_shout(playerid, params);

CMD:low(playerid, params[])
{
	new
		text[128],
		msg[200];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "Usage: /low [text]");
	format(msg,sizeof(msg),"{696969}%s quietly: %s", RetPname(playerid,1), text);
	ProxMsg(8.0,playerid,msg,-1);
	return 1;
}

CMD:shout(playerid, params[])
{
	new
		text[128],
		msg[200];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "Usage: /shout [text]");
	format(msg,sizeof(msg),"%s shouts: %s!", RetPname(playerid,1), text);
	ProxMsg2(45.0,playerid,msg,0xFFFFFFFF,0xAAAAAAFF,0x808080FF,0x3F3F3FFF);
	return 1;
}

CMD:wipechat(playerid, params[])
{
	for(new i; i < 10; i++)
	{
		SendClientMessage(playerid, -1, "");
	}
	return 1;
}

CMD:vehid(playerid, params[])
{
	new msg[180];
	format(msg,sizeof(msg),"Vehicle ID: %d", GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, -1,msg);
	return 1;
}

CMD:lockrv(playerid, params[])
{
	new
		Float:pos[3];
	for(new i; i < MAX_RENTVEH_FAGGIO; i++)
	{
		if(!strcmp(vRent[i][Owner],RetPname(playerid),false))
		{
			GetVehiclePos(vRent[i][ID], pos[0], pos[1], pos[2]);
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from your rented vehicle");
			if(!vRent[i][Locked]) {
				vRent[i][Locked] = true;
				GameTextForPlayer(playerid, "~r~Locked", 1000, 5);
				return 1;
			}
			else if(vRent[i][Locked]) {
				vRent[i][Locked] = false;
				GameTextForPlayer(playerid, "~g~Unlocked", 1000, 5);
				return 1;
			}
		}
	}
	return 1;
}

CMD:setprice(playerid, params[])
{
	new str[800];
	for(new i; i < MAX_ELECTRONIC; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
				strcat(str,"Phone\n");
				strcat(str,"Boombox\n");

				ShowPlayerDialog(playerid,DIALOG_SPRICE_ELECTRONIC,DIALOG_STYLE_LIST,"Set Price - Electronic",str,"Select","Close");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_CLOTHES; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(!strcmp(bizClothes[i][Owner],RetPname(playerid),false)) {
				ShowPlayerDialog(playerid,DIALOG_SPRICE_CLOTHES,DIALOG_STYLE_INPUT,"Set Price - Clothes","Type your desired price for all clothes,(min $10, max $1000)","Set","Close");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_TOOL; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(!strcmp(bizTool[i][Owner],RetPname(playerid),false)) {
				strcat(str,"Repair kit\n");
				strcat(str,"Fishing Rod\n");
				strcat(str,"Screwdriver\n");

				ShowPlayerDialog(playerid,DIALOG_SPRICE_TOOL,DIALOG_STYLE_LIST,"Set Price - Tool",str,"Select","Close");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	return 1;
}

CMD:setskin(playerid, params[])
{
	new
		idx;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /setskin [skinid]");

	if(idx > 0 && idx <= 311) {
		SetPlayerSkin(playerid, idx);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid ID");
}

CMD:rentveh(playerid, params[])
{
	new
		numplate[240];
	if(IsPlayerInRangeOfPoint(playerid,1.5,1562.2598,-2300.6880,13.5650)) {
		for(new i; i < MAX_RENTVEH_FAGGIO; i++)
		{
			if(!vRent[i][Rented]) {
				if(GetPlayerMoney(playerid) < 60) return SendClientMessage(playerid, -1, "ERROR: Not Enough Money");
				GivePlayerMoney(playerid, -60);
				vRent[i][ID] = CreateVehicle(462,1561.3556,-2308.7231,13.5485,89.9013,1,0,-1);
				format(numplate,sizeof(numplate),"RENT-%d",i);
				SetVehicleNumberPlate(vRent[i][ID], numplate);
				PutPlayerInVehicle(playerid, vRent[i][ID], 0);
				vRent[i][RentTime] = 30;
				strcpy(vRent[i][Owner],RetPname(playerid));
				vRent[i][Rented] = true;
				SendClientMessage(playerid, -1, "use /lockrv to lock your rented vehicle");
				break;
			}
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid,1.5,1926.1271,-1788.2462,13.3906)) {
		for(new i; i < MAX_RENTVEH_FAGGIO; i++)
		{
			if(!vRent[i][Rented]) {
				if(GetPlayerMoney(playerid) < 60) return SendClientMessage(playerid, -1, "ERROR: Not Enough Money");
				GivePlayerMoney(playerid, -60);
				vRent[i][ID] = CreateVehicle(462,1927.0935,-1792.6266,13.3828,270.2360,1,0,-1);
				format(numplate,sizeof(numplate),"RENT-%d",i);
				SetVehicleNumberPlate(vRent[i][ID], numplate);
				PutPlayerInVehicle(playerid, vRent[i][ID], 0);
				vRent[i][RentTime] = 30;
				strcpy(vRent[i][Owner],RetPname(playerid));
				vRent[i][Rented] = true;
				SendClientMessage(playerid, -1, "use /lockrv to lock your rented vehicle");
				break;
			}
		}
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You're not near by vehicle rent point");
}

CMD:collectbizrevenue(playerid, params[])
{
	new msg[160];
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
			if(bizElectronic[i][Balance] < 1) return SendClientMessage(playerid, -1, "ERROR: this business has no income yet");
			GivePlayerMoney(playerid, bizElectronic[i][Balance]);
			format(msg,sizeof(msg),"You have collected {008000}$%d{FFFFFF} from your business",bizElectronic[i][Balance]);
			bizElectronic[i][Balance] = 0;
			SendClientMessage(playerid, -1, msg);
			return 1;
		}
	}
	for(new i; i < MAX_TOOL; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(strcmp(bizTool[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
			if(bizTool[i][Balance] < 1) return SendClientMessage(playerid, -1, "ERROR: this business has no income yet");
			GivePlayerMoney(playerid, bizTool[i][Balance]);
			format(msg,sizeof(msg),"You have collected {008000}$%d{FFFFFF} from your business",bizTool[i][Balance]);
			bizTool[i][Balance] = 0;
			SendClientMessage(playerid, -1, msg);
			return 1;
		}
	}
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(strcmp(bizClothes[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
			if(bizClothes[i][Balance] < 1) return SendClientMessage(playerid, -1, "ERROR: this business has no income yet");
			GivePlayerMoney(playerid, bizClothes[i][Balance]);
			format(msg,sizeof(msg),"You have collected {008000}$%d{FFFFFF} from your business",bizClothes[i][Balance]);
			bizClothes[i][Balance] = 0;
			SendClientMessage(playerid, -1, msg);
			return 1;
		}
	}
	for(new i; i < MAX_RESTAURANT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			if(strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
			if(bizRestaurant[i][Balance] < 1) return SendClientMessage(playerid, -1, "ERROR: this business has no income yet");
			GivePlayerMoney(playerid, bizRestaurant[i][Balance]);
			format(msg,sizeof(msg),"You have collected {008000}$%d{FFFFFF} from your business",bizRestaurant[i][Balance]);
			bizRestaurant[i][Balance] = 0;
			SendClientMessage(playerid, -1, msg);
			return 1;
		}
	}
	return 1;
}

CMD:boombox(playerid, params[])
{
	new
		Float:pos[4],
		Float:Objpos[3],
		label[300],
		opt[40];
	if(!pInventory[playerid][Boombox]) return SendClientMessage(playerid, -1, "ERROR: You don't have a boombox");
	if(sscanf(params,"s[40]", opt)) return SendClientMessage(playerid, -1, "Usage: /boombox [place | pickup | set]");

	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);

	if(!strcmp(opt,"place",false)) {
		if(pBoombox[playerid][Placed]) return SendClientMessage(playerid, -1, "ERROR: Boombox is already placed");
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 30.0, pBoombox[i][PosX],pBoombox[i][PosY],pBoombox[i][PosZ]))
			{
				return 1;
			}
			if(i == (MAX_PLAYERS - 1) && !IsPlayerInRangeOfPoint(playerid, 30.0, pBoombox[i][PosX],pBoombox[i][PosY],pBoombox[i][PosZ])) {
				format(label,sizeof(label),"{00AAAA}[%s's Boombox]",RetPname(playerid));

				pBoombox[playerid][Placed] = true;
				pBoombox[playerid][PosX] = pos[0];
				pBoombox[playerid][PosY] = pos[1];
				pBoombox[playerid][PosZ] = pos[2];
				pBoombox[playerid][Obj] = CreateDynamicObject(2226,pos[0],pos[1],(pos[2] - 1.0),0.0,0.0,pos[3]);
				pBoombox[playerid][Label] = CreateDynamic3DTextLabel(label,0xFFFFFFAA,pos[0],pos[1],(pos[2] - 0.5),5.0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
			}
		}
		if(!pBoombox[playerid][Placed]) return SendClientMessage(playerid, -1, "ERROR: can't place boombox close to other boombox");
		return 1;
	}
	else if(!strcmp(opt,"pickup",false)) {
		if(!pBoombox[playerid][Placed]) return SendClientMessage(playerid, -1, "ERROR: your boombox is not placed");
		GetDynamicObjectPos(pBoombox[playerid][Obj], Objpos[0], Objpos[1], Objpos[2]);
		if(!IsPlayerInRangeOfPoint(playerid,1.5,Objpos[0],Objpos[1],Objpos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from your boombox");
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 3.8, 0, 0, 0, 0, 0, 0);
		DestroyDynamicObject(pBoombox[playerid][Obj]);
		DestroyDynamic3DTextLabel(pBoombox[playerid][Label]);
		pBoombox[playerid][Placed] = false;
		pBoombox[playerid][PosX] = 1000000000000.0;
		pBoombox[playerid][PosY] = 1000000000000.0;
		pBoombox[playerid][PosZ] = 1000000000000.0;
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerInRangeOfPoint(i, 30.0, Objpos[0],Objpos[1],Objpos[2])) {
				StopAudioStreamForPlayer(i);
			}
		}
		SendClientMessage(playerid, -1, "You've picked up your boombox");
		return 1;
	}
	else if(!strcmp(opt,"set",false)) {
		if(!pBoombox[playerid][Placed]) return SendClientMessage(playerid, -1, "ERROR: your boombox is not placed");
		GetDynamicObjectPos(pBoombox[playerid][Obj], Objpos[0], Objpos[1], Objpos[2]);
		if(!IsPlayerInRangeOfPoint(playerid,1.5,Objpos[0],Objpos[1],Objpos[2])) return SendClientMessage(playerid, -1, "ERROR: You're too far away from your boombox");
		ShowPlayerDialog(playerid,DIALOG_BOOMBOX_SET,DIALOG_STYLE_INPUT,"Boombox Set","Type Audio Stream Url","Play","Close");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
}

CMD:restockbiz(playerid, params[])
{
	new str[800];
	for(new i; i < MAX_ELECTRONIC; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
				strcat(str,"Phone\n");
				strcat(str,"Boombox\n");

				ShowPlayerDialog(playerid,DIALOG_RESTOCK_ELECTRONIC,DIALOG_STYLE_LIST,"Restock - Electronic",str,"Restock","Close");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_CLOTHES; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
				if(pInventory[playerid][Product] < 2) return SendClientMessage(playerid, -1, "ERROR: 2 Products needed for restocking");
				if(bizClothes[i][Stock] == 100) return SendClientMessage(playerid, -1, "ERROR: Stock is Full");
				pInventory[playerid][Product] -= 2;
				bizClothes[i][Stock] = 100;
				SendClientMessage(playerid, -1, "Business has been restocked");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_ELECTRONIC; i++) {
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(!strcmp(bizTool[i][Owner],RetPname(playerid),false)) {
				strcat(str,"Repair kit\n");
				strcat(str,"Fishing Rod\n");
				strcat(str,"Screwdriver\n");

				ShowPlayerDialog(playerid,DIALOG_RESTOCK_TOOL,DIALOG_STYLE_LIST,"Restock - Tool",str,"Restock","Close");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	return 1;
}

CMD:getproduct(playerid, params[])
{
	if(!pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You're not a trucker");
	if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2197.5491,-2661.5784,13.5469)) return SendClientMessage(playerid, -1, "ERROR: You're not near by /getproduct point");
	if(pMission[playerid][Material] || pMission[playerid][Sweeper]) return SendClientMessage(playerid, -1, "ERROR: you're already in other mission");
	if(pMission[playerid][Product]) return SendClientMessage(playerid, -1, "ERROR: You're already taking this mission");
	if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
	if(pInventory[playerid][Product] == 5) return SendClientMessage(playerid, -1, "ERROR: You can't get more products");
	pMission[playerid][Product] = true;
	GivePlayerMoney(playerid, -150);
	SetPlayerCheckpoint(playerid,2867.3545,2572.0383,10.8203, 8.0);
	SendClientMessage(playerid, -1, "Go to checkpoint in order to collect your product");
	SendClientMessage(playerid, -1, "use /cancel to cancel mission");
	return 1;
}

CMD:myproducts(playerid,params[])
{
	new msg[120];
	format(msg,sizeof(msg),"You Have {FF0000}%d{FFFFFF} Product(s)",pInventory[playerid][Product]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:sellbizto(playerid, params[])
{
	new
		idx,
		msg[400],
		price;
	if(sscanf(params, "ii", idx, price)) return SendClientMessage(playerid, -1, "Usage: /sellbizto [playerid] [price]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player is not connected");
	if(idx == playerid) return SendClientMessage(playerid, -1, "ERROR: Invalid playerid");
	if(price <= 0) return SendClientMessage(playerid, -1, "ERROR: Invalid price");
	if(!IsPlayerInRangeOfPlayer(playerid,idx,3.0)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from that player");
	if(pBizSell[playerid][Offering] > -1) return SendClientMessage(playerid, -1, "ERROR: You're already offering a player");
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
				pBizSell[playerid][Offering] = idx;
				pBizSell[idx][OfferedBy] = playerid;
				pBizSell[idx][Price] = price;
				pBizSell[idx][BizType] = BUSINESS_ELECTRONIC;
				pBizSell[idx][BizID] = i;
				format(msg,sizeof(msg),
					"{FFFFFF}Business Type: {FFFF00}Electronic Store{FFFFFF}\n\
					ID: {FF0000}%d \n\
					Price: {008000}%d{FFFFFF}\n\n\
					Player ID %d offering to sell their Business to You, Would You accept their offer?",i,price,playerid);
				ShowPlayerDialog(idx,DIALOG_SELL_BIZ,DIALOG_STYLE_MSGBOX,"Business Sell",msg,"Accept","Deny");
				SendClientMessage(playerid, -1, "you've offered that player, wait them to response");
				return 1;
			}
			else if(strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_TOOL; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(!strcmp(bizTool[i][Owner],RetPname(playerid),false)) {
				pBizSell[playerid][Offering] = idx;
				pBizSell[idx][OfferedBy] = playerid;
				pBizSell[idx][Price] = price;
				pBizSell[idx][BizType] = BUSINESS_TOOL;
				pBizSell[idx][BizID] = i;
				format(msg,sizeof(msg),
					"{FFFFFF}Business Type: {FFFF00}Tool Store{FFFFFF}\n\
					ID: {FF0000}%d \n\
					Price: {008000}%d{FFFFFF}\n\n\
					Player ID %d offering to sell their Business to You, Would You accept their offer?",i,price,playerid);
				ShowPlayerDialog(idx,DIALOG_SELL_BIZ,DIALOG_STYLE_MSGBOX,"Business Sell",msg,"Accept","Deny");
				return 1;
			}
			else if(strcmp(bizTool[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(!strcmp(bizClothes[i][Owner],RetPname(playerid),false)) {
				pBizSell[playerid][Offering] = idx;
				pBizSell[idx][OfferedBy] = playerid;
				pBizSell[idx][Price] = price;
				pBizSell[idx][BizType] = BUSINESS_CLOTHES;
				pBizSell[idx][BizID] = i;
				format(msg,sizeof(msg),
					"{FFFFFF}Business Type: {FFFF00}Clothes Shop{FFFFFF}\n\
					ID: {FF0000}%d \n\
					Price: {008000}%d{FFFFFF}\n\n\
					Player ID %d offering to sell their Business to You, Would You accept their offer?",i,price,playerid);
				ShowPlayerDialog(idx,DIALOG_SELL_BIZ,DIALOG_STYLE_MSGBOX,"Business Sell",msg,"Accept","Deny");
				return 1;
			}
			else if(strcmp(bizClothes[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_RESTAURANT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			if(!strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) {
				pBizSell[playerid][Offering] = idx;
				pBizSell[idx][OfferedBy] = playerid;
				pBizSell[idx][Price] = price;
				pBizSell[idx][BizType] = BUSINESS_RESTAURANT;
				pBizSell[idx][BizID] = i;
				format(msg,sizeof(msg),
					"{FFFFFF}Business Type: {FFFF00}Restaurant{FFFFFF}\n\
					ID: {FF0000}%d \n\
					Price: {008000}%d{FFFFFF}\n\n\
					Player ID %d offering to sell their Business to You, Would You accept their offer?",i,price,playerid);
				ShowPlayerDialog(idx,DIALOG_SELL_BIZ,DIALOG_STYLE_MSGBOX,"Business Sell",msg,"Accept","Deny");
				return 1;
			}
			else if(strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	return 1;
}

CMD:sellbiz(playerid, params[])
{
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
				GivePlayerMoney(playerid, 1000);
				UpdateElectronicBizLabel(i,"None","None");
				SendClientMessage(playerid, -1, "Property has been sold");
				return 1;
			}
			else if(strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_TOOL; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(!strcmp(bizTool[i][Owner],RetPname(playerid),false)) {
				GivePlayerMoney(playerid, 4000);
				UpdateToolBizLabel(i,"None","None");
				SendClientMessage(playerid, -1, "Property has been sold");
				return 1;
			}
			else if(strcmp(bizTool[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(!strcmp(bizClothes[i][Owner],RetPname(playerid),false)) {
				GivePlayerMoney(playerid, 1000);
				UpdateClothesBizLabel(i,"None","None");
				SendClientMessage(playerid, -1, "Property has been sold");
				return 1;
			}
			else if(strcmp(bizClothes[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			if(!strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) {
				GivePlayerMoney(playerid, 500);
				UpdateRestaurantBizLabel(i,"None","None");
				SendClientMessage(playerid, -1, "Property has been sold");
				return 1;
			}
			else if(strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player or unowned");
		}
	}
	return 1;
}

CMD:restockfood(playerid, params[])
{
	new bool:found,id,name[60],ft;
	if(sscanf(params, "is[60]", ft, name)) return SendClientMessage(playerid,-1,"Usage: /restockfood [foodid]");
	if(ft < 0 || ft > 3) return SendClientMessage(playerid, -1, "ERROR: Invalid food type");
	for(new i; i < MAX_RESTAURANT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			found = true;
			id = i;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not near by any restaurant doorstep");
	if(strcmp(bizRestaurant[id][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You don't own this business");
	if(pInventory[playerid][Product] <= 0) return SendClientMessage(playerid, -1, "ERROR: You need 1 product to restock food");
	switch(ft)
	{
		case 0:
		{
			if(bizRestaurant[id][Sprunk] == 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
			pInventory[playerid][Product] -= 1;
			bizRestaurant[id][Sprunk] = 50;
			SendClientMessage(playerid, -1, "Food restocked!");
		}
		case 1:
		{
			if(bizRestaurant[id][Water] == 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
			pInventory[playerid][Product] -= 1;
			bizRestaurant[id][Water] = 50;
			SendClientMessage(playerid, -1, "Food restocked!");
		} 
		case 2:
		{
			if(bizRestaurant[id][Fish] == 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
			pInventory[playerid][Product] -= 1;
			bizRestaurant[id][Fish] = 50;
			SendClientMessage(playerid, -1, "Food restocked!");
		}
		case 3:
		{
			if(bizRestaurant[id][Chicken] == 50) return SendClientMessage(playerid, -1, "ERROR: Stock is full");
			pInventory[playerid][Product] -= 1;
			bizRestaurant[id][Chicken] = 50;
			SendClientMessage(playerid, -1, "Food restocked!");
		}
	}
	return 1;
}

CMD:setfoodname(playerid, params[])
{
	new bool:found,id,name[60],ft;
	if(sscanf(params, "is[60]", ft, name)) return SendClientMessage(playerid,-1,"Usage: /setfoodname [foodid] [name]");
	if(ft < 0 || ft > 3) return SendClientMessage(playerid, -1, "ERROR: Invalid food type");
	for(new i; i < MAX_RESTAURANT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			found = true;
			id = i;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not near by any restaurant doorstep");
	if(strcmp(bizRestaurant[id][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You don't own this business");
	UpdateRestaurantFoodName(id,ft,name);
	SendClientMessage(playerid, -1, "Food name has been changed");
	return 1;
}

CMD:setshopname(playerid, params[])
{
	new
		text[100];
	if(sscanf(params,"s[100]",text)) return SendClientMessage(playerid,-1,"Usage: /setshopname [text]");
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
			if(!strcmp(bizElectronic[i][Owner],RetPname(playerid))) {
				if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid,-1,"ERROR: Not enough money, $500 for every shop name changes");
				GivePlayerMoney(playerid, -500);
				UpdateElectronicBizLabel(i, bizElectronic[i][Owner],text);
				SendClientMessage(playerid,-1,"Business shop name has been changed");
				return 1;
			}
			else if(strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_TOOL; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
			if(!strcmp(bizTool[i][Owner],RetPname(playerid))) {
				if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid,-1,"ERROR: Not enough money, $500 for every shop name changes");
				GivePlayerMoney(playerid, -500);
				UpdateToolBizLabel(i,bizTool[i][Owner],text);
				SendClientMessage(playerid,-1,"Business shop name has been changed");
				return 1;
			}
			else if(strcmp(bizTool[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_CLOTHES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
			if(!strcmp(bizClothes[i][Owner],RetPname(playerid))) {
				if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid,-1,"ERROR: Not enough money, $500 for every shop name changes");
				GivePlayerMoney(playerid, -500);
				UpdateClothesBizLabel(i,bizClothes[i][Owner],text);
				SendClientMessage(playerid,-1,"Business shop name has been changed");
				return 1;
			}
			else if(strcmp(bizClothes[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	for(new i; i < MAX_RESTAURANT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
			if(!strcmp(bizRestaurant[i][Owner],RetPname(playerid))) {
				if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid,-1,"ERROR: Not enough money, $500 for every shop name changes");
				GivePlayerMoney(playerid, -500);
				UpdateRestaurantBizLabel(i,bizRestaurant[i][Owner],text);
				SendClientMessage(playerid,-1,"Business shop name has been changed");
				return 1;
			}
			else if(strcmp(bizRestaurant[i][Owner],RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You're not the owner of this business");
		}
	}
	return 1;
}

CMD:buybiz(playerid, params[])
{
	new hasbiz;
	for(new i; i < 1000; i++)
	{
		if(!strcmp(bizElectronic[i][Owner],RetPname(playerid),false)) {
			hasbiz++;
		}
		if(!strcmp(bizTool[i][Owner],RetPname(playerid),false)) {
			hasbiz++;
		}
		if(!strcmp(bizClothes[i][Owner],RetPname(playerid),false)) {
			hasbiz++;
		}

	}
	if(hasbiz == 1 && !pAccount[playerid][VIP1]) return SendClientMessage(playerid, -1, "ERROR: You can't buy more business");
	else if(hasbiz == 2 && !pAccount[playerid][VIP2]) return SendClientMessage(playerid, -1, "ERROR: You can't buy more business");
	else if(hasbiz == 3 && !pAccount[playerid][VIP3]) return SendClientMessage(playerid, -1, "ERROR: You can't buy more business");
	else if(hasbiz == 4) return SendClientMessage(playerid, -1, "ERROR: You can't buy more business");
	else {
		for(new i; i < MAX_ELECTRONIC; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ])) {
				if(!strcmp(bizElectronic[i][Owner],"None",false)) {
					if(GetPlayerMoney(playerid) < bizElectronic[i][Price]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
					GivePlayerMoney(playerid, -bizElectronic[i][Price]);
					UpdateElectronicBizLabel(i,RetPname(playerid),bizElectronic[i][ShopName]);
					SendClientMessage(playerid, -1, "Property Bought");
					return 1;
				}
				else if(strcmp(bizElectronic[i][Owner],"None",false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player");
			}
		}
		for(new i; i < MAX_TOOL; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
				if(!strcmp(bizTool[i][Owner],"None",false)) {
					if(GetPlayerMoney(playerid) < bizTool[i][Price]) return SendClientMessage(playerid, -1, "ERROR: Not enough Money");
					GivePlayerMoney(playerid, -bizTool[i][Price]);
					UpdateToolBizLabel(i,RetPname(playerid),bizTool[i][ShopName]);
					SendClientMessage(playerid, -1, "Property Bought");
					return 1;
				}
				else if(strcmp(bizTool[i][Owner],"None",false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player");
			}
		}
		for(new i; i < MAX_CLOTHES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
				if(!strcmp(bizClothes[i][Owner],"None",false)) {
					if(GetPlayerMoney(playerid) < bizClothes[i][Price]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
					GivePlayerMoney(playerid, -bizClothes[i][Price]);
					UpdateClothesBizLabel(i,RetPname(playerid),bizClothes[i][ShopName]);
					SendClientMessage(playerid, -1, "Property Bought");
					return 1;
				}
				else if(strcmp(bizClothes[i][Owner],"None",false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player");
			}
		}
		for(new i; i < MAX_RESTAURANT; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
				if(!strcmp(bizRestaurant[i][Owner],"None",false)) {
					if(GetPlayerMoney(playerid) < bizRestaurant[i][Price]) return SendClientMessage(playerid, -1, "ERROR: Not enough money");
					GivePlayerMoney(playerid, -bizRestaurant[i][Price]);
					UpdateRestaurantBizLabel(i,RetPname(playerid),bizRestaurant[i][ShopName]);
					SendClientMessage(playerid, -1, "Property Bought");
					return 1;
				}
				else if(strcmp(bizRestaurant[i][Owner],"None",false)) return SendClientMessage(playerid, -1, "ERROR: This Business is already owned by other player");
			}
		}
	}
	return 1;
}

CMD:phone(playerid, params[])
{
	new str[800];
	new fstr[800];
	strcat(str,"SMS Inbox\n");
	strcat(str,"Advertisement Logs\n");
	strcat(str,"Advertisement\n");
	strcat(str,"Buy Phone Credits\n");
	strcat(str,"_____________________________\n");
	strcat(str,"Number: {00AAAA}%d\n");
	strcat(str,"Credit(s): {00AAAA}%d\n");
	format(fstr,sizeof(fstr),str,pStat[playerid][PhoneNumber],pPhone[playerid][Credit]);
	if(!pInventory[playerid][Phone]) return SendClientMessage(playerid,-1,"ERROR: You don't have a phone");
	ShowPlayerDialog(playerid,DIALOG_PHONE,DIALOG_STYLE_LIST,"Phone",fstr,"Select","Close");
	return 1;
}

CMD:getint(playerid, params[])
{
	new msg[80];
	format(msg,sizeof(msg),"Interior: %d",GetPlayerInterior(playerid));
	SendClientMessage(playerid,-1,msg);
	return 1;
}

CMD:getvw(playerid, params[])
{
	new msg[80];
	format(msg,sizeof(msg),"Virtual World: %d",GetPlayerVirtualWorld(playerid));
	SendClientMessage(playerid,-1,msg);
	return 1;
}

CMD:exit(playerid, params[])
{
	if(GetPlayerInterior(playerid) > 0 && GetPlayerVirtualWorld(playerid) > 0) {
		for(new i; i < MAX_ELECTRONIC; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,-2240.7825,137.1277,1035.4141) && GetPlayerVirtualWorld(playerid) == bizElectronic[i][WorldID]) {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ]);
				return 1;
			}
		}
		for(new i; i < MAX_TOOL; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,140.7118,1710.8280,1002.1363) && GetPlayerVirtualWorld(playerid) == bizTool[i][WorldID]) {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ]);
				return 1;
			}
		}
		for(new i; i < MAX_CLOTHES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,161.3896,-96.8334,1001.8047) && GetPlayerVirtualWorld(playerid) == bizClothes[i][WorldID]) {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ]);
				return 1;
			}
		}
		for(new i; i < MAX_RESTAURANT; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,460.5504,-88.6155,999.5547) && GetPlayerVirtualWorld(playerid) == bizRestaurant[i][WorldID]) {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ]);
				return 1;
			}
		}

		/* Public Building/interior */
		if(IsPlayerInRangeOfPoint(playerid, 1.5,1494.4346,1303.5786,1093.2891) && GetPlayerVirtualWorld(playerid) == WORLD_DRIVING_LICENSE) {
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1111.5823,-1796.9653,16.5938);
			return 1;
		}
	}
	return 1;
}

CMD:buy(playerid, params[])
{
	new
		str_f[1200],
		str[800];
	for(new i; i < MAX_ELECTRONIC; i++)
	{
		if(GetPlayerVirtualWorld(playerid) == bizElectronic[i][WorldID]) {
			if(!IsPlayerInRangeOfPoint(playerid, 1.5,-2237.0012,130.1817,1035.4141)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the buy point");
			strcat(str,"{00FF00}Item Name\t{00FF00}Price\t{00FF00}Stock\n");
			strcat(str,"Phone\t$%d\t%d\n");
			strcat(str,"Boombox\t$%d\t%d\n");
			format(str_f,sizeof(str_f),str,bizElectronic[i][PhonePrice],bizElectronic[i][Phone],bizElectronic[i][BoomboxPrice],bizElectronic[i][Boombox]);
			ShowPlayerDialog(playerid,DIALOG_SHOP_ELECTRONIC,DIALOG_STYLE_TABLIST_HEADERS,"Electronic Store",str_f,"Buy","Close");
			return 1;
		}
	}
	for(new i; i < MAX_TOOL; i++)
	{
		if(GetPlayerVirtualWorld(playerid) == bizTool[i][WorldID]) {
			if(!IsPlayerInRangeOfPoint(playerid, 1.5,148.2934,1698.5463,1002.1363)) return SendClientMessage(playerid, -1, "ERROR: You're not close enough from the buy point");
			strcat(str,"{00FF00}Item Name\t{00FF00}Price\t{00FF00}Stock\n");
			strcat(str,"Repair Kit\t$%d\t%d\n");
			strcat(str,"Fishing Rod\t$%d\t%d\n");
			strcat(str,"Screwdriver\t$%d\t%d\n");
			format(str_f,sizeof(str_f),str,
				bizTool[i][ToolPrice][Repairkit],
				bizTool[i][Repairkit],

				bizTool[i][ToolPrice][Fishingrod],
				bizTool[i][Fishingrod],

				bizTool[i][ToolPrice][Screwdriver],
				bizTool[i][Screwdriver]
			);
			ShowPlayerDialog(playerid,DIALOG_SHOP_TOOL,DIALOG_STYLE_TABLIST_HEADERS,"Tool Store",str_f,"Buy","Close");
			return 1;
		}
 	}
 	for(new i; i < MAX_RESTAURANT; i++)
 	{
 		if(GetPlayerVirtualWorld(playerid) == bizRestaurant[i][WorldID]) {
 			if(!IsPlayerInRangeOfPoint(playerid, 1.5,450.4843,-83.6519,999.5547)) return SendClientMessage(playerid, -1, "ERROR: You're not  close enough from the buy point");
 			strcat(str,"Food\tPrice\tStock\n");
 			strcat(str,"%s\t$%d\t%d\n");
 			strcat(str,"%s\t$%d\t%d\n");
 			strcat(str,"%s\t$%d\t%d\n");
 			strcat(str,"%s\t$%d\t%d\n");

 			format(str_f,sizeof(str_f),str,
 				bizRestaurant[i][SprunkName],
 				bizRestaurant[i][SprunkPrice],
 				bizRestaurant[i][Sprunk],

 				bizRestaurant[i][WaterName],
 				bizRestaurant[i][WaterPrice],
 				bizRestaurant[i][Water],

 				bizRestaurant[i][FishName],
 				bizRestaurant[i][FishPrice],
 				bizRestaurant[i][Fish],

 				bizRestaurant[i][ChickenName],
 				bizRestaurant[i][ChickenPrice],
 				bizRestaurant[i][Chicken]
 			);
 			ShowPlayerDialog(playerid,DIALOG_SHOP_RESTAURANT, DIALOG_STYLE_TABLIST_HEADERS,"Buy Food", str_f, "Close", "Buy");
 			return 1;
 		}
 	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
		for(new i; i < MAX_ELECTRONIC; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizElectronic[i][EnterX], bizElectronic[i][EnterY], bizElectronic[i][EnterZ])) {
				SetPlayerInterior(playerid, 6);
				SetPlayerVirtualWorld(playerid, bizElectronic[i][WorldID]);
				SetPlayerPos(playerid, -2238.3647,137.3522,1035.4141);
            	SetPlayerFacingAngle(playerid, 270.7877);
            	SendClientMessage(playerid, -1, "Type /buy to Buy Products");
            	return 1;
			}
		}
		for(new i; i < MAX_TOOL; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ])) {
				SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, bizTool[i][WorldID]);
				SetPlayerPos(playerid, 138.7050,1707.4708,1002.1363);
				SetPlayerFacingAngle(playerid, 180.4274);
				SendClientMessage(playerid, -1, "Type /buy to Buy Products");
				return 1;
			}
		}
		for(new i; i < MAX_CLOTHES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ])) {
				SetPlayerInterior(playerid, 18);
				SetPlayerVirtualWorld(playerid, bizClothes[i][WorldID]);
				SetPlayerPos(playerid, 161.4918,-90.1912,1001.8047);
				SetPlayerFacingAngle(playerid, 359.6699);
				SendClientMessage(playerid, -1, "Type /buyclothes to Buy Products");
				return 1;
			}
		}
		for(new i; i < MAX_RESTAURANT; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,1.5,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ])) {
				SetPlayerInterior(playerid, 4);
				SetPlayerVirtualWorld(playerid, bizRestaurant[i][WorldID]);
				SetPlayerPos(playerid, 455.1110,-88.7018,999.5547);
				SetPlayerFacingAngle(playerid, 91.0902);
				SendClientMessage(playerid, -1, "Type /buy to Buy Foods");
				return 1;
			}
		}

		/* Public Building/interior */
		if(IsPlayerInRangeOfPoint(playerid, 1.5,1111.5823,-1796.9653,16.5938))
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, WORLD_DRIVING_LICENSE);
			SetPlayerPos(playerid,1494.6310,1305.7600,1093.2891);
			SetPlayerFacingAngle(playerid, 0.6052);
			return 1;
		}
	}
	return 1;
}

CMD:ca(playerid, params[]) return cmd_clearanim(playerid, params);

CMD:clearanim(playerid, params[])
{
	if(!UsingAnim[playerid]) return SendClientMessage(playerid, -1, "ERROR: You're not using anim");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	UsingAnim[playerid] = false;
	SendClientMessage(playerid, -1, "Anim has been cleared");
	return 1;
}

CMD:sfps(playerid, params[])
{
	new
		msg[80];
	if(!IsPlayerAdmin(playerid)) return 0;
	format(msg,sizeof(msg),"Server Tick Rate: %d", GetServerTickRate());
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:ado(playerid, params[])
{
	new
		msg[400],
		Float:pos[3],
		text[80];
	if(sscanf(params, "s[80]", text)) return SendClientMessage(playerid, -1, "Usage: /ado [text]");

	if(strlen(text) > 80) return SendClientMessage(playerid, -1, "ERROR: Text is too long");

	if(IsADO[playerid] && !strcmp(text,"off",false)) {
		Delete3DTextLabel(pRpText[playerid][ADO]);
		IsADO[playerid]=false;
		SendClientMessage(playerid, -1, "ADO Has Been Removed");
		return 1;
	}
	else if(IsADO[playerid] && strcmp(text,"off",false)) return SendClientMessage(playerid, -1, "You already have ADO text placed");
	else {
		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
		format(msg,sizeof(msg),"{D6A4D9}* %s\n(( %s ))", text, RetPname(playerid));
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) pRpText[playerid][ADO] = Create3DTextLabel(msg, -1,pos[0],pos[1],(pos[2] - 0.2),20.0,0);
		else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			pRpText[playerid][ADO] = Create3DTextLabel(msg, -1,pos[0],pos[1],pos[2],20.0,0);
			Attach3DTextLabelToVehicle(pRpText[playerid][ADO], GetPlayerVehicleID(playerid), 0.0, 0.0, 0.8);
		}
		else return SendClientMessage(playerid, -1, "ERROR: You can only place ADO text when you were inside vehicle or on-foot");
		IsADO[playerid] = true;
		SendClientMessage(playerid, 0xAAAAAAAA, "ADO has been placed, type /ado off to remove");
		return 1;
	}
}

CMD:ame(playerid, params[])
{
	new
		msg[400],
		text[80];
	if(sscanf(params, "s[80]", text)) return SendClientMessage(playerid, -1, "Usage: /ame [text]");

	if(strlen(text) > 80) return SendClientMessage(playerid, -1, "ERROR: Text is too long");

	if(IsAME[playerid] && !strcmp(text,"off",false)) {
		DestroyDynamic3DTextLabel(pRpText[playerid][AME]);
		IsAME[playerid] = false;
		SendClientMessage(playerid, -1, "AME Has been removed");
		return 1;
	}
	else if(IsAME[playerid] && strcmp(text,"off",false)) return SendClientMessage(playerid, -1, "You already have AME text above your head");
	else {
		format(msg,sizeof(msg),"{D6A4D9}* %s %s", RetPname(playerid), text);
		pRpText[playerid][AME] = Create3DTextLabel(msg, -1, 0.0,0.0,0.0,20.0,0);
		Attach3DTextLabelToPlayer(pRpText[playerid][AME], playerid,0.0,0.0,0.8);
		IsAME[playerid] = true;
		SendClientMessage(playerid, 0xAAAAAAAA, "AME Text has been attached above your head, type /ame off to remove");
		return 1;
	}
}


CMD:deletebiz(playerid, params[])
{
	new
		opt[80],
		biz_fh[400],
		bizid;
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "p< >s[80]i", opt, bizid)) return SendClientMessage(playerid, -1, "Usage: /deletebiz [bizname] [bizid]");
		if(!strcmp(opt,"electronic",false)) {
			format(biz_fh,sizeof(biz_fh),BIZ_ELECTRONIC,bizid);
			if(fexist(biz_fh)) {
				DestroyDynamicPickup(dini_Int(biz_fh,"pickup"));
				DestroyDynamic3DTextLabel(dini_Int(biz_fh,"label"));
				bizElectronic[bizid][EnterX] = 100000000000000000000000000000.0;
				bizElectronic[bizid][EnterY] = 100000000000000000000000000000.0;
				bizElectronic[bizid][EnterZ] = 100000000000000000000000000000.0;
				bizElectronic[bizid][Pickup] = EOS;
				bizElectronic[bizid][Label] = EOS;
				fremove(biz_fh);
				SendClientMessage(playerid, -1, "Biz Deleted");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: File Not Found");
		}
		if(!strcmp(opt,"tool",false)) {
			format(biz_fh,sizeof(biz_fh),BIZ_TOOL,bizid);
			if(fexist(biz_fh)) {
				DestroyDynamicPickup(dini_Int(biz_fh,"pickup"));
				DestroyDynamic3DTextLabel(dini_Int(biz_fh,"label"));
				bizTool[bizid][EnterX] = 1000000000000000.0;
				bizTool[bizid][EnterY] = 1000000000000000.0;
				bizTool[bizid][EnterZ] = 1000000000000000.0;
				bizTool[bizid][Pickup] = EOS;
				bizTool[bizid][Label] = EOS;
				fremove(biz_fh);
				SendClientMessage(playerid, -1, "Biz Deleted"); 
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: File Not Found");
		}
		if(!strcmp(opt,"clothes",false)) {
			format(biz_fh,sizeof(biz_fh),BIZ_CLOTHES,bizid);
			if(fexist(biz_fh)) {
				DestroyDynamicPickup(dini_Int(biz_fh,"pickup"));
				DestroyDynamic3DTextLabel(dini_Int(biz_fh,"label"));
				bizClothes[bizid][EnterX] = 10000000.0;
				bizClothes[bizid][EnterY] = 10000000.0;
				bizClothes[bizid][EnterZ] = 10000000.0;
				bizClothes[bizid][Pickup] = EOS;
				bizClothes[bizid][Label] = EOS;
				fremove(biz_fh);
				SendClientMessage(playerid, -1, "Biz Deleted");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: File Not Found");
		}
		if(!strcmp(opt,"restaurant",false)) {
			format(biz_fh,sizeof(biz_fh),BIZ_RESTAURANT,bizid);
			if(fexist(biz_fh)) {
				DestroyDynamicPickup(dini_Int(biz_fh,"pickup"));
				DestroyDynamic3DTextLabel(dini_Int(biz_fh,"label"));
				bizRestaurant[bizid][EnterX] = 10000000.0;
				bizRestaurant[bizid][EnterY] = 10000000.0;
				bizRestaurant[bizid][EnterZ] = 10000000.0;
				bizRestaurant[bizid][Pickup] = EOS;
				bizRestaurant[bizid][Label] = EOS;
				fremove(biz_fh);
				SendClientMessage(playerid, -1, "Biz Deleted");
				return 1;
			}
			else return SendClientMessage(playerid, -1, "ERROR: File Not Found");
		}
		else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:createbiz(playerid, params[])
{
	new
		Float:pPos[3],
		price,
		biz_fh[400],
		biz_label[400],
		opt[80];
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params,"p< >s[80]i",opt, price)) return SendClientMessage(playerid, -1, "Usage: /createbiz [type] [price]");

		GetPlayerPos(playerid,pPos[0],pPos[1],pPos[2]);

		if(!strcmp(opt,"electronic",false)) {
			for(new i; i < MAX_ELECTRONIC; i++) {
				format(biz_fh,sizeof(biz_fh),BIZ_ELECTRONIC,i);
				if(!fexist(biz_fh)) {
					strcpy(bizElectronic[i][Owner], "None");
					strcpy(bizElectronic[i][ShopName], "None");
					bizElectronic[i][EnterX] = pPos[0];
					bizElectronic[i][EnterY] = pPos[1];
					bizElectronic[i][EnterZ] = pPos[2];
					bizElectronic[i][Price] = price;
					bizElectronic[i][WorldID] = (1_000 + i);
					bizElectronic[i][Phone] = 50;
					bizElectronic[i][Boombox] = 50;
					bizElectronic[i][PhonePrice] = 200;
					bizElectronic[i][BoomboxPrice] = 400;
					bizElectronic[i][Balance] = 0;
					format(biz_label,
						sizeof(biz_label),
						"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Electronic Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
						i,
						bizElectronic[i][ShopName],
						bizElectronic[i][Owner],
						bizElectronic[i][Price]
					);
					bizElectronic[i][Pickup] = CreateDynamicPickup(1274,0,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ]);
					bizElectronic[i][Label] = CreateDynamic3DTextLabel(biz_label,0xFFFFFFAA,bizElectronic[i][EnterX],bizElectronic[i][EnterY],bizElectronic[i][EnterZ],10.0);
					ftouch(biz_fh);
					dini_Set(biz_fh,"owner",bizElectronic[i][Owner]);
					dini_Set(biz_fh,"shopname",bizElectronic[i][ShopName]);
					dini_FloatSet(biz_fh,"enterx",bizElectronic[i][EnterX]);
					dini_FloatSet(biz_fh,"entery",bizElectronic[i][EnterY]);
					dini_FloatSet(biz_fh,"enterz",bizElectronic[i][EnterZ]);
					dini_IntSet(biz_fh,"price",bizElectronic[i][Price]);
					dini_IntSet(biz_fh,"worldid",bizElectronic[i][WorldID]);
					dini_IntSet(biz_fh,"pickup",bizElectronic[i][Pickup]);
					dini_IntSet(biz_fh,"label",bizElectronic[i][Label]);
					dini_IntSet(biz_fh,"phone",bizElectronic[i][Phone]);
					dini_IntSet(biz_fh,"boombox",bizElectronic[i][Boombox]);
					dini_IntSet(biz_fh,"phoneprice",bizElectronic[i][PhonePrice]);
					dini_IntSet(biz_fh,"boomboxprice",bizElectronic[i][BoomboxPrice]);
					dini_IntSet(biz_fh,"balance",bizElectronic[i][Balance]);
					SendClientMessage(playerid, -1, "Business Created");
					break;
				}
			}
			return 1;
		}

		if(!strcmp(opt,"tool",false)) {
			for(new i; i < MAX_TOOL; i++)
			{
				format(biz_fh,sizeof(biz_fh),BIZ_TOOL,i);
				if(!fexist(biz_fh)) {
					strcpy(bizTool[i][Owner],"None");
					strcpy(bizTool[i][ShopName],"None");
					bizTool[i][EnterX] = pPos[0];
					bizTool[i][EnterY] = pPos[1];
					bizTool[i][EnterZ] = pPos[2];
					bizTool[i][Price] = price;
					bizTool[i][WorldID] = (2_000 + i);
					bizTool[i][Repairkit] = 50;
					bizTool[i][Screwdriver] = 50;
					bizTool[i][Crowbar] = 50;
					bizTool[i][Fishingrod] = 50;
					bizTool[i][Rope] = 50;

					bizTool[i][ToolPrice][Repairkit] = 30;
					bizTool[i][ToolPrice][Fishingrod] = 35;
					bizTool[i][ToolPrice][Screwdriver] = 25;

					bizTool[i][Balance] = 0;
					format(biz_label,
						sizeof(biz_label),
						"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Tool Store\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
						i,
						bizTool[i][ShopName],
						bizTool[i][Owner],
						bizTool[i][Price]
					);
					bizTool[i][Pickup] = CreateDynamicPickup(1274,0,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ]);
					bizTool[i][Label] = CreateDynamic3DTextLabel(biz_label,0xFFFFFFAA,bizTool[i][EnterX],bizTool[i][EnterY],bizTool[i][EnterZ],10.0);
					ftouch(biz_fh);
					dini_Set(biz_fh,"owner",bizTool[i][Owner]);
					dini_Set(biz_fh,"shopname",bizTool[i][ShopName]);
					dini_FloatSet(biz_fh,"enterx",bizTool[i][EnterX]);
					dini_FloatSet(biz_fh,"entery",bizTool[i][EnterY]);
					dini_FloatSet(biz_fh,"enterz",bizTool[i][EnterZ]);
					dini_IntSet(biz_fh,"price",bizTool[i][Price]);
					dini_IntSet(biz_fh,"worldid",bizTool[i][WorldID]);
					dini_IntSet(biz_fh,"pickup",bizTool[i][Pickup]);
					dini_IntSet(biz_fh,"label",bizTool[i][Label]);
					dini_IntSet(biz_fh,"repairkit",bizTool[i][Repairkit]);
					dini_IntSet(biz_fh,"screwdriver",bizTool[i][Screwdriver]);
					dini_IntSet(biz_fh,"crowbar",bizTool[i][Crowbar]);
					dini_IntSet(biz_fh,"fishingrod",bizTool[i][Fishingrod]);
					dini_IntSet(biz_fh,"rope",bizTool[i][Rope]);

					dini_IntSet(biz_fh,"fishingrodprice",bizTool[i][ToolPrice][Fishingrod]);
					dini_IntSet(biz_fh,"screwdriver",bizTool[i][ToolPrice][Screwdriver]);
					dini_IntSet(biz_fh,"repairkitprice",bizTool[i][ToolPrice][Repairkit]);

					dini_IntSet(biz_fh,"balance",bizTool[i][Balance]);
					SendClientMessage(playerid, -1, "Business Created");
					break;
				}
			}
			return 1;
		}
		if(!strcmp(opt,"clothes",false)) {
			for(new i; i < MAX_CLOTHES; i++)
			{
				format(biz_fh,sizeof(biz_fh),BIZ_CLOTHES,i);
				if(!fexist(biz_fh)) {
					strcpy(bizClothes[i][Owner],"None");
					strcpy(bizClothes[i][ShopName],"None");
					bizClothes[i][EnterX] = pPos[0];
					bizClothes[i][EnterY] = pPos[1];
					bizClothes[i][EnterZ] = pPos[2];
					bizClothes[i][Price] = price;
					bizClothes[i][WorldID] = (3_000 + i);
					bizClothes[i][ClothesPrice] = 65;
					bizClothes[i][Stock] = 100;
					bizClothes[i][Balance] = 0;
					format(biz_label,
						sizeof(biz_label),
						"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Clothes Shop\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
						i,
						bizClothes[i][ShopName],
						bizClothes[i][Owner],
						bizClothes[i][Price]
					);
					bizClothes[i][Pickup] = CreateDynamicPickup(1274,0,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ]);
					bizClothes[i][Label] = CreateDynamic3DTextLabel(biz_label,0xFFFFFFAA,bizClothes[i][EnterX],bizClothes[i][EnterY],bizClothes[i][EnterZ],10.0);
					ftouch(biz_fh);
					dini_Set(biz_fh,"owner",bizClothes[i][Owner]);
					dini_Set(biz_fh,"shopname",bizClothes[i][ShopName]);
					dini_FloatSet(biz_fh,"enterx",bizClothes[i][EnterX]);
					dini_FloatSet(biz_fh,"entery",bizClothes[i][EnterY]);
					dini_FloatSet(biz_fh,"enterz",bizClothes[i][EnterZ]);
					dini_IntSet(biz_fh,"price",bizClothes[i][Price]);
					dini_IntSet(biz_fh,"worldid",bizClothes[i][WorldID]);
					dini_IntSet(biz_fh,"pickup",bizClothes[i][Pickup]);
					dini_IntSet(biz_fh,"label",bizClothes[i][Label]);
					dini_IntSet(biz_fh,"clothesprice",bizClothes[i][ClothesPrice]);
					dini_IntSet(biz_fh,"stock",bizClothes[i][Stock]);
					dini_IntSet(biz_fh,"balance",bizClothes[i][Balance]);
					SendClientMessage(playerid, -1, "Business Created");
					break;
				}
			}
			return 1;
		}
		if(!strcmp(opt,"restaurant",false)) {
			for(new i; i < MAX_RESTAURANT; i++)
			{
				format(biz_fh,sizeof(biz_fh),BIZ_RESTAURANT,i);
				if(!fexist(biz_fh)) {
					strcpy(bizRestaurant[i][Owner],"None");
					strcpy(bizRestaurant[i][ShopName],"None");
					bizRestaurant[i][EnterX] = pPos[0];
					bizRestaurant[i][EnterY] = pPos[1];
					bizRestaurant[i][EnterZ] = pPos[2];
					bizRestaurant[i][Price] = price;
					bizRestaurant[i][WorldID] = (4_000 + i);
					bizRestaurant[i][Sprunk] = 50;
					bizRestaurant[i][Water] = 50;
					bizRestaurant[i][Fish] = 50;
					bizRestaurant[i][Chicken] = 50;
					bizRestaurant[i][SprunkPrice] = 5;
					bizRestaurant[i][WaterPrice] = 3;
					bizRestaurant[i][FishPrice] = 8;
					bizRestaurant[i][ChickenPrice] = 10;
					strcpy(bizRestaurant[i][SprunkName],"Sprunk");
					strcpy(bizRestaurant[i][WaterName],"Water");
					strcpy(bizRestaurant[i][FishName],"Fish");
					strcpy(bizRestaurant[i][ChickenName],"Chicken");
					format(biz_label,
						sizeof(biz_label),
						"{AAAAAA}[ID:%d]\n{FF0000}%s\n{FF0000}Restaurant\n{FFFFFF}Owner: {FF0000}%s\n{AAAAAA}Type /enter to enter\n{008000}For Sale $%d",
						i,
						bizRestaurant[i][ShopName],
						bizRestaurant[i][Owner],
						bizRestaurant[i][Price]
					);
					bizRestaurant[i][Pickup] = CreateDynamicPickup(1274,0,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ]);
					bizClothes[i][Label] = CreateDynamic3DTextLabel(biz_label,0xFFFFFFAA,bizRestaurant[i][EnterX],bizRestaurant[i][EnterY],bizRestaurant[i][EnterZ],10.0);
					ftouch(biz_fh);
					dini_Set(biz_fh,"owner",bizRestaurant[i][Owner]);
					dini_Set(biz_fh,"shopname",bizRestaurant[i][ShopName]);
					dini_FloatSet(biz_fh,"enterx",bizRestaurant[i][EnterX]);
					dini_FloatSet(biz_fh,"entery",bizRestaurant[i][EnterY]);
					dini_FloatSet(biz_fh,"enterz",bizRestaurant[i][EnterZ]);
					dini_IntSet(biz_fh,"price",bizRestaurant[i][Price]);
					dini_IntSet(biz_fh,"worldid",bizRestaurant[i][WorldID]);
					dini_IntSet(biz_fh,"pickup",bizRestaurant[i][Pickup]);
					dini_IntSet(biz_fh,"label",bizRestaurant[i][Label]);
					dini_IntSet(biz_fh,"sprunk",bizRestaurant[i][Sprunk]);
					dini_IntSet(biz_fh,"water",bizRestaurant[i][Water]);
					dini_IntSet(biz_fh,"fish",bizRestaurant[i][Fish]);
					dini_IntSet(biz_fh,"chicken",bizRestaurant[i][Chicken]);
					dini_IntSet(biz_fh,"sprunkp",bizRestaurant[i][SprunkPrice]);
					dini_IntSet(biz_fh,"waterp",bizRestaurant[i][WaterPrice]);
					dini_IntSet(biz_fh,"fishp",bizRestaurant[i][FishPrice]);
					dini_IntSet(biz_fh,"chickenp",bizRestaurant[i][ChickenPrice]);
					dini_IntSet(biz_fh,"balance",bizRestaurant[i][Balance]);
					dini_Set(biz_fh,"sprunkn",bizRestaurant[i][SprunkName]);
					dini_Set(biz_fh,"watern",bizRestaurant[i][WaterName]);
					dini_Set(biz_fh,"fishn",bizRestaurant[i][FishName]);
					dini_Set(biz_fh,"chickenn",bizRestaurant[i][ChickenName]);
					SendClientMessage(playerid, -1, "Biz Created");
					break;
				}
			}
			return 1;
		}
		else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:plant(playerid, params[])
{
	return 1;
}

CMD:re(playerid, params[]) return cmd_reply(playerid, params);

CMD:reply(playerid, params[])
{
	new
		text[200],
		msg[200];

	new
		s,
		m,
		h,
		d,
		mo,
		y,
		pmlog[2000];
	if(GetPVarInt(playerid, "PreviousPM") == -1) return SendClientMessage(playerid,-1,"ERROR: You haven't received any PM yet");
	if(sscanf(params, "s[200]", text)) return SendClientMessage(playerid, -1, "Usage: /r(eply) [text]");
	if(!IsPlayerConnected(GetPVarInt(playerid, "PreviousPM"))) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected!");
	format(msg,sizeof(msg),"{FFFF00}(( PM From %s: %s ))", RetPname(playerid), text);
	SendClientMessage(GetPVarInt(playerid, "PreviousPM"),-1,msg);
	format(msg,sizeof(msg),"{FFFF00}(( PM Sent to %s: %s ))", RetPname(GetPVarInt(playerid, "PreviousPM")), text);
	SendClientMessage(playerid,-1,msg);
	
	/* PM Logger */
	gettime(h, m, s);
	getdate(y, mo, d);
	format(pmlog,sizeof(pmlog),"%s => (%s): %s\r\n",d,mo,y,h,m,s,RetPname(playerid),RetPname(playerid),text);
	Logger(PM_LOG_DIR,pmlog);

	SetPVarInt(GetPVarInt(playerid, "PreviousPM"),"PreviousPM",playerid);
	PlayerPlaySound2(GetPVarInt(playerid, "PreviousPM"),1054);
	return 1;
}

CMD:pm(playerid, params[])
{
	new
		idx,
		msg[200],
		text[200];

	new
		s,
		m,
		h,
		d,
		mo,
		y,
		pmlog[2000];
	if(sscanf(params, "is[200]", idx, text)) return SendClientMessage(playerid, -1, "Usage: /pm [id] [text]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected!");
	format(msg,sizeof(msg),"{FFFF00}(( PM From %s: %s ))", RetPname(playerid), text);
	SendClientMessage(idx,-1,msg);
	format(msg,sizeof(msg),"{FFFF00}(( PM Sent to %s: %s ))", RetPname(idx), text);
	SendClientMessage(playerid,-1,msg);

	/* PM Logger */
	gettime(h, m, s);
	getdate(y, mo, d);
	format(pmlog,sizeof(pmlog),"%s => (%s): %s\r\n",d,mo,y,h,m,s,RetPname(playerid),RetPname(playerid),text);
	Logger(PM_LOG_DIR,pmlog);

	SetPVarInt(idx,"PreviousPM",playerid);
	PlayerPlaySound2(idx,1054);
	return 1;
}

CMD:unban(playerid, params[])
{
	new
		fh[400],
		bool:checkban,
		name[128];
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "s[128]", name)) return SendClientMessage(playerid, -1, "Usage: /unban [name/filename]");
		
		format(fh,sizeof(fh),PLAYER_ACCOUNT,name);

		if(!fexist(fh)) return SendClientMessage(playerid, -1, "ERROR: File Not Found");
		else {
			checkban = dini_Bool(fh,"ban");
			if(!checkban) return SendClientMessage(playerid, -1, "ERROR: Account Is Not Banned");
			dini_BoolSet(fh,"ban",false);
			dini_Unset(fh,"banreason");
			SendClientMessage(playerid, -1, "Account Has Been Unbanned");
		}
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:rban(playerid, params[])
{
	new
		name[120],
		re[120],
		fh[120],
		bool:on;
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "p< >s[120]s[120]", name, re)) return SendClientMessage(playerid, -1, "Usage: /rban [username] [reason]");
		if(!strcmp(name,RetPname(playerid),false)) return SendClientMessage(playerid, -1, "ERROR: You can't remote ban yourself");
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(!strcmp(RetPname(i),name,false)) {
				on = true;
				break;
			}
		}
		if(on) return SendClientMessage(playerid, -1, "ERROR: Player with that username is currently online");
		format(fh,sizeof(fh),PLAYER_ACCOUNT,name);
		if(!fexist(fh)) return SendClientMessage(playerid, -1, "ERROR: The account with that username didn't exist");
	    dini_BoolSet(fh,"ban",true);
		SendClientMessageToAllEx(-1,"{FF0000}[BAN]{FFFF00} %s Has Been Remote-Banned By Admin %s, reason: %s", name, RetPname(playerid), re);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:ban(playerid, params[])
{
	new
		fh[400],
		msg[280],
		idx,
		reason[80];

	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "is[80]", idx, reason)) return SendClientMessage(playerid, -1, "Usage: /ban [playerid] [reason]");
		if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
		if(IsPlayerAdmin(idx)) return SendClientMessage(playerid, -1, "ERROR: You Can't Unban RCON Admin");
		if(idx == playerid) return SendClientMessage(playerid, -1, "ERROR: You Can't Ban Yourself");
		for(new i = 0; i < 50; i++)
	    {
	        SendClientMessage(idx,-1,"");
	    }
	    format(msg,sizeof(msg),"{FF0000}[BAN]{FFFF00} %s Has Been Banned By Admin %s, reason: %s", RetPname(idx), RetPname(playerid),reason);
	    SendClientMessageToAll(-1, msg);
	    format(fh,sizeof(fh),PLAYER_ACCOUNT,RetPname(idx));
	    dini_BoolSet(fh,"ban",true);
	    dini_Set(fh,"banreason",reason);
	    Kick2(idx,1000);
	    return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:myspareparts(playerid, params[])
{
	new msg[128];
	format(msg,sizeof(msg),"Gun Part(s): %d\n", pInventory[playerid][GunPart]);

	ShowPlayerDialog(playerid,DIALOG_SPAREPART,DIALOG_STYLE_MSGBOX,"Spare Parts",msg,"Close","");
	return 1;
}

CMD:mymaterials(playerid, params[])
{
	new msg[128];
	format(msg,sizeof(msg),"You Have {666600}%d{FFFFFF} Material(s)",pInventory[playerid][Material]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:info(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid,1.5,1313.1063,-875.3223,39.5781)) { //sweeper
		new str[400];
		strcat(str,"{FFFF00}Job:{FFFFFF} Street Sweeper\n");
		strcat(str,"{FFFF00}Salary: {008000}$15{FFFFFF}\n");
		strcat(str,"{FFFF00}Required Level:{FFFFFF} -\n");
		strcat(str,"ProTip: -");

		ShowPlayerDialog(playerid,DIALOG_SWEEPER_INFO,DIALOG_STYLE_MSGBOX,"Sweeper Job Info",str,"Close","");
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.5,1271.9991,-2038.5074,59.0828)) { // bus
		new str[400];
		strcat(str,"{FFFF00}Job:{FFFFFF} Bus Driver\n");
		strcat(str,"{FFFF00}Salary: {008000}$45{FFFFFF}\n");
		strcat(str,"{FFFF00}Required Level:{FFFFFF} -\n");
		strcat(str,"ProTip: use /ado to tell your bus route, example: '/ado Route: LS-LV'\n");

		ShowPlayerDialog(playerid,DIALOG_BUS_INFO,DIALOG_STYLE_MSGBOX,"Bus Driver Job Info",str,"Close","");
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.5,764.2607,-1304.5879,13.5613)) { // mower
		new str[400];
		strcat(str,"{FFFF00}Job:{FFFFFF} Mower\n");
		strcat(str,"{FFFF00}Salary: {008000}$10{FFFFFF}\n");
		strcat(str,"{FFFF00}Required Level:{FFFFFF} -\n");

		ShowPlayerDialog(playerid,DIALOG_MOWER_INFO,DIALOG_STYLE_MSGBOX,"Mower Job Info",str,"Close","");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You're not on any info point");
}

CMD:resetpmoney(playerid, params[])
{
    new
    	msg[128],
        idx;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1,"Usage: /resetpmoney [id]");

    /* Check Is Player Connected To Server */
    if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1,"ERROR: Player Is Not Connected");

    /* If Player Have Money Below 0 */
    //if(GetPlayerMoney(idx) < 0) return CmdError(playerid, "Player Money Is Below 0");

    /* Reset The Player Money */
    GivePlayerMoney(idx, -GetPlayerMoney(idx));
    SendClientMessage(idx, -1, "{00FF00}[ADMIN CMD]{AA0000}[RESET MONEY]{FFFFFF} Your Money Has Been Reseted By Admin");
    format(msg,sizeof(msg),"{00FF00}[ADMIN CMD]{AA0000}[RESET MONEY]{FFFFFF} %s Money Has Been Reseted By Admin", RetPname(playerid));
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:setscore(playerid, params[])
{
	new
		sc;
	if(!IsPlayerAdmin(playerid)) return 0;

	if(sscanf(params,"i", sc)) return SendClientMessage(playerid, -1, "Usage: /setscore [score]");
	SetPlayerScore(playerid, sc);
	return 1;
}

CMD:repairweapon(playerid, params[])
{
	new text_gunmaker[1000];

	if(!IsPlayerInRangeOfPoint(playerid,1.5,-752.7269,-131.6847,65.8281)) return SendClientMessage(playerid,-1,"ERROR: You're too far away from gun making point");
	if(!pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You're not a gun maker");
	
	strcat(text_gunmaker,"{00FF00}Name\t{00FF00}Gun Parts\n");
	strcat(text_gunmaker,"Colt45\t3\n");
	strcat(text_gunmaker,"Desert Eagle\t3\n");
	strcat(text_gunmaker,"Rifle\t3\n");
	strcat(text_gunmaker,"Shotgun\t3\n");

	ShowPlayerDialog(playerid,DIALOG_REPAIRGUN,DIALOG_STYLE_TABLIST_HEADERS,"Gun Maker",text_gunmaker,"Repair","Close");
	return 1;
}

CMD:makeammo(playerid, params[])
{
	new text_gunmaker[1000];

	if(!IsPlayerInRangeOfPoint(playerid,1.5,-752.7269,-131.6847,65.8281)) return SendClientMessage(playerid,-1,"ERROR: You're too far away from gun making point");
	if(!pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You're not a gun maker");
	
	strcat(text_gunmaker,"{00FF00}Name\t{00FF00}Ammo\t{00FF00}Gun Parts\n");
	strcat(text_gunmaker,"Colt45\t17\t1\n");
	strcat(text_gunmaker,"Desert Eagle\t7\t3\n");
	strcat(text_gunmaker,"Rifle\t4\t6\n");
	strcat(text_gunmaker,"Shotgun\t8\t6\n");

	ShowPlayerDialog(playerid,DIALOG_MAKEAMMO,DIALOG_STYLE_TABLIST_HEADERS,"Gun Maker",text_gunmaker,"Make","Close");
	return 1;
}

CMD:makegun(playerid, params[])
{
	new text_gunmaker[1000];

	if(!IsPlayerInRangeOfPoint(playerid,1.5,-752.7269,-131.6847,65.8281)) return SendClientMessage(playerid,-1,"ERROR: You're too far away from gun making point");
	if(!pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You're not a gun maker");
	
	strcat(text_gunmaker,"{00FF00}Name\t{00FF00}Gun Parts\n");
	strcat(text_gunmaker,"Colt45\t3\n");
	strcat(text_gunmaker,"Desert Eagle\t7\n");
	strcat(text_gunmaker,"Rifle\t16\n");
	strcat(text_gunmaker,"Shotgun\t14\n");

	ShowPlayerDialog(playerid,DIALOG_MAKEGUN,DIALOG_STYLE_TABLIST_HEADERS,"Gun Maker",text_gunmaker,"Make","Close");
	return 1;
}

CMD:job(playerid, params[])
{
	new
		opt1[12],
		opt2[80];
	if(sscanf(params,"p< >s[12]s[80]", opt1, opt2)) { 
		return SendClientMessage(playerid, -1, "Usage: /job [join | quit] [jobname]");
	}

	if(!strcmp(opt1,"join",false)) {
		if(!strcmp(opt2,"gun maker",false) || !strcmp(opt2,"gunmaker",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,-757.2897,-133.7420,65.8281)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from this job point");
			if(GetPlayerScore(playerid) < 3) return SendClientMessage(playerid, -1, "ERROR: You need to be level 3 to join this job");
			if(pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You're already joined this job");
			if(
				pJob[playerid][Mechanic] ||
				pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You cant join to this job as you already joined in another job");
			pJob[playerid][Gunmaker] = true;
			SendClientMessage(playerid, -1, "You're now a Gun Maker");
			return 1;
		}
		if(!strcmp(opt2,"mechanic",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,2139.5847,-1733.7576,17.2891)) return SendClientMessage(playerid, -1, "ERROR: You're not near by Mechanic Job Point");
			if(GetPlayerScore(playerid) < 2) return SendClientMessage(playerid, -1, "ERROR: You need to be level 2 to join this job");
			if(pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're already joined this job");
			if(
				pJob[playerid][Gunmaker] ||
				pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You cant join to this job as you already joined in another job");
			pJob[playerid][Mechanic] = true;
			SendClientMessage(playerid, -1, "You're now a Mechanic");
			return 1;
		}
		if(!strcmp(opt2,"trucker",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,-49.8569,-269.3626,6.6332)) return SendClientMessage(playerid, -1, "ERROR: You're not near by the Job Point");
			if(GetPlayerScore(playerid) < 2) return SendClientMessage(playerid, -1, "ERROR: You need to be level 2 to join this job");
			if(pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You're already joined this job");
			if(
				pJob[playerid][Mechanic] ||
				pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You cant join to this job as you already joined in another job");
			pJob[playerid][Trucker] = true;
			SendClientMessage(playerid, -1, "You're now a Trucker");
			return 1;
		}
		else return SendClientMessage(playerid, -1, "ERROR: Invalid Option"); 
	}
	if(!strcmp(opt1,"quit",false)) {
		if(!strcmp(opt2,"gum maker",false) || !strcmp(opt2,"gunmaker",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,-757.2897,-133.7420,65.8281)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from this job point");
			if(!pJob[playerid][Gunmaker]) return SendClientMessage(playerid, -1, "ERROR: You're not joined this job");
			pJob[playerid][Gunmaker] = false;
			SendClientMessage(playerid, -1, "You quit from this job");
			return 1;
		}
		if(!strcmp(opt2,"mechanic",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,2139.5847,-1733.7576,17.2891)) return SendClientMessage(playerid, -1, "ERROR: You're not near by Mechanic Job Point");
			if(!pJob[playerid][Mechanic]) return SendClientMessage(playerid, -1, "ERROR: You're not joined this job");
			pJob[playerid][Mechanic] = false;
			SendClientMessage(playerid, -1, "You quit from this job");
			return 1;
		}
		if(!strcmp(opt2,"trucker",false)) {
			if(!IsPlayerInRangeOfPoint(playerid,1.5,-49.8569,-269.3626,6.6332)) return SendClientMessage(playerid, -1, "ERROR: You're not near by the Job Point");
			if(!pJob[playerid][Trucker]) return SendClientMessage(playerid, -1, "ERROR: You're not joined this job");
			pJob[playerid][Trucker] = false;
			SendClientMessage(playerid, -1, "You quit from this job");
			return 1;
		}
		else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option"); 
}

CMD:inventory(playerid, params[])
{
	return 1;
}

CMD:heal(playerid, params[])
{
	new
		idx;

	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /heal [playerid]");
		if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player is not Connected");
		SetPlayerHealth(idx, 100.0);
		SendClientMessage(playerid, -1, "Player healed");
		SendClientMessage(idx, -1, "{00FF00}[ADMIN CMD]{AA0000}[HEAL]{FFFFFF} You Has Been Healed By Admin");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:sweeper(playerid, params[])
{
	new bool:found;
	for(new i; i < sizeof(SweeperVeh); i++)
	{
		if(IsPlayerInVehicle(playerid, SweeperVeh[i])) {
			found = true;
			break;
		}
	}
	if(!found) return SendClientMessage(playerid, -1, "ERROR: You're not in any sweeper");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 574) return SendClientMessage(playerid, -1, "ERROR: You're not in any sweeper");
	if(pMission[playerid][Sweeper]) return SendClientMessage(playerid, -1, "ERROR: You're already taking this job");
	pMission[playerid][Sweeper] = true;
	SetPlayerCheckpoint(playerid,1324.2096,-864.3158,39.5781,8.0);
	SendClientMessage(playerid, -1, "Follow the checkpoint to finish the job"); 
	return 1;
}

CMD:e(playerid, params[]) return cmd_engine(playerid, params);

CMD:engine(playerid, params[])
{
	new
		msg[128],
		vehicleid = GetPlayerVehicleID(playerid),
		engine,
		lights,
		alarm,
		doors,
		bonnet,
		boot,
		objective;
	new Float:h;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "ERROR: You must be in a vehicle to use this command");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "ERROR: You must be the driver of the vehicle");
	// for(new i; i < MAX_PLAYERS; i++)
	// {
	// 	if(GetPlayerVehicleID(playerid) == pVehicle[i][ID]) {
	// 		if(i != playerid) {
	// 			return SendClientMessage(playerid, -1, "ERROR: You don't have the key to manage this vehicle");
	// 		}
	// 	}
	// }
	if(HasNoEngine(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, -1, "ERROR: This vehicle has no engine");
	GetVehicleHealth(GetPlayerVehicleID(playerid), h);
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(engine == 0) {
		if(h <= 260) return SendClientMessage(playerid, -1, "ERROR: The engine is broken!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][RadiatorHealth] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Radiator is broken!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Oil] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: The oil is dried!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Fuel] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Out of Fuel!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Battery] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Battery is Dead!");
		SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
		//format(msg,sizeof(msg),"{D6A4D9}* %s starts the vehicle engine", RetPname(playerid,1));
		cmd_me(playerid, "starts the vehicle engine");
		//ProxMsg(30.0,playerid,msg,-1);
		return 1;
	}
	if(engine == 1) {
		SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
		//format(msg,sizeof(msg),"{D6A4D9}* %s turns off the vehicle engine", RetPname(playerid,1));
		cmd_me(playerid, "turns off the vehicle engine");
		//ProxMsg(30.0,playerid,msg,-1);
		return 1;
	}
	if(engine == VEHICLE_PARAMS_UNSET) {
		if(h <= 260) return SendClientMessage(playerid, -1, "ERROR: The engine is broken!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][RadiatorHealth] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Radiator is broken!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Oil] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: The oil is dried!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Fuel] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Out of Fuel!");
		if(IsPlayerInVehicle(playerid, pVehicle[playerid][ID]) && pVehicle[playerid][Battery] <= 0.0) return SendClientMessage(playerid, -1, "ERROR: Battery is Dead!");
		SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
		//format(msg,sizeof(msg),"{D6A4D9}* %s starts the vehicle engine", RetPname(playerid,1));
		cmd_me(playerid, "starts the vehicle engine");
		//ProxMsg(30.0,playerid,msg,-1);
		return 1;
	}
	return 0;
}

CMD:gmx(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
    {
        SendRconCommand("gmx");
        return 1;
    }
    return 0;
}

CMD:money(playerid, params[])
{
    new money;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "i", money)) return SendClientMessage(playerid, -1, "Usage: /money [amount]");

    GivePlayerMoney(playerid, money);
    return 1;
}

CMD:togglemaptp(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	if(ToggleMapTP[playerid]) {
		ToggleMapTP[playerid] = false;
		SendClientMessage(playerid, -1, "Toggle Off");
		return 1;
	}
	else if(!ToggleMapTP[playerid]) {
		ToggleMapTP[playerid] = true;
		SendClientMessage(playerid, -1, "Toggle On");
		return 1;
	}
	return 0;
}

CMD:qna(playerid, params[]) 
{
	new
		opt[80],
		text[128],
		msg[200];
	if(!sPChannel[qna]) return SendClientMessage(playerid, -1, "ERROR: This channel has been disabled by admin");
	if(sscanf(params, "p< >s[80]s[128]", opt, text)) return SendClientMessage(playerid, -1, "Usage: /qna [question | answer] [text]");

	if(!strcmp(opt,"question",false)) {
		format(msg,sizeof(msg),"{FFFF00}[Q&A]{FFFFFF}{FF00FF}[Question]{FFFFFF} %s: %s", RetPname(playerid), text);
		SendClientMessageToAll(-1,msg);
		return 1;
	}
	if(!strcmp(opt,"answer",false)) {
		format(msg,sizeof(msg),"{FFFF00}[Q&A]{FFFFFF}{008000}[Answer]{FFFFFF} %s: %s", RetPname(playerid), text);
		SendClientMessageToAll(-1,msg);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
}

CMD:ping(playerid, params[])
{
	new msg[80];
	format(msg, sizeof(msg), "Pong!, (%dms)", GetPlayerPing(playerid));
	SendClientMessage(playerid, -1, msg);
	return 1;
}

CMD:b(playerid, params[])
{
	new 
		msg[200],
		text[200];
	if(sscanf(params, "s[200]", text)) return SendClientMessage(playerid, -1, "Usage: /b [text]");
	format(msg,sizeof(msg),"%s: (( %s ))", RetPname(playerid), text);
	ProxMsg(30.0,playerid,msg,0xAAAAAAAA);
	return 1;
}

CMD:ooc(playerid, params[])
{
	new
		text[200];
	if(!sPChannel[ooc]) return SendClientMessage(playerid, -1, "ERROR: This channel has been disabled by admin");
	if(sscanf(params, "s[200]", text)) return SendClientMessage(playerid, -1, "Usage: /o(oc) [text]");
	foreach(new i : Player) if(IsPlayerLoggedIn[i]) SendClientMessageEx(i,-1,"(( %s: %s ))",RetPname(playerid),text);
	return 1;
}

CMD:me(playerid, params[])
{
	new
		msg[300],
		text[300];
	if(sscanf(params, "s[300]", text)) return SendClientMessage(playerid, -1, "Usage: /me [text]");
	format(msg,sizeof(msg),"{D6A4D9}* %s %s", RetPname(playerid,1), text);
	ProxMsg(30.0,playerid,msg,-1);
	return 1;
}

CMD:do(playerid, params[])
{
	new
		msg[300],
		text[300];
	if(sscanf(params, "s[300]", text)) return SendClientMessage(playerid, -1, "Usage: /do [text]");
	format(msg,sizeof(msg),"{D6A4D9}* %s (( %s ))", text, RetPname(playerid));
	ProxMsg(30.0,playerid,msg,-1);
	return 1;
}

CMD:cancel(playerid, params[])
{
	new
		opt[80];
	if(sscanf(params, "s[80]", opt)) return SendClientMessage(playerid, -1, "Usage: /cancel [material | sweeper | product | component]");

	if(!strcmp(opt,"material",false)) {
		if(!pMission[playerid][Material]) return SendClientMessage(playerid, -1, "ERROR: You're not in material mission");
		pMission[playerid][Material] = false;
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, -1, "Material Mission has been canceled");
		return 1;
	}
	if(!strcmp(opt,"sweeper",false)) {
		if(!pMission[playerid][Sweeper]) return SendClientMessage(playerid, -1, "ERROR: You're not taking this job");
		pMission[playerid][Sweeper] = false;
		DisablePlayerCheckpoint(playerid);
		RemovePlayerFromVehicle(playerid);
		SetSweeperToRespawn2(2000);
		SendClientMessage(playerid, -1, "job canceled");
		return 1;
	}
	if(!strcmp(opt,"product",false)) {
		if(!pMission[playerid][Product]) return SendClientMessage(playerid, -1, "ERROR: You're not in product mission");
		pMission[playerid][Product] = false;
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, -1, "Product Mission has been canceled");
		return 1;
	}
	if(!strcmp(opt,"component",false)) {
		if(!pMission[playerid][Component]) return SendClientMessage(playerid, -1, "ERROR: You're not in component mission");
		pMission[playerid][Component] = false;
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, -1, "Component Mission has been canceled");
		return 1;
	}
	if(!strcmp(opt,"bus",false)) {
		if(!pMission[playerid][BusDriver]) return SendClientMessage(playerid, -1, "ERROR: You're not in bus driver mission");
		for(new i; i < 7; i++)
		{
			if(!strcmp(vBus[i][Owner],RetPname(playerid))) {
				if(!IsPlayerInVehicle(playerid, vBus[i][ID])) return SendClientMessage(playerid, -1, "ERROR: You're not in your bus");
				pMission[playerid][BusDriver] = false;
				strcpy(vBus[i][Owner],"None");
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, -1, "Bus Driver Mission has been canceled");
				return 1;
			}
		}
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
}

CMD:getmaterials(playerid, params[])
{
	new
		matcount;
	matcount = pInventory[playerid][Material];
	if(!IsPlayerInRangeOfPoint(playerid,1.5,613.0717,1549.8906,5.0001)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from material point");
	if(pInventory[playerid][Material] == 100 || (matcount + 3) > 100) return SendClientMessage(playerid, -1, "ERROR: You can't get more material");
	if(pMission[playerid][Material]) return SendClientMessage(playerid, -1, "ERROR: You're already taking this mission");
	if(GetPlayerMoney(playerid) < 250) return SendClientMessage(playerid, -1, "ERROR: Not Enough Money");
	GivePlayerMoney(playerid, -250);
	pMission[playerid][Material] = true;
	SetPlayerCheckpoint(playerid,2508.7227,-2118.3533,13.5469,8.0);
	SendClientMessage(playerid, -1, "Go to checkpoint in order to collect your materials");
	SendClientMessage(playerid, -1, "you can cancel this mission using command /cancel");
	return 1;
}

CMD:craft(playerid, params[])
{
	new
		opt[80];

	if(sscanf(params,"s[80]",opt)) { 
		return SendClientMessage(playerid, -1, "Usage: /craft [craftname]");
	}
	if(!strcmp(opt,"gunpart",false)) {
		if(!IsPlayerInRangeOfPoint(playerid,1.5,-12.9450,2350.7974,24.1406)) return SendClientMessage(playerid, -1, "ERROR: You're too far away from gun crafting point");
		if(pInventory[playerid][Material] < 3) return SendClientMessage(playerid, -1, "ERROR: Not Enough Materials, 3 Materials For 1 Gun Part");
		if(pInventory[playerid][GunPart] == 50) return SendClientMessage(playerid, -1, "ERROR: You can't craft more gun parts");
		pInventory[playerid][Material] -= 3;
		SendClientMessage(playerid, -1, "3 Materials Used, Crafting in progress...");
		ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.0, 1, 0, 0, 1, 0);
		pState[playerid][CraftingGun] = true;
		SetTimerEx("GunCraft", 15000, 0, "i", playerid);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
}

CMD:setint(playerid, params[])
{
	new
		msg[128],
		idx,
		vw;
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "ii", idx, vw)) return SendClientMessage(playerid, -1, "Usage: /setint [playerid] [interior id]");

		if(idx == INVALID_PLAYER_ID || !IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Invalid Player ID");

		SetPlayerInterior(idx, vw);
		format(msg,sizeof(msg),"{00FF00}[ADMIN CMD]{AA0000}[SETINT]{FFFFFF} Your Interior Has Been Set to %d by Admin", vw);
		SendClientMessage(idx, -1, msg);
		format(msg,sizeof(msg),"{00FF00}[ADMIN CMD]{AA0000}[SETINT]{FFFFFF} %s Interior Has Been Set to %d by Admin", RetPname(idx), vw);
		SendClientMessage(playerid, -1, msg);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have a permissions to use this command");
}

CMD:setvw(playerid, params[])
{
	new
		msg[128],
		idx,
		vw;
	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "ii", idx, vw)) return SendClientMessage(playerid, -1, "Usage: /setvw [playerid] [world id]");

		if(idx == INVALID_PLAYER_ID || !IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Invalid Player ID");

		SetPlayerVirtualWorld(idx, vw);
		format(msg,sizeof(msg),"{00FF00}[ADMIN CMD]{AA0000}[SETVW]{FFFFFF} Your Virtual World Has Been Set to %d by Admin", vw);
		SendClientMessage(idx, -1, msg);
		format(msg,sizeof(msg),"{00FF00}[ADMIN CMD]{AA0000}[SETVW]{FFFFFF} %s Virtual World Has Been Set to %d by Admin", RetPname(idx), vw);
		SendClientMessage(playerid, -1, msg);
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: You don't have a permissions to use this command");
}

CMD:adminduty(playerid, params[])
{
	if(!pAccount[playerid][Admin]) return SendClientMessage(playerid, -1, "ERROR: You're not an Administrator");
	new
		opt[10];

	if(sscanf(params, "s[10]", opt)) return SendClientMessage(playerid, -1, "Usage: /adminduty [on|off]");

	if(!strcmp(opt,"on",true)) {
		if(pStaffDuty[playerid][Admin]) return SendClientMessage(playerid, -1, "ERROR: You're already on duty as Administrator");
		pStaffDuty[playerid][Admin] = true;
		SetPlayerColor(playerid, 0x00FF00FF);
		SendClientMessage(playerid, -1, "{00FF00}[ADMIN DUTY]{FFFFFF} You has been on duty as Administrator");
		return 1;
	}
	if(!strcmp(opt,"off",true)) {
		if(!pStaffDuty[playerid][Admin]) return SendClientMessage(playerid, -1, "ERROR: You're already off duty as Administrator");
		pStaffDuty[playerid][Admin] = false;
		SetPlayerColor(playerid, 0xFFFFFFFF);
		SendClientMessage(playerid, -1, "{00FF00}[ADMIN DUTY]{FFFFFF} You has been off duty as Administrator");
		return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Invalid Option");
}

CMD:kick(playerid, params[])
{
	new
		msg[280],
		idx,
		reason[80];

	if(pStaffDuty[playerid][Admin] || IsPlayerAdmin(playerid)) {
		if(sscanf(params, "is[80]", idx, reason)) return SendClientMessage(playerid, -1, "Usage: /kick [playerid] [reason]");
		if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
		if(IsPlayerAdmin(idx)) return SendClientMessage(playerid, -1, "ERROR: You Can't Kick RCON Admin");
		if(idx == playerid) return SendClientMessage(playerid, -1, "ERROR: You Can't Kick Yourself");
		for(new i = 0; i < 50; i++)
	    {
	        SendClientMessage(idx,-1,"");
	    }
	    format(msg,sizeof(msg),"{FF0000}[KICK]{FFFF00} %s Has Been Kicked By Admin %s, reason: %s", RetPname(idx), RetPname(playerid),reason);
	    SendClientMessageToAll(-1, msg);
	    Kick2(idx,100);
	    return 1;
	}
	else return SendClientMessage(playerid, -1, "ERROR: Only Admins and RCON Admins can use this command");
}

CMD:beadmin(playerid, params[])
{
	new
		idx;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /beadmin [playerid]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
	if(pAccount[idx][Admin]) return SendClientMessage(playerid, -1, "ERROR: Player Is An Admin");
	pAccount[idx][Admin] = true;
	SendClientMessage(idx, -1, "{00FF00}[ADMIN PROMOTE]:{FFFFFF} You Has Been Promoted As an Administrator By RCON Administrator");
	return 1;
}

CMD:noadmin(playerid, params[])
{
	new
		idx;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /noadmin [playerid]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
	if(!pAccount[idx][Admin]) return SendClientMessage(playerid, -1, "ERROR: Player Is Not An Admin");
	pAccount[idx][Admin] = false;
	if(pStaffDuty[idx][Admin]) { 
		pStaffDuty[idx][Admin] = false;
		SetPlayerColor(playerid, 0xFFFFFFFF);
	}
	SendClientMessage(idx, -1, "{00FF00}[ADMIN PROMOTE]:{FFFFFF} Your Admin Position Has Been Removed By RCON Administrator");
	return 1;
}

CMD:behelper(playerid, params[])
{
	new
		idx;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /behelper [playerid]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
	if(pAccount[idx][Helper]) return SendClientMessage(playerid, -1, "ERROR: Player is a Helper");
	pAccount[idx][Helper] = true;
	SendClientMessage(idx, -1, "{00FF00}[ADMIN PROMOTE]:{FFFFFF} You Has Been Promoted As a Helper By RCON Administrator");
	return 1;
}

CMD:nohelper(playerid, params[])
{
	new
		idx;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, -1, "Usage: /nohelper [playerid]");
	if(!IsPlayerConnected(idx)) return SendClientMessage(playerid, -1, "ERROR: Player Is Not Connected");
	if(!pAccount[idx][Helper]) return SendClientMessage(playerid, -1, "ERROR: Player is not a Helper");
	pAccount[idx][Helper] = false;
	if(pStaffDuty[idx][Helper]) { 
		pStaffDuty[idx][Helper] = false;
		SetPlayerColor(playerid, 0xFFFFFFFF);
	}
	SendClientMessage(idx, -1, "{00FF00}[ADMIN PROMOTE]:{FFFFFF} Your Helper Position has been Removed By RCON Administrator");
	return 1;
}
/* EOS */