% MIRR   �C���������v��
%
% R = MIRR(CF,SRATE,RRATE) �́A��A�̒���L���b�V���t���[�ɑ΂���C��
% �������v�����v�Z���܂��BCF �̓L���b�V���t���[�̃x�N�g���ASRATE �͕���
% �L���b�V���t���[���l�̋��Z���ARRATE �͐��̃L���b�V���t���[�l�̍ē�����
% �ł��BCF �ɍs�񂪓��͂��ꂽ�ꍇ�A���̍s��̂��ꂼ��̗񂪁A�ʁX�̃L���b
% �V���t���[�Ƃ��Ď�舵���܂��BSRATE �y�� RRATE �ɂ́A�e�� CF �̗��
% �Ή�����s�x�N�g���A�܂��́A�e�L���b�V���t���[�ɑ΂��ē������[�g�œK�p
% �����X�J���l����͂ł��܂��B
% 
% ���F
% $100,000�̓������������肵�܂��B�ȉ��̃L���b�V���t���[�́A���̓�������
% �ɂ���Ă����炳���N�Ԏ��v�ł��B�ؓ�������9%�A�ē�������12%�ł��B
%  
%                      Year 1       $20,000 
%                      Year 2      ($10,000)
%                      Year 3       $30,000 
%                      Year 4       $38,000 
%                      Year 5       $50,000 
% 
% ���̓����̏C���������v�����v�Z���܂��B
% 
%       r = mirr([-100000 20000 -10000 30000 38000 50000],.09,.12) 
% 
% ���̌��� r = 8.32%���o�͂���܂��B  
% 
% �Q�l : IRR, PVVAR, ANNURATE, XIRR.
%
% �Q�l����: Brealey and Myers, Principles of Corporate Finance, 
%           Chapter 5.
 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
