//
//  ViewController.h
//  PredicateFunctionsExercise
//
//  Created by Xcode Developer on 3/12/22.
//

#import <UIKit/UIKit.h>
@import simd;

// TO-DO: The arrays should be external to their closing blocks for vector operations
static const unsigned int (^guarded_bool_expr)(const unsigned int) = ^ (const unsigned int boolean_operation_index) {
    return ^ (const unsigned int boolean_operation[16]) {
        return boolean_operation[boolean_operation_index];
    }((const unsigned int[16]){
        (0 << 0 | 0 << 1 | 0 << 2 | 0 << 3), (0 << 0 | 0 << 1 | 0 << 2 | 1 << 3), (0 << 0 | 0 << 1 | 1 << 2 | 0 << 3), (0 << 0 | 0 << 1 | 1 << 2 | 1 << 3),
        (0 << 0 | 1 << 1 | 0 << 2 | 0 << 3), (0 << 0 | 1 << 1 | 0 << 2 | 1 << 3), (0 << 0 | 1 << 1 | 1 << 2 | 0 << 3), (0 << 0 | 1 << 1 | 1 << 2 | 1 << 3),
        (1 << 0 | 0 << 1 | 0 << 2 | 0 << 3), (1 << 0 | 0 << 1 | 0 << 2 | 1 << 3), (1 << 0 | 0 << 1 | 1 << 2 | 0 << 3), (1 << 0 | 0 << 1 | 1 << 2 | 1 << 3),
        (1 << 0 | 1 << 1 | 0 << 2 | 0 << 3), (1 << 0 | 1 << 1 | 0 << 2 | 1 << 3), (1 << 0 | 1 << 1 | 1 << 2 | 0 << 3), (1 << 0 | 1 << 1 | 1 << 2 | 1 << 3)});
};

static const unsigned int (^conditional_bool_expr)(const unsigned int, const unsigned int, const unsigned int) = ^ (const unsigned int bool_exp_a, const unsigned int bool_exp_b, const unsigned int boolean_operation_index) {
    return ((const unsigned int[16]){
        bool_exp_a & ~bool_exp_a,
        ~bool_exp_a & ~bool_exp_b,
        ~bool_exp_a & bool_exp_b,
        ~bool_exp_a,
        bool_exp_a & ~bool_exp_b,
        ~bool_exp_b,
        (bool_exp_a | bool_exp_b) & ~(bool_exp_a & bool_exp_b),
        ~(bool_exp_a & bool_exp_b),
        (bool_exp_a & bool_exp_b),
        (bool_exp_a & bool_exp_b) | (~(bool_exp_a) & ~(bool_exp_b)),
        bool_exp_b,
        bool_exp_a | ~(bool_exp_b),
        bool_exp_a | bool_exp_b,
        bool_exp_a | ~(bool_exp_a)})[boolean_operation_index];
};

void mask_on_position(unsigned int * byte, unsigned char position) {
    * byte = (* byte) | (1 << position);
}

void mask_off_position(unsigned int * byte, unsigned char position) {
    unsigned long mask = 1 << position;
    * byte = (* byte) & ~mask;
}

unsigned long modifyBit(unsigned int byte, unsigned char position, unsigned int state) {
    unsigned long mask = 1 << position;
    return ( byte & ~mask) | (-state & mask);
}

int flipBit(unsigned int byte, unsigned char position) {
    int mask = 1 << position;
    return  byte ^ mask;
}

unsigned char isBitSet(unsigned char * bit, unsigned char position) {
    *bit >>= position;
    return !!(*bit & 1);
}

int extractBit(unsigned int byte, unsigned int length, unsigned int position) {
    return (((1 << length) - 1) & (byte >> (position - 1)));
}

// To-Do:
//        (typeof(byte_expression) takes typeof(filter) returning typeof(byte_evaluation)) takes (typeof(bit_expression) returns typeof(bit_evaluation))
//        (typeof(byte_operation) -------------------------------------------------------)       (typeof(bit_operation) -------------------------------)
//        (typeof(bit_vector_operation) ---------------------------------------------------------------------------------------------------------------)

typedef unsigned char bit;
    typedef typeof(bit) bit_state;
    typedef typeof(bit) bit_mask;
typedef typeof(bit *) byte;
    typedef typeof(byte) byte_state;
    typedef typeof(byte) byte_mask;

typedef typeof(size_t) operation_parameter;
    typedef typeof(operation_parameter) length;
    typedef typeof(operation_parameter) position;

typedef typeof(bit(^)(bit, bit_mask, bit_state, position, length)) expression_evaluator;
typedef typeof(bit(^)(expression_evaluator)) evaluation;
typedef typeof(expression_evaluator(^)(byte, byte_mask, byte_state, position, length)) expression;
typedef typeof(evaluation(^)(expression)) evaluate_expression;


// byte --->
//           expression ---> expression_evaluator
//                                                ---> evaluate_expression ---> evaluation
//                                                                                         ---> bit
// bit(evaluation(evaluate_expression(expression(byte))))

typedef typeof(bit(^)(void)) bit_evaluator;
typedef typeof(bit(^)(bit_evaluator)) bit_evaluation;
typedef typeof(bit_evaluation(^)(bit_evaluator)) bit_expression;
    typedef typeof(bit_evaluation(^)(bit_expression)) bit_operation;

typedef typeof(byte(^)(unsigned char * bit, unsigned char position, unsigned char length, unsigned char * mask)) byte_expression; // accumulates typeof(bit_evaluation)
typedef typeof(byte(^)(byte_expression)) byte_evaluation;
// typeof(byte_operation) accumulates typeof(bit) from typeof(byte), starting at typeof(position) and ending with typeof(length) of typeof(byte)
    typedef typeof(byte(^)(byte_expression)) byte_operation;

typedef typeof(unsigned int(^)() bit_vector_operation;

unsigned int (^(^bit_vector_operation)(unsigned int, unsigned char, unsigned char, unsigned int))(unsigned char *, unsigned char, unsigned char, unsigned char *)  = ^ (unsigned int byte, unsigned char position, unsigned char length, unsigned int byte_mask) {
    return ^ (unsigned int(^bit_expression)(unsigned char *, unsigned char, unsigned char, unsigned char *)) {
        return (^ (unsigned int(^byte_operation)(void)) {
            /*
             Map (iterator) and Reduce (Accumulator) filter space
             */
            
            for (unsigned char index   = position; index < length; index++) {
                unsigned char bit      = (unsigned char)(byte >> index);
                unsigned char bit_mask = (unsigned char)(byte_mask >> index);
                printf("%u", bit_operation(&bit, index, length, &bit_mask));
            }; printf("\n");
            

            return ^ (unsigned int(^byte_operation)(void)) {
                return byte_operation;
            };
        }(^ unsigned int {
            return guarded_bool_expr(4);
        })(^ unsigned int {
            return guarded_bool_expr(4);
        }));
    }(^ unsigned int (unsigned char * bit, unsigned char position, unsigned char length, unsigned char * mask) { // bit_expression
        return (unsigned int)(isBitSet(bit, position)); // typeof(bit_evaluation)
    });
};


@interface ViewController : UIViewController


@end

