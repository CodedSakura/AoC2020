using System;
using System.Collections.Generic;
using System.Linq;

namespace A {
    internal static class A {
        private static string Reverse(string s) {
            var charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }

        public static void Main() {
            var text = System.IO.File.ReadAllText(@"input.txt");
            var tiles = text.Trim().Split(new[] {"\n\n"}, StringSplitOptions.None);

            var edges = new Dictionary<string, int>();

            foreach (var tile in tiles) {
                var tData = tile.Split(new [] {'\n'}, 2);
                var id = int.Parse(tData[0].Substring(5, 4));
                var img = tData[1].Split('\n');
                var imgEdges = new[] {
                    img[0], img[img.Length - 1], // top, bottom
                    "", "" // left, right
                };
                foreach (var imgLine in img) {
                    imgEdges[2] += imgLine[0];
                    imgEdges[3] += imgLine[imgLine.Length - 1];
                }
                foreach (var imgEdge in imgEdges) {
                    if (edges.ContainsKey(imgEdge)) {
                        edges.Remove(imgEdge);
                    } else if (edges.ContainsKey(Reverse(imgEdge))) {
                        edges.Remove(Reverse(imgEdge));
                    } else {
                        edges.Add(imgEdge, id);
                    }
                }
            }

            Console.WriteLine(
                edges.Values.ToList()
                    .GroupBy(x => x)
                    .Where(x => x.Skip(1).Any())
                    .Select(x => x.Key)
                    .Aggregate((long) 1, (acc, x) => acc * x));
        }
    }
}