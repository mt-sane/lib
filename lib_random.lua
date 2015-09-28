--[[ 
Lib - A collection of useful stuff.

Copyright © 2015 Sane (https://forum.minetest.net/memberlist.php?mode=viewprofile&u=10658)
License:  GNU Affero General Public License version 3 (AGPLv3) (http://www.gnu.org/licenses/agpl-3.0.html)
          See also: COPYING.txt
--]]

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
