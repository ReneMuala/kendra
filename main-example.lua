Create = require "createNetwork"
Gradient = require "training.stochasticGradientDescent.algorithm"
ErrorFunctions = require "training.stochasticGradientDescent.errorFunctions"
inspect = require "deps.inspect"
Manager = require "manager"
Math = require "math"

kendra = Create {
    input = 3,
    hidden = 3,
    output = 2,
    hiddenCount = 1
}

kendraManager = Manager(kendra, "models/kendra-game.model.lua")

kendraManager.tryLoad()

-- get output using euclidean distance
function train()
    grad = Gradient(kendra, 0.9, 0.001, ErrorFunctions.SEF)
    iterationsCount = 20
    grad.verbosity = 0
    for i = 1, iterationsCount do
        for j = 1, 25000 do
            grad.train {
                {
                    input = { 1, 0, 0 },
                    expect = { 1, 0 }
                },
                {
                    input = { 1, 0, 1 },
                    expect = { 1, 1 }
                },
                {
                    input = { 0, 0, 1 },
                    expect = { 0, 1 }
                },
                {
                    input = { 0, 1, 0 },
                    expect = { 0, 0 }
                },
                {
                    input = { 1, 1, 0 },
                    expect = { 1, 0 }
                },
                {
                    input = { 0, 1, 1 },
                    expect = { 0, 1 }
                },
            }
        end
        print(inspect(kendra.compute {
            0, 1, 0
        }))
        print()
    end
end
train()

kendraManager.save()