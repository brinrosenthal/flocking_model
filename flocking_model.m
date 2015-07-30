%function = spp_soft_core_1_1%output = spp_soft_core_1_0(XXXCr,lr,Ca,la)
%THIS CODE SIMULATES A NONDIMENSIONALIZED VERSION OF THE SELF-PROPELLED PARTICLE MODEL WITH SOFT CORE
%INTERACTIONS DESCRIBED IN D'ORSOGNA ET AL. 2006 PRL
%BASED ON "spp_soft_core_1_1.m"

% input:
%   -paras from SETTINGS_flocking_model.m

% output:
%   - groupid_final: group identities in final frame
%   - agent_x_ds: downsampled agent x positions
%   - agent_y_ds: downsampled agent y positions

function [groupid_final, agent_x_ds, agent_y_ds, agent_id_ds] = flocking_model(paras)

% unpack parameters
C = paras.C;                l = paras.l;   
psi0 = paras.psi0;
eta = paras.eta;            noise_on = paras.noise_on;
noise_sd = paras.noise_sd;  numagents = paras.numagents;
tau = paras.tau;            numsteps = paras.numsteps;
m = paras.m;               
num_reps = paras.num_reps; 
env_upper = paras.env_upper;  
max_attraction_length = paras.max_attraction_length;
kneighbors = paras.kneighbors; % number of neighbors to interact with
int_type = paras.int_type;
downsample_factor = paras.downsample_factor;

%set starting positions and velocities of all agents
init_length = 6*pi*sqrt(numagents)/sqrt(25);%set length of initialization square centered at origin of space to give density 5/(20*pi)^2
xn = unifrnd(env_upper/2 - init_length/2,env_upper/2 + init_length/2, numagents,2); %define starting locations
xnt_1 = zeros(size(xn));
vn = unifrnd(-1,1,numagents,2);%define starting velocities
vn_1 = zeros(size(vn));
xn = xn + tau.*vn;

%initialize storage vectors
numgroups = zeros(numsteps,1);
psi_x = zeros(numagents,1);
GradUxi = zeros(numagents,2);

xtotal = []; ytotal = []; groupid = [];
vxtotal = []; vytotal = [];

for j = 1:numsteps
    
    % print out progress
    if mod(j,100)==0
        disp([num2str(j/numsteps*100) '% completed'])
    end
    
    M2 = xn*xn.';
    D = diag(M2);
    M2 = sqrt(bsxfun(@plus,D,D.')-2*M2);
    M2 = torus_dist_matrix(xn,env_upper);
    [numgroups(j), ids]= group_counter(M2,max_attraction_length);
    groupid = [groupid ids'];
    
    
    %add noise to agent positions
    if noise_on == 1
        noise_matrix = noise_vector(noise_sd,numagents);
        vn = vn + noise_matrix;
    end

    
    for i = 1:numagents
        xit = xn(i,:);
        vit = vn(i,:);

        psi_x(i) = psi0; % self-propulsion term.
        
        % SBR: added if-else statement to check which type of interaction
        if strcmpi(int_type,'MD')
            % metric distance interaction limit, if int_type = 'MD'
            GradUxi(i,:) = gMorsePotential_nondim(xit,xn,M2,C,l,max_attraction_length);
        elseif strcmpi(int_type,'TD')
            % metric and topological distance interaction limit, if int_type = 'TD'
            GradUxi(i,:) = gMorsePotential_nondim_TD(i,xn,M2,C,l,max_attraction_length,kneighbors);
        elseif strcmpi(int_type,'none')
            % for asocial groups, set GradUxi to 0
            GradUxi(i,:) = [0 0];
        end
    end
    
    %FOLLOWING CODE COMPUTES ACCELERATION/SPEED BY SOLVING ODES
    options = odeset('Stats','off','AbsTol',1e-2);
    [t xx] = ode45(@SoftCollectiveMorse_nondim,[0 tau/2 tau],[xn(:,1) xn(:,2) vn(:,1) vn(:,2)],options,numagents,psi_x,eta,GradUxi);
    xntemp1 = xx(3,1:numagents);
    yntemp1 = xx(3,numagents+1:2*numagents);
    xnt_1 = [xntemp1' yntemp1'];
    vxntemp1 = xx(3,2*numagents+1:3*numagents);
    vyntemp1 = xx(3,3*numagents+1:4*numagents);
    vnt_1 = [vxntemp1' vyntemp1'];
    
    xn = xnt_1;%update positions
    vn = vnt_1;%update speeds
    xn = period_correct(xn,env_upper);%correct positions to make env periodic
    
    
    %%% save agent positions 
    xtotal = [xtotal; xn(:,1)'];
    ytotal = [ytotal; xn(:,2)'];
    
    vxtotal = [vxtotal; vn(:,1)'];
    vytotal = [vytotal; vn(:,2)'];
    
end

groupid_final = groupid(:,numsteps);

agent_x_ds = xtotal(1:downsample_factor:end,:); % downsampled x position
agent_y_ds = ytotal(1:downsample_factor:end,:); % downsampled y position

agent_id_ds = groupid(:,1:downsample_factor:end); % downsampled group ids



