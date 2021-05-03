
BusStop = {}
BusStop.Models = { 'prop_busstop_05', 'prop_busstop_02', 'prop_busstop_04', 'prop_bus_stop_sign' }
BusStop.Stops = {}

-- Finds the nearest bus stop model with 25m.
--  Coords is optional
BusStop.FindNearestModel = function(coords) 
    return FindClosestObject(BusStop.Models, 25, coords)
end

-- Requests a new stop to be created
BusStop.RequestCreateStop = function(identifingCoordinate, stopCoordinate, heading, name, callback)
    -- Send the message to the server. Once we get a call back we will log it
    print('Requesting new bus stop', identifingCoordinate, stopCoordinate, heading, name)
    ESX.TriggerServerCallback(E.CreateBusStop, function(hash)
        BusStop.RequestAllStops()
        if callback then callback(hash) end
    end, identifingCoordinate, stopCoordinate, heading, name)
end


-- Gets a list of bus stops
BusStop.RequestAllStops = function(callback) 
    ESX.TriggerServerCallback(E.GetBusStops, function(stops)
        BusStop.Stops = stops
        if callback then  callback(stops) end
    end)
end

-- Registers the events
BusStop.RegisterEvents = function(ESX)
    BusStop.RequestAllStops(function(stops)

        for _, stop in pairs(stops) do
            stop.blip = AddBlipForCoord(stop.x, stop.y, stop.z)
            SetBlipSprite(stop.blip, 513)
            SetBlipDisplay(stop.blip, 4)
            SetBlipScale(stop.blip, 0.9)
            -- SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(stop.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Bus Stop")
            EndTextCommandSetBlipName(stop.blip)
        end
    end)
end

-- Renders the stops
BusStop.RenderAll = function()
    if Config.alwaysRenderStops then
        for k, stop in pairs(BusStop.Stops) do
            BusStop.Render(stop)
        end
    end
end

-- Render a specific stop. Color is optional
BusStop.Render = function(stop, color)
    if color == nil then color = { r = 255, g = 255, b = 0 } end
    
    BusStop.DrawZone(stop, stop.heading, color)
    local model = BusStop.FindNearestModel(stop)
    local textCoord = stop
    if model then textCoord = GetEntityCoords(model) end
    
    textCoord = vector3(textCoord.x+.0, textCoord.y+.0, textCoord.z+4.25)
    DrawText3D(textCoord, tostring(stop.id) .. ' | ' .. stop.name, 3)
end

-- Drwas a rectangular zone marker, snapped ot the ground
BusStop.DrawZone = function(coordinate, heading, color) 
    -- Draw the rectangle
    local depth = 0.5
    local height = 1.0
    local size = { x = 3.5, y = 13.0, z = height }

    --Draw the position
    local rotation = { x = .0, y = .0, z = heading + .0 }
    local position = { x=coordinate.x, y=coordinate.y, z=coordinate.z }
    
    local hasGround, groundZ, normal = GetGroundZAndNormalFor_3dCoord(position.x, position.y, position.z, 0)
    if hasGround then 
        position.z = groundZ - depth
        
        if Config.debug and DEBUG_FindStops then
            local qHeading = quat(heading, vector3(0, 0, 1))
            DrawQuaternion(coordinate, qHeading, {r=255, g=0, b=0})
            
            local qRoad = quat(vector3(0, 1, 0), normal)
            DrawQuaternion(coordinate, qRoad, {r=0, g=255, b=0})

            -- We need to rotate qRoad 90deg in the direction of qHeading
            local qNew = qRoad * quat(90, vector3(1, 0, 0))
            DrawQuaternion(coordinate, qNew, {r=0, g=0, b=255})
        end
    end

    DrawMarker(43, 
        position.x + .0, position.y+ .0, position.z + .0, -- Position
        0.0, 0.0, 0.0,                               -- Direction
        rotation.x, rotation.y, rotation.z,                      -- Rotation
        size.x+ .0, size.y+ .0, size.z+ .0,          -- Scale
        color.r, color.g, color.b, 0.01,             -- Color
        0, 0, 0, 0, 0, 0, 0
    )
end

