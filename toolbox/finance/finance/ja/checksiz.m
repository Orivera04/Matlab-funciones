% CHECKSIZ   入力引数間のサイズが互いに矛盾していないかどうかをテスト
%
% ECODE = CHECKSIZ(SIZES,FUN)は、引数のサイズが互いに矛盾していないか
% どうかをテストします。SIZES は、各入力引数のサイズを示す M 行 2 列の
% 行列 FUN は、CHECKSIZ を呼び出す関数の名称です。
%
% 例題：
% AとBの入力をとる関数 FOO における入力引数のサイズに矛盾があるか否かを
% チェックするには、つぎの関数を呼び出します。
%
%       ecode = checksiz([size(A);size(B)],'FOO')
%
% A と B の関数のサイズが矛盾している場合には、ECODE = 1とエラーメッセージ
% が出力されます。そうでない場合には、ECODE = 0が出力されます。
%
% 参考 : CHECKRNG, CHECKTYP.


%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
