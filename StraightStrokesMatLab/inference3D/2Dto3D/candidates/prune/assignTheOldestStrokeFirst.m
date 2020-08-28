function  [candidate_lines,...
           intersections,...
        strokes_topology,...
        confidence_threshold_reached,...
        costs_low] = assignTheOldestStrokeFirst(cur_stroke_ind,...
                                    intersections,...
                                    strokes_topology,...                                                                                     
                                    cam_param,...
                                    img,...
                                    pairsInterInter)


     %% Find the oldest stroke:
     
    inds_non_assigned_strks = find(cat(1,  strokes_topology(:).num_candidate_lines) > 0);
      
    global confidence_threshold;
    
    global confidence_step;
    global confidence_threshold_min;
    
%     confidence_threshold_old = confidence_threshold;
%     confidence_threshold = confidence_step*confidence_threshold; 
        
    i = 1;
    not_assigned = true;
    
    max_costs = NaN*ones(length(inds_non_assigned_strks),1);
    confidence_vals = NaN*ones(length(inds_non_assigned_strks),1);
    costs_low = false;
    global max_cost_threshold;
    while not_assigned 
        
        ind_strk = inds_non_assigned_strks(i);

%         candidate_lines = strokes_topology(ind_strk).candidate_lines;

        strk_assign =  strokes_topology(ind_strk);
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


        if isnan(max_costs(i))
            try
            [strokes_topology, intersections] = ...
                    assignDepthStraightStroke(  strk_assign,...
                                        intersections,...
                                        strokes_topology,...
                                        cam_param,...
                                        pairsInterInter,...
                                        true,...
                                        true);
            catch e
                rethrow(e);
            end
            max_costs(i) = strokes_topology(ind_strk).score;
            confidence_vals(i) = strokes_topology(ind_strk).confidence;
        else
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
        end
%         
        not_assigned = ~strokes_topology(ind_strk).depth_assigned;
        i = i + 1;
        if i > length(inds_non_assigned_strks)
           i = 1;
            if sum(max_costs >= max_cost_threshold) == 0
                costs_low = true;
                break;
            end
            confidence_threshold = max(confidence_vals); 
            if confidence_threshold < confidence_threshold_min
                break;
            end
        end
    end
    
    confidence_threshold_reached = confidence_threshold;
%     confidence_threshold = confidence_threshold_old;
    
    %% Directional prior:
    
    cur_stroke = strokes_topology(cur_stroke_ind);
    cur_stroke.ind = cur_stroke_ind;
    
      
    UP_TO_LAST = true;
    [cur_stroke.inds_intrsctns_eval,...
     cur_stroke.inds_intrsctns_eval_actv,...
     cur_stroke.inds_intrsctns_eval_mltpl_cnddts,...
     cur_stroke.inds_intrsctng_strks_eval,...
     cur_stroke.inds_intrsctng_strks_eval_actv,...
     cur_stroke.inds_intrsctng_strks_eval_mltpl_cnddts] = ...
        returnIndicesNodesTypes(cur_stroke, ...
                            cat(1, strokes_topology(:).depth_assigned),...
                                        intersections,...
                                        UP_TO_LAST);
                                    
    
    if cur_stroke.line_group ~= 4
        % Direction towards vanishing lines:    
        direction_prior = getDirectionVec(cur_stroke.line_group);
    else
        direction_prior = [];
    end
   
    %% Find all the candidate lines:             
     [  candidate_lines, ...
        strokes_topology,...
        intersections,...
        num_strokes_dependend] = ...
                findCandidateLines(  strokes_topology,...
                                     intersections,...
                                     pairsInterInter,...
                                     cur_stroke,...
                                     direction_prior,...
                                     cam_param);
                                 
                                 
end