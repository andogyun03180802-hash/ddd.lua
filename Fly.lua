local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ===== ESP =====
local espEnabled = false
local espObjects = {}

local function createESP(character, plr)
    if espObjects[character] then return end

    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChild("Humanoid")
    if not head or not humanoid then return end

    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(4,0,5,0)
    gui.AlwaysOnTop = true
    gui.Adornee = head
    gui.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.3,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = gui

    local healthBG = Instance.new("Frame")
    healthBG.Size = UDim2.new(1,0,0.2,0)
    healthBG.Position = UDim2.new(0,0,0.35,0)
    healthBG.BackgroundColor3 = Color3.new(0,0,0)
    healthBG.Parent = gui

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1,0,1,0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.Parent = healthBG

    humanoid.HealthChanged:Connect(function()
        local percent = humanoid.Health / humanoid.MaxHealth
        healthBar.Size = UDim2.new(percent,0,1,0)
    end)

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.Parent = character

    espObjects[character] = {gui, highlight}
end

local function removeESP()
    for _, objs in pairs(espObjects) do
        for _, obj in pairs(objs) do
            if obj then obj:Destroy() end
        end
    end
    espObjects = {}
end

-- ===== FLY =====
local flying = false
local bodyVelocity
local bodyGyro

local function startFly(char)
    local root = char:WaitForChild("HumanoidRootPart")

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
end

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

-- ===== 입력 =====
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- E → ESP
    if input.KeyCode == Enum.KeyCode.E then
        espEnabled = not espEnabled

        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    createESP(plr.Character, plr)
                end
            end
        else
            removeESP()
        end
    end

    -- F → 플라이
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        local char = player.Character or player.CharacterAdded:Wait()

        if flying then
            startFly(char)
        else
            stopFly()
        end
    end
end)

-- ===== 비행 움직임 =====
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and player.Character then
        local cam = workspace.CurrentCamera
        local move = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end

        bodyVelocity.Velocity = move * 60
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- 새 플레이어 ESP 적용
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            createESP(char, plr)
        end
    end)
end)
