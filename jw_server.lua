local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

RegisterCommand('info',function(source,args,rawCommand)
	if not source then
		error("You are not console.")
	end

	if args[1] == nil then
		TriggerClientEvent("Notify", source, "aviso", "Você precisa informar o passaporte do personagem")
		return
	end

	local user_id = vRP.getUserId(source)
	local tplayer = vRP.getUserSource(tonumber(args[1]))
	
	if tplayer == nil then
		TriggerClientEvent("Notify", source,"aviso","Passaporte <b>"..vRP.format(args[1]).."</b> indisponível no momento.")
		return
	end

	if vRP.hasPermission(user_id, "admin.permissao") then
		local ped = GetPlayerPed(tplayer)
		local tidentity = vRP.getUserIdentity(tplayer)    
		local ping = GetPlayerPing(tplayer)
		local name = GetPlayerName(tplayer)
		local job = vRP.getUserGroupByType(tplayer, "job") or "Desempregado"
		local ip = GetPlayerEndpoint(tplayer)
		local health = GetEntityHealth(ped)
		local vida = health - 100
		local vidamax = GetEntityMaxHealth(ped)
		local colete = GetPedArmour(ped)

		vRPclient._setDiv(source,"infocompleta",".div_infocompleta { background-color: rgba(0,30,100,0.60); font-size: 15px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #ccffff; }","<div class=\"local\"><b>Nome:</b> "..tidentity.name.." "..tidentity.firstname.." ( "..vRP.format(tidentity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..tidentity.registration.."</div><div class=\"local\"><b>Idade:</b> "..tidentity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..tidentity.phone.."</div><div class=\"local2\"><b>IP:</b> "..ip.."</div><div class=\"local2\"><b>Ping:</b> "..ping.."ms</div><div class=\"local2\"><b>Name:</b> "..name.."</div><div class=\"local2\"><b>Emprego:</b> "..job.."</div><div class=\"local2\"><b>Vida:</b> "..vida.."/"..vidamax.."</div><div class=\"local2\"><b>Colete:</b> "..colete.."/100</div>")
		
		vRP.request(source,"Você deseja fechar a info?", 1000)
		
		vRPclient._removeDiv(source,"infocompleta")
	else
		TriggerClientEvent("chatMessage", source, "", { 255, 255, 255 }, "Sem permissão")
	end
end)

RegisterCommand('info2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local rows = vRP.query("vRP/userid_byidentifier",{ identifier = args[1] })
	local idtf = json.encode(rows)
    TriggerClientEvent("chatMessage",source, "", { 255, 255, 255 }, "ID: "..idtf)
end)
