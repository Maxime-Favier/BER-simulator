function [symbols] = mapper_3(codes)
% @author : Xiaoning Lee
QPSK=[1+1i   1-1i  -1+1i  -1-1i]./sqrt(2); 
index = bi2de((buffer(codes,2))','left-msb')';
symbols = QPSK(index+1);

end