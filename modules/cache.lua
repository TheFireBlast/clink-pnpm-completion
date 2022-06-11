---@class Cache
---@field caches table
---@field times table
---@field default_time_limit number
---@field time_limits table
local Cache = {}

---Creates a new cache manager instance
---@param default_time_limit number
---@return Cache
function Cache:new(default_time_limit)
    local c = {
        caches = {},
        times = {},
        time_limits = {},
        default_time_limit = default_time_limit
    }
    setmetatable(c, self)
    self.__index = self
    return c
end

---Checks if a certain cache is still valid
---@param id string
---@return boolean
function Cache:valid(id)
    local time_limit = self.time_limits[id] or self.default_time_limit
    local timestamp = self.times[id]
    return timestamp ~= nil and os.time() - timestamp < time_limit
end

---Gets the value of a cache
---@param id string
---@return any
function Cache:get(id)
    return self.caches[id]
end

---Updates a cache's value
---@param id string
---@param value any
function Cache:update(id, value)
    self.times[id] = os.time()
    self.caches[id] = value
end

---Makes a cache invalid
---@param id string
function Cache:invalidate(id)
    self.times[id] = nil
end

---Changes a cache's time limit
---@param id string
---@param time_limit integer
function Cache:set_time_limit(id, time_limit)
    self.time_limits[id] = time_limit
end

return Cache
