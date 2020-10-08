-- Globals:
-- ========
-- our big global object:
SassAddon = {
	addon_loaded = false,
	variables_loaded = false,
	pending_learn = nil,
	myPlayer = {
		name = UnitName("player"),
		classStuff = UnitClass("player")
	},
	-- Init text stuff:
	txt = {
		x = 20,
		y = 30,
		justifyV = "TOP",
		justifyH = "LEFT",
		parent = UIParent, -- SassAddon.panel | SassAddon.panel2 not defined yet
		r = .5,
		g = 1,
		b = .5,
		a = 1,
		col_width = (SASSTEXT.COLWIDTH * 2) + 10;

	};
};


-- boot frame:
local boot_frame = CreateFrame("Frame")
boot_frame:RegisterEvent("ADDON_LOADED")
boot_frame:SetScript(
  "OnEvent", function(frame,event,...)
		if frame == boot_frame then
	    SassAddon.init();
		end
  end
);


-- SimpleAssist_SavedVars = {};




-- default config settings

local SimpleAssistDefaults={
	SimpleAssistPrefsRAID = false,
	SimpleAssistPrefsSAY = false,
	SimpleAssistPrefsYELL = false,
	SimpleAssistPrefsPARTY = false
	};
	SimpleAssistDefaults["CustomChat"]={};
	SimpleAssistDefaults["CustomChat"][1]="Help";
	SimpleAssistDefaults["CustomChat"][2]="in attacking";
	SimpleAssistDefaults["CustomChat"][3]=".";
	SimpleAssistDefaults["version"]=3;

-- My local functions:
-- ====================







-- Event functions



	DEFAULT_CHAT_FRAME:AddMessage('green is the grass',  0.5, 1.0, 0.5, 1);


--- Once the addon is loaded, register all our events and create our frames
--
function SassAddon.init()
	local myPlayer = SassAddon.myPlayer; -- local shortcut
	if ( false == SassAddon.addon_loaded ) then -- only need to load once
		DEFAULT_CHAT_FRAME:AddMessage(SASSTEXT.WELCOME,  0.5, 1.0, 0.5, 1);
		if (not myPlayer.name) then -- hasn't been initialized
			myPlayer.name = UnitName("player");
		end

		-- Register all our events:
		SassAddon.eventframe = CreateFrame("Frame" ); -- the frame to listen to all our events
		local ev = SassAddon.eventframe; -- local shortcut

		-- and register our basic events:
		ev:RegisterEvent("PLAYER_ENTERING_WORLD");
		ev:RegisterEvent("CHAT_MSG_CHANNEL");
		ev:RegisterEvent("VARIABLES_LOADED");
		ev:RegisterEvent("UPDATE_BINDINGS");
		ev:RegisterEvent("PLAYER_LEAVE_COMBAT");
		ev:RegisterEvent("PLAYER_REGEN_ENABLED");

		-- self:RegisterEvent("CHAT_MSG_TEXT_EMOTE"); -- for listening
		ev:SetScript("OnEvent", SassAddon.HandleEvent);


		-- Set up the preference panel:
		SimpleAssist_Options_CreatePanel();

		SassAddon.addon_loaded = true; -- Only load once
	end
end



-- Draws a control currently selected settings panel
-- Uses the cursor values in SassAddon.txt global
-- Assumes all control have an associated label
--
-- @tparam Type of control CheckButton | EditBox
--
function SassAddon.PanelControl(type, name, parent)
	local control_frame;
	local txt = SassAddon.txt;
	if nil == parent then -- if a parent frame wasn't passed, use the current selection
		parent = txt.parent;
	end
	if "CheckButton" == type then
		local cb = CreateFrame("CheckButton", name, parent);
		cb:ClearAllPoints();
		cb:SetPoint(
			"TOPLEFT", -- point (WoW point name)
			parent, -- relative frame. maybe change this to the label at some point
			"TOPLEFT", -- point of relative frame
			txt.x - 30 , --offset x
			txt.y --offset y
		);

	end


	if "EditBox" == type then

	end


end


--- Adds a text string to a settings panel
-- Most of the cursor and color values are stored in SassAddon.txt global
-- @tparam text to add to panel
-- @tparam (optional) name of text object to inherit
--
-- Updates SassAddon.txt.y (vertical cursor position)
function SassAddon.PanelText(text, inherit)
	local txt = SassAddon.txt;
	if nil == inherit then
		inherit = "GameFontNormal"
	end
	local t = txt.parent:CreateFontString(
		nil, -- new frame name
		"ARTWORK", -- layer
		inherit  -- inherits GameFontNormal "GameFontNormalLarge"
	);
	-- at some point, allow different inherit. But I can't
	t:ClearAllPoints();
	t:SetPoint("TOPLEFT", txt.x, txt.y);
