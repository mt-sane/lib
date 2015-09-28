--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also COPYING.txt .
--]]

Lib = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname).."/"
dofile(modpath.."lib.lua")
dofile(modpath.."lib_random.lua")
dofile(modpath.."lib_cardinal.lua")

-----------------
