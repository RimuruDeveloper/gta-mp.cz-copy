
enum player_struct
{
	id,
	Name[MAX_PLAYER_NAME],
	Password[65],
	Salt[17],

	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:Angle,

	Cache:Cache_ID,
	bool:IsLoggedIn,
}
new Player[MAX_PLAYERS][player_struct];


#define GetPlayerData(%0,%1) 		Player[%0][%1]
#define SetPlayerData(%0,%1,%2)		Player[%0][%1] = %2
#define AddPlayerData(%0,%1,%2,%3) 	Player[%0][%1] %2 %3


forward OnPlayerKick(playerid);
public OnPlayerKick(playerid)
{
	if(IsPlayerConnected(playerid)) return Kick(playerid);
	return false;
}
#define Kick(%0) SetTimerEx("OnPlayerKick", 110, false, "i", %0)