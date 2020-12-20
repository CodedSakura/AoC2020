using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace B {
    internal static class B {
        private static string Reverse(string s) {
            var charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }

        private static string[] FlipH(string[] img) {
            img = (string[]) img.Clone();
            Array.Reverse(img);
            return img;
        }

        private static string[] FlipV(string[] img) {
            img = (string[]) img.Clone();
            return img.ToList().Select(Reverse).ToArray();
        }

        private static string[] Transpose(string[] img) {
            img = (string[]) img.Clone();
            var res = new string[img[0].Length];
            foreach (var t in img)
                for (var j = 0; j < t.Length; j++)
                    res[j] += t[j];
            return res;
        }

        private static string[] Rotate(string[] img, int rot) {
            img = (string[]) img.Clone();
            switch (rot) {
                case 2: // 180
                    return FlipH(FlipV(img));
                case 1: // 90R
                    return FlipV(Transpose(img));
                case 3: // 270R
                    return Transpose(FlipV(img));
            }
            return img;
        }

        private static string[] Edges(string[] img) {
            img = (string[]) img.Clone();
            var imgEdges = new[] {
                img[0], img[img.Length - 1], // top, bottom
                "", "" // left, right
            };
            var rightSide = img[img.Length - 1].Length - 1;
            foreach (var imgLine in img) {
                imgEdges[2] += imgLine[0];
                imgEdges[3] += imgLine[rightSide];
            }

            return imgEdges;
        }

        public static void Main() {
            var text = System.IO.File.ReadAllText(@"input.txt");
            var tiles = text.Trim().Split(new[] {"\n\n"}, StringSplitOptions.None);

            var images = new Dictionary<int, string[]>();
            var edges = new Dictionary<string, int>(); // data, (id, edge)
            var relations = new Dictionary<int, List<int>>();

            foreach (var tile in tiles) {
                var tData = tile.Split(new [] {'\n'}, 2);
                var id = int.Parse(tData[0].Substring(5, 4));
                var img = tData[1].Split('\n');
                images.Add(id, img);
                relations.Add(id, new List<int>());

                foreach (var t in Edges(img)) {
                    if (edges.ContainsKey(t) || edges.ContainsKey(Reverse(t))) {
                        int oId;
                        if (edges.ContainsKey(t)) {
                            oId = edges[t];
                            edges.Remove(t);
                        } else {
                            oId = edges[Reverse(t)];
                            edges.Remove(Reverse(t));
                        }
                        relations[oId].Add(id);
                        relations[id].Add(oId);
                    } else {
                        edges.Add(t, id);
                    }
                }
            }

            string[] grid;
            var attempt = 0;
            var startingId = relations.Where(kv => kv.Value.Count == 2).ToArray()[0].Key;
            
            do {
                var currentId = startingId;
                var rowId = currentId;
                grid = Rotate(images[currentId], attempt % 4);
                if (attempt >= 8) grid = FlipH(grid);
                else if (attempt >= 4) grid = FlipV(grid);
                var tileW = grid[0].Length;
                var tileH = grid.Length;
                var vOffset = 0;
                var tRelations = relations.ToDictionary(e => e.Key, e => e.Value.ToList());

                while (true) {
                    var rEdge = Edges(grid.Skip(vOffset).ToArray())[3];
                    var rEdgeR = Reverse(rEdge);
                    var found = false;
                    foreach (var r in tRelations[currentId]) {
                        var cEdges = Edges(images[r]);
                        if (!cEdges.Contains(rEdge) && !cEdges.Contains(rEdgeR)) continue;

                        var reverse = cEdges.Contains(rEdgeR);
                        var cEdgeIndex = Array.IndexOf(cEdges, reverse ? rEdgeR : rEdge);
                        var cData = Rotate(images[r], new[] {3, 1, 0, 2}[cEdgeIndex]);
                        if (Edges(cData).Contains(rEdgeR)) cData = FlipH(cData);
                        for (var i = 0; i < cData.Length; i++) {
                            grid[i + vOffset] += cData[i];
                        }

                        found = true;
                        tRelations[currentId].Remove(r);
                        tRelations[r].Remove(currentId);
                        currentId = r;
                        break;
                    }

                    if (found) continue;
                    // line done, time for next row

                    var bEdge = Edges(grid.Skip(vOffset).ToArray())[1].Substring(0, tileW);
                    var bEdgeR = Reverse(bEdge);
                    vOffset = grid.Length;
                    foreach (var r in tRelations[rowId]) {
                        var cEdges = Edges(images[r]);
                        if (!cEdges.Contains(bEdge) && !cEdges.Contains(bEdgeR)) continue;

                        var reverse = cEdges.Contains(bEdgeR);
                        var cEdgeIndex = Array.IndexOf(cEdges, reverse ? bEdgeR : bEdge);
                        var cData = Rotate(images[r], new[] {0, 2, 1, 3}[cEdgeIndex]);
                        if (Edges(cData).Contains(bEdgeR)) cData = FlipV(cData);
                        var newGrid = new string[vOffset + cData.Length];
                        grid.CopyTo(newGrid, 0);
                        for (var i = 0; i < cData.Length; i++) {
                            newGrid[i + vOffset] = cData[i];
                        }

                        grid = newGrid;

                        found = true;
                        tRelations[rowId].Remove(r);
                        tRelations[r].Remove(rowId);
                        currentId = r;
                        rowId = r;
                        break;
                    }

                    if (!found) break;
                }
                
                // cleanup
                var cleanGrid = new string[grid.Length / tileH * (tileH - 2)];
                var cgI = 0;
                for (var i = 0; i < grid.Length; i++) {
                    if (i % tileH == 0 || i % tileH == tileH - 1) continue;
                    cleanGrid[cgI] = "";
                    for (var j = 0; j < grid[i].Length; j++) {
                        if (j % tileW == 0 || j % tileW == tileW - 1) continue;
                        cleanGrid[cgI] += grid[i][j];
                    }
                    cgI++;
                }
                grid = cleanGrid;

                if (grid.Length == grid[0].Length && grid.Length != images[startingId].Length) {
                    break;
                }

                attempt++;
            } while (attempt < 12);
            
            var monster = new[] {
                "                  # ",
                "#    ##    ##    ###",
                " #  #  #  #  #  #   "};
            
            
            for (var i = 0; i < 4; i++) {
                var tGrid = Rotate(grid, i);
                for (var j = 0; j < 3; j++) {
                    tGrid = j == 0 ? tGrid : j == 1 ? FlipH(tGrid) : FlipV(tGrid);

                    var monsterCount = 0;
                    
                    for (var y = 0; y < tGrid.Length - 2; y++) {
                        for (var x = 0; x < tGrid[y].Length - monster[0].Length; x++) {
                            var match = true;
                            for (var y1 = 0; y1 < monster.Length && match; y1++) {
                                for (var x1 = 0; x1 < monster[y1].Length && match; x1++) {
                                    if (monster[y1][x1] == ' ') continue;
                                    if (monster[y1][x1] != tGrid[y + y1][x + x1]) match = false;
                                }
                            }

                            if (match) monsterCount++;
                            for (var y1 = 0; y1 < monster.Length && match; y1++) {
                                for (var x1 = 0; x1 < monster[y1].Length && match; x1++) {
                                    if (monster[y1][x1] == ' ') continue;
                                    tGrid[y + y1] = tGrid[y + y1].Remove(x + x1, 1).Insert(x + x1, "O");
                                }
                            }
                        }
                    }

                    if (monsterCount <= 0) continue;
                    Console.WriteLine(string.Join("\n", tGrid).Count(x => x == '#'));
                    return;
                }
            }
        }
    }
}