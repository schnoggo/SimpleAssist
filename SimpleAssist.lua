-- Globals:
-- ========
-- our big global object:
SassAddon = {
	addon_loaded = false,
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
		col_width = (SASSTEXT.COLWIDTH * 2) + 10
	},
	unsaved_setting = {}
};


-- boot frame:
local boot_frame = CreateFrame("Frame")
boot_frame:RegisterEvent("ADDON_LOADED")
boot_frame:SetScript(
  "OnEvent", function(frame,event, addon, ...)
		if frame == boot_frame then
	    SassAddon.init(event, addon);
		end
  end
);


-- SimpleAssist_SavedVars = {};




-- default config settings

	SassAddon.defaults={
		CHAT_EMOTE = false,
		CHAT_RAID=false,
		CHAT_SAY = false,
		CHAT_YELL = false,
		CHAT_PARTY = false,
		CHAT_RW = false,
		CUSTOM_CALL_BEFORE = SASSTEXT.CUSTOM_CALL_BEFORE,
		CUSTOM_CALL_MIDDLE = SASSTEXT.CUSTOM_CALL_MIDDLE,
		CUSTOM_CALL_AFTER =	'.',
		RAID_ICON = 'RTARGET0',
		version = 4
	};

-- My local functions:
-- ====================


--- Once the addon is loaded, register all our events and create our frames
--
function SassAddon.init(event, addon)
	local myPlayer = SassAddon.myPlayer; -- local shortcut
	local need_to_init = false;
	if event == "ADDON_LOADED" and addon == "SimpleAssist" then
	--	DEFAULT_CHAT_FRAME:AddMessage(SASSTEXT.WELCOME,  0.5, 1.0, 0.5, 1); -- leave for testing

		if ( false == SassAddon.addon_loaded ) then -- only need to load once
			SassAddon.addon_loaded = true;

			-- do we need to init the saved variables?
			if not (SimpleAssistCharVars) then
				need_to_init = true;
			else
				if (nil == SimpleAssistCharVars["version"]) then
					need_to_init = true;
				else
					if SimpleAssistCharVars["version"] < 4 then
						need_to_init = true;
					end
				end
			end
 -- need_to_init = true;

			if (need_to_init) then
				DEFAULT_CHAT_FRAME:AddMessage(SASSTEXT.FIRST_RUN,  0.5, 1.0, 0.5, 1);
				-- never saved, create from scratch
				SimpleAssistCharVars = SassAddon.deepcopy(SassAddon.defaults);
				SassAddon.unsaved_settings = SassAddon.deepcopy(SimpleAssistCharVars);


			end


			if (not myPlayer.name) then -- hasn't been initialized
				myPlayer.name = UnitName("player");
			end

			-- Register all our events:
			SassAddon.eventframe = CreateFrame("Frame" ); -- the frame to listen to all our events
			local ev = SassAddon.eventframe; -- local shortcut

			local f =  CreateFrame("CheckButton", "SimpleAssistActionButton", UIParent, "ActionBarButtonTemplate");

			f:SetAttribute("type", "macro");
			f:SetAttribute("width", "30");
			f:SetAttribute("height", "30");
			f:SetAttribute("macrotext", "/assist target");
			f:ClearAllPoints();
			f:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 50, 50); -- (point, frame, relativePoint , x, y);
			-- putting the button off-screen to make it invisible
			-- f:SetPoint("BOTTOMRIGHT", "UIParent", "TOPLEFT", 2, -2); -- (point, frame, relativePoint , x, y);


			-- and register our basic events:
			ev:RegisterEvent("PLAYER_ENTERING_WORLD");
			ev:RegisterEvent("CHAT_MSG_CHANNEL");
			ev:RegisterEvent("VARIABLES_LOADED");
			ev:RegisterEvent("UPDATE_BINDINGS");
			ev:RegisterEvent("PLAYER_LEAVE_COMBAT");
			ev:RegisterEvent("PLAYER_REGEN_ENABLED");

			-- self:RegisterEvent("CHAT_MSG_TEXT_EMOTE"); -- for listening
			ev:SetScript("OnEvent", SassAddon.HandleEvent);

			-- Set up our display frame:
	--		SassAddon.alert = CreateFrame("MessageFrame", "SimpleAssistAlertFrame", UIParent );
		--	SassAddon.alert.


			-- Set up the preference panel:
			SimpleAssist_Options_CreatePanel();
		end --SassAddon.addon_loaded
	end -- ADDON_LOADED
end


--- Main WoW Event handler
 function SassAddon.HandleEvent(frame, event, ...)
--	DEFAULT_CHAT_FRAME:AddMessage('event ' .. event,  0.5, 1.0, 0.5, 1);
	local eventHandled = false;
	local inParty, unitID;
	local myPlayer = SassAddon.myPlayer;

