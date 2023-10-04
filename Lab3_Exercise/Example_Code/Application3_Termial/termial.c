int termial(int n) {
    if (n == 1) return 1;
    return n + termial(n-1);
}

int main() {
    int n = 10;
    int result = termial(n);
    return 0;
}