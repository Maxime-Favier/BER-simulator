function [e1] = encoder1(a)
%ENCODER1 encoder 1
%   1 + D^2  1 + D + D^2
% @author Maxime Favier
e1 = ones(1, length(a)*2)*(-1);
rate = 2;
for i = 1:length(a)
    if i-2 >= 1
        d2 = a(i-2);
    else
        d2 = 0;
    end
    if i-1 >= 1
        d1 = a(i-1);
    else
        d1 = 0;
    end
    e1(i*rate-1) = xor(a(i), d2);
    e1(i*rate) = xor(xor(a(i), d1),d2);
end
end

