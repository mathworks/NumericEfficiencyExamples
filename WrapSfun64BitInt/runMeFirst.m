% Mex the s-function and the wrapped C code
%
build_mex_sfun_user_hybrid_add

% Open a model to exercise the S-Function
%
mdl = 'model_exercise_wrapper_strict_typed';
open_system(mdl)

% sim it normal mode
%    no code gen used
set_param(mdl,'SimulationMode','normal')
sim(mdl)

% sim it accelerator mode
%    uses code gen to accelerate, but Coder licenses not used
%
set_param(mdl,'SimulationMode','accelerator')
sim(mdl)

% generate stand-alone C code from model
%     for Generic Real-Time
%       requires MATLAB Coder and Simulink Coder
rtwbuild(mdl)

% Execute the model at the command line
bangCommand = sprintf('!%s',mdl);
eval(bangCommand)

% Load the mat-file created by the generated code executable
load(mdl)

% Compare sim vs generated code
err = rt_yout - yout;
worstAbsErr = max( abs( err(:) ) )
