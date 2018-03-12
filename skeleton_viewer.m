% init
main_path = '/home/stefan/results/spencer_tracker/';
seq_path = 'anno_seq_03-e1920-2505_results';

save_path = ['./results/', seq_path, '/id_%04d/id_%04d_fr_%04d.txt'];
save_path_occ = ['./results/', seq_path, '/id_%04d/occ_id_%04d_fr_%04d.txt'];
img_path = [main_path seq_path '/img/img_%08d.jpg'];
anno_path = [main_path seq_path '/annotations.txt'];
annos = load(anno_path);
% 1   2   3   4   5   6   7   8   9   10
% fr, id, l,  t,  w,  h,  co, x,  y,  z 

joint_names = {'HEAD','NECK', 'LEFT SHOULDER', 'RIGHT SHOULDER', ...
    'LEFT ELBOW', 'RIGHT ELBOW', 'LEFT WRIST', 'RIGHT WRIST'};
num_joints = numel(joint_names);
anno_ids = sort(unique(annos(:,2)));
num_frames = max(annos(:,1));
num_annos = numel(anno_ids);

h = figure();

% load all skeletons (.mat or .txt?)
% load(['./results/', seq_path, '/anno_joints.mat']; %all_joints
% txt solution below

%view loop
for fr = 250:num_frames
    %show image
    img = imread(sprintf(img_path,fr));
    figure(h), imshow(img);
    figure(h), text(0,490,sprintf('global: %i/%i',fr,num_frames),'FontSize',12);
    figure(h), hold on;
    for id = anno_ids'
        file_name = sprintf(save_path,id,id,fr);
        file_name_occ = sprintf(save_path_occ,id,id,fr);
        %get skeleton
        if ~exist(file_name, 'file')
          continue;
        end
        curr_skel = load(file_name);
        %get occlusions
        if ~exist(file_name_occ, 'file')
            curr_occ = zeros(num_joints,1);
        else
            curr_occ = load(file_name_occ);
        end
        %draw joints
        colors = repmat(mod([100*id,200*id,300*id],255)./255,8,1);
        colors = colors.*(1-curr_occ.*0.7);
        figure(h), scatter(curr_skel(:,1),curr_skel(:,2),50,colors,'o')
        %draw lines
        line(curr_skel(1:2,1),curr_skel(1:2,2),'Color',colors(1,:),'LineWidth',1)
        line(curr_skel(3:5,1),curr_skel(3:5,2),'Color',colors(1,:),'LineWidth',1)
        line(curr_skel(6:8,1),curr_skel(6:8,2),'Color',colors(1,:),'LineWidth',1)
    end
    figure(h),hold off;
    %wait
    waitforbuttonpress()
end