RegisterNetEvent('mx-multicharacter:GetCharacters')
RegisterNetEvent('mx-multicharacter:notification')
RegisterNetEvent('mx-multicharacter:RefreshCharacters')
RegisterNetEvent('mx-multicharacter:SetCitizenId')
RegisterNetEvent('mx-multicharacter:StartESX')
RegisterNetEvent('mx-multicharacter:OpenSkinMenu')
RegisterNetEvent('mx-multicharacter:LoadSkin')
RegisterNetEvent('mx-multicharacter:refresh')
RegisterNetEvent('esx:playerLoaded')

CreateThread(function ()
     while true do
          Wait(0)
          if NetworkIsSessionActive() or NetworkIsPlayerActive(PlayerId()) then
               MX:CharacterSelector()
               if MX.spawnmanager then
                    exports['spawnmanager']:setAutoSpawn(false)
               end
               break
          end
     end
end)

function MX:Notification(msg)
     SendNUIMessage({
          type = 'notification',
          msg = msg
     })
end

AddEventHandler('mx-multicharacter:LoadSkin', function ()
     TriggerEvent('esx:getSharedObject', function(ESX)
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
               TriggerEvent('skinchanger:loadSkin', skin)
          end)  
     end)
end)

AddEventHandler('mx-multicharacter:refresh', function ()
     SendNUIMessage({
          type = 'refresh'
     })
     MX:CharacterSelector()
end)

AddEventHandler('mx-multicharacter:OpenSkinMenu', function (sex)
     TriggerEvent('esx_skin:openSaveableMenu', function()
          if MX.cutscene then
               TriggerEvent('introCinematic:start', {
                    sex = sex
               })
          end
     end)
end)

function MX:Cam(bool)
     if bool then
         DoScreenFadeIn(1000)
         FreezeEntityPosition(PlayerPedId(), true)
         cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1126.08, -1262.42, 20.62, 0.0 ,0.0, 216.53, 65.00, false, 0)
         SetCamActive(cam, true)
         RenderScriptCams(true, false, 1, true, true)
     else
         SetCamActive(cam, false)
         DestroyCam(cam, true)
         RenderScriptCams(false, false, 1, true, true)
         FreezeEntityPosition(PlayerPedId(), false)
     end
end

function MX:TSE(...)
     TriggerServerEvent(...)
end

function MX:LoadAnim(dict)
     RequestAnimDict(dict)
     while not HasAnimDictLoaded(dict) do
          Wait(100)
     end
end

