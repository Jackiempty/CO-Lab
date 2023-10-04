int main () {
    int result = 0;
    for (int i = 0 ; i < 10 ; i++) {
        result += i;
    }
    return 0;
}


int main () {
    int result = 0;
    int i = 0;
    while (i < 10) {
        result += i;
        i++;
    }
    return 0;
}


int main () {
    int result = 0;
    int i = 0;
    do {
        result += i;
        i++;
    } while (i < 10);
    return 0;
}