--	t:SetPoint("RIGHT", -60);
	t:SetJustifyH("LEFT");
	t:SetJustifyV("TOP");
	t:SetTextColor(txt.r, txt.g, txt.b, txt.a);
	t:SetWidth(txt.col_width);
	t:SetText(text);
	local hh = t:GetHeight();
	txt.y = txt.y - (hh - SASSTEXT.LINESPACING);
	DEFAULT_CHAT_FRAME:AddMessage("height: " .. hh);
--	DEFAULT_CHAT_FRAME:AddMessage(text,  0.5, 1.0, 0.5, 1);
end

--- Main WoW Event handler
 function SassAddon.HandleEvent(frame, event, ...)
	DEFAULT_CHAT_FRAME:AddMessage('event ' .. event,  0.5, 1.0, 0.5, 1);
	local eventHandled = false;
	local inParty, unitID;
	local myPlayer = SassAddon.myPlayer;

-- VARIABLES_LOADED
-- ================

	if ( event == "VARIABLES_LOADED" ) then
		-- record that we have been loaded:
		SassAddon.variables_loaded = true;


		if not (SimpleAssistSavedVars) then
			SimpleAssistSavedVars={
			SimpleAssistPrefsRAID=false,
			SimpleAssistPrefsSAY = false,
			SimpleAssistPrefsYELL = false,
			SimpleAssistPrefsPARTY = false,
			SimpleAssistRaidIcon=0};
			SimpleAssistSavedVars["CustomChat"]={};
			SimpleAssistSavedVars["CustomChat"][1]=SASSTEXT_CUSTOM_CALL_BEFORE;
			SimpleAssistSavedVars["CustomChat"][2]=SASSTEXT_CUSTOM_CALL_MIDDLE;
			SimpleAssistSavedVars["CustomChat"][3]=SASSTEXT_CUSTOM_CALL_AFTER;
		end


		if (SimpleAssistSavedVars["version"] == nil) then
			SimpleAssistSavedVars["version"] = GetAddOnMetadata("SimpleAssist", "Version");
			SimpleAssistSavedVars["CustomChat"]={};
			SimpleAssistSavedVars["CustomChat"][1]=SASSTEXT_CUSTOM_CALL_BEFORE;
			SimpleAssistSavedVars["CustomChat"][2]=SASSTEXT_CUSTOM_CALL_MIDDLE;
			SimpleAssistSavedVars["CustomChat"][3]=SASSTEXT_CUSTOM_CALL_AFTER;
		else

		end

		eventHandled = true;
	end -- ( event == "VARIABLES_LOADED" )





	if (eventHandled == false and event == "UPDATE_BINDINGS") then
		SimpleAssist_UpdateBindings();
		eventHandled = true;
	end


	if (eventHandled == false and ((event == "PLAYER_LEAVE_COMBAT") or (event == "PLAYER_REGEN_ENABLED"))) then
		if (SassAddon.pending_learn ~= nil) then
			-- SimpleAssist_PrivateLearnAssist(SassAddon.pending_learn);
			-- replace with code that uses player name instead of unitID

			if (SassAddon.pending_learn == "pending clear") then
				getglobal("SimpleAssistActionButton"):SetAttribute("macrotext", "/assist target");
				SimpleAssist_PopMsg(SASSTEXT.CLEARED);
			else
				-- expand the macro code here
				getglobal("SimpleAssistActionButton"):SetAttribute("macrotext", "/assist "..SassAddon.pending_learn);
				SimpleAssist_PopMsg(SASSTEXT.ASSIST_SET ..": " .. SassAddon.pending_learn);
			end
			SassAddon.pending_learn = nil;
		end
		eventHandled = true;
	end -- event handled?


	if (eventHandled == false) then
		-- msgText = string.lower(arg1);
	end




end -- end of function




function SimpleAssist_UpdateBindings()
 if getglobal("SimpleAssistActionButton") then
			local k1, k2, k3 = GetBindingKey("SASS_ASSIST");
				if (k1) then -- SetOverrideBindingClick(owner, isPriority, "KEY", "ButtoName"[,"mouseButton"]);
				-- DEFAULT_CHAT_FRAME:AddMessage("SASS key="..k1,  0.5, 1.0, 0.5, 1);
				SetOverrideBindingClick(getglobal("SimpleAssistActionButton"),nil,k1,"SimpleAssistActionButton");
			end
		end -- button instantiated
end

function SimpleAssistTester()
SimpleAssist_PopMsg("Yadda");

end









-- In Game Functions:

