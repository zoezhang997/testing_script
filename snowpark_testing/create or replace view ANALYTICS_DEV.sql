create or replace view ANALYTICS_DEV.FRAUD_DETECTION.VW_FRAUD_PAX(
	LNG_RES_LEGS_ID_NMBR,
	LNG_RESERVATION_NMBR,
	STR_EMAIL,
	LNG_PAX_ID_NMBR,
	DTM_DATE,
	FLIGHTDATE,
	STR_FIRST_NAME,
	STR_LAST_NAME,
	STR_SPEC_NEEDS,
	STR_CONTACT_EMAIL,
	STR_CONTACT_NAME,
	STR_REF1,
	DTM_DOB_DATE,
	STR_PASSPORT_COUNTRY_CODE,
	STR_GENDER,
	STR_HOME_TEL,
	STR_NAME_KEY,
	DTM_PASSPORTEXPIRY_DATE,
	DTM_PASSPORT_ISSUED_DATE,
	TRIP_DEP_AIRPORT,
	TRIP_ARR_AIRPORT,
	LNG_AGENCY_ID_NMBR,
	STR_AGENCY_NAME,
	DOMAIN,
	BOOKING_STATUS,
	PAX_STATUS,
	FLOWN_STATUS,
	KEYWORDS,
	PAYMENT_METHOD,
	STR_GL_CARD_NMBR,
	FIRST_6_DIGITS,
	LAST_4_DIGITS,
	STR_GL_PAYMENTS_PAYER,
	STR_POSTAL_CODE,
	STR_ADDR1,
	STR_ADDR2,
	STR_CITY,
	STR_TEL,
	EMAIL_FLAG_SUSPECTED,
	PROMO,
	EMAIL_DOMAIN,
	EMAIL_DOMAIN_FINAL,
	BOOKING_DATE,
	BOOKING_TIMESTAMP,
	KEY,
	CHARGES_TOTAL,
	AMOUNT,
	DISCOUNT
) as


