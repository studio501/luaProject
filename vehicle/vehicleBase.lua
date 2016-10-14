------------------------------------------------------------------
-- 创建者: tangwen
-- 创建日期: 20150202
-- 功能描叙: 基础代码
------------------------------------------------------------------


local vehicle = vehicle
local superClass = base.Object
local vehicleBase = base.class("vehicleBase",superClass)
vehicle.vehicleBase = vehicleBase

function vehicleBase:ctor(  )
	superClass.ctor(self)
	self.m_name = nil
	self.m_speed = nil

end

function vehicleBase:init( dt )
	self.m_stateMap = {}
	self.m_stateMap[1] = {state=1,time=10}
	self.m_stateMap[2] = {state=2,time=20}
	self.m_stateMap[3] = {state=2,time=60}
	self.m_stateMap[4] = {state=3,time=100}

	self.m_curState = vehicleState.state_enum.Start_State

	self.m_s1 = vehicleState.startState:new()
	self.m_s2 = vehicleState.runningState:new()
	self.m_s3 = vehicleState.midStopState:new()
	self.m_s4 = vehicleState.endStopState:new()
	
end

function vehicleBase:running( dt )
	self:getState():Process(self,dt)
end

function vehicleBase:getVehicleState( dt )
	for i=1,#self.m_stateMap do
		if self.m_stateMap[i].time == dt then
			return self.m_stateMap[i].state
		end
	end
	return -1
end

function vehicleBase:getStateWithString( state )
	for key,var in pairs(vehicleState.state_enum) do
		if var == state then
			return key
		end
	end
	return "state error"
end

function vehicleBase:getState(  )
	if self.m_curState == 0 then
		return self.m_s1
	elseif self.m_curState == 1 then
		return self.m_s2
	elseif self.m_curState == 2 then
		return self.m_s3
	elseif self.m_curState == 3 then
		return self.m_s4
	end
end

function vehicleBase:changeState( destState )
	cclog(string.format("%s changeState to %s",self:getStateWithString(self.m_curState),self:getStateWithString(destState)))
	self.m_curState = destState
end

function vehicleBase:printState(  )
	cclog(string.format("car state is %s",self:getStateWithString(self.m_curState)))
end

