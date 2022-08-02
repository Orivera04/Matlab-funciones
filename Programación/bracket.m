function left = bracket ( xdata, xval )
% 
%  BRACKET returns the index of the lower bracket for a data value.
%
%  We're trying to ensure that XVAL is in interval LEFT:
%
%    XDATA(LEFT) <= XVAL <= XDATA(LEFT+1)
%
%  except that if XVAL is less than XDATA(1), it is assigned to interval 1,
%  and if it is greater than XDATA(NDATA), is is assigned interval NDATA-1.
%
  nval = length ( xval );
  ndata = length ( xdata );

  for ival = 1 : nval

    if ( xval(ival) <= xdata(2) )

      left(ival) = 1;

    elseif ( xdata(ndata) <= xval(ival) )

      left(ival) = ndata-1;

    else

      idata = 2;
      while ( xdata(idata+1) < xval(ival) )
        idata = idata + 1;
      end
      left(ival) = idata;

    end

  end



