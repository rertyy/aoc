use std::fs::File;
use std::io::Read;

fn read_file() -> String {
    let mut contents = String::new();
    let mut file = File::open("input.txt").expect("Could not open file");
    file.read_to_string(&mut contents).expect("Could not read file");
    // print!("{}", contents);
    contents
}

fn turn_contents_to_grid(contents: String) -> Vec<Vec<char>> {
    let mut grid: Vec<Vec<char>> = Vec::new();
    for line in contents.lines() {
        let mut row: Vec<char> = Vec::new();
        for c in line.chars() {
            row.push(c);
        }
        grid.push(row);
    }
    grid
}

fn find_starting_point(grid: &Vec<Vec<char>>) -> (usize, usize) {
    for (y, row) in grid.iter().enumerate() {
        for (x, c) in row.iter().enumerate() {
            if *c == 'S' {
                return (x, y);
            }
        }
    }
    panic!("No starting point found");
}

enum Direction {
    Up,
    Down,
    Left,
    Right,
}

fn dfs(grid: &Vec<Vec<char>>, start_x: usize, start_y: usize, start_direction: Direction) -> usize {
    let mut stack: Vec<(usize, usize, Direction)> = Vec::new();
    let mut count = 0;

    // why am I even using a stack here
    stack.push((start_x, start_y, start_direction));


    while let Some((x, y, source_direction)) = stack.pop() {
        count += 1;
        match (grid[y][x], source_direction) {
            ('F', Direction::Right) => stack.push((x, y + 1, Direction::Up)),
            ('F', Direction::Down) => stack.push((x + 1, y, Direction::Left)),
            ('J', Direction::Left) => stack.push((x, y - 1, Direction::Down)),
            ('J', Direction::Up) => stack.push((x - 1, y, Direction::Right)),
            ('L', Direction::Right) => stack.push((x, y - 1, Direction::Down)),
            ('L', Direction::Up) => stack.push((x + 1, y, Direction::Left)),
            ('7', Direction::Left) => stack.push((x, y + 1, Direction::Up)),
            ('7', Direction::Down) => stack.push((x - 1, y, Direction::Right)),
            ('-', Direction::Left) => stack.push((x + 1, y, Direction::Left)),
            ('-', Direction::Right) => stack.push((x - 1, y, Direction::Right)),
            ('|', Direction::Up) => stack.push((x, y + 1, Direction::Up)),
            ('|', Direction::Down) => stack.push((x, y - 1, Direction::Down)),
            ('S', _) => return count,
            _ => {
                println!("({}, {}), char: {}", x, y, grid[y][x]);
                panic!("Invalid character");
            }
        }
    }

    panic!("No 'S' found in the grid");
}

fn find_connectors(grid: &Vec<Vec<char>>, x: usize, y: usize) -> usize {
    let left = if x > 0 { grid[y][x - 1] } else { ' ' };
    let right = if x < grid[y].len() - 1 { grid[y][x + 1] } else { ' ' };
    let up = if y > 0 { grid[y - 1][x] } else { ' ' };
    let down = if y < grid.len() - 1 { grid[y + 1][x] } else { ' ' };

    if left == 'F' || left == 'L' || left == '-' {
        return dfs(&grid, x - 1, y, Direction::Right);
    } else if right == 'J' || right == '7' || right == '-' {
        return dfs(&grid, x + 1, y, Direction::Left);
    } else if up == 'F' || up == '7' || up == '|' {
        return dfs(&grid, x, y - 1, Direction::Down);
    } else if down == 'J' || down == 'L' || down == '|' {
        return dfs(&grid, x, y + 1, Direction::Up);
    } else {
        panic!("No connectors found")
    }
}


pub(crate) fn main() {
    let mut contents = read_file();
    contents.pop();
    let grid = turn_contents_to_grid(contents);
    let (x, y) = find_starting_point(&grid);
    println!("Starting point: ({}, {})", x, y);
    let steps_to_travel = find_connectors(&grid, x, y);
    println!("Steps to travel: {}", steps_to_travel);
    // actually I didnt handle odd even here but whatever
    let ans = steps_to_travel / 2;
    println!("Answer: {}", ans)
}