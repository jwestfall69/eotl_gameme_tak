#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <tf2>

#define PLUGIN_AUTHOR  "ack"
#define PLUGIN_VERSION "0.3"

public Plugin myinfo = {
	name = "eotl_gameme_tak",
	author = PLUGIN_AUTHOR,
	description = "GameMe stat for taunt after kill",
	version = PLUGIN_VERSION,
	url = ""
};

enum struct PlayerState {
    int killer;
    float deathTime;
}

PlayerState g_playerStates[MAXPLAYERS + 1];
ConVar g_cvTauntTime;

public void OnPluginStart() {
    LogMessage("version %s starting", PLUGIN_VERSION);

    g_cvTauntTime = CreateConVar("eotl_gameme_tak_taunt_time", "3", "max seconds after kill for a taunt register as a taunt after kill");
    HookEvent("player_death", EventPlayerDeath);

}

public void OnClientConnected(int client) {
    ResetPlayerState(client);
}

public Action EventPlayerDeath(Handle event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    int killer = GetClientOfUserId(GetEventInt(event, "attacker"));

    g_playerStates[client].killer = killer;
    g_playerStates[client].deathTime = GetGameTime();

    return Plugin_Continue;
}

public void TF2_OnConditionAdded(int taunter, TFCond condition) {

    if(condition != TFCond_Taunting) {
        return;
    }

    // check taunter recently killed someoone
    for(int client = 1; client <= MaxClients; client++) {

        if(!IsClientInGame(client)) {
            continue;
        }

        if(IsPlayerAlive(client)) {
            continue;
        }

        if(g_playerStates[client].killer != taunter) {
            continue;
        }

        float timeDiff = GetGameTime() - g_playerStates[client].deathTime;
        if(timeDiff > g_cvTauntTime.FloatValue) {
            continue;
        }

        ResetPlayerState(client);
        LogMessage("%N did a taunt after kill on %N (%.1f seconds ago)", taunter, client, timeDiff);
        LogToGame("\"%L\" triggered \"taunt_after_kill\"", taunter);
        LogToGame("\"%L\" triggered \"taunted_after_death\"", client);
    }
}

void ResetPlayerState(int client) {
    g_playerStates[client].killer = -1;
    g_playerStates[client].deathTime = 0.0;
}