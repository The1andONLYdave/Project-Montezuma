BEGIN {
  FS = ",";
ORS=","
}
{
for (i=1; i<81; i++) 
if (($i==453)||($i==250)){print "0";}
else if ($i>0){print $i;}
else print $i; 

printf "\n";

}
END {

}

#print without -- because ladder.csv is already edited.#2276,603,604,2277,602,2583,2582,509