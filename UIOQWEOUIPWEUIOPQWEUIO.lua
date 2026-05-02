local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local npcFolder = workspace:WaitForChild("NPCs")

local lockOn = false

-- Q 입력
userInput.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Q and not gp then
		lockOn = true
	end
end)

userInput.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Q then
		lockOn = false
	end
end)

-- ✅ "사람"인지 확인
local function isHuman(character)
	return character:FindFirstChild("Humanoid") 
	   and character:FindFirstChild("Head")
end

-- 가장 가까운 "사람" 찾기
local function getClosestNPC()
	local closest = nil
	local shortest = math.huge

	for _, npc in pairs(npcFolder:GetChildren()) do
		if isHuman(npc) then
			local head = npc.Head
			local dist = (head.Position - camera.CFrame.Position).Magnitude

			if dist < shortest then
				shortest = dist
				closest = head
			end
		end
	end

	return closest
end

-- 에임 고정
runService.RenderStepped:Connect(function()
	if lockOn then
		local target = getClosestNPC()
		if target then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
		end
	end
end)
