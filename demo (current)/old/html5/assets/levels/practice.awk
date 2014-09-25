BEGIN {
  FS = ",";
ORS=","
}
{
for (i=1; i<81; i++) 
if (($i==4604)||($i==604)||($i==4605)||($i==4605)||($i==605)||($i==4603)||($i==603)||($i==6277)||($i==2277)||($i==6278)||($i==2278)||($i==6583)||($i==2583)||($i==6584)||($i==2584)||($i==4510)||($i==510))print "0";#gets in ladder.awk
else if ($i>4000){print --$i-4000;}
else if ($i>0){print --$i;}
else print $i; 

printf "\n";

}
END {

}

#convert exported data from tmx files exported by tiled to haxeflixel by decreasing every tilemapumber by 1

