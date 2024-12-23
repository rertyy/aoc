with open("input.txt") as f:
    total = 0

    for line in f:
        _, nums = line.strip().split(": ")
        winning_nums, card_nums = nums.split(" | ")
        winning_nums = winning_nums.split()
        card_nums = card_nums.split()

        score = 0
        found = False
        for num in card_nums:
            if num in winning_nums:
                if not found:
                    found = True
                    score += 1
                else:
                    score *= 2
        total += score

    print(total)
