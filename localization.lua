SASSTEXT_TITLE="Schnoggo's Simple Assist Ver. " .. GetAddOnMetadata("SimpleAssist", "Version");
SASSTEXT_OPTIONSPACING=-60; -- vertical distance between each TITLE below:
SASSTEXT_SUMMARY="Use the Key Bindings (Main Menu:Key Binding) panel to set up your keys.";
SASSTEXT_BINDING_SET_TITLE="Set Player to Assist";
SASSTEXT_BINDING_SET="Target the player you wish to assist in battle by clicking them or their portrait. Then hit the key you've bound to this function to ''remember'' who to assist.";
SASSTEXT_BINDING_ASSIST_TITLE="Assist Learned Player";
SASSTEXT_BINDING_ASSIST="Hitting this key will select the target of (''assist'') the player you selected with the ''Set Player to Assist.'' If no player is learned, this will assist your current target. Because of the default behavior, it is safe to bind this to your regular Assist key (F).";
SASSTEXT_BINDING_REQ_TITLE="Request Assistance";
SASSTEXT_BINDING_REQ="This key will send a request for others to attack your current target. Addons cannot automatically change targets, so this feature is informational only. Click the OPTIONS tab below to enable additional features.";


SASSTEXT_BUTTON_CLOSE="Close";

SASSTEXT_CHAT_HEAD="You may optionally send a message in chat when requesting assistance. Select which chat channels below:";
SASSTEXT_CHAT_EMOTE="Emote";
SASSTEXT_CHAT_YELL="Yell";
SASSTEXT_CHAT_RAID="Raid";
SASSTEXT_CHAT_PARTY="Party";
SASSTEXT_CHAT_SAY="Say";
SASSTEXT_CHAT_RW="RaidWarning";


SASSTEXT_CUSTOM_CALL_HEAD="You can customize the message sent in chat when requesting assistance:";
SASSTEXT_CUSTOM_CALL_BEFORE="Help ";
SASSTEXT_CUSTOM_CALL_PLAYERNAME=UnitName("player");
SASSTEXT_CUSTOM_CALL_MIDDLE=" in attacking ";
SASSTEXT_CUSTOM_CALL_MOBNAME="[Target]";
SASSTEXT_CUSTOM_CALL_AFTER=".";



SASSTEXT_RTARGET_HEAD="You can assign a ''Raid Target Icon'' to your current target when requesting assistance. You can select which icon:";
SASSTEXT_RTARGET0="No Icon";
SASSTEXT_RTARGET1="Star";
SASSTEXT_RTARGET2="Circle";
SASSTEXT_RTARGET3="Diamond";
SASSTEXT_RTARGET4="Triangle";
SASSTEXT_RTARGET5="Crescent";
SASSTEXT_RTARGET6="Square";
SASSTEXT_RTARGET7="X";
SASSTEXT_RTARGET8="Skull";



BINDING_HEADER_SASS_TITLE = "Simple Assist";
BINDING_NAME_SASS_LEARN = "Set Player to Assist";
BINDING_NAME_SASS_ASSIST = "Assist Learned Player";
BINDING_NAME_SASS_ASK = "Request Assistance";

SASSTEXT = {
	WELCOME="SimpleAssist " .. GetAddOnMetadata("SimpleAssist", "Version") .. " Loaded. Type /sass to change settings.",
	ASSISTING="Assisting",
	CLEARED="Assist Cleared",
	ASSIST_SET="Assist set",
	ASSIST_PENDING="Assist will change when you leave combat. \nQueuing:",
	CLEAR_PENDING="Assist will be cleared when you leave combat. ",
	CHAT_ASSIST="Assist {name} in attacking {target}."
	};

SASSTEXT_ATTACK_EMOTE="to attack";
