//
//  ViewController.m
//  PredicateFunctionsExercise
//
//  Created by James Alan Bush on 3/12/22.
//

#import "ViewController.h"
@import simd;

/*
 Functors invoked with an argument supplied by the caller
 */
typedef const float (^ const __strong float_blk)(const float);
float_blk b = ^ const float (const float f) {
    return f;
};

typedef const void * (^ const __strong float_blk_t)(float_blk);
float_blk_t b_ptr = ^ (float_blk b) {
    return Block_copy((const void *)CFBridgingRetain(b));
};

// There should be no external-facing return type; this is an inner block to an outer void(^)(const void *), both of which are implemented (returned) by the callee
typedef float_blk (^ const __strong functor)(const void *);
functor f = ^ (const void * float_blk_ptr) {
    return (float_blk)CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge float_blk)(float_blk_ptr)));
};

/*
 Functors invoked with an argument supplied by the callee (returns the uninvoked functor, which can be invoked with 'void' instead of the argument required by the functor)
 */

/*
 
- [ ] float (^)(void)  // callee supplies float parameter (evaluated during initialization: float(^(^))(float))(void)
- [ ] float (^)(void) // callee supplies the float parameter (evaluated during invocation: float(^(^(^))(float))(float))(void) - like a composition
- [ ] float //
^ float {
    ^ (float f) {
        return f;
    }(f);
}();
 
 */

typedef const float (^ const __strong float_to_float_blk)(const float);
float_to_float_blk fb = ^ const float (const float f) {
    return f;
};
//typedef const float(^(^ const __strong float_using_float_blk))(const float))(void);
//float_using_float_blk ffb = ^ (const float f) {
//    return ^ (const float_blk fb) {
//        return ^ (const float f) {
//            return ^ const float {
//                return fb(f);
//            };
//        };
//    }(b)(f);
//};

// Passes block with its parameter and evaluates it when invoked by the caller (lazy evaluation?)
typedef const float (^float_blk_)(void);
typedef const float_blk_ (^(^ const __strong float_using_float_blk_)(float_to_float_blk))(const float);
float_using_float_blk_ ffb_ = ^ (float_to_float_blk fb) {
    return ^ (const float(^const __strong fb)(const float)) {
        return ^ (const float f) {
            return ^ const float {
                return ^ (const float f) {
                    return f;
                }(f);
            };
        };
    }(fb);
};





//typedef const float (^(^blk_pack)(const float))(void);
//blk_pack fb = ^ (const float f_) {
//    return ^ (const blk b_) {
//        return ^ (const float f) {
//            return ^ const float {
//                return b_(f);
//            };
//        };
//    }(b)(f_);
//};


// A block that creates a blk_pack without invoking its inner blk
// (used when source provides the float parameter, but when the float parameter should be evaluated at the destination)
// (for example: when one of the state bit vectors should be read only after the block reaches the destination;
//  right now, blk_pack would use the value of a state bit vector at the time the blk_pack was created)
//typedef const float (^(^(^blk_pack_)(const float))(const float))(void);
//blk_pack_ fb = ^ (const float f_) {
//    return ^ (const blk b_) {
//        return ^ (const float f) {
//            return ^ const float {
//                return b_(f);
//            };
//        };
//    }(b)(f_); // to return only the blk ('b'), omit the second parameter and change the return block to float(float) versus float(void)
//};


//typedef const float (^f_blk)(void);
//f_blk fb = ^ (const float f) {
//    return ^ const float {
//        return f;
//    };
//}(b(UIScreen.mainScreen.scale));
//
//blk b_ = ^ blk (f_blk fb) {
//    return ^ const float (const float f) {
//        return f;
//    };
//}(fb);


//typedef const void * (^ const __strong blk_pack_t)(blk_pack);
//blk_pack_t bp_t = ^ (blk_pack bp) {
//    return Block_copy((const void *)CFBridgingRetain(bp));
//};
//
//typedef blk_pack (^ const __strong functor_pack)(const void *);
//functor_pack fp = ^ (const void * functor_pack_t) {
//    return (blk_pack)CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge blk_pack)(functor_pack_t)));
//};





// To-Do: Return a generic type and typecast in the assignment/initialization



