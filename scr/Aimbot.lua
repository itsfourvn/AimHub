--[[

	Universal Aimbot, Triggerbot, Tracer & ESP Module with Glass UI by itsfour
	Bản quyền thuộc về itsfour (https://github.com/itsfourvn)
	Copyright (c) itsfour. All rights reserved.
	Press [RightShift] to Toggle Menu UI

]]

if LPH_OBFUSCATED == nil then 
	LPH_NO_VIRTUALIZE = function(...)
		return ...
	end
end

local game, workspace = game, workspace
local getrawmetatable, pcall, next, tick, getgenv = getrawmetatable, pcall, next, tick, getgenv
local Vector2new, Vector3zero, CFramenew, Color3fromRGB, Color3fromHSV, Drawingnew, TweenInfonew = Vector2.new, Vector3.zero, CFrame.new, Color3.fromRGB, Color3.fromHSV, Drawing and Drawing.new, TweenInfo.new
local mousemoverel, mousemoveabs, tablefind, tableremove, stringlower, stringsub, mathclamp = mousemoverel or (Input and Input.MouseMove), mousemoveabs, table.find, table.remove, string.lower, string.sub, math.clamp
local mouse1press, mouse1release, mouse1click, taskwait = mouse1press, mouse1release, mouse1click, task.wait
local clonefunction, cloneref = clonefunction or LPH_NO_VIRTUALIZE(function(...)
	return ...
end), cloneref or LPH_NO_VIRTUALIZE(function(...)
	return ...
end)

local GameMetatable = getrawmetatable and getrawmetatable(game) or {
	__index = LPH_NO_VIRTUALIZE(function(self, Index)
		return self[Index]
	end),
	__newindex = LPH_NO_VIRTUALIZE(function(self, Index, Value)
		self[Index] = Value
	end)
}

local __index = GameMetatable.__index
local __newindex = GameMetatable.__newindex
local getrenderproperty, setrenderproperty = getrenderproperty or __index, setrenderproperty or __newindex

local _GetService = __index(game, "GetService")
local GetService = function(Service)
	return cloneref(_GetService(game, Service))
end

local RunService = GetService("RunService")
local UserInputService = GetService("UserInputService")
local TweenService = GetService("TweenService")
local Players = GetService("Players")

local LocalPlayer = __index(Players, "LocalPlayer")
local Camera = __index(workspace, "CurrentCamera")

local FindFirstChild, FindFirstChildOfClass = __index(game, "FindFirstChild"), __index(game, "FindFirstChildOfClass")
local GetDescendants = __index(game, "GetDescendants")
local WorldToViewportPoint = __index(Camera, "WorldToViewportPoint")
local GetPartsObscuringTarget = __index(Camera, "GetPartsObscuringTarget")
local GetMouseLocation = __index(UserInputService, "GetMouseLocation")
local GetPlayers = __index(Players, "GetPlayers")
local GetPlayerFromCharacter = __index(Players, "GetPlayerFromCharacter")
local Mouse = __index(LocalPlayer, "GetMouse")(LocalPlayer)
local CameraViewportSize = __index(Camera, "ViewportSize")

local RequiredDistance, Typing, Running, ServiceConnections, Animation, OriginalSensitivity = 2000, false, false, {}
local Connect, Disconnect = __index(game, "DescendantAdded").Connect

do
	local TemporaryConnection = Connect(__index(game, "DescendantAdded"), function() end)
	Disconnect = TemporaryConnection.Disconnect
	Disconnect(TemporaryConnection)
end

getgenv().itsfourDeveloperAimbot = {
	DeveloperSettings = {
		UpdateMode = "RenderStepped",
		TeamCheckOption = "TeamColor",
		RainbowSpeed = 1,
		DisableWarnings = false
	},
	Settings = {
		Enabled = true,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		OffsetToMoveDirection = false,
		OffsetIncrement = 15,
		Sensitivity = 0,
		Sensitivity2 = 1,
		LockMode = 1,
		LockPart = "Head",
		TriggerKey = Enum.UserInputType.MouseButton2,
		Toggle = false
	},
	Triggerbot = {
		Enabled = false,
		TeamCheck = false,
		AliveCheck = true,
		AimLockedCheck = false,
		Delay = 0
	},
	ClosestPlayerTracer = {
		Enabled = false,
		Position = 3,
		Transparency = 0.5,
		Thickness = 1,
		RainbowColor = false,
		Color = Color3fromRGB(150, 150, 255)
	},
	FOVSettings = {
		Enabled = true,
		Visible = true,
		Radius = 180,
		NumSides = 60,
		Thickness = 1,
		Transparency = 1,
		Filled = false,
		RainbowColor = false,
		RainbowOutlineColor = false,
		Color = Color3fromRGB(255, 255, 255),
		OutlineColor = Color3fromRGB(0, 0, 0),
		LockedColor = Color3fromRGB(255, 150, 150)
	},
	ESPSettings = {
		Enabled = true,
		Dot = true,
		DotRadius = 4,
		EnemyDotColor = Color3fromRGB(255, 0, 0),
		TeamDotColor = Color3fromRGB(0, 255, 0),
		Name = true,
		NameSize = 14,
		NameColor = Color3fromRGB(255, 255, 255),
		Distance = true,
		DistanceSize = 13,
		DistanceColor = Color3fromRGB(200, 200, 200),
		TeamCheck = false
	},
	Language = "EN",
	Blacklisted = {},
	FOVCircleOutline = Drawingnew("Circle"),
	FOVCircle = Drawingnew("Circle"),
	Tracer = Drawingnew("Line"),
	ESPObjects = {},
	OriginalDisplayDistanceTypes = {}
}

local Environment, _warn = getgenv().itsfourDeveloperAimbot, clonefunction(warn); warn = function(...)
	return not Environment.DeveloperSettings.DisableWarnings and _warn(...)
end

local ConfigFileName = "itsfour_auto_config.json"

local function AutoSaveConfig()
	if writefile and HttpService then
		pcall(function()
			local encoded = game:GetService("HttpService"):JSONEncode({
				Settings = Environment.Settings,
				Triggerbot = Environment.Triggerbot,
				ClosestPlayerTracer = Environment.ClosestPlayerTracer,
				FOVSettings = {
					Enabled = Environment.FOVSettings.Enabled,
					Radius = Environment.FOVSettings.Radius,
					Color = {Environment.FOVSettings.Color.R, Environment.FOVSettings.Color.G, Environment.FOVSettings.Color.B}
				},
				ESPSettings = Environment.ESPSettings,
				Language = Environment.Language
			})
			writefile(ConfigFileName, encoded)
		end)
	end
end

local function AutoLoadConfig()
	if isfile and isfile(ConfigFileName) then
		pcall(function()
			local decoded = game:GetService("HttpService"):JSONDecode(readfile(ConfigFileName))
			if decoded then
				if decoded.Settings then for k, v in pairs(decoded.Settings) do Environment.Settings[k] = v end end
				if decoded.Triggerbot then for k, v in pairs(decoded.Triggerbot) do Environment.Triggerbot[k] = v end end
				if decoded.ClosestPlayerTracer then for k, v in pairs(decoded.ClosestPlayerTracer) do Environment.ClosestPlayerTracer[k] = v end end
				if decoded.ESPSettings then for k, v in pairs(decoded.ESPSettings) do Environment.ESPSettings[k] = v end end
				if decoded.Language then Environment.Language = decoded.Language end
				if decoded.FOVSettings then
					Environment.FOVSettings.Enabled = decoded.FOVSettings.Enabled
					Environment.FOVSettings.Radius = decoded.FOVSettings.Radius
					if decoded.FOVSettings.Color then
						Environment.FOVSettings.Color = Color3.new(decoded.FOVSettings.Color[1], decoded.FOVSettings.Color[2], decoded.FOVSettings.Color[3])
					end
				end
			end
		end)
	end
end

pcall(AutoLoadConfig)

repeat
	taskwait(0)
until Environment and Environment.FOVCircle and Environment.FOVCircleOutline

setrenderproperty(Environment.FOVCircle, "Visible", false)
setrenderproperty(Environment.FOVCircleOutline, "Visible", false)

local function CreateESP(player)
	if Environment.ESPObjects[player] then return end
	local dot = Drawingnew("Circle")
	dot.Visible = false
	dot.Thickness = 1
	dot.Filled = true
	dot.NumSides = 30
	dot.Transparency = 1

	local nameTag = Drawingnew("Text")
	nameTag.Visible = false
	nameTag.Size = Environment.ESPSettings.NameSize
	nameTag.Center = true
	nameTag.Outline = true

	local distanceTag = Drawingnew("Text")
	distanceTag.Visible = false
	distanceTag.Size = Environment.ESPSettings.DistanceSize
	distanceTag.Center = true
	distanceTag.Outline = true

	Environment.ESPObjects[player] = {Dot = dot, NameTag = nameTag, DistanceTag = distanceTag}
end

local function RestoreDefaultName(player)
	local character = player.Character
	local humanoid = character and FindFirstChildOfClass(character, "Humanoid")
	if humanoid and Environment.OriginalDisplayDistanceTypes[player] then
		pcall(function()
			humanoid.DisplayDistanceType = Environment.OriginalDisplayDistanceTypes[player]
		end)
	end
end

local function RemoveESP(player)
	RestoreDefaultName(player)
	if Environment.ESPObjects[player] then
		for _, obj in pairs(Environment.ESPObjects[player]) do
			pcall(function() obj:Remove() end)
		end
		Environment.ESPObjects[player] = nil
	end
end

for _, p in pairs(GetPlayers(Players)) do
	if p ~= LocalPlayer then
		CreateESP(p)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then
		CreateESP(p)
	end
end)

