#ifndef slFixptSum_h_
#define slFixptSum_h_
#ifndef slFixptSum_COMMON_INCLUDES_
#define slFixptSum_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif

#include "slFixptSum_types.h"

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

typedef struct {
  int8_T a;
  int8_T b;
} ExternalInputs;

typedef struct {
  int16_T y;
} ExternalOutputs;

struct tag_RTM {
  const char_T * volatile errorStatus;
};

extern ExternalInputs rtU;
extern ExternalOutputs rtY;
extern void slFixptSum_initialize(void);
extern void slFixptSum_step(void);
extern RT_MODEL *const rtM;

#endif

