% init
close all;
main_path = '/home/stefan/results/spencer_tracker/';
seq_path = 'anno_seq_03-e1920-2505_results';

mkdir('results', seq_path)
save_folder = ['./results/', seq_path, '/id_%04d/']; 
save_path = ['./results/', seq_path, '/id_%04d/id_%04d_fr_%04d.txt'];
save_path_occ = ['./results/', seq_path, '/id_%04d/occ_id_%04d_fr_%04d.txt'];
img_path = [main_path seq_path '/img/img_%08d.jpg'];
anno_path = [main_path seq_path '/annotations.txt'];
annos = load(anno_path);
% 1   2   3   4   5   6   7   8   9   10
% fr, id, l,  t,  w,  h,  co, x,  y,  z 

title_pre = 'Please mark the %s';
joint_names = {'HEAD','NECK', 'LEFT SHOULDER', 'LEFT ELBOW', ...
    'LEFT WRIST', 'RIGHT SHOULDER', 'RIGHT ELBOW', 'RIGHT WRIST'};
num_joints = numel(joint_names);
anno_ids = sort(unique(annos(:,2)));
num_frames = max(annos(:,1));
num_annos = numel(anno_ids);
all_joints = struct('id',[],'from_to',[],'joints',[]);
anno_step = 3;
exclude_ids = [];
for id = anno_ids'
    curr_anno = annos(annos(:,2)==id,:);
    last_fr = max(curr_anno(:,1));
    file_name = sprintf(save_path,id,id,last_fr);
    if exist(file_name,'file')
        exclude_ids = [exclude_ids, id];
    end
end

if ~isempty(exclude_ids)
    warning('The following ids will be excluded:')
    warning('%i, ',exclude_ids);
    anno_ids = setdiff(anno_ids,exclude_ids);
end

h = figure();
%h = figure('units','normalized','outerposition',[0 0 1 1]);

