------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20140202
-- 功能描叙: 有限状态机类
------------------------------------------------------------------

local superClass = base.GameObj
local class = base.class
base.StateMachine = class("base.StateMachine", superClass)
local StateMachine = base.StateMachine

function StateMachine:ctor()
    superClass.ctor(self)

	self.m_owner 		= nil -- 拥有此状态机的对象
	self.m_curState		= nil -- 当前状态
    self.m_hasChangedState = false
    self.m_inFirstState = false
    self.m_globalState  = nil -- 全局状态
    self.m_hasChangedGlobalState = false
    self.m_inFirstGlobalState = false
end

function StateMachine:init(owner, stepLen)
	superClass.init(self)

	self.m_owner = owner
    self:schedule(self.step, stepLen or 0, false)
end

--[[
@brief 改变全局状态
]]
function StateMachine:changeGlobalState(newState)
    
    if self.m_globalState ~= nil then
		self.m_globalState:exit()
        self.m_globalState:clean()
	end
	self.m_globalState = newState
    if not self.m_hasChangedGlobalState then
        self.m_hasChangedGlobalState = true
        self.m_inFirstGlobalState = true
    else
        self.m_inFirstGlobalState = false
    end
    if self.m_globalState then
        self.m_globalState:setOwner(self.m_owner)
	    self.m_globalState:enter()
    end
end

--[[
@brief 改变为新全局状态，如果当前状态与新状态相同则不改变
]]
function StateMachine:changeNewGlobalState(newState)
    if self.m_globalState.c_clsClass ~= newState.c_clsClass then
        self:changeGlobalState(newState)
    end
end

--[[
@brief 改变状态
]]
function StateMachine:changeState(newState)
	if self.m_curState ~= nil then
		self.m_curState:exit(self.m_owner)
        self.m_curState:clean()
	end

    if not self.m_hasChangedState then
        self.m_hasChangedState = true
        self.m_inFirstState = true
    else
        self.m_inFirstState = false
    end

	self.m_curState = newState
    self.m_curState:setOwner(self.m_owner)
	self.m_curState:enter()
end

--[[
@brief 改变状态
]]
function StateMachine:changeNewState(newState)
    if self.m_curState.c_clsClass ~= newState.c_clsClass then
        self:changeState(newState)
    end
end

function StateMachine:getCurrentState()
	return self.m_curState
end

function StateMachine:getCurrentGlobalState()
    return self.m_globalState
end

function StateMachine:isInFirstState()
    return self.m_inFirstState
end

function StateMachine:isInFirstGlobalState()
    return self.m_inFirstGlobalState
end

function StateMachine:step(nDeltaTime)

    if self.m_globalState ~= nil then 
        self.m_globalState:execute(nDeltaTime)
    end

	if self.m_curState ~= nil then
		self.m_curState:execute(nDeltaTime)
	end
end

function StateMachine:isInGlobalState(clsGlobalStateClass)
    if clsGlobalStateClass == nil then return self.m_globalState == nil end
    if self.m_globalState == nil and clsGlobalStateClass ~= nil then return false end
    return self.m_globalState:isExactlyKindOf(clsGlobalStateClass)
end

function StateMachine:isInState(clsStateClass)
    if clsStateClass == nil then return self.m_curState == nil end
    if self.m_curState == nil and clsStateClass ~= nil then return false end
	return self.m_curState:isExactlyKindOf(clsStateClass)
end

function StateMachine:clean()

    if self.m_curState then
        self.m_curState:exit()
        self.m_curState:clean()
        self.m_curState = nil
    end

    if self.m_globalState then
        self.m_globalState:exit()
        self.m_globalState:clean()
        self.m_globalState = nil
    end

    superClass.clean(self)
end