input = [[
95
43
114
118
2
124
120
127
140
21
66
103
102
132
136
93
59
131
32
9
20
141
94
109
143
142
65
73
27
83
133
104
60
110
89
29
78
49
76
16
34
17
105
98
15
106
4
57
1
67
71
14
92
39
68
125
113
115
26
33
61
45
46
11
99
7
25
130
42
3
10
54
44
139
50
8
58
86
64
77
35
79
72
36
80
126
28
123
119
51
22
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
	for i=1,#A do
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

function part2()
    local arr_input = parse_input(input)
    merge_sort(arr_input)
    arr_input[0] = 0
    function arr_slice(A, pieces)
        local arr = {}
        local prev = 0
        for i = 1, pieces do
            local max = math.floor(#A / pieces * i)
            while(max ~= #A and A[max + 1] - A[max] ~= 3) do -- must be 3 apart
                max = max + 1
            end
            arr[i] = table.slice(A, prev, max)
            prev = max
        end
        return arr
    end
    local function perms(arr)
        local accumulator = 1
        local function perm_changing(arr, index)
            
            if not (index >= #arr or #arr == 2) then
                
                perm_changing(arr, index + 1)
                
                local diff = arr[index + 1] - arr[index - 1]
                
                if diff <= 3 then
                    local copy_arr = table.shallow_copy(arr)
                    table.remove(copy_arr, index)
                    perm_changing(copy_arr, index)
                    accumulator = accumulator + 1
                end
            end
        end
        perm_changing(arr, 2)
        return accumulator
    end

    local answer = 1
    local num = 5 -- pieces to be cut
    local arr_sliced = arr_slice(arr_input, num)
    
    for j = 1, num do
        answer = answer * perms(arr_sliced[j])
    end
    return answer
end

print(part1())
print(part2())

--[[
// Source Academy

function remove_array(A, i){
    const new_A = [];
    for (let j = 0; j < i; j = j + 1){
        new_A[array_length(new_A)] = A[j];
    }
    for (let k = i + 1; k < array_length(A); k = k + 1){
        new_A[array_length(new_A)] = A[k];
    }
    return new_A;
}
function distinct_arrangements(arr){
    let accumulate = 1;
    function perm_changing(arr, index){
        if (!(index >= array_length(arr) - 1  || array_length(arr) === 2)) {
            perm_changing(arr, index + 1);
            const diff = arr[index + 1] - arr[index - 1];
            if (diff <= 3) {
                accumulate = accumulate + 1;
                const rem_arr = remove_array(arr, index);
                perm_changing(rem_arr, index);
            } else {}
        } else {}
    }
    perm_changing(arr, 1);
    return accumulate;
}


// test1
// const arr_input = [0, 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19];
// distinct_arrangements(arr_input);

// test2
// const arr_input = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49];
// distinct_arrangements(arr_input);

// test2
// const arr_input = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 20, 21, 22, 25, 26, 27, 28, 29, 32, 33, 34, 35, 36, 39, 42, 43, 44, 45, 46, 49, 50, 51, 54, 57, 58, 59, 60, 61, 64, 65, 66, 67, 68, 71, 72, 73, 76, 77, 78, 79, 80, 83, 86, 89, 92, 93, 94, 95, 98, 99, 102, 103, 104, 105, 106, 109, 110, 113, 114, 115, 118, 119, 120, 123, 124, 125, 126, 127, 130, 131, 132, 133, 136, 139, 140, 141, 142, 143];
// distinct_arrangements(arr_input);

]]

--[[
    // Source Academy

function remove_array(A, i){
    const new_A = [];
    for (let j = 0; j < i; j = j + 1){
        new_A[array_length(new_A)] = A[j];
    }
    for (let k = i + 1; k < array_length(A); k = k + 1){
        new_A[array_length(new_A)] = A[k];
    }
    return new_A;
}

function tonumber_array(A){
    let num = 0;
    const len = array_length(A);
    for (let i = 1; i < len; i = i + 1){
        num = num + A[i];
    }
    return num;
}

function distinct_arrangements(arr){
    const mem = [];
    
    function perm_changing(arr, index){
        if (index < array_length(arr) - 1) {
            const arr_id = tonumber_array(arr);
            
            const diff = arr[index + 1] - arr[index - 1];
            if (diff <= 3){
                const rem_arr = remove_array(arr, index);
                let no_remove = 0;
                if (mem[arr_id] !== undefined) {
                    no_remove = mem[arr_id];
                } else {
                    no_remove = perm_changing(arr, index + 1);
                    mem[arr_id] = no_remove;
                }
                const remove = perm_changing(rem_arr, index);
                const result = no_remove + remove;
                return result;
                
            } else {
                const no_remove = perm_changing(arr, index + 1);
                // mem[arr_id] = no_remove;
                return no_remove;
            }

        } else {
            return 1;
        }
    }
    
    return perm_changing(arr, 1);
}


// test0
// const arr_input = [0, 1, 2, 3, 4, 5];
// distinct_arrangements(arr_input);

// test1
// const arr_input = [0, 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19];
// distinct_arrangements(arr_input);

// test2
// const arr_input = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49];
// distinct_arrangements(arr_input);

// test3
const arr_input = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 20, 21, 22, 25, 26, 27, 28, 29, 32, 33, 34, 35, 36, 39, 42, 43, 44, 45, 46, 49, 50, 51, 54, 57, 58, 59, 60, 61, 64, 65, 66, 67, 68, 71, 72, 73, 76, 77, 78, 79, 80, 83, 86, 89, 92, 93, 94, 95, 98, 99, 102, 103, 104, 105, 106, 109, 110, 113, 114, 115, 118, 119, 120, 123, 124, 125, 126, 127, 130, 131, 132, 133, 136, 139, 140, 141, 142, 143];
distinct_arrangements(arr_input);
]]