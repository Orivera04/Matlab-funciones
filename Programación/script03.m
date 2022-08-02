	% Este script usa la fución calcarea para calcular 
	% el área de un círculo. Se pide el radio.
    clc;
	radio = input('Introduzca el radio: ');
    
	% Se llama a la función calcarea y se imprime el resultado
	area = calcarea(radio);
	fprintf('Para un círculo de radio: %.2f,',radio)
	fprintf(' el área es %.2f\n',area)
