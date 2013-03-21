
local function makeSubscriptionInterfaces(instEvents, classEvents)
  for k,v in pairs(classEvents) do
    instEvents[k] = { subscribers = {} }
    
    local function subscribe(self,subscriber)
      local subscribers = self.subscribers
      subscribers[#subscribers+1] = subscriber
    end
    
    local function unsubscribe(self,unsubscriber)
      for i,v in ipairs(self.subscribers) do
        if v == unsubscriber then
          table.remove(self.subscribers, i)
        end
      end
    end
    
    instEvents[k].subscribe = subscribe
    instEvents[k].unsubscribe = unsubscribe
  end
end

local function addEventTriggers(inst)
  local events = inst.events
  
  for k,v in pairs(events) do
    inst[k] = function(self,...)
      for _,subscriber in ipairs(v.subscribers) do
        subscriber(...)
      end
    end
  end
end

local function addDelegates(class,parent,inst)  
  local delegates = {}
  
  for k,method in pairs(class) do
    if k ~= "events" and k ~= "init" and k:sub(1,2) ~= "__" then
      delegates[k] = function (...) return method(inst,...) end
    end
  end
    
  if parent ~= nil then
    for k,method in pairs(parent) do
      if k ~= "events" and k ~= "init" and k:sub(1,2) ~= "__" then
        delegates[k] = function (...) return method(inst,...) end
      end
    end
  end
    
  inst.delegates = delegates
end

local class = {}

local function new(self,parent)
  -- the new class to create
  local c = {}
  
  c.events = {}
  if parent ~= nil then
    for k,v in pairs(parent.events) do
      c.events[k] = v
    end
  end
  
  local c_meta = {}
  
  function c_meta:__index(key)
    if parent then
      return parent[key]
    else
      return nil
    end
  end
  
  function c_meta:__newindex(k,v)
    if k:sub(1,2) == '__' then
      rawset(getmetatable(self), k, v)
    else
      rawset(self,k,v)
    end  
  end
  
  function c_meta:__call(...)
    local inst = {}
    inst.__class = c
    
    addDelegates(self,parent,inst)
    inst.events = {}
    makeSubscriptionInterfaces(inst.events,self.events)
    addEventTriggers(inst)
    
    local inst_meta = {}
    for k,v in pairs(c_meta) do
      inst_meta[k] = v 
    end
    function inst_meta.__index(inst,key)
      return c[key]
    end
    
    setmetatable(inst,inst_meta)
    
    inst.init_super = parent and parent.init or nil
    inst:init(...)
    inst.init_super = nil
    
    return inst
  end

  setmetatable(c,c_meta)  
  return c
end

-- Returns a new class for you to add methods to
function class:new()
  return new(self,nil)
end

--Returns a new class which inherits from parent
--@param(parent : unknown) The constructor object of the parent class
function class:inherit(parent)
  return new(self,parent)
end

return class