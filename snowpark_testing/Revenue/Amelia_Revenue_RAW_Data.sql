(
select  
--t8.*,
--add mst time of the flight date for testing
TO_VARCHAR(TO_DATE(t8.DTM_LOCAL_ETD_DATE),'MM/DD/YYYY') AS "Flight Date",
--convert_timezone('UTC', 'MST', t8.DTM_FLIGHT_DATE) as "Flight MST Date",
--TO_VARCHAR(TO_DATE(t8.DTM_FLIGHT_DATE),'MM/DD/YYYY') AS "Flight Date",
--TO_VARCHAR(TO_TIME(t8.DTM_FLIGHT_DATE),'HH24:MI:SS') as "Flight time",
t1.LNG_RESERVATION_NMBR as "Reservation Nmbr",
t8.LNG_SKED_DETAIL_ID_NMBR AS  "Sked Detail Id Nmbr",
to_varchar(timeadd(hour,-7,t1.dtm_GL_Charges_Date),'MM/DD/YYYY HH12:MI:SS AM') as "Charge Date",
t9.STR_IDENT AS "Departure",
t10.STR_IDENT as "Arrival",
t1.LNG_RES_LEGS_ID_NMBR AS "Legs Id Nmbr",
t1.LNG_GL_CHARGE_TYPE_ID_NMBR as "Charge Type",
round(t1.MNY_GL_CHARGES_AMOUNT - t1.mny_GL_Charges_Discount ,2) as "Net Charge",
round(t1.MNY_GL_CHARGES_TAXES,2) as "Taxes",
round(t1.MNY_GL_CHARGES_TOTAL,2) as "Total Charge",
t5.STR_GL_CHARGE_TYPE_DESC as "Charge Type Desc",
t8.STR_FLIGHT_NMBR as "Flight Nmbr",
'100%' as "	Percent of Full Leg",
t1.STR_GL_CHARGES_DESC as "Charges Desc",
t1.LNG_CREATION_USER_ID_NMBR as "User Id Nmbr",
t4.LNG_LEG_NMBR as "Leg Nmbr",
t7.LNG_RES_SEGMENTS_ID_NMBR as "Segments Id Nmbr",
t6.LNG_AGENCY_ID_NMBR as "Agency Id Nmbr",
t3.STR_REF1 as "Reference",
t2.STR_CURRENCY_IDENT AS "Currency Ident",
t6.STR_AGENCY_NAME as "Agency Name",
t11.STR_USER_NAME as "Sales Username",
case 
    WHEN t23.str_country_desc = 'Canada' AND t24.str_country_desc = 'Canada' THEN 'Domestic'
    ELSE 'International'
end as "Transborder",
t4.STR_LEG_STATUS as "Leg Status",
case 
	when (t1.lng_GL_Charge_Type_Id_Nmbr = 4 OR (t1.lng_gl_charge_type_id_nmbr = 1028 AND STR_GL_CHARGES_DESC = 'Fare Rebate')) then 'Base'
	when t1.lng_GL_Charge_Type_Id_Nmbr in (2, 3, 6, 995, 996, 999, 1000, 1001, 1002, 1013) then 'Ancillary'
	when t1.lng_GL_Charge_Type_Id_Nmbr in (1, 5, 1009, 1010, 1012, 1016, 1018, 1019, 1020, 1021, 1022, 1023,1024,1025,1026,1027) then 'FlowThru'
	else 'Unassigned'
end as "Category",
case 
	when t1.lng_GL_Charge_Type_Id_Nmbr = 1 then 'Airport Improvement Fee' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr = 3 then 'Cancellation' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr = 4 then 'Fare' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr = 5 then 'Air Traveller Security Charge' -- OK

	when t1.lng_GL_Charge_Type_Id_Nmbr = 995 then 'No Show' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr IN (999,1005) AND (UPPER(t1.str_GL_Charges_Desc) like '%NON REFUNDABLE%' OR UPPER(t1.str_GL_Charges_Desc) like '%NON-REFUNDABLE%') then 'Non Refundable' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr = 1000 then 'Call Center Fee' -- OK
	when t1.lng_GL_Charge_Type_Id_Nmbr = 1001 then 'Seat Assignment' -- OK
			
	when (UPPER(t1.str_GL_Charges_Desc) like '%ACF%'
		) then 'ACF - Prepaid'
			
	when (UPPER(t1.str_GL_Charges_Desc) like '%GATE%'
		) then 'Carry On - Gate' 
			
	when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and UPPER(t1.str_GL_Charges_Desc) like '%CARRY ON%'
	) then 'Carry On' 
			
	when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%CHK BAG%' 
