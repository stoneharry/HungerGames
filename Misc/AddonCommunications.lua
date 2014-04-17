
local links = {};

local function ReceiveAddonMessage(message)
	local packet, link, linkCount, msg = message:match("(%d%d%d)(%d%d)(%d%d)(.+)");
	packet, link, linkCount = tonumber(packet), tonumber(link), tonumber(linkCount);
	print (packet, link, linkCount, msg);
	
	links[packet] = links[packet] or {count = 0};
	links[packet][link] = msg;
	links[packet].count = links[packet].count + 1;
	
	if (links[packet].count == linkCount) then
		local fullMessage = table.concat(links[packet]);
		--Do whatever with 'fullMessage'
		print (fullMessage, "\n");
		links[packet] = {count = 0};
	end
end

local t = os.clock();

ReceiveAddonMessage("0010101Hello, world!");
ReceiveAddonMessage("0020103Hello");
ReceiveAddonMessage("0020303world!");
ReceiveAddonMessage("0020203, ");

print (string.format("Time taken: %f", os.clock() - t));


local function SendAddonMessage(packet, message)
	local splitLength = 240;
	local splits = math.ceil(#message / splitLength);
	local counter = 1;
	for i = 1, #message, splitLength do
		local send = string.format("%03u%02u%02u%s", packet, counter, splits, message:sub(1, splitLength));
		message = message:sub(241);
		counter = counter + 1;
	end
end