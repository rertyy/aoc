import functools


def main():
    with open("input.txt") as f:
        sums = 0
        for line in f:
            line = line.strip()
            springs, groups = line.split(" ")
            groups = tuple(int(x) for x in groups.split(","))
            springs = tuple(springs)
            sums += check_valid(springs, ".", 0, groups)
            sums += check_valid(springs, "#", 0, groups)

        return sums


@functools.cache
def check_valid(
    springs: tuple[str], curr_ele: str, index: int, groups: tuple[int, ...]
):
    # print(f"Checking: curr_ele={curr_ele}, index={index}, groups={groups}, prev_ele={prev_ele}")

    if index >= len(springs) and groups:
        return 0
    elif index >= len(springs) and not groups:
        return 1
    elif (springs[index] == "#" and curr_ele == ".") or (
        springs[index] == "." and curr_ele == "#"
    ):
        return 0
    elif not groups:
        return 1 if "#" not in springs[index:] else 0
    elif groups[0] == 0:
        return check_valid(springs, ".", index + 1, groups[1:])
    elif groups[0] > 0:
        new_groups = list(groups)
        new_groups[0] -= 1
        if curr_ele == "#":
            return check_valid(springs, "#", index + 1, tuple(new_groups))
        elif curr_ele == ".":
            return check_valid(
                springs, "#", index + 1, tuple(new_groups)
            ) + check_valid(springs, ".", index + 1, groups)


if __name__ == "__main__":
    ans = main()
    print(ans)
    # 44302 too high
    # 2472 is wrong
    # ans supposed to be 7653
