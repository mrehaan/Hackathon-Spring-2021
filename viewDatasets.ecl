IMPORT $.getAll_Records;
Import std;

// View missing kids
OUTPUT(CHOOSEN(getAll_Records.Raw_MissingKids_Ds, 500), NAMED('Missing_kids'));


// View sex offernders
OUTPUT(CHOOSEN(getAll_Records.Raw_SexOffenders_Ds, 500), NAMED('Sex_offernders'));


// View US Cities
OUTPUT(CHOOSEN(getAll_Records.USCitiesInfo_Raw, 500), NAMED('US_Geo_Info'));


//missingKidsAppendLatLng := JOIN (getAll_Records.Raw_MissingKids_Ds, getAll_Records.USCitiesInfo_Raw, TRIM(Std.Str.ToUpperCase(LEFT.missingcounty), ALL) = TRIM(Std.Str.ToUpperCase(RIGHT.city), ALL) and right.state_id='GA');
MissingKidsLatLngLayout := RECORD
    getAll_Records.MissingKids_Rec;
    REAL lat;
    REAL lng;
    REAL8 NORTH;
    REAL8 SOUTH;
  	REAL8 WEST;
  	REAL8 EAST;
  
END;

INTEGER earthRadius := 3960;
REAL8 degrees_to_radians := 3.14/180.0;
REAL8 radians_to_degrees := 180/3.14;

REAL8 x := (30/earthRadius)*radians_to_degrees;



// Append lat and lng to missing kids and other calculations
missingKidsAppendDS := JOIN(getAll_Records.Raw_MissingKids_Ds, getAll_Records.USCitiesInfo_Raw, 
                            //Join Condition
                            TRIM(Std.Str.ToUpperCase(LEFT.missingcounty), ALL) = TRIM(Std.Str.ToUpperCase(RIGHT.city), ALL) and right.state_id='GA',
                            //transform
                            TRANSFORM(  MissingKidsLatLngLayout,
                                        SELF.lat := RIGHT.Lat,
                                        SELF.lng := RIGHT.Lng,
                                        SELF.NORTH := RIGHT.Lat+x;
                                        SELF.SOUTH := RIGHT.Lat-x;
                                        SELF.EAST := RIGHT.Lng+(30/earthRadius*cos(RIGHT.lat*degrees_to_radians))*radians_to_degrees;
                                        SELF.WEST := RIGHT.Lng-(30/earthRadius*cos(RIGHT.lat*degrees_to_radians))*radians_to_degrees;
                                        SELF := LEFT
                                        ));
                    OUTPUT(missingKidsAppendDS, NAMED('missingkidslatlong'));

  predatorAppendLatLng := JOIN (getAll_Records.Raw_SexOffenders_Ds, getAll_Records.USCitiesInfo_Raw, TRIM(Std.Str.ToUpperCase(LEFT.city), ALL) = TRIM(Std.Str.ToUpperCase(RIGHT.city), ALL) and right.state_id='GA');
  OUTPUT(predatorAppendLatLng, NAMED('predatorkidslatlong'));
  

 //inRangeLatLng := JOIN (getAll_Records.missingkidslatlong, getAll_Records.predatorkidslatlong, RIGHT.lat BETWEEN LEFT.SOUTH AND LEFT.NORTH and RIGHT.lng BETWEEN LEFT.WEST AND LEFT.EAST);
  
  inRangeLatLngLayout := RECORD
   
    predatorAppendLatLng;
    
    
    INTEGER SCORE;
 
END;

 inRangeLatLngKidsAppendDS := JOIN(missingKidsAppendDS,predatorAppendLatLng, 
                            RIGHT.lat BETWEEN LEFT.SOUTH AND LEFT.NORTH and RIGHT.lng BETWEEN LEFT.WEST AND LEFT.EAST,

                            //transform
                            TRANSFORM(inRangeLatLngLayout,
                                        
                                        
                                        SELF.Score := 50 +  IF(RIGHT.predator = 'PREDATOR', 50, 0) + IF(RIGHT.absconder = 'ABSCONDER',50,0) + IF(RIGHT.incarcerated = 'INCARCERATED',50,0) ;
                                        SELF := RIGHT;
                                      ),ALL);

           
                        
  OUTPUT(chooseN(inRangeLatLngKidsAppendDS,100), NAMED('inRangeLatLng'));

  kidsLatLngLayout := RECORD
   
   missingKidsAppendDS;
    
    
    INTEGER SCORE;
 
END;
  
   KidsAppendDS := JOIN(missingKidsAppendDS,predatorAppendLatLng, 
                            RIGHT.lat BETWEEN LEFT.SOUTH AND LEFT.NORTH and RIGHT.lng BETWEEN LEFT.WEST AND LEFT.EAST,

                            //transform
                            TRANSFORM(kidsLatLngLayout,
                                      SELF.Score := 50 +  IF(LEFT.CurrentAge BETWEEN 9 AND 17, 50, 0);
                                      SELF := LEFT;
                                      ),ALL);
 
                                    

                     OUTPUT(chooseN(KidsAppendDS,100), NAMED('kidsrangelat'));

              
