-- // original code by isso i just added a flight toggle lol

local user_input_service: UserInputService = game:GetService("UserInputService")
local run_service: RunService = game:GetService("RunService")

local plr: Player = game:GetService("Players").LocalPlayer
local cam: Camera = workspace.CurrentCamera

local char: Model = plr.Character or workspace[plr.Name]

local flyspeed: number = 2
local toggleKey = Enum.KeyCode.F

local part: BasePart

local keys_using = {
    ["W"] = false,
    ["A"] = false,
    ["S"] = false,
    ["D"] = false,
    ["Q"] = false,
    ["E"] = false
}

local flight_enabled = true

if getgenv().vectorfly then 
    getgenv().vectorfly.part:Destroy()

    for i=1,#getgenv().vectorfly do
        getgenv().vectorfly[i]:Disconnect()
    end
end

local function input_began(key, a)
    if a then return end

    key = string.split(tostring(key.KeyCode), ".")
    key = key[#key]

    if keys_using[key] == false then
        keys_using[key] = true
    end
end

local function input_ended(key, a)
    if a then return end

    key = string.split(tostring(key.KeyCode), ".")
    key = key[#key]

    if keys_using[key] == true then
        keys_using[key] = false
    end
end

local function main(delta_time)
    if not flight_enabled then return end

    local speed: number = flyspeed * (delta_time / (1 / 60))

    local x_vec: Vector3 = cam.CFrame.XVector * speed
    local look_vec: Vector3 = cam.CFrame.LookVector * speed
    local y_vec: Vector3 = cam.CFrame.YVector / 2

    if not char then
        getgenv().vectorfly.part:Destroy()

        for i=1,#getgenv().vectorfly do
            getgenv().vectorfly[i]:Disconnect()
        end
    end

    if keys_using["W"] and not keys_using["S"] then
        part.Position += look_vec
    end
    if keys_using["A"] and not keys_using["D"] then
        part.Position -= x_vec
    end
    if keys_using["S"] and not keys_using["W"] then
        part.Position -= look_vec
    end
    if keys_using["D"] and not keys_using["A"] then
        part.Position += x_vec
    end
    if keys_using["Q"] and not keys_using["E"] then
        part.Position -= y_vec
    end
    if keys_using["E"] and not keys_using["Q"] then
        part.Position += y_vec
    end

    char:MoveTo(part.Position)
end

part = Instance.new("Part")
part.Anchored = true
part.Position = char.PrimaryPart.Position

getgenv().vectorfly = {
    part = part
}

getgenv().vectorfly[#getgenv().vectorfly + 1] = run_service["Heartbeat"]:Connect(main)
getgenv().vectorfly[#getgenv().vectorfly + 1] = user_input_service.InputBegan:Connect(input_began)
getgenv().vectorfly[#getgenv().vectorfly + 1] = user_input_service.InputEnded:Connect(input_ended)

local function toggleFlight()
    flight_enabled = not flight_enabled
    if flight_enabled then
        print("1")
    else
        print("0")
    end
end

user_input_service.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        toggleFlight()
    end
end)