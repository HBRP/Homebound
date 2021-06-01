--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}

local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false
local TokoVoipID = nil

local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0


--====================================================================================
--  Check si le joueurs poséde un téléphone
--  Callback true or false
--====================================================================================
function hasPhone (cb)
  cb(exports["em_items"]:has_item_by_name("phone"))
end
--====================================================================================
--  Que faire si le joueurs veut ouvrir sont téléphone n'est qu'il en a pas ?
--====================================================================================
function ShowNoPhoneWarning ()
end

--[[
  Ouverture du téphone lié a un item
  Un solution ESC basé sur la solution donnée par HalCroves
  https://forum.fivem.net/t/tutorial-for-gcphone-with-call-and-job-message-other/177904
]]--


AddEventHandler('esx:onPlayerDeath', function()
  if menuIsOpen then
    menuIsOpen = false
    TriggerEvent('gcPhone:setMenuStatus', false)
    SendNUIMessage({show = false})
    PhonePlayOut()
    SetBigmapActive(0,0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  TriggerServerEvent('gcPhone:allUpdate')
end)

--[[

        TriggerClientEvent('gcPhone:myPhoneNumber', sourcePlayer, myPhoneNumber)
        TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(identifier))
        TriggerClientEvent('gcPhone:allMessage', sourcePlayer, getMessages(identifier))
        TriggerClientEvent('gcPhone:getBourse', sourcePlayer, getBourse())
        sendHistoriqueCall(sourcePlayer, num)

]]

local function set_phone_number(phone_number)

  myPhoneNumber = phone_number
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
  SendNUIMessage({event = 'updatePlayerID', id = GetPlayerServerId(PlayerId())})

end

local function set_contact_information(phone_contacts)

  for i = 1, #phone_contacts do
    phone_contacts[i].id      = phone_contacts[i].phone_contact_id
    phone_contacts[i].display = phone_contacts[i].phone_contact_name
    phone_contacts[i].number  = phone_contacts[i].phone_number
    phone_contacts[i].identifier = ""
  end

  contacts = phone_contacts
  SendNUIMessage({event = 'updateContacts', contacts = contacts})

end

local function set_all_messages(phone_messages)

  for i = 1, #phone_messages do
    phone_messages[i].transmitter = phone_messages[i].receiving_phone_number
    phone_messages[i].receiver    = phone_messages[i].sender_phone_number

    phone_messages[i].isRead      = phone_messages[i].is_read and 1 or 0
    phone_messages[i].owner       = phone_messages[i].is_sender and 1 or 0
    phone_messages[i].message     = phone_messages[i].phone_message
    phone_messages[i].time        = phone_messages[i].time_sent
  end

  messages = phone_messages
  SendNUIMessage({event = 'updateMessages', messages = phone_messages})

end

local function set_phone_call_history(phone_calls)

  SendNUIMessage({event = 'historiqueCall', historique = phone_calls})

end

local function set_phone_data()

  exports["em_dal"]:phone_get_phone_data_async(function(phone_data)

    set_phone_number(phone_data.phone_number)
    set_contact_information(phone_data.phone_contacts)
    set_all_messages(phone_data.phone_messages)
    --set_phone_call_history(phone_data.phone_calls)
    SendNUIMessage({event = 'updateBourse', bourse = {}})

  end)

end

exports["em_commands"]:register_command("test_phone", function(source, args, raw_commands)

  set_phone_data()
  Citizen.Wait(100)

  TogglePhone()
  SetNuiFocus(true, true)

end, "test_phone")

AddEventHandler("em_dal:character_loaded", set_phone_data)

--====================================================================================
--
--====================================================================================

local function set_nui_phone()
  if menuIsOpen == true then
    print(useMouse)
    print(ignoreFocus)
    if useMouse == true and hasFocus == ignoreFocus then
      local nuiFocus = not hasFocus
      SetNuiFocus(nuiFocus, nuiFocus)
      hasFocus = nuiFocus
    elseif useMouse == false and hasFocus == true then
      SetNuiFocus(false, false)
      hasFocus = false
    end
  else
    if hasFocus == true then
      SetNuiFocus(false, false)
      hasFocus = false
    end
  end
end

local function toggle_phone()

  if (not menuIsOpen and isDead) or takePhoto then
    return
  end

  hasPhone(function (hasPhone)
    if hasPhone == true then
      TogglePhone()
      set_nui_phone()
    else
      ShowNoPhoneWarning()
    end
  end)

end