function MX:CreatePeds(data)
     for i = 1, 4 do
          if data and next(data) then
               local find = false
               for k,v in pairs(data) do
                    if tonumber(v.queue) == i then
                         find = data[k]
                         break
                    end
               end
               if find then
                    local model = find.skin.sex == 0 and self.DefaultModels[1] or self.DefaultModels[2]
                    if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
                    self.createdPeds[i] = find
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                         Wait(100)
                    end
                    self.createdPeds[i].ped = CreatePed(16, model, self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
                    PlaceObjectOnGroundProperly(self.createdPeds[i].ped)
                    SetBlockingOfNonTemporaryEvents(self.createdPeds[i].ped, true)
                    exports['skinchanger']:loadmulticharpeds(self.createdPeds[i].ped, find.skin)
                    SetEntityAlpha(self.createdPeds[i].ped, 200)
                    math.randomseed(GetGameTimer())
                    local selAnim = math.random(1, #self.Anims)
                    while self.beforeAnim and self.beforeAnim == selAnim do
                         Wait(0)
                         math.randomseed(GetGameTimer())
                         selAnim = math.random(1, #self.Anims)
                    end
                    self.beforeAnim = selAnim
                    self:LoadAnim(self.Anims[selAnim].dict)
                    TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
               else
                    local model = math.random(1, #self.DefaultModels)
                    if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
                    self.createdPeds[i] = {}
                    RequestModel(self.DefaultModels[model])
                    while not HasModelLoaded(self.DefaultModels[model]) do
                         Wait(100)
                    end
                    self.createdPeds[i].ped = CreatePed(16, self.DefaultModels[model], self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
                    SetEntityAlpha(self.createdPeds[i].ped, 100)
                    math.randomseed(GetGameTimer())
                    local selAnim = math.random(1, #self.Anims)
                    while self.beforeAnim and self.beforeAnim == selAnim do
                         Wait(0)
                         math.randomseed(GetGameTimer())
                         selAnim = math.random(1, #self.Anims)
                    end
                    self.beforeAnim = selAnim
                    self:LoadAnim(self.Anims[selAnim].dict)
                    TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
               end
          else
               local model = self.DefaultModels[math.random(1, #self.DefaultModels)]
               if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
               self.createdPeds[i] = {}
               RequestModel(model)
               while not HasModelLoaded(model) do
                    Wait(100)
               end
               self.createdPeds[i].ped = CreatePed(16, model, self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
               SetEntityAlpha(self.createdPeds[i].ped, 100)
               math.randomseed(GetGameTimer())
               local selAnim = math.random(1, #self.Anims)
               while self.beforeAnim and self.beforeAnim == selAnim do
                    Wait(0)
                    math.randomseed(GetGameTimer())
                    selAnim = math.random(1, #self.Anims)
               end
               self.beforeAnim = selAnim
               self:LoadAnim(self.Anims[selAnim].dict)
               TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
          end
     end
end

function MX:DelEntity()
     if next(self.createdPeds) then
          for i = 1, #self.createdPeds do
               SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) 
               DeleteEntity(self.createdPeds[i].ped) 
          end
     end
end

function MX:CharacterSelector()
     DisplayRadar(0)
     DoScreenFadeOut(300)
     SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
     ShutdownLoadingScreenNui()
     RequestCollisionAtCoord(self.InvisibleSpawn)
     while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
         SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
         RequestCollisionAtCoord(self.InvisibleSpawn)
         Wait(0)
     end
     SetEntityVisible(PlayerPedId(), false)
     FreezeEntityPosition(PlayerPedId(), true)
     Citizen.Wait(3500)
     self:Cam(true)
     self:TSE('mx-multicharacter:GetCharacters')
     Wait(700)
     SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
     SetEntityVisible(PlayerPedId(), false)
     DoScreenFadeIn(300)
end

AddEventHandler('mx-multicharacter:RefreshCharacters', function () MX:TSE('mx-multicharacter:GetCharacters') end)

AddEventHandler('mx-multicharacter:SetCitizenId', function (cid) MX.CitizenId = cid end)

AddEventHandler('mx-multicharacter:GetCharacters', function (data, slots)
     MX:CreatePeds(data)
     SendNUIMessage({
          type = 'SetupCharacters',
          handler = data,
          slots = slots,
          useVIP = MX.UseVIP,
          ShortMultichar = MX.Multichar
     })
     SetNuiFocus(true, true)
end)

AddEventHandler('mx-multicharacter:notification', function (msg) MX:Notification(msg) end)

RegisterNUICallback('DeleteCharacter', function (data) MX:TSE('mx-multicharacter:DeleteCharacter', data.citizenid) end)

RegisterNUICallback('CreateCharacter', function (data)
     SetEntityCoords(PlayerPedId(), MX.GeneralSpawn)
     SetEntityInvincible(PlayerPedId(), false)
     SetEntityVisible(PlayerPedId(), true)
     FreezeEntityPosition(PlayerPedId(), false)
     RequestModel(GetHashKey('mp_m_freemode_01'))
     while not HasModelLoaded(GetHashKey('mp_m_freemode_01')) do
          RequestModel(GetHashKey('mp_m_freemode_01'))
          Citizen.Wait(0)
     end
     SetPlayerModel(PlayerId(), GetHashKey('mp_m_freemode_01'))
     MX:Cam(false)
     SetNuiFocus(false, false)
     if MX.Multichar then
          if not IsScreenFadedOut() then
               DoScreenFadeOut(0)
          end
     end
     Wait(500)
     MX.NewCharacterData = {
          firstname = data.firstname,
          lastname = data.lastname,
          sex = data.sex,
          dateofbirth = data.date,
          height = data.height or 170,  --TODO: Add height to html page
          queue = data.queue
     }
     TriggerServerEvent('mx-multicharacter:CreateCharacter', MX.NewCharacterData, true)

     MX:DelEntity()
     DisplayRadar(1)
     end)

AddEventHandler('mx-multicharacter:StartESX', function (data, new)
     if not MX.essentialmode then
          if not MX.Multichar then
               TriggerServerEvent('esx:onPlayerJoined')
          else
               --- Event not safe for net es_extended v1.3.5
               --- (https://github.com/esx-framework/esx-legacy/blob/0e09d4ad2a4439fea44db607c9520f78e780fa1b/%5Besx%5D/es_extended/server/main.lua#L27)
               ---
               if new and data then
                    if data.firstname and data.lastname and data.sex and data.dateofbirth and data.height and data.queue then -- just to be sure
                         TriggerServerEvent('mx-multicharacter:onPlayerJoined', data, new)
                    else
                         print('DEBUG-SV: missing some parameters from data table')
                    end
               else
                    TriggerServerEvent('mx-multicharacter:onPlayerJoined', data, new)
               end
          end
     else
          TriggerServerEvent('es:firstJoinProper')
          TriggerEvent('es:allowedToSpawn')
     end
end)

AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)

     if MX.Multichar then
          DoScreenFadeIn(500)
          SetEntityVisible(PlayerPedId(), false)

          exports.spawnmanager:spawnPlayer({
               x = xPlayer.coords.x,
               y = xPlayer.coords.y,
               z = xPlayer.coords.z + 0.25,
               heading = xPlayer.coords.heading,
               model = `mp_m_freemode_01`,
               skipFade = false
               }, function()
                    TriggerServerEvent('esx:onPlayerSpawn')
                    TriggerEvent('esx:onPlayerSpawn')
                    TriggerEvent('playerSpawned') -- compatibility with old scripts
                    TriggerEvent('esx:restoreLoadout')
                    if isNew then
                         if skin.sex == 0 then
                         TriggerEvent('skinchanger:loadDefaultModel', true)
                    else
                    TriggerEvent('skinchanger:loadDefaultModel', false)
                         end
                         elseif skin then TriggerEvent('skinchanger:loadSkin', skin) end
                    TriggerEvent('esx:loadingScreenOff')
                    ShutdownLoadingScreen()
                    ShutdownLoadingScreenNui()
                    FreezeEntityPosition(PlayerPedId(), false)
               end)
     end
end)

RegisterNUICallback('PlayCharacter', function (data)
     MX:Cam(false)
     SetNuiFocus(false, false)
     if MX.Multichar then
          if not IsScreenFadedOut() then
               DoScreenFadeOut(0)
          end
     end
     FreezeEntityPosition(PlayerPedId(), true)
     MX:DelEntity()
     DisplayRadar(1)
     TriggerServerEvent('mx-multicharacter:CheckCharacterIsOwner', data.data)
end)

RegisterNUICallback('SelectCharacter', function (data)
     if next(MX.createdPeds) then
          for _,v in pairs(MX.createdPeds) do
               if v.queue == data.queue then
                    if v.ped ~= MX.currentCharacter then
                         SetEntityAlpha(v.ped, 255)
                         if MX.currentCharacter then
                              SetEntityAlpha(MX.currentCharacter, 200)
                         end
                         MX.currentCharacter = v.ped
                    end
                    break
               end
          end
     end
end)

exports('GetMulti', function ()
     return MX.NewCharacterData
end)

exports('SetMulti', function ()
     MX.NewCharacterData = false
end)
