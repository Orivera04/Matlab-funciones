function std_state = get_std_model_state(rownum)

% function returns the Standard state value corresponding to the
% rownum-th Primary model 

global Primary_state

std_state = Primary_state(rownum).std_state ;