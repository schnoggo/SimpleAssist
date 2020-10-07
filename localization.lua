SASSTEXT = {

	TITLE="Schnoggo's Simple Assist Ver. " .. GetAddOnMetadata("SimpleAssist", "Version"),
	WELCOME="SimpleAssist " .. GetAddOnMetadata("SimpleAssist", "Version") .. " Loaded. Type /sass to change settings.",

	TITLESPACING=-12, -- vertical distance between each TITLE below:
	LINESPACING=-8,
	COLWIDTH = 286,

	ASSISTING="Assisting",
	CLEARED="Assist Cleared",
	ASSIST_SET="Assist set",
	ASSIST_PENDING="Assist will change when you leave combat. \nQueuing:",
	CLEAR_PENDING="Assist will be cleared when you leave combat. ",
	CHAT_ASSIST="Assist {name} in attacking {target}.",

INFO_PANEL = {
	"Use the Key Bindings (Main Menu:Key Binding) panel to set up your keys.",
	"*Set Player to Assist",
	"Target the player you wish to assist in battle by clicking them or their portrait. Then hit the key you've bound to this function to ''remember'' who to assist.",
	"*Assist Learned Player",
	"Hitting this key will select the target of (''assist'') the player you selected with the ''Set Player to Assist.'' If no player is learned, this will assist your current target. Because of the default behavior, it is safe to bind this to your regular Assist key (F).",
	"*Request Assistance",
	"This key will send a request for others to attack your current target. Addons cannot automatically change targets, so this feature is informational only. Click the OPTIONS tab below to enable additional features."
},

BUTTON_CLOSE="Close",

CHAT_HEAD="You may optionally send a message in chat when requesting assistance. Select which chat channels below:",
CHAT_EMOTE="Emote",
CHAT_YELL="Yell",
CHAT_RAID="Raid",
CHAT_PARTY="Party",
CHAT_SAY="Say",
CHAT_RW="RaidWarning",


CUSTOM_CALL_HEAD="You can customize the message sent in chat when requesting assistance:",
CUSTOM_CALL_BEFORE="Help ",
CUSTOM_CALL_PLAYERNAME=UnitName("player"),
CUSTOM_CALL_MIDDLE=" in attacking ",
CUSTOM_CALL_MOBNAME="[Target]",
CUSTOM_CALL_AFTER=".",



RTARGET_HEAD="You can assign a ''Raid Target Icon'' to your current target when requesting assistance. You can select which icon:",
RTARGET0="No Icon",
RTARGET1="Star",
RTARGET2="Circle",
RTARGET3="Diamond",
RTARGET4="Triangle",
RTARGET5="Crescent",
RTARGET6="Square",
RTARGET7="X",
RTARGET8="Skull",



BINDING_HEADER_SASS_TITLE = "Simple Assist",
BINDING_NAME_SASS_LEARN = "Set Player to Assist",
BINDING_NAME_SASS_ASSIST = "Assist Learned Player",
BINDING_NAME_SASS_ASK = "Request Assistance",

ATTACK_EMOTE="to attack"
}
