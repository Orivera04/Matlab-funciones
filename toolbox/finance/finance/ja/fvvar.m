% FVVAR   �ϓ��L���b�V���t���[�̏������l
%
% FV = FVVAR(CF,RATE,DF) �́A������� RATE ���^����ꂽ�Ƃ��ɕϓ��L���b
% �V���t���[ CF �̏������l FV ���o�͂��܂��BFV�̓L���b�V���t���[�̏���
% ���l�ł��B���������z�́A�����L���b�V���t���[�l�Ƃ��Ċ܂܂�܂��B�s�K��
% �ȃL���b�V���t���[�̏ꍇ�ADF �̓L���b�V���t���[������������t�̃x�N�g��
% �ƂȂ�܂��B
% 
% ���F
% $10,000�̓����������������Ɖ��肵�܂��B�ȉ��̃L���b�V���t���[�́A����
% ������������̔N�Ԏ��v�ł��B�N����8%�Ƃ��܂��B
% 
%                      Year 1       $2000 
%                      Year 2       $1500 
%                      Year 3       $3000 
%                      Year 4       $3800 
%                      Year 5       $5000 
% 
% ���̋K���I�ȃL���b�V���t���[�̏������l���v�Z���܂��B
% 
%       fv = fvvar([-10000 2000 1500 3000 3800 5000],.08) 
% 
% ���̌��ʁAfv = 2722.10���o�͂���܂��B
% 
% $10,000�̓��������ɂ��A���̕s�K���ȃL���b�V���t���[�������܂��B��
% �������̎x�������ŏ��̃L���b�V���t���[�̒l�Ƃ��Ċ܂܂�Ă��邱�Ƃɒ���
% ���Ă��������B 
% 
%                     �L���b�V���t���[          ���t 
%                      -10000           �@ 1987�N 1��12��
%                        2500          �@�@1988�N 2��14��
%                        2000          �@�@1988�N 3�� 3��
%                        3000          �@�@1988�N 6��14��
%                        4000           �@ 1988�N12�� 1��
% 
% �ϐ� CF �� DF �́A���̂悤�ɒ�`����A��������9%�ƂȂ��Ă��܂��B
% 
%       cf = [-10000,2500,2000,3000,4000]; 
%       df = ['01/12/1987'
%             '02/14/1988'
%             '03/03/1988'
%             '06/14/1988'
%             '12/01/1988'];
% 
% ���̃L���b�V���t���[�̏������l�́Afv = fvvar(cf,.09,df)���Ȃ킿�A
% pv = 167.28 �ƂȂ�܂��B
% 
% �Q�l : PVFIX, FVFIX, IRR, PVVAR, PAYUNI.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  