local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local lockOn = false
local target = nil

-- 가장 가까운 플레이어 찾기 (Head 기준)
local function getClosestTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local closest = nil
    local shortest = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local dist = (char.HumanoidRootPart.Position - head.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = head
                end
            end
        end
    end

    return closest
end

-- Q 키 토글
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.Q then
        lockOn = not lockOn

        if lockOn then
            target = getClosestTarget()
        else
            target = nil
        end
    end
end)

-- 에임 + 몸 회전
RunService.RenderStepped:Connect(function()
    if lockOn and target and player.Character then
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")

        if root and humanoid then
            local targetPos = target.Position

            -- 🎯 몸 회전 (Y축 고정)
            local lookPos = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
            root.CFrame = CFrame.new(root.Position, lookPos)

            -- 🎯 카메라 에임 (머리 정확히 조준)
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
        end
    end
end)
