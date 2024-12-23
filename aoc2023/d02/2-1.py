import re

max_cols = {"red": 12, "green": 13, "blue": 14}

sums = 0

with open("input.txt") as f:
    for line in f:
        game, sets = line.split(": ")
        game_id = int(game[5:])
        valid = True
        for colour in ("red", "green", "blue"):
            colours = re.findall(rf"\d+ {colour}", sets)
            for num_colour in colours:
                num, _ = num_colour.split(" ")
                if int(num) > max_cols[colour]:
                    valid = False
                    break
        if valid:
            sums += game_id

    print(sums)
