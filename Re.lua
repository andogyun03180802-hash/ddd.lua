local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local target = nil
local lockOn = false

-- 에임 + 몸 회전
RunService.RenderStepped:Connect(function()
    if lockOn and target and player.Character then
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")

        if root and humanoid then
            local targetPos = target.Position

            -- ✅ 몸 회전 (이게 핵심)
            root.CFrame = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))

            -- ✅ 카메라 에임
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
        end
    end
end)