Players.PlayerRemoving:Connect(function(p)
	RemoveESP(p)
end)

local FixUsername = LPH_NO_VIRTUALIZE(function(String)
	for _, Value in next, GetPlayers(Players) do
		local Name = __index(Value, "Name")
		if stringsub(stringlower(Name), 1, #String) == stringlower(String) then
			return Name
		end
	end
end)

local GetRainbowColor = LPH_NO_VIRTUALIZE(function()
	local RainbowSpeed = Environment.DeveloperSettings.RainbowSpeed
	return Color3fromHSV(tick() % RainbowSpeed / RainbowSpeed, 1, 1)
end)

local ConvertVector = LPH_NO_VIRTUALIZE(function(Vector)
	return Vector2new(Vector.X, Vector.Y)
end)

local CancelLock = LPH_NO_VIRTUALIZE(function()
	Environment.Locked = nil
	setrenderproperty(Environment.FOVCircle, "Color", Environment.FOVSettings.Color)
	__newindex(UserInputService, "MouseDeltaSensitivity", OriginalSensitivity)
	if Animation then
		Animation:Cancel()
	end
	setrenderproperty(Environment.Tracer, "Visible", Environment.ClosestPlayerTracer.Enabled)
end)

local GetClosestPlayer = LPH_NO_VIRTUALIZE(function(Aux)
	local Settings = Environment.Settings
	local LockPart = Settings.LockPart

	if not Environment.Locked or Aux then
		RequiredDistance = Environment.FOVSettings.Enabled and Environment.FOVSettings.Radius or 2000
		Required3DDistance = 10000

		for _, Value in next, GetPlayers(Players) do
			local Character = __index(Value, "Character")
			local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")

			if Value ~= LocalPlayer and not tablefind(Environment.Blacklisted, __index(Value, "Name")) and Character and FindFirstChild(Character, LockPart) and Humanoid then
				local PartPosition, TeamCheckOption = __index(Character[LockPart], "Position"), Environment.DeveloperSettings.TeamCheckOption

				if Settings.TeamCheck and __index(Value, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) then
					continue
				end

				if Settings.AliveCheck and __index(Humanoid, "Health") <= 0 then
					continue
				end

				if Settings.WallCheck then
					local BlacklistTable = GetDescendants(__index(LocalPlayer, "Character"))
					for _, _Value in next, GetDescendants(Character) do
						BlacklistTable[#BlacklistTable + 1] = _Value
					end
					if #GetPartsObscuringTarget(Camera, {PartPosition}, BlacklistTable) > 0 then
						continue
					end
				end

				local Vector, OnScreen, Distance = WorldToViewportPoint(Camera, PartPosition)
				Vector = ConvertVector(Vector)
				Distance = (GetMouseLocation(UserInputService) - Vector).Magnitude
				local _3DDistance = (__index(Camera, "CFrame").Position - PartPosition).Magnitude

				if Distance < RequiredDistance and _3DDistance < Required3DDistance and OnScreen then
					RequiredDistance, Required3DDistance = Distance, _3DDistance
					if not Aux then
						Environment.Locked = Value
					elseif not Running and not Environment.Locked then
						return Value
					end
				end
			end
		end
	elseif (GetMouseLocation(UserInputService) - ConvertVector(WorldToViewportPoint(Camera, __index(__index(__index(Environment.Locked, "Character"), LockPart), "Position")))).Magnitude > RequiredDistance then
		CancelLock()
	end
end)

local Load = function()
	OriginalSensitivity = __index(UserInputService, "MouseDeltaSensitivity")
	local Settings, Triggerbot, Tracer, FOVCircle, FOVCircleOutline, TracerSettings, FOVSettings, Offset = Environment.Settings, Environment.Triggerbot, Environment.Tracer, Environment.FOVCircle, Environment.FOVCircleOutline, Environment.ClosestPlayerTracer, Environment.FOVSettings
	local OffsetToMoveDirection, LockPart = Settings.OffsetToMoveDirection, Settings.LockPart
	local DeveloperSettings = Environment.DeveloperSettings
	local UpdateMode = DeveloperSettings.UpdateMode
	local TeamCheckOption = DeveloperSettings.TeamCheckOption

	if mouse1press and mouse1release then
		ServiceConnections.Triggerbot = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
			if Triggerbot.Enabled and Mouse.Target then
				local Character = Mouse.Target.Parent
				local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
				local Player = GetPlayerFromCharacter(Players, Character)
				if Character and Humanoid and Player then
					if Triggerbot.TeamCheck and __index(Player, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) then
						return
					end
					if Triggerbot.AliveCheck and __index(Humanoid, "Health") <= 0 then
						return
					end
					if Triggerbot.AimLockedCheck and not Environment.Locked then
						return
					end
					if Triggerbot.Delay ~= 0 then
						taskwait(Triggerbot.Delay)
					end
					mouse1press(); __index(RunService, UpdateMode):Wait(); mouse1release(); mouse1click(); __index(RunService, UpdateMode):Wait()
				end
			end
		end))
	end

	ServiceConnections.UpdateTracer = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
		local ClosestPlayer = TracerSettings.Enabled and Settings.Enabled and GetClosestPlayer(true)
		if ClosestPlayer then
			setrenderproperty(Tracer, "Visible", true)
			for Index, Value in next, TracerSettings do
				if Index == "Color" then continue end
				if pcall(getrenderproperty, Tracer, Index) then
					setrenderproperty(Tracer, Index, Value)
				end
			end
			setrenderproperty(Tracer, "Color", TracerSettings.RainbowColor and GetRainbowColor() or TracerSettings.Color)
			if TracerSettings.Position == 1 then
				setrenderproperty(Tracer, "From", Vector2new(CameraViewportSize.X / 2, CameraViewportSize.Y))
			elseif TracerSettings.Position == 2 then
				setrenderproperty(Tracer, "From", CameraViewportSize / 2)
			elseif TracerSettings.Position == 3 then
				setrenderproperty(Tracer, "From", GetMouseLocation(UserInputService))
			else
				TracerSettings.Position = 3
			end
			setrenderproperty(Tracer, "To", ConvertVector(WorldToViewportPoint(Camera, __index(__index(ClosestPlayer, "Character")[Settings.LockPart], "Position"))))
		else
			setrenderproperty(Tracer, "Visible", false)
		end
	end))

	ServiceConnections.RenderSteppedConnection = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
		for player, objects in pairs(Environment.ESPObjects) do
			local character = player.Character
			local humanoid = character and FindFirstChildOfClass(character, "Humanoid")
			local head = character and FindFirstChild(character, "Head")
			local rootPart = character and FindFirstChild(character, "HumanoidRootPart")
			
			local showESP = Environment.ESPSettings.Enabled and character and head and rootPart and humanoid and humanoid.Health > 0
			if showESP and Environment.ESPSettings.TeamCheck and player[TeamCheckOption] == LocalPlayer[TeamCheckOption] then
				showESP = false
			end

			if humanoid then
				if Environment.ESPSettings.Enabled and Environment.ESPSettings.Name and showESP then
					if not Environment.OriginalDisplayDistanceTypes[player] then
						Environment.OriginalDisplayDistanceTypes[player] = humanoid.DisplayDistanceType
					end
					humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				else
					if Environment.OriginalDisplayDistanceTypes[player] then
						humanoid.DisplayDistanceType = Environment.OriginalDisplayDistanceTypes[player]
					end
				end
			end

			if showESP then
				local defaultNamePos = head.Position + Vector3.new(0, 2.2, 0)
				local dotVector, dotOnScreen = WorldToViewportPoint(Camera, defaultNamePos)

				if dotOnScreen then
					if Environment.ESPSettings.Dot then
						objects.Dot.Visible = true
						objects.Dot.Position = Vector2.new(dotVector.X, dotVector.Y)
						objects.Dot.Radius = Environment.ESPSettings.DotRadius
						local isTeam = (player[TeamCheckOption] == LocalPlayer[TeamCheckOption])
						objects.Dot.Color = isTeam and Environment.ESPSettings.TeamDotColor or Environment.ESPSettings.EnemyDotColor
					else
						objects.Dot.Visible = false
					end

					if Environment.ESPSettings.Name then
						objects.NameTag.Visible = true
						objects.NameTag.Size = Environment.ESPSettings.NameSize
						objects.NameTag.Color = Environment.ESPSettings.NameColor
						objects.NameTag.Text = player.DisplayName .. " (@" .. player.Name .. ")"
						local offsetNameY = Environment.ESPSettings.Dot and (Environment.ESPSettings.DotRadius + Environment.ESPSettings.NameSize + 2) or (Environment.ESPSettings.NameSize + 2)
						objects.NameTag.Position = Vector2.new(dotVector.X, dotVector.Y - offsetNameY)
					else
						objects.NameTag.Visible = false
					end

					if Environment.ESPSettings.Distance then
						objects.DistanceTag.Visible = true
						objects.DistanceTag.Size = Environment.ESPSettings.DistanceSize
						objects.DistanceTag.Color = Environment.ESPSettings.DistanceColor
						local localChar = LocalPlayer.Character
						local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
						local distanceMeters = localRoot and math.floor((rootPart.Position - localRoot.Position).Magnitude) or 0
						objects.DistanceTag.Text = tostring(distanceMeters) .. "m"
						local offsetDistY = Environment.ESPSettings.Dot and (Environment.ESPSettings.DotRadius + 4) or 4
						objects.DistanceTag.Position = Vector2.new(dotVector.X, dotVector.Y + offsetDistY)
					else
						objects.DistanceTag.Visible = false
					end
				else
					objects.Dot.Visible = false
					objects.NameTag.Visible = false
					objects.DistanceTag.Visible = false
				end
			else
				objects.Dot.Visible = false
				objects.NameTag.Visible = false
				objects.DistanceTag.Visible = false
			end
		end

		if FOVSettings.Enabled and Settings.Enabled then
			for Index, Value in next, FOVSettings do
				if Index == "Color" then continue end
				if pcall(getrenderproperty, FOVCircle, Index) then
					setrenderproperty(FOVCircle, Index, Value)
					setrenderproperty(FOVCircleOutline, Index, Value)
				end
			end
			setrenderproperty(FOVCircle, "Color", (Environment.Locked and FOVSettings.LockedColor) or FOVSettings.RainbowColor and GetRainbowColor() or FOVSettings.Color)
			setrenderproperty(FOVCircleOutline, "Color", FOVSettings.RainbowOutlineColor and GetRainbowColor() or FOVSettings.OutlineColor)
			setrenderproperty(FOVCircleOutline, "Thickness", FOVSettings.Thickness + 1)
			setrenderproperty(FOVCircle, "Position", GetMouseLocation(UserInputService))
			setrenderproperty(FOVCircleOutline, "Position", GetMouseLocation(UserInputService))
		else
			setrenderproperty(FOVCircle, "Visible", false)
			setrenderproperty(FOVCircleOutline, "Visible", false)
		end

		if Running and Settings.Enabled then
			GetClosestPlayer()
			Offset = Settings.OffsetToMoveDirection and __index(FindFirstChildOfClass(__index(Environment.Locked, "Character"), "Humanoid"), "MoveDirection") * (mathclamp(Settings.OffsetIncrement, 1, 30) / 10) or Vector3zero

			if Environment.Locked then
				local LockedPosition_Vector3 = __index(__index(Environment.Locked, "Character")[Settings.LockPart], "Position")
				local LockedPosition = WorldToViewportPoint(Camera, LockedPosition_Vector3 + Offset)

				if Settings.LockMode == 2 then
					mousemoverel((LockedPosition.X - GetMouseLocation(UserInputService).X) / Settings.Sensitivity2, (LockedPosition.Y - GetMouseLocation(UserInputService).Y) / Settings.Sensitivity2)
				elseif Settings.LockMode == 3 and mousemoveabs then
					mousemoveabs(LockedPosition.X, LockedPosition.Y)
				else
					if Settings.Sensitivity > 0 then
						Animation = TweenService:Create(Camera, TweenInfonew(Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFramenew(Camera.CFrame.Position, LockedPosition_Vector3 + Offset)})
						Animation:Play()
					else
						__newindex(Camera, "CFrame", CFramenew(Camera.CFrame.Position, LockedPosition_Vector3 + Offset))
					end
					__newindex(UserInputService, "MouseDeltaSensitivity", 0)
				end

				setrenderproperty(FOVCircle, "Color", FOVSettings.LockedColor)
				setrenderproperty(Tracer, "Visible", false)
			end
		end
	end))

	ServiceConnections.InputBeganConnection = Connect(__index(UserInputService, "InputBegan"), LPH_NO_VIRTUALIZE(function(Input)
		if Typing then return end
		local TriggerKey, Toggle = Settings.TriggerKey, Settings.Toggle
		if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == TriggerKey or Input.UserInputType == TriggerKey then
			if Toggle then
				Running = not Running
				if not Running then CancelLock() end
			else
				Running = true
			end
		end
	end))

	ServiceConnections.InputEndedConnection = Connect(__index(UserInputService, "InputEnded"), LPH_NO_VIRTUALIZE(function(Input)
		if Typing then return end
		local TriggerKey = Settings.TriggerKey
		if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == TriggerKey or Input.UserInputType == TriggerKey then
			Running = false; CancelLock()
		end
	end))
