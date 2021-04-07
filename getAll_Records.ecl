EXPORT getAll_Records := MODULE
  
   //*****************************************************************************
   //*****************************************************************************

   // Missing children in GA in Jan 2021
   EXPORT MissingKids_Rec := RECORD
        STRING 		FullName;		// Missing child full name
        STRING 		PublishedDate;	// Date information was published
        STRING 		PageLink;		// Link to the child missing page
        INTEGER	 	CurrentAge;		// Child's today's age
        STRING 		MissingDate;	// Date the child went missing
        STRING 		MissingCounty;	// County the child was kidnapped 
        STRING 		CountyPolice;	// Cpounty police to contacting 
    END;


    EXPORT Raw_MissingKids_Ds := DATASET('~raw::missingkids.csv', MissingKids_Rec, CSV(HEADING(1)));



    //*****************************************************************************
    //*****************************************************************************

    // Sex offenders 
    EXPORT SexOffen_Rec := RECORD
        STRING 		NAME;
        STRING 		SEX;
        STRING 		RACE;
        STRING 		YEAROFBIRTH;
        INTEGER		HEIGHT;
        INTEGER		WEIGHT;
        STRING 		HAIRCOLOR;
        STRING 		EYECOLOR;
        STRING 		STREETNUMBER;
        STRING 		STREET;
        STRING 		CITY;
        STRING2		STATE;
        STRING5		ZIPCODE;
        STRING 		COUNTY;
        STRING8		REGISTRATIONDATE;
        STRING 		CRIME;
        STRING8		CONVICTIONDATE;
        STRING 		CONVICTIONSTATE;
        STRING 		INCARCERATED;
        STRING 		PREDATOR;
        STRING 		ABSCONDER;
        STRING8		RESVERIFICATIONDATE;
        STRING 		LEVELING;
    END;

    EXPORT Raw_SexOffenders_Ds := DATASET('~raw::sexoffenders.csv', SexOffen_Rec, CSV(Heading(1)));

    //*****************************************************************************
    //*****************************************************************************
     
    // US Cities, Counties, and FIPs Dataset
	EXPORT USCitiesInfo_Rec := RECORD
      STRING		City;			// The name of the city/town.
      STRING		City_ascii;		// city as an ASCII string.
      STRING2		State_id;		// The state or territory's USPS postal abbreviation.
      STRING		State_name;		// The name of the state or territory that contains the city/town.
      INTEGER		County_fips;	// The 5-digit FIPS code for the primary county. The first two digits correspond to the state's FIPS code.
      STRING		County_name;	// The name of the primary county (or equivalent) that contains the city/town.	
      REAL			Lat;			// The latitude of the city/town.
      REAL			Lng;			// The longitude of the city/town.
      INTEGER		Population;		// The 5-digit FIPS code for all counties that overlap the city/town (e.g. 04013|04021)
      INTEGER		Density;		// An estimate of the city's urban population. (2019).
      STRING		Source;			// For some cities, our data is generated from a polygon representing the city, for others we simply have a point.
      BOOLEAN 		Military;		// TRUE if this place is a military establishment such as a fort or base.
      BOOLEAN 		Incorporated; 	// TRUE if the place is a city/town. FALSE if the place is just a commonly known name for a populated area.
      STRING		Timezone;		// The city's time zone in the tz database format. (e.g. America/Los_Angeles)
      INTEGER		Ranking;		// An integer from 1-5 that captures the importance of a city (1 is most important, 5 least important).
      STRING		Zips;			// A string containing all five-digit zip codes in the city/town, delimited by a space.
      INTEGER		ID;				// A 10-digit unique id generated by SimpleMaps. It is consistent across releases and databases
	END;
   
	EXPORT USCitiesInfo_Raw := DATASET('~raw::us::cities::information.csv', USCitiesInfo_Rec, CSV(HEADING(1)));

END;
