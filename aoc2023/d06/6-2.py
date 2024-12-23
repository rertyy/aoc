def main():
    with open("input.txt") as f:
        lines = f.readlines()
        times = lines[0].split()[1:]
        time = "".join(times)
        time = int(time)

        distances = lines[1].split()[1:]
        distance = "".join(distances)
        distance = int(distance)
        possibilities = 1

        max_time = find_max_winning(time, distance)
        min_time = find_min_winning(time, distance)

        if (
            min_time not in range(time)
            or max_time not in range(time)
            or max_time < min_time
        ):
            possibilities *= 0

        possibilities *= max_time - min_time + 1
        return possibilities


def find_min_winning(race_time: int, dist_to_beat: int) -> int:
    lo = 1
    hi = race_time - 1

    while lo < hi:
        m = lo + (hi - lo) // 2
        if is_winning_dist(m, race_time, dist_to_beat):
            hi = m
        else:
            lo = m + 1
    return lo


def find_max_winning(race_time: int, dist_to_beat: int) -> int:
    lo = 1
    hi = race_time - 1

    while lo < hi:
        m = lo + (hi - lo) // 2
        if is_winning_dist(m, race_time, dist_to_beat):
            lo = m + 1
        else:
            hi = m
    return lo - 1


def is_winning_dist(time_held: int, race_time: int, dist_to_beat: int) -> int:
    time_travelled = race_time - time_held
    speed = time_held
    distance_travelled = speed * time_travelled
    return distance_travelled > dist_to_beat


if __name__ == "__main__":
    x = main()
    print(x)
