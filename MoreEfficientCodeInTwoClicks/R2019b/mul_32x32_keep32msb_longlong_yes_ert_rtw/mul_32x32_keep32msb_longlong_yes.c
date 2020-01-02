/*
 * File: mul_32x32_keep32msb_longlong_yes.c
 *
 * Code generated for Simulink model 'mul_32x32_keep32msb_longlong_yes'.
 *
 * Model version                  : 1.158
 * Simulink Coder version         : 9.2 (R2019b) 18-Jul-2019
 * C/C++ source code generated on : Thu Jan  2 15:22:59 2020
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "mul_32x32_keep32msb_longlong_yes.h"
#include "mul_32x32_keep32msb_longlong_yes_private.h"

/* Exported block signals */
int32_T U1;                            /* '<Root>/In0' */
int32_T U2;                            /* '<Root>/In1' */
int32_T Y1;                            /* '<Root>/Product' */

/* Real-time model */
RT_MODEL rtM_;
RT_MODEL *const rtM = &rtM_;

/* Model step function */
void mul_32x32_keep32msb_longlong_yes_step(void)
{
  Y1 = (int32_T)(((int64_T)U1 * U2) >> 32);
}

/* Model initialize function */
void mul_32x32_keep32msb_longlong_yes_initialize(void)
{
  /* (no initialization code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
