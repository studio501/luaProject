------------------------------------------------------------------
-- 创建者: liyang_guo
-- 创建日期: 20140202
-- 功能描叙: 游戏对象类的根基类
------------------------------------------------------------------

local className = "base.GameObj"
local superClass = base.Object
local GameObj = base.class(className, superClass)
local TAG = className

base.GameObj = GameObj
local es = es
local clone = clone
local scheduler = cc.Director:getInstance():getScheduler()

function GameObj:ctor()
    superClass.ctor(self)

	self.m_updateEntry = nil -- update方法的定时器入口
	self.m_scheduledSelectorInfosArr = {} -- 定时调度的成员方法信息
    self.m_scheduledFuncInfosArr = {} -- 定时调度的闭包函数信息

    self.m_alarmEntryArr = nil -- 计时器入口数组

    self.m_callOnCleanFuncArr = nil -- 需要在clean方法中调用的函数
end

function GameObj:init()
    superClass.init(self)
    local events = self:getCaredEvents()
    assert(events, string.format("%s:getCaredEvents returned nothing!", self.c_strClassName))
    for _, event in ipairs(events) do
        es.register(event, self, self.handleEvent)
    end
end

--[[
@brief 获取对象关心的事件
]]
function GameObj:getCaredEvents()
    return { }
end

--[[
@brief 处理的事件
]]
function GameObj:handleEvent(eEvent, ...)
    cclog("event %s has not handled by class %s!", eEvent.name, self.c_strClassName)
end

--[[
@access protected
@owner instance
@brief 每帧调用一次，如要启动请先调用对象的scheduleUpdate方法
@param nDelta 当前帧的时间
]]
function GameObj:update(nDelta)
	
end

--[[
@access protected
@owner instance
@brief 启动对一个计时器
@param selector 被调方法
@param nInterval 调用间隔事件
@param bPaused 是否处于暂停状态，默认为false
]]
function GameObj:schedule(selector, nInterval, bPaused)
    assert(not self:isScheduled(selector), "the selector has been scheduled!")
    nInterval = nInterval or 0
    bPaused = bPaused or false
	local function func(nDelta)
		selector(self, nDelta)
	end
	local scheduleEntry = scheduler:scheduleScriptFunc(func, nInterval, bPaused or false)
	table.insert(self.m_scheduledSelectorInfosArr, { entry = scheduleEntry, selector = selector })
end

--[[
@brief 判断某个selector是否已被调度
]]
function GameObj:isScheduled(selector)
	for i,entryInfo in ipairs(self.m_scheduledSelectorInfosArr) do
		if entryInfo.selector == selector then
			return true
		end
	end
	return false
end


--[[
@access protected
@owner instance
@brief 启动对update进行不停地调用
]]
function GameObj:scheduleUpdate()
	if self.m_updateEntry ~= nil then
		return
	end

	local function func(nDelta)
		self:update(nDelta)
	end
	self.m_updateEntry = scheduler:scheduleScriptFunc(func, 0, false)
end

--[[
@access protected
@owner instance
@brief 停止对update进行不停地调用
]]
function GameObj:unscheduleUpdate()
	if self.m_updateEntry ~= nil then
		scheduler:unscheduleScriptEntry(self.m_updateEntry)
		self.m_updateEntry = nil
	end
end

--[[
@access protected
@owner instance
@brief 停止对某个selector的定时调度
@return true 成功
@return false 未对此selector进行定时调度
]]
function GameObj:unschedule(selector)
	
    for idx, info in ipairs(self.m_scheduledSelectorInfosArr) do
        if info.selector == selector then
			scheduler:unscheduleScriptEntry(info.entry)
		    table.remove(self.m_scheduledSelectorInfosArr, idx)
            return true
		end
    end
    return false
end

--[[
@access protected
@owner instance
@brief 停止所有定时调度
]]
function GameObj:unscheduleAllSelector()
	self:unscheduleUpdate()
    while not table.empty(self.m_scheduledSelectorInfosArr) do
        local info = table.remove(self.m_scheduledSelectorInfosArr)
        scheduler:unscheduleScriptEntry(info.entry)
    end
end


