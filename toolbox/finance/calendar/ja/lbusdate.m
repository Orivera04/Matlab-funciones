% LBUSDATE   ���̍Ō�̉c�Ɠ�
%
% D = LBUSDATE(Y,M,HOL,WEEKEND) 
%
% ����:
%
%   Y - �N
%       ���: 2002
%
%   M - ��
%       ���: 12 (12��)
%
% ����(�I�v�V����):
%
%   HOL - �x�Ɠ��������x�N�g���ł��BHOL �̎w�肪�Ȃ��ꍇ�A�x�Ɠ��̃f�[�^��
%         HOLIDAYS ���[�`���ɂ���ďo�͂���܂��B
%         �����_�ł́AHOLIDAYS ��NY�̋x�����T�|�[�g���܂��B
%
%   WEEKEND - �T����1�Ƃ���0��1���܂ޒ���7�̃x�N�g���ł��B
%             ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%             ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%             WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%             �y�j���Ɠ��j�����T���ɂȂ�܂��B
% �o��:
%
%   D - �w�肳�ꂽ���̍Ō�̉c�Ɠ�
%
% ���Ƃ��΁Ad = lbusdate(1997,5) �́A1997�N5��30���ɑ�������V���A��
% ���t�ԍ� d = 729540 ���o�͂��܂��B
% 
% �Q�l : BUSDATE, EOMDATE, FBUSDATE, HOLIDAYS, ISBUSDAY.


% Author(s): C.F. Garvin, 11-14-95 Bob Winata 12-12-02
% Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
