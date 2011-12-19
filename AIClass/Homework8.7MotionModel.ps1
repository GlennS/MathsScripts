$timeStep = 4.0;

$angularVelocity = [Math]::Pi / 8.0;
$anglePerStep = $timeStep * $angularVelocity;

$velocity = 10.0;
$velocityPerStep = $timeStep * $velocity;

$steps = 4;

$x = 0.0;
$y = 0.0;
$angle = 0.0;

1..4 |% {
	$x = $x + (([Math]::Cos($angle)) * $velocityPerStep);
	$y = $y + (([Math]::Sin($angle)) * $velocityPerStep);
	$angle = $angle + $anglePerStep;
	
	Write-Host "X $x Y $y Angle $angle";
}
