[freqX,freqY, icoeff] = getGaussiansCoeff(2, 0.025, 1, 1/3, 2.5, 1);
dlmwrite('gauss.csv',icoeff')
plotCompGauss(2, 0.025, freqX, freqY, icoeff)