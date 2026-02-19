print("GameId:", game.GameId)
print("PlaceId:", game.PlaceId)


local ALLOWED_GAME_ID = 358276974 -- Universe/GameId

task.wait(1) -- wichtig! manchmal ist GameId sonst noch 0

print("Aktuelle GameId:", game.GameId)

if game.GameId == ALLOWED_GAME_ID then
  



else
    warn("❌ Apoc 2")
end
