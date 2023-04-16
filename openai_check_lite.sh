#!/bin/bash

support_area="AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BO BA BW BR BN BG BF CV CA CL CO KM CG CR CI HR CY CZ DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT VA HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX FM MD MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PS PA PG PY PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA KR ES LK SR SE CH TW TZ TH TL TG TO TT TN TR TV UG UA AE GB US UY VU ZM"

openai_checker() {
	echo "Checking IPv${ip_ver}"
	header_back=$(curl -SsI${ip_ver} "https://chat.openai.com/")
	curl_status_code=$?
	if [ "${curl_status_code}" != "0" ]; then
		echo -e "\033[31m[Network Error]\033[0m Maybe your VPS unsupport IPv${ip_ver} | Curl Error code: ${curl_status_code}"
	elif echo "${header_back}" | grep -q "text/plain"; then
		echo -e "\033[31m[BLOCKED]\033[0m Your IPv${ip_ver} is BLOCKED!"
	else
		cloudflare_back=$(curl -Ss${ip_ver} "https://chat.openai.com/cdn-cgi/trace")
		cloudflare_area=$(echo "${cloudflare_back}" | awk -F '=' '/loc=/{print $2}')
		cloudflare_ip=$(echo "${cloudflare_back}" | awk -F '=' '/ip=/{print $2}')
		if echo "${support_area}" | grep -q "\<${cloudflare_area}\>"; then
			echo -e "\033[32m[Unlocked]\033[0m IPv${ip_ver} - (${cloudflare_ip}) | Region: \033[32m${cloudflare_area}\033[0m"
		else
			echo -e "\033[33m[Unsupported]\033[0m IPv${ip_ver} - (${cloudflare_ip}) | Region: \033[33m${cloudflare_area}\033[0m | Not support OpenAI at this time"
		fi
	fi
}

ip_ver=4
openai_checker
ip_ver=6
openai_checker
