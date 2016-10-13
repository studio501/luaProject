------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20140306
-- 功能描叙: 对象池类
------------------------------------------------------------------

local superClass = base.Object
base.ObjectPool = base.class("base.ObjectPool", superClass)
local ObjectPool = base.ObjectPool

local DEFAULT_SIZE = 5  -- 默认对象池大小

function ObjectPool:ctor()
    superClass.ctor(self)

    self.m_cls  = nil   -- 存储的对象所属的类
    self.m_size = 0     -- 最大对象存储个数
    self.m_arrObjs = {} -- 用来存储对象的表
end

--[[
@param cls 池中存储的对象所属的类
@param size 最大对象存储个数
]]
function ObjectPool:init(cls, size)
    superClass.init(self)

    assert(cls, "cls can't be nil")

    self.m_cls = cls
    self.m_size = size or DEFAULT_SIZE
end

--[[
@brief 获取一个对象
@note 调用时传递所有创建对象需要的参数
]]
function ObjectPool:obtain(...)
    local obj = table.remove(self.m_arrObjs)
    if obj then
        obj:ctor(...)
        obj:init(...)
    else
        obj = self.m_cls:new(...)
    end
    return obj
end

--[[
@brief 释放一个对象
]]
function ObjectPool:free(obj)
    if not #self.m_arrObjs < self.m_size then
        table.insert(self.m_arrObjs, obj)
    end
end

function ObjectPool:clean()
    self.m_arrObjs = nil
    
    superClass.clean(self)
end