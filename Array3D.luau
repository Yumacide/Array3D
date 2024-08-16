--!native
--!strict
local Array3D = {}
Array3D.__index = Array3D

export type Array3D<T> = {
	Array: { T },
	XMax: number,
	YMax: number,
	ZMax: number,

	new: (xMax: number, yMax: number, zMax: number, defaultValue: T?) -> Array3D<T>,
	Get: (self: Array3D<T>, x: number, y: number, z: number) -> T,
	Set: (self: Array3D<T>, x: number, y: number, z: number, value: T) -> (),
	To3D: (self: Array3D<T>, i: number) -> (number, number, number),
	To1D: (self: Array3D<T>, x: number, y: number, z: number) -> number,
}

function Array3D.new<T>(xMax: number, yMax: number, zMax: number, defaultValue: T?): Array3D<T>
	local array = table.create(xMax * yMax * zMax, defaultValue)
	return setmetatable({
		XMax = xMax,
		YMax = yMax,
		ZMax = zMax,
		Array = array,
	}, Array3D) :: any
end

function Array3D.Get<T>(self: Array3D<T>, x: number, y: number, z: number): T?
	if x < 1 or y < 1 or z < 1 or x > self.XMax or y > self.YMax or z > self.ZMax then
		warn(`Array3D:Get({x}, {y}, {z}): Index out of bounds`)
		return nil
	end
	return self.Array[self:To1D(x, y, z)]
end

function Array3D.Set<T>(self: Array3D<T>, x: number, y: number, z: number, value: T)
	if x < 1 or y < 1 or z < 1 or x > self.XMax or y > self.YMax or z > self.ZMax then
		warn(`Array3D:Set({x}, {y}, {z}, {value}): Index out of bounds`)
		return
	end
	self.Array[self:To1D(x, y, z)] = value
end

function Array3D.To3D<T>(self: Array3D<T>, i: number): (number, number, number)
	local z = math.floor((i - 1) / (self.XMax * self.YMax)) + 1
	i -= (z - 1) * self.XMax * self.YMax
	local y = math.floor((i - 1) / self.XMax) + 1
	local x = (i - 1) % self.XMax + 1
	return x, y, z
end

function Array3D.To1D<T>(self: Array3D<T>, x: number, y: number, z: number)
	return ((z - 1) * self.XMax * self.YMax) + ((y - 1) * self.XMax) + x
end

return Array3D