--[[
@access protected
@owner instance
@brief 对某个函数进行定时调度，对象释放时会自动解除定时调度
@param func 函数
]]
function GameObj:scheduleFunction(func, nInterval, bPaused)
    assert(func, "func cant' be nil")
    nInterval = nInterval or 0
    bPaused = bPaused or false
    local entry = scheduler:scheduleScriptFunc(func, nInterval, bPaused)
    table.insert(self.m_scheduledFuncInfosArr, {func = func, entry = entry})
    return entry
end

--[[
@access protected
@owner instance
@brief 停止对某个函数的定时调度
@param entry GameObj:scheduleFunction方法返回值
]]
function GameObj:unscheduleFunction(entry)
    assert(entry, "entry can't be nil")
    scheduler:unscheduleScriptEntry(entry)
    for idx, info in ipairs(self.m_scheduledFuncInfosArr) do
        if info.entry == entry then
            scheduler:unscheduleScriptEntry(entry)
            table.remove(self.m_scheduledFuncInfosArr, idx)
            return
        end
    end
    log.w(TAG, "entry %s is not scheduled by GameObj:scheduleFunction, traceback %s", tostring(entry), debug.traceback())
end

--[[
@access protected
@owner instance
@brief 停止对某个函数的定时调度
@param entry GameObj:scheduleFunction方法返回值
]]
function GameObj:unscheduleAllFunction()
    while not table.empty(self.m_scheduledFuncInfosArr) do
        local info = table.remove(self.m_scheduledFuncInfosArr)
        scheduler:unscheduleScriptEntry(info.entry)
    end
end

function GameObj:alarm(fireTime, selector)
    local entry
    local function callback__()
        if entry then
            table.removebyvalue(self.m_alarmEntryArr, entry)
        end
        selector(self)
    end
    entry = time.alarm(fireTime, callback__)
    self.m_alarmEntryArr = self.m_alarmEntryArr or {}
    table.insert(self.m_alarmEntryArr, entry)
    return entry
end

function GameObj:alarmFunc(fireTime, func)
    local entry
    local function callback__()
        if entry then
            table.removebyvalue(self.m_alarmEntryArr, entry)
        end
        func()
    end
    entry = time.alarm(fireTime, callback__)
    self.m_alarmEntryArr = self.m_alarmEntryArr or {}
    table.insert(self.m_alarmEntryArr, entry)
    return entry
end

function GameObj:removeAlarm(alarmEntry)
    time.removeAlarm(alarmEntry)
    table.removebyvalue(self.m_alarmEntryArr, alarmEntry)
end

function GameObj:removeAllAlarm()
    if self.m_alarmEntryArr then
        while true do
            local entry = table.remove(self.m_alarmEntryArr)
            if entry then
                time.removeAlarm(entry)
            else
                break
            end
        end

    end
end

function GameObj:createCallback(func)
    return cbhelper.callback(self, nil, func)
end

function GameObj:discardCallback(id)
    return cbhelper.discard(self, id)
end

--[[
@brief 注册一个函数，在clean方法中调用
]]
function GameObj:callOnClean(func)
    self.m_callOnCleanFuncArr = self.m_callOnCleanFuncArr or {}
    table.insert(self.m_callOnCleanFuncArr, func)
end

--[[
@brief 取消在clean方法中调用指定函数
]]
function GameObj:stopCallOnClean(func)
    table.removebyvalue(self.m_callOnCleanFuncArr, func)
end

function GameObj:callInNextFrame(func)
    local entry
    entry = self:scheduleFunction(function()
        self:unscheduleFunction(entry)
        func()
    end, 0, false)
end

--[[
@access public
@owner instance
@brief 当某个对象不再使用时，请调用它的此方法, 以释放它占有的资源
]]
function GameObj:clean()
    -- 解除对事件的监听
    local events = self:getCaredEvents()
    assert(events, string.format("%s:getCaredEvents returned nothing!", self.c_strClassName))
    for _, event in pairs(events) do
        es.remove(event, self, self.handleEvent)
    end

    -- 停止所有调度方法和函数
	self:unscheduleAllSelector()
    self:unscheduleAllFunction()

    -- 停止所有计时器
    self:removeAllAlarm()

    -- 清除所有回调
    cbhelper.discard(self)

    -- 调用所有需要在clean方法中调用的函数
    if self.m_callOnCleanFuncArr then
        for _, func in ipairs(self.m_callOnCleanFuncArr) do
            func()
        end
        self.m_callOnCleanFuncArr = nil
    end

    superClass.clean(self)
end