local function toggle_key_up(event)

  if takePhoto then
    return
  end

  SendNUIMessage({keyUp = event})

end

RegisterCommand('phone_m', function() toggle_phone() end, false)
RegisterCommand('phone_up', function() toggle_key_up('ArrowUp') end, false)
RegisterCommand('phone_down', function() toggle_key_up('ArrowDown') end, false)
RegisterCommand('phone_left', function() toggle_key_up('ArrowLeft') end, false)
RegisterCommand('phone_right', function() toggle_key_up('ArrowRight') end, false)
RegisterCommand('phone_enter', function() toggle_key_up('Enter') end, false)
RegisterCommand('phone_backspace', function() toggle_key_up('Backspace') end, false)

RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'M')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'UP')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'DOWN')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'LEFT')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'RIGHT')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'RETURN')
--RegisterKeyMapping('phone_m', 'phone_m', 'keyboard', 'BACK')

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
  local number = ''
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    number =  GetOnscreenKeyboardResult()
  end
  if number ~= '' then
    TriggerEvent('gcphone:autoCall', number, {
      useNumber = fixeNumber
    })
    PhonePlayCall(true)
  end
end

function TakeAppel (infoCall)
  TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

RegisterNetEvent("gcPhone:notifyFixePhoneChange")
AddEventHandler("gcPhone:notifyFixePhoneChange", function(_PhoneInCall)
  PhoneInCall = _PhoneInCall
end)

--[[
  Affiche les imformations quant le joueurs est proche d'un fixe
--]]
function showFixePhoneHelper (coords)
  for number, data in pairs(Config.FixePhone) do
    local dist = GetDistanceBetweenCoords(
      data.coords.x, data.coords.y, data.coords.z,
      coords.x, coords.y, coords.z, 1)
    if dist <= 2.5 then
      SetTextComponentFormat("STRING")
      AddTextComponentString(_U('use_fixed', data.name, number))
      DisplayHelpTextFromStringLabel(0, 0, 0, -1)
      if IsControlJustPressed(1, Config.KeyTakeCall) then
        startFixeCall(number)
      end
      break
    end
  end
end

RegisterNetEvent('gcPhone:register_FixePhone')
AddEventHandler('gcPhone:register_FixePhone', function(phone_number, data)
  Config.FixePhone[phone_number] = data
end)

--[[
local registeredPhones = {}
Citizen.CreateThread(function()
  if not Config.AutoFindFixePhones then return end
  while not ESX do Citizen.Wait(0) end
  while true do
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    for _, key in pairs({'p_phonebox_01b_s', 'p_phonebox_02_s', 'prop_phonebox_01a', 'prop_phonebox_01b', 'prop_phonebox_01c', 'prop_phonebox_02', 'prop_phonebox_03', 'prop_phonebox_04'}) do
      local closestPhone = GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, key, false)
      if closestPhone ~= 0 and not registeredPhones[closestPhone] then
        local phoneCoords = GetEntityCoords(closestPhone)
        number = ('0%.2s-%.2s%.2s'):format(math.abs(phoneCoords.x*100), math.abs(phoneCoords.y * 100), math.abs(phoneCoords.z *100))
        if not Config.FixePhone[number] then
          TriggerServerEvent('gcPhone:register_FixePhone', number, phoneCoords)
        end
        registeredPhones[closestPhone] = true
      end
    end
    Citizen.Wait(1000)
  end
end)
]]

Citizen.CreateThread(function ()
  local mod = 0
  while true do
    local playerPed   = PlayerPedId()
    local coords      = GetEntityCoords(playerPed)
    local inRangeToActivePhone = false
    local inRangedist = 0
    for i, _ in pairs(PhoneInCall) do
        local dist = GetDistanceBetweenCoords(
          PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
          coords.x, coords.y, coords.z, 1)
        if (dist <= soundDistanceMax) then
          DrawMarker(1, PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
              0,0,0, 0,0,0, 0.1,0.1,0.1, 0,255,0,255, 0,0,0,0,0,0,0)
          inRangeToActivePhone = true
          inRangedist = dist
          if (dist <= 1.5) then
            SetTextComponentFormat("STRING")
            AddTextComponentString(_U('key_answer'))
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(1, Config.KeyTakeCall) then
              PhonePlayCall(true)
              TakeAppel(PhoneInCall[i])
              PhoneInCall = {}
              StopSoundJS('ring2.ogg')
            end
          end
          break
        end
    end
    if inRangeToActivePhone == false then
      showFixePhoneHelper(coords)
    end
    if inRangeToActivePhone == true and currentPlaySound == false then
      PlaySoundJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
      currentPlaySound = true
    elseif inRangeToActivePhone == true then
      mod = mod + 1
      if (mod == 15) then
        mod = 0
        SetSoundVolumeJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
      end
    elseif inRangeToActivePhone == false and currentPlaySound == true then
      currentPlaySound = false
      StopSoundJS('ring2.ogg')
    end
    Citizen.Wait(0)
  end
end)

