import re

with open("1/input.txt") as f:
    sums = 0
    for line in f:
        nums = re.findall(r"\d", line)
        sums += int("".join(nums[0] + nums[-1]))
    print(sums)
