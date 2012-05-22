-- lualist based on Jaylist v2.2
-- Jaylist Copyright (C) 2011 by Ben Brooks Scholz. MIT Licensed.
-- lualist Copyright (C) 2012 by Lance Ulmer. MIT Licensed.

local list
list = function ()

    local _table = {}
    local _next  = nil

    local _isList
    _isList = function (item)
        return item._table and item.next
    end

    local _isArray
    _isArray = function (item)
        if (item and type(item) == 'table') then
            for key in pairs(item) do
                if (type(key) ~= "number") then
                    return false
                end
            end
            return true
        else
            return false
        end
    end

    local _zipArray
    _zipArray = function (a, b)
        local i = nil
        local zipped = {}

        for i = 1, #a do
            zipped[#zipped+1] = {a[i], b[i]}
        end

        return zipped
    end

    local _deepEquals
    _deepEquals = function (a_obj, b_obj)
        local i       = nil
        local key     = nil
        local atype   = type(a_obj)
        local btype   = type(b_obj)

        if (a_obj == b_obj) then
            return true
        end
        if (atype ~= btype) then
            return false
        end

        if (_isArray(a_obj) and _isArray(b_obj)) then
            if (#a_obj ~= #b_obj) then
                return false
            end
            for i = 1, #a_obj do
                if (a_obj[i] ~= b_obj[i]) then
                    return false
                end
            end
            return true
        end

        if (atype ~= "table") then
            return false
        end

        local a_keys = {}
        for key in pairs(a_obj) do
            a_keys[#a_keys+1] = key
        end

        local b_keys = {}
        for key in pairs(b_obj) do
            b_keys[#b_keys+1] = key
        end

        if (#a_keys ~= #b_keys) then
            return false
        end

        for key in pairs(a_obj) do
            if (not b_obj[key]) then
                return false
            end
            if (a_obj[key] and b_obj[key]) then
                return _deepEquals(a_obj[key], b_obj[key])
            end
        end

        return true
    end

    local _deepCopy
    _deepCopy = function (obj)
        local entry  = nil
        local copied = {}

        if (_isList(obj)) then
            copied = list()
        elseif (_isArray(obj)) then
            copied = {}
        end

        for entry in pairs(obj) do

            if (obj[entry]) then
                if (type(obj[entry]) == 'string' or
                    type(obj[entry]) == 'number' or
                    type(obj[entry]) == 'boolean') then
                    copied[entry] = obj[entry]
                elseif (_isArray(obj) or type(obj[entry]) == 'table') then
                    copied[entry] = _deepCopy(obj[entry])
                end

            end
        end
        return copied
    end


    local this
    this = {
        _table = _table,
        _next = _next,

        -- get: Returns the value attached to the given key or undefined
        -- if it isn't found.
        get = function (key)
            return this._table[key]
        end,

        -- add: Inserts an object into the list, assigning it to the given key.
        -- It returns the value upon successful addition to the list. If a value
        -- is inserted with a key that exists in the list already, the old value
        -- is overwritten. Add throws an error if the key passed is an internal
        -- property like 'hasOwnProperty'.
        add = function (key, value)
            this._table[key] = value
            return this._table[key]
        end,

        -- remove: Removes an object from the list with the given key. It
        -- returns undefined if no object with the given key exists in the
        -- list. Otherwise, it returns the value removed. A list or array
        -- of keys may also be passed.
        remove = function (item)
            local nitem = nil
            local val   = nil

            if (_isList(item)) then
                --while nitem = item.next() do
                nitem = item.next()
                while nitem do
                    this._table[nitem] = nil
                    nitem = item.next()
                end

            elseif (_isArray(item)) then
                while (#item ~= 0) do
                    table.remove(this._table, 1)
                end

            else
                val = this._table[item]
                this._table[item] = nil
                return val
            end
        end,


        -- keys: Returns an array of the keys in the list.
        keys = function ()
            local keys = {}
            for key in pairs(this._table) do
                if (type(key) ~= 'number') then
                    keys[#keys+1] = key
                end
            end
            return keys
        end,

        -- values: Returns an array of the values in the list. Duplicate values
        -- are only displayed once.
        values = function ()
            local values = {}

            for key, value in pairs(this._table) do
                if (type(key) ~= 'number') then
                    values[#values+1] = value
                end
            end

            return values
        end,

        -- items: Returns an array of key-value pairs: [[key, value]]
        items = function ()
            return _zipArray(this.keys(), this.values())
        end,

        -- len: Returns the number of items in the list. Returns zero if empty.
        len = function ()
            return #this.keys()
        end,

        -- clear: Removes the items from the list.
        clear = function ()
            this._table = {}
        end,

        -- hasKey: Returns true if the list contains the given key and false if
        -- if does not.
        hasKey = function (key)
            return (this.get(key) ~= nil)
        end,

        -- update: Adds all the entries from the input list to the list.
        update = function (list)
            list.each(function (key)
                this._table[key] = list.get(key)
            end)
        end,

        -- copy: Returns a deep copy of the list.
        copy = function ()
            local copy = list()
            copy.update(_deepCopy(this))

            return copy
        end,

        -- each: Iterates over each entry in the list, calling the callback
        -- with the parameter 'key'.
        each = function (callback)
            for key in pairs(this._table) do
                if (this._table[key]) then
                    callback(key)
                end
            end
        end,

        -- next: Iterates over the list, returning the key of next entry
        -- on each call. Returns undefined when the iteration is complete.
        next = function ()
            if (this._next ~= nil and #this._next ~= 0) then
                return table.remove(this._next,1)

            elseif (this._next == nil) then
                this._next = this.keys()
                return table.remove(this._next,1)

            elseif (#this._next == 0) then
                this._next = nil
                return this._next
            end
        end,

        -- object: Return the key-value list as an object.
        object = function ()
            return this._table
        end,

        -- isEqual: Returns true if the lists are equivalent and false otherwise.
        isEqual = function (list)
            return not _isList(list) and false or _deepEquals(this._table, list._table)
        end
    }
    return this
end

return list