function PlaySoundJS (sound, volume)
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS (sound, volume)
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  SendNUIMessage({ event = 'stopSound', sound = sound})
end

RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TogglePhone()
  end
end)

-- TEST NOTIFICATIONS
RegisterNetEvent("gcPhone:testNotifications")
AddEventHandler("gcPhone:testNotifications", function()
  SendNUIMessage({event = 'updateNotification', active = true })
  SendNUIMessage({
    event = 'updateNotificationInfo', 
    info = {
      app = 'twitter',
      icon = 'twitter',
      prefix = 'fab',
      color = 'dodgerblue',
      message = 'Hola esta es una prueba de notificaciones ekisde jajaja'
    },
  })
end)


RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)
  -- SendNUIMessage({event = 'updateMessages', messages = messages})
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  hasPhone(function (hasPhone)
    if hasPhone == true then
      if message.owner == 0 then
        local app = _U('new_message')
        if Config.ShowNumberNotification == true then
          app = _U('new_message_from', message.transmitter)
          for _,contact in pairs(contacts) do
            if contact.number == message.transmitter then
              app = _U('new_message_transmitter', contact.display)
              break
            end
          end
        end

        SendNUIMessage({event = 'updateNotification', active = true})
        SendNUIMessage({
          event = 'updateNotificationInfo', 
          info = {
            app = app,
            icon = 'sms',
            prefix = 'fas',
            color = '#87fc6a',
            message = message
          }
        })
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
      end
    end
  end)
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num)

  print(display)
  print(num)
  exports["em_dal"]:phone_new_contact_async(function()

    exports["em_dal"]:phone_get_contacts_async(function(phone_contacts)
      set_contact_information(phone_contacts)
    end)

  end, num, display)

end

function deleteContact(id)

  exports["em_dal"]:phone_delete_contact_async(function()

    exports["em_dal"]:phone_get_contacts_async(function(phone_contacts)
      set_contact_information(phone_contacts)
    end)

  end, id)

end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)

  exports["em_dal"]:phone_mark_messages_read_async(function() end, num)

  for k, v in ipairs(messages) do
    if v.transmitter == num then
      v.isRead = 1
    end
  end

end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
  if initiator == true then
    SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
    PhonePlayCall()
    if menuIsOpen == false then
      TogglePhone()
    end
  else
    hasPhone(function (hasPhone)
      if hasPhone == true then
        SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
      end
    end)
  end
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
  if inCall == false and USE_RTC == false then
    inCall = true
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(infoCall.id+1)
    elseif Config.UseSaltyChat then
      exports['saltychat']:EstablishCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src) --Assign Channel
      exports['saltychat']:EstablishCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src) --Assign Channel
    else
      NetworkSetVoiceChannel(infoCall.id + 1)
      NetworkSetTalkerProximity(0.0)
    end
  end
  if menuIsOpen == false then
    TogglePhone()
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
  if inCall == true then
    inCall = false
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(0)
    elseif Config.UseSaltyChat then
      exports['saltychat']:EndCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src) --Assign Channel
      exports['saltychat']:EndCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src) --Assign Channel
    else
      Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(2.5)
    end
  end
  PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


function startCall (phone_number, rtcOffer, extraData)
  if rtcOffer == nil then
    rtcOffer = ''
  end
  TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function requestHistoriqueCall()
  TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end


--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb(true)
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb(true)
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb(true)
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb(true)
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    if Config.UseTokoVoIP then
      exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
      TokoVoipID = nil
    else
      NetworkSetTalkerProximity(2.5)
    end
  end
  cb(true)
end)


RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
  cb(true)
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
  TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)

