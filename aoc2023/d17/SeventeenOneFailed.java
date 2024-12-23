import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class Main {
    public static int[][] readGraph(String filename) {
        ArrayList<int[]> intArrList = new ArrayList<>();

        try {
            FileReader fileReader = new FileReader(filename);
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            String line = bufferedReader.readLine();
            while (line != null) {
                int[] arr = line.chars()
                        .map(Character::getNumericValue)
                        .toArray();
                intArrList.add(arr);
                line = bufferedReader.readLine();
            }
            bufferedReader.close();
            return intArrList.toArray(new int[0][]);
        } catch (FileNotFoundException ex) {
            System.out.println("Unable to open file '" + filename + "'");
        } catch (IOException ex) {
            System.out.println("Error reading file '" + filename + "'");
        }
        return null;
    }

    public record State(int x, int y, int dx, int dy, int consecutiveStraight, int distTo, int h, State parent) {
//        @Override
//        public boolean equals(Object obj) {
//            if (obj == null) {
//                return false;
//            }
//            if (obj instanceof State o) {
//                return o.x == this.x && o.y == this.y && o.dx == this.dx && o.dy == this.dy;
//            }
//            return false;
//        }
//
//        @Override
//        public int hashCode() {
//            return (x * 103 + y * 1013 + dx * 50777 + dy * 100003) % 21221 ;
//        }
    }

    public record Coord(int x, int y, int dx, int dy) {
    }

    public static int manhattan(int x, int y, int n, int m) {
        return n + m - x - y - 2;
    }


    public static int astar(int[][] heatmap) {
        int n = heatmap[0].length;
        int m = heatmap.length;
        State init = new State(0, 0, 1, 0, 0, 0, n + m - 2, null);
        State init2 = new State(0, 0, 0, 1, 0, 0, n + m - 2, null);
        PriorityQueue<State> pq = new PriorityQueue<>(Comparator.comparingInt(o -> o.h));
        pq.add(init);
        pq.add(init2);
        HashMap<Coord, Integer> distanceFromStart = new HashMap<>();
        distanceFromStart.put(new Coord(0, 0, 1, 0), 0);
        distanceFromStart.put(new Coord(0, 0, 0, 1), 0);
        HashSet<State> answers = new HashSet<>();

        while (!pq.isEmpty()) {
            State curr = pq.poll();
//            System.out.println(curr);

//            if (curr.x == heatmap.length - 1 && curr.y == heatmap[0].length - 1) {
//                return curr.distTo;
//            }

            if (curr.x == n - 1 && curr.y == m - 1) {
                answers.add(curr);
            }

            for (int[] delta : new int[][]{{curr.dx, curr.dy}, {-curr.dy, curr.dx}, {curr.dy, -curr.dx}}) {
                int newX = curr.x + delta[0];
                int newY = curr.y + delta[1];

                if (newY < 0 || newY >= heatmap.length || newX < 0 || newX >= heatmap[0].length) {
                    continue;
                }

                Coord currCoord = new Coord(curr.x, curr.y, curr.dx, curr.dy);
                Coord newCoord = new Coord(newX, newY, delta[0], delta[1]);

                int oldDist = distanceFromStart.computeIfAbsent(newCoord, x -> 999_999_999);
                int newDist = distanceFromStart.get(currCoord) + heatmap[newY][newX];
                if (oldDist > newDist) {


                    if (curr.dx == delta[0] && curr.consecutiveStraight != 2) {
                        State elem = new State(newX, newY, delta[0], delta[1],
                                curr.consecutiveStraight + 1,
                                newDist,
                                newDist + manhattan(newX, newY, n, m),
                                curr);
                        pq.add(elem); // supposed to be update if present
                        Integer x = distanceFromStart.replace(newCoord, newDist);
                        assert x != null;

                    } else if (curr.dx != delta[0]) {
                        State elem = new State(newX, newY, delta[0], delta[1],
                                0,
                                newDist,
                                newDist + manhattan(newX, newY, n, m),
                                curr);
                        pq.add(elem); // supposed to be update if present
                        Integer x = distanceFromStart.replace(newCoord, newDist);
                        assert x != null;

                    }


                }
            }


        }

        return answers
                .stream()
                .map(o -> printParents(o, heatmap))
                .min(Comparator.comparingInt(o -> o.distTo))
                .orElseThrow()
                .distTo;
    }

    public static State printParents(State s, int[][] heatmap) {
        System.out.println("Parent");
        State curr = s;
        while (curr != null) {
            System.out.printf("%d ", heatmap[curr.y][curr.x]);
            System.out.println(curr);
            curr = curr.parent;

        }
        return s;

    }

    public static void main(String[] args) {
        int[][] heatmap = readGraph("src/input.txt");
        assert heatmap != null;
//        System.out.println(Arrays.deepToString(heatmap));
        int ans = astar(heatmap);

        System.out.println(ans);
        // 668 is the ans
    }
}