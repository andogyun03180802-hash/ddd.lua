local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local npcFolder = workspace:WaitForChild("NPCs")

local lockOn = false
local currentTarget = nil
local highlight = nil

-- UI 생성
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local box = Instance.new("Frame")
box.Size = UDim2.new(0, 100, 0, 100)
box.BorderSizePixel = 2
box.BorderColor3 = Color3.fromRGB(255,255,255)
box.BackgroundTransparency = 1
box.Visible = false
box.Parent = screenGui

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0, 200, 0, 50)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextStrokeTransparency = 0
infoText.TextScaled = true
infoText.Visible = false
infoText.Parent = screenGui

-- 입력
userInput.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Q and not gp then
        lockOn = true
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        lockOn = false

        if highlight then
            highlight:Destroy()
            highlight = nil
        end

        box.Visible = false
        infoText.Visible = false
        currentTarget = nil
    end
end)

-- 가장 가까운 NPC
local function getClosestNPC()
    local closest = nil
    local shortest = math.huge

    for _, npc in pairs(npcFolder:GetChildren()) do
        if npc:FindFirstChild("Head") and npc:FindFirstChild("Humanoid") then
            local head = npc.Head
            local dist = (head.Position - camera.CFrame.Position).Magnitude

            if dist < shortest then
                shortest = dist
                closest = npc
            end
        end
    end

    return closest
end

runService.RenderStepped:Connect(function()
    if lockOn then
        local npc = getClosestNPC()

        if npc and npc:FindFirstChild("Head") then
            local head = npc.Head
            local humanoid = npc:FindFirstChild("Humanoid")

            -- 🎯 에임 고정
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)

            -- 🔵 하이라이트
            if currentTarget ~= npc then
                currentTarget = npc

                if highlight then
                    highlight:Destroy()
                end

                highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(0,0,255)
                highlight.OutlineColor = Color3.fromRGB(0,0,255)
                highlight.FillTransparency = 0.5
                highlight.Parent = npc
            end

            -- 📺 화면 좌표
            local pos, visible = camera:WorldToViewportPoint(head.Position)

            if visible then
                box.Visible = true
                infoText.Visible = true

                -- ⬜ 박스 위치
                box.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 50)

                -- ❤️ 체력 + 📍 좌표
                local hp = humanoid and math.floor(humanoid.Health) or 0
                local position = head.Position

                infoText.Position = UDim2.new(0, pos.X - 100, 0, pos.Y - 80)
                infoText.Text = "HP: "..hp..
                                "\nX:"..math.floor(position.X)..
                                " Y:"..math.floor(position.Y)..
                                " Z:"..math.floor(position.Z)
            else
                box.Visible = false
                infoText.Visible = false
            end
        end
    end
end)
