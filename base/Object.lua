------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20150202
-- 功能描叙: 所有类的根基类
------------------------------------------------------------------

base.Object = base.class("base.Object", nil)

local Object = base.Object
local clone = clone
--[[
@access public
@owner	class
@note 一般情况下不复写该方法
]]
function Object:new(...)
	local t = {}
	setmetatable(t, self)
	t:ctor(...)
	t:init(...)
	return t
end

--[[
@access protected
@owner	class
@brief 继承某个类
@detail	将要继承的类的全部属性拷贝到当前类中
]]
function Object:inherit(clsTarget)
	for k, v in pairs(clsTarget) do
		self[clone(k)] = clone(v)
	end
end

--[[
@access protected
@owner	instance
@brief 对对象进行构造，主要用于成员变量的初始化
]]
function Object:ctor()
    self.m_strCreationTraceback = debug.traceback() -- 创建追溯
    self.m_bCalledCtor = true
end

--[[
@access protected
@owner	instance
@brief 对对象进行初始化
]]
function Object:init()
    self.m_bCalledInit = true
end

--[[
@access public
@owner class
@owner instance
@brief 判断某一个类或者对象的类型是否为clsClass类，不考虑父类
]]
function Object:isExactlyKindOf(clsClass)
    return self.c_clsClass == clsClass
end

--[[
@access public
@owner class
@owner instance
@brief 判断某一个类或者对象的类型是否为clsClass类或者其子类
]]
function Object:isKindOf(clsClass)
	local cls = self.c_clsClass
	while cls ~= nil do
		if cls == clsClass then
			return true
		end
		cls = cls.c_clsSuper
	end
	return false
end

--[[
@access public
@owner instance
@brief 当某个对象不再使用时，请调用它的此方法, 以释放它占有的资源
]]
function Object:clean()
    assert(self.m_bCalledCtor, string.format("class %s have not called Object:ctor", self.c_strClassName))
    assert(self.m_bCalledInit, string.format("class %s have not called Object:init", self.c_strClassName))
end
