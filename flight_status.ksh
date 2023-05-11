#!/usr/bin/bash

flight_status() { 
  curl --silent --stderr - "https://mobile.flightview.com/TrackByRoute.aspx?view=detail&al=$1&fn=$2&dpdat=$(date +%Y%m%d)" |
  html2text | grep -A19 "Status" ;
};

flight_status $1 $2
