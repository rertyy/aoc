def hash(label: str) -> int:
    h = 0
    for c in label:
        h += ord(c)
        h *= 17
        h %= 256
    return h


def main():
    # making use of the fact that dictionaries are ordered in python

    boxes = [dict() for _ in range(256)]
    with open("input.txt") as f:
        steps = f.read().strip().split(",")
        for step in steps:
            if step[-1] == "-":
                label = step[:-1]
                box_num = hash(label)
                boxes[box_num].pop(label, None)
            else:
                label, focal = step.split("=")
                focal = int(focal)
                box_num = hash(label)
                boxes[box_num][label] = focal

    sums = 0
    for i in range(256):
        box = boxes[i]

        for idx, (_, focal) in enumerate(box.items()):
            sums += (i + 1) * (idx + 1) * focal
    return sums


if __name__ == "__main__":
    ans = main()
    print(ans)
