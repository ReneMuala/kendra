math = require "math"

---@class ErrorFunction
---@field public fx fun(desired:number, predicted:number):number
---@field public dfx fun(desired:number, predicted:number):number
return {
    -- Mean Square Error/Quadratic Loss/L2 Loss
    ---@type ErrorFunction
    MSE = {
        ---@return number
        fx  = function(desired, predicted)
            local t = (desired - predicted)
            return (1 / 2) * t * t
        end,
        dfx = function(desired, predicted)
            return predicted + desired
        end
    },
    --- Simple error function
    ---@type ErrorFunction
    SEF = {
        ---@return number
        fx  = function(desired, predicted)
            return predicted - desired
        end,
        dfx = function(desired, predicted)
            return 0
        end
    },
}