-- VARIABLES_LOADED
-- ================

	if ( event == "VARIABLES_LOADED" ) then -- sounds like variables_loaded events should be ADDON_LOADED
		-- record that we have been loaded:

		eventHandled = true;
	end -- ( event == "VARIABLES_LOADED" )





	if (eventHandled == false and event == "UPDATE_BINDINGS") then
		SimpleAssist_UpdateBindings();
		eventHandled = true;
	end


	if (eventHandled == false and ((event == "PLAYER_LEAVE_COMBAT") or (event == "PLAYER_REGEN_ENABLED"))) then
		if (SassAddon.pending_learn ~= nil) then -- we have a "learn" pending from combat
			if ("pending clear" == SassAddon.pending_learn) then
				SimpleAssistActionButton:SetAttribute("macrotext", "/assist target");
				SimpleAssist_PopMsg(SASSTEXT.CLEARED);
			else
				-- expand the macro code here
				SimpleAssistActionButton:SetAttribute("macrotext", "/assist " .. SassAddon.pending_learn);
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
 if nil ~= SimpleAssistActionButton then
			local key1, key2 = GetBindingKey("Assist Learned Player");
				if (key1) then -- SetOverrideBindingClick(owner, isPriority, "KEY", "ButtoName"[,"mouseButton"]);
					SetOverrideBindingClick(
						SassAddon.eventframe, -- owner frame
						false, -- isPriority, even false is higher than normal bindings
						key1,
						"SimpleAssistActionButton" -- buttonName
					);
			end
		end -- button has been instantiated
end

function SimpleAssistTester()
SimpleAssist_PopMsg("Yadda");

end









-- In Game Functions:

---
-- "Learn" the current target as the unit to assist
-- {unit} = ID of unit to be set as assist (from Target)
--
function  SimpleAssist_LearnAssist(unit)

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


---
-- The actual function to learn the unit to assist
-- Since this can't be called during combat,
-- it will be called by SimpleAssist_LearnAssist
-- @param  unit to remember. if no unit, clear the remembered "assistee"
function SimpleAssist_PrivateLearnAssist(unit)

	if (UnitName(unit) == nil) then
		SimpleAssistActionButton:SetAttribute("macrotext", "/assist target");
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
				SimpleAssistActionButton:SetAttribute("macrotext", "/assist "..thisUnitName);
				SimpleAssist_PopMsg(SASSTEXT.ASSIST_SET ..": " .. thisUnitName);
		end -- friend
	end -- player
end



function  SimpleAssist_AskAssist()
	local myPlayer = SassAddon.myPlayer;
	local target_name=UnitName("target");

	if (nil ~= target_name ) then -- only ask for help if there is a target
		-- local msg = SASSTEXT.CHAT_ASSIST;
		-- string.gsub(s, pattern, replace [, n])
		-- msg=string.gsub(msg, "{name}", myPlayerName );
		-- msg=string.gsub(msg, "{target}", target_name );
		local before = SimpleAssistCharVars["CUSTOM_CALL_BEFORE"];
		local middle = SimpleAssistCharVars["CUSTOM_CALL_MIDDLE"];
		local after =SimpleAssistCharVars["CUSTOM_CALL_AFTER"];

		-- format the message:
		if ("" ~= before and "" ~= before) then
			before = before .. " ";
		end

		if ("" ~= middle and "" ~= middle) then
			middle = middle .. " ";
		end

		local msg = before .. myPlayer.name .. middle .. target_name .. after;
		--DEFAULT_CHAT_FRAME:AddMessage("Ask assist: " .. msg ,  0.5, 1.0, 0.5, 1);


		if (IsInGroup()) then
			local raid_icon_num = 0;
			if (nil ~= SimpleAssistCharVars.RAID_ICON ) then
				raid_icon_num = tonumber(strsub(SimpleAssistCharVars.RAID_ICON, -1));
			end

			if (IsInRaid()) then
				if (SimpleAssistCharVars.CHAT_RAID) then
					SendChatMessage(msg, "RAID");
				end

				if (SimpleAssistCharVars.CHAT_RW) then
					SendChatMessage(msg, "RAID_WARNING");
				end

				if 0 ~= raid_icon_num then
					SetRaidTarget("target",raid_icon_num);
				end

			else -- not raid, just party

				if (SimpleAssistCharVars.CHAT_PARTY) then
					SendChatMessage(msg, "PARTY");
				end

				if 0 ~= raid_icon_num then
					SetRaidTarget("target",raid_icon_num);
				end
			end -- party

		else -- not in a group, so only yell, say or emote
			if (SimpleAssistCharVars.CHAT_YELL) then
				SendChatMessage(msg, "YELL");
			end
			if (SimpleAssistCharVars.CHAT_SAY) then
				SendChatMessage(msg, "SAY");
			end

			if (SimpleAssistCharVars.CHAT_EMOTE) then
				DoEmote("ATTACKMYTARGET");
			end

			if (SimpleAssistCharVars.RAID_ICON ~= 0) then
				SetRaidTarget("target",icon_number);
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
