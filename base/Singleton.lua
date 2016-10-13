------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20140202
-- 功能描叙: 单例类基类
------------------------------------------------------------------

base.Singleton = {}
local Singleton = base.Singleton
local KEY = "c_singleton";
--[[
@access public
@owner class
@brief 获取当前类的单例对象
]]
function Singleton:getInstance(...)
    local inst = rawget(self, KEY)
	if inst == nil then
		inst = self:new(...)
        rawset(self, KEY, inst)
	end
	return inst
end

--[[
@access public
@owner class
@brief 清除当前类的单例对象
]]
function Singleton:purge()
    local inst = rawget(self, KEY)
	if inst ~= nil then
		inst:clean()
		rawset(self, KEY, nil)
	end
end
