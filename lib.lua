--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also: COPYING.txt
--]]

-- Diverse stuff

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

-- String stuff

-- Appends all characters of a string to a table.
function Lib.StringToTable(s, t)
	t = t or {}
	if type(s) == "string" then
		for i=1, #s do t[#t+1] = s:sub(i,i) end
	end
	return t
end