end

ServiceConnections.TypingStartedConnection = Connect(__index(UserInputService, "TextBoxFocused"), function()
	Typing = true
end)

ServiceConnections.TypingEndedConnection = Connect(__index(UserInputService, "TextBoxFocusReleased"), function()
	Typing = false
end)

local Translations = {
	EN = {
		SubTitle = "| itsfourvn ([RightShift])",
		Tabs = {"Aimbot", "Trigger", "Visuals"},
		Sections = {
			AimbotCore = "Aimbot Core Settings",
			TargetPref = "Target & Locking Preferences",
			TriggerConf = "Triggerbot Configuration",
			FOVSettings = "FOV Settings",
			TracerLines = "Tracer Lines",
			ESPEnhance = "ESP Enhancements"
		},
		Labels = {
			AimbotEnabled = "Aimbot Enabled",
			TeamCheck = "Team Check",
			AliveCheck = "Alive Check",
			WallCheck = "Wall Check",
			ToggleMode = "Toggle Mode",
			LockPart = "Lock Part",
			LockMode = "Lock Mode",
			Smoothness = "Smoothness",
			Sens2 = "Sensitivity 2",
			PredOffset = "Prediction Offset",
			OffsetAmount = "Offset Amount",
			TrigEnabled = "Triggerbot Enabled",
			TrigTeamCheck = "Trigger Team Check",
			TrigAliveCheck = "Trigger Alive Check",
			AimLockedOnly = "Aim Locked Only",
			TrigDelay = "Trigger Delay",
			FOVEnabled = "FOV Enabled",
			FOVRadius = "FOV Radius",
			FOVColor = "FOV Circle Color",
			TracerEnabled = "Tracer Enabled",
			TracerOrigin = "Tracer Origin",
			TracerColor = "Tracer Color",
			ESPEnabled = "ESP Enabled",
			ESPHeadDot = "ESP Head Dot",
			DotRadius = "Dot Radius",
			EnemyDotColor = "Enemy Dot Color",
			TeamDotColor = "Team Dot Color",
			ESPName = "ESP Name",
			NameFontSize = "Name Font Size",
			NameColor = "Name Color",
			ESPDistance = "ESP Distance",
			DistFontSize = "Distance Font Size",
			DistColor = "Distance Color"
		}
	},
	VN = {
		SubTitle = "| itsfourvn ([RightShift])",
		Tabs = {"Aimbot", "Trigger", "Visuals"},
		Sections = {
			AimbotCore = "Cài Đặt Aimbot",
			TargetPref = "Tùy Chỉnh Mục Tiêu",
			TriggerConf = "Cấu Hình Triggerbot",
			FOVSettings = "Cài Đặt Vòng FOV",
			TracerLines = "Đường Kẻ Tracer",
			ESPEnhance = "Cải Tiến ESP"
		},
		Labels = {
			AimbotEnabled = "Bật Aimbot",
			TeamCheck = "Kiểm Tra Team",
			AliveCheck = "Kiểm Tra Sống",
			WallCheck = "Kiểm Tra Tường",
			ToggleMode = "Chế Độ Toggle",
			LockPart = "Bộ Phận Khóa",
			LockMode = "Chế Độ Khóa",
			Smoothness = "Độ Mượt",
			Sens2 = "Độ Nhạy 2",
			PredOffset = "Dự Đoán Hướng",
			OffsetAmount = "Mức Dự Đoán",
			TrigEnabled = "Bật Triggerbot",
			TrigTeamCheck = "Trigger Team Check",
			TrigAliveCheck = "Trigger Alive Check",
			AimLockedOnly = "Chỉ Bắn Khi Khóa",
			TrigDelay = "Độ Trễ Trigger",
			FOVEnabled = "Bật Vòng FOV",
			FOVRadius = "Bán Kính FOV",
			FOVColor = "Màu Vòng FOV",
			TracerEnabled = "Bật Tracer",
			TracerOrigin = "Nguồn Tracer",
			TracerColor = "Màu Tracer",
			ESPEnabled = "Bật ESP",
			ESPHeadDot = "Chấm Trên Đầu",
			DotRadius = "Bán Kính Chấm",
			EnemyDotColor = "Màu Chấm Địch",
			TeamDotColor = "Màu Chấm Team",
			ESPName = "Hiện Tên",
			NameFontSize = "Cỡ Chữ Tên",
			NameColor = "Màu Tên",
			ESPDistance = "Hiện Khoảng Cách",
			DistFontSize = "Cỡ Chữ Khoảng Cách",
			DistColor = "Màu Khoảng Cách"
		}
	}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "itsfourGlassMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local MainBlur = Instance.new("UIStroke")
MainBlur.Parent = MainFrame
MainBlur.Color = Color3.fromRGB(255, 255, 255)
MainBlur.Transparency = 0.7
MainBlur.Thickness = 1

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BackgroundTransparency = 0.4
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local FixCover = Instance.new("Frame")
FixCover.Parent = TopBar
FixCover.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
FixCover.BackgroundTransparency = 0.4
FixCover.BorderSizePixel = 0
FixCover.Position = UDim2.new(0, 0, 1, -5)
FixCover.Size = UDim2.new(1, 0, 0, 5)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 110, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "ITSFOUR HUB"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TopBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 115, 0, 0)
SubTitle.Size = UDim2.new(0, 180, 1, 0)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = Translations[Environment.Language].SubTitle
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -35, 0.2, 0)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Text = "X"

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	Environment:Exit()
end)

