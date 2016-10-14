

local superClass = base.Object
local timer = base.class("timer",superClass)

function timer:init( timeBySec,cb )
	superClass.init(self)
	local i = 0
	while i< timeBySec do
		i = i+1
		cb(i)
	end
end

return timer