 int power(int base, int exponent) {
    int result;
    if(base == -1) // if_1
    {
        int a = abs(exponent);
        if(a % 2 == 0) // if_2
        {
            return 1;
        }
        else // else_2
        {
            return -1;
        }  
        // endif_2      
    }
    else // else_1
    {
        if(exponent < 0 && base != 1) // if_3
        //(exponent >= 0 || base == 1)'
        { 
            return 0;
        }
        else  // else_3, base != -1, exponent >= 0  
        {
            result = 1;
            int a = base;
            for(int i = 0; i < exponent; i++)
            {
                result *= base;
            }
            return result;
        }
        // endif_3
    }
    // endif_1
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
        int base = *(test++);
        int exponent = *(test++);
        if (base == 0 && exponent <= 0)
            valid = 0;
        else
            result = power(base, exponent);
        *(answer++) = valid;
        *(answer++) = result;
    }
    return 0;
}

// (base == 0 && exponent <= 0) = (base != 0 || exponent > 0)'