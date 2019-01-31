local meta = require "kong.meta"


local OffConnector   = {}
OffConnector.__index = OffConnector


local function ignore()
  return true
end


function OffConnector.new(kong_config)
  local self = {
    database = "off",
    timeout = 1,
    close = ignore,
    connect = ignore,
    truncate_table = ignore,
    truncate = ignore,
    insert_lock = ignore,
    remove_lock = ignore,
    schema_reset = ignore,
  }

  return setmetatable(self, OffConnector)
end


function OffConnector:infos()
  return {
    strategy = "off",
    db_name = "kong_off",
    db_desc = "cache",
    db_ver = meta._VERSION,
  }
end


function OffConnector:connect_migrations(opts)
  return {}
end


function OffConnector:query()
  return nil, "cannot perform queries without a database"
end


function OffConnector:schema_migrations(subsystems)
  local rows = {}
  for _, subsystem in ipairs(subsystems) do
    local migs = {}
    for _, mig in ipairs(subsystem.migrations) do
      table.insert(migs, mig.name)
    end
    table.insert(rows, {
      subsystem = subsystem.name,
      executed = migs,
      last_executed = migs[#migs],
      pending = {},
    })
  end
  return rows
end


function OffConnector:is_014()
  return {
    is_014 = false,
  }
end


function OffConnector:get_timeout()
  return self.timeout
end


return OffConnector
