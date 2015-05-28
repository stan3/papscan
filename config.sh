
# output files begin with this
FILE_PREFIX="$(date +%d-%b-%Y_%H%M%S)"

function upload() {
  local i
  local cmd
  for i in $FILE_PREFIX*; do
    cmd="put \"$i\"" 
    [ -n "$1" ] && cmd="$cmd \"$1\""
    smbclient //aniene/scanned -U guest% -c "$cmd"
  done
}

#SGDEV="$(scsidetect.py aic7xxx 5 FUJITSU fi-4220Cdj)"
#if [ -z "$SGDEV" ]; then
#  die "Couldn't find scanner"
#fi
#SCANDEV="fujitsu:$SGDEV"
SCANDEV=fujitsu:fi-6230dj:43873

# magic file for sub commands to increment number of adf scans in
export ADF_COUNT_FILE="$HOME/adf.count"

# documentation for bash case statements can be found here;
# http://www.tldp.org/LDP/abs/html/testbranch.html

case "$PRESET" in
  "1") # not used
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Lineart \
        --sleeptimer 5 --page-height 297 \
        --resolution 150 \
	--pdfgroup group --scan-script plain
    upload
  ;;
  "2")
    my_scanadf -d $SCANDEV --source "ADF Duplex" --mode Lineart \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
                 --duplex both --pdfgroup group --scan-script plain
    upload
  ;;
  "3")
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
		 --pdfgroup single --scan-script monochrome
    upload
  ;;
  "4")
    my_scanadf -d $SCANDEV --source "ADF Duplex" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
                 --duplex both --pdfgroup group2 --scan-script monochrome
    upload
  ;;
  "5")
    my_scanadf -d $SCANDEV --source Flatbed --mode Lineart \
                 --sleeptimer 5 \
                 --resolution 150 -e 1 \
		 --scan-script plain
    upload
  ;;
  "6")
    my_scanadf -d $SCANDEV --source Flatbed --mode Color \
                 --sleeptimer 5 \
                 --resolution 150 -e 1 \
		 --scan-script plain
    upload
  ;;
  "7")
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 200 \
		 --pdfgroup group --scan-script monochrome
    upload
  ;;
  "&")
    read -p 'Enter name: ' NAME
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 200 \
		 --pdfgroup group --scan-script monochrome
    upload "$NAME.pdf"
  ;;
  "r")
    my_scanadf -d $SCANDEV --source "ADF Duplex" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
                 --duplex both --pdfgroup group --scan-script plain
    upload
  ;;
  "8")
    my_scanadf -d $SCANDEV --source "ADF Duplex" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 200 \
                 --duplex both --pdfgroup group --scan-script monochrome
    upload
  ;;
  "9" )
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
		 --pdfgroup group --scan-script monochrome.py
    upload
  ;;
  "x")
    my_scanadf -d $SCANDEV --source Flatbed -e 5 --mode Color \
                 --sleeptimer 5 \
        --resolution 150 \
	--pdfgroup group --scan-script monochrome
    upload
  ;;
  "y")
    my_scanadf -d $SCANDEV --source Flatbed --mode Gray \
                 --sleeptimer 5 \
                 --resolution 150 -e 1 \
		 --scan-script plain
    pdf2ps $FILE_PREFIX.pdf - | lpr
  ;;
  "z")
    # scan to printer
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
                 --resolution 150 \
		 --pdfgroup group --scan-script plain
    pdf2ps $FILE_PREFIX.pdf - | lp -
  ;;
  "t")
    my_scanadf -d $SCANDEV --source "ADF Duplex" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
        --resolution 150 --duplex both \
	--pdfgroup group --scan-script monochrome.py
    upload
  ;;
  "g")
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Gray \
                 --sleeptimer 5 --page-height 297 \
        --resolution 150 \
	--pdfgroup group --scan-script monochrome.py
    upload
  ;;
  "b")
    my_scanadf -d $SCANDEV --source "Flatbed" --mode Gray \
                 --sleeptimer 5 \
                 --resolution 150 -e 1 \
		 --pdfgroup group --scan-script monochrome
    upload
  ;;
  "n")
    my_scanadf -d $SCANDEV --source "ADF Front" --mode Color \
        --sleeptimer 5 --page-height 297 \
        --resolution 150 \
	--pdfgroup group --scan-script plain
    upload
  ;;
  "q")
    read -p 'Enter to shutdown, n then enter to cancel: ' line
    # sudoers config: %admin ALL=(ALL) NOPASSWD: /sbin/halt
    [ -z "$line" ] && sudo /sbin/halt -p
  ;;
  * )
    echo Unknown preset $PRESET
  ;;
esac