--====================================================================================
--  Gestion des evenements NUI
--====================================================================================
RegisterNUICallback('log', function(data, cb)
  print(data)
  cb(true)
end)
RegisterNUICallback('focus', function(data, cb)
  cb(true)
end)
RegisterNUICallback('blur', function(data, cb)
  cb(true)
end)
RegisterNUICallback('reponseText', function(data, cb)

  SetNuiFocus(false, false)

  local form = {

    {
      input_type = "text_input",
      input_name = "Link",
      placeholder = "Image Link",
      options = {},
      numbers_valid = true,
      characters_valid =  true,
      optional = false
    }

  }
  exports["em_form"]:display_form(function(inputs)

    local text = exports["em_form"]:get_form_value(inputs, "Link")
    SetNuiFocus(true, true)
    cb(json.encode({text = text}))

  end, "Change your Profile Pic", form)

end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)

  if data.message == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end

  print(json.encode(data))
  exports["em_dal"]:phone_new_message_async(function(response)

    if not response.result.success then
      exports['t-notify']:Alert({style = "error", message = response.result.message})
    else
      exports["em_dal"]:phone_get_messages_async(function(phone_messages)
        set_all_messages(phone_messages)
      end)
      exports["em_dal"]:trigger_targeted_phone_event("gcphone:receiveMessage", phone_number, data.message)
      TriggerEvent("gcphone:receiveMessage", data.message)
    end

  end, data.phoneNumber, data.message)

  cb(true)

end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb(true)
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  print(json.encode(data))
  deleteMessageContact(data.number)
  cb(true)
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)

  exports["em_dal"]:phone_delete_all_messages_async(function() end)

  --deleteAllMessage()
  cb(true)
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb(true)
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb)

  addContact(data.display, data.phoneNumber)
  cb(true)

end)
RegisterNUICallback('updateContact', function(data, cb)

  exports["em_dal"]:phone_update_contact_async(function()

    exports["em_dal"]:phone_get_contacts_async(function(phone_contacts)
      set_contact_information(phone_contacts)
    end)

  end, data.id, data.phoneNumber, data.display)
  cb(true)
end)

RegisterNUICallback('deleteContact', function(data, cb)

  print(json.encode(data))
  deleteContact(data.id)
  cb(true)

end)
RegisterNUICallback('getContacts', function(data, cb)
    cb(json.encode(contacts))
    cb(true)
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb(true)
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
  if string.match(eventName, 'gcphone') then
    if data.data ~= nil then
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  else
    print('Event not allowed')
  end
  cb(true)
end)
RegisterNUICallback('useMouse', function(um, cb)
    useMouse = um
    cb(true)
end)
RegisterNUICallback('deleteALL', function(data, cb)
    TriggerServerEvent('gcPhone:deleteALL')
    cb(true)
end)



function TogglePhone()
  menuIsOpen = not menuIsOpen
  SendNUIMessage({show = menuIsOpen})
  if menuIsOpen == true then
    PhonePlayIn()
    TriggerEvent('gcPhone:setMenuStatus', true)
    SetBigmapActive(1,0)
  else
    PhonePlayOut()
    TriggerEvent('gcPhone:setMenuStatus', false)
    SetBigmapActive(0,0)
  end
end
RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  TriggerEvent('gcPhone:setMenuStatus', false)
  SendNUIMessage({show = false})
  cb(true)
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  TriggerEvent('gcPhone:setMenuStatus', false)
  SendNUIMessage({show = false})
  PhonePlayOut()
  SetBigmapActive(0,0)
  cb(true)
end)


----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb(true)
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb(true)
end)


----------------------------------
---------- Force Update ----------
----------------------------------
local phoneReady = false
RegisterNetEvent('gcphone:phoneReady')
AddEventHandler('gcphone:phoneReady', function()
  phoneReady = true
end)

AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "gcphone" then
    while not phoneReady do
      TriggerServerEvent('gcPhone:allUpdate')
      -- Try every 5 Seconds
      Citizen.Wait(50000)
    end
  end
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------

RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb(true)
end)

RegisterNUICallback('takePhoto', function(data, cb)
  CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  Citizen.Wait(0)
  if hasFocus == true then
    SetNuiFocus(false, false)
    hasFocus = false
  end
  while takePhoto do
    Citizen.Wait(0)

    if IsControlJustPressed(1, 27) then -- Toogle Mode
      frontCam = not frontCam
      CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then -- CANCEL
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      break
    elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
      exports['screenshot-basic']:requestScreenshotUpload(data.url, data.field, function(data)
        local resp = json.decode(data)
        DestroyMobilePhone()
        CellCamActivate(false, false)
        cb(json.encode({ url = resp.url }))
      end)
      takePhoto = false
    end
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
  end
  Citizen.Wait(1000)
  PhonePlayAnim('text', false, true)
end)
