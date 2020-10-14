-- functions to draw and read controls on a settings panel


function SassAddon.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[SassAddon.deepcopy(orig_key)] = SassAddon.deepcopy(orig_value)
        end
        setmetatable(copy, SassAddon.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function SassAddon.LoadDefaults()
  SassAddon.unsaved_settings = SassAddon.deepcopy(SimpleAssistCharVars);
end

-- configure the setting panels to use specified columns (1 or 2)
function SassAddon.PanelColumns(cols)
	local txt = SassAddon.txt;
	if 1 == cols then
		txt.col_width = (SASSTEXT.COLWIDTH * 2) + 10;

	else
		txt.col_width = SASSTEXT.COLWIDTH;
	end

end

-- Draws a control currently selected settings panel
-- Uses the cursor values in SassAddon.txt global
-- Assumes all control have an associated label
--
-- @tparam Type of control CheckButton | EditBox
-- @tparam Name of control. This will be prepended with "SASS_CONTROL_" to be global safe
-- @tparam (optional) parent frame
--
function SassAddon.PanelControl(type, name, parent)
	local control_frame;
	local txt = SassAddon.txt;
	if nil == parent then -- if a parent frame wasn't passed, use the current selection
		parent = txt.parent;
	end
	if "CheckButton" == type then
		local cb = CreateFrame(
			"CheckButton", -- frame type
			"SASS_CONTROL_" .. name, -- name of newly created frame (can't be nil for our purposes)
			parent, -- parent frame
			"ChatConfigCheckButtonTemplate" -- virtual frame template
	    -- numberic id of frame
		);
		cb:ClearAllPoints();
		cb:SetPoint(
			"TOPLEFT", -- point (WoW point name)
			parent, -- relative frame. maybe change this to the label at some point
			"TOPLEFT", -- point of relative frame
			txt.x - 30 , --offset x
			txt.y + 24 --offset y
		);
		cb: HookScript("OnClick", SimpleAssist_Checkbox_OnClick);
		-- set the value:

		local current_value = SassAddon.unsaved_settings[name];
		SassAddon.unsaved_settings[name] = current_value;
		cb:SetChecked(current_value);
		cb["SASS_SETTING"] = name; -- so we can know which setting this maps to
	end -- CheckButton


  if "RadioButton" == type then
		local cb = CreateFrame(
			"CheckButton", -- frame type
			"SASS_CONTROL_" .. name, -- name of newly created frame (can't be nil for our purposes)
			parent, -- parent frame
			"SendMailRadioButtonTemplate" -- virtual frame template
	    -- numberic id of frame
		);
		cb:ClearAllPoints();
		cb:SetPoint(
			"TOPLEFT", -- point (WoW point name)
			parent, -- relative frame. maybe change this to the label at some point
			"TOPLEFT", -- point of relative frame
			txt.x - 30 , --offset x
			txt.y + 24 --offset y
		);
		cb: HookScript("OnClick", SimpleAssist_Radio_OnClick);
		-- set the value:

		local current_value = SassAddon.unsaved_settings[name];
		SassAddon.unsaved_settings[name] = current_value;
		cb:SetChecked(current_value);
		cb["SASS_SETTING"] = name; -- so we can know which setting this maps to
	end -- CheckButton



	if "EditBox" == type then

    local ebx = CreateFrame(
      "EditBox", -- frame type
      "SASS_CONTROL_" .. name, -- name of newly created frame (can't be nil for our purposes)
      parent, -- parent frame
      "InputBoxTemplate" -- virtual frame template
      -- numberic id of frame
    );
    ebx:SetSize(110, 20);
    ebx:ClearAllPoints();
    ebx:SetPoint(
      "TOPLEFT", -- point (WoW point name)
      parent, -- relative frame. maybe change this to the label at some point
      "TOPLEFT", -- point of relative frame
      txt.x , --offset x
      txt.y +4 --offset y
    );
    ebx:SetAutoFocus(false);

    --eb: HookScript("OnClick", SimpleAssist_Checkbox_OnClick);

    local current_value = SassAddon.unsaved_settings[name];
    SassAddon.unsaved_settings[name] = current_value;
    ebx:SetText(current_value);
    ebx:SetCursorPosition(0)
    ebx["SASS_SETTING"] = name; -- so we can know which setting this maps to
	end --EditBox

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

end
