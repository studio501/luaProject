

local superClass = vehicleState.vehicleStateBase
local midStopState = base.class("vehicleState.midStopState", superClass)

vehicleState.midStopState = midStopState

function midStopState:Process( car,dt )
	self:changeState(car,vehicleState.state_enum.Running_State)
end