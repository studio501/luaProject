

local superClass = base.Object
local vehicleStateBase = base.class("vehicleState.vehicleStateBase", superClass)

vehicleState.vehicleStateBase = vehicleStateBase

function vehicleStateBase:Process( car,dt )
	
end

function vehicleStateBase:changeState( car,ds )
	car:changeState(ds)
end
