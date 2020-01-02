/*
 * File: mul_32x32_keep32msb_longlong_no.h
 *
 * Code generated for Simulink model 'mul_32x32_keep32msb_longlong_no'.
 *
 * Model version                  : 1.158
 * Simulink Coder version         : 9.2 (R2019b) 18-Jul-2019
 * C/C++ source code generated on : Thu Jan  2 15:18:39 2020
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_mul_32x32_keep32msb_longlong_no_h_
#define RTW_HEADER_mul_32x32_keep32msb_longlong_no_h_
#ifndef mul_32x32_keep32msb_longlong_no_COMMON_INCLUDES_
# define mul_32x32_keep32msb_longlong_no_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                    /* mul_32x32_keep32msb_longlong_no_COMMON_INCLUDES_ */

#include "mul_32x32_keep32msb_longlong_no_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Real-time Model Data Structure */
struct tag_RTM {
  const char_T * volatile errorStatus;
};

/*
 * Exported Global Signals
 *
 * Note: Exported global signals are block signals with an exported global
 * storage class designation.  Code generation will declare the memory for
 * these signals and export their symbols.
 *
 */
extern int32_T U1;                     /* '<Root>/In0' */
extern int32_T U2;                     /* '<Root>/In1' */
extern int32_T Y1;                     /* '<Root>/Product' */

/* Model entry point functions */
extern void mul_32x32_keep32msb_longlong_no_initialize(void);
extern void mul_32x32_keep32msb_longlong_no_step(void);

/* Real-time Model object */
extern RT_MODEL *const rtM;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'mul_32x32_keep32msb_longlong_no'
 */
#endif                       /* RTW_HEADER_mul_32x32_keep32msb_longlong_no_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
