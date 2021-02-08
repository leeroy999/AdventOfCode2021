input = [[
1007153
29,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,433,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,19,x,x,x,23,x,x,x,x,x,x,x,977,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,41
]]

function parse_input(input)
    local arr = {}
    for line in string.gmatch(input, ".-\n") do
        arr[#arr + 1] = line
    end
    local i = 1
    arr[3] = {}
    for bus in string.gmatch(arr[2], "%d+") do
        arr[3][i] = bus
        i = i + 1
    end
    arr[4] = {}
    i = 1
    for bus in string.gmatch(arr[2]..",", ".-%p") do
        local str = string.sub(bus, 1, -2)
        if str == "x" then
            arr[4][i] = "x"
        else
            arr[4][i] = tonumber(str)
        end
        i = i + 1
    end
    return arr
end

function printArray(A)
	for k, v in pairs(A) do
	    if type(v) == "table" then
	        for i, j in pairs(v) do
	            print("["..k.."]".."["..i.."]"..":"..j)
	        end
        else
		    print("["..k.."]"..":"..tostring(v))
		end
	end
end

function part1()
    local input_arr = parse_input(input)

    local earliest, arr_buses = tonumber(input_arr[1]), input_arr[3]

    local min, bus_no = math.huge, 0

    for i = 1, #arr_buses do
        local bus_time = tonumber(arr_buses[i])
        local delay = math.ceil(earliest / bus_time) * bus_time - earliest
        if delay < min then
            min = delay
            bus_no = bus_time
        end
    end

    return min * bus_no
end

-- Naive solution
--[[function part2()
    local input_arr = (parse_input(input))[4]
    function max_bus(arr, i, max, index)
        if arr[i] ~= "x" and arr[i] - i + 1 > max then
            max = arr[i]
            index = i
        end
        if i == #arr then
            return max, index
        else
            return max_bus(arr, i + 1, max, index)
        end
    end

    function index_num(arr)
        local index_arr = {}
        for i = 1, #arr do
            if arr[i] ~= "x" then
                index_arr[#index_arr + 1] = {i, arr[i]}
            end
        end
        return index_arr
    end

    local max, ind = max_bus(input_arr, 1, 0, 0)
    local start = math.ceil((max - ind + 1) / input_arr[1]) * input_arr[1]
    print(start)
    
    local index_arr = index_num(input_arr)
    local earliest = 0

    while(earliest == 0) do
        local time = start
        local index = 2

        while index <= #index_arr do
            time = start + index_arr[index][1] - 1
            if time % index_arr[index][2] == 0 then
                index = index + 1
            else
                break
            end
        end
        if index > #index_arr then
            earliest = start
        else
            start = start + index_arr[1][2]
        end
    end

    return earliest
end]]

--Chinese Remainder Theorem
function part2()
    -- Taken from https://www.rosettacode.org/wiki/Sum_and_product_of_an_array#Lua
    function prodf(a, ...) return a and a * prodf(...) or 1 end
    function prodt(t) return prodf(unpack(t)) end
    
    function mulInv(a, b)
        local b0 = b
        local x0 = 0
        local x1 = 1
    
        if b == 1 then
            return 1
        end
    
        while a > 1 do
            local q = math.floor(a / b)
            local amb = math.fmod(a, b)
            a = b
            b = amb
            local xqx = x1 - q * x0
            x1 = x0
            x0 = xqx
        end
    
        if x1 < 0 then
            x1 = x1 + b0
        end
    
        return x1
    end
    
    function chineseRemainder(n, a)
        local prod = prodt(n)
    
        local p
        local sm = 0
        for i=1,#n do
            p = prod / n[i]
            sm = sm + a[i] * mulInv(p, n[i]) * p
        end
    
        return math.fmod(sm, prod)
    end

    function index_num(arr)
        local n = {}
        local a = {}
        for i = 1, #arr do
            if arr[i] ~= "x" then
                n[#n + 1] = arr[i]
                a[#a + 1] = arr[i] - i + 1
            end
        end
        return n, a
    end

    local input_arr = (parse_input(input))[4]
    local n, a = index_num(input_arr)
    
    return chineseRemainder(n, a)

end

print(part1())
print(part2())