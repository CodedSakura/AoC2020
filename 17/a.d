module a;
import std.stdio;
import std.file;
import std.string;

int countNeighbours(bool[][][] grid, ulong _x, ulong _y, ulong _z) {
    int c = 0;
    foreach (z; -1 .. 2) {
        if (z+_z >= grid.length || z+_z < 0) continue;
        foreach (y; -1 .. 2) {
            if (y+_y >= grid[z+_z].length || y+_y < 0) continue;
            foreach (x; -1 .. 2) {
                if (x+_x >= grid[z+_z][y+_y].length || x+_x < 0) continue;
                if (x == y && y == z && z == 0) continue;
                if (grid[z+_z][y+_y][x+_x]) c++;
            }
        }
    }
    return c;
}

bool[][][] expandWhereNeeded(bool[][][] grid) {
    lTop: foreach (line; grid[$-1]) {
        foreach (v; line) {
            if (v) {
                grid.length++;
                grid[$-1].length = grid[0].length;
                foreach (y; 0 .. grid[0].length) {
                    grid[$-1][y].length = grid[0][0].length;
                }
                break lTop;
            }
        }
    }

    lBottom: foreach (line; grid[0]) {
        foreach (v; line) {
            if (v) {
                grid = [[]] ~ grid;
                grid[0].length = grid[1].length;
                foreach (y; 0 .. grid[1].length) {
                    grid[0][y].length = grid[1][0].length;
                }
                break lBottom;
            }
        }
    }

    lBack: foreach (plane; grid) {
        foreach (v; plane[$-1]) {
            if (v) {
                foreach (z; 0 .. grid.length) {
                    grid[z].length++;
                    grid[z][$-1].length = grid[0][0].length;
                }
                break lBack;
            }
        }
    }

    lFront: foreach (plane; grid) {
        foreach (v; plane[0]) {
            if (v) {
                foreach (z; 0 .. grid.length) {
                    grid[z] = [[]] ~ grid[z];
                    grid[z][0].length = grid[0][1].length;
                }
                break lFront;
            }
        }
    }

    lRight: foreach (plane; grid) {
        foreach (line; plane) {
            if (line[$-1]) {
                foreach (z; 0 .. grid.length) {
                    foreach (y; 0 .. grid[0].length) {
                        grid[z][y].length++;
                    }
                }
                break lRight;
            }
        }
    }

    lLeft: foreach (plane; grid) {
        foreach (line; plane) {
            if (line[0]) {
                foreach (z; 0 .. grid.length) {
                    foreach (y; 0 .. grid[0].length) {
                        grid[z][y] = [false] ~ grid[z][y];
                    }
                }
                break lLeft;
            }
        }
    }
    return grid;
}

void main(string[] args) {
    string[] lines = splitLines(readText("input.txt"));
    bool[][][] grid;
    grid.length = 1;
    grid[0].length = lines.length;
    foreach (y, line; lines) {
        grid[0][y].length = line.length;
        foreach (x, v; line) {
            grid[0][y][x] = v == '#';
        }
    }

    foreach (c; 0 .. 6) {
        grid = expandWhereNeeded(grid);
        bool[][][] newGrid;
        newGrid.length = grid.length;
        foreach (z, plane; grid) {
            newGrid[z].length = plane.length;
            foreach (y, line; plane) {
                newGrid[z][y].length = line.length;
                foreach (x, v; line) {
                    int nCount = countNeighbours(grid, x, y, z);
                    if (v) {
                        newGrid[z][y][x] = 2 <= nCount && nCount <= 3;
                    } else {
                        newGrid[z][y][x] = nCount == 3;
                    }
                }
            }
        }
        grid = newGrid;
    }

    ulong count = 0;
    foreach (plane; grid) {
        foreach (line; plane) {
            foreach (v; line) {
                count += v;
            }
        }
    }
    writeln(count);
}
