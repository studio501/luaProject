------------------------------------------------------------------
-- ������: liyang_guo
-- ��������: 20140306
-- ��������: �������
------------------------------------------------------------------

local superClass = base.Object
base.ObjectPool = base.class("base.ObjectPool", superClass)
local ObjectPool = base.ObjectPool

local DEFAULT_SIZE = 5  -- Ĭ�϶���ش�С

function ObjectPool:ctor()
    superClass.ctor(self)

    self.m_cls  = nil   -- �洢�Ķ�����������
    self.m_size = 0     -- ������洢����
    self.m_arrObjs = {} -- �����洢����ı�
end

--[[
@param cls ���д洢�Ķ�����������
@param size ������洢����
]]
function ObjectPool:init(cls, size)
    superClass.init(self)

    assert(cls, "cls can't be nil")

    self.m_cls = cls
    self.m_size = size or DEFAULT_SIZE
end

--[[
@brief ��ȡһ������
@note ����ʱ�������д���������Ҫ�Ĳ���
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
@brief �ͷ�һ������
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