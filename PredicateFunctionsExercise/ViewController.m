//
//  ViewController.m
//  PredicateFunctionsExercise
//
//  Created by James Alan Bush on 3/12/22.
//

#import "ViewController.h"
@import simd;

typedef int (^boolean_expression)(void);
typedef int (^guarded_boolean_expression)(void);
typedef int (^ const (*guarded_boolean_expression_t))(void);
typedef int (^(^conditional_boolean_expression)(guarded_boolean_expression_t))(void);
typedef int (^ const (^ const (*conditional_boolean_expression_t))(guarded_boolean_expression_t))(void);
typedef int (^predicate)(void);
typedef int (^ const (*predicate_t))(void);

static int c = 0;
static int flag = 2;
guarded_boolean_expression flag_conditional = ^ int { return flag; };


conditional_boolean_expression isEven = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() % 2 == 0; printf("\n%d %s (%d)\n", flag, (result) ? "is even"     : "is not even",     result); return result; }; };
conditional_boolean_expression isOdd  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() % 2 == 1; printf("\n%d %s (%d)\n", flag, (result) ? "is odd"      : "is not odd",      result); return result; }; };
conditional_boolean_expression isPos  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() > 0;      printf("\n%d %s (%d)\n", flag, (result) ? "is positive" : "is not positive", result); return result; }; };
conditional_boolean_expression isNeg  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() < 0;      printf("\n%d %s (%d)\n", flag, (result) ? "is negative" : "is not negative", result); return result; }; };

static void (^evaluate_predicate)(predicate_t) = ^ (predicate_t p) {
    printf("\nresult = %d (%d invocations)\n", (*p)(), c);
};

static int (^(^(^(^g)(__strong conditional_boolean_expression, __strong conditional_boolean_expression, guarded_boolean_expression_t))(int (^__strong)(conditional_boolean_expression_t, conditional_boolean_expression_t, guarded_boolean_expression_t)))(int (^__strong)(int)))(void) =
^ (conditional_boolean_expression boolean_conditional_a, conditional_boolean_expression boolean_conditional_b, guarded_boolean_expression_t guarded_conditional) {
    return ^ (int (^bitwise_operation)(conditional_boolean_expression_t, conditional_boolean_expression_t, guarded_boolean_expression_t)) {
        return ^ (int(^block)(int)) {
            return ^ (int boolean_expression) {
                return ^ int {
                    return block(boolean_expression);
                };
            }(bitwise_operation((conditional_boolean_expression_t)&boolean_conditional_a, (conditional_boolean_expression_t)&boolean_conditional_b, guarded_conditional));
        };
    };
};


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // gbe_a is set to a precalculated and stored result
    // Invoking gbe_a() merely returns the results without recalculating it -- perfect for use inside the domain of discourse
    guarded_boolean_expression gbe_a = g(isEven, isOdd, &flag_conditional)(^ int (conditional_boolean_expression_t boolean_conditional_a, conditional_boolean_expression_t boolean_conditional_b, guarded_boolean_expression_t guarded_conditional) {
        printf("\nA\t%s\n", __PRETTY_FUNCTION__);
        return ((*boolean_conditional_a)(guarded_conditional)() & (*guarded_conditional)()) && (*boolean_conditional_b)(guarded_conditional);
    })(^ int (int i) {
        printf("\nB\t%s\n", __PRETTY_FUNCTION__);
        return i;
    });
    
    guarded_boolean_expression gbe_b = g(isPos, isNeg, &flag_conditional)(^ int (conditional_boolean_expression_t boolean_conditional_a, conditional_boolean_expression_t boolean_conditional_b, guarded_boolean_expression_t guarded_conditional) {
        printf("\nC\t%s\n", __PRETTY_FUNCTION__);
        return ((*boolean_conditional_a)(guarded_conditional)() & (*guarded_conditional)()) && (*boolean_conditional_b)(guarded_conditional);
    })(^ int (int i) {
        printf("\nD\t%s\n", __PRETTY_FUNCTION__);
        return i;
    });
    
    gbe_a() & gbe_b();
    
    // Returning a variety of bitwise operations with randomly chosen operands and operators
    // to demonstrate that simd vectors can be used combining multiple bitwise operations into a single operation
//    simd_uint2 bit_vector = simd_make_uint2((gbe_a() << 0), (gbe_b() << 0));
//    simd_uint2 bit_mask   = simd_make_uint2(flag, flag);
//    simd_uint2 results    = simd_make_uint2(bit_vector & bit_mask);
//    printf("\n%d & %d == %d\t\t\t", bit_vector[0], bit_mask[0], results[0]);
//    printf("%d & %d == %d\n", bit_vector[1], bit_mask[1], results[1]);
//    results    = simd_make_uint2(bit_vector | bit_mask);
//    printf("%d | %d == %d\t\t\t", bit_vector[0], bit_mask[0], results[0]);
//    printf("%d | %d == %d\n", bit_vector[1], bit_mask[1], results[1]);
//    results    = simd_make_uint2(bit_vector ^ bit_mask);
//    printf("%d ^ %d == %d\t\t\t", bit_vector[0], bit_mask[0], results[0]);
//    printf("%d ^ %d == %d\n", bit_vector[1], bit_mask[1], results[1]);
}

@end
