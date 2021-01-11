/* Copyright 1994-2013 The MathWorks, Inc.
 *
 * File      : sfun_user_fxp_prodsum.c
 *
 * Abstract:
 *      User S-function example
 *      Using on strictly type core algorithm shared
 *      by simulation and by C code generation.
 * 
 *      This example implements a simple hybrid add of two inputs 
 *      The core algorithm is in a C file
 *      that will be shared for both simulation and code generation.
 *     
 *      This s-function handles the registration and so forth 
 *      and calls the core algorithm from the C file.
 * 
 *      For code generation, a corresponding TLC file will 
 *      handle the interfacing aspects, then call the 
 *      core algorithm from the same C file as used for simulation.
 */

/*=====================================*
 * Required setup for C MEX S-Function *
 *=====================================*/
#define S_FUNCTION_NAME sfun_user_hybrid_add
#define S_FUNCTION_LEVEL 2

/* Fixed width integer types from C99 standard */
#include <stdint.h>

#include "simstruc.h"
#include "fixedpoint.h"

#include "example_func_core_strictly_typed.h"

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 1
#endif


static void setRealOutput(SimStruct *S,int idxPort, DTypeId id)
{
    ssSetOutputPortWidth(S, idxPort, 1);
    ssSetOutputPortDataType(S, idxPort, id);    
    ssSetOutputPortOptimOpts(S, idxPort, SS_REUSABLE_AND_LOCAL);
    ssSetOutputPortComplexSignal(S, idxPort, COMPLEX_NO);
}
static void setRealInput(SimStruct *S,int idxPort, DTypeId id)
{
    ssSetInputPortWidth(S, idxPort, 1);
    ssSetInputPortDataType(S, idxPort, id);
    ssSetInputPortDirectFeedThrough(S, idxPort, TRUE);
    ssSetInputPortRequiredContiguous(S, idxPort, TRUE);
    ssSetInputPortOptimOpts(S, idxPort, SS_REUSABLE_AND_LOCAL);
    ssSetInputPortOverWritable(S, idxPort, FALSE);
    ssSetInputPortComplexSignal(S, idxPort, COMPLEX_NO);
}



static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 0);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
        return;

    if (!ssSetNumOutputPorts(S, 1))
        return;

    if (!ssSetNumInputPorts(S, 2))
        return;

    /* register data types
     */
    DTypeId u64id = ssRegisterDataTypeInteger(S, 0, 64, 0);
    DTypeId u32id = ssRegisterDataTypeInteger(S, 0, 32, 0);

    setRealOutput(S, 0, u64id);
    //setRealOutput(S, 1, u64id);
    //setRealOutput(S, 2, u32id);

    setRealInput(S, 0, u64id);
    setRealInput(S, 1, u32id);

    ssSetNumSampleTimes(S, 1);

    ssSetOptions(S,
                 SS_OPTION_DISCRETE_VALUED_OUTPUT |
                     SS_OPTION_EXCEPTION_FREE_CODE |
                     SS_OPTION_USE_TLC_WITH_ACCELERATOR |
                     SS_OPTION_WORKS_WITH_CODE_REUSE |
                     SS_OPTION_NONVOLATILE |
                     SS_OPTION_CALL_TERMINATE_ON_EXIT |
                     SS_OPTION_CAN_BE_CALLED_CONDITIONALLY);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    (void)tid;

    uint64_t * const pY0 = (uint64_t * const)ssGetOutputPortSignal(S, 0);

    uint64_t const * const pU0 = (uint64_t const * const)ssGetInputPortSignal(S, 0);
    uint32_t const * const pU1 = (uint32_t const * const)ssGetInputPortSignal(S, 1);
    
    *pY0 = func_core_hybrid_add(*pU0, *pU1);

    /*
    uint64_t * const pY1 = (uint64_t * const)ssGetOutputPortSignal(S, 1);
    uint32_t * const pY2 = (uint32_t * const)ssGetOutputPortSignal(S, 2);
    *pY1 = *pU0;
    *pY2 = *pU1;    
     */
}

static void mdlTerminate(SimStruct *S)
{
    (void)S;
}

/*=======================================*
 * Required closing for C MEX S-Function *
 *=======================================*/

#ifdef MATLAB_MEX_FILE /* Is this file being compiled as a MEX-file? */
#include "simulink.c"  /* MEX-file interface mechanism               */
#include "fixedpoint.c"
#else
#include "cg_sfun.h" /* Code generation registration function      */
#endif
