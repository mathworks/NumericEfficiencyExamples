/*
 * File: model_for_FPGA_w_C_testing_target.h
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

#ifndef RTW_HEADER_model_for_FPGA_w_C_testing_target_h_
#define RTW_HEADER_model_for_FPGA_w_C_testing_target_h_
#ifndef model_for_FPGA_w_C_testing_target_COMMON_INCLUDES_
# define model_for_FPGA_w_C_testing_target_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                  /* model_for_FPGA_w_C_testing_target_COMMON_INCLUDES_ */

#include "model_for_FPGA_w_C_testing_target_types.h"

/* Shared type includes */
#include "multiword_types.h"

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
extern int8_T U1;                      /* '<Root>/In0' */
extern uint8_T U2;                     /* '<Root>/In1' */
extern int16_T U3;                     /* '<Root>/In2' */
extern int32_T Y1;                     /* '<Root>/Product' */

/* Model entry point functions */
extern void model_for_FPGA_w_C_testing_target_initialize(void);
extern void model_for_FPGA_w_C_testing_target_step(void);

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
 * '<Root>' : 'model_for_FPGA_w_C_testing_target'
 */
#endif                     /* RTW_HEADER_model_for_FPGA_w_C_testing_target_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
