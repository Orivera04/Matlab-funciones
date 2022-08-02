k = 0;

while k ~= 3
  k = menu( 'Click on your option', 'Do this', ...
            'Do that', 'Quit' );
  if k == 1
    disp( 'Do this ... press any key to continue ...' )
    pause
  elseif k == 2
    disp( 'Do that ... press any key to continue ...' )
    pause
  end

end;
