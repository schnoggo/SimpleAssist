function SimpleAssist_Options_CreatePanel()
  SassAddon.panel = CreateFrame( "Frame", "SassAddonPanel", UIParent );

    -- Register in the Interface Addon Options GUI
  SassAddon.panel.name = "SimpleAssist";

  -- Add the panel to the Interface Options
  InterfaceOptions_AddCategory(SassAddon.panel);

  -- child panels:
  SassAddon.panel2 = CreateFrame( "Frame", "SassAddonInfo", UIParent );
  SassAddon.panel2.name = "Information";
  SassAddon.panel2.parent = SassAddon.panel.name;
  InterfaceOptions_AddCategory(SassAddon.panel2);


  local txt = SassAddon.txt;
  txt.parent = SassAddonPanel; -- SassAddon.panel | SassAddon.panel2
  txt.y = -15;
  txt.x = 10;
  txt.r = 1;
  txt.g = .82;
  txt.b = 0;
  SassAddon.PanelText("Simple Assist", "GameFontNormalLarge");

  txt.parent = SassAddonInfo; -- SassAddon.panel | SassAddon.panel2
  txt.y = -15;
  txt.x = 10;
  txt.r = 1;
  txt.g = .82;
  txt.b = 0;
  SassAddon.PanelText("Simple Assist - Information", "GameFontNormalLarge");


  txt.y = txt.y + SASSTEXT.OPTIONSPACING;
  for _,  thisline in ipairs(SASSTEXT.INFO_PANEL) do -- thisline is automatically local
    local inherit = nil;
    txt.r = 1;
    txt.g = 1;
    txt.b = 1;
    if "*" == string.sub(thisline,1,1) then
      thisline = strsub(thisline,2);
      inherit = "GameFontNormalMed2";
      txt.r = 1;
      txt.g = .82;
      txt.b = 0;
    end
    SassAddon.PanelText(thisline);
    txt.y = txt.y + SASSTEXT.OPTIONSPACING;

end


end



-- Text drawing
--



-- GUI Handlers:
-- =============================

-- prefs:
function SimpleAssist_Options_OnClick(self)
	id = self:GetID()
	local buttonName=self:GetName()
	SimpleAssistDefaults[buttonName] =getglobal(buttonName):GetChecked();
	SimpleAssistSavedVars[buttonName] =getglobal(buttonName):GetChecked();
end


function SimpleAssist_Radio_OnClick(arg1)
	SimpleAssistSavedVars["SimpleAssistRaidIcon"]=arg1;
	SimpleAssistUpdateRadios();
end


 -- OnShow
 function SimpleAssistPrefsFrameOnShow()


	-- draw the current settings:
	table.foreach(SimpleAssistSavedVars,
		function(k,v)
			if (getglobal(k) ~= nil) then
				if string.find("Text",k) then

				else
					getglobal(k):SetChecked(v);
				end

			end
		end

	);
	-- fill in the text for the custom chat message:
	for i = 1,3 do
		local tMsgName="SimpleAssistChatText"..i;
		local tMsgText=	SimpleAssistSavedVars["CustomChat"][i];
		if (tMsgText ~= nil) then
			getglobal(tMsgName):SetText(tMsgText);
		end
	end

	-- draw the radio buttons for Raid Icon
	if (SimpleAssistSavedVars["SimpleAssistRaidIcon"] == nil) then
		SimpleAssistSavedVars["SimpleAssistRaidIcon"] = 0;
	end

	SimpleAssistUpdateRadios();

 end



function SimpleAssistUpdateRadios()
  i=0;
	while (i<9) do
		if (i==SimpleAssistSavedVars["SimpleAssistRaidIcon"]) then
  		getglobal("SimpleAssist_RB"..i):SetChecked(true);
		else
			getglobal("SimpleAssist_RB"..i):SetChecked(false);
		end
		i=i+1;
	end
end



function SimpleAssist_GetPrefsText()
	SimpleAssistSavedVars["CustomChat"]={};
	for i = 1,3 do
		local tMsgName="SimpleAssistChatText"..i;
		local tMsgText=getglobal(tMsgName):GetText();
		if (tMsgText ~= nil) then
			SimpleAssistSavedVars["CustomChat"][i]=tMsgText;
		end
	end
end
