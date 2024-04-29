math = require "math"

---@class ActivationFunction
---- The function
---@field public fx fun(x:number):number
---@field public dfx fun(x:number):number

return {
    ---@type ActivationFunction
    Tanh = {
        fx  = math.tanh,
        dfx = function(x)
            local t = math.tanh(x)
            return 1 - t * t end
    },

    ---@type ActivationFunction
    ReLu = {
        fx = function(x) return math.max(x, 0) end,
        --- Undefined for x == 0
        dfx = function(x)
            if x < 0 then return 0 end
            if x > 1 then return 1 end
            error("Relu.dfx is not defined for x == 0")
        end
    },

    ---@type ActivationFunction
    Sigmoid = {
        fx  = function(x) return 1 / (1 + math.exp(-x)) end,
        dfx = function(x)
            return 1 / (1 + math.exp(-x)) * (1 - (1 / (1 + math.exp(-x)))) end,
    },

    ---@type ActivationFunction
    Linear = {
        fx  = function(x) return x end,
        dfx = function(x) return 1 end,
    }
}
