#include "slFixptSum.h"
#include "rtwtypes.h"
#include "slFixptSum_private.h"

ExternalInputs rtU;
ExternalOutputs rtY;
static RT_MODEL rtM_;
RT_MODEL *const rtM = &rtM_;
void slFixptSum_step(void)
{
  rtY.y = (int16_T)(int32_T)(((int32_T)rtU.a << 5ULL) + (int32_T)rtU.b);
}

void slFixptSum_initialize(void)
{
}
