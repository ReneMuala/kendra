## Kendra Training
# Stochastic Gradient Descent Method

# example

```Lua
Create = require "createNetwork"
Gradient = require "training.stochasticGradientDescent.algorithm"
ErrorFunctions = require "training.stochasticGradientDescent.errorFunctions"
inspect = require "inspect"

local kendra = Create {
    input = 3,
    hidden = 3,
    output = 2,
    hiddenCount = 1
}

local kendraTrainer = Gradient(kendra, 0.9, 0.1, ErrorFunctions.SEF)

function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

for j = 1, 100 do
    for i = 0, 100000 do 
        -- training
        grad.train {
            {
                input =  {0,1,1},
                expect = {0,1}
            },
            {
                input =  {1,1,0},
                expect = {1,0}
            },
            {
                input =  {1,0,1},
                expect = {1,1}
            },
            {
                input =  {0,1,0},
                expect = {0,0}
            },
        } 
    end
    print("results: ")
    print(inspect(kendra.compute({0,1,1})))
    print(inspect(kendra.compute({1,1,0})))
    print(inspect(kendra.compute({1,0,1})))
    print(inspect(kendra.compute({0,1,0})))
    sleep(1)
end
```