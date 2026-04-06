local PlayerGUI = script.Parent
local Workspace = game["Environment"]

local syncEvent = Workspace:FindChild("LeaderstatsSync")
if not syncEvent then
    print("LeaderstatsSync event not found in Workspace. Leaderstats panel will not work.")
    return
end


CoreUI.LeaderboardEnabled = false
CoreUI.UserCardEnabled = false

local PANEL_WIDTH   = 180
local ROW_HEIGHT    = 22
local TITLE_HEIGHT  = 28
local PADDING       = 6

local panel = Instance.New("UIView")
panel.Name                   = "LeaderstatsPanel"
panel.SizeOffset                   = Vector2.New(PANEL_WIDTH, TITLE_HEIGHT)
panel.PositionOffset               = Vector2.New(10, 10)
panel.Color        = Color.New(0.08, 0.08, 0.08, 0.7)
panel.Visible                = false
panel.Parent                 = PlayerGUI

local title = Instance.New("UILabel")
title.Name      = "Title"
title.Text      = "Stats"
title.SizeOffset      = Vector2.New(PANEL_WIDTH, TITLE_HEIGHT)
title.PositionOffset  = Vector2.New(0, 0)
title.FontSize  = 15
title.TextColor = Color.New(1, 0.85, 0.2)
title.Parent    = panel

local statRows = {}

local function getOrCreateRow(index, statName)
    if statRows[index] then
        return statRows[index].label
    end

    local label = Instance.New("UILabel")
    label.Name      = "Stat_" .. index
    label.SizeOffset      = Vector2.New(PANEL_WIDTH - PADDING * 2, ROW_HEIGHT)
    label.PositionOffset  = Vector2.New(PADDING, TITLE_HEIGHT + (index - 1) * ROW_HEIGHT)
    label.FontSize  = 13
    label.TextColor = Color.New(1, 1, 1)
    label.Text      = statName .. ": ..."
    label.Parent    = panel

    statRows[index] = { label = label, name = statName }
    return label
end


local function resizePanel(rowCount)
    panel.SizeOffset = Vector2.New(PANEL_WIDTH, TITLE_HEIGHT + rowCount * ROW_HEIGHT + PADDING)
end


syncEvent.InvokedClient:Connect(function(msg)
    local count = msg.GetNumber("count")
    if not count or count == 0 then
        panel.Visible = false
        return
    end

    panel.Visible = true
    resizePanel(count)

    for i = 1, count do
        local name  = msg.GetString("name"  .. i)
        local value = msg.GetString("value" .. i)

        if name and value then
            local label = getOrCreateRow(i, name)
            label.Text = name .. ": " .. value
        end
    end
end)
