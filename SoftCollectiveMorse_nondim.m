% Function for ode solver- evaluate next timestep of simulation

function dx = SoftCollectiveMorse_nondim(t,x,numagents,psi_x,eta,GradUxi)

vxtemp = x(2*numagents+1:3*numagents);
vytemp = x(3*numagents+1:4*numagents);

%dx in x dimension
dxtemp = vxtemp;

%dx in y dimension
dytemp = vytemp;

% take dvxtemp,dvytemp out of loop over agents, replace norm with hand-calculated norm (~2.5x faster)
dvxtemp = (psi_x - eta*(sqrt(vxtemp.^2 + vytemp.^2).^2)).*vxtemp./sqrt(vxtemp.^2 + vytemp.^2) - GradUxi(:,1); %WARNING: CHANGED 6-3-2014 TO NORMALIZE FOR SPEED
dvytemp = (psi_x - eta*(sqrt(vxtemp.^2 + vytemp.^2).^2)).*vytemp./sqrt(vxtemp.^2 + vytemp.^2) - GradUxi(:,2); %WARNING: CHANGED 6-3-2014 TO NORMALIZE FOR SPEED

dx = [dxtemp; dytemp; dvxtemp; dvytemp];

end