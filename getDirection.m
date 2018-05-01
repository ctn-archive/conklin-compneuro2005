% get COMPLETE prefered direction for each neuron,
% including compact gaussian coefficients and prefered velocity

function [freqX freqY coeff] = getDirection(sideLength, step, nGaussians, sigma, maxFreq, random, type)

[freqX freqY coeff] = getGaussiansCoeff(sideLength, step, nGaussians, sigma, maxFreq, random);
dir = getVelDir(nGaussians, type);
    
% rescale to make maxium value equals 1
maxv = max(max(coeff(:,:)));
coeff = coeff/maxv;

coeff = [coeff; dir];