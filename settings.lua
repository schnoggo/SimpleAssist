function SimpleAssist_Options_CreatePanel()
  local line_vspace;
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

  -- set up the panel
  txt.parent = SassAddonPanel; -- SassAddon.panel | SassAddon.panel2
  line_vspace = SASSTEXT.LINESPACING;
  -- draw the panel title:
  txt.y = -15;
  txt.x = 10;
  txt.r = 1;
  txt.g = .82;
  txt.b = 0;
  SassAddon.PanelText("Simple Assist", "GameFontNormalLarge");

  -- now indent after title:
  txt.x = 15;
  txt.y = ( txt.y + SASSTEXT.TITLESPACING ) - line_vspace; -- where to start the panel

  -- Chat type selector intro text:
  SassAddon.PanelText(SASSTEXT.CHAT_HEAD);

  -- And now the checkboxes and labels:
  -- Back to white:
  txt.r = 1;
  txt.g = 1;
  txt.b = 1;
  -- two columns:
  txt.col_width = SASSTEXT.COLWIDTH;
  txt.x = 50; -- leave room for the checkbox

  local max_per_col = 3;
  local items_in_col = 0;
  local top_of_block = txt.y; -- save it so we can do columns
  -- Walk through available emotes:
    local emote_types = {
      "CHAT_EMOTE", "CHAT_YELL", "CHAT_RAID", "CHAT_PARTY", "CHAT_SAY", "CHAT_RW"
    };

    for _,  emote_type in ipairs(emote_types) do -- emote_type is automatically local
      -- Draw the label:
      SassAddon.PanelText(SASSTEXT[emote_type]);


      SassAddon.PanelControl('CheckButton',"SASS_" .. emote_type);
      txt.y = txt.y + line_vspace;
      items_in_col = items_in_col +1;
      if items_in_col >= max_per_col then
        items_in_col = 0;
        txt.y = top_of_block;
        txt.x = txt.x + SASSTEXT.COLWIDTH;
      end
    end


  -- set up panel 2
  txt.parent = SassAddonInfo; -- SassAddon.panel | SassAddon.panel2
  txt.y = -15;
  txt.x = 10;
  txt.r = 1;
  txt.g = .82;
  txt.b = 0;
  SassAddon.PanelText("Simple Assist - Information", "GameFontNormalLarge");
  -- now indent after title:
  txt.x = 15;

  txt.y = ( txt.y + SASSTEXT.TITLESPACING ) - SASSTEXT.LINESPACING; -- where to start the panel
  for _,  thisline in ipairs(SASSTEXT.INFO_PANEL) do -- thisline is automatically local
    local inherit = nil;
    txt.r = 1;
    txt.g = 1;
    txt.b = 1;
    line_vspace = SASSTEXT.LINESPACING;
    if "*" == string.sub(thisline,1,1) then
      thisline = strsub(thisline,2);
      inherit = "GameFontNormalMed2";
      txt.r = 1;
      txt.g = .82;
      txt.b = 0;
      line_vspace = SASSTEXT.TITLESPACING;
    end
    txt.y = txt.y + line_vspace;
    SassAddon.PanelText(thisline);
  end

end



-- Text drawing
--



-- GUI Handlers:
-- =============================

-- prefs:
function SimpleAssist_Options_OnClick(ef, ...)
  if nil ~= ef then
  	buttonName=ef:GetName();
  	SimpleAssistDefaults[buttonName] =_G[buttonName]:GetChecked();
  	SimpleAssistSavedVars[buttonName] =_G[buttonName]:GetChecked();
  end
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
