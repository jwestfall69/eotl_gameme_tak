# eotl_gameme_tak (Taunt After Kill)
This is a TF2 souncemod plugin I wrote for the [EOTL](https://www.endofthelinegaming.com/) community.

When a player is killed and the killer taunts them, this plugin will log the following events.

taunt_after_kill<br/>
taunted_after_death<br/>

These can then be added as actions in [GameMe](https://www.gameme.com) for tracking / points.  ie:

[Taunted After Death](https://eotl.gameme.com/actioninfo/730)<br>
[Taunt After Kill](https://eotl.gameme.com/actioninfo/726)

### ConVars
<hr>

**eotl_gameme_tak_taunt_time [seconds]**

  When a player dies, this is the number of seconds the killer has
  to taunt them for it to count as a taunt after kill.

  Default: 3
