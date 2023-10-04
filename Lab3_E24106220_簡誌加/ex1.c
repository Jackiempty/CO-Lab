int div(int dividend, int divisor) { // dividend: 被除數，divisor: 除數 => dividend/divisor
    int result;
    int counter = 0;
    int a = abs(dividend);
    int b = abs(divisor);
    int mask_a = dividend >>> 31;
    int mask_b = divisor >>> 31;
    int mask_result = mask_a ^ mask_b;

    while(a >= b)
    {
        a -= b;
        counter++;
    }
    result = counter;
    result = result ^ mask_result;
    result = result - mask_result;

    return result;
}

int main() {
    int num_test = * (int *) 0x10000000;
    int *test =      (int *) 0x10000004;
    int *answer =    (int *) 0x01000000;

    for (int i = 0 ; i < num_test ; i++) {
        // test i
        int result;
        int valid = 1;
        // test{i} from memory;
        int dividend = *(test++);
        int divisor = *(test++);
        if (divisor == 0)
            valid = 0;    
        else
            result = div(dividend, divisor);
        *(answer++) = valid;
        *(answer++) = result;
    }
    return 0;
}