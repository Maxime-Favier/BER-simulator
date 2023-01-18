function [e3] = encoder3(a)
%ENCODER3 Summary of this function goes here
%   Detailed explanation goes here
% @author: Maxime Favier
e3 = ones(1, length(a)*2)*(-1);
rate=2;
for i = 1:length(a)
    if i-4 >= 1
        d4 = a(i-4);
    else
        d4 = 0;
    end
    if i-3 >= 1
        d3 = a(i-3);
    else
        d3 = 0;
    end
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
    e3(i*rate-1) = xor(a(i), xor(d3, d4));
    e3(i*rate) = xor(xor(a(i), d1), xor(d3, d4));
end
end

