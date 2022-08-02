% ----------------------------------------------------------
function stop
global LIGHTS RED RTIMER
RTIMER = RTIMER + 1;         % advance red timer
prq;                         % display queue of cars

if RTIMER == RED             % check if lights must be changed
  LIGHTS = 'G';
  RTIMER = 0;
end;