select
    t4.LNG_RES_LEGS_ID_NMBR,
    t4.lng_reservation_nmbr,
    t27.STR_EMAIL,
    t27.LNG_PAX_ID_NMBR,
    CAST(t4.dtm_date as date) as dtm_date,
    CAST(t12.dtm_local_etd_date as date) as FlightDate,
    -- cast(dtm_gl_charges_date as date) as charge_date,
    UPPER(REPLACE(STR_FIRST_NAME, ',', ' ')) AS STR_FIRST_NAME,
    UPPER(REPLACE(STR_LAST_NAME, ',', ' ')) AS STR_LAST_NAME,
    t8.STR_SPEC_NEEDS,
    t8.STR_CONTACT_EMAIL,
    UPPER(REPLACE(t8.STR_CONTACT_NAME, ',', ' ')) AS STR_CONTACT_NAME,
    t8.str_Ref1,
    DTM_DOB_DATE,
    STR_PASSPORT_COUNTRY_CODE,
    STR_GENDER,
    STR_HOME_TEL,
    UPPER(REPLACE(STR_NAME_KEY, ',', ' ')) AS STR_NAME_KEY,
    DTM_PASSPORTEXPIRY_DATE,
    DTM_PASSPORT_ISSUED_DATE,
    t5.str_Ident as trip_Dep_Airport,
    t6.str_Ident as trip_Arr_Airport,
    t8.lng_Agency_Id_Nmbr,
    t9.str_Agency_Name,
    case when UPPER(t27.STR_EMAIL) like '%MAILNESIA%' then '1. Mailnesia'
    when UPPER(t27.STR_EMAIL) like '%BYTELEADING%' then '2. Byteleading'
    when UPPER(t27.STR_EMAIL) like '%CANADAMOOSES%' then '3. Canadamooses'
    when UPPER(t27.STR_EMAIL) like '%SKYISTHECAP%' then '4. Skyisthecap'
    when UPPER(t27.STR_EMAIL) like '%TTJIPIAO.TOP%' then '5. Ttjipiao.top'
    else 'Other' end as Domain,
     CASE 
       
       WHEN t11.str_Res_Status = 'C' then 'Confirmed' 
       WHEN t11.str_Res_Status = 'N' then 'No Show'
       WHEN t11.str_Res_Status = 'P' then 'Pending Confirmed'
       WHEN t11.str_Res_Status = 'Q' then 'Pending Standby'
       WHEN t11.str_Res_Status = 'R' then 'Pending Waitlisted'
       WHEN t11.str_Res_Status = 'S' then 'Standby'
       WHEN t11.str_Res_Status = 'W' then 'Waitlisted'
       WHEN t11.str_Res_Status = 'X' then 'Cancelled'
       when t8.str_cax_reason not in ('Hold On Reservation Expired') then 'Hold On Reservation Expired'
       ELSE 'Other' END as booking_status,
       CASE 
       when booking_status in ('Cancelled','Hold On Reservation Expired') then 'Cancelled'
       WHEN t11.str_res_checkin_boarded = 'X' THEN 'No Show'
               WHEN t11.str_res_checkin_boarded = 'B' THEN 'Boarded'
               WHEN t11.str_res_checkin_boarded = 'C' THEN 'Checked In'
               WHEN t11.str_res_checkin_boarded = 'N' THEN 'Not Checked In'
               ELSE 'Cancelled' END as Pax_Status,
                CASE when pax_status in ('Cancelled') then 'Cancelled'
        	WHEN t11.str_res_checkin_boarded = 'B' 
        		AND t11.str_res_status = 'C'
        		THEN 'Flown'
                when Pax_Status = 'Not Checked In' and t11.str_res_checkin_boarded <> 'B' 
        		AND t11.str_res_status <> 'C' then 'Not Checked In'
                when Pax_Status = 'Checked In' and t11.str_res_checkin_boarded <> 'B' 
        		AND t11.str_res_status <> 'C' then 'Checked In'
                WHEN t11.str_res_status = 'N' AND Pax_Status = 'Not Checked In' then 'No Show'
        	ELSE 'Cancelled'
        END AS flown_status,
    case 
    when UPPER(t8.STR_SPEC_NEEDS) like '%CHARGEBACK%' then 'CB'
    when UPPER(t8.STR_SPEC_NEEDS) like '%FRAUD%' then 'Fraud'
    when UPPER(t8.STR_SPEC_NEEDS) like '%APC%' then 'APC'
    when UPPER(t8.STR_SPEC_NEEDS) like '%GROUP FRAUD%' then 'Group Fraud'
    when UPPER(t8.STR_SPEC_NEEDS) like '%KIWI%' then 'Kiwi'
    else 'Other' end as keywords,
    PAYMENT_METHOD,
    STR_GL_CARD_NMBR,
    FIRST_6_DIGITS,
    LAST_4_DIGITS,
    UPPER(REPLACE(STR_GL_PAYMENTS_PAYER, ',', ' ')) AS STR_GL_PAYMENTS_PAYER,
    t27.STR_POSTAL_CODE,
    t27.STR_ADDR1,
    t27.STR_ADDR2,
    t27.STR_CITY,
    t27.STR_TEL,
    CASE WHEN t8.STR_CONTACT_EMAIL in ('cherdavinodell2143@gmail.com',
'fba002@mailnesia.com',
'Olayinkasodunke11@yahoo.com',
'fba001@mailnesia.com',
'shemiraniamirhuosein@mailnesia.com',
'vmprebkplzp@hotmail.com',
'parislovemontreal@gmail.com',
'feudisis@gmail.com',
'malick.pro.thiam@gmail.com',
'jahnya.sz@yahoo.ca',
'fgzsfhjouyrdvjiutdchu@gmail.com',
'singhjagpreet96@gmail.com',
'philipernest_en3@gmail.com',
'jnikkokris@gmail.com',
'nathgd87@gmail.com',
'sassa47@outlook.com',
'zazaza1954@outlook.com',
'schanpreetsan1345@gmail.com',
'xgad@trip.com',
'qijiandian@vip.163.com') then 'Suspected Emails' else 'Other' end email_flag_suspected,
CASE WHEN t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('1282') then 'CFLAIR25'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30763') then 'FLAIR2197'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30746') then 'Promo Code: 30746'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30771') then 'Promo Code: 30771'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30752') then 'Promo Code: 30752'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30755') then 'Promo Code: 30755'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30754') then 'Promo Code: 30754'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30713') then 'Promo Code: 30713'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30769') then 'Promo Code: 30769'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30759') then 'Promo Code: 30759'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30760') then 'Promo Code: 30760'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30765') then 'Promo Code: 30765'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30764') then 'Promo Code: 30764'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30692') then 'Promo Code: 30692'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30729') then 'Promo Code: 30729'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30758') then 'Promo Code: 30758'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('30691') then 'Promo Code: 30691'
when t4.LNG_PROMO_CODE_DEFINITION_ID_NMBR in ('-1') then 'No Promo Used'
else 'Other' end as promo,
SUBSTRING(t27.STR_EMAIL, CHARINDEX('@', t27.STR_EMAIL) + 1, LEN(t27.STR_EMAIL) - CHARINDEX('@', t27.STR_EMAIL)) AS email_domain,
    SUBSTRING(t8.STR_CONTACT_EMAIL, CHARINDEX('@', t8.STR_CONTACT_EMAIL) + 1, LEN(t8.STR_CONTACT_EMAIL) - CHARINDEX('@', t8.STR_CONTACT_EMAIL)) AS email_domain_final,
    CAST(t26.dtm_creation_date as date) AS booking_date,
    t26.dtm_creation_date as booking_timestamp,
    concat(str_contact_name,' ', dtm_dob_date, ' ', TRIM(trip_Dep_Airport) ,' ', TRIM(trip_Arr_Airport)) key,
    sum(MNY_GL_CHARGES_TOTAL) as charges_total,
    sum(MNY_GL_CHARGES_AMOUNT) as amount,
    sum(MNY_GL_CHARGES_DISCOUNT) as discount
