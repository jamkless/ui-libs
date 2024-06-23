local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/siernlib/main/library.lua"))()
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local win = Library:Create({
    Name = "jamkles lua"
})

local Lock = win:Tab('Legit')
local Cam = Lock:Section('Camlock')

Cam:Button('Load Tool', function()
    local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "jamkles.lua"
Tool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer

local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end

connectCharacterAdded()

player.CharacterRemoving:Connect(function()
    Tool.Parent = game.Players.LocalPlayer.Backpack
end)
end)


Cam:Textbox('Prediction ', function(v)
    jamkles.jamky_settings.prediction = v
end)

Cam:Textbox('smoothness ', function(v)
    jamkles.jamky_settings.smoothness = v
end)

Cam:Textbox('Shake ', function(v)
    jamkles.jamky_settings.shake_value = v
end)

local dropdown = Cam:Dropdown("Aimparts", {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg",  "LeftUpperLeg", "RightLowerLeg", "RightFoot",  "RightUpperLeg" },"UpperTorso", function(v)
    jamkles.jamky_settings.aim_part(v)
end)

local jamkles = {
    jamky_settings = {
    prediction = 0.135,
    smoothness = 0.9,
    aim_part = "UpperTorso",
    shake_value = 0,
    autopred_system = false     
    } 
} 



Notification:Notify(
    {Title = "jamkles.lua", Description = "loaded"},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 3, Type = "default"},
    {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84), Callback = function(State) print(tostring(State)) end}
)


local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset
local AimlockState = true
local Locked
local Victim
local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey

if getgenv().Loaded == true then
    Notification:Notify(
        {Title = "jamkles.lua", Description = "loaded"},
        {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 3, Type = "default"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84), Callback = function(State) print(tostring(State)) end}
    )    return
end

getgenv().Loaded = true

local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = Color3.fromRGB(255, 255, 0)
fov.NumSides = 1000

function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)

            return fov
        end
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild(jamkles.jamky_settings.aim_part) and notKO and notGrabbed then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if (getgenv().FOV) then
                if (fov.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

Tool.Activated:Connect(function()
    if AimlockState == true then
        Locked = not Locked
        if Locked then
            Victim = getClosest()
Notification:Notify(
    {Title = "jamkles.lua", Description = "Locked on: "..tostring(Victim.Character.Humanoid.DisplayName)},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 3, Type = "default"},
    {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84), Callback = function(State) print(tostring(State)) end}
        )
        else
            if Victim ~= nil then
                Victim = nil
                Notification:Notify(
                    {Title = "jamkles.lua", Description = "unlocked"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 3, Type = "default"},
                    {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84), Callback = function(State) print(tostring(State)) end}
            )
            end
        end
    else
        Notify("Aimlock is not enabled!")
    end
end)

RS.RenderStepped:Connect(function()
    update()
    if AimlockState == true then
        if Victim ~= nil then
            local shakeOffset = Vector3.new(
                math.random(-jamkles.jamky_settings.shake_value, jamkles.jamky_settings.shake_value),
                math.random(-jamkles.jamky_settings.shake_value, jamkles.jamky_settings.shake_value),
                math.random(-jamkles.jamky_settings.shake_value, jamkles.jamky_settings.shake_value)
            ) * 0.1
local LookPosition = CFrame.new(Camera.CFrame.p, Victim.Character[jamkles.jamky_settings.aim_part].Position + (Vector3.new(Victim.Character.HumanoidRootPart.Velocity.X,Victim.Character.HumanoidRootPart.AssemblyAngularVelocity.Y*0.5,Victim.Character.HumanoidRootPart.Velocity.Z)*jamkles.jamky_settings.prediction))+shakeOffset
            Camera.CFrame = Camera.CFrame:Lerp(LookPosition, jamkles.jamky_settings.smoothness)        
    end
end
end)

for _, con in next, getconnections(workspace.CurrentCamera.Changed) do
  task.wait()
    con:Disable()
end
for _, con in next, getconnections(workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
   task.wait()
    con:Disable()
end

while task.wait() do
    if getgenv().AutoPred == true then
    pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                 split = string.split(pingvalue,'(')
                 ping = tonumber(split[1])
     if ping <200 then
            jamkles.jamky_settings.prediction = 0.1973432432343325
        elseif ping < 150 then
            jamkles.jamky_settings.prediction = 0.1922
        elseif ping < 90 then
            jamkles.jamky_settings.prediction = 0.16
        elseif ping < 80 then
            jamkles.jamky_settings.prediction = 0.169
        elseif ping < 70 then
            jamkles.jamky_settings.prediction = 0.1355
        elseif ping < 50 then
            jamkles.jamky_settings.prediction = 0.125
        elseif ping < 40 then
            jamkles.jamky_settings.prediction = 0.12
        elseif ping < 30 then
            jamkles.jamky_settings.prediction = 0.12
        end
    end
    end





       
    
