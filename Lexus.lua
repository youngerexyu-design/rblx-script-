local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Settings
local AutoParry = true
local Distance = 12

-- Parry function
local function DoParry()
    -- Example trigger key / remote
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
    task.wait(0.05)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
end

-- Detect enemy attack
RunService.RenderStepped:Connect(function()
    if not AutoParry then return end

    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v ~= Character then
            local Humanoid = v:FindFirstChild("Humanoid")
            local HRP = v:FindFirstChild("HumanoidRootPart")

            if Humanoid and HRP and Humanoid.Health > 0 then
                local myHRP = Character:FindFirstChild("HumanoidRootPart")

                if myHRP then
                    local dist = (myHRP.Position - HRP.Position).Magnitude

                    if dist <= Distance then
                        -- Check attack animation
                        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                            if track.Name:lower():find("attack") then
                                DoParry()
                            end
                        end
                    end
                end
            end
        end
    end
end)
