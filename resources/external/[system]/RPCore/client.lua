
if Config.nogrip then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(200)
            local ped = PlayerPedId()
            if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
                local chance_result = math.random()
                if chance_result < Config.ragdoll_chance then 
                    Citizen.Wait(600)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.00)
                    SetPedToRagdoll(ped, 5000, 1, 2)
                else
                    Citizen.Wait(2000)
                end
            end
        end
    end)
end

if Config.pvp then
    AddEventHandler("playerSpawned", function()
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)
    end)
end

if Config.noreticle then
    local scopedWeapons = 
    {
        100416529,  -- WEAPON_SNIPERRIFLE
        205991906,  -- WEAPON_HEAVYSNIPER
        3342088282  -- WEAPON_MARKSMANRIFLE
    }
    
    function HashInTable( hash )
        for k, v in pairs( scopedWeapons ) do 
            if ( hash == v ) then 
                return true 
            end 
        end 
    
        return false 
    end 
    
    function ManageReticle()
        local ped = PlayerPedId()
    
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
            local _, hash = GetCurrentPedWeapon( ped, true )
    
            if ( GetFollowPedCamViewMode() ~= 4 and IsPlayerFreeAiming() and not HashInTable( hash ) ) then 
                HideHudComponentThisFrame( 14 )
            end 
        end 
    end 
    
    Citizen.CreateThread( function()
        while true do 
            HideHudComponentThisFrame( 14 )     
            Citizen.Wait(0)
        end 
    end)
end

if Config.neverwanted then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            for i = 1, 12 do
                EnableDispatchService(i, false)
            end
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
        end
    end)
end

if Config.crouch then
    local crouched = false
    
    Citizen.CreateThread( function()
        while true do 
            Citizen.Wait(5)
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(ped) ) then 
                DisableControlAction( 0, 36, true )
                if ( not IsPauseMenuActive() ) then 
                    if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                        RequestAnimSet( "move_ped_crouched" )
                        while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                            Citizen.Wait( 100 )
                        end 
                        if ( crouched == true ) then 
                            ResetPedMovementClipset( ped, 0 )
                            crouched = false 
                        elseif ( crouched == false ) then
                            SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                            crouched = true 
                        end 
                    end
                end 
            end 
        end
    end)
end

if Config.handsup then
    Citizen.CreateThread(function()
        local dict = "missminuteman_1ig_2"
        
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        local handsup = false
        while true do
            Citizen.Wait(5)
            if IsControlJustPressed(1, 323) then --Start holding X
                if not handsup then
                    TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                    handsup = true
                else
                    handsup = false
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
    end)
end

if Config.fingerpoint then

    local mp_pointing = false
    local keyPressed = false
    
    local function startPointing()
        local ped = PlayerPedId()
        RequestAnimDict("anim@mp_point")
        while not HasAnimDictLoaded("anim@mp_point") do
            Wait(0)
        end
        SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
        SetPedConfigFlag(ped, 36, 1)
        Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
        RemoveAnimDict("anim@mp_point")
    end
    
    local function stopPointing()
        local ped = PlayerPedId()
        Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
        if not IsPedInjured(ped) then
            ClearPedSecondaryTask(ped)
        end
        if not IsPedInAnyVehicle(ped, 1) then
            SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
        end
        SetPedConfigFlag(ped, 36, 0)
        ClearPedSecondaryTask(PlayerPedId())
    end
    
    local once = true
    local oldval = false
    local oldvalped = false
    
    Citizen.CreateThread(function()
        while true do
            Wait(5)
    
            if once then
                once = false
            end
    
            if not keyPressed then
                if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                    Wait(200)
                    if not IsControlPressed(0, 29) then
                        keyPressed = true
                        startPointing()
                        mp_pointing = true
                    else
                        keyPressed = true
                        while IsControlPressed(0, 29) do
                            Wait(50)
                        end
                    end
                elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                    keyPressed = true
                    mp_pointing = false
                    stopPointing()
                end
            end
    
            if keyPressed then
                if not IsControlPressed(0, 29) then
                    keyPressed = false
                end
            end
            if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
                stopPointing()
            end
            if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
                if not IsPedOnFoot(PlayerPedId()) then
                    stopPointing()
                else
                    local ped = PlayerPedId()
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
                    camPitch = (camPitch + 70.0) / 112.0
    
                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading = Cos(camHeading)
                    local sinCamHeading = Sin(camHeading)
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end
                    camHeading = (camHeading + 180.0) / 360.0
    
                    local blocked = 0
                    local nn = 0
    
                    local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                    local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                    nn,blocked,coords,coords = GetRaycastResult(ray)
    
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
    
                end
            end
        end
    end)
end

if Config.deleteveh then
    exports["em_commands"]:register_command( "dv", function()
        TriggerEvent( "RPCore:deleteVehicle" )
    end, "Deletes the vehicle you're sat in, or standing next to." )

    local distanceToCheck = 5.0
    local numRetries = 5

    RegisterNetEvent( "RPCore:deleteVehicle" )
    AddEventHandler( "RPCore:deleteVehicle", function()
        local ped = PlayerPedId()

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            local pos = GetEntityCoords( ped )

            if ( IsPedSittingInAnyVehicle( ped ) ) then 
                local vehicle = GetVehiclePedIsIn( ped, false )

                if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                    DeleteGivenVehicle( vehicle, numRetries )
                else 
                    Notify( "You must be in the driver's seat!" )
                end 
            else
                local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
                local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

                if ( DoesEntityExist( vehicle ) ) then 
                    DeleteGivenVehicle( vehicle, numRetries )
                else 
                    Notify( "~y~You must be in or near a vehicle to delete it." )
                end 
            end 
        end 
    end )

    function DeleteGivenVehicle( veh, timeoutMax )
        local timeout = 0 

        SetEntityAsMissionEntity( veh, true, true )
        DeleteVehicle( veh )

        if ( DoesEntityExist( veh ) ) then
            Notify( "~r~Failed to delete vehicle, trying again..." )
            while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
                DeleteVehicle( veh )

                if ( not DoesEntityExist( veh ) ) then 
                    Notify( "~g~Vehicle deleted." )
                end 

                timeout = timeout + 1 
                Citizen.Wait( 500 )

                if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                    Notify( "~r~Failed to delete vehicle after " .. timeoutMax .. " retries." )
                end 
            end 
        else 
            Notify( "~g~Vehicle deleted." )
        end 
    end 

    function GetVehicleInDirection( entFrom, coordFrom, coordTo )
        local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
        local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
        
        if ( IsEntityAVehicle( vehicle ) ) then 
            return vehicle
        end 
    end

    function Notify( text )
        SetNotificationTextEntry( "STRING" )
        AddTextComponentString( text )
        DrawNotification( false, false )
    end
end