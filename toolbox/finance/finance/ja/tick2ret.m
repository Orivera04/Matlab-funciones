% TICK2RET   ���i���n�񂩂瑝�����v���n����o��
%
% ���̊֐��́ANASSETS �̎��Y�̉��i�� NUMOBS �̊ϑ��l�ԂŎ��������
% ���Y���v���v�Z���܂��B
% 
% [RetSeries, RetIntervals] = tick2ret(TickSeries, TickTimes)
%  
% ����:
%    TickSeries   : ���Ȏ��Y���i�� NUMOBS �s NASSETS ��̍s��B�ŏ��̍s
%                   �́A���Y�̓������i�ŁA�Ō�̍s�͍Ō��(�ł��V����)
%                   �ϑ��l�������Ă��܂��B
%    TickTimes    : (�I�v�V����)�ϑ����Ԃ� NUMOBS �s1��̑����x�N�g���B
%                   ���Ԃ͐��l�Ŏ����ꂽ�A�V���A�����t�ԍ�(���P��)�A�܂�
%                   �́A�C�ӂ̒P��(�N�Ȃ�)�Ŏ������10�i���̂����ꂩ��
%                   ���͂��܂��B
%
% �o�́F
%    RetSeries    : �������v�̊ϑ��l����Ȃ� NUMOBS-1 �s NASSETS ��̍s
%                   ��ł��Bi �Ԗڂ̎��v�́ATickTimes(i)���� TickTimes
%                   (i+1)�̊��Ԃɐ��������̂ŁA�N�Ԏ��v�ւ̃X�P�[�����O
%                   �́A�K�p����܂���B
% 
%                   RetSeries(i)= TickSeries(i+1)/TickSeries(i)- 1;
%
%    RetIntervals : (�I�v�V����)�ϑ��l�Ԃ̎��ԊԊu�̃X�J���l�A�܂��́A
%                   NUMOBS-1 �s1��̃x�N�g���ł��B���� TickTimes �Ɏw��
%                   ���Ȃ��Ƃ��́A�S�Ă̊Ԋu������1�ł���Ɖ��肳��܂��B
%
% �Q�l : RET2TICK, EWSTATS.


%   Author(s): J. Akao 3/24/98
%   Copyright 1995-2002 The MathWorks, Inc.  
