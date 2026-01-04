forward_ports() {
    (
        function valid_endpoint() {
            REGEX='^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3})$'
            if [[ $1 =~ $REGEX ]]; then
                return 0
            fi
            REGEX='^(([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]):(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3})$'
            if [[ $1 =~ $REGEX ]]; then
                return 0
            fi
            return 1
        }
        i=0
        while true; do
            FW_SRC="FW_SRC${i}"
            FW_DST="FW_DST${i}"
            FW_SRC="${!FW_SRC}"
            FW_DST="${!FW_DST}"
            if ! valid_endpoint "${FW_SRC}" || ! valid_endpoint "${FW_DST}"; then
                if [[ -n $FW_SRC || -n $FW_DST ]]; then
                    echo "ERROR: Invalid forward: FW_SRC${i}=${FW_SRC} or FW_DST${i}=${FW_DST}"
                elif [[ $i -lt 16 ]]; then
                    ((i++))
                    continue
                fi
                break
            fi
            if [[ -z "${FW_SRC}" || -z "${FW_DST}" ]]; then break; fi
            echo "SOCAT: Forward ${FW_SRC} -> ${FW_DST}"
            socat TCP-LISTEN:${FW_SRC},reuseaddr,fork TCP:${FW_DST} &
            ((i++))
        done
    )
}
