% ----------------------------------------------------------
function prq
global CARS LIGHTS T
fprintf( '%3.0f ', T );    % display period number

if LIGHTS == 'R'           % display colour of lights
  fprintf( 'R    ' );
else
  fprintf( 'G    ' );
end;

for i = 1:CARS             % display * for each car
  fprintf( '*' );
end;

fprintf( '\n' )            % new line