/*
 Example of packing the parameter with the block so that the parameter can be supplied at the origin (prior to destination):
 
    const void * blk_ptr = ((__bridge const float(^ const __strong)(float))(float_blk_t(CFBridgingRelease((__bridge CFTypeRef _Nullable)(float_blk)))))((float)UIScreen.mainScreen.scale));

 Example of packing just the block so that the parameter can be supplied at its destination:
 
    typeof(float (^)(float)) float_blk_from_ptr = functor(float_blk_t((typeof(float (^)(float)))float_blk));
    float float_value = float_blk_from_ptr(UIScreen.mainScreen.scale);
    printf("\t\t%.2f", float_value);
*/

typedef int (^boolean_expression)(void);
typedef int (^guarded_boolean_expression)(void);
typedef int (^ const (*guarded_boolean_expression_t))(void);
typedef int (^(^conditional_boolean_expression)(guarded_boolean_expression_t))(void);
typedef int (^ const (^ const (*conditional_boolean_expression_t))(guarded_boolean_expression_t))(void);
typedef int (^predicate)(void);
typedef int (^ const (*predicate_t))(void);

static unsigned int c = 0;
static unsigned int flag = 1;
guarded_boolean_expression flag_conditional = ^ int { return flag; };

conditional_boolean_expression isEven = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() % 2 == 0; printf("\n%d %s (%d)\n", flag, (result) ? "is even"     : "is not even",     result); return result; }; };
conditional_boolean_expression isOdd  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() % 2 == 1; printf("\n%d %s (%d)\n", flag, (result) ? "is odd"      : "is not odd",      result); return result; }; };
conditional_boolean_expression isPos  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() > 0;      printf("\n%d %s (%d)\n", flag, (result) ? "is positive" : "is not positive", result); return result; }; };
conditional_boolean_expression isNeg  = ^ (guarded_boolean_expression_t _Nullable x) { return ^ int { int result = (*x)() < 0;      printf("\n%d %s (%d)\n", flag, (result) ? "is negative" : "is not negative", result); return result; }; };



static void (^evaluate_predicate)(unsigned int) = ^ (unsigned int index) {
    printf("%d %d", (1UL << 0 | 1UL << 1^ | 1UL << 2 | 1UL << 3), ~(1UL << 0 | 1UL << 1 | 1UL << 2 | 1UL << 3));
    bits(conditional_bool_expr((1UL << 0 | 1UL << 1 | 1UL << 2 | 1UL << 3), (1UL << 0 | 1UL << 1 | 1UL << 2 | 1UL << 3), index));
};

static conditional_boolean_expression_t (^(^(^(^g)(__strong conditional_boolean_expression, __strong conditional_boolean_expression, guarded_boolean_expression_t))
                                                  (conditional_boolean_expression_t (^__strong)(conditional_boolean_expression_t, conditional_boolean_expression_t, guarded_boolean_expression_t)))
                                                  (conditional_boolean_expression_t (^__strong)(conditional_boolean_expression_t)))(void) =
^ (conditional_boolean_expression bool_exp_a, conditional_boolean_expression bool_exp_b, guarded_boolean_expression_t guarded_conditional) {
    return ^ (conditional_boolean_expression_t (^evaluate_boolean_expression)(conditional_boolean_expression_t, conditional_boolean_expression_t, guarded_boolean_expression_t)) {
        return ^ (conditional_boolean_expression_t(^ _Nullable functor)(conditional_boolean_expression_t)) {
            return ^ (conditional_boolean_expression_t boolean_expression) {
                return ^ conditional_boolean_expression_t {
                    return functor(boolean_expression);
                };
            }(evaluate_boolean_expression((conditional_boolean_expression_t)&bool_exp_a, (conditional_boolean_expression_t)&bool_exp_b, guarded_conditional));
        };
    };
};


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 16; i++) evaluate_predicate(i);
    
    typedef const float (^ const __strong float_exp)(const float);
    float_exp f_exp = ^ const float (const float f) {
        return f;
    };
    float fe_f = f_exp(1.0);
    
    typedef const float (^ const __strong float_eval)(void);
    float_eval f_eval = ^ (float_exp fb) {
        return ^ (const float f) {
            return ^ (const float f) {
                return ^ (const float f) {
                    return ^ const float {
                        return fb(f);
                    };
                }(f);
            }(f);
        };
    }(f_exp)(1.0);
    float_eval * f_eval_t = &f_eval;
    float f_eval_f = (*f_eval_t)();
    
    

