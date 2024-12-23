import re


def check_num(schematic: list[list[str]], y: int, x: int, direction: int = 0) -> str:
    if x < 0 or y < 0 or y > len(schematic) - 1 or x > len(schematic[0]) - 1:
        return ""
    if schematic[y][x].isdigit():
        match direction:
            case 0:  # both
                return (
                    check_num(schematic, y, x - 1, -1)
                    + schematic[y][x]
                    + check_num(schematic, y, x + 1, 1)
                )
            case -1:  # left only
                return check_num(schematic, y, x - 1, -1) + schematic[y][x]
            case 1:  # right only
                return schematic[y][x] + check_num(schematic, y, x + 1, 1)
    return ""


def sum_ratios():
    with open("input.txt") as f:
        schematic = [[i for i in x if i != "\n"] for x in f]
        sums = 0
        for i, line in enumerate(schematic):
            for j, char in enumerate(line):
                if char == "*":
                    numbers = set()
                    for dx in (-1, 0, 1):
                        for dy in (-1, 0, 1):
                            if dx == dy == 0:
                                continue
                            num = check_num(schematic, i + dy, j + dx)
                            if num.isdigit():
                                numbers.add(int(num))
                    if len(numbers) == 2:
                        ratio = 1
                        for number in numbers:
                            ratio *= number
                        sums += ratio
        return sums


if __name__ == "__main__":
    ans = sum_ratios()
    print(ans)


def failed():
    # why does this not work...
    with open("input.txt") as f:
        sums = 0
        gear_matches = []
        num_matches = []

        schematic = f.readlines()

        for line in schematic:
            gear_matches.append(list(re.finditer(r"\*", line)))
            num_matches.append(list(re.finditer(r"\d+", line)))

        for i, line in enumerate(schematic):
            if i == 20:
                pass
            for gear in gear_matches[i]:
                count = 0
                gear_ratio = 1

                gear_start, gear_end = gear.span()

                stride = 3
                if i - 1 >= 0:
                    x = schematic[i - 1][
                        max(0, gear_start - stride) : min(
                            len(schematic) - 1, gear_end + stride
                        )
                    ]
                y = schematic[i][
                    max(0, gear_start - stride) : min(
                        len(schematic) - 1, gear_end + stride
                    )
                ]
                if i + 1 < len(schematic):
                    z = schematic[i + 1][
                        max(0, gear_start - stride) : min(
                            len(schematic) - 1, gear_end + stride
                        )
                    ]

                for j in range(i - 1, i + 2):
                    if i < 0 or i > len(schematic) - 1:
                        continue
                    if count > 2:
                        break
                    for num in num_matches[j]:
                        if count > 2:
                            break
                        num_start, num_end = num.span()

                        if num_start > gear_end or count > 2:
                            break

                        if (
                            gear_start - 1 in range(num_start, num_end + 1)
                            or gear_start in range(num_start, num_end + 1)
                            or gear_start + 1 in range(num_start, num_end + 1)
                        ):
                            count += 1
                            gear_ratio *= int(num.group())
                if count == 2:
                    sums += gear_ratio

        print(sums)

        # 79_839_267 is too low
