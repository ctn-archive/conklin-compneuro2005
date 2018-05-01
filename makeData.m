
population_size = 40^2;
[freqX freqY directions] = getDirection(2, 0.02, population_size, 1/3, 2, 0, 'dir');
transMatX = getTransMat(freqX, freqY, 1/5000,0);
transMatY = getTransMat(freqX, freqY, 0, 1/5000);

% % shuffle prefered directions
% indeces = randperm(length(directions));
% directions = directions(:, indeces);

save matData

dlmwrite('transMatX.csv',transMatX)
dlmwrite('transMatY.csv',transMatY)
dlmwrite('directions.csv',directions')
dlmwrite('freqX.csv',freqX)
dlmwrite('freqY.csv',freqY)

%% generate samples
sample_size = 50^2;
[~, ~, samples] = getDirection(2, 0.02, sample_size, 1/3, 2, 0, 'sample'); % samples along column direction

dlmwrite('samples.csv',samples')

% %% generate environments
% envs = makeEnv(3, freqX, freqY);
% dlmwrite('envs.csv',envs)