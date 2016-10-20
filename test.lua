local lfs = require"lfs"
local dt = os.date("*t")

local allClass = {}

local dir = arg[1] or "./viva_unity_code"

function io.writefile(path, content, mode)
    mode = mode or "a+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function cclog(...)
	--print(string.format(...))
	local outputFile = string.format("%s_%s_%s_%s_%s_%s.txt",dt.year,dt.month,dt.day,dt.hour,dt.min,dt.sec)
	assert( io.writefile(outputFile,...) ,"open file error" )
	assert( io.writefile(outputFile,"\n"))
end


function printTable(tab)
	for i,v in pairs(tab) do
		if type(v) == "table" then
			cclog("table %s : {",i)
			printTable(v)
			cclog("}\n")
		else
			cclog(string.format("%s : %s\n",i,v))
		end
	end
end

function getClassInfo( filename )
	local file = io.open(filename,"r")
	assert(file,string.format("can not open %s to read",filename))
	local str = file:read()
	while str do
		local r1,r2 = string.match(str,"public class (%w+) : (%w+)")
		if r1 and r2 then
			allClass[r1] = r2
			break
		end
		str = file:read()
	end
end

function printClass( inKey )
	local rk = inKey
	local rv = allClass[inKey]

	local result = rk
	while rv do
		result = string.format("%s<---%s",rv,result)
		rk = rv
		rv = allClass[rk]
	end
	-- cclog(result)

	return result
end

function printClassLikeTree(  )
	local t = {}
	for key,var in pairs( allClass ) do
		table.insert(t,printClass(key)) 
	end
	table.sort(t)
	printTable(t)
end

function attrdir (path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = string.format("%s/%s",path,file) --path..'/'..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
			--printTable(attr)
            if attr.mode == "directory" then
				--print(f)
			elseif attr.mode == "file" then
				if "cs" == string.sub(f,-2) then
					getClassInfo(f)
				end
			end
        end
    end

    printClassLikeTree()
    -- printTable(allClass)
end

function main(  )
	--attrdir ("./viva_unity_code")	
	attrdir(dir)
	-- local str = "public class DelayedSpriteSetup : MonoBehaviour"
	
end

main()

