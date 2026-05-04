local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local lockOn = false
local target = nil

-- 가장 가까운 타겟 찾기
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

        if not lockOn then
            target = nil
        end
    end
end)

-- 계속 갱신 + 에임
RunService.RenderStepped:Connect(function()
    if lockOn and player.Character then
        
        -- 🔥 매 프레임 타겟 다시 찾기
        target = getClosestTarget()

        if target then
            local root = player.Character:FindFirstChild("HumanoidRootPart")

            if root then
                local targetPos = target.Position

                -- 몸 회전
                local lookPos = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
                root.CFrame = CFrame.new(root.Position, lookPos)

                -- 카메라 에임
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end
    end
end)
