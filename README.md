# lualist
A simple wrapper for lua's built-in tables.
lualist is a complete port of [Jaylist](https://github.com/benbscholz/jaylist) in lua.
Jaylist's functionality was inspired by Python's dictionary.

## demo

        local list = require('lualist')

        local lualist = list()

        -- and add some items
        lualist.add("here", "strings")
        lualist.add("there", 1638423)
        lualist.add("these", {1,2,3,4,5})

        -- let's view the keys in the list
        -- -> ["here", "there", "these"]
        for k,v in pairs(lualist.keys()) do print(v) end

        -- let's view the values in the list
        -- -> ["strings", 1638423, [1,2,3,4,5]]
        for k,v in pairs(lualist.values()) do print(v) end

        -- let's remove an item
        lualist.remove("here")

        -- trying to retrieve an item that doesn't exist yields undefined
        -- -> undefined
        print(lualist.get("here"))

        -- -> 1638423
        print(lualist.get("there"))

        -- deep copy a list
        local beelist = lualist.copy()

        -- list equality
        -- -> true
        print(lualist.isEqual(beelist))

        -- empty a list
        lualist.clear()

        -- iteration with a callback
        beelist.each(function(key) print(key) end)

        -- iteration with a loop
        local item = beelist.next()
        while item do
            print(item)
            item = beelist.next()
        end

        -- update a list with the contents of another
        lualist.update(beelist)

## Functions:
###Create the list:

    local lualist = list()


###Add a value to the list:

#### add(key, value)
--Insert an object into the list, overwriting any value already assigned to the key. Returns the value upon successful addition.

    lualist.add("key", value)


###Get the value from the list:

#### get(key)
--Returns the value associated with key, undefined if the key has not been entered into the list.

    local val = lualist.get("key")


###Remove the value from the list:

#### remove(key)
--Removes the object from the list. Returns undefined if no value is assigned to the key. Upon successful removal, it returns the value removed. A list or array of keys may also be passed.

    lualist.remove("key")


###Get the keys in the list:

#### keys()
--Returns an array of the keys in the list.

    local keys = lualist.keys()


###Get the values in the list:

#### values()
--Returns an array of the values in the list.

    local values = lualist.values()


###Get the items in the list:

#### items()
--Returns an array of key-value pairs. [[key, value]]

    local items = lualist.items()


###Get the length of the list:

#### len()
--Returns the number of elements in the list, 0 when empty.

    len = lualist.len()


###Clear the list:

#### clear()
--Removes all the items from the list.

    lualist.clear()


###Check if the list contains the key:

#### hasKey(key)
-- Returns true if the list contains the key and false otherwise.

    lualist.hasKey(key)


###Update a list with another list:

#### update(list)
-- Adds the entries of the input list to the list.

    lualist.update(somelist)


###Deep copy a list:

#### copy()
-- Returns a deep copy of the list.

    local newlist = lualist.copy()


###Iterate through a list:

#### each(callback)
-- Iterates through each entry in the list, calling callback with parameter key for each value.

    lualist.each(function(key)somefunction(key)end)


###Iterate through a list:

#### next()
-- Iterates through each entry in the list, returning a key on each call. When the iteration is complete, next() returns undefined & the iteration can begin again.

    while(lualist.next()) {...}


###Return an object representation of the list:

#### object()
-- Returns the list as an object of key-value pairs.

    local obj = lualist.object()


###Check if two lists are equal:

#### isEqual(list)
-- Returns true if the lists are equivalent and false otherwise.

    lualist.isEqual(alist)


