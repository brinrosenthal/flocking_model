% script to visualize peak tracking, use NGROUPS, from SETTINGS_flocking_model.m

% movie flag, 'on' if you want to save, 'off' otherwise
make_movie = 'off'

% reset random seed so group colors are the same each time
rng(10);

% folder to save movie frames
save_fold = 'C:\Users\SaraBrin\Google Drive\Fish_schooling\Lab Data\Update_15_02\col_sense_movies\2_phenotypes';
mkdir(save_fold);
current_fold = cd;

% number of lag points to plot
tlag = 3;
r = 1;
paras = NGROUPS.trial(r).paras;
xtotal = NGROUPS.trial(r).agent_x_ds;
ytotal = NGROUPS.trial(r).agent_y_ds;

[numframes,numagents] = size(xtotal);

groupid = NGROUPS.trial(r).agent_id_ds;


hold on

% move to save_fold if saving movie
if strcmpi(make_movie,'on')
    cd(save_fold)
end

group_col_vec = [rand(paras.numagents,1) ones(paras.numagents,2)];
group_col_vec(2) = 205/360; group_col_vec(1) = 1;% % some fine-tuning of group colors
group_col_vec = hsv2rgb(group_col_vec);



% add counter so we don't have to rename files later
fcount = 0;
for frame = tlag+2:numframes
    fcount = fcount+1;
    frame
    hold off

    xlim([-2,paras.env_upper+2]); ylim([-2,paras.env_upper+2]);

    colids = group_col_vec(groupid(:,frame),:); % color code by group id
    scatter(xtotal(frame,:),ytotal(frame,:),4,colids,'filled')


    % plots tails using weird surface method...much faster!
    for i = 1:paras.numagents
        xlag = [xtotal(frame:-1:frame-tlag,i)]';
        ylag = [ytotal(frame:-1:frame-tlag,i)]';
        zlag = zeros(size(xlag));
        colids_lag = zeros(tlag+1,3);
        colids_lag(1,:) = rgb2hsv(colids(i,:));
        colids_lag(2:end,1) = colids_lag(1,1);
        colids_lag(2:end,2) = colids_lag(1,2) - [1:tlag]'/tlag;
        colids_lag(2:end,3) = colids_lag(1,3)-[1:tlag]'/tlag/10;
        colids_lag = hsv2rgb(colids_lag);
        collag(1,:,:) = colids_lag;
        
        % don't plot agents that are too close to the edge
        if sum(abs(diff(xlag))+ abs(diff(ylag)))<paras.env_upper/2
            surface([xlag;xlag],[ylag;ylag],[zlag;zlag],[collag;collag],'facecol','no', 'edgecol','interp','linew',.5);
        end
    end
    
    xlim([0,paras.env_upper]);ylim([0,paras.env_upper]);
    
    text_str = {['t = ' num2str(frame)]};
    tbox1 = annotation('textbox',[.5,.15,.1,.1],'String',text_str,'LineStyle','none');
    
    fnumber = num2str(10000+fcount);
    fname = ['frame_' fnumber(2:end) '.png'];
    
    if strcmpi(make_movie,'on')
        export_fig(fname, '-r125', '-transparent')
    end
    getframe();
    delete(tbox1);
    hold off
end

cd(current_fold);
