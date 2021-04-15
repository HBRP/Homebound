Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0) -- ZOOM_LEVEL_GOLF_COURSE
    SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0) -- ZOOM_LEVEL_INTERIOR
    SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0) -- ZOOM_LEVEL_GALLERY
    SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0) -- ZOOM_LEVEL_GALLERY_MAXIMIZE
end)

-- Map stuff below
local x = -0.025
local y = -0.015
local w = 0.16
local h = 0.25

Citizen.CreateThread(function()

    local minimap = RequestScaleformMovie("minimap")

    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do 
       Citizen.Wait(100) 
    end
    
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap",
                      "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', x, y, w, h)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.035, -0.03, 0.18, 0.22)

    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Citizen.Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
        EndScaleformMovieMethod()
    end

end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)