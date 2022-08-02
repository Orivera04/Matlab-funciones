% Function mpc555rt_optflags_getfcn
%
% Abstract :
%   Handles the callbacks for the MPC555 Optimization Flags
%

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $
% $Date: 2004/04/19 01:27:08 $
function newVal = mpc555rt_optflags_getfcn(hObj, val)

   % get the configset for this object
   cs = getConfigSet(hObj);
   if isempty(cs)
      % handle empty case
      % passing through value gives correct result
      newVal = val;
      return;
   end;
   
   optswitch = get_param(cs, 'MPC555_OPTIMIZATION_SWITCH');
   if isempty(optswitch)
      error('Unexpected error: optswitch is empty in mpc555rt_optflags_getfcn.');
   end;
   
   prefs = RTW.TargetPrefs.load('mpc555.prefs');
   
   switch lower(optswitch)
        case 'speed'
			flags = prefs.ToolChainOptions.CompilerOptimizationSwitches.Speed;
            newVal = [''' ' flags ' '''];
        case 'size'
			flags = prefs.ToolChainOptions.CompilerOptimizationSwitches.Size;
            newVal = [''' ' flags ' '''];
        case 'debug'
			flags = prefs.ToolChainOptions.CompilerOptimizationSwitches.Debug;
            newVal = [''' ' flags ' '''];
        case 'custom'
            % use flag values entered in the opt switches box
            % by the user
            
            % Enforce quoting around value. This
            % is to circumvent a bug where rtwoptions
            % that are not quoted cause the build process to crash.
            newVal = quote(val);
       otherwise
            error('Unknown MPC555_OPTIMIZATION_SWITCH!');
   end
   
% Force single quoting of argument
function val = quote(val)
    % Strip all leading single quotes and whitespace
	 % Add single quotes to the value. If the original
    % value is empty or just white space make sure that
    % there is whitespace between the quotes because
    % downstream processing requires this.

    % Strip quotes
    val = regexprep(val,'^[''\s]*([^'']*)[''\s]*$','$1');
    % Strip trailing and leading whitespace and add quotes
    val = regexprep(val,'^\s*(.*[^\s])\s*$',''' $1 ''');
    if isempty(val)
        val = '''  ''';
    end
