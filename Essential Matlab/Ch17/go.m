% ----------------------------------------------------------
function go
global CARS GTIMER GREEN LIGHTS
GTIMER = GTIMER + 1;        % advance green timer
CARS = CARS - 8;            % let 8 cars through

if CARS < 0                 % ... there may have been < 8
  CARS = 0;
end;

prq;                        % display queue of cars

if GTIMER == GREEN          % check if lights need to change
  LIGHTS = 'R';
  GTIMER = 0;
end;