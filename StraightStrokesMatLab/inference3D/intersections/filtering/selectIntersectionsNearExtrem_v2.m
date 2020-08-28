function inds_intrscts_likely = ...
            selectIntersectionsNearExtrem_v2(indcs_intrsctns_prev_strks, ...
                                             distances_extrem, ...
                                             intersections)
global dist_endpoint;
global SHOW_FIGS_PREPROCESS;    
global debug_local; 
 


    
intersection_near_stroke_extrem = indcs_intrsctns_prev_strks(distances_extrem < dist_endpoint);

if SHOW_FIGS_PREPROCESS || debug_local
        plot(intersections.coordinates2D(intersection_near_stroke_extrem, 1),...
             intersections.coordinates2D(intersection_near_stroke_extrem, 2), '*c');    
end

mask_likely = intersections.likely(intersection_near_stroke_extrem);
mask_non_collinear = ~intersections.collinear(intersection_near_stroke_extrem)';

inds_intrscts_likely = [];

if sum(mask_likely&mask_non_collinear)
    try
    inds_intrscts_likely = intersection_near_stroke_extrem(mask_likely&mask_non_collinear);
    catch
        disp('');
    end
    if SHOW_FIGS_PREPROCESS || debug_local
        plot(intersections.coordinates2D(inds_intrscts_likely, 1),...
             intersections.coordinates2D(inds_intrscts_likely, 2), 'ob');    
    end
else
    %Strokes continuition:
%     inds_intrscts_likely = intersection_near_stroke_extrem;
%     inds_intrscts_likely = intersection_near_stroke_extrem(mask_non_collinear);
%     if SHOW_FIGS_PREPROCESS || debug_local
%         plot(intersections.coordinates2D(inds_intrscts_likely, 1),...
%              intersections.coordinates2D(inds_intrscts_likely, 2), 'ok');    
%     end
%     if SHOW_FIGS_PREPROCESS || debug_local
%         plot(intersections.coordinates2D(inds_intrscts_likely, 1),...
%              intersections.coordinates2D(inds_intrscts_likely, 2), 'om');    
%     end
% else
%     % No intersection near the end point is identified as likely:
%     inds_intrscts_likely = intersection_near_stroke_extrem;    
%     if SHOW_FIGS_PREPROCESS || debug_local
%          plot(intersections.coordinates2D(intersection_near_stroke_extrem, 1),...
%              intersections.coordinates2D(intersection_near_stroke_extrem, 2), 'og');          
%     end
end



% else 
%     intersection_near_stroke_extrem_likely = intersection_near_stroke_extrem(intersections.likely(intersection_near_stroke_extrem));
%     inds_intrsctng_strks_nr_strk_extrm_likely  = inds_intrsctng_strks_nr_strk_extrm(intersections.likely(intersection_near_stroke_extrem));
%     
%     inds_intrscts_prcdng_likely = intersection_near_stroke_extrem_likely(inds_intrsctng_strks_nr_strk_extrm_likely < stroke.ind);
%     inds_intrscts_prcdng_extrem = intersection_near_stroke_extrem(inds_intrsctng_strks_nr_strk_extrm < stroke.ind);
%     
%     if SHOW_FIGS_PREPROCESS
%             plot(intersections.coordinates2D(intersection_near_stroke_extrem_likely, 1),...
%                 intersections.coordinates2D(intersection_near_stroke_extrem_likely, 2), 'ob'); 
%             sls{end+1} = 'likely';
%     end
%         
%     if ~isempty(inds_intrscts_prcdng_likely)
%         if SHOW_FIGS_PREPROCESS
%             plot(intersections.coordinates2D(intersection_near_stroke_extrem_likely, 1),...
%                 intersections.coordinates2D(intersection_near_stroke_extrem_likely, 2), '*r'); 
%             sls{end+1} = 'likely prev strokes';
%         end        
%     elseif ~isempty(inds_intrscts_prcdng_extrem)
%        % Find the closest intersection to any likely intersection.
%        distances = zeros(length(inds_intrscts_prcdng_extrem),1);
%        intrsctns_lkl_crdnts = intersections.coordinates2D(intersections.likely,:);
%        
%        for i =1:length(inds_intrscts_prcdng_extrem)
%            vecs = (intrsctns_lkl_crdnts - intersections.coordinates2D(inds_intrscts_prcdng_extrem(i),:));
%            distances(i) = min(sum(vecs.^2,2)); %squared distance            
%        end
%        
%        [~, ind] = min(distances);
%        intersections.likely(inds_intrscts_prcdng_extrem(ind)) = true;
%        
%        
% %        intersections = ...
% %             addSecondCollinearIntersection(intersections, ...
% %                         inds_intrscts_prcdng_extrem(ind));
% %                     
%   
%        
%        
%        disp(intersections.strokes_indices(inds_intrscts_prcdng_extrem(ind),:))
%        disp(stroke.ind);
%            
%        if SHOW_FIGS_PREPROCESS
% 
%             plot(intersections.coordinates2D(inds_intrscts_prcdng_extrem(ind), 1),...
%                 intersections.coordinates2D(inds_intrscts_prcdng_extrem(ind), 2), 'oc'); 
%             sls{end+1} = 'near likely prev strokes';
%        end
%     else
%         %Just find any intersection with previous strokes:
%         % Find the closest intersection to any likely intersection.
%        indcs_intrsctns_prev_strokes =  stroke.indcs_intrsctns(stroke.indcs_intrsctng_strks < stroke.ind);
%        
%        if ~isempty(indcs_intrsctns_prev_strokes)
%        
%            distances = zeros(length(indcs_intrsctns_prev_strokes),1);
%            intrsctns_lkl_crdnts = intersections.coordinates2D(intersections.likely,:);
% 
%            for i =1:length(indcs_intrsctns_prev_strokes)
%                vecs = (intrsctns_lkl_crdnts - intersections.coordinates2D(indcs_intrsctns_prev_strokes(i),:));
%                distances(i) = min(sum(vecs.^2,2)); %squared distance            
%            end
% 
%            [~, ind] = min(distances);
%            intersections.likely(indcs_intrsctns_prev_strokes(ind)) = true;
%            
%             
% %             intersections = ...
% %                 addSecondCollinearIntersection(intersections, ...
% %                             indcs_intrsctns_prev_strokes(ind));
%                     
% %            disp(intersections.strokes_indices(indcs_intrsctns_prev_strokes(ind),:))
% %            disp(stroke.ind);
%            if SHOW_FIGS_PREPROCESS
% 
%                 plot(intersections.coordinates2D(indcs_intrsctns_prev_strokes(ind), 1),...
%                     intersections.coordinates2D(indcs_intrsctns_prev_strokes(ind), 2), 'oc'); 
%                 sls{end+1} = 'any near likely prev strokes';
%            end
%        end
%     end


end

