
static bool:gRequestClass[MAX_PLAYERS];


static gRegCameraTimer[MAX_PLAYERS],
       gRegCameraNumber[MAX_PLAYERS];

static gRegPasswordAttempts[MAX_PLAYERS];

#define MAX_REG_CAMERA_POS		19
enum reg_camera_pos
{
	Float:rcX,
	Float:rcY,
	Float:rcZ,
	Float:rcLX,
	Float:rcLY,
	Float:rcLZ,
}
static gRegCameraPos[MAX_REG_CAMERA_POS][reg_camera_pos] = 
{
	{1826.7866, -1672.7229, 13.0750, 1827.4474, -1673.3661, 13.4618},
	{1727.2889, 1472.2411, 14.1693, 1726.4728, 1471.7032, 14.3802},
	{2067.5703, 1439.5208, 17.3412, 2068.1445, 1440.3271, 17.4821},
	{1727.2889, 1472.2411, 14.1693, 1726.4728, 1471.7032, 14.3802},
	{-2674.7488, 388.0626, 4.0132, -2673.8801, 387.6731, 4.3192},
	{2840.1877, -1612.7880, 23.3090, 2839.6040, -1613.5999, 23.2960},
	{2364.2390, 2167.9202, 13.9316, 2363.4077, 2167.4106, 14.1532},
	{2484.1514, 2129.6802, 14.4170, 2483.1921, 2129.9626, 14.4326},
	{1727.2889, 1472.2411, 14.1693, 1726.4728, 1471.7032, 14.3802},
	{487.3781, -1468.7429, 23.6802, 483.7449, -1545.9088, 23.7081},
	{-1840.6877, 907.5088, 31.3310, -1839.8691, 908.0293, 31.5739},
	{2336.4109, -1482.1517, 24.2376, 2337.1477, -1482.8229, 24.3187},
	{2067.5703, 1439.5208, 17.3412, 2068.1445, 1440.3271, 17.4821},
	{2137.7048, 2172.3809, 13.6339, 2138.3540, 2171.6472, 13.8341},
	{2364.2390, 2167.9202, 13.9316, 2363.4077, 2167.4106, 14.1532},
	{2484.1514, 2129.6802, 14.4170, 2483.1921, 2129.9626, 14.4326},
	{2120.3232, -1735.7609, 21.6487, 2119.5576, -1735.1245, 21.7407},
	{1536.5770, -1687.1340, 26.7069, 1537.2950, -1686.5640, 26.3081},
	{2022.6130, -1432.0500, 17.6541, 2022.9890, -1431.1240, 17.6552}
};

static const gWeakPasswords[][] = {
   	"123123", "12345", "123456",
   	"1111", "1234512345", "123123123"
};

stock player_OnPlayerConnect(playerid)
{
	SetSpawnInfo(playerid, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

	static const empty_player[player_struct];
	Player[playerid] = empty_player;
	
	gRequestClass[playerid] = false;
    gRegCameraTimer[playerid] = -1;
    gRegCameraNumber[playerid] = -1;
    gRegPasswordAttempts[playerid] = 0;

    GetPlayerName(playerid, Player[playerid][Name], MAX_PLAYER_NAME);
}

stock player_OnPlayerDisconnect(playerid)
{
	if(cache_is_valid(Player[playerid][Cache_ID]))
	{
		cache_delete(Player[playerid][Cache_ID]);
		Player[playerid][Cache_ID] = MYSQL_INVALID_CACHE;
	}
	OnPlayerSave(playerid);
}

stock player_OnPlayerRequestClass(playerid)
{
	if(!gRequestClass[playerid])
	{
		for(new i; i < sizeof(logo); i++) TextDrawShowForPlayer(playerid, logo[i]);
		PlayAudioStreamForPlayer(playerid, "https://62.210.90.211/audio/gta_sa_theme.mp3");
		TogglePlayerControllable(playerid, false);

		gRegCameraNumber[playerid] = random(sizeof(gRegCameraPos));
		SetPlayerCameraPos(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcX], gRegCameraPos[gRegCameraNumber[playerid]][rcY], gRegCameraPos[gRegCameraNumber[playerid]][rcZ]);
		SetPlayerCameraLookAt(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcLX], gRegCameraPos[gRegCameraNumber[playerid]][rcLY], gRegCameraPos[gRegCameraNumber[playerid]][rcLZ]);
		SetPlayerPos(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcX], gRegCameraPos[gRegCameraNumber[playerid]][rcY], gRegCameraPos[gRegCameraNumber[playerid]][rcZ]);

		gRegCameraTimer[playerid] = SetTimerEx("OnPlayerChangeRegCamera", 10 * 1000, true, "d", playerid);

		static const string[] = "SELECT * FROM `players` WHERE `nickname` = '%e' LIMIT 1";
	    new query[sizeof(string) - 2 + MAX_PLAYER_NAME];
		mysql_format(handle, query, sizeof(query), string, Player[playerid][Name]);
		mysql_tquery(handle, query, "OnPlayerCheck", "d", playerid);

		gRequestClass[playerid] = true;
	}
}

