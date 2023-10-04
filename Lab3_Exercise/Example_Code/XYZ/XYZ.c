int xyz(int x, int y, int z) {
    int result = x + y*2 + z*3;
    return result;
}

int main () {
    int a = 10;
    int b = 5;
    int c = 7;
    int d = xyz(a, b, c);
    int e = xyz(a, c, d);
    int f = a + d + e;
    return 0;
}