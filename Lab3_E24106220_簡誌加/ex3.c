int factorial(int n) {
    int result;
    if(n < 0)
    {
        result = -1;
    }
    else if(n == 0)
    {
        result = 1;
    }
    else
    {
        result = n * factorial(n-1);
    }   
    return result;   
}

int main() {
    int num_test = * (int *) 0x10000000;
    int *test =      (int *) 0x10000004;
    int *answer =    (int *) 0x01000000;

    for (int i = 0 ; i < num_test ; i++) {
        // test i
        // test{i} from memory;
        int n = *(test++);
        int result = factorial(n);
        *(answer++) = result;
    }
    return 0;
}