//    blk functor_f = f(b_ptr(b));
//    float float_value = functor_f(UIScreen.mainScreen.scale);
//    printf("\t\t%.2f", float_value);
//
//    printf("\nfloat_blk_literal == %.1f\n", ^ (const float f) {
//        return ^ const float {
//            return f;
//        };
//    }(b(UIScreen.mainScreen.scale))());
//
//    float f = ^ (const float f) {
//        return ^ const float {
//            return f;
//        };
//    }(b(UIScreen.mainScreen.scale))();
//
//    typedef const float (^f_blk)(void);
//    f_blk fb = ^ (const float f) {
//        return ^ const float {
//            return f;
//        };
//    }(b(UIScreen.mainScreen.scale));
//
//    blk b_ = ^ blk (f_blk fb) {
//        return ^ const float (const float f) {
//            return f;
//        };
//    }(fb);


//    const void * blk_ptr = (const void *)(b_ptr(CFBridgingRelease((__bridge CFTypeRef _Nullable)(b))))(1.0);//((float)UIScreen.mainScreen.scale);

    
    // PARAMETER(S)
        // (float_blk_t((const typeof(const float (^)(const float)))float_blk));
    // RETURN
    //     ((__bridge const float(^ const __strong)(float))(float_blk_t(CFBridgingRelease((__bridge CFTypeRef _Nullable)(float_blk)))))((float)UIScreen.mainScreen.scale);

    // PARAMETER(S)
//         (float_blk_t((const typeof(const float (^)(const float)))float_blk));
    // RETURN (Example of packing the parameter with the block so that the parameter can be supplied at the origin (prior to destination)
//    printf("\t\t%.2f\n", ((__bridge const float(^ const __strong)(float))(float_blk_t(CFBridgingRelease((__bridge CFTypeRef _Nullable)(float_blk)))))((float)UIScreen.mainScreen.scale));
    
    // RETURN = PARAMETER(S)
    // Example of packing just the block so that the parameter can be supplied at its destination
//    typeof(float (^)(float)) float_blk_from_ptr = functor(float_blk_t((typeof(float (^)(float)))float_blk));
//    float float_value = float_blk_from_ptr(UIScreen.mainScreen.scale);
//    printf("\t\t%.2f", float_value);

//    conditional_boolean_expression_t gbe_x = g(isEven, isOdd, &flag_conditional)
//    (^conditional_boolean_expression_t (conditional_boolean_expression_t bool_exp_a, conditional_boolean_expression_t bool_exp_b, guarded_boolean_expression_t guarded_conditional) {
//        return bool_exp_a;
//    })
//    (^ conditional_boolean_expression_t (conditional_boolean_expression_t b) {
//        return ^ conditional_boolean_expression_t {
//            return b;
//        };
//    });
    
    
//    conditional_boolean_expression_t gbe_a = g(isEven, isOdd, &flag_conditional)
//    (^ conditional_boolean_expression_t (conditional_boolean_expression_t bool_exp_a, conditional_boolean_expression_t bool_exp_b, guarded_boolean_expression_t guarded_conditional) {
//        return ((*bool_exp_a)(guarded_conditional)() & (*guarded_conditional)()) && (*bool_exp_b)(guarded_conditional);
//    })(^ conditional_boolean_expression_t (conditional_boolean_expression_t boolean_evaluation) {
////        return Block_copy((conditional_boolean_expression_t)CFBridgingRetain(^ conditional_boolean_expression_t {
////            printf("\t\tgbe_a() == %d\n", boolean_evaluation);
////            return boolean_evaluation;
////        }));
//    });
    
//    guarded_boolean_expression gbe_b = g(isPos, isNeg, &flag_conditional)(^ int (conditional_boolean_expression_t bool_exp_a, conditional_boolean_expression_t bool_exp_b, guarded_boolean_expression_t guarded_conditional) {
//        return ((*bool_exp_a)(guarded_conditional)() & (*guarded_conditional)()) && (*bool_exp_b)(guarded_conditional);
//    })(^ int (int i) {
//        printf("\t\tgbe_b()\n");
//        return i;
//    });
    
//    printf("gbe_a() == %d\n", gbe_a());
//    printf("gbe_b() == %d\n", gbe_b());
//    printf("gbe_a() & gbe_b() == %d\n", gbe_a() & gbe_b());
    
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
