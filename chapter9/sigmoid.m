function val = sigmoid(inX)
% ��������������s�任
[m,n] = size(inX);
val = zeros(m,1);
val = 1.0 / (1 + exp(-inX));