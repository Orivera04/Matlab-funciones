function [izq,der] = subinterv( xdata, xval )
% 
%  SUBINTERV regresa los subindices de los extrwmos del subintervalo.
%
%  en el cual se encuentra xval.
% Si xval=extremo_izquierdo entonces izq=indice(extremo_izquierdo) -1; 
%    XDATA(IZQ) <= XVAL <= XDATA(DER)
%
%  
%  
%
  nval = length ( xval );
  ndata = length ( xdata );

  for ival = 1 : nval

    if ( xval(ival) <= xdata(2) )

      izq(ival) = 1;
      der(ival) = 2;
    elseif ( xdata(ndata) <= xval(ival) )

      izq(ival) = ndata-1;
      der(ival) = ndata;
    else

      idata = 2;
      while ( xdata(idata+1) < xval(ival) )
        idata = idata + 1;
      end
      izq(ival) = idata;
      der(ival) = idata+1;
    end

  end;



