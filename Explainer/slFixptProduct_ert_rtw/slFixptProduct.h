#ifndef slFixptProduct_h_
#define slFixptProduct_h_
#ifndef slFixptProduct_COMMON_INCLUDES_
#define slFixptProduct_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif

#include "slFixptProduct_types.h"

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
extern void slFixptProduct_initialize(void);
extern void slFixptProduct_step(void);
extern RT_MODEL *const rtM;

#endif

