local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local following = false
local target = nil

-- 가장 가까운 플레이어 찾기
local function getClosestTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local closest = nil
    local shortest = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr.Character.HumanoidRootPart
            end
        end
    end

    return closest
end

-- X 키 토글
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.X then
        following = not following

        if following then
            target = getClosestTarget()
        else
            target = nil
        end
    end
end)

-- 계속 따라가기 (뒤 위치 유지)
RunService.RenderStepped:Connect(function()
    if following and target and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            -- 타겟 뒤쪽 위치 계산
            local behindPos = target.CFrame.Position - target.CFrame.LookVector * 3

            -- 위치 이동 (딱 붙음)
            root.CFrame = CFrame.new(behindPos, target.Position)
        end
    end
end)
