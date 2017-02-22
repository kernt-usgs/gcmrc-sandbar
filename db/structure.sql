# Dump of table AnalysisBins
# ------------------------------------------------------------

CREATE TABLE AnalysisBins (
  BinID int(11) NOT NULL AUTO_INCREMENT,
  Title varchar(50) NOT NULL,
  LowerDischarge double DEFAULT NULL,
  UpperDischarge double DEFAULT NULL,
  IsActive tinyint(1) NOT NULL DEFAULT '1',
  DisplayColor varchar(6) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy tinytext NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy tinytext NOT NULL,
  PRIMARY KEY (BinID),
  UNIQUE KEY IX_AnalysisBins_Title (Title),
  KEY IX_AnalysisBins_AddedOn (AddedOn),
  KEY IX_AnalysisBins_UpdatedOn (UpdatedOn)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table LookupListItems
# ------------------------------------------------------------

CREATE TABLE LookupListItems (
  ItemID int(11) NOT NULL AUTO_INCREMENT,
  ListID int(11) NOT NULL,
  Title varchar(50) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (ItemID),
  UNIQUE KEY UX_LookupListItems_Title (ListID,Title),
  KEY FK_LookupListItems_ListID_idx (ListID),
  KEY IX_LookupListItems_AddedOn (ListID,AddedOn),
  KEY IX_LookupListItems_UpdatedOn (ListID,UpdatedOn),
  CONSTRAINT FK_LookupListItems_ListID FOREIGN KEY (ListID) REFERENCES LookupLists (ListID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table LookupLists
# ------------------------------------------------------------

CREATE TABLE LookupLists (
  ListID int(11) NOT NULL AUTO_INCREMENT,
  Title tinytext NOT NULL,
  EditableByUser tinyint(1) DEFAULT '0',
  PRIMARY KEY (ListID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table ModelResultsBinned
# ------------------------------------------------------------

CREATE TABLE ModelResultsBinned (
  RunID int(11) NOT NULL,
  SectionID int(11) NOT NULL,
  BinID int(11) NOT NULL,
  Area double NOT NULL,
  Volume double NOT NULL,
  Area3D double DEFAULT NULL,
  PRIMARY KEY (RunID,SectionID,BinID),
  KEY FX_ModelResultsBinned_SectionID_idx (SectionID),
  KEY FX_ModelResultsBinned_BinID_idx (BinID),
  CONSTRAINT FX_ModelResultsBinned_BinID FOREIGN KEY (BinID) REFERENCES AnalysisBins (BinID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FX_ModelResultsBinned_RunID FOREIGN KEY (RunID) REFERENCES ModelRuns (MasterRunID) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT FX_ModelResultsBinned_SectionID FOREIGN KEY (SectionID) REFERENCES SandbarSections (SectionID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table ModelResultsIncremental
# ------------------------------------------------------------

CREATE TABLE ModelResultsIncremental (
  RunID int(11) NOT NULL,
  SectionID int(11) NOT NULL,
  Elevation double NOT NULL,
  Area double DEFAULT NULL,
  Volume double DEFAULT NULL,
  Area3D double DEFAULT NULL,
  ID int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (ID),
  KEY FK_ModelRunsIncremental_RunID_idx (RunID),
  CONSTRAINT FK_ModelRunsIncremental_RunID FOREIGN KEY (RunID) REFERENCES ModelRuns (MasterRunID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table ModelRuns
# ------------------------------------------------------------

CREATE TABLE ModelRuns (
  MasterRunID int(11) NOT NULL AUTO_INCREMENT,
  Title varchar(50) NOT NULL,
  Remarks varchar(1000) DEFAULT NULL,
  RunTypeID int(11) NOT NULL,
  Published tinyint(1) NOT NULL DEFAULT '0',
  InputXML longtext,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  InstallationGuid varchar(256) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  RunOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  RunBy varchar(50) DEFAULT NULL,
  PRIMARY KEY (MasterRunID),
  KEY IX_ModelRuns_AddedOn (AddedOn),
  KEY IX_ModelRuns_UpdatedOn (UpdatedOn),
  KEY IX_ModelRuns_RunOn (RunOn),
  KEY FK_ModelRuns_RunTypeID_idx (RunTypeID),
  CONSTRAINT FK_ModelRuns_RunTypeID FOREIGN KEY (RunTypeID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table Reaches
# ------------------------------------------------------------

CREATE TABLE Reaches (
  ReachID int(11) NOT NULL AUTO_INCREMENT,
  ReachCode varchar(10) NOT NULL,
  Title varchar(50) NOT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (ReachID),
  UNIQUE KEY ReachCode_UNIQUE (ReachCode),
  UNIQUE KEY Title_UNIQUE (Title),
  KEY IX_Reaches_AddedOn (AddedOn),
  KEY IX_Reaches_UpdatedOn (UpdatedOn)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table RemoteCameras
# ------------------------------------------------------------

CREATE TABLE RemoteCameras (
  CameraID int(11) NOT NULL AUTO_INCREMENT,
  RiverMile double NOT NULL,
  CameraRiverBankID int(11) NOT NULL,
  TargetRiverBankID int(11) NOT NULL,
  SiteCode4 varchar(10) DEFAULT NULL,
  SiteID int(11) DEFAULT NULL,
  SiteName varchar(50) NOT NULL,
  SiteCode varchar(10) NOT NULL,
  CurrentNPSPermit tinyint(1) NOT NULL DEFAULT '0',
  NAUName varchar(10) DEFAULT NULL,
  HavePhotos tinyint(1) DEFAULT '0',
  TheSubject varchar(50) DEFAULT NULL,
  TheView varchar(50) DEFAULT NULL,
  BestPhotoTime varchar(10) DEFAULT NULL,
  BeginFilmRecord varchar(10) DEFAULT NULL,
  EndFilmRecord varchar(10) DEFAULT NULL,
  BeginDigitalRecord varchar(10) DEFAULT NULL,
  EndDigitalRecord varchar(10) DEFAULT NULL,
  CardTypeID int(11) DEFAULT NULL,
  Remarks varchar(1000) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (CameraID),
  KEY FK_RemoteCameras_CameraRiverBankID_idx (CameraRiverBankID),
  KEY FK_RemoteCameras_TargetRiverBankID_idx (TargetRiverBankID),
  KEY FK_RemoteCameras_SiteID_idx (SiteID),
  KEY FK_RemoteCameras_CardTypeID_idx (CardTypeID),
  KEY IX_RemoteCameras_AddedOn (AddedOn),
  KEY IX_RemoteCameras_UpdatedOn (UpdatedOn),
  CONSTRAINT FK_RemoteCameras_CameraRiverBankID FOREIGN KEY (CameraRiverBankID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_RemoteCameras_CardTypeID FOREIGN KEY (CardTypeID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_RemoteCameras_SiteID FOREIGN KEY (SiteID) REFERENCES SandbarSites (SiteID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_RemoteCameras_TargetRiverBankID FOREIGN KEY (TargetRiverBankID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table SandbarSections
# ------------------------------------------------------------

CREATE TABLE SandbarSections (
  SectionID int(11) NOT NULL AUTO_INCREMENT,
  SurveyID int(11) NOT NULL,
  SectionTypeID int(11) NOT NULL,
  Uncertainty double NOT NULL DEFAULT '0',
  InstrumentID int(11) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (SectionID),
  KEY FK_SandbarSections_SectionID_idx (InstrumentID),
  KEY FK_SandbarSections_SectionTypeID_idx (SectionTypeID),
  KEY FK_SandbarSections_SurveyID_idx (SurveyID),
  KEY IX_SandbarSections_AddedOn (AddedOn),
  KEY IX_SandbarSections_UpdatedOn (UpdatedOn),
  CONSTRAINT FK_SandbarSections_InstrumentID FOREIGN KEY (InstrumentID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSections_SectionTypeID FOREIGN KEY (SectionTypeID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSections_SurveyID FOREIGN KEY (SurveyID) REFERENCES SandbarSurveys (SurveyID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table SandbarSites
# ------------------------------------------------------------

CREATE TABLE SandbarSites (
  SiteID int(11) NOT NULL AUTO_INCREMENT,
  SiteCode tinytext,
  SiteCode5 tinytext NOT NULL,
  RiverMile double NOT NULL,
  Title tinytext NOT NULL,
  AlternateTitle tinytext,
  History tinytext,
  ExpansionRatio8k double DEFAULT NULL,
  ExpansionRatio45k double DEFAULT NULL,
  StageChange8k45k double DEFAULT NULL,
  SecondaryGDAWS int(11) DEFAULT NULL,
  ReachID int(11) DEFAULT NULL,
  SegmentID int(11) DEFAULT NULL,
  CampsiteSurveyRecord tinytext,
  RemoteCameraID int(11) DEFAULT NULL,
  StageDischargeA double DEFAULT NULL,
  StageDischargeB double DEFAULT NULL,
  StageDischargeC double DEFAULT NULL,
  Northing double DEFAULT NULL,
  Easting double DEFAULT NULL,
  Latitude double DEFAULT NULL,
  Longitude double DEFAULT NULL,
  InitialSurvey date DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy tinytext NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy tinytext NOT NULL,
  RiverSideID int(11) NOT NULL,
  SiteTypeID int(11) NOT NULL,
  EddySize int(11) DEFAULT NULL,
  PrimaryGDAWS int(11) DEFAULT NULL,
  Remarks varchar(1000) DEFAULT NULL,
  PRIMARY KEY (SiteID),
  UNIQUE KEY IX_SiteCode5 (SiteCode5(5)),
  KEY FK_SandbarSites_RemoteCameraID_idx (RemoteCameraID),
  KEY FK_SandbarSites_ReachID_idx (ReachID),
  KEY FK_SandbarSites_SegmentID_idx (SegmentID),
  KEY IX_SandbarSites_AddedOn (AddedOn),
  KEY IX_SandbarSites_UpdatedOn (UpdatedOn),
  KEY FK_SandbarSites_RiverSideID_idx (RiverSideID),
  KEY FK_SandbarSites_SiteTypeID_idx (SiteTypeID),
  CONSTRAINT FK_SandbarSites_ReachID FOREIGN KEY (ReachID) REFERENCES Reaches (ReachID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSites_RemoteCameraID FOREIGN KEY (RemoteCameraID) REFERENCES RemoteCameras (CameraID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSites_RiverSideID FOREIGN KEY (RiverSideID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSites_SegmentID FOREIGN KEY (SegmentID) REFERENCES Segments (SegmentID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSites_SiteTypeID FOREIGN KEY (SiteTypeID) REFERENCES LookupListItems (ItemID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table SandbarSurveys
# ------------------------------------------------------------

CREATE TABLE SandbarSurveys (
  SurveyID int(11) NOT NULL AUTO_INCREMENT,
  SiteID int(11) NOT NULL,
  TripID int(11) NOT NULL,
  SurveyDate datetime NOT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (SurveyID),
  KEY FK_SandbarSurveys_SiteID_idx (SiteID),
  KEY FK_SandbarSurveys_TripID_idx (TripID),
  KEY IX_SandbarSurveys_SurveyDate (SurveyDate),
  KEY IX_SandbarSurveys_AddedOn (AddedOn),
  KEY IX_SandbarSurveys_UpdatedOn (UpdatedOn),
  CONSTRAINT FK_SandbarSurveys_SiteID FOREIGN KEY (SiteID) REFERENCES SandbarSites (SiteID) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT FK_SandbarSurveys_TripID FOREIGN KEY (TripID) REFERENCES Trips (TripID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table Segments
# ------------------------------------------------------------

CREATE TABLE Segments (
  SegmentID int(11) NOT NULL AUTO_INCREMENT,
  SegmentCode varchar(10) NOT NULL,
  Title varchar(50) NOT NULL,
  UpstreamRiverMile double NOT NULL,
  DownstreamRiverMile double NOT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (SegmentID),
  UNIQUE KEY SegmentCode_UNIQUE (SegmentCode),
  UNIQUE KEY Title_UNIQUE (Title),
  KEY IX_Segments_USRM (UpstreamRiverMile),
  KEY IX_Segments_DSRM (DownstreamRiverMile),
  KEY IX_Segments_AddedOn (AddedOn),
  KEY IX_Segments_UpdatedOn (UpdatedOn)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table StageDischarges
# ------------------------------------------------------------

CREATE TABLE StageDischarges (
  SampleID int(11) NOT NULL AUTO_INCREMENT,
  SiteID int(11) NOT NULL,
  SampleDate datetime DEFAULT NULL,
  SampleTime varchar(50) DEFAULT NULL,
  SampleCode varchar(50) DEFAULT NULL,
  ElevationLocal double DEFAULT NULL,
  ElevationSP double NOT NULL,
  SampleCount int(11) DEFAULT NULL,
  Flow double NOT NULL,
  FlowMS double NOT NULL,
  Comments varchar(255) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy varchar(50) NOT NULL,
  PRIMARY KEY (SampleID),
  KEY FX_StageDischarges_SiteID_idx (SiteID),
  CONSTRAINT FX_StageDischarges_SiteID FOREIGN KEY (SiteID) REFERENCES SandbarSites (SiteID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table TableChangeLog
# ------------------------------------------------------------

CREATE TABLE TableChangeLog (
  TableName varchar(50) NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Sequence int(11) NOT NULL,
  Synchronize int(11) NOT NULL,
  PRIMARY KEY (TableName),
  KEY IX_Sequence (Sequence),
  KEY IX_UpdatedOn (UpdatedOn)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table Trips
# ------------------------------------------------------------

CREATE TABLE Trips (
  TripID int(11) NOT NULL AUTO_INCREMENT,
  TripDate date NOT NULL,
  Remarks varchar(1000) DEFAULT NULL,
  AddedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  AddedBy tinytext NOT NULL,
  UpdatedOn datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedBy tinytext NOT NULL,
  PRIMARY KEY (TripID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table VersionChangeLog
# ------------------------------------------------------------

CREATE TABLE VersionChangeLog (
  DateOfChange datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Version int(11) NOT NULL,
  Description tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

