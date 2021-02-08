input = [[
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
]]

function merge(A, low, mid, high) 
    local B = {}
    local left = low
    local right = mid + 1
    local Bidx = 1

    while (left <= mid and right <= high) do
        
        if (A[left] <= A[right]) then
            B[Bidx] = A[left]
            left = left + 1
        else 
            B[Bidx] = A[right]
            right = right + 1
        end
        Bidx = Bidx + 1
    end
    
    while (left <= mid) do
        B[Bidx] = A[left]
        Bidx = Bidx + 1
        left = left + 1
    end
    while (right <= high) do
        B[Bidx] = A[right]
        Bidx = Bidx + 1
        right = right + 1
    end
    
    for k = 1, (high - low + 1) do
        A[low + k - 1] = B[k]
    end
end

function merge_sort_helper(A, low, high) 
    if (low < high) then
        local mid = math.floor((low + high) / 2)
        merge_sort_helper(A, low, mid)
        merge_sort_helper(A, mid + 1, high)
        merge(A, low, mid, high)
    end
end

function merge_sort(A) 
    merge_sort_helper(A, 1, #A)
end

function printArray(A)
	for i=0,#A do
		io.write(A[i] .. ", ")
	end
	io.write("\n")
end

function parse_input(input)
    local arr = {}
    for number in string.gmatch(input, "%d+") do
        table.insert(arr, tonumber(number))
    end
    return arr
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

function part1()
    local arr = parse_input(input)
    merge_sort(arr)
    local ones = 0
    local threes = 0
    local abrupt = false
    if arr[1] == 3 then
        threes = threes + 1
    elseif arr[1] == 1 then
        ones = ones + 1
    else
        -- do nothing
    end

    for i=1, #arr - 1 do
        diff = arr[i + 1] - arr[i]
        if diff > 3 then -- abrupt ending
            abrupt = true
            threes = threes + 1
            break
        elseif diff == 3 then
            threes = threes + 1
        elseif diff == 1 then
            ones = ones + 1
        else
            -- do nothing
        end
    end
    if not abrupt then
        threes = threes + 1
    end
    return ones * threes
end

function stringify_array(A)
    local str = ""
    for i = 1, #A do
        str = str .. tostring(A[i])
    end
    return str
end

function part2()
    local arr_input = parse_input(input)
    merge_sort(arr_input)
    arr_input[0] = 0
    local function perms(arr)
        local mem = {}
        local function perm_changing(arr, index)
            local arr_id = stringify_array(arr)
            if index < #arr then
                if mem[arr_id] ~= nil then
                    return mem[arr_id]
                else
                    local diff = arr[index + 1] - arr[index - 1]
                    if diff <= 3 then
                        local copy_arr = table.shallow_copy(arr)
                        table.remove(copy_arr, index)
                        local remove = perm_changing(copy_arr, index)
                        local no_remove = perm_changing(arr, index + 1)
                        
                        local result = no_remove + remove
                        mem[arr_id] = result
                        return result
                    else
                        local no_remove = perm_changing(arr, index + 1)
                        mem[arr_id] = no_remove
                        return no_remove
                    end
                end
            else
                return 1
            end
        end
        return perm_changing(arr, 1)
    end
    return perms(arr_input)
end

-- print(part1())
print(part2())