local LangBtn = Instance.new("TextButton")
LangBtn.Parent = TopBar
LangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
LangBtn.BackgroundTransparency = 0.3
LangBtn.BorderSizePixel = 0
LangBtn.Position = UDim2.new(1, -95, 0.2, 0)
LangBtn.Size = UDim2.new(0, 55, 0, 26)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
LangBtn.TextSize = 12
LangBtn.Text = Environment.Language

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 15, 0, 55)
ContentContainer.Size = UDim2.new(1, -30, 1, -65)

local Tabs = {
	Aimbot = Instance.new("ScrollingFrame"),
	Trigger = Instance.new("ScrollingFrame"),
	Visuals = Instance.new("ScrollingFrame")
}

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Parent = MainFrame
TabButtonsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabButtonsContainer.BackgroundTransparency = 0.5
TabButtonsContainer.BorderSizePixel = 0
TabButtonsContainer.Position = UDim2.new(0, 15, 0, 55)
TabButtonsContainer.Size = UDim2.new(1, -30, 0, 35)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabButtonsContainer

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtonsContainer
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local tabContentFrames = {}
local tabButtonsList = {}

for name, frame in pairs(Tabs) do
	frame.Parent = ContentContainer
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new(0, 0, 0, 42)
	frame.Size = UDim2.new(1, 0, 1, -42)
	frame.CanvasSize = UDim2.new(0, 0, 0, 1450)
	frame.ScrollBarThickness = 3
	frame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
	frame.Visible = (name == "Aimbot")
	
	local layout = Instance.new("UIListLayout")
	layout.Parent = frame
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	
	tabContentFrames[name] = frame
