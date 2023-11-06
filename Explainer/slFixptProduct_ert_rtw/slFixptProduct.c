#include "slFixptProduct.h"
#include "rtwtypes.h"
#include "slFixptProduct_private.h"

ExternalInputs rtU;
ExternalOutputs rtY;
static RT_MODEL rtM_;
RT_MODEL *const rtM = &rtM_;
void slFixptProduct_step(void)
{
  rtY.y = (int16_T)(int32_T)((int32_T)rtU.a * (int32_T)rtU.b);
}

void slFixptProduct_initialize(void)
{
}
