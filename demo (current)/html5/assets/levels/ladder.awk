BEGIN {
  FS = ",";
ORS=","
}
{
for (i=1; i<81; i++) 
if (($i==4604)||($i==604)){print "603";} #blue ladder
else if (($i==4605)||($i==605)){print "604";} #seil
else if (($i==4603)||($i==603)){print "602";} #gelbe leiter
else if (($i==6277)||($i==2277)){print "2276";} #schlüssel und türen
else if (($i==6278)||($i==2278)){print "2277";} #
else if (($i==6583)||($i==2583)){print "2582";} #
else if (($i==6584)||($i==2584)){print "2583";} #
else if (($i==4510)||($i==510)){print "509";} # sollte der durchhüpfbare boden am levelanfang sein.
else print "0"; 

printf "\n";

}
END {

}

#remove tiles but no ladders or strings 603/604

