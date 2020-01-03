/*
 * File: model_for_FPGA_w_C_testing_target.c
 *
 * Code generated for Simulink model 'model_for_FPGA_w_C_testing_target'.
 *
 * Model version                  : 1.165
 * Simulink Coder version         : 9.2 (R2019b) 18-Jul-2019
 * C/C++ source code generated on : Fri Jan  3 11:13:29 2020
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ASIC/FPGA->ASIC/FPGA
 * Emulation hardware selection:
 *    Differs from embedded hardware (Custom Processor->MATLAB Host Computer)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "model_for_FPGA_w_C_testing_target.h"
#include "model_for_FPGA_w_C_testing_target_private.h"

/* Exported block signals */
int8_T U1;                             /* '<Root>/In0' */
uint8_T U2;                            /* '<Root>/In1' */
int16_T U3;                            /* '<Root>/In2' */
int32_T Y1;                            /* '<Root>/Product' */

/* Real-time model */
RT_MODEL rtM_;
RT_MODEL *const rtM = &rtM_;

/* Model step function */
void model_for_FPGA_w_C_testing_target_step(void)
{
  int32_T tmp;
  int16_T tmp_0;

  /* Sum: '<Root>/Add' incorporates:
   *  Inport: '<Root>/In0'
   *  Inport: '<Root>/In1'
   */
  tmp_0 = (int16_T)(((U1 & 2048U) != 0U ? U1 | -2048 : U1 & 2047) + (int16_T)(U2
    << 2));

  /* Product: '<Root>/Product' incorporates:
   *  Inport: '<Root>/In2'
   *  Sum: '<Root>/Add'
   */
  tmp = ((tmp_0 & 2048U) != 0U ? tmp_0 | -2048 : tmp_0 & 2047) * U3;
  Y1 = (tmp & 134217728U) != 0U ? tmp | -134217728 : tmp & 134217727;
}

/* Model initialize function */
void model_for_FPGA_w_C_testing_target_initialize(void)
{
  /* (no initialization code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
