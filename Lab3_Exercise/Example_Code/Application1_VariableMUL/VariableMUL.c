int mul(int multiplicand, int multiplier) {

/*  Do abs multiplication */

    // Get abs(multiplicand) & abs(multiplier)
    int a = abs(multiplicand);
    int b = abs(multiplier);
    
    // Do sorting to accelerate multiplication
    int array[2] = {a, b};
    two_sort(&array);

    // Do multiplication through successive addition
    int i = 0;
    int result = 0;
    while (i < array[0]) {
        result += array[1];
        i++;
    }

/* Append sign on the abs_result */

    // Calculate the sign of the result
    int mask_a = multiplicand >>> 31;
    int mask_b = multiplier >>> 31;
    int mask_result = mask_a ^ mask_b;

    // Accroding mask_result
    // 1. keep result positive
    // 2. Convert result to negative
    result = result ^ mask_result;
    result = result - mask_result;
    
    return result;
}