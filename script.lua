-- rufocheck | Blox Strike
-- Executor: Xeno
-- Client-side

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "rufocheck"
gui.Enabled = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28, 0.35)
frame.Position = UDim2.fromScale(0.05, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0,170,255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.15)
title.Text = "rufocheck"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,170,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Tabs
local espBtn = Instance.new("TextButton", frame)
espBtn.Position = UDim2.fromScale(0.05,0.18)
espBtn.Size = UDim2.fromScale(0.4,0.15)
espBtn.Text = "Smart ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
espBtn.TextColor3 = Color3.fromRGB(0,170,255)

local aimBtn = Instance.new("TextButton", frame)
aimBtn.Position = UDim2.fromScale(0.55,0.18)
aimBtn.Size = UDim2.fromScale(0.4,0.15)
aimBtn.Text = "Aimbot"
aimBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
aimBtn.TextColor3 = Color3.fromRGB(0,170,255)

local espFrame = Instance.new("Frame", frame)
espFrame.Position = UDim2.fromScale(0.05,0.36)
espFrame.Size = UDim2.fromScale(0.9,0.6)
espFrame.BackgroundTransparency = 1

local aimFrame = espFrame:Clone()
aimFrame.Parent = frame
aimFrame.Visible = false

-- ================= ESP =================
local drawings = {}

local function clearESP(plr)
	if drawings[plr] then
		for _,d in pairs(drawings[plr]) do
			d:Remove()
		end
	end
	drawings[plr] = nil
end

local function createESP(plr)
	if plr == LocalPlayer then return end
	drawings[plr] = {
		box = Drawing.new("Square"),
		name = Drawing.new("Text"),
		health = Drawing.new("Text"),
		distance = Drawing.new("Text")
	}
	for _,d in pairs(drawings[plr]) do
		d.Visible = false
		d.Thickness = 1.5
	end
end

RunService.RenderStepped:Connect(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if not drawings[plr] then createESP(plr) end

			local hrp = plr.Character.HumanoidRootPart
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)

			local isEnemy = plr.Team ~= LocalPlayer.Team
			local color = isEnemy and Color3.fromRGB(170,0,255) or Color3.fromRGB(0,255,0)

			if onscreen then
				local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

				local box = drawings[plr].box
				box.Size = Vector2.new(40,60)
				box.Position = Vector2.new(pos.X-20,pos.Y-30)
				box.Color = color
				box.Visible = true

				drawings[plr].name.Text = plr.Name
				drawings[plr].name.Position = Vector2.new(pos.X, pos.Y-40)
				drawings[plr].name.Color = color
				drawings[plr].name.Center = true
				drawings[plr].name.Visible = true

				drawings[plr].health.Text = "HP: "..math.floor(hum.Health)
				drawings[plr].health.Position = Vector2.new(pos.X, pos.Y+35)
				drawings[plr].health.Color = color
				drawings[plr].health.Center = true
				drawings[plr].health.Visible = true

				drawings[plr].distance.Text = math.floor(dist).."m"
				drawings[plr].distance.Position = Vector2.new(pos.X, pos.Y+50)
				drawings[plr].distance.Color = color
				drawings[plr].distance.Center = true
				drawings[plr].distance.Visible = true
			else
				clearESP(plr)
			end
		else
			clearESP(plr)
		end
	end
end)

-- ================= HITBOX EXPANDER =================
local hitboxEnabled = false

local function applyHitbox()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			if hitboxEnabled then
				head.Size = Vector3.new(5,5,5)
				head.Transparency = 0.5
				head.CanCollide = false
			else
				head.Size = Vector3.new(2,1,1)
				head.Transparency = 0
			end
		end
	end
end

local hbBtn = Instance.new("TextButton", aimFrame)
hbBtn.Size = UDim2.fromScale(1,0.3)
hbBtn.Text = "Big Head Mode (5x)"
hbBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
hbBtn.TextColor3 = Color3.fromRGB(0,170,255)

hbBtn.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	applyHitbox()
	hbBtn.Text = hitboxEnabled and "Big Head: ON" or "Big Head: OFF"
end)

-- ================= TAB SWITCH =================
espBtn.MouseButton1Click:Connect(function()
	espFrame.Visible = true
	aimFrame.Visible = false
end)

aimBtn.MouseButton1Click:Connect(function()
	espFrame.Visible = false
	aimFrame.Visible = true
end)

-- ================= KEYBIND =================
UIS.InputBegan:Connect(function(i,gp)
	if not gp and i.KeyCode == Enum.KeyCode.LeftAlt then
		gui.Enabled = not gui.Enabled
	end
end)