end

local tabNames = {"Aimbot", "Trigger", "Visuals"}
for i, tName in ipairs(tabNames) do
	local tBtn = Instance.new("TextButton")
	tBtn.Parent = TabButtonsContainer
	tBtn.BackgroundColor3 = (tName == "Aimbot") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 45)
	tBtn.BackgroundTransparency = (tName == "Aimbot") and 0.1 or 0.5
	tBtn.BorderSizePixel = 0
	tBtn.Size = UDim2.new(0.32, 0, 0.8, 0)
	tBtn.Position = UDim2.new(0, 0, 0.1, 0)
	tBtn.Font = Enum.Font.GothamBold
	tBtn.TextColor3 = (tName == "Aimbot") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
	tBtn.TextSize = 13
	tBtn.Text = string.upper(tName)
	tBtn:SetAttribute("TabKey", tName)
	
	table.insert(tabButtonsList, tBtn)
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tBtn
	
	tBtn.MouseButton1Click:Connect(function()
		for name, frame in pairs(tabContentFrames) do
			frame.Visible = (name == tName)
		end
		for _, child in ipairs(TabButtonsContainer:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
				child.BackgroundTransparency = 0.5
				child.TextColor3 = Color3.fromRGB(180, 180, 190)
			end
		end
		tBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		tBtn.BackgroundTransparency = 0.1
		tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

local currentParentTab = Tabs.Aimbot

local function CreateSectionHeader(textKey)
	local Label = Instance.new("TextLabel")
	Label.Parent = currentParentTab
	Label.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	Label.BackgroundTransparency = 0.6
	Label.BorderSizePixel = 0
	Label.Size = UDim2.new(0, 500, 0, 28)
	Label.Font = Enum.Font.GothamBold
	Label.TextColor3 = Color3.fromRGB(0, 170, 255)
	Label.TextSize = 12
	Label.Text = "  ✦ " .. string.upper(Translations[Environment.Language].Sections[textKey] or textKey)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label:SetAttribute("LangKey", textKey)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Label
end

local function CreateToggle(nameKey, default, callback)
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = currentParentTab
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	ToggleBtn.BackgroundTransparency = 0.4
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Size = UDim2.new(0, 500, 0, 36)
	ToggleBtn.Font = Enum.Font.Gotham
	ToggleBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
	ToggleBtn.TextSize = 13
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
	ToggleBtn.Text = "    " .. (Translations[Environment.Language].Labels[nameKey] or nameKey)
	ToggleBtn:SetAttribute("LangKey", nameKey)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = ToggleBtn
	
	local StatusIndicator = Instance.new("Frame")
	StatusIndicator.Parent = ToggleBtn
	StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
	StatusIndicator.BackgroundColor3 = default and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(70, 70, 80)
	StatusIndicator.Position = UDim2.new(1, -15, 0.5, 0)
	StatusIndicator.Size = UDim2.new(0, 36, 0, 18)
	
	local IndCorner = Instance.new("UICorner")
	IndCorner.CornerRadius = UDim.new(1, 0)
	IndCorner.Parent = StatusIndicator
	
	local Circle = Instance.new("Frame")
	Circle.Parent = StatusIndicator
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	Circle.Size = UDim2.new(0, 14, 0, 14)
	
	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle
	
	local state = default
	ToggleBtn.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(70, 70, 80)}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
		callback(state)
		AutoSaveConfig()
	end)
