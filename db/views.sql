CREATE VIEW vw_areavolume
AS SELECT
   MR.ID AS id,
   S.SiteID AS site_id,
   MR.SectionID AS sandbar_id,'Eddy' AS calc_type,
   S.SurveyDate AS calc_date,
   MR.Elevation AS plane_height,
   MR.Elevation AS prev_plane_height,
   MR.Elevation AS next_plane_height,
   MR.Area AS area_2d_amt,NULL AS area_3d_amt,
   MR.Volume AS volume_amt
FROM (((ModelResultsIncremental MR join SandbarSections SS on((MR.SectionID = SS.SectionID))) join SandbarSurveys S on((S.SurveyID = SS.SurveyID))) join ModelRuns R on((MR.RunID = R.MasterRunID))) where ((R.Published <> 0));

CREATE VIEW vw_sitesections
AS SELECT
   S.SiteID AS SiteID,
   SS.SectionTypeID AS SectionTypeID
FROM (SandbarSections SS join SandbarSurveys S on((SS.SurveyID = S.SurveyID))) group by S.SiteID,SS.SectionTypeID;

CREATE VIEW vw_sectiontypecount
AS SELECT
   Sections.SiteID AS SiteID,count(Sections.SectionTypeID) AS SectionTypeCount,(case when (count(Sections.SectionTypeID) > 2) then 'SR' else NULL end) AS SectionType
FROM vw_sitesections Sections group by Sections.SiteID;

CREATE VIEW vw_site
AS SELECT
   S.SiteID AS ID,
   S.RiverMile AS river_mile,substr(L.Title,1,1) AS river_side,
   S.Title AS site_name,lpad(cast(S.PrimaryGDAWS as char charset utf8),8,'0') AS gdaws_site_id,
   S.SiteCode5 AS gcmrc_site_id,
   STC.SectionType AS deposit_type,
   S.EddySize AS eddy_size,
   S.ExpansionRatio8k AS exp_ratio_8000,
   S.ExpansionRatio45k AS exp_ratio_45000,
   S.StageChange8k45k AS stage_change,NULL AS sed_budget_reach,NULL AS cur_stage_relation,
   S.CampsiteSurveyRecord AS campsite,NULL AS geom,
   S.StageDischargeA AS stage_discharge_coeff_a,
   S.StageDischargeB AS stage_discharge_coeff_b,
   S.StageDischargeC AS stage_discharge_coeff_c,NULL AS photo_from,NULL AS photo_view,NULL AS flow_direction,NULL AS image_name,NULL AS image_name_med,NULL AS image_name_small,NULL AS p_month,NULL AS p_day,NULL AS p_year,NULL AS gdaws_site_display,lpad(cast(S.SecondaryGDAWS as char charset utf8),8,'0') AS secondary_gdaws_site_id,NULL AS second_gdaws_site_disp,
   S.Latitude AS latitude,
   S.Longitude AS longitude
FROM ((SandbarSites S join LookupListItems L on((S.RiverSideID = L.ItemID))) join vw_sectiontypecount STC on((S.SiteID = STC.SiteID)));


CREATE VIEW vw_survey
AS SELECT
   SS.SurveyID AS id,
   SS.SurveyDate AS survey_date,NULL AS survey_method,NULL AS uncrt_a_8000,NULL AS uncrt_b_8000,NULL AS discharge,
   T.TripDate AS trip_date,
   SS.SurveyDate AS calc_type,
   SS.SiteID AS site_id,
   S.SectionID AS sandbar_id
FROM ((SandbarSurveys SS join Trips T on((SS.TripID = T.TripID))) join SandbarSections S on((S.SurveyID = SS.SurveyID)));


CREATE VIEW vw_sandbar
AS SELECT
   SS.SectionID AS id,
   S.SiteID AS site_id,
   L.Title AS sandbar_name
FROM ((SandbarSections SS join SandbarSurveys S on((SS.SurveyID = S.SurveyID))) join LookupListItems L on((SS.SectionTypeID = L.ItemID))) group by id,site_id,sandbar_name;

CREATE VIEW vw_incrementalresults
AS SELECT
   S.SiteID AS SiteID,
   S.SurveyID AS SurveyID,
   S.SurveyDate AS SurveyDate,
   SS.SectionTypeID AS SectionTypeID,
   MR.Area AS Area,
   MR.Volume AS Volume,
   MR.Elevation AS Elevation
FROM (((ModelResultsIncremental MR join SandbarSections SS on((MR.SectionID = SS.SectionID))) join SandbarSurveys S on((SS.SurveyID = S.SurveyID))) join ModelRuns M on((MR.RunID = M.MasterRunID))) where ((M.Published <> 0));