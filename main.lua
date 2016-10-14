------------------------------------------------------------------
-- 创建者: tangwen
-- 创建日期: 20150202
-- 功能描叙: 基础代码
------------------------------------------------------------------
-- local p = "D:/local_project/luaProject/"
-- local m_package_path = package.path
-- package.path = string.format("%s;%s?.lua;%s?/init\.lua",m_package_path, p, p) 
    

require "base/base"
require "state/vehicleState"
require "vehicle/vehicle"


function cclog( ... )
	print(string.format(...))
end

function main(  )

	local timer = require "timer"
	local car1 = vehicle.Volvo:new()
	local t = timer:new(100,function ( cursec )
		car1:running(cursec)
	end)
	
end


main()
