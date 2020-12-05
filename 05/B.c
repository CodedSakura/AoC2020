#include <stdio.h>

int main() {
    FILE *fp = fopen("input.txt", "r");
    char *line;
    size_t len = 0;

    unsigned long found[30];
    for (int i = 0; i < 30; ++i) {found[i] = 0;}

    while (getline(&line, &len, fp) != -1) {
        int id = 0;
        char c;
        for (int i = 0; i < 10; ++i) {
            c = line[i];
            id |= c == (i < 7 ? 'B' : 'R');
            id <<= i != 9;
        }
        found[id / 32] ^= 1 << (id % 32);
    }

    for (int i = 1; i < 29; ++i) {
        if (found[i] != -1) {
            for (int j = 0; j < 32; ++j) {
                if (~found[i] == 1 << j) {
                    printf("%d", 32*i + j);
                    break;
                }
            }
        }
    }

    fclose(fp);
    return 0;
}