% Mex the s-function and the wrapped C code
%
build_mex_sfun_user_hybrid_add

% Open a model to exercise the S-Function
%
mdl = 'model_exercise_wrapper_strict_typed';
open_system(mdl)

% sim it
sim(mdl)

% generate C code from model
rtwbuild(mdl)

% Execute the model at the command line
bangCommand = sprintf('!%s',mdl);
eval(bangCommand)

% Load the mat-file created by the generated code executable
load(mdl)

% Compare sim vs generated code
err = rt_yout - yout;
worstAbsErr = max( abs( err(:) ) )
