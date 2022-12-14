% CSAPI   節点でない端点条件をもつキュービックスプライン補間
%
% PP  = CSAPI(X,Y)  は、節点ではない端点条件を使って与えられたデータ 
% (X,Y) への(pp-型の)キュービックスプライン補間を出力します。
% 補間は、データサイト X(j) で、与えられたデータ値 Y(:,j), j=1:length(X) 
% に一致します。データ値は、スカラ、ベクトル、行列、またはN次元配列です。
% 同じサイトのデータ点は、平均化されます。
% グリッド化されたデータへの補間については、以下を参照してください。
%
% CSAPI(X,Y,XX) は、FNVAL(CSAPI(X,Y),XX) と同じです。
%
% たとえば, 
%
%      values = csapi([-1:5]*(pi/2),[-1 0 1 0 -1 0 1], linspace(0,2*pi));
%
% は、この区間全体で正弦関数に対して驚くほど適切で細かい列を与えます。
%
% また、以下のように、矩形のグリッド上でデータ値を補間することも可能です。
%
% PP = CSAPI({X1, ...,Xm},Y) は、ji=1:length(Xi) と i=1:m に対して、
% データサイト (X1(j1), ..., Xm(jm)) でデータ値 Y(:,j1,...,jm) に一致
% するm点の(pp-型の)キュービックスプライン補間を出力します。
% 各 Xi の要素が識別されなければなりません。自然数のベクトル d で、関数が
% スカラ値のときに受け入れることのできる空の d として、Y は、
% [d,length(X1),...,.length(Xm)] の大きさでなければなりません。
%
% CSAPI({X1, ...,Xm},Y,XX) は、FNVAL(CSAPI({X1,...,Xm},Y),XX) と同じです。
%
% たとえば、つぎの構文は、2変数関数を補間した図を作成します。
%
%      x = -1:.2:1; y=-1:.25:1; [xx, yy] = ndgrid(x,y); 
%      z = sin(10*(xx.^2+yy.^2)); pp = csapi({x,y},z);
%      fnplt(pp)
%
% ここで、NDGRID の代わりに MESHGRID を使用すると、エラーになります。
%
% 参考 : CSAPE, SPAPI, SPLINE, NDGRID.


%   Copyright 1987-2003 C. de Boor and The MathWorks, Inc.
