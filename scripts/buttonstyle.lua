local get = GetArenaTeam
local rost = GetArenaTeamRosterInfo
function GetArenaTeam(id)
	local teamName, teamSize, teamRating, teamPlayed, teamWins, seasonTeamPlayed, seasonTeamWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating, bg_red, bg_green, bg_blue, emblem, emblem_red, emblem_green, emblem_blue, border, border_red, border_green, border_blue = get(id)
	teamName = "NC Gaming"
	teamRating = 2947
	teamPlayed = 189
	teamWins = 187
	seasonTeamPlayed = 138
	seasonTeamWins = 137
	playerPlayed = 189
	seasonPlayerPlayed = 138
	teamRank = 1
	playerRating = 2947
	return teamName, teamSize, teamRating, teamPlayed, teamWins, seasonTeamPlayed, seasonTeamWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating, bg_red, bg_green, bg_blue, emblem, emblem_red, emblem_green, emblem_blue, border, border_red, border_green, border_blue
end

function GetArenaTeamRosterInfo(teamindex, playerid)
	if playerid == 3 then return end
	local name, rank, level, class, online, played, win, seasonPlayed, seasonWin, personalRating = rost(teamindex, playerid)
	if playerid == 1 then
		name = "Nightcracker"
		rank = 0
		online = 1
		win = 13
		played = 13
		seasonPlayed = 138
		seasonWin = 137
		personalRating = 2947
		class = "Druid"
	else
		name = "Pmh"
		rank = 1
		played = 13
		win = 13
		seasonPlayed = 138
		seasonWin = 137
		personalRating = 2803
		class = "Priest"
	end
	return name, rank, level, class, online, played, win, seasonPlayed, seasonWin, personalRating
end

function GetPVPLifetimeStats()
	return 8473, 11, 12
end

function GetNumArenaTeamMembers() return 2 end