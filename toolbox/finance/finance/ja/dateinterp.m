% DATEINTERP   ���Z�V���A�����t�ɗ�������}���܂��B��A�̎Q�Ƃ��闘��
%              �Ȑ����������ɓ��}���s���܂��B
%
% �\���F
%   Rates = dateinterp(RefDates, RefRates, Dates, Basis)
%
% ���́F
%   RefDates : �Q�Ƃ���_�ƂȂ���t��������Nref�s1��̃x�N�g��
%   RefRates : �Q�Ƃ��闘��������Nref�sNcurve��̍s��B���̍s��̊e��́A
%              RefDates �Ŋϑ�����闘���Ȑ��ł��B
%   Dates    : ���}����闘�����v�Z���邽�߂ɗp������t��Ndates�s1���
%              �x�N�g��
%   Basis    : �o�ߎ��Ԃ��v�Z���邽�߂ɗp����s������J�E���g�
%
% �o�́F
%   Rates    : ���}���ꂽ������Ndates�sNcurve��̍s��B�s��̊e���
%              RefRates���̑Ή����闘���Ȑ����瓱�o���ꂽ�����Ȑ��ł��B
%              ���}�́ARefDates�͈̔͊O�ł͒萔���}�ARefDates�͈̔͊O
%              �ł͐��`���}�ƂȂ��Ă��܂��B
%
% �Q�l : INTERP1Q, DAYSDIF.


%   Training example function JHA 1/13/98
%   Copyright 1995-2002 The MathWorks, Inc. 
