% transformation Matrix
% transMat consists of 2 by 2 sub-matrix
% = shift in the original space
% = rotationin the fourier space
% delta should be a small value

function transMat = getTransMat(freqX, freqY, deltaX, deltaY)

% !!! eliminate zero freqency
freqX = freqX(2:end);
freqY = freqY(2:end);

len = 2 * length(freqX);

phaseX = 2*pi*freqX * deltaX;
phaseY = 2*pi*freqY * deltaY;
phase = phaseX + phaseY;

cosElem = cos(phase);
sinElem = sin(phase);

% expand into diag vectors
diagV0 = zeros(len, 1);
diagV0(1:2:end) = cosElem;
diagV0(2:2:end) = cosElem;

diagV1 = zeros(len - 1, 1);
diagV1(1:2:end) = sinElem;

diagVn1 = zeros(len - 1, 1);
diagVn1(1:2:end) = -sinElem;

transMat = diag(diagV0, 0) + diag(diagV1, 1) + diag(diagVn1, -1);

% append one for the constant coefficient
% transMat = [1 zeros(1,len); zeros(len,1) transMat];