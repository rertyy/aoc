import re

nums_dict = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}

with open("1/input.txt") as f:
    sums = 0
    for line in f:
        one = re.search(
            r"[1-9]|one|two|three|four|five|six|seven|eight|nine", line
        ).group()
        two = re.search(
            r"[1-9]|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin", line[::-1]
        ).group()[::-1]
        one = nums_dict[one] if one in nums_dict else one
        two = nums_dict[two] if two in nums_dict else two
        sums += int(one + two)
    print(sums)