forward OnPlayerChangeRegCamera(playerid);
public OnPlayerChangeRegCamera(playerid)
{
	gRegCameraNumber[playerid] = random(sizeof(gRegCameraPos));
	SetPlayerCameraPos(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcX], gRegCameraPos[gRegCameraNumber[playerid]][rcY], gRegCameraPos[gRegCameraNumber[playerid]][rcZ]);
	SetPlayerCameraLookAt(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcLX], gRegCameraPos[gRegCameraNumber[playerid]][rcLY], gRegCameraPos[gRegCameraNumber[playerid]][rcLZ]);
	SetPlayerPos(playerid, gRegCameraPos[gRegCameraNumber[playerid]][rcX], gRegCameraPos[gRegCameraNumber[playerid]][rcY], gRegCameraPos[gRegCameraNumber[playerid]][rcZ]);
	return true;
}

forward OnPlayerCheck(playerid);
public OnPlayerCheck(playerid)
{
	if(cache_num_rows() > 0)
	{
		cache_get_value(0, "password", Player[playerid][Password], 65);
		cache_get_value(0, "salt", Player[playerid][Salt], 17);

		Player[playerid][Cache_ID] = cache_save();

		Dialog_Show(playerid, Dialog:Login);
	}
	else
	{
		Dialog_Show(playerid, Dialog:Register);
	}
	return true;
}

DialogCreate:Login(playerid)
{
	Dialog_Open(playerid, Dialog:Login, DIALOG_STYLE_PASSWORD, !"Авторизация", "{ffffff}Добро пожаловать на GTA-MULTIPLAYER.CZ игровой сервер!\n\n\
		{ff0080}Пожалуйста, введите пароль для входа в свой игровой аккаунт.\n", !"Вход", !"Закрыть");
}
DialogCreate:LoginPasswordError(playerid)
{
	Dialog_Open(playerid, Dialog:LoginPasswordError, DIALOG_STYLE_MSGBOX, !"Авторизация", "{ffffff}Вы ввели неправильный пароль!\n", !"Назад", !"");
}
DialogResponse:Login(playerid, response, listitem, inputtext[])
{
    if(!response) return Kick(playerid);

    new pass_hash[65];
	SHA256_PassHash(inputtext, Player[playerid][Salt], pass_hash, 65);

    if(!strcmp(pass_hash, Player[playerid][Password]))
    {
    	KillTimer(gRegCameraTimer[playerid]);
    	StopAudioStreamForPlayer(playerid);

        cache_set_active(Player[playerid][Cache_ID]);

        LoadPlayerData(playerid);

        cache_delete(Player[playerid][Cache_ID]);
		Player[playerid][Cache_ID] = MYSQL_INVALID_CACHE;

		SetSpawnInfo(playerid, 0, 0, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], Player[playerid][Angle], 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);

        new version[10];
    	GetPlayerVersion(playerid, version, sizeof(version));
    	if(strcmp(version, "0.3.7-R4")) SendClientMessage(playerid, 0xFF0000FF, "ВНИМАНИЕ! Вы используете устаревшую версию клиента игры. Скачайте последнюю версию 0.3.7 R4 по адресу GTA-MULTIPLAYER.CZ!");

    	SendClientMessage(playerid, -1, "Вы вошли в аккаунт! Получайте удовольствие от игры на нашем сервере.");
   	}
    else
   	{
   		if(gRegPasswordAttempts[playerid] == 3)
   		{
   			new str[46 - 2 + MAX_PLAYER_NAME];
   			format(str, sizeof(str), "%s был отключён за 3 неудачные попытки авторизации", Player[playerid][Name]);
   			SendClientMessageToAll(0xFF0000FF, str);
   			return Kick(playerid);
   		}
   		gRegPasswordAttempts[playerid] += 1;
   		Dialog_Show(playerid, Dialog:LoginPasswordError);
   	}
    return true;
}
DialogResponse:LoginPasswordError(playerid, response, listitem, inputtext[])
{
	if(response) return Dialog_Show(playerid, Dialog:Login);
	return true;
}

