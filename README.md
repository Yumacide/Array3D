# Array3D

A flat 3D array implementation

## Usage

```lua
local Array3D = require(path.to.Array3D)

local grid = Array3D.new(10, 10, 10, "Hello, world!") -- Create a 10x10x10 3D array and fill it
print(grid:Get(1, 2, 3)) -- Hello, world!
grid:Set(4, 5, 6, "Goodbye, world.")
```

## Performance

#### Iterating through a 50x50x50 array and incrementing every value by 1 (native mode):

-   Flat array: 0.3248ms (3079/s)
-   Nested array: 2.0054ms (499/s)

This is an 84% difference in speed!

The `Get` and `Set` methods are marginally slower than `array[x][y][z]` in a nested array, but this is due to the overhead of calling the method, checking if the index is in bounds, and indexing the object's `XMax` and `YMax` properties.

This library is basically 5 lines of math and some sugar, so you can implement `Array3D:To1D(x, y, z)` as a local function with no checks instead:

```lua
local function to1D(x: number, y: number, z: number, xMax: number, yMax: number)
    return ((z - 1) * xMax * yMax) + ((y - 1) * xMax) + x
end

print(flatArray[to1D(1, 2, 3, 10, 10)])
```

And it becomes 20% faster than indexing a nested array! This is trivial, however, and the main benefit of using a flat array is being able to iterate through it faster.