% anno loop
for id = anno_ids'
    mkdir(sprintf('results/%s', seq_path), sprintf('id_%04d',id))
    curr_annos = annos(annos(:,2)==id,:);
    from_frame = min(curr_annos(:,1));
    to_frame = max(curr_annos(:,1));
    % fill annos with holes with fake data (rare case, always occ)
    if (size(curr_annos,1) < to_frame-from_frame+1)
        fixed_annos = [];
        for i=from_frame:to_frame
            if any(curr_annos(:,1)==i)
                fixed_line = curr_annos(curr_annos(:,1)==i,:);
            else
                fixed_line = fixed_line; %noop. last one is used
            end
            fixed_annos = [fixed_annos ; fixed_line];
        end
        curr_annos = fixed_annos;
        from_frame = min(curr_annos(:,1));
        to_frame = max(curr_annos(:,1));
    end

    anno_window_size = to_frame-from_frame+1; 
    joint_positions = nan(anno_window_size,num_joints,2);
    occlusion_flags = zeros(anno_window_size,num_joints,1);
    
    % annotate every 'anno_step'th frame (+ start and end)
    anno_frames = round(linspace(from_frame,to_frame,...
        (to_frame-from_frame+1)/anno_step));
    skip_frames = [];
    frame_cnt = 0;
    for fr = anno_frames%from_frame:to_frame
        file_name = sprintf(save_path,id,id,fr);
        frame_cnt  = frame_cnt + 1;
        if exist(file_name,'file')
            warning('Frame already annotated, next...\n');
            continue;
        end
        skip_flag = false;
        local_fr = fr-from_frame+1;
        curr_box = curr_annos(local_fr,3:6);
        img = imread(sprintf(img_path,fr));
        figure(h), imshow(img);
        figure(h), text(0,490,sprintf('ID: %i/%i (%i/%i), global: %i',id,num_annos,local_fr,to_frame-from_frame+1,fr),'FontSize',12);
        figure(h), text(0,505,'(s)kip all occluded, (r)edo last one, (c)lear+redo all current','FontSize',12);
        rectangle('Position',curr_box,'EdgeColor',[0,1,0],'LineWidth',1);
        i = 1;
        while (i<=num_joints)
            point_style = 'ro';
            title(sprintf(title_pre,string(joint_names(i))));
            in_p=zeros(1,2);
            [in_p(1),in_p(2),button] = ginput(1);
            if (button==115 || button==2) %middle-click or s = skip (all occluded)
                skip_flag = true;
                if(fr==from_frame)
                    %skip_frames = [skip_frames fr:anno_frames(frame_cnt+1)-1];
                    occlusion_flags(local_fr:((anno_frames(frame_cnt+1)-1)-from_frame+1),:,1) = 1;
                elseif(fr == to_frame)
                    %skip_frames = [skip_frames anno_frames(frame_cnt-1)+1:fr];
                    occlusion_flags(((anno_frames(frame_cnt-1)+1)-from_frame+1):local_fr,:,1) = 1;                    
                else
                    %skip_frames = [skip_frames anno_frames(frame_cnt-1)+1:anno_frames(frame_cnt+1)-1];
                    occlusion_flags(((anno_frames(frame_cnt-1)+1)-from_frame+1):((anno_frames(frame_cnt+1)-1)-from_frame+1),:,1) = 1;                    
                end
                break;
            elseif(button == 114) % "r"edo last one
                figure(h), hold on, imshow(img);
                rectangle('Position',curr_box,'EdgeColor',[0,1,0],'LineWidth',1);
                if i > 2
                    for j = 1:i-2
                        if(~occlusion_flags(local_fr,j,1))
                            plot(joint_positions(local_fr,j,1),joint_positions(local_fr,j,2),'ro','MarkerSize',5);
                        else
                            plot(joint_positions(local_fr,j,1),joint_positions(local_fr,j,2),'bo','MarkerSize',5);
                        end
                    end
                end
                figure(h), hold off;
                i = max(1,i-1);
                continue; 
            elseif(button == 99) % "c"lear all
                figure(h), hold on, imshow(img);
                rectangle('Position',curr_box,'EdgeColor',[0,1,0],'LineWidth',1);
                figure(h), hold off;
                i = 1;
                continue;
            elseif(button == 3) %right-click = occluded
                if(fr==from_frame)
                    occlusion_flags(local_fr:((anno_frames(frame_cnt+1)-1)-from_frame+1),i,1) = 1; 
                elseif(fr == to_frame)
                    occlusion_flags(((anno_frames(frame_cnt-1)+1)-from_frame+1):local_fr,i,1) = 1; 
                else
                    occlusion_flags(((anno_frames(frame_cnt-1)+1)-from_frame+1):((anno_frames(frame_cnt+1)-1)-from_frame+1),i,1) = 1; 
                end
                point_style = 'bo';
            end
            joint_positions(local_fr,i,:) = in_p;
            figure(h), hold on, plot(in_p(1),in_p(2),point_style,'MarkerSize',5), hold off;
            i = i+1;
        end
        %if(~skip_flag) % Also save skipped (NaN) to interrupt during id
        % save single (checkpoint, /wo interpolation)
        save_joints = squeeze(joint_positions(local_fr,:,:));
        dlmwrite(sprintf(save_path,id,id,fr),save_joints,'\t')
        dlmwrite(sprintf(save_path_occ,id,id,fr),occlusion_flags(local_fr,:,1)')
        %end
    end
    %interpolate
    for i=1:num_joints
        X = joint_positions(:,i,:);
        X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)),'linear');
        joint_positions(:,i,:) = X;
    end
    %smooth?
    
    %save single (final overwrite)
    all_joints(id).id = id;
    all_joints(id).from_to = [from_frame, to_frame];
    all_joints(id).joints = joint_positions;
    for fr = setdiff(from_frame:to_frame, skip_frames)
        save_joints = squeeze(joint_positions(fr-from_frame+1,:,:));
        dlmwrite(sprintf(save_path,id,id,fr),save_joints,'\t')
        dlmwrite(sprintf(save_path_occ,id,id,fr),occlusion_flags(fr-from_frame+1,:,1)')
    end
    %save all_mat (checkpoint overwrite)
    save(['./results/', seq_path, '/anno_joints.mat'], 'all_joints');
end
% save all_mat (final overwrite)
save(['./results/', seq_path, '/anno_joints.mat'], 'all_joints');
