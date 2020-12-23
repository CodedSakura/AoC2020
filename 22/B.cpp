#include <iostream>
#include <queue>
#include <fstream>
#include <set>

using namespace std;

string queueRepr(queue<int> g) {
    string out;
    while (!g.empty()) {
        out += to_string(g.front()) + ", ";
        g.pop();
    }
    return out.substr(0, out.size() - 2);
}

queue<int> subQueue(queue<int> g, int from, int to) {
    queue<int> out;
    int i = 0;
    while (!g.empty() && i++ < from) g.pop();
    while (!g.empty() && i++ < to) {
        out.push(g.front());
        g.pop();
    }
    return out;
}

static queue<int> dummyQueue;
int subGame(queue<int> p1, queue<int> p2, queue<int> &winning = dummyQueue) {
    set<string> prevPlays;
    while (!p1.empty() && !p2.empty()) {
        string currPlay = queueRepr(p1) + "; " + queueRepr(p2);
        if (prevPlays.count(currPlay)) {
            winning = p1;
            return 1;
        }
        prevPlays.insert(currPlay);

        int p1p = p1.front(); p1.pop();
        int p2p = p2.front(); p2.pop();

        int winner;
        if (p1p <= p1.size() && p2p <= p2.size()) {
            winner = subGame(subQueue(p1, 0, p1p+1), subQueue(p2, 0, p2p+1));
        } else {
            winner = p1p > p2p ? 1 : 2;
        }

        if (winner == 1) {
            p1.push(p1p);
            p1.push(p2p);
        } else {
            p2.push(p2p);
            p2.push(p1p);
        }
    }
    winning = p2.empty() ? p1 : p2;
    return p2.empty() ? 1 : 2;
}

int main() {
    queue<int> p1, p2;

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

    queue<int> winner;
    subGame(p1, p2, winner);
    unsigned long c = winner.size(), score = 0;
    while (!winner.empty()) {
        score += (c--) * winner.front(); winner.pop();
    }
    cout << score << endl;
}
