% THIS IS THE MAIN SETTINGS FUNCTION, TO SET PARAMETERS FOR FLOCKING MODEL
 
%SIMULATE SOFT-CORE INTERACTION MODEL WITH PAIRWISE MORSE POTENTIAL. MODEL
%DESCRIBED IN D'ORSOGNA ET AL. 2006 PHYS. REV. LETT.

% modified by SBR (14-10-15):
% 
% 1) pack all parameters into "paras" struct, for input into
% SIM_soft_core_nondim_v6.m
% 
% 2) turn script into function, to run on della, with inputs: r,peak_idx to
% select elements from two selected variables to loop over respectively
% 
% 3) create and save struct NGROUPS with the following fields:
%     paras: record of parameters used
%     NGROUPS.trial(k).groupid_final = groupid_final;           group identities at final timestep
%     NGROUPS.trial(k).agent_x_ds = agent_x_ds;                 downsampled agent x positions every ds timestep
%     NGROUPS.trial(k).agent_y_ds = agent_y_ds;                 downsampled agent y positions every ds timestep
%     NGROUPS.trial(k).agent_id_ds = agent_id_ds;               downsampled agent group identities every ds timestep 
% 
% 4) replace SIM_soft_core_nondim_1_1 with SIM_soft_core_nondim_v6- a function that outputs desired quantities


% loop over indices r and p to select different parameters
function SETTINGS_flocking_model(r,p)

% if there are no arguments, select 2 as default
if nargin==0
    r = 70; p = 1;
end

% directory where code lives
CODEDIR = cd; % ENTER YOUR PATH HERE
addpath(CODEDIR)

% directory in which to save output files
output_folder = cd; % ENTER YOUR PATH HERE
cd(output_folder);

% reseed randomizer with r
rng(r)

% sample tau from list
tau_vec = linspace(.05,1,10);

% sample numagents from list
num_agents_vec = linspace(50,500,10);

% self-propulsion
psi0loop = linspace(0,6,200);
paras.psi0 = psi0loop(r);

paras.C = 1.1; %repulsion coef/attraction coef  
paras.l = .1333; %repulsion decay length/attraction decay length

% SET PARAMETERS

% SET AGENT PARAMETERS
paras.numagents = num_agents_vec(p);%300; %set number of agents 
paras.tau = .5; %set time step size
paras.numsteps = 500*.5/paras.tau; %set number of timesteps to simulate. 
paras.m = 1; %set mass of agents

paras.eta = 1; %define friction term
paras.noise_on = 1;%(1) add or (0) do not add a noise vector to agent positions at each timestep
paras.noise_sd = 1e-3*paras.tau/.5;%0.01;%1e-3;%specify standard deviation of symmetric 2-normal from which noise vectors are drawn

% SET ENVIRONMENTAL PARAMETERS
paras.rho = 10; % average distance between two asocial agents
paras.env_upper = 2*paras.rho*sqrt(paras.numagents);%length of periodic square


% NUMBER OF REPLICATES PER SIMULATION
paras.num_reps = 1; %set number of replications for parameter sweep 

%SET INTERACTION TYPE PARAMETERS
paras.int_type = 'TD';% 'TD' for topological interactions, 'MD' for metric interactions, 'none' for asocial
paras.max_attraction_length = 20 ;%set the length beyond which agents are not attracted to one another
kneighbors = 25; % number of interacting neighbors
paras.kneighbors = kneighbors;

% DOWNSAMPLE FACTOR --> save every downsample_factor frame
paras.downsample_factor = 5*.5/paras.tau;

for k = 1:paras.num_reps
    k
    
    %RUN FLOCKING MODEL
    [groupid_final, agent_x_ds, agent_y_ds, agent_id_ds] = flocking_model(paras); %run simulation script
    
    % SAVE FLOCKING RESULTS
    NGROUPS.trial(k).groupid_final = groupid_final;
    NGROUPS.trial(k).agent_x_ds = agent_x_ds;
    NGROUPS.trial(k).agent_y_ds = agent_y_ds;
    NGROUPS.trial(k).agent_id_ds = agent_id_ds;
    
    NGROUPS.trial(k).paras = paras;

    % SBR: name files- save every iteration
    rlabel= num2str(10000+(r));
    save(['NGROUPS_' rlabel(2:end) '_' num2str(p) '.mat'],'NGROUPS')
    
end



