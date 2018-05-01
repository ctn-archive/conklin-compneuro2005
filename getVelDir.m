% get coefficients for velocity input

function dir = getVelDir(n, type)

angl = 2* pi * rand(1, n);
dir = [cos(angl); sin(angl)];

if strcmp(type, 'dir')
%     dir = double(rand(2, n) > 0.5);
elseif strcmp(type, 'sample')
%     dir = rand(2, n);
    radius = rand(1,n);
    dir = dir .* ([1;1] * radius);
end

% dir = dir * 2 - 1;