function  SimpleAssist_LearnAssist(unit)
-- {unit} = ID of unit to be set as assist (from Target)

	if (InCombatLockdown()) then
		local thisUnitName=UnitName(unit);
		if (thisUnitName==nil) then
			SassAddon.pending_learn="pending clear"; -- use a name with a space and no upper-case
			SimpleAssist_PopMsg(SASSTEXT.CLEAR_PENDING);
		else
			SassAddon.pending_learn=thisUnitName;
			SimpleAssist_PopMsg(SASSTEXT.ASSIST_PENDING .. thisUnitName);
		end
	else
		SimpleAssist_PrivateLearnAssist(unit);
	end

end -- function


function SimpleAssist_PrivateLearnAssist(unit)
-- inputs
--     unit to remember
--     if no unit, clear the remembered "assistee"

	if (UnitName(unit) == nil) then
		getglobal("SimpleAssistActionButton"):SetAttribute("macrotext", "/assist target");
		SimpleAssist_PopMsg(SASSTEXT.CLEARED);
	end

	if (UnitIsPlayer(unit)) then
		if (UnitIsFriend("target", unit)) then -- unit could technically be "target" here... (changed from player to target for Battle of Darrowshire and similar events
				-- SimpleAssist_units["assist1"]=UnitName(unit);
				local thisUnitName=UnitName(unit);
				-- expand the macro code here
				-- /assist [target=focus, exists]
				-- check for modifier to use
				-- /use [nomodifier, nomounted]Snowy Gryphon;
				-- /use [modifier:alt]Palomino Bridle;
				getglobal("SimpleAssistActionButton"):SetAttribute("macrotext", "/assist "..thisUnitName);
				SimpleAssist_PopMsg(SASSTEXT.ASSIST_SET ..": " .. thisUnitName);
		end -- friend
	end -- player
end



function  SimpleAssist_AskAssist()
	local myPlayer = SassAddon.myPlayer;
	local target_name=UnitName("target");

	if (target_name ~= nil) then -- only ask for help if there is a target
		-- local msg = SASSTEXT.CHAT_ASSIST;
		-- string.gsub(s, pattern, replace [, n])
		-- msg=string.gsub(msg, "{name}", myPlayerName );
		-- msg=string.gsub(msg, "{target}", target_name );
		local p1=SimpleAssistSavedVars["CustomChat"][1];
		local p2=SimpleAssistSavedVars["CustomChat"][2];
		local p3=SimpleAssistSavedVars["CustomChat"][3];

		-- format the message:
		if (p1 ~= "") then
			p1=p1.." ";
		end
		-- if (p2 ~= "") then
			-- p2=" "..p2.." ";
		-- end
		-- if (p3 ~= "") then
			-- p3=" "..p3;
		-- end
		local msg = p1 .. myPlayer.name .. p2 .. target_name .. p3;

		-- tell it to the world (or party, or raid...)
		if (IsInGroup()) then
			if (IsInRaid()) then
				if (SimpleAssistSavedVars["SimpleAssistPrefsRAID"]) then
					SendChatMessage(msg, "RAID");
				end

				if (SimpleAssistSavedVars["SimpleAssistPrefsRW"]) then
					SendChatMessage(msg, "RAID_WARNING");
				end

				if (SimpleAssistSavedVars["SimpleAssistRaidIcon"] ~= 0) then
					SetRaidTarget("target",SimpleAssistSavedVars["SimpleAssistRaidIcon"]);
				end

			else -- not raid, just party

				if (SimpleAssistSavedVars["SimpleAssistPrefsPARTY"] ) then
					SendChatMessage(msg, "PARTY");
				end

				if (SimpleAssistSavedVars["SimpleAssistRaidIcon"] ~= 0) then
					SetRaidTarget("target",SimpleAssistSavedVars["SimpleAssistRaidIcon"]);
				end
			end -- party

		else -- not in a group, so only yell, say or emote
			if (SimpleAssistSavedVars["SimpleAssistPrefsYELL"]) then
				SendChatMessage(msg, "YELL");
			end
			if (SimpleAssistSavedVars["SimpleAssistPrefsSAY"]) then
				SendChatMessage(msg, "SAY");
			end

			if (SimpleAssistSavedVars["SimpleAssistPrefsEMOTE"]) then
				DoEmote("ATTACKMYTARGET");
			end

			if (SimpleAssistSavedVars["SimpleAssistRaidIcon"] ~= 0) then
				SetRaidTarget("target",SimpleAssistSavedVars["SimpleAssistRaidIcon"]);
			end


		end -- in group/solo test

	end -- have target

end




function SimpleAssist_PopMsg(msg)
-- Our head's up display for this AddOn
-- Inputs: {msg} = message to display in the HUD
	if (msg == nil) then
    	msg="Oh Baby!";
    end
    if (SchnoggoAlertInform) then
    	SchnoggoAlertInform(msg);
    else
		SimpleAssistAlertFrame:AddMessage(msg, 1, 1, 1, 1, 3);
    end
end

function SimpleAssist_DoAssist()
-- this function is now a dummy. It exists only so that a keybinding can be set.

end
