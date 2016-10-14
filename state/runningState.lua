

local superClass = vehicleState.vehicleStateBase
local runningState = base.class("vehicleState.runningState", superClass)

vehicleState.runningState = runningState

function runningState:Process( car,dt )
	local nextState = car:getVehicleState( dt )


	if nextState == vehicleState.state_enum.MidStop_State then
		self:changeState(car,vehicleState.state_enum.MidStop_State)
	elseif nextState == vehicleState.state_enum.EndStop_State then
		self:changeState(car,vehicleState.state_enum.EndStop_State)
	else
		car:printState()
	end
end