------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20140202
-- 功能描叙: 有限状态机状态类
------------------------------------------------------------------

local superClass = base.GameObj
base.State = base.class("base.State", superClass)
local State = base.State

function State:ctor()
    superClass.ctor(self)

    self.m_owner = nil -- 状态所有者
end

function State:setOwner(owner)
    self.m_owner = owner
end

function State:enter()
	
end

function State:execute(nDeltaTime)
	
end

function State:exit()
	
end
