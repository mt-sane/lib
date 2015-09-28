--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also: COPYING.txt
--]]

-- Cardinal vector stuff

Lib.Cardinal = {}

-- Cardinal vectors: north, south, east, west, up, down, center
Lib.Cardinal.C = {
	n = vector.new( 0, 0, 1),
	s = vector.new( 0, 0,-1),
	e = vector.new( 1, 0, 0),
	w = vector.new(-1, 0, 0),
	u = vector.new( 0, 1, 0),
	d = vector.new( 0,-1, 0),
	c = vector.new( 0, 0, 0),
}

-- Cardinal keys to hashes
Lib.Cardinal.CK2H = {}
for k,v in pairs(Lib.Cardinal.C) do
	local t = Lib.Cardinal.CK2H
	t[k] = minetest.hash_node_position(v)
end

-- Facedir to Cardinal key
Lib.Cardinal.F2CK = {}
Lib.Cardinal.F2CK[0] = "n"
Lib.Cardinal.F2CK[2] = "s"
Lib.Cardinal.F2CK[1] = "e"
Lib.Cardinal.F2CK[3] = "w"

-- Cardinal key to Facedir
Lib.Cardinal.CK2F = { n = 0, s = 2, e = 1, w = 3, }

-- Cardinal hashes key to Facedir
Lib.Cardinal.CH2F = { }
for f = 0, 3 do
	Lib.Cardinal.CH2F[Lib.Cardinal.F2CK[f]] = f
end

-- 90° rotations of the cardinal positions
--
-- First index selects the turning direction. Think of the turning direction as the movement keys
-- in computer games: 
-- w = pitch down, s = pitch up.
-- a = yaw  left,  d = yaw right.
-- q = roll left,  e = roll right.
--
-- Second index selects the current cardinal direction. This can either be the cardinal direction
-- shortcut also used in Lib.Cardinal.C or the direction vector's hash.
--
-- Examples:
-- Lib.Cardinal.Turns.a.n                                                 -> {x=-1,y=0,z=0} -- west
-- Lib.Cardinal.Turns["a"][14074393083904]                                -> {x=-1,y=0,z=0} -- west
-- Lib.Cardinal.Turns["a"][minetest.hash_node_position(Lib.Cardinal.C.n)] -> {x=-1,y=0,z=0} -- west
--
Lib.Cardinal.Turns = {}

local makeTurns = {
	-- Turn (pitch) down
	w = {
		F = function (angle, ...)
			return Lib.Mat.RXF(angle, ...)
		end,
		c = { n = "d", s = "u", e = "e", w = "w", u = "n", d = "s", c = "c", },
	}
	-- Turn (pitch) up
	s = {
		F = function (angle, ...)
			return Lib.Mat.RXF(-angle, ...)
		end,
		c = { n = "u", s = "d", e = "e", w = "w", u = "s", d = "s", c = "c", },
	},
	-- Turn (yaw) left
	a = {
		F = function (angle, ...)
			return Lib.Mat.RYF(-angle, ...)
		end,
		c = { n = "w", s = "e", e = "n", w = "s", u = "u", d = "d", c = "c", },
	}
	-- Turn (yaw) right
	d = {
		F = function (angle, ...)
			return Lib.Mat.RYF(angle, ...)
		end,
		c = { n = "e", s = "w", e = "s", w = "n", u = "u", d = "d", c = "c", },
	},
	-- Turn (roll) left
	q = {
		F = function (angle, ...)
			return Lib.Mat.RZF(angle, ...)
		end,
		c = { n = "n", s = "s", e = "u", w = "d", u = "w", d = "e", c = "c", },
	},
	-- Turn (roll) right
	e = {
		F = function (angle, ...)
			return Lib.Mat.RZF(-angle, ...)
		end,
		c = { n = "n", s = "s", e = "d", w = "u", u = "e", d = "w", c = "c", },
	},
}
for k,v in pairs(makeTurns) do
	local t = { F = v.F }
	Lib.Cardinal.Turns[k] = t

	for k1,v1 in pairs(v.c) do
		local newDir     = Lib.Cardinal.C[v1]
		local currentDir = Lib.Cardinal.C[k1]
		local hash       = minetest.hash_node_position(currentDir)
		
		t[k1     ] = newDir
		t["k"..k1] = v1
		t[hash   ] = newDir
	end
end
