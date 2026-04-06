game.Players.PlayerAdded:Connect(function(player)
    Leaderstats = Instance.New("Folder")
    Leaderstats.Name = "Leaderstats"
    Leaderstats.Parent = player
end)

local Kills = Instance.New("NumberValue")
Kills.Name = "Kills"
Kills.Value = 0
Kills.Parent = Leaderstats