--				or UPPER(t1.str_GL_Charges_Desc) like '%CHECKED BAG%'
			or UPPER(t1.str_GL_Charges_Desc) like '%CHECKED%'
			or UPPER(t1.str_GL_Charges_Desc) like '%IN 1ST%'
			or UPPER(t1.str_GL_Charges_Desc) like '%IN 2ND%'
			or UPPER(t1.str_GL_Charges_Desc) like '%IN 3RD%'
			)
		) then 'Checked Bag' 
			
		when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%AIRPORT CHECKIN%')
		) then 'Airport Check-in' 
			
		when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%SPORT%' 
			or UPPER(t1.str_GL_Charges_Desc) like '%GOLF%'
			or UPPER(t1.str_GL_Charges_Desc) like '%HOCKEY%'
			or UPPER(t1.str_GL_Charges_Desc) like '%BICYCLE%'
			or UPPER(t1.str_GL_Charges_Desc) like '%SNOWBOARD%'
			)
		) then 'Sports' 
			
		when (
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%PRIORITY%')
		) then 'Priority Boarding' 
			
		when (
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%PET IN%')
		) then 'Pet in Cabin' 
			
		when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002) 
		and (UPPER(t1.str_GL_Charges_Desc) like '%OVERWEIGHT%' 
		or UPPER(t1.str_GL_Charges_Desc) like '%OVERSIZE%'
		or UPPER(t1.str_GL_Charges_Desc) like '%EXCESS%')
		) then 'Misc Bag Charges' 
			
			
			
	    when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (
		UPPER(t1.str_GL_Charges_Desc) like '%BASIC BUNDLE%'
		or UPPER(t1.str_GL_Charges_Desc) like '%BASIC B%'
		)
		) then 'Basic Bundle' 
			
		when (-- OK
		t1.lng_GL_Charge_Type_Id_Nmbr in (2, 1002)
		and (UPPER(t1.str_GL_Charges_Desc) like '%BIG BUNDLE%'
		or UPPER(t1.str_GL_Charges_Desc) like '%BIG B%'
		)
		) then 'Big Bundle' 
			
		when (
		t1.lng_GL_Charge_Type_Id_Nmbr in (1002, 1013,998)
		and (UPPER(t1.str_GL_Charges_Desc) like '%TRAVELFLE%' or UPPER(t1.str_GL_Charges_Desc) like '%TRAVEL FLE%')
		) then 'TravelFLEX' 
			
		when UPPER(t1.str_GL_Charges_Desc) like '%NAME%' then 'Name Change' -- OK
			
		when UPPER(t1.str_GL_Charges_Desc) like '%GROUP BOOKING%' then 'Group Booking Fee' -- OK
			
		when t1.lng_GL_Charge_Type_Id_Nmbr = 6 OR UPPER(t1.str_gl_charges_desc) like '%change fee%' OR UPPER(t1.str_gl_charges_desc) like 'change fee%' OR t1.lng_GL_Charge_Type_Id_Nmbr = 1013 then 'Modification Fee' -- OK

        when t1.lng_GL_Charge_Type_Id_Nmbr = 2 then 'Airport Bags' -- OK
			
		when t1.lng_GL_Charge_Type_Id_Nmbr in (1009, 1010, 1012, 1016, 1018, 1019, 1020, 1021, 1022, 1023,1024,1025,1026,1027) then t5.str_GL_Charge_Type_Desc
        when t1.lng_GL_Charge_Type_Id_Nmbr = 1002 and t5.str_GL_Charge_Type_Desc = 'SSR' then 'SSR'
	     else 'Unassigned'          
end as "Ancillary Category",
case 
	when "Category" in ('Base', 'FlowThru', 'Unassigned') then 0
	when t1.mny_GL_Charges_Amount < 0 then -1 -- Refund txn, net off the previous count
	when (t1.mny_GL_Charges_Amount = 0 and t1.bit_Fully_Paid =1) then 1 
	when (t1.mny_GL_Charges_Amount = 0 and t1.bit_Fully_Paid !=1) then 0 -- 
	when t1.mny_GL_Charges_Amount > 1 then 1
	else 0 -- Unassigned
end as "Purchase Cnt",
CASE 
	 WHEN t23.str_country_desc = 'Canada' AND t24.str_country_desc = 'Canada' and t8.mny_Distance < 800 THEN 'Short Haul'
	 WHEN t23.str_country_desc = 'Canada' AND t24.str_country_desc = 'Canada' and t8.mny_Distance > 800 AND t8.mny_Distance < 1600 THEN 'Mid Stage'
	 WHEN t23.str_country_desc = 'Canada' AND t24.str_country_desc = 'Canada' and t8.mny_Distance > 1600 and t8.mny_Distance < 9000  THEN 'Long Haul'
     WHEN t8.LNG_DEP_AIRPORT_ID_NMBR in (18,55,57,59,65,66) or t8.LNG_ARR_AIRPORT_ID_NMBR in (18,55,57,59,65,66) then 'International'
     ELSE 'Sun'
END AS "Classification",
case 
    when t6.lng_Agency_Id_Nmbr in ('1','8','275') then 'Direct'
	else 'InDirect' 
