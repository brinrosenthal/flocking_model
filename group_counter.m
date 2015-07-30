function [ numgroups assignments ] = group_counter(distmat,cutoff)
%FUNCTION THAT CREATES A SPARSE MATRIX FROM A DISTANCE MATRIX BY APPLYING
%A CUTOFF AND THEN USES "GRAPHCONNCOMP" TO COMPUTE THE NUMBER OF 
%STRONGLY CONNECTED COMPONENTS
distmat(distmat < cutoff) = 1;
distmat(distmat ~= 1) = 0;

sparsemat = sparse(distmat);
[numgroups assignments] = graphconncomp(sparsemat,'Directed', false);

%output_args = [numgroups assignments];
end
