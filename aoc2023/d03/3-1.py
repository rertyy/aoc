import re

sums = 0
symbols = ["#", "$", "%", "&", "*", "+", "-", "/", "=", "@"]
symbols_reg = re.compile("|".join(map(re.escape, symbols)))

with open("input.txt") as f:
    # inputs = f.read()
    # unique_inputs = set(inputs)
    # schematic = inputs.split("\n")

    schematic = f.readlines()
    for i, line in enumerate(schematic):
        for match in re.finditer(r"\d+", line):
            start, end = match.span()

            char_before = max(start - 1, 0)
            char_after = min(
                len(line) - 1, end + 1
            )  # this is the char after + 1 index because end exclusive

            before_index = max(0, i - 1)
            after_index = min(len(schematic) - 1, i + 1)

            line_prev = schematic[before_index][char_before:char_after]
            line_curr = schematic[i][char_before:char_after]
            line_aft = schematic[after_index][char_before:char_after]

            search_before = re.search(symbols_reg, line_prev)
            search_curr = re.search(symbols_reg, line_curr)
            search_after = re.search(symbols_reg, line_aft)

            if search_before or search_curr or search_after:
                sums += int(match.group())

    print(sums)
