% RET2TICK   �������i�Ƒ������v�����A�̉��i�𐶐�
%
% ���̊֐��́ANASSET �̓����� NUMOBS �̑������v�̊ϑ��l���牿�i��
% �������܂��B
% 
% [TickSeries, TickTimes] = ....
%          ret2tick(RetSeries, StartPrice, RetIntervals, StartTime)
%  
% ����:
%    RetSeries    : �������v�̊ϑ��l����Ȃ� NUMOBS �s NASSETS ��̍s��
%                   �ł��Bi �Ԗڂ̎��v�́ATickTimes(i)���� TickTimes(i+1)
%                   �̊��Ԃɐ��������̂ŁA�N�Ԏ��v�ւ̃X�P�[�����O��
%                   �Ȃ���܂���B
%
%    StartPrice   : (�I�v�V����)�������Y���i��1�s NASSETS ��̃x�N�g����
%                   ���BStartPrice �Ɏw�肪�Ȃ��Ƃ��́A���i��1����X�^�[�g
%                   ���܂��B
%
%    RetIntervals : (�I�v�V����)�ϑ��l�Ԃ̎��ԊԊu�̃X�J���l�A�܂��́A
%                   NUMOBS �s 1��̃x�N�g���ł��B���� RetIntervals ���w
%                   �肵�Ȃ��ꍇ�A�S�Ă̊Ԋu������1�ł���Ɖ��肳��܂��B
%
%    StartTime    : (�I�v�V����)�ŏ��̊ϑ��l�̊J�n����
%
% �o��:
%    TickSeries   : ���Ȏ��Y���i�� NUMOBS+1 �s NASSETS ��̍s��B�ŏ���
%                   �s�́A���Y�̓������i�ŁA�Ō�̍s�͍Ō��(�ł��V����)
%                   �ϑ��l�������Ă��܂��B
%
%    TickTimes    : ���i�ɑΉ�����ϑ����Ԃ� NUMOBS+1 �s1��̃x�N�g���B
%                   �������Ԃ́AStartTime �œ��Ɏw�����Ȃ�����0�ƂȂ��
%                   ���B
%
% �Q�l : TICK2RET, PORTSIM.


%   Author(s): J. Akao 3/24/98
%   Copyright 1995-2002 The MathWorks, Inc.  