FROM (SELECT * FROM STAGE_PROD.amelia_dbo.vw_gl_charges where active_flag = 'Y') AS t1

left join (SELECT * FROM STAGE_PROD.amelia_dbo.vw_res_legs WHERE ACTIVE_FLAG = 'Y') as t4 
ON t1.lng_Res_Legs_Id_Nmbr = t4.lng_Res_Legs_Id_Nmbr

left join (SELECT * FROM STAGE_PROD.amelia_dbo.vw_res_pax_group WHERE ACTIVE_FLAG = 'Y') as t26 
on t4.lng_res_pax_group_id_nmbr = t26.lng_res_pax_group_id_nmbr

left join (SELECT * FROM STAGE_PROD.AMELIA_DBO.vw_PAX WHERE ACTIVE_FLAG = 'Y') t27
on  t26.LNG_PAX_ID_NMBR = t27.LNG_PAX_ID_NMBR

LEFT JOIN (SELECT * FROM STAGE_PROD.amelia_dbo.vw_res_header WHERE ACTIVE_FLAG = 'Y') AS t8 
ON t4.lng_Reservation_Nmbr = t8.lng_Reservation_Nmbr

LEFT JOIN (SELECT * FROM STAGE_PROD.amelia_dbo.vw_agency WHERE ACTIVE_FLAG = 'Y') AS t9 
ON t8.lng_Agency_Id_Nmbr = t9.lng_Agency_Id_Nmbr

left join (SELECT * FROM STAGE_PROD.amelia_dbo.vw_res_segments where active_flag = 'Y') t11
on t4.LNG_RES_LEGS_ID_NMBR = t11.LNG_RES_LEGS_ID_NMBR

left join (SELECT * FROM STAGE_PROD.amelia_dbo.vw_sked_detail where active_flag = 'Y') t12
on t11.lng_Sked_Detail_Id_Nmbr = t12.lng_Sked_Detail_id_Nmbr


