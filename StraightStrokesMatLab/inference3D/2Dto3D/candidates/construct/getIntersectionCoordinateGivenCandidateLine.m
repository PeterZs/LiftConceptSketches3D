% function [inter_coord_3D, intersections] = ...
%                 getIntersectionCoordinateGivenCandaiteLine(strokes_topology, ...
%                                                            intersections, ...
%                                                            cam_param,...
%                                                            ind_hypoth_inter,...
%                                                            ind_hypoth_stroke,...
%                                                            hj)
% Description:
%   Estimates the exact intersections posotion in 3D given candidate line
%   3D prior.
%   Saves the 3D intersection into the intersections data structure.

function [inter_coord_3D, intersections] = ...
                getIntersectionCoordinateGivenCandidateLine(strokes_topology, ...
                                                           intersections, ...
                                                           cam_param,...
                                                           ind_hypoth_inter,...
                                                           ind_hypoth_stroke,...
                                                           hj)
            
    [inter_coord_3D, ~] = ...
        opt3Dpos2DProj( cat(1,intersections(ind_hypoth_inter).coordinates2D), cam_param, ...
                        strokes_topology(ind_hypoth_stroke).candidate_lines(hj).coordinates3D_prior(1, 1:3), ...
                        strokes_topology(ind_hypoth_stroke).candidate_lines(hj).coordinates3D_prior(1, 4:6));


    intersections(ind_hypoth_inter).cnddts3D(hj).coordinates3D = inter_coord_3D;

    intersections(ind_hypoth_inter).cnddts3D(hj).cnddt_lns = cell(2,1);

    intersections(ind_hypoth_inter).cnddts3D(hj).cnfgrtns = cell(2,1);

end