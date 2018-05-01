% plot using compact gaussian coefficients

function plotCompGauss(sideLength, step, freqX, freqY, coeff)

[X Y Z] = reconst(sideLength, step, freqX, freqY, coeff);

surf(X,Y,Z);
xlim([-sideLength/2 sideLength/2]);
ylim([-sideLength/2 sideLength/2]);