% ISBUSDAY   ���t���c�Ɠ��ł���ꍇ�̔���
%
% T = ISBUSDAY(D,HOL,WEEKEND)
%
% ����:
%        
%   D       - �Y��������t�̃x�N�g��
%
% ����(�I�v�V����):
%
%   HOL     - ���[�U��`�̋x���̃x�N�g���ł��B�f�t�H���g�́A(holidays.m��)
%             ���炩���ߒ�`����Ă���US�̋x���ł��B
%
%   WEEKEND - �T����1�Ƃ���0��1���܂ޒ���7�̃x�N�g���ł��B
%             ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%             ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%             WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%             �y�j���Ɠ��j�����T���ɂȂ�܂��B
%
% �o��:
%
%   T       - D ���c�Ɠ��ł���ꍇ��1�A�����łȂ��ꍇ��0�ł��B
%
%
% ���Ƃ��΁A
%
%   Date = ['15 feb 2001'; '16 feb 2001'; '17 feb 2001'];
%
% �Ƃ��āA(holidays.m����)���炩���ߒ�`����Ă���US�̋x���x�N�g����
% �p���āA���j���݂̂��T���Ƃ��ĉc�Ɠ���������ɂ́AMATLAB�Ɉȉ���
% �悤�Ɏw�����܂��B
%
%   Busday = isbusday(Date, [], [1 0 0 0 0 0 0])
%
% �Q�l : BUSDATE, FBUSDATE, HOLIDAYS, LBUSDATE.


%   Author(s): C.F. Garvin, M. Reyes-Kattar, 10-24-95 Bob Winata, 04-02-02
%   Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
