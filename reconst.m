function [X Y Z] = reconst(sideLength, step, freqX, freqY, coeff)

ccos = coeff([1 (2:2:end)]);
csin = [0; coeff(3:2:end)];

[X Y] = meshgrid((-sideLength/2 : step: sideLength/2));
% [X Y] = meshgrid((0 : step: sideLength));
n = size(X,1);

nf = length(freqX);
X3 = X(:) * freqX';
X3 = reshape(X3, [n n nf]);
Y3 = Y(:) * freqY';
Y3 = reshape(Y3, [n n nf]);
ccos = repmat(reshape(ccos, [1,1,nf]),[size(X) 1]);
csin = repmat(reshape(csin, [1,1,nf]),[size(X) 1]);

Z = (1/n^2)*(ccos.*(cos(2*pi*X3 + 2*pi*Y3)) + csin.*(sin(2*pi*X3 + 2*pi*Y3)));
Z = sum(Z,3);