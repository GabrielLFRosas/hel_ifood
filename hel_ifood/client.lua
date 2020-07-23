local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
heL = Tunnel.getInterface("hel_ifood")

-----------------------------------------------------------------------------------------------------------------------------------------
--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local quantidade = 0
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local CoordenadaX = 151.9
local CoordenadaY = -1467.61
local CoordenadaZ = 28.6
-- FAZER LANCHE -- 
local CoordenadaX1 = 143.92
local CoordenadaY1 = -1462.73
local CoordenadaZ1 = 29.36
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RESIDENCIAS ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 155.85, ['y'] = -43.10, ['z'] = 67.71 },
	[2] = { ['x'] = 313.35, ['y'] = -245.31, ['z'] = 53.89 },
	[3] = { ['x'] = -52.17, ['y'] = -103.74, ['z'] = 57.63 },
	[4] = { ['x'] = -269.36, ['y'] = 27.27, ['z'] = 54.65 },
	[5] = { ['x'] = -598.12, ['y'] = 5.68, ['z'] = 43.07 },
	[6] = { ['x'] = -795.49, ['y'] = 40.80, ['z'] = 48.25 },
	[7] = { ['x'] = -843.95, ['y'] = 87.22, ['z'] = 51.96 },
	[8] = { ['x'] = -831.32, ['y'] = -227.58, ['z'] = 37.09 },
	[9] = { ['x'] = -682.37, ['y'] = -374.73, ['z'] = 34.15 },
	[10] = { ['x'] = -295.17, ['y'] = -617.44, ['z'] = 33.31 },
	[11] = { ['x'] = -553.23, ['y'] = -649.75, ['z'] = 33.08 },
	[12] = { ['x'] = -934.24, ['y'] = -456.49, ['z'] = 37.15 },
	[13] = { ['x'] = -1078.39, ['y'] = -267.97, ['z'] = 37.61 },
	[14] = { ['x'] = -1437.76, ['y'] = -412.62, ['z'] = 35.79 },
	[15] = { ['x'] = -1669.03, ['y'] = -541.66, ['z'] = 34.98 },
	[16] = { ['x'] = -1392.47, ['y'] = -580.91, ['z'] = 30.05 },
	[17] = { ['x'] = -1042.79, ['y'] = -387.18, ['z'] = 37.57 },
	[18] = { ['x'] = -255.13, ['y'] = -756.19, ['z'] = 32.63 },
	[19] = { ['x'] = 13.42, ['y'] = -972.96, ['z'] = 29.30 },
	[20] = { ['x'] = 257.70, ['y'] = -1062.13, ['z'] = 29.10 },
	[21] = { ['x'] = 792.41, ['y'] = -944.58, ['z'] = 25.55 },
	[22] = { ['x'] = 120.44, ['y'] = -926.42, ['z'] = 29.73 },
	[23] = { ['x'] = 2.53, ['y'] = -1127.96, ['z'] = 28.09 },
	[24] = { ['x'] = -582.63, ['y'] = -867.52, ['z'] = 25.63 },
	[25] = { ['x'] = -1047.00, ['y'] = -779.63, ['z'] = 18.93 },
	[26] = { ['x'] = -1061.55, ['y'] = -495.26, ['z'] = 36.24 },
	[27] = { ['x'] = -1071.15, ['y'] = -433.65, ['z'] = 36.45 },
	[28] = { ['x'] = -1203.82, ['y'] = -131.74, ['z'] = 40.70 },
	[29] = { ['x'] = -932.33, ['y'] = 326.64, ['z'] = 71.25 },
	[30] = { ['x'] = -587.70, ['y'] = 250.66, ['z'] = 82.26 },
	[31] = { ['x'] = -478.28, ['y'] = 223.87, ['z'] = 83.02 },
	[32] = { ['x'] = -310.77, ['y'] = 226.85, ['z'] = 87.78 },
	[33] = { ['x'] = 75.20, ['y'] = 229.06, ['z'] = 108.70 },
	[34] = { ['x'] = 296.00, ['y'] = 147.55, ['z'] = 103.77 },
	[35] = { ['x'] = 978.79, ['y'] = -117.71, ['z'] = 73.99 },
	[36] = { ['x'] = 1187.01, ['y'] = -431.18, ['z'] = 67.02 },
	[37] = { ['x'] = 1260.03, ['y'] = -582.09, ['z'] = 68.88 },
	[38] = { ['x'] = 1360.39, ['y'] = -570.32, ['z'] = 74.22 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ENTREGAR ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ifood',function(source,args,rawCommand)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z,true)
	if args[1] == "iniciar" and distance <= 1.2 and not servico then
		servico = true
		selecionado = math.random(38)
		CriandoBlip(locs,selecionado)
		heL.Quantidade()
		TriggerEvent("Notify","sucesso","Você entrou em serviço.")
		TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Lanches</b>.")
	elseif args[1] == "cancelar" and servico then
		servico = false
		RemoveBlip(blips)
		TriggerEvent("Notify","aviso","Você saiu de serviço.")
	end	
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FAZER LANCHE ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('lanche',function(source,args,rawCommand)
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local distance = GetDistanceBetweenCoords(CoordenadaX1,CoordenadaY1,CoordenadaZ1,x,y,z,true)

    if distance <= 1.2 and heL.checkLanche() then
        TriggerEvent('cancelando',true)
        processo = true
        segundos = 8
        TriggerEvent("progress",8000,"Fazendo Lanche")
        SetTimeout(7500,function()
            vRP._DeletarObjeto()
            vRP._stopAnim(false)
            --TriggerServerEvent("trydeleteobj",ObjToNet("hei_prop_heist_box"))
        end)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ENTREGAS ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,247,217,99,100,1,0,0,1)
				if IsControlJustPressed(0,38) then
					if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("faggio2")) then
						if heL.checkPayment() then
							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
										selecionado = math.random(38)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlip(locs,selecionado)
							TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Lanches</b>.")
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ STATUS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("quantidade-lanche")
AddEventHandler("quantidade-lanche",function(status)
    quantidade = status
end)

local cds = {
	{x=151.9,y=-1467.61,z=28.6},
	{x=143.92,y=-1462.73,z=29.36},
	}

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k, v in pairs(cds) do
		  local distance = GetDistanceBetweenCoords(v.x,v.y,v.z,x,y,z,true)  
			if distance <= 5 then
				idle = 5
				DrawText3Ds(CoordenadaX,CoordenadaY,CoordenadaZ,"/ifood iniciar")
			end	
			if distance <= 3 then
				DrawText3Ds(CoordenadaX1,CoordenadaY1,CoordenadaZ1,"/lanche")
			end
		end
	   Wait(idle)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo then
			if segundos > 0 then
				segundos = segundos - 1
				if segundos == 0 then
					processo = false
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Lanche")
	EndTextCommandSetBlipName(blips)
end