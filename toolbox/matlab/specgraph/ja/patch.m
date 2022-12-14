% PATCH   patchの作成
% 
% PATCH(X,Y,C) は、ベクトル X と Y で定義される"patch"または2次元の多角形を、
% カレントの軸に追加します。X と Y が同じサイズの行列の場合、列ごとに
% 1つの多角形("面")が追加されます。C は、面("平坦"な色付け)または頂点
% ("補間された"カラーリング)のカラーを指定します。多角形の内部のカラーを
% 指定するために、線形補間が使用されます。
% 
% X と Y がベクトルまたは行列に対して、C が文字列の場合、各面は'color'で
% 塗りつぶされます。'color' は、'r','g','b','c','m','y','w','k' のいずれか
% です。C がスカラの場合、カラーマップをインデックス付けして、面のカラーを
% 指定します。1行3列のベクトル C は、カラーを直接指定するRGBの3要素と
% 仮定されます。
%
% X と Y がベクトルのとき、C が同じ長さのベクトルの場合、各頂点のカラーを
% カラーマップのインデックスとして指定し、線形補間を使用して多角形の内部の
% カラーを指定します("補間された"シェーディング)。
%
% X と Y が行列のとき、nが X と Y の列数で、C が1行n列の場合、各面 
% j = 1:n は、カラーマップのインデックス C(j) によって平坦なカラーリングが
% 行われます。C が1行3列の場合は、常にRGBの3要素 ColorSpec と仮定され、
% 各面に対して同じ平坦なカラーを指定することに注意してください。C が X と 
% Y と同じサイズの行列の場合、頂点のカラーをカラーマップのインデックス
% として指定し、面をカラーリングするのに線形補間が使用されます。
% C が1xnx3の場合、nが X と Y の列数のとき、各面jはRGBの3要素 C(1,j,:) に
% よって平坦なカラーリングをされます。C がmxnx3の場合、X と Y がm行n列の
% とき、各頂点 (X(i,j),Y(i,j)) は、RGBの3要素 C(i,j,:) によってカラーリング
% され、面は補間を使ってカラーリングされます。
%
% PATCH(X,Y,Z,C )は、3次元座標にpatchを作成します。Z は、X と Y と同じ
% サイズでなければなりません。
%
% PATCHは、Patchオブジェクトのハンドル番号を出力します。Patchは、AXES
% オブジェクトの子です。
%
% X,Y,C の3要素(3次元に対しては X,Y,Z,C の4要素)の後に、Patchのプロパティ
% を指定するために、パラメータと値の組合わせを続けることができます。X,Y,C
% の3要素(3次元に対しては X,Y,Z,C の4要素)を省略して、パラメータと値の
% 組合わせを使ってすべてのプロパティを指定できます。
%
% パッチオブジェクトは、プロパティ Faces,Vertices,FaceVertexCData で設定
% されたデータを使います(詳細は、リファレンスマニュアルを参照)。これらの
% プロパティは、便利なシンタックスをもっていませんが、プロパティの名前と
% 値の組を使って設定されています。XData,YData,Zdata,Cdata として指定する
% パッチデータは、変換され、Faces,Vertices,FaceVertexCData として、内部に
% 保存され、オリジナルの行列としてストアされません。GET が Xdata,YData,
% Zdata,Cdata を引用して使う場合、出力値は、Faces,Vertices,FaceVertexCData 
% から変換されます。
%
% GET(H) は、H がpatchオブジェクトのハンドル番号のとき、patchオブジェクト
% のプロパティとそのカレント値のリストを表示します。SET(H) は、patch
% オブジェクトのプロパティと有効なプロパティ値のリストを表示します。
% 
% 参考：FILL, FILL3, LINE, TEXT, SHADING.


%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.9.4.1 $  $Date: 2004/04/28 02:05:27 $
%   Built-in function.

