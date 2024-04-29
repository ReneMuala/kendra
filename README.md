![kendra](images/image.jfif)

# Kendra

An artificial intelligence framework by Landia

## Getting started

1. Install Luajit

2. Add the following lines to main.lua
```Lua
Network = require "network"
-- Create an kendra 
local kendra = Network {
    Perceptron(3, Functions.Sigmoid),
    Perceptron(3, Functions.Sigmoid),
    Perceptron(2, Functions.Sigmoid),
}
--- Predict 1,2,3 and return the results
kendra.compute({1,2,3})
```
3. Run with luajit.exe main.lua (Windows) or luajit main.lua (*nix)

4. See examples to understand about training strategies to make your kendra model smarter!

## Resources

- https://youtu.be/p1-FiWjThs8
- https://youtu.be/IruMm7mPDdM
