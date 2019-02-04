local declarative = require("kong.db.declarative")
local kong = kong


-- Do not accept Lua configurations from the Admin API
-- because it is Turing-complete.
local accept = {
  yaml = true,
  json = true,
}


return {
  ["/config"] = {
    POST = function(self, db)
      if kong.db.strategy ~= "off" then
        kong.response.exit(400, {
          message = "this endpoint is only available when Kong is " ..
                    "configured to not use a database"
        })
      end

      local dc = declarative.init(kong.configuration)

      local config = self.params.config
      -- TODO extract proper filename from the input
      local entities, err = dc:parse_string(config, "config.yml", accept)
      if err then
        return kong.response.exit(400, { error = err })
      end

      declarative.load_into_cache(entities)

      return kong.response.exit(201, entities)
    end,
  },
}
