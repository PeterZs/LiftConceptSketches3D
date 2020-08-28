clear all;
folder = 'C:\Users\yulia\Research\DesignSketch3D\results\backproject_reconstruction_json\json_cluster_v3';
global folder_save;
global sketch_height;
sketch_height = 512;
foler_save_base = 'C:\Users\yulia\Research\DesignSketch3D\results\backproject_reconstruction_json\json_cluster_v3\frames_clipped';

files = dir(folder);
files = files(~[files(:).isdir]);
files = {files.name};


for i = 22:length(files)
   filename = files{i};
   filename_ = strrep(filename, '.json', '');
   try
       [ strokes_topology, intersections, cam_param] = ...
            readReconstructionJsonFelix( fullfile(folder, filename));   
   catch
       continue;
   end
   [strokes_topology, intersections, cam_param] = scaleAndCenterTheObject(strokes_topology, intersections, cam_param, []);
    
   folder_save = fullfile(foler_save_base, filename_);
   
   if ~exist(folder_save, 'dir')
       mkdir(folder_save);
   end
   
   objectLFSquareAndSaveSVGFrames(strokes_topology, cam_param, 'LFS')

%    objectLFEffectAndSaveSVGFrames(strokes_topology, cam_param, 'lf')
%    objectChangeScaleOneAxisAndSaveSVGFrames(strokes_topology, cam_param, 'scaleXYZ')    
end

% [ strokes_topology, intersections, cam_param] = ...
% readReconstructionJsonFelix( fullfile(folder, 'Professional2_vacuum_cleaner_bestScore_full.json' ));
% [strokes_topology, intersections, cam_param] = scaleAndCenterTheObject(strokes_topology, intersections, cam_param, []);
% folder_save = fullfile(foler_save_base, 'Professional2_vacuum_cleaner');
% 
% objectLFEffectAndSaveSVGFrames(strokes_topology, cam_param, 'lf')
% objectChangeScaleOneAxisAndSaveSVGFrames(strokes_topology, cam_param, 'scaleXYZ')
% % rotate3DAndSaveSVGFrames(strokes_topology, cam_param, '360');
% 
% [ strokes_topology, intersections, cam_param] = ...
% readReconstructionJsonFelix( fullfile(folder, 'Professional6_mouse_bestScore_full.json' ));
% [strokes_topology, intersections, cam_param] = scaleAndCenterTheObject(strokes_topology, intersections, cam_param, []);
% folder_save = fullfile(foler_save_base, 'Professional6_mouse');
% % objectLFEffectAndSaveSVGFrames(strokes_topology, cam_param, 'lf')
% objectChangeScaleOneAxisAndSaveSVGFrames(strokes_topology, cam_param, 'scaleXYZ')
% % rotate3DAndSaveSVGFrames(strokes_topology, cam_param, '360');
% 
% [ strokes_topology, intersections, cam_param] = ...
% readReconstructionJsonFelix( fullfile(folder, 'student8_house_bestScore_full.json' ));
% [strokes_topology, intersections, cam_param] = scaleAndCenterTheObject(strokes_topology, intersections, cam_param, []);
% folder_save = fullfile(foler_save_base, 'student8_house');
% %objectLFEffectAndSaveSVGFrames(strokes_topology, cam_param, 'lf')
% objectChangeScaleOneAxisAndSaveSVGFrames(strokes_topology, cam_param, 'scaleXYZ')
% % rotate3DAndSaveSVGFrames(strokes_topology, cam_param, '360');