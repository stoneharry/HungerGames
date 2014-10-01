
function sendAddonMessage(plr, msg, packet)
	local splitLength = 240
	local splits = math.ceil(msg:len() / splitLength)
	local send
	local counter = 1
	for i=1, msg:len(), splitLength do
		send = string.format("%03d", packet)
		send = send .. string.format("%02d", counter)
		send = send .. string.format("%02d", splits)
		if ((i + splitLength) > msg:len()) then
			send = send .. msg:sub(i, msg:len())
		else
			send = send .. msg:sub(i, i + splitLength)
		end
		counter = counter + 1

		if _DEBUG then print("[SENT] " .. send) end
		plr:SendAddonMessage(send, "", 7, plr)
	end
end