end

local function CreateToggleWithColor(nameKey, defaultState, defaultColor, stateCallback, colorCallback)
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = currentParentTab
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	ToggleBtn.BackgroundTransparency = 0.4
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Size = UDim2.new(0, 500, 0, 36)
	ToggleBtn.Font = Enum.Font.Gotham
	ToggleBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
	ToggleBtn.TextSize = 13
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
	ToggleBtn.Text = "    " .. (Translations[Environment.Language].Labels[nameKey] or nameKey)
	ToggleBtn:SetAttribute("LangKey", nameKey)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = ToggleBtn
	
	local ColorDropdownBtn = Instance.new("TextButton")
	ColorDropdownBtn.Parent = ToggleBtn
	ColorDropdownBtn.AnchorPoint = Vector2.new(1, 0.5)
	ColorDropdownBtn.BackgroundColor3 = defaultColor
	ColorDropdownBtn.Position = UDim2.new(1, -60, 0.5, 0)
	ColorDropdownBtn.Size = UDim2.new(0, 26, 0, 20)
	ColorDropdownBtn.Text = ""
	
	local ColorCorner = Instance.new("UICorner")
	ColorCorner.CornerRadius = UDim.new(0, 4)
	ColorCorner.Parent = ColorDropdownBtn
	
	local ColorListFrame = Instance.new("Frame")
	ColorListFrame.Parent = MainFrame
	ColorListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	ColorListFrame.BackgroundTransparency = 0.1
	ColorListFrame.BorderSizePixel = 0
	ColorListFrame.Size = UDim2.new(0, 130, 0, 160)
	ColorListFrame.Visible = false
	ColorListFrame.ZIndex = 10
	
	local ListCorner = Instance.new("UICorner")
	ListCorner.CornerRadius = UDim.new(0, 6)
	ListCorner.Parent = ColorListFrame
	
	local UIListLayoutColors = Instance.new("UIListLayout")
	UIListLayoutColors.Parent = ColorListFrame
	UIListLayoutColors.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayoutColors.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayoutColors.Padding = UDim.new(0, 5)
	
	local palette = {
		{Color3.fromRGB(255, 60, 60), "Đỏ"},
		{Color3.fromRGB(60, 255, 100), "Xanh lá"},
		{Color3.fromRGB(0, 170, 255), "Xanh dương"},
		{Color3.fromRGB(255, 220, 0), "Vàng"},
		{Color3.fromRGB(255, 100, 255), "Hồng"},
		{Color3.fromRGB(255, 255, 255), "Trắng"}
	}
	
	for _, item in ipairs(palette) do
		local cBtn = Instance.new("TextButton")
		cBtn.Parent = ColorListFrame
		cBtn.BackgroundColor3 = item[1]
		cBtn.BorderSizePixel = 0
		cBtn.Size = UDim2.new(0.9, 0, 0, 20)
		cBtn.Text = ""
		local cCorner = Instance.new("UICorner")
		cCorner.CornerRadius = UDim.new(0, 4)
		cCorner.Parent = cBtn
		cBtn.MouseButton1Click:Connect(function()
			ColorDropdownBtn.BackgroundColor3 = item[1]
			ColorListFrame.Visible = false
			colorCallback(item[1])
			AutoSaveConfig()
		end)
	end
	
	ColorDropdownBtn.MouseButton1Click:Connect(function()
		local absPos = ColorDropdownBtn.AbsolutePosition
		local mainPos = MainFrame.AbsolutePosition
		ColorListFrame.Position = UDim2.new(0, absPos.X - mainPos.X - 100, 0, absPos.Y - mainPos.Y + 30)
		ColorListFrame.Visible = not ColorListFrame.Visible
	end)

	local StatusIndicator = Instance.new("Frame")
	StatusIndicator.Parent = ToggleBtn
	StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
	StatusIndicator.BackgroundColor3 = defaultState and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(70, 70, 80)
	StatusIndicator.Position = UDim2.new(1, -15, 0.5, 0)
	StatusIndicator.Size = UDim2.new(0, 36, 0, 18)
	
	local IndCorner = Instance.new("UICorner")
	IndCorner.CornerRadius = UDim.new(1, 0)
	IndCorner.Parent = StatusIndicator
	
	local Circle = Instance.new("Frame")
	Circle.Parent = StatusIndicator
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	Circle.Size = UDim2.new(0, 14, 0, 14)
	
	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle
	
	local state = defaultState
	ToggleBtn.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(70, 70, 80)}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
		stateCallback(state)
		AutoSaveConfig()
	end)
