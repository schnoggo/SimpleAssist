function SimpleAssist_Options_CreatePanel()
  local line_vspace;
  SassAddon.LoadDefaults();
  SassAddon.panel = CreateFrame( "Frame", "SassAddonPanel", UIParent );
  SassAddon.RegisterInterfacePanel(SassAddon.panel, "SimpleAssist")


  -- child panels:
  SassAddon.panel2 = CreateFrame( "Frame", "SassAddonInfo", UIParent );
  SassAddon.panel2.name = "Information";
  SassAddon.panel2.parent = SassAddon.panel.name;
  InterfaceOptions_AddCategory(SassAddon.panel2);

  local txt = SassAddon.txt; -- make a shorter reference

  -- set up the UI panel
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
  SassAddon.PanelColumns(2); -- two columns
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
      SassAddon.PanelControl('CheckButton', emote_type); -- "SASS_" is prepended to name
      txt.y = txt.y + line_vspace;
      items_in_col = items_in_col +1;
      if items_in_col >= max_per_col then -- step over to the second column
        items_in_col = 0;
        txt.y = top_of_block;
        txt.x = txt.x + SASSTEXT.COLWIDTH;
      end
    end

-- The text boxes for messages:

    local this_row_y = -200;
    txt.x = 15;
    txt.r = 1;
    txt.g = .82;
    txt.b = 0;
    txt.y = this_row_y;
    SassAddon.PanelColumns(1);
    SassAddon.PanelText(SASSTEXT.CUSTOM_CALL_HEAD);
    this_row_y = this_row_y - 20; -- everything goes one line below the intro text
    txt.y = this_row_y;
    SassAddon.PanelControl('EditBox', 'CUSTOM_CALL_BEFORE');
    txt.r = 1;
    txt.g = 1;
    txt.b = 1;
    txt.x = 132;
    txt.y = this_row_y;
    SassAddon.PanelText(UnitName("player"));
    txt.y = this_row_y;
    txt.x = 262;
    SassAddon.PanelControl('EditBox', 'CUSTOM_CALL_MIDDLE');
    txt.y = this_row_y;
    txt.x = 380;
    SassAddon.PanelText(SASSTEXT.CUSTOM_CALL_MOBNAME);
    txt.y = this_row_y;
    txt.x = 440;
    SassAddon.PanelControl('EditBox', 'CUSTOM_CALL_AFTER');



-- Radio buttons for Raid target icon

txt.x = 15;
txt.r = 1;
txt.g = .82;
txt.b = 0;
txt.y = -330;
SassAddon.PanelColumns(1);
SassAddon.PanelText(SASSTEXT.RTARGET_HEAD);
local this_row_y = txt.y -20;
txt.y = this_row_y;
max_per_col = 4;
items_in_col = 0;
top_of_block = txt.y;

local radio_setting ;
local radio_text;

txt.x = 55;
  for i=0, 8, 1 do
  -- Draw the label:
    radio_setting = "RTARGET" .. i;
    -- if i > 0 then
    --  radio_text = SASSTEXT[radio_setting] .. " |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. i .. "|t";
    --else
      radio_text = SASSTEXT[radio_setting];
    -- end
    SassAddon.PanelText(radio_text);
    SassAddon.PanelControl('RadioButton', radio_setting); -- "SASS_" is prepended to name
    txt.y = txt.y + line_vspace;
    items_in_col = items_in_col +1;
    if items_in_col >= max_per_col then -- step over to the second column
      items_in_col = 0;
      txt.y = top_of_block;
      txt.x = txt.x + SASSTEXT.COLWIDTH;
      max_per_col = 99; -- don't wrap next column
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
