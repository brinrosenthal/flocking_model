function torus_dist_matrix = torus_dist_matrix(x, env_upper)

%x_s is (1x2) source location.
%N is linear dimension of space
%istorus is an indicator denoting whether space should be treated as
%Euclidean or periodic
    
    L = length(x);
    torus_dist_matrix = zeros(L,L);
    for i=1:L
        %for j=1:L
            %torus_dist_matrix(i,j) = torus_dist(x(i,:),x(j,:),env_upper);
            torus_dist_matrix(i,:) = torus_dist(x,x(i,:),env_upper);
        %end
    end


