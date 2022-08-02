function [s, lbl] = c24xcan_callback(action)
% C24XCAN_CALLBACK Mask Helper Function for the c24xx CAN blocks.
%
% $RCSfile: c24xcan_callback.m,v $
% $Revision: 1.1.6.2 $
% $Date: 2004/04/08 20:58:44 $
% Copyright 2003-2004 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

switch action
    
    case 'dynamic'
        
        if (strcmp(get_param(gcb,'MaskType'), 'C24x CAN Receive'))
            s = {1, 2};
            lbl = {'f()','Msg'};            
            
            ind = 2;
            if strcmp (get_param(gcb,'outputMessageLength'), 'on' )
                ind = ind + 1;
                s{ind} = ind;
                lbl{ind} = 'len';            
            end
            if strcmp (get_param(gcb,'outputMessageTimeStamp'), 'on' )
                ind = ind + 1;
                s{ind} = ind;
                lbl{ind} = 'TS';  
            end
            
            % Always return 4 elements; Elements for ports that are not
            % used will be copies of the last port used 
            for k=ind+1:4
                s{k} = s{ind};
                lbl{k} = lbl{ind};                 
            end
        end
        
    otherwise        
        
end

return

% [EOF] c24xcan_callback.m