DialogCreate:Register(playerid)
{
	Dialog_Open(playerid, Dialog:Register, DIALOG_STYLE_PASSWORD, !"Регистрация", "{ffffff}Добро пожаловать на GTA-MULTIPLAYER.CZ игровой сервер!\n\n\
		{ff0080}Пожалуйста, введите пароль для регистрации игрового аккаунта. Вы будете использовать этот\n\
		пароль для последующего входа в свой игровой аккаунт!\n", !"Регистрация", !"Закрыть");
}
DialogCreate:RegisterPasswordWeak(playerid)
{
	Dialog_Open(playerid, Dialog:Register, DIALOG_STYLE_MSGBOX, !"Регистрация", "{ffffff}Этот пароль слишком лёгкий!\n", !"Регистрация", !"");
}
DialogResponse:Register(playerid, response, listitem, inputtext[])
{
    if(!response) return Kick(playerid);

    if(CheckWeakPassword(inputtext)) Dialog_Show(playerid, Dialog:RegisterPasswordWeak);

    for (new i = 0; i < 16; i++) Player[playerid][Salt][i] = random(94) + 33;
    SHA256_PassHash(inputtext, Player[playerid][Salt], Player[playerid][Password], 65);

	static const string[] = "INSERT INTO `players` (`nickname`, `password`, `salt`) VALUES ('%e', '%e', '%e')";
    new query[sizeof(string) - 6 + MAX_PLAYER_NAME + 65 + 17];
    mysql_format(handle, query, sizeof(query), string, Player[playerid][Name], Player[playerid][Password], Player[playerid][Salt]);
    mysql_tquery(handle, query, "OnPlayerRegister", "d", playerid);

    KillTimer(gRegCameraTimer[playerid]);
    StopAudioStreamForPlayer(playerid);
    return true;
}
DialogResponse:RegisterPasswordWeak(playerid, response, listitem, inputtext[])
{
	if(response) Dialog_Show(playerid, Dialog:Register);
	return true;
}
stock CheckWeakPassword(const text[])
{
    for(new i; i < sizeof(gWeakPasswords); i++)
    {
    	if(strfind(text, gWeakPasswords[i], true) != -1) return false;
    }
    return true;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    Player[playerid][id] = cache_insert_id();

    Player[playerid][IsLoggedIn] = true;

    SetSpawnInfo(playerid, 0, 0, 1682.7000, -2244.8999, 13.5454, 0.0000, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
    return true;
}

stock LoadPlayerData(playerid)
{
	cache_get_value_int(0, "id", Player[playerid][id]);

	cache_get_value_float(0, "x", Player[playerid][PosX]);
	cache_get_value_float(0, "y", Player[playerid][PosY]);
	cache_get_value_float(0, "z", Player[playerid][PosZ]);
	cache_get_value_float(0, "angle", Player[playerid][Angle]);
	return true;
}

stock OnPlayerSave(playerid)
{
	if(!Player[playerid][IsLoggedIn]) return false;
	GetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
	GetPlayerFacingAngle(playerid, Player[playerid][Angle]);

	new query[91 - 10 + 40 + MAX_PLAYER_NAME];
    mysql_format(handle, query, sizeof(query), "UPDATE `players` SET `x`= '%f', `y`= '%f', `z`= '%f', `angle`= '%f' WHERE `nickname` = '%e'", Player[playerid][PosX], Player[playerid][PosY],
    	Player[playerid][PosZ], Player[playerid][Angle], Player[playerid][Name]);
    mysql_tquery(handle, query);
	return true;
}