end

local function CreateSelector(nameKey, options, defaultIndex, callback)
	local Container = Instance.new("Frame")
	Container.Parent = currentParentTab
	Container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	Container.BackgroundTransparency = 0.4
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(0, 500, 0, 36)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Parent = Container
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Font = Enum.Font.Gotham
	Label.TextColor3 = Color3.fromRGB(230, 230, 240)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Text = Translations[Environment.Language].Labels[nameKey] or nameKey
	Label:SetAttribute("LangKey", nameKey)
	
	local currentIdx = defaultIndex
	local Btn = Instance.new("TextButton")
	Btn.Parent = Container
	
	local CurveBg = Instance.new("UICorner")
	CurveBg.CornerRadius = UDim.new(0, 4)
	CurveBg.Parent = Btn
	
	Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	Btn.BackgroundTransparency = 0.3
	Btn.BorderSizePixel = 0
	Btn.Position = UDim2.new(0.5, 0, 0.15, 0)
	Btn.Size = UDim2.new(0.47, 0, 0.7, 0)
	Btn.Font = Enum.Font.GothamBold
	Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
	Btn.TextSize = 12
	Btn.Text = tostring(options[currentIdx])
	
	Btn.MouseButton1Click:Connect(function()
		currentIdx = currentIdx + 1
		if currentIdx > #options then currentIdx = 1 end
		Btn.Text = tostring(options[currentIdx])
		callback(options[currentIdx], currentIdx)
		AutoSaveConfig()
	end)
end

local function CreateSlider(nameKey, min, max, default, isFloat, callback)
	local Container = Instance.new("Frame")
	Container.Parent = currentParentTab
	Container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	Container.BackgroundTransparency = 0.4
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(0, 500, 0, 50)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Parent = Container
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 15, 0, 6)
	Label.Size = UDim2.new(1, -30, 0, 20)
	Label.Font = Enum.Font.Gotham
	Label.TextColor3 = Color3.fromRGB(230, 230, 240)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Text = Translations[Environment.Language].Labels[nameKey] or nameKey
	Label:SetAttribute("LangKey", nameKey)
	
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Parent = Container
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Position = UDim2.new(0, -15, 0, 6)
	ValueLabel.Size = UDim2.new(1, 0, 0, 20)
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Text = tostring(default)
	
	local SliderBar = Instance.new("TextButton")
	SliderBar.Parent = Container
	SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	SliderBar.BackgroundTransparency = 0.3
	SliderBar.BorderSizePixel = 0
	SliderBar.Position = UDim2.new(0, 15, 0, 32)
	SliderBar.Size = UDim2.new(0, 470, 0, 6)
	SliderBar.Text = ""
	
	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = SliderBar
	
	local SliderFill = Instance.new("Frame")
	SliderFill.Parent = SliderBar
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	SliderFill.BorderSizePixel = 0
	SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	
	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = SliderFill
	
	local dragging = false
	SliderBar.MouseButton1Down:Connect(function() dragging = true end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if dragging then AutoSaveConfig() end
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local barPos = SliderBar.AbsolutePosition.X
			local barSize = SliderBar.AbsoluteSize.X
			local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
			SliderFill.Size = UDim2.new(percent, 0, 1, 0)
			local value = min + (max - min) * percent
			if isFloat then
				value = math.floor(value * 100) / 100
			else
				value = math.floor(value)
			end
			ValueLabel.Text = tostring(value)
			callback(value)
		end
	end)
end

currentParentTab = Tabs.Aimbot

CreateSectionHeader("AimbotCore")
CreateToggle("AimbotEnabled", Environment.Settings.Enabled, function(v) Environment.Settings.Enabled = v end)
CreateToggle("TeamCheck", Environment.Settings.TeamCheck, function(v) Environment.Settings.TeamCheck = v end)
CreateToggle("AliveCheck", Environment.Settings.AliveCheck, function(v) Environment.Settings.AliveCheck = v end)
CreateToggle("WallCheck", Environment.Settings.WallCheck, function(v) Environment.Settings.WallCheck = v end)
CreateToggle("ToggleMode", Environment.Settings.Toggle, function(v) Environment.Settings.Toggle = v end)

CreateSectionHeader("TargetPref")
CreateSelector("LockPart", {"Head", "HumanoidRootPart", "Torso"}, 1, function(v) Environment.Settings.LockPart = v end)
CreateSelector("LockMode", {"1 (Camera Smooth)", "2 (Mouse Rel)", "3 (Mouse Abs)"}, 1, function(v, idx) Environment.Settings.LockMode = idx end)
CreateSlider("Smoothness", 0, 1, Environment.Settings.Sensitivity, true, function(v) Environment.Settings.Sensitivity = v end)
CreateSlider("Sens2", 1, 10, Environment.Settings.Sensitivity2, true, function(v) Environment.Settings.Sensitivity2 = v end)
CreateToggle("PredOffset", Environment.Settings.OffsetToMoveDirection, function(v) Environment.Settings.OffsetToMoveDirection = v end)
CreateSlider("OffsetAmount", 1, 30, Environment.Settings.OffsetIncrement, false, function(v) Environment.Settings.OffsetIncrement = v end)

currentParentTab = Tabs.Trigger

CreateSectionHeader("TriggerConf")
CreateToggle("TrigEnabled", Environment.Triggerbot.Enabled, function(v) Environment.Triggerbot.Enabled = v end)
CreateToggle("TrigTeamCheck", Environment.Triggerbot.TeamCheck, function(v) Environment.Triggerbot.TeamCheck = v end)
CreateToggle("TrigAliveCheck", Environment.Triggerbot.AliveCheck, function(v) Environment.Triggerbot.AliveCheck = v end)
CreateToggle("AimLockedOnly", Environment.Triggerbot.AimLockedCheck, function(v) Environment.Triggerbot.AimLockedCheck = v end)
CreateSlider("TrigDelay", 0, 1, Environment.Triggerbot.Delay, true, function(v) Environment.Triggerbot.Delay = v end)

