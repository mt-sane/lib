--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also: COPYING.txt
--]]

Lib.Mat = {}

-- Matrix calculations

-- Multiplies a 3 x 3 matrix with a vector.
function Lib.Mat.M33V3(m33, v3)
	local m1, m2 , m3 = m[1], m[2], m[3]
	local x, y, z = v3.x, v3.y, v3.z 
	return
		m1[1]*x + m1[2]*y + m1[3]*z,
		m2[1]*x + m2[2]*y + m2[3]*z,
		m3[1]*x + m3[2]*y + m3[3]*z
end

-- Rotation matrices

-- Returns the 3d rotation matrix
-- for a rotation about the x axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RXM(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end

	local r = math.rad(angle)
	local s = math.sin(r)
	local c = math.cos(r)
	local m = {
		{ 1, 0,  0 },
		{ 0, c, -s },
		{ 0, s,  c },
	}

	if cash then cash[angle] = m end
	return m
end

-- Returns the 3d rotation matrix
-- for a rotation about the y axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RYM(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end

	local r = math.rad(angle)
	local s = math.sin(r)
	local c = math.cos(r)
	local m = {
		{  c, 0, s },
		{  0, 1, 0 },
		{ -s, 0, c },
	}

	if cash then cash[angle] = m end
	return m
end

-- Returns the 3d rotation matrix
-- for a rotation about the z axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RZM(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end

	local r = math.rad(angle)
	local s = math.sin(r)
	local c = math.cos(r)
	local m = {
		{ c, -s, 0 },
		{ s,  c, 0 },
		{ 0,  0, 1 },
	}

	if cash then cash[angle] = m end
	return m
end

-- Rotation functions

-- Rotates v about any axis 0°
function Lib.Mat.R0(v) 
	return v.x, v.y, v.z
end

-- Rotates v about x 90° or -270°.
function Lib.Mat.RX90(v)
	return v.x, -v.z, v.y
end

-- Rotates v about x 180° or -180°.
function Lib.Mat.RX180(v)
	return v.x, -v.y, -v.z
end

-- Rotates v about x 270° or -90°.
function Lib.Mat.RX270(v)
	return v.x, v.z, -v.y
end

-- Rotates v about y 90° or -270°.
function Lib.Mat.RY90(v)
	return v.z, v.y, -v.x
end

-- Rotates v about y 180° or -180°.
function Lib.Mat.RY180(v)
	return -v.x, v.y, -v.z
end

-- Rotates v about y 270° or -90°.
function Lib.Mat.RY270(v)
	return -v.z, v.y, v.x
end

-- Rotates v about z 90° or -270°.
function Lib.Mat.RZ90(v)
	return -v.y, v.x, v.z
end

-- Rotates v about z 180° or -180°.
function Lib.Mat.RZ180(v)
	return -v.x, -v.y, v.z
end

-- Rotates v about z 270° or -90°.
function Lib.Mat.RZ270(v)
	return v.y, -v.x, v.z
end


-- Returns the 3d rotation function
-- for a rotation about the x axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RXF(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end
	
	local f
	if angle == 0 then
		f = Lib.Mat.R0
	elseif angle == 90 then
		f = Lib.Mat.RX90
	elseif angle == 180 then
		f = Lib.Mat.RX180
	elseif angle == 270 then
		f = Lib.Mat.RX270
	else
		local r = math.rad(angle)
		local s = math.sin(r)
		local c = math.cos(r)
		f = function(v)
			local y, z = v.y, v.z
			return 
				v.x,
				c * y + -s * z,
				s * y +  c * z
		end
	end
	
	if cash then cash[angle] = f end
	return f
end

-- Returns the 3d rotation function
-- for a rotation about the y axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RYF(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end

	local f
	if angle == 0 then
		f = Lib.Mat.R0
	elseif angle == 90 then
		f = Lib.Mat.RY90
	elseif angle == 180 then
		f = Lib.Mat.RY180
	elseif angle == 270 then
		f = Lib.Mat.RY270
	else
		local r = math.rad(angle)
		local s = math.sin(r)
		local c = math.cos(r)
		f = function(v)
			local x, z = v.x, v.z
			return 
				c * x + s * z,
				v.y,
				-s * x + c * z
		end
	end

	if cash then cash[angle] = f end
	return f
end

-- Returns the 3d rotation function
-- for a rotation about the z axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RZF(angle, cash)
	angle = angle % 360
	if angle < 0 then angle = 360 - angle end
	local cashed_item = cash and cash[angle]
	if cashed_item then return cashed_item end

	local f
	if angle == 0 then
		f = Lib.Mat.R0
	elseif angle == 90 then
		f = Lib.Mat.RZ90
	elseif angle == 180 then
		f = Lib.Mat.RZ180
	elseif angle == 270 then
		f = Lib.Mat.RZ270
	else
		local r = math.rad(angle)
		local s = math.sin(r)
		local c = math.cos(r)
		f = function(v)
			local x, y = v.x, v.y
			return 
				c * x + -s * y,
				s * x +  c * y,
				v.z
		end
	end

	if cash then cash[angle] = f end
	return f
end

-- Rotates v 
-- about the x axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RX(v, angle, cash)
	return vector.new(Lib.Mat.RXF(angle, cash)(v))
end

-- Rotates v 
-- about the y axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RY(v, angle, ...)
	return vector.new(Lib.Mat.RYF(angle, cash)(v))
end

-- Rotates v 
-- about the z axis 
-- using the given angle 
-- in degrees.
-- Optionally a cash can be used.
function Lib.Mat.RZ(v, angle, ...)
	return vector.new(Lib.Mat.RZF(angle, cash)(v))
end


