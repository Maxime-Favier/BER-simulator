function [symbols] = mapper_4(x)
% @author : Xiaoning Lee
AMPM= [1-1i  -3+3i  1+3i  -3-1i  3-3i  -1+1i  3+1i  -1-3i]./sqrt(10);     
index = bi2de((buffer(x,3))','left-msb');
symbols = AMPM(index+1);
end
