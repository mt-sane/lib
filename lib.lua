--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also: COPYING.txt
--]]

local copyTypes = { number=true, string=true, boolean=true, table=true }

-- Returns a (values) copy of the table.
-- 
-- o    -> The object to copy.
-- seen <> Nil or a table that will be filled with references to all tables that are refernced by 
--         o or one of it's decendants.
--         If preinitalized with table refernces, those tables will not be copied.
-- copy <> Nil or the table to copy the values to.
--
-- Only value types and tables are copied.
--
function Lib.CopyValues(o, seen, copy) 
	if type(o) ~= 'table' then return o end
	if seen and seen[o] then return seen[o] end

	local copy = copy or {}
	local s = seen or {}
	s[o] = copy

	for k, v in pairs(o) do 
		if copyTypes[type(k)] and copyTypes[type(v)] then
			copy[k] = Lib.CopyValues(v, s) 
		end
	end
	
	return copy
end

-- Random number generator

Lib.Random = {}

-- Returns a random number generator.
--
-- seed -> nil or a seed value to initialize the random number generator.
--
-- The returned table will contain the following functions:
-- Next       -> returns the next 'random' integer value >= -2147483648 and <= 2147483647.
-- NextReal   -> returns the next 'random' floating point value >= 0.0 < 1.0 .
--
-- Please note that the functions are indexed via the . notation.
-- Examples:
-- r = Lib.Random.New(1)
-- print(r.NextReal()) --> 0.51272447093221
--
function Lib.Random.New(seed)
	seed = seed or os.time()
	local pcgr = PcgRandom(seed)
	return {
		Next     = function() return pcgr:next() end,
		NextReal = function() return (pcgr:next() + 2147483648) / 4294967295 end,
	}
end

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
	w = { n = "d", s = "u", e = "e", w = "w", u = "n", d = "s", c = "c", },
	-- Turn (pitch) up
	s = { n = "u", s = "d", e = "e", w = "w", u = "s", d = "s", c = "c", },
	
	-- Turn (yaw) left
	a = { n = "w", s = "e", e = "n", w = "s", u = "u", d = "d", c = "c", },
	-- Turn (yaw) right
	d = { n = "e", s = "w", e = "s", w = "n", u = "u", d = "d", c = "c", },
	
	-- Turn (roll) left
	q = { n = "n", s = "s", e = "u", w = "d", u = "w", d = "e", c = "c", },
	e = { n = "n", s = "s", e = "d", w = "u", u = "e", d = "w", c = "c", },
}
for k,v in pairs(makeTurns) do
	local t = {}
	Lib.Cardinal.Turns[k] = t
	for k1,v1 in pairs(v) do
		local newDir     = Lib.Cardinal.C[v1]
		local currentDir = Lib.Cardinal.C[k1]
		local hash       = minetest.hash_node_position(currentDir)
		
		t[k1  ] = newDir
		t[hash] = newDir
	end
end

-- String stuff

-- Appends all characters of a string to a table.
--
function Lib.StringToTable(s, t)
	t = t or {}
	if type(s) == "string" then
		for i=1, #s do t[#t+1] = s:sub(i,i) end
	end
	return t
end


