param([float] $x1, [float] $x2, [float] $mean, [float] $standardDev, [float] $variance)

if(-not $standardDev)
{
	$standardDev = [Math]::Sqrt($variance);
}
else
{
	$variance = [Math]::Pow($standardDev, 2);
}
