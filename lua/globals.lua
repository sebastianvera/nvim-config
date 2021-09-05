_G.dump = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  local reload_module = require('plenary.reload').reload_module

  _G.reload = function(name)
    reload_module(name)
    return require(name)
  end
end
