param([float] $x, [float] $mean, [float] $standardDev, [float] $variance)

if(-not $standardDev)
{
	$standardDev = [Math]::Sqrt($variance);
}
else
{
	$variance = [Math]::Pow($standardDev, 2);
}

$xMinusMu = $x - $mean;
$xMinusMuOverSigma = $xMinusMu / $standardDev;

# Z represents the difference of X from the mean as a proportion of standard deviation.
$Z = $xMinusMuOverSigma;

$eToTheZSq = [Math]::Exp([Math]::Pow($Z, 2));

$tau = 2 * [Math]::Pi;
$sigmaSquaredtau = $variance * $tau;

1 / [Math]::Sqrt($sigmaSquaredtau * $eToTheZSq);
