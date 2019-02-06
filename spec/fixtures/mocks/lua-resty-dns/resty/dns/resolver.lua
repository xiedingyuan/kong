local resolver = {}

resolver.TYPE_A = "A"
resolver.TYPE_AAA = "AAA"

setmetatable(resolver, {
  __index = function(t, k)
    error("Trying to reach key " .. k)
  end
})

return resolver
