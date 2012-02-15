param([float] $x, [float] $mean, [float] $standardDev, [float] $variance)

if(-not $standardDev)
{
	$standardDev = [Math]::Sqrt($variance);
}

$xMinusMu = $x - $mean;
$xMinusMuOverSigma = $xMinusMu / $standardDev;
$xMinusMuOverSigmaSq = [Math]::Pow($xMinusMuOverSigma, 2);

$root2Pi = [Math]::Sqrt(2 * [Math]::Pi);
$sigmaRoot2Pi = $standardDev * $root2Pi;

[Math]::Exp(-0.5 * $xMinusMuOverSigmaSq) / $sigmaRoot2Pi
