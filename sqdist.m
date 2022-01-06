function d=sqdist(a,b)
% SQDIST - computes squared Euclidean distance matrix
%          computes a rectangular matrix of pairwise distances
% between points in A (given in columns) and points in B

% NB: very fast implementation taken from Roland Bunschoten
% alpha: controls the tradeoff between the original HSI and the corresponding mean-filtered HSI

aa = sum(a.*a,1); bb = sum(b.*b,1); ab = a'*b;
d = abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab);

d = real(d);
d = max(d,0);

