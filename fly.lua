local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local flying = false

local bodyVelocity
local bodyGyro

function startFlying(character)
    local root = character:WaitForChild("HumanoidRootPart")

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(999999, 999999, 999999)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(999999, 999999, 999999)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
end

function stopFlying()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying

        local character = player.Character or player.CharacterAdded:Wait()

        if flying then
            startFlying(character)
        else
            stopFlying()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local moveDir = Vector3.new(0,0,0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end

            bodyVelocity.Velocity = moveDir * 50
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end)
