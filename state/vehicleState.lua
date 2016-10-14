

vehicleState = {}
vehicleState.state_enum = base.toNumberEnum({
{"Start_State",0},
{"Running_State",1},
{"MidStop_State",2},
{"EndStop_State",3},
})

require "state/vehicleStateBase"
require "state/endStopState"
require "state/midStopState"
require "state/runningState"
require "state/startState"


