create or replace view ANALYTICS_DEV.INFLIGHT_SALES.VW_INFLIGHT_REVENUE(
	AIRLINE_CODE,
	DEPARTURE_AIRPORT_CODE,
	ARRIVAL_AIRPORT_CODE,
	NDOD,
	ROUTE,
	FLIGHT_NUMBER,
	TAILNUMBER,
	FLIGHT_DATE_INFL,
	FLIGHT_DATE_INFL_UTC,
	ORDER_LOCAL_DATE,
	ORDER_STANDARD_DATE,
	KEY,
	ITEM_NAME,
	PRODUCT_CODE,
	PRODUCT_GROUP,
	ORDER_ID,
	ORDER_IDENTIFIER,
	QUANTITY,
	PRICE,
	BASE,
	TAX_INFO,
	TAX,
	DISCOUNT,
	DISCOUNT_REASON,
	TOTAL_GROSS,
	CURRENCY_CODE,
	ORDER_TOTAL,
	NETCHARGE
) as


with main as
(
Select 'F8' as airline_code,
infl.departure_airport_code,
infl.arrival_airport_code,
CASE WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YQB') OR (TRIM(departure_airport_code) = 'YQB' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYQB'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYUL'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYOW'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YYG') OR (TRIM(departure_airport_code) = 'YYG' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYYG'
WHEN (TRIM(departure_airport_code) = 'YSJ' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YSJ') THEN 'YSJYYZ'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YSJ') OR (TRIM(departure_airport_code) = 'YSJ' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYSJ'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYYZ'
WHEN (TRIM(departure_airport_code) = 'YYG' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YYG') THEN 'YYGYYZ'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYKF'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YYG') OR (TRIM(departure_airport_code) = 'YYG' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYYG'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YXU') OR (TRIM(departure_airport_code) = 'YXU' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYXU'
WHEN (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'YQG') OR (TRIM(departure_airport_code) = 'YQG' AND TRIM(arrival_airport_code) = 'YHZ') THEN 'YHZYQG'
WHEN (TRIM(departure_airport_code) = 'YDF' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YDF') THEN 'YDFYKF'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YXE') OR (TRIM(departure_airport_code) = 'YXE' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYXE'
WHEN (TRIM(departure_airport_code) = 'YXE' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YXE') THEN 'YXEYYC'
WHEN (TRIM(departure_airport_code) = 'YQR' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YQR') THEN 'YQRYWG'
WHEN (TRIM(departure_airport_code) = 'YQT' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YQT') THEN 'YQTYWG'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YQR') OR (TRIM(departure_airport_code) = 'YQR' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYQR'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YXE') OR (TRIM(departure_airport_code) = 'YXE' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYXE'
WHEN (TRIM(departure_airport_code) = 'YQT' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YQT') THEN 'YQTYYZ'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YQT') OR (TRIM(departure_airport_code) = 'YQT' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYQT'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYWG'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYYC'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YXE') OR (TRIM(departure_airport_code) = 'YXE' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYXE'
WHEN (TRIM(departure_airport_code) = 'YQR' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YQR') THEN 'YQRYVR'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YXU') OR (TRIM(departure_airport_code) = 'YXU' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYXU'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYWG'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYYZ'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYWG'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYWG'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYXX'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YWG') OR (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYWG'
WHEN (TRIM(departure_airport_code) = 'YWG' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YWG') THEN 'YWGYYJ'
WHEN (TRIM(departure_airport_code) = 'YQR' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YQR') THEN 'YQRYYZ'
WHEN (TRIM(departure_airport_code) = 'YXE' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YXE') THEN 'YXEYYZ'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYYJ'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYYC'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYVR'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYYJ'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYYC'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YQU') OR (TRIM(departure_airport_code) = 'YQU' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYQU'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YXS') OR (TRIM(departure_airport_code) = 'YXS' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYXS'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YLW') OR (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYLW'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YKA') OR (TRIM(departure_airport_code) = 'YKA' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYKA'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YXS') OR (TRIM(departure_airport_code) = 'YXS' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYXS'
WHEN (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YXX') THEN 'YXXYYC'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYYC'
WHEN (TRIM(departure_airport_code) = 'YQU' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YQU') THEN 'YQUYVR'
WHEN (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YYC') THEN 'YYCYYJ'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYXX'
WHEN (TRIM(departure_airport_code) = 'YQQ' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YQQ') THEN 'YQQYYC'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYVR'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYYJ'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YQQ') OR (TRIM(departure_airport_code) = 'YQQ' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYQQ'
WHEN (TRIM(departure_airport_code) = 'YMM' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YMM') THEN 'YMMYVR'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYYZ'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYOW'
WHEN (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YUL') THEN 'YULYYZ'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYUL'
WHEN (TRIM(departure_airport_code) = 'YQG' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YQG') THEN 'YQGYUL'
WHEN (TRIM(departure_airport_code) = 'YMM' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YMM') THEN 'YMMYYZ'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYYC'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYKF'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYYZ'
WHEN (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YYC') THEN 'YYCYYZ'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYOW'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYYC'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYUL'
WHEN (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YUL') THEN 'YULYYC'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YLW') OR (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYLW'
WHEN (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'YQB') OR (TRIM(departure_airport_code) = 'YQB' AND TRIM(arrival_airport_code) = 'YEG') THEN 'YEGYQB'
WHEN (TRIM(departure_airport_code) = 'YQU' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YQU') THEN 'YQUYYZ'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYYZ'
WHEN (TRIM(departure_airport_code) = 'YQG' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YQG') THEN 'YQGYVR'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYXX'
WHEN (TRIM(departure_airport_code) = 'YLW' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YLW') THEN 'YLWYOW'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YXU') OR (TRIM(departure_airport_code) = 'YXU' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYXU'
WHEN (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YXX') THEN 'YXXYYZ'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYVR'
WHEN (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YKF') THEN 'YKFYYJ'
WHEN (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YVR') THEN 'YVRYYZ'
WHEN (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'YYJ') THEN 'YYJYYZ'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYXX'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYVR'
WHEN (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'YYJ') OR (TRIM(departure_airport_code) = 'YYJ' AND TRIM(arrival_airport_code) = 'YOW') THEN 'YOWYYJ'
WHEN (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'YUL') THEN 'YULYXX'
WHEN (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'YUL') THEN 'YULYVR'
WHEN (TRIM(departure_airport_code) = 'YXU' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'YXU') THEN 'YXUYYC'
WHEN (TRIM(departure_airport_code) = 'CUN' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'CUN') THEN 'CUNYKF'
WHEN (TRIM(departure_airport_code) = 'CUN' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'CUN') THEN 'CUNYYZ'
WHEN (TRIM(departure_airport_code) = 'CUN' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'CUN') THEN 'CUNYOW'
WHEN (TRIM(departure_airport_code) = 'SJD' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'SJD') THEN 'SJDYXX'
WHEN (TRIM(departure_airport_code) = 'SJD' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'SJD') THEN 'SJDYVR'
WHEN (TRIM(departure_airport_code) = 'SJD' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'SJD') THEN 'SJDYEG'
WHEN (TRIM(departure_airport_code) = 'PVR' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'PVR') THEN 'PVRYXX'
WHEN (TRIM(departure_airport_code) = 'PVR' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'PVR') THEN 'PVRYVR'
WHEN (TRIM(departure_airport_code) = 'PVR' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'PVR') THEN 'PVRYEG'
WHEN (TRIM(departure_airport_code) = 'SFO' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'SFO') THEN 'SFOYVR'
WHEN (TRIM(departure_airport_code) = 'BUR' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'BUR') THEN 'BURYVR'
WHEN (TRIM(departure_airport_code) = 'LAX' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'LAX') THEN 'LAXYVR'
WHEN (TRIM(departure_airport_code) = 'SFO' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'SFO') THEN 'SFOYEG'
WHEN (TRIM(departure_airport_code) = 'BUR' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'BUR') THEN 'BURYEG'
WHEN (TRIM(departure_airport_code) = 'LAX' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'LAX') THEN 'LAXYEG'
WHEN (TRIM(departure_airport_code) = 'SFB' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'SFB') THEN 'SFBYKF'
WHEN (TRIM(departure_airport_code) = 'SFB' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'SFB') THEN 'SFBYYZ'
WHEN (TRIM(departure_airport_code) = 'PSP' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'PSP') THEN 'PSPYVR'
WHEN (TRIM(departure_airport_code) = 'SFB' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'SFB') THEN 'SFBYOW'
WHEN (TRIM(departure_airport_code) = 'FLL' AND TRIM(arrival_airport_code) = 'YKF') OR (TRIM(departure_airport_code) = 'YKF' AND TRIM(arrival_airport_code) = 'FLL') THEN 'FLLYKF'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YQL') OR (TRIM(departure_airport_code) = 'YQL' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYQL'
WHEN (TRIM(departure_airport_code) = 'FLL' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'FLL') THEN 'FLLYYZ'
WHEN (TRIM(departure_airport_code) = 'SFB' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'SFB') THEN 'SFBYUL'
WHEN (TRIM(departure_airport_code) = 'AZA' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'AZA') THEN 'AZAYYC'
WHEN (TRIM(departure_airport_code) = 'AZA' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'AZA') THEN 'AZAYVR'
WHEN (TRIM(departure_airport_code) = 'FLL' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'FLL') THEN 'FLLYOW'
WHEN (TRIM(departure_airport_code) = 'PSP' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'PSP') THEN 'PSPYEG'
WHEN (TRIM(departure_airport_code) = 'AZA' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'AZA') THEN 'AZAYEG'
WHEN (TRIM(departure_airport_code) = 'FLL' AND TRIM(arrival_airport_code) = 'YUL') OR (TRIM(departure_airport_code) = 'YUL' AND TRIM(arrival_airport_code) = 'FLL') THEN 'FLLYUL'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYEG'
WHEN (TRIM(departure_airport_code) = 'SFB' AND TRIM(arrival_airport_code) = 'YHZ') OR (TRIM(departure_airport_code) = 'YHZ' AND TRIM(arrival_airport_code) = 'SFB') THEN 'SFBYHZ'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YXS') OR (TRIM(departure_airport_code) = 'YXS' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYXS'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YQG') OR (TRIM(departure_airport_code) = 'YQG' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYQG'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YMM') OR (TRIM(departure_airport_code) = 'YMM' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYMM'
WHEN (TRIM(departure_airport_code) = 'TUS' AND TRIM(arrival_airport_code) = 'YXU') OR (TRIM(departure_airport_code) = 'YXU' AND TRIM(arrival_airport_code) = 'TUS') THEN 'TUSYXU'
WHEN (TRIM(departure_airport_code) = 'AZA' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'AZA') THEN 'AZAYYZ'
WHEN (TRIM(departure_airport_code) = 'PSP' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'PSP') THEN 'PSPYYZ'
WHEN (TRIM(departure_airport_code) = 'JFK' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'JFK') THEN 'JFKYYZ'
WHEN (TRIM(departure_airport_code) = 'ORD' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'ORD') THEN 'ORDYYZ'
WHEN (TRIM(departure_airport_code) = 'BNA' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'BNA') THEN 'BNAYYZ'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YXX') OR (TRIM(departure_airport_code) = 'YXX' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYXX'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYVR'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YYC') OR (TRIM(departure_airport_code) = 'YYC' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYYC'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYEG'
WHEN (TRIM(departure_airport_code) = 'DEN' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'DEN') THEN 'DENYYZ'
WHEN (TRIM(departure_airport_code) = 'ANC' AND TRIM(arrival_airport_code) = 'YVR') OR (TRIM(departure_airport_code) = 'YVR' AND TRIM(arrival_airport_code) = 'ANC') THEN 'ANCYVR'
WHEN (TRIM(departure_airport_code) = 'BNA' AND TRIM(arrival_airport_code) = 'YEG') OR (TRIM(departure_airport_code) = 'YEG' AND TRIM(arrival_airport_code) = 'BNA') THEN 'BNAYEG'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYYZ'
WHEN (TRIM(departure_airport_code) = 'LAS' AND TRIM(arrival_airport_code) = 'YOW') OR (TRIM(departure_airport_code) = 'YOW' AND TRIM(arrival_airport_code) = 'LAS') THEN 'LASYOW'
WHEN (TRIM(departure_airport_code) = 'ATL' AND TRIM(arrival_airport_code) = 'YYZ') OR (TRIM(departure_airport_code) = 'YYZ' AND TRIM(arrival_airport_code) = 'ATL') THEN 'ATLYYZ'
ELSE NULL END as NDOD,
CONCAT(departure_airport_code,'-',arrival_airport_code) as route,
flight_number,
tailnumber,
CONCAT(substr(departure_local_datetime,7,4),'-',substr(departure_local_datetime,1,2),'-',substr(departure_local_datetime,4,2)) flight_date_infl,
CONCAT(substr(departure_standard_datetime,7,4),'-',substr(departure_standard_datetime,1,2),'-',substr(departure_standard_datetime,4,2)) flight_date_infl_utc,
CONCAT(SUBSTR(od.order_local_datatime,7,4),'-',substr(od.order_local_datatime,1,2),'-',substr(od.order_local_datatime,4,2)) as order_local_date,
CONCAT(SUBSTR(od.order_standard_datetime,7,4),'-',substr(od.order_standard_datetime,1,2),'-',substr(od.order_standard_datetime,4,2)) as order_standard_date,
concat(a.flight_number,'-',order_local_date,'-',infl.departure_airport_code,'-',infl.arrival_airport_code,'-',r.tailnumber) as key,
p.item_name,
p.product_code,
p.product_group,
od.order_id,
infl.order_identifier,
SUM(quantity) quantity,
SUM(infl.price_amount) as price,
sum(base_amount) as base,
tax_info_identifier as tax_info,
sum(TAX_AMOUNT) as tax,
sum(discount_amount) as discount,
discount_reason_identifier as discount_reason,
SUM(total_gross_amount) as total_gross,
infl.currency_code,
SUM(quantity*total_gross_amount) as Order_total,
SUM(total_gross_amount-discount_amount) as netcharge
from INFLIGHT_SALES_DATAMART_UAT.FACTS.LIFE_REPORT_FLIGHTS_FACT as infl
left join INFLIGHT_SALES_DATAMART_UAT.dimensions.aircraft_dim as r
    on infl.aircraft_identifier = r.aircraft_identifier
left join inflight_sales_datamart_uat.dimensions.airline_flight_dim as a 
    on infl.airline_flight_identifier = a.airline_flight_identifier
left join inflight_sales_datamart_uat.dimensions.order_dim od
    on infl.order_identifier = od.order_identifier
left join inflight_sales_datamart_uat.dimensions.product_dim p
    on infl.product_identifier = p.product_identifier
where substr(departure_local_datetime,7,4) >= '2023'
group by airline_code,
infl.departure_airport_code,
infl.arrival_airport_code,
NDOD,
route,
flight_number,
tailnumber,
flight_date_infl,
flight_date_infl_utc,
order_local_date,
order_standard_date,
key,
p.item_name,
p.product_code,
p.product_group,
od.order_id,
infl.order_identifier,
tax_info,
discount_reason,
infl.currency_code
)

select *
from main
;