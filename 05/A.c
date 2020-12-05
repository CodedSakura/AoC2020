#include <stdio.h>

int main() {
    FILE *fp = fopen("input.txt", "r");
    char *line;
    size_t len = 0;

    int max = 0;

    while (getline(&line, &len, fp) != -1) {
        int id = 0;
        char c;
        for (int i = 0; i < 10; ++i) {
            c = line[i];
            id |= c == (i < 7 ? 'B' : 'R');
            id <<= i != 9;
        }
        if (id > max) max = id;
    }
    printf("%d\n", max);

    fclose(fp);
    return 0;
}