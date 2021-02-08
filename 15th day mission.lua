input = {2,15,0,9,1,20}

function print_table(arr)
    for k,v in pairs(arr) do
        io.write("["..k.."]"..": "..v..", ")
    end
    io.write("\n")
end

function part1()
    function check_found(arr, num)
        for k,v in pairs(arr) do
            if num == v then
                return true, k
            end
        end
        return false, -1
    end
    function memorygame(n, i, prev_num)
        -- print_table(input)
        -- print(i)
        if i > n then
            return prev_num
        else
            local repeated, index = check_found(input, prev_num)
            if not repeated then
                input[i - 1] = prev_num
                return memorygame(n, i + 1, 0)
            else
                local num = i - 1 - index
                input[i - 1] = prev_num
                input[index] = nil
                return memorygame(n, i + 1, num)
            end
        end
    end
    return memorygame(2020, #input + 1, table.remove(input))
end

function part2() 
    -- more efficient way: use numbers as keys, index as values
    input_dict = {}
    for i = 1, #input do
        input_dict[input[i]] = i
    end
    function memorygame(n, i, prev_num)
        if i > n then
            return prev_num
        else
            -- to search up whether number was repeated, just check if input_dict[num] is nil
            local rep_index = input_dict[prev_num]
            input_dict[prev_num] = i - 1
            if rep_index == nil then
                return memorygame(n, i + 1, 0)
            else
                local num = i - 1 - rep_index
                return memorygame(n, i + 1, num)
            end
        end
    end
    return memorygame(30000000, #input + 2, 0)
end

print(part1())
print(part2())

