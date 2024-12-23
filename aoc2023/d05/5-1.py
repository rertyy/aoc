"""
50 98 2
dst src range
if seed-to-soil map, means
soil seed range

so seed 98 maps to soil 50
seed 99 maps to soil 51
"""


class Map:
    def __init__(self, map_from: str, map_to: str):
        self.src = map_from
        self.dest = map_to
        self.ranges: list[
            tuple[range, range]
        ] = []  # probably better data structures than a list

    def add(self, src_range: range, dest_range: range) -> None:
        self.ranges.append((src_range, dest_range))


def form_maps(lines: list[str]) -> dict[str, Map]:
    maps: dict[str, Map] = dict()
    current_map: Map | None = None

    # a to b map
    for i in range(1, len(lines)):
        line = lines[i].strip()

        if not line:
            # empty lines
            continue

        elif "map" in line:
            src_to_dest, _ = line.split()
            src, _, dest = src_to_dest.split("-")
            maps[src] = Map(src, dest)
            current_map = maps[src]

        else:
            # numbers
            dest_start, src_start, range_length = line.split()
            dest_start = int(dest_start)
            src_start = int(src_start)
            range_length = int(range_length)
            current_map.add(
                range(src_start, src_start + range_length),
                range(dest_start, dest_start + range_length),
            )
    for m in maps.values():
        print(m.src, m.ranges)

    return maps


def main(file_path):
    with open(file_path) as f:
        lines = f.readlines()
        _, seeds = lines[0].split(": ")
        seeds = seeds.split()
        locations = []

        maps = form_maps(lines)

        for seed in seeds:
            evaluating = int(seed)
            curr_map = maps["seed"]
            while True:
                for src_range, dest_range in curr_map.ranges:
                    if evaluating in src_range:
                        diff = evaluating - src_range.start
                        evaluating = dest_range.start + diff
                        break

                if curr_map.dest == "location":
                    break

                curr_map = maps[curr_map.dest]

            locations.append(evaluating)

    return min(locations)


if __name__ == "__main__":
    min_val = main("input.txt")
    print(min_val)
