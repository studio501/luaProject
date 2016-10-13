------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20150202
-- 功能描叙: 基础代码
------------------------------------------------------------------


base = {}

--[[
@brief 创建一个类
@param strClassName 类的名称
@param clsSuper 父类的类型，若没有父类则不传入
@return 用以模拟类的表
]]
function base.class(strClassName, clsSuper)
	
	local cls = {}
    setmetatable(cls, clsSuper)
    cls.c_clsSuper = clsSuper
    cls.c_clsClass = cls
    cls.c_strClassName = strClassName
    cls.__index = cls
    return cls
end

require "base/Object.lua"
require "base/GameObj.lua"
require "base/ObjectPool.lua"
require "base/Singleton.lua"
require "base/State.lua"
require "base/StateMachine.lua"

function base.init()

end

function base.clean()

end

--[[
@brief 创建字符串枚举
@param arrFieldNames 包含字段名的数组类型表
@note 字段名和字段值相同，都为字符串
]]
function base.toStringEnum(arrFieldNames)
	local enum = {}
	local strName = nil
	for i = 1, #arrFieldNames do
		strName = arrFieldNames[i]
		enum[strName] = strName
	end
	return enum
end

--[[
@brief 创建整数枚举
@param arrFieldInfos 包含字段信息的数组类型表
@note arrFieldInfos中的一个元素为{ strFiledName, nFieldValue }, 如不指定字段值，则nFieldValue为nil
]]
function base.toNumberEnum(arrFieldInfos)
	local enum = {}
	local info = nil
	local lastValue = -1
	for i = 1, #arrFieldInfos do
		info = arrFieldInfos[i]
		local name = info[1]	-- 第一个为字段名
		local value = info[2]	-- 第二个为字段值
		if value ~= nil then
			enum[name] = value
			lastValue = value
		else
			enum[name] = lastValue + 1
			lastValue = lastValue + 1
		end
	end
	return enum
end
