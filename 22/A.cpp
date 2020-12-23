#include <iostream>
#include <queue>
#include <fstream>

using namespace std;

int main() {
    queue<int> p1;
    queue<int> p2;

    fstream inputfile;
    inputfile.open("input.txt", ios::in);
    string line;
    bool p2init = false;
    while (getline(inputfile, line)) {
        if (line.empty()) {
            p2init = true;
            continue;
        }
        if (line.length() > 3) continue;
        (p2init ? p2 : p1).push(stoi(line));
    }
    inputfile.close();

    int rounds = 0;
    while (!p1.empty() && !p2.empty()) {
        int p1p = p1.front(); p1.pop();
        int p2p = p2.front(); p2.pop();
        if (p1p > p2p) {
            p1.push(p1p);
            p1.push(p2p);
        } else {
            p2.push(p2p);
            p2.push(p1p);
        }
        rounds++;
    }
    queue<int> winner = p1.empty() ? p2 : p1;
    int c = winner.size(), score = 0;
    while (!winner.empty()) {
        score += (c--) * winner.front(); winner.pop();
    }
    cout << score << endl;
}
