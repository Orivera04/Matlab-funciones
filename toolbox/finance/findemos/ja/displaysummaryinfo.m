% DISPLAYSUMMARYINFO   DEパラメータの情報を表示
%
% DISPLAYSUMMARYINFO(INFOCELLARRAY) は、選択した線オブジェクトのテキスト
% 情報を表示します。INFOCELLARRAY は、選択したラインオブジェクトの 
% 'UserData' フィールドに情報(入力制御パラメータ、収束基準など)をひと
% まとめにして含むセル配列です。ユーザがラインオブジェクトをクリックする
% と、テキストオブジェクトが、INFOCELLARRAY の内容を表示するために生成
% されます。このテキストはパッチオブジェクトの中に表示されます。なお、
% このパッチボックスは、グリッドラインが透けて見えないように、テキストを
% 単に囲んだ構造になっています(パッチオブジェクトの外観をより見栄えの
% よいものにし、テキストをより読み易くするためにそのような構造になって
% います)。ユーザがマウスボタンを解除するとテキストとパッチオブジェクトは
% 消去されます。
% 
% 参考 : DEGATOOL, GETSUMMARYINFO, DEGADEMO, RUNBUTTONCALLBACK.


% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