currentParentTab = Tabs.Visuals

CreateSectionHeader("FOVSettings")
CreateToggleWithColor("FOVEnabled", Environment.FOVSettings.Enabled, Environment.FOVSettings.Color, function(v) Environment.FOVSettings.Enabled = v end, function(c) Environment.FOVSettings.Color = c end)
CreateSlider("FOVRadius", 30, 500, Environment.FOVSettings.Radius, false, function(v) Environment.FOVSettings.Radius = v end)

CreateSectionHeader("TracerLines")
CreateToggleWithColor("TracerEnabled", Environment.ClosestPlayerTracer.Enabled, Environment.ClosestPlayerTracer.Color, function(v) Environment.ClosestPlayerTracer.Enabled = v end, function(c) Environment.ClosestPlayerTracer.Color = c end)
CreateSelector("TracerOrigin", {"1 (Bottom Screen)", "2 (Center Screen)", "3 (Mouse Cursor)"}, 3, function(v, idx) Environment.ClosestPlayerTracer.Position = idx end)

CreateSectionHeader("ESPEnhance")
CreateToggle("ESPEnabled", Environment.ESPSettings.Enabled, function(v) Environment.ESPSettings.Enabled = v end)
CreateToggleWithColor("ESPHeadDot", Environment.ESPSettings.Dot, Environment.ESPSettings.EnemyDotColor, function(v) Environment.ESPSettings.Dot = v end, function(c) Environment.ESPSettings.EnemyDotColor = c end)
CreateSlider("DotRadius", 1, 15, Environment.ESPSettings.DotRadius, false, function(v) Environment.ESPSettings.DotRadius = v end)

CreateToggleWithColor("ESPName", Environment.ESPSettings.Name, Environment.ESPSettings.NameColor, function(v) Environment.ESPSettings.Name = v end, function(c) Environment.ESPSettings.NameColor = c end)
CreateSlider("NameFontSize", 10, 24, Environment.ESPSettings.NameSize, false, function(v) Environment.ESPSettings.NameSize = v end)

CreateToggleWithColor("ESPDistance", Environment.ESPSettings.Distance, Environment.ESPSettings.DistanceColor, function(v) Environment.ESPSettings.Distance = v end, function(c) Environment.ESPSettings.DistanceColor = c end)
CreateSlider("DistFontSize", 10, 24, Environment.ESPSettings.DistanceSize, false, function(v) Environment.ESPSettings.DistanceSize = v end)

local function UpdateLanguageUI()
	local t = Translations[Environment.Language]
	SubTitle.Text = t.SubTitle
	LangBtn.Text = Environment.Language
	for _, btn in ipairs(tabButtonsList) do
		local key = btn:GetAttribute("TabKey")
		if key == "Aimbot" then btn.Text = "AIMBOT"
		elseif key == "Trigger" then btn.Text = "TRIGGER"
		elseif key == "Visuals" then btn.Text = "VISUALS"
		end
	end
	for _, frame in pairs(tabContentFrames) do
		for _, descendant in ipairs(frame:GetDescendants()) do
			local langKey = descendant:GetAttribute("LangKey")
			if langKey then
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
					if t.Labels[langKey] then
						descendant.Text = (descendant.Text:match("^%s*") or "    ") .. t.Labels[langKey]
					elseif t.Sections[langKey] then
						descendant.Text = "  ✦ " .. string.upper(t.Sections[langKey])
					end
				end
			end
		end
	end
end

LangBtn.MouseButton1Click:Connect(function()
	if Environment.Language == "EN" then
		Environment.Language = "VN"
	else
		Environment.Language = "EN"
	end
	UpdateLanguageUI()
	AutoSaveConfig()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

Environment.Exit = LPH_NO_VIRTUALIZE(function(self)
	assert(self, "itsfour_AimHub.Exit: Missing parameter #1 \"self\" <table>.")
	for Index, _ in next, ServiceConnections do
		pcall(Disconnect, ServiceConnections[Index])
	end
	for player, _ in pairs(Environment.ESPObjects) do
		RestoreDefaultName(player)
	end
	for _, objs in pairs(Environment.ESPObjects) do
		for _, obj in pairs(objs) do
			pcall(function() obj:Remove() end)
		end
	end
	Load = nil; ConvertVector = nil; CancelLock = nil; GetClosestPlayer = nil; GetRainbowColor = nil; FixUsername = nil
	self.FOVCircle:Remove()
	self.FOVCircleOutline:Remove()
	self.Tracer:Remove()
	ScreenGui:Destroy()
	getgenv().itsfourDeveloperAimbot = nil; pcall(collectgarbage, "step", 200)
end)

Environment.Restart = LPH_NO_VIRTUALIZE(function()
	for Index, _ in next, ServiceConnections do
		pcall(Disconnect, ServiceConnections[Index])
	end
	Load()
end)

Environment.Blacklist = LPH_NO_VIRTUALIZE(function(self, Username)
	assert(self, "itsfour_AimHub.Blacklist: Missing parameter #1 \"self\" <table>.")
	assert(Username, "itsfour_AimHub.Blacklist: Missing parameter #2 \"Username\" <string>.")
	Username = FixUsername(Username)
	assert(self, "itsfour_AimHub.Blacklist: User "..Username.." couldn't be found.")
	self.Blacklisted[#self.Blacklisted + 1] = Username
end)

Environment.Whitelist = LPH_NO_VIRTUALIZE(function(self, Username)
	assert(self, "itsfour_AimHub.Whitelist: Missing parameter #1 \"self\" <table>.")
	assert(Username, "itsfour_AimHub.Whitelist: Missing parameter #2 \"Username\" <string>.")
	Username = FixUsername(Username)
	assert(Username, "itsfour_AimHub.Whitelist: User "..Username.." couldn't be found.")
	local Index = tablefind(self.Blacklisted, Username)
	assert(Index, "itsfour_AimHub.Whitelist: User "..Username.." is not blacklisted.")
	tableremove(self.Blacklisted, Index)
end)

Environment.GetClosestPlayer = LPH_NO_VIRTUALIZE(function()
	return GetClosestPlayer(true)
end)

Environment.Load = Load

setmetatable(Environment, {
	__call = Load
})

Load()
UpdateLanguageUI()
