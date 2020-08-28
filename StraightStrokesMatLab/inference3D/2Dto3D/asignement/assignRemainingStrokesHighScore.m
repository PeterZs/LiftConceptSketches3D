function  [strokes_topology, intersections] = ...
        assignRemainingStrokesHighScore(...
                        strokes_topology,...
                        intersections,...
                        cam_param,...
                        pairsInterInter)
                    
global confidence_threshold;
global max_cost_threshold;

inds_non_assigned_strks = ...
  find(cat(1,  strokes_topology(:).num_candidate_lines) > 0);

if isempty(inds_non_assigned_strks)
    return;
end

  
max_costs = cat(1, strokes_topology(inds_non_assigned_strks).score);
confidence_vals = cat(1, strokes_topology(inds_non_assigned_strks).confidence);

% Keep only strokes with high score values:
max_costs_mask = max_costs > 0.5;
max_costs = max_costs(max_costs_mask);
confidence_vals = confidence_vals(max_costs_mask);
inds_non_assigned_strks = inds_non_assigned_strks(max_costs_mask);
           
% Sort the strokes according to cost and then according to confidence:        

[inds_non_assigned_strks,...
          max_costs, ...
          confidence_vals] = ...
                sortStrokesScoreConfidence(inds_non_assigned_strks,...
                                    max_costs, ...
                                    confidence_vals);

while ~isempty(inds_non_assigned_strks)
    ind_strk = inds_non_assigned_strks(1);

    strk_assign = strokes_topology(ind_strk);
    strk_assign.ind = ind_strk;

    UP_TO_LAST = true;
    [strk_assign.inds_intrsctns_eval,...
     strk_assign.inds_intrsctns_eval_actv,...
     strk_assign.inds_intrsctns_eval_mltpl_cnddts,...
     strk_assign.inds_intrsctng_strks_eval,...
     strk_assign.inds_intrsctng_strks_eval_actv,...
     strk_assign.inds_intrsctng_strks_eval_mltpl_cnddts] = ...
        returnIndicesNodesTypes(strk_assign, ...
                            cat(1, strokes_topology(:).depth_assigned),...
                                        intersections,...
                                        UP_TO_LAST);
                                    

        try
        [strokes_topology, intersections] = ...
            checkDepthAssignemnt(strokes_topology, ...
                                 intersections,...
                                 strk_assign,...
                                 strk_assign.candidate_lines,...
                                 pairsInterInter,...
                                 cam_param,...
                                 true);
        catch e
            rethrow(e);
        end

    

    inds_non_assigned_strks = ...
        find(cat(1,  strokes_topology(:).num_candidate_lines) > 0);
    max_costs = cat(1, strokes_topology(inds_non_assigned_strks).score);
    confidence_vals = cat(1, strokes_topology(inds_non_assigned_strks).confidence);
    
    [inds_non_assigned_strks,...
              max_costs, ...
              confidence_vals] = ...
                    sortStrokesScoreConfidence(inds_non_assigned_strks,...
                                        max_costs, ...
                                        confidence_vals);

    if ~isempty(inds_non_assigned_strks)
        confidence_threshold = confidence_vals(1);
        max_cost_threshold = max_costs(1);
    end
end

%   [strokes_topology, intersections, cam_param] = ...
%             scaleAndCenterTheObject(strokes_topology, ...
%                                     intersections, ...
%                                     cam_param);

global folder_save;
saveDrawingAsOBJ(strokes_topology, intersections, folder_save, 'highScore');
saveDrawingAsOBJSingleObject(strokes_topology, folder_save, 'highScore');
saveJSONReconstruction(strokes_topology, intersections, cam_param, folder_save, 'highScore');
rotate3DAndSaveSVGFrames(strokes_topology, cam_param, 'highScore_full');
end