end as "Channel"
from 
(
SELECT * FROM (SELECT
LNG_RESERVATION_NMBR,
DTM_GL_CHARGES_DATE,
LNG_RES_LEGS_ID_NMBR ,
LNG_GL_CHARGE_TYPE_ID_NMBR,
MNY_GL_CHARGES_AMOUNT,
MNY_GL_CHARGES_TAXES,
MNY_GL_CHARGES_TOTAL,
LNG_CREATION_USER_ID_NMBR,
STR_GL_CHARGES_DESC,
BIT_FULLY_PAID ,
LNG_CURRENCY_ID_NMBR,
MNY_GL_CHARGES_DISCOUNT,
LNG_LAST_MOD_USER_ID_NMBR,
LNG_GL_CHARGES_ID_NMBR,
	CAST(EFFECTIVE_START_DATE AS DATE),
	ROW_NUMBER() OVER (PARTITION BY LNG_GL_CHARGES_ID_NMBR
ORDER BY
	EFFECTIVE_START_DATE DESC) RN
FROM
	STAGE_DEV.AMELIA_DBO.STG_GL_CHARGES
WHERE
	1=1
	--AND LNG_GL_CHARGES_ID_NMBR = 117781698
	AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01'
	--AND	LNG_RESERVATION_NMBR= :RESRV_NMBR
	)
WHERE RN=1) t1
--from STAGE_DEV.AMELIA_DBO.STG_GL_CHARGES t1
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_CURRENCY_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_CURRENCY WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t2 on t2.LNG_CURRENCY_ID_NMBR = t1.LNG_CURRENCY_ID_NMBR and t2._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_RESERVATION_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_RES_HEADER WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t3 on t3.LNG_RESERVATION_NMBR = t1.LNG_RESERVATION_NMBR and t3._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_RES_LEGS_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_RES_LEGS WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t4 on t4.LNG_RES_LEGS_ID_NMBR = t1.LNG_RES_LEGS_ID_NMBR and t4._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_GL_CHARGE_TYPE_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_GL_CHARGE_TYPE_DEFINITION WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t5 on t5.LNG_GL_CHARGE_TYPE_ID_NMBR=t1.LNG_GL_CHARGE_TYPE_ID_NMBR and t5._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_AGENCY_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_AGENCY WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t6 on t6.LNG_AGENCY_ID_NMBR = t3.LNG_AGENCY_ID_NMBR and t6._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_RES_LEGS_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_RES_SEGMENTS WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t7 on t7.LNG_RES_LEGS_ID_NMBR = t4.LNG_RES_LEGS_ID_NMBR and t7._fivetran_deleted = FALSE --and CAST(t1.DTM_GL_CHARGES_DATE AS DATE) = CAST(t7.DTM_CREATION_DATE AS DATE))
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_SKED_DETAIL_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_SKED_DETAIL WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t8 on t8.LNG_SKED_DETAIL_ID_NMBR = t7.LNG_SKED_DETAIL_ID_NMBR and t8._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_AIRPORT_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_AIRPORT WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t9 on t9.LNG_AIRPORT_ID_NMBR = t8.LNG_DEP_AIRPORT_ID_NMBR and t9._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_AIRPORT_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_AIRPORT WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t10 on t10.LNG_AIRPORT_ID_NMBR = t8.LNG_ARR_AIRPORT_ID_NMBR and t10._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY lng_User_Id_Nmbr ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_USERS WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t11 ON t1.lng_Creation_User_Id_Nmbr  = t11.lng_User_Id_Nmbr and t11._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY lng_Province_Id_Nmbr ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_PROVINCE_DEFINITION WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t18 ON t9.lng_Province_Id_Nmbr = t18.lng_Province_Id_Nmbr and t18._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY lng_Province_Id_Nmbr ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_PROVINCE_DEFINITION WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t19 ON t10.lng_Province_Id_Nmbr = t19.lng_Province_Id_Nmbr and t19._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_COUNTRY_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_COUNTRY WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t23 ON t23.LNG_COUNTRY_ID_NMBR = t18.LNG_COUNTRY_ID_NMBR and t23._fivetran_deleted = FALSE
left join (SELECT * FROM (SELECT	CAST(EFFECTIVE_START_DATE AS DATE),	ROW_NUMBER() OVER (PARTITION BY LNG_COUNTRY_ID_NMBR ORDER BY EFFECTIVE_START_DATE DESC) RN,* FROM STAGE_DEV.AMELIA_DBO.STG_COUNTRY WHERE 1=1 AND CAST(EFFECTIVE_START_DATE AS DATE) <= '9999-01-01' ) WHERE RN=1) t24 ON t24.LNG_COUNTRY_ID_NMBR = t19.LNG_COUNTRY_ID_NMBR and t24._fivetran_deleted = FALSE
WHERE 1=1  
AND t3.str_cax_reason not in ('Hold On Reservation Expired')
and t5.str_GL_Charge_Type_Desc not in ('Balance Charge')
and "Flight Date"= '09/10/2023'
-- and t1.LNG_RESERVATION_NMBR= :RESRV_NMBR
)
  