left join 
(
        SELECT distinct 
        TBL_GL_PAYMENTS.LNG_RESERVATION_NMBR 
        , TBL_GL_PAYMENTS.LNG_RES_PAX_GROUP_ID_NMBR 
        , TBL_GL_PAYMENTS.MNY_GL_PAYMENTS_AMOUNT AS PAYMENT_AMOUNT
        , TBL_GL_PAYMENTS.DTM_CREATION_DATE AS PAYMENT_DATE
        , TBL_GL_PAYMENT_METHOD.STR_GL_PAYMENT_METHOD_DESC AS PAYMENT_METHOD
        , CONCAT('', CAST(RIGHT(TBL_GL_CREDITCARD_PAYMENT.STR_GL_CARD_NMBR, 4) AS VARCHAR)) AS LAST_4_DIGITS
        ,CONCAT('', CAST(LEFT(TBL_GL_CREDITCARD_PAYMENT.STR_GL_CARD_NMBR, 6) AS VARCHAR)) AS FIRST_6_DIGITS
        ,STR_GL_CARD_NMBR
        ,STR_GL_PAYMENTS_PAYER
        -- ,str_orderid
        -- ,str_ccreason
        FROM  (SELECT * FROM STAGE_PROD.amelia_dbo.vw_gl_payments where active_flag = 'Y') TBL_GL_PAYMENTS
        
        left JOIN  (SELECT * FROM STAGE_PROD.amelia_dbo.vw_gl_payment_method where active_flag = 'Y') as TBL_GL_PAYMENT_METHOD 
        ON TBL_GL_PAYMENTS.LNG_GL_PAYMENT_METHOD_ID_NMBR = TBL_GL_PAYMENT_METHOD.LNG_GL_PAYMENT_METHOD_ID_NMBR 
        
        LEFT JOIN (SELECT * FROM STAGE_PROD.amelia_dbo.vw_gl_payment_cc_xref where active_flag = 'Y') as TBL_GL_PAYMENT_CC_XREF 
        ON TBL_GL_PAYMENTS.LNG_GL_PAYMENTS_ID_NMBR = TBL_GL_PAYMENT_CC_XREF.LNG_GL_PAYMENTS_ID_NMBR 
        
        left JOIN  (SELECT * FROM STAGE_PROD.amelia_dbo.vw_gl_creditcard_payment where active_flag = 'Y') TBL_GL_CREDITCARD_PAYMENT 
        ON  TBL_GL_PAYMENT_CC_XREF.LNG_GL_CREDITCARD_PAYMENT_ID_NMBR = TBL_GL_CREDITCARD_PAYMENT.LNG_GL_CREDITCARD_PAYMENT_ID_NMBR 

        -- left join (SELECT * FROM STAGE_PROD.amelia_dbo.vw_cc_track where active_flag = 'Y') TBL_cc_track
        -- ON  TBL_GL_PAYMENTS.lng_reservation_nmbr = TBL_cc_track.lng_reservation_nmbr
) t30
on TRIM(t26.lng_res_pax_group_id_nmbr) = TRIM(t30.lng_res_pax_group_id_nmbr)
and t26.lng_reservation_nmbr = t30.lng_reservation_nmbr

LEFT JOIN (SELECT * FROM STAGE_PROD.amelia_dbo.vw_airport WHERE ACTIVE_FLAG = 'Y') AS t5 ON t4.lng_Dep_Airport_Id_Nmbr = t5.lng_Airport_Id_Nmbr
LEFT JOIN (SELECT * FROM STAGE_PROD.amelia_dbo.vw_airport WHERE ACTIVE_FLAG = 'Y') AS t6 ON t4.lng_Arr_Airport_Id_Nmbr = t6.lng_Airport_Id_Nmbr

where 1 = 1
and CAST(t26.dtm_creation_date as date) >= '2023-08-01'
group by t4.LNG_RES_LEGS_ID_NMBR,
t4.lng_reservation_nmbr,
    t27.STR_EMAIL,
    t27.LNG_PAX_ID_NMBR,
    dtm_date,
    FlightDate,
    -- charge_date,
    STR_FIRST_NAME,
    STR_LAST_NAME,
    t8.STR_SPEC_NEEDS,
    t8.STR_CONTACT_EMAIL,
    t8.STR_CONTACT_NAME,
    t8.str_Ref1,
    DTM_DOB_DATE,
    STR_PASSPORT_COUNTRY_CODE,
    STR_GENDER,
    STR_HOME_TEL,
    STR_NAME_KEY,
    DTM_PASSPORTEXPIRY_DATE,
    DTM_PASSPORT_ISSUED_DATE,
    t5.str_Ident,
    t6.str_Ident,
    t8.lng_Agency_Id_Nmbr,
    t9.str_Agency_Name,
    Domain,
    booking_status,
    Pax_Status,
    flown_status,
    booking_date,
    booking_timestamp,
    keywords,
     PAYMENT_METHOD,
    STR_GL_CARD_NMBR,
    FIRST_6_DIGITS,
    LAST_4_DIGITS,
    STR_GL_PAYMENTS_PAYER,
    t27.STR_POSTAL_CODE,
    t27.STR_ADDR1,
    t27.STR_ADDR2,
    t27.STR_CITY,
    t27.STR_TEL,
    email_domain,
    email_domain_final,
    email_flag_suspected,
    promo
-- having Domain = '1. Mailnesia'

;