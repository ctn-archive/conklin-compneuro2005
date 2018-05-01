% compute fourier coefficients of gaussians evenly distributed on a 2-D plane
% cutOff is highest frequency
% the first csin (coefficient of sin function) is 0
% NOTE: when random = 0, nGaussians should be a perfect square
%
% Parameteres:
%
% x, y sets the location of generated Gaussian bump
%
% sigma sets the wideth of the gaussian
%
% nGaussians sets the number of gaussian bumps genereated
% random controls whether the gaussian bumps will be evenly or randomly
% distributed. Set it to 'false' when using the x,y parameters

function [freqX freqY Coeff] = getGaussiansCoeff(sideLength, step, nGaussians, sigma, maxFreq, random, x, y)

% % general parameters
nSteps = sideLength/step + 1;
% generate field centered at (0,0)
[X Y] = meshgrid((-sideLength/2 : step : sideLength/2));
iZero = 1;

if nargin == 6
    % generate gaussians randomly or evenly space in the field
    if random == 1
        % parameters of gaussians
        meanX = rand(nGaussians,1) * sideLength - sideLength/2;
        meanY = rand(nGaussians,1) * sideLength - sideLength/2;
    else
        sqn = sqrt(nGaussians);
        [meanX meanY] = meshgrid(linspace(-sideLength/2, sideLength/2, sqn));
        meanX = meanX(:);
        meanY = meanY(:);
    end
else
    meanX = x - 1;
    meanY = y - 1;
end
    
    
% select valid frequencies
freq = (0:floor(maxFreq));
[freqX freqY] = meshgrid(freq);
freqX = [-freqX(2:end, :); freqX]; % duplicate to become a half circle, covering all freqencies needed
freqY = [freqY(2:end, :); freqY];
freqX(1: floor(end/2), 1) = maxFreq + 1; % exclude overlaping frequencies in the next step
% ifreq = sqrt(freqX.^2 + freqY.^2) <= maxFreq; % indeces of valid frequencies
ifreq = (abs(freqX) <= maxFreq) & (abs(freqY) <= maxFreq); % you can also use the line above
freqX = freqX(ifreq);
freqY = freqY(ifreq);

m = floor(nSteps/2) + 1; % the center(zero frequency) indeces after ifftshift
row = freqX + m;
column = freqY + m;
indeces = nSteps*(row - 1) + column; % indeces of valid ferqencies in shifted coeff matrices

len = 2*length(freqX) - 1;
Coeff = zeros( len, nGaussians);
base_gaussian = exp( ( -(X - 0).^2 - (Y - 0).^2)  /(2*sigma^2) );

for iGaussian = 1 : nGaussians
%     gaussian = exp( ( -(X - meanX(iGaussian)).^2 - (Y - meanY(iGaussian)).^2)  /(2*sigma^2) );
    shiftY = ((meanY(iGaussian) - (-sideLength/2)) / sideLength) * length(Y);
    shiftX = ((meanX(iGaussian) - (-sideLength/2)) / sideLength) * length(X);
    gaussian = circshift(base_gaussian, [ceil(shiftY) ceil(shiftX)]);

    coeff = fft2(ifftshift(gaussian));
    scoeff = fftshift(coeff);
    scoeff = scoeff(indeces);
    
    ccos = 2*real(scoeff);
    csin = -2*imag(scoeff);
    ccos(iZero) = ccos(iZero)/2;
     
    Coeff([1 (2:2:end)], iGaussian) = ccos;
    Coeff(3:2:end, iGaussian) = csin(2:end);
  
%%% No Need!    
%     if strcmp(type, 'dir')
%         % normalization
%         Coeff(:, iGaussian) = Coeff(:, iGaussian)/ norm(Coeff(:, iGaussian));
%     end
end

freqX = freqX / sideLength; % compensate for non-unit sideLenght
freqY = freqY / sideLength;

% % test reconstruction
% n = size(X,1);
% nf = length(freqX);
% X3 = X(:) * freqX';
% X3 = reshape(X3, [n n nf]);
% Y3 = Y(:) * freqY';
% Y3 = reshape(Y3, [n n nf]);
% ccos = repmat(reshape(ccos, [1,1,nf]),[size(X) 1]);
% csin = repmat(reshape(csin, [1,1,nf]),[size(X) 1]);
% 
% Z = (1/n^2)*(ccos.*(cos(2*pi*X3 + 2*pi*Y3)) + csin.*(sin(2*pi*X3 + 2*pi*Y3)));
% Z = sum(Z,3);
% 
% % figure; surf(gaussian-Z); zlim([-1 1]);
% figure;surf(Z);
