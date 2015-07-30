function output = gMorsePotential_nondim_TD(i_f,xn,distmat,C,l,max_attraction_length,kneighbors)
%Output gradient from nondimensionalied generalized Morse potential summed over all other agents(described in D'orsogna et al. 2006 PRL)
%i_f: index of focal individual
%xn: position matrix (n x 2) of all individuals, including focal
%C: ratio of repulsion const. over attraction const
%l: ratio of repulsion decay length over attraction length
%max_attraction_length: distance beyond which no attraction is felt
%NOTE: 4-7-2014 ADDED NORMALIZATION BY DIVIDING POTENTIAL BY NUMBER OF
%NEIGHBORS


% SBR: rewrite input args to remove need for slow calling of "ismember"
xf = xn(i_f,:);
find_row = i_f;%ismember(xn,xf,'rows');%pull row of focal indiv from position matrix
fdists = distmat(find_row,:);%pull row of focal individual from distance matrix

% SBR: speed up knnsearch, using matlab file exchange function (renamed by me to knnsearchfast) http://www.mathworks.com/matlabcentral/fileexchange/19345-efficient-k-nearest-neighbor-search-using-jit
% Note: input arguments are backwards from old, builtin version
idxTD= knnsearchfast(xf,xn,kneighbors);

% list of all non-focal fish
idxnonfocal = ones(length(xn),1);
idxnonfocal(i_f) = 0;

idxinradius = fdists' < max_attraction_length;

idxones = zeros(length(xn),1);
idxones(idxTD) = 1;
% select only topological neighbors which are within max_attraction_length
% SBR: remove ismember for speed
neighbors_only = xn(logical(idxones.*idxnonfocal.*idxinradius),:);%drop focal individual and those that exceed max attraction length from positions matrix

TDneighbors = neighbors_only;
fdists = fdists(idxTD);
fdists = fdists(fdists>0);%remove zero distances from distance matrix
fdists = fdists(fdists<max_attraction_length);%remove distances that exceed maximum attraction length

%compute derivative in x1 and x2 directions
Smat = zeros(numel(fdists),2);

if numel(fdists) > 0 %skip loop if agent has no neighbors
    %numel(fdists)
    % SBR: remove loop over fdists- rewrote grad_calc_nondim to output vector
    yfoc = TDneighbors;
    Smat = grad_calc_nondim(C,l,xf,yfoc);%DIVIDE BY NUMBER OF NEIGHBORS TO NORMALIZE POTENTIAL
    
end

output = sum(Smat);%sum matrix of zeros if agent has no neighbor

end
