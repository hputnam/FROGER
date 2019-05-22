BEGIN {
    print "chrBase\tchr\tbase\tstrand\tcoverage\tfreqC\tfreqT"
}

{
    coverage=$5 + $6
    freqT=(100 - $4)/100.0
    freqC=$4/100.0
    printf "%s.%s\t%s\t%s\t%s\t%d\t%0.2f\t%0.2f\n",
           $1, $2, $1, $2, "F", coverage, freqC, freqT 
}
