import re

sums = 0

with open("input.txt") as f:
    for line in f:
        _, sets = line.split(": ")
        power = 1
        for colour in ("red", "green", "blue"):
            colours = re.findall(rf"\d+ {colour}", sets)
            min_required = 0
            for num_colour in colours:
                num, _ = num_colour.split(" ")
                min_required = max(min_required, int(num))
            power *= min_required
        sums += power

    print(sums)
