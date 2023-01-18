function [e2] = encoder2(a)
%ENCODER2 Encode the binary vector with the E2 convolutional encoder
%   Encode the vector with G = 1+D^2+D^3+D^4, 1+D^2+D^3
% TO IMPROVE : vectorisation, use of the convolution function
% @author: Maxime Favier
e2 = ones(1, length(a)*2)*(-1);
rate = 2;
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
    e2(i*rate-1) = xor(a(i), xor(d2, xor(d3, d4)));
    e2(i*rate) = xor(xor(a(i), d2), d3);
end
end

