function output = gMorsePotential_nondim(xf,xn,distmat,C,l,max_attraction_length)
%Output gradient from nondimensionalied generalized Morse potential summed over all other agents(described in D'orsogna et al. 2006 PRL)
%xf: position of focal individual
%xn: position matrix (n x 2) of all individuals, including focal
%C: ratio of repulsion const. over attraction const
%l: ratio of repulsion decay length over attraction length
%max_attraction_length: distance beyond which no attraction is felt
%NOTE: 4-7-2014 ADDED NORMALIZATION BY DIVIDING POTENTIAL BY NUMBER OF
%NEIGHBORS

%create matrix to match # neighbors
%foc_mat = repmat(xf,numel(xn(:,1)),1);


find_row = ismember(xn,xf,'rows');%pull row of focal indiv from position matrix
fdists = distmat(find_row,:);%pull row of focal individual from distance matrix
%ismember(xn,xf,'rows')
%(fdists < max_attraction_length)'
%ismember(xn,xf,'rows')==0 & (fdists < max_attraction_length)'
neighboors_only = xn((ismember(xn,xf,'rows')==0 & (fdists < max_attraction_length)'),:);%drop focal individual and those that exceed max attraction length from positions matrix
fdists = fdists(fdists>0);%remove zero distances from distance matrix
fdists = fdists(fdists<max_attraction_length);%remove distances that exceed maximum attraction length
exp_r = exp(-fdists);
exp_a = exp(-fdists.*l);

Uxf = C.*exp_r-exp_a;


%compute derivative in x1 and x2 directions
Smat = zeros(numel(fdists),2);

if numel(fdists) > 0 %skip loop if agent has no neighbors
    %numel(fdists)
    for i = 1:numel(fdists)
        yfoc = neighboors_only(i,:);
        
        Smat(i,:) = grad_calc_nondim(C,l,xf,yfoc);%DIVIDE BY NUMBER OF NEIGHBORS TO NORMALIZE POTENTIAL
        
    end
    
    output = sum(Smat);%sum matrix of zeros if agent has no neighbor
    
end
