module b;
import std.stdio;
import std.file;
import std.string;

int countNeighbours(bool[][][][] grid, ulong _x, ulong _y, ulong _z, ulong _t) {
    int c = 0;
    foreach (t; -1 .. 2) {
        if (t+_t >= grid.length || t+_t < 0) continue ;
        foreach (z; -1 .. 2) {
            if (z+_z >= grid[t+_t].length || z+_z < 0) continue ;
            foreach (y; -1 .. 2) {
                if (y+_y >= grid[t+_t][z+_z].length || y+_y < 0) continue ;
                foreach (x; -1 .. 2) {
                    if (x+_x >= grid[t+_t][z+_z][y+_y].length || x+_x < 0) continue ;
                    if (x == y && y == z && z == t && t == 0) continue ;
                    if (grid[t+_t][z+_z][y+_y][x+_x]) c++;
                }
            }
        }
    }
    return c;
}

bool[][][][] expandWhereNeeded(bool[][][][] hyperspace) {
    lForward: foreach (plane; hyperspace[$-1]) {
        foreach (line; plane) {
            foreach (v; line) {
                if (v) {
                    hyperspace.length++;
                    hyperspace[$-1].length = hyperspace[0].length;
                    foreach (z; 0 .. hyperspace[0].length) {
                        hyperspace[$-1][z].length = hyperspace[0][0].length;
                        foreach (y; 0 .. hyperspace[0][0].length) {
                            hyperspace[$-1][z][y].length = hyperspace[0][0][0].length;
                        }
                    }
                    break lForward;
                }
            }
        }
    }

    lBackward: foreach (plane; hyperspace[0]) {
        foreach (line; plane) {
            foreach (v; line) {
                if (v) {
                    hyperspace = [[]] ~ hyperspace;
                    hyperspace[0].length = hyperspace[1].length;
                    foreach (z; 0 .. hyperspace[1].length) {
                        hyperspace[0][z].length = hyperspace[1][0].length;
                        foreach (y; 0 .. hyperspace[1][0].length) {
                            hyperspace[0][z][y].length = hyperspace[1][0][0].length;
                        }
                    }
                    break lBackward;
                }
            }
        }
    }

    lTop: foreach (space; hyperspace) {
        foreach (line; space[$-1]) {
            foreach (v; line) {
                if (v) {
                    foreach (t; 0 .. hyperspace.length) {
                        hyperspace[t].length++;
                        hyperspace[t][$-1].length = hyperspace[0][0].length;
                        foreach (y; 0 .. hyperspace[0][0].length) {
                            hyperspace[t][$-1][y].length = hyperspace[0][0][0].length;
                        }
                    }
                    break lTop;
                }
            }
        }
    }

    lBottom: foreach (space; hyperspace) {
        foreach (line; space[0]) {
            foreach (v; line) {
                if (v) {
                    foreach (t; 0 .. hyperspace.length) {
                        hyperspace[t] = [[]] ~ hyperspace[t];
                        hyperspace[t][0].length = hyperspace[0][1].length;
                        foreach (y; 0 .. hyperspace[0][1].length) {
                            hyperspace[t][0][y].length = hyperspace[0][1][0].length;
                        }
                    }
                    break lBottom;
                }
            }
        }
    }

    lBack: foreach(space; hyperspace) {
        foreach (plane; space) {
            foreach (v; plane[$-1]) {
                if (v) {
                    foreach (t; 0 .. hyperspace.length) {
                        foreach (z; 0 .. hyperspace[0].length) {
                            hyperspace[t][z].length++;
                            hyperspace[t][z][$-1].length = hyperspace[0][0][0].length;
                        }
                    }
                    break lBack;
                }
            }
        }
    }

    lFront: foreach(space; hyperspace) {
        foreach (plane; space) {
            foreach (v; plane[0]) {
                if (v) {
                    foreach (t; 0 .. hyperspace.length) {
                        foreach (z; 0 .. hyperspace[0].length) {
                            hyperspace[t][z] = [[]] ~ hyperspace[t][z];
                            hyperspace[t][z][0].length = hyperspace[0][0][1].length;
                        }
                    }
                    break lFront;
                }
            }
        }
    }

    lRight: foreach (space; hyperspace) {
        foreach (plane; space) {
            foreach (line; plane) {
                if (line[$-1]) {
                    foreach (t; 0 .. hyperspace.length) {
                        foreach (z; 0 .. hyperspace[0].length) {
                            foreach (y; 0 .. hyperspace[0][0].length) {
                                hyperspace[t][z][y].length++;
                            }
                        }
                    }
                    break lRight;
                }
            }
        }
    }

    lLeft: foreach (space; hyperspace) {
        foreach (plane; space) {
            foreach (line; plane) {
                if (line[0]) {
                    foreach (t; 0 .. hyperspace.length) {
                        foreach (z; 0 .. hyperspace[0].length) {
                            foreach (y; 0 .. hyperspace[0][0].length) {
                                hyperspace[t][z][y] = [ false] ~ hyperspace[t][z][y];
                            }
                        }
                    }
                    break lLeft;
                }
            }
        }
    }
    return hyperspace;
}

void main(string[] args) {
    string[] lines = splitLines(readText("input.txt"));
    bool[][][][] hyperspace;
    hyperspace.length = 1;
    hyperspace[0].length = 1;
    hyperspace[0][0].length = lines.length;
    foreach (y, line; lines) {
        hyperspace[0][0][y].length = line.length;
        foreach (x, v; line) {
            hyperspace[0][0][y][x] = v == '#';
        }
    }

    foreach (c; 0 .. 6) {
        hyperspace = expandWhereNeeded(hyperspace);
        bool[][][][] newHyperspace;
        newHyperspace.length = hyperspace.length;
        foreach (t, space; hyperspace) {
            newHyperspace[t].length = space.length;
            foreach (z, plane; space) {
                newHyperspace[t][z].length = plane.length;
                foreach (y, line; plane) {
                    newHyperspace[t][z][y].length = line.length;
                    foreach (x, v; line) {
                        int nCount = countNeighbours(hyperspace, x, y, z, t);
                        if (v) {
                            newHyperspace[t][z][y][x] = 2 <= nCount && nCount <= 3;
                        } else {
                            newHyperspace[t][z][y][x] = nCount == 3;
                        }
                    }
                }
            }
        }
        hyperspace = newHyperspace;
    }

    ulong count = 0;
    foreach (space; hyperspace) {
        foreach (plane; space) {
            foreach (line; plane) {
                foreach (v; line) {
                    count += v;
                }
            }
        }
    }
    writeln(count);
}
