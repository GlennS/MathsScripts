param($speed1, $speed2, $distance, $totalHours)

function RoundedMiles($mph, $hours)
{
	[Math]::Round($mph * $hours);
}

function RoundedMinutes($hours)
{
	[Math]::Round(60 * $hours);
}

$hours2 = ($distance - ($speed1 * $totalHours))/($speed2 - $speed1);
$distance2 = RoundedMiles $speed2 $hours2;
$mins2 = RoundedMinutes $hours2;


$hours1 = $totalHours - $hours2;
$distance1 = RoundedMiles $speed1 $hours1;
$mins1 = RoundedMinutes $hours1;

"$mins1 minutes at $speed1 mph = $distance1 miles";
"$mins2 minutes at $speed2 mph = $distance2 miles";
