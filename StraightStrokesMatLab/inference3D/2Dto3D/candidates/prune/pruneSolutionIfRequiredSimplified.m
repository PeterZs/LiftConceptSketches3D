function [strokes_topology,...
          intersections] = ...
                pruneSolutionIfRequiredSimplified(cur_stroke,...
                                        strokes_topology, ...
                                        intersections,...
                                        pairsInterInter,...
                                        cam_param,...
                                        expectedNumberCandidateLines)
    % Load global parameters:
    global confidence_threshold;
    global thr_max_num_lines;
    global confidence_threshold_min;
    global max_cost_threshold;
        
    %Intialise:
    confidence_threshold_reached = confidence_threshold;
    costs_low = false;
    
    %Save:
    confidence_threshold_old = confidence_threshold;

    
    
    %Find the set of all dependent strokes:
    try
        visited_strks = [];
        [inds_non_assgnd_dpndnt_strks] = findNonAssgndDpndntStrksSimplified(cur_stroke,...
                                                 strokes_topology,...
                                                 intersections,...
                                                 visited_strks);
    catch e
       rethrow(e); 
    end
    
    % Prun till the criteria are sutisfied:    
%     while ((expectedNumberCandidateLines > thr_max_num_lines) || ...
%            (checkNumConfigurationsAnyStroke(strokes_topology, candidate_lines, inds_non_assgnd_dpndnt_strks)) ) && ...
%            (confidence_threshold_reached > confidence_threshold_min) 
     while ((expectedNumberCandidateLines > thr_max_num_lines) && ...
            (confidence_threshold_reached > confidence_threshold_min))    

     fprintf('Thresholds reduction, expectedNumberCandidateLines %d \n',...
                expectedNumberCandidateLines);
        
            if (cur_stroke.ind == 81)
               disp('') ;
            end
        try
            [inds_non_assigned_strks,...
            max_costs,...
            confidence_vals,...
            confidence_threshold_reached] = ...
                    getNonAssigenedStrokesData(strokes_topology, max_cost_threshold, inds_non_assgnd_dpndnt_strks);
        catch e
            confidence_threshold = confidence_threshold_old;   
            rethrow(e);
        end
        
%         fprintf('inds_non_assigned_strks:'); disp(inds_non_assigned_strks);
        
         if isempty(inds_non_assigned_strks) | ...
           (confidence_threshold_reached < confidence_threshold_min)  | ...
           (strokes_topology(inds_non_assigned_strks(1)).score < max_cost_threshold)
            break;
        end

       [strokes_topology,...
        intersections,...
        expectedNumberCandidateLines] = ...
                assignOnePrevStrokeCheckCandidateLinesSimplified(cur_stroke.ind,...
                    strokes_topology,...
                    intersections,...
                    pairsInterInter,...
                    cam_param,...
                    inds_non_assigned_strks);
    end

    confidence_threshold = confidence_threshold_old;   

    end