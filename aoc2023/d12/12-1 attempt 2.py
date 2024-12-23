import functools


def main():
    with open("input.txt") as f:
        sums = 0
        for line in f:
            line = line.strip()
            springs, groups = line.split(" ")
            groups = list(int(x) for x in groups.split(","))
            sums += check_valid(springs, groups)

        return sums


def check_valid(springs: list[str], groups: list[int]) -> int:
    for s in springs:
        pass


if __name__ == "__main__":
    ans = main()
    print(ans)
    # 44302 too high
    # 2472 is wrong
    # ans supposed to be 7653
