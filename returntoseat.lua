seat_names={
	"Bed",
	"Compact Pilot Seat",
	"Driver seat",
	"Helm",
	"Ladder", --this one can't use in server.setCharacterSeated(object_id,vehicle_id,nil)
	"Medical Bed",
	"Padded Seat",
	"Passenger Seat",
	"Passenger Seat (Deprecated)",
	"Pilot Seat",
	"Pilot Seat (HOTAS)",
	"Stretcher",
}
   --these are seats that are nil in setCharacterSeated while they are unnamed.
   --these are the seat names that are returned from while they are unnamed onCharacterSit/onPlayerSit.
g_savedata = {}

--helper function to find a given value in an unordered table
function thisEquals(v,t)
	local _ = false
	if t then
		for index,value in pairs(t)do
		_=_ or (v==value)
		end
	end
	return _
end
   
-- CALLBACKS

function onCreate(is_world_create)
	if g_savedata.seated == nil then
		g_savedata =
		{
			seated = {}
		}
	end
end

function onPlayerSit(peer_id, vehicle_id, seat_name)
	-- If the seat is unnamed, ignore
	if thisEquals(seat_name,seat_names)then
		seat_name=nil
	end

	if seat_name then
		table.insert(g_savedata.seated,{peer_id=peer_id,vehicle_id=vehicle_id, seat_name=seat_name})
	end
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, ...)
	if (command == "?returntoseat") then
		local seat_name,vehicle_id = nil,nil
		for _, seat in ipairs(g_savedata.seated) do
			if seat.peer_id == user_peer_id then
				seat_name = seat.seat_name
				vehicle_id = seat.vehicle_id
			end
		end

		if seat_name and vehicle_id then
			local object_id = server.getPlayerCharacterID(user_peer_id)	
			server.setCharacterSeated(object_id, vehicle_id, seat_name)
		end
	end

end
   