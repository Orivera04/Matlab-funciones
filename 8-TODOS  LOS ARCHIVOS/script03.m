	% Este script usa la fuci�n calcarea para calcular 
	% el �rea de un c�rculo. Se pide el radio.
    clc;
	radio = input('Introduzca el radio: ');
    
	% Se llama a la funci�n calcarea y se imprime el resultado
	area = calcarea(radio);
	fprintf('Para un c�rculo de radio: %.2f,',radio)
	fprintf(' el �rea es %.2f\n',area)
