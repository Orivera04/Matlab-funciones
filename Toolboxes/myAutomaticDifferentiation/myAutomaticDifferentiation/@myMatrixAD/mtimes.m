function z = mtimes(x, y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if isa(x, 'myMatrixAD')
        if isa(y, 'myMatrixAD')
            z = x;
            z.values = x.values*y.values;
%             z.derivatives = zeros([size(z.values), z.nVariables]);
%             for i = 1:x.nVariables
%                 z.derivatives(:,:,i) = x.derivatives(:,:,i)*y.values + x.values*y.derivatives(:,:,i);
%             end
            sx = size(x.values);
            sy = size(y.values);
            temp1 = reshape(permute(x.derivatives,[1 3 2]), sx(1)*y.nVariables, sx(2));
            temp2 = reshape(y.derivatives, sy(1), sy(2)*y.nVariables);
            z.derivatives = permute(reshape(temp1*y.values, sx(1), y.nVariables, sy(2)),[1 3 2]) + reshape(x.values*temp2, sx(1), sy(2), y.nVariables);
        else
            z = x;
            z.values = x.values*y;
%             z.derivatives = zeros([size(z.values), z.nVariables]);
%             for i = 1:x.nVariables
%                 z.derivatives(:,:,i) = x.derivatives(:,:,i)*y;
%             end
            sx = size(x.values);
            sy = size(y);
            temp1 = reshape(permute(x.derivatives,[1 3 2]), sx(1)*x.nVariables, sx(2));
            z.derivatives = permute(reshape(temp1*y, sx(1), x.nVariables, sy(2)),[1 3 2]);
        end
    else
            z = y;
            z.values = x*y.values;
%             z.derivatives = zeros([size(z.values), z.nVariables]);
%             for i = 1:y.nVariables
%                 z.derivatives(:,:,i) = x*y.derivatives(:,:,i);
%             end
            sx = size(x);
            sy = size(y.values);
            temp2 = reshape(y.derivatives, sy(1), sy(2)*y.nVariables);
            z.derivatives = reshape(x*temp2, sx(1), sy(2), y.nVariables);
    end
