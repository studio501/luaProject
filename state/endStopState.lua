

local superClass = vehicleState.vehicleStateBase
local endStopState = base.class("vehicleState.endStopState", superClass)

vehicleState.endStopState = endStopState

function endStopState:Process( car,dt )
	car:printState()
end