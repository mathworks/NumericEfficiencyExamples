/* Copyright 2020 The MathWorks, Inc.
 *
 * File      : sfun_user_various_hybrid_add.c
 *
 * Abstract:
 *      User S-function example
 *      Using a core algorithm shared
 *      by simulation and by C code generation
 *      that dynamically dispatches to different numeric type situations
 * 
 *      This s-function handles the registration 
 *      and puts type information about the ports in a C structure.
 *      and then calls the share core algorithm from the C file.
 * 
 *      For code generation, a corresponding TLC file will 
 *      handle the interfacing aspects of putting 
 *      information about the ports in a C structure.
 *      and then calling the 
 *      core algorithm from the same C file as used for simulation.
 */

/*=====================================*
 * Required setup for C MEX S-Function *
 *=====================================*/
#define S_FUNCTION_NAME sfun_user_various_hybrid_add
#define S_FUNCTION_LEVEL 2

/* Fixed width integer types from C99 standard */
//#include <stdint.h>

#include "simstruc.h"
#include "fixedpoint.h"

#include "example_func_core_dynamic_typed.h"

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 1
#endif

enum
{
    IDX_CHOICE_OF_TYPES,
    N_PAR
};

#define PMX_CHOICE_OF_TYPES (ssGetSFcnParam(S, IDX_CHOICE_OF_TYPES))

#define V_CHOICE_OF_TYPES (mxIsEmpty(PMX_CHOICE_OF_TYPES) ? 0 : (mxGetPr(PMX_CHOICE_OF_TYPES)[0]))

static int basicParamCheck(
    SimStruct *S,
    const mxArray *pOrigParam)
{
    if ((ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) || !mxIsEmpty(pOrigParam))
    {
        if (mxIsEmpty(pOrigParam))
        {
            ssSetErrorStatus(S, "An SFunction parameter was empty.");
            return 0;
        }

        if (mxGetNumberOfElements(pOrigParam) != 1)
        {
            ssSetErrorStatus(S, "An SFunction parameter was not a scalar as required.");
            return 0;
        }
        if (!mxIsDouble(pOrigParam))
        {
            ssSetErrorStatus(S, "SFunction parameter was not a double as required.");
            return 0;
        }
    }

    /* all parameters are OK */
    return 1;
}

#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    if (!basicParamCheck(S, PMX_CHOICE_OF_TYPES))
        return;

    if ((V_CHOICE_OF_TYPES < 0) || (V_CHOICE_OF_TYPES > 2))
    {
        ssSetErrorStatus(S, "Case parameter must be an integer value of 0, 1, or 3.");
    }
}

static void setRealOutput(SimStruct *S, int idxPort, DTypeId id)
{
    ssSetOutputPortWidth(S, idxPort, 1);
    ssSetOutputPortDataType(S, idxPort, id);
    ssSetOutputPortOptimOpts(S, idxPort, SS_REUSABLE_AND_LOCAL);
    ssSetOutputPortComplexSignal(S, idxPort, COMPLEX_NO);
}
static void setRealInput(SimStruct *S, int idxPort, DTypeId id)
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
    ssSetNumSFcnParams(S, N_PAR);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
        return;

    if (!ssSetNumOutputPorts(S, 1))
        return;

    if (!ssSetNumInputPorts(S, 2))
        return;

    /*if (ssGetSimMode(S) == SS_SIMMODE_SIZES_CALL_ONLY)
    {
        return;
    }*/

    for (int i = 0; i < N_PAR; i++)
    {
        ssSetSFcnParamNotTunable(S, i);
    }

    DTypeId dtIdU0;
    DTypeId dtIdU1;
    DTypeId dtIdY0;

    /* register data types
     */
    switch ((int)(V_CHOICE_OF_TYPES))
    {
    case 0:
        dtIdU0 = ssRegisterDataTypeInteger(S, 0, 64, 0);
        dtIdU1 = ssRegisterDataTypeInteger(S, 0, 32, 0);
        dtIdY0 = ssRegisterDataTypeInteger(S, 0, 64, 0);
        break;
    case 1:
        dtIdU0 = ssRegisterDataTypeInteger(S, 0, 64, 0);
        dtIdU1 = ssRegisterDataTypeInteger(S, 0, 64, 0);
        dtIdY0 = ssRegisterDataTypeInteger(S, 0, 64, 0);
        break;
    default:
        dtIdU0 = SS_SINGLE;
        dtIdU1 = SS_SINGLE;
        dtIdY0 = SS_SINGLE;
        break;
    };

    setRealOutput(S, 0, dtIdY0);

    setRealInput(S, 0, dtIdU0);
    setRealInput(S, 1, dtIdU1);

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

void setNumTypeAttrib(
    SimStruct *S,
    numTypeAttrib *const pAttrib,
    DTypeId dataTypeId)
{
    pAttrib->isFloat = ssGetDataTypeIsFloatingPoint(S, dataTypeId);
    
    if ( pAttrib->isFloat ) {
        pAttrib->isSigned = true;
        pAttrib->wordLength = dataTypeId == SS_SINGLE ? 32 : 64;
    } else {
        pAttrib->isSigned = ssGetDataTypeFxpIsSigned(S, dataTypeId);
        pAttrib->wordLength = ssGetDataTypeFxpWordLength(S, dataTypeId);
    }
    
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    (void)tid;

    void *const pY0 = (void *const)ssGetOutputPortSignal(S, 0);
    void const *const pU0 = (void const *const)ssGetInputPortSignal(S, 0);
    void const *const pU1 = (void const *const)ssGetInputPortSignal(S, 1);

    numTypeAttrib ntAttribU0;
    numTypeAttrib ntAttribU1;
    numTypeAttrib ntAttribY0;

    setNumTypeAttrib(S, &ntAttribU0,
                     ssGetInputPortDataType(S, 0));
    setNumTypeAttrib(S, &ntAttribU1,
                     ssGetInputPortDataType(S, 1));
    setNumTypeAttrib(S, &ntAttribY0,
                     ssGetOutputPortDataType(S, 0));

    func_core_hybrid_add_dispatch(pU0, pU1, pY0, &ntAttribU0, &ntAttribU1, &ntAttribY0);
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
