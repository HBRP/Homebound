--[[

MIT License

Copyright (c) 2019 Emma Davenport

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]--

function PlaySound(soundfile, volume)

  local audio = {type = "play_sound", soundfile = soundfile, volume = volume}
  SendNUIMessage({audio = audio})

end

function StopSound(soundfile)

  local audio = {type = "stop_sound", soundfile = soundfile}
  SendNUIMessage({audio = audio})

end

local function CalculateAudioVolumeForBystanders(audio_file, audio_vol_base, audio_x, audio_y, audio_z)

  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
  local volume  = audio_vol_base * math.exp(-1 * .25 * math.sqrt((x - audio_x) ^ 2 + (y - audio_y) ^ 2 + (z - audio_z) ^ 2))

  if volume < .1 then return end
  PlaySound(audio_file, volume)

end

RegisterNetEvent("PlayAudioForBystanders")
AddEventHandler("PlayAudioForBystanders", CalculateAudioVolumeForBystanders)

local BASE_VOLUME = .3
local function PlaySoundForEveryoneInVicinity(audio_file)

  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
  TriggerServerEvent("StartClientAudioForBystanders", audio_file, BASE_VOLUME, x, y, z)

end

RegisterNetEvent("PlaySoundForEveryoneInVicinity")
AddEventHandler("PlaySoundForEveryoneInVicinity", PlaySoundForEveryoneInVicinity)
