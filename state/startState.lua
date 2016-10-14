

local superClass = vehicleState.vehicleStateBase
local startState = base.class("vehicleState.startState", superClass)

vehicleState.startState = startState

function startState:Process( car,dt )
	local nextState = car:getVehicleState( dt )


	if nextState == vehicleState.state_enum.Running_State then
		self:changeState(car,vehicleState.state_enum.Running_State)
	else
		car:printState()
	end
end