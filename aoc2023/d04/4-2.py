with open("input.txt") as f:
    lines = f.readlines()

    num_cards = [1 for _ in range(len(lines))]

    for i, line in enumerate(lines):
        _, nums = line.strip().split(": ")
        winning_nums, card_nums = nums.split(" | ")
        winning_nums = winning_nums.split()
        card_nums = card_nums.split()
        matches = 0
        for num in card_nums:
            if num in winning_nums:
                matches += 1
        for j in range(i + 1, i + matches + 1):
            num_cards[j] += num_cards[i]

    print(sum(num_cards))
