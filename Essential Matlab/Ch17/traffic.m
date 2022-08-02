clc
clear                 % clear out any previous garbage!
global CARS GTIMER GREEN LIGHTS RED RTIMER T

CARS = 0;             % number of cars in queue
GTIMER = 0;           % timer for green lights
GREEN = 2;            % period lights are green
LIGHTS = 'R';         % colour of lights
n = 48;               % number of 10-sec periods
p = 0.3;              % probability of a car arriving
RED = 4;              % period lights are red
RTIMER = 0;           % timer for red lights

for T = 1:n           % for each 10-sec period

  r = rand(1,10);     % 10 seconds means 10 random numbers
  CARS = CARS + sum(r < p);  % cars arriving in 10 seconds

  if LIGHTS == 'G'
    go                % handles green lights
  else
    stop              % handles red lights
  end;
  
end