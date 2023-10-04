int main() {
    int a = 0;
    int b = 10;
    
    if (b >= 10) {
        a = 5;
        b = 3;
    }
    else {
        a = 3;
        b = 3;
    }

    if (a == b) {
        a = 6;
        b = 11;
    }
    else {
        a = 4;
        b = 2;
    }

    if (b < 10) {
        a = 10;
        b = 5;
    }
    else {
        a = 9;
        b = 7;
    }
    
    return 0;
}