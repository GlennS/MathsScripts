param([float] $x, [float] $mean, [float] $standardDev, [float] $variance)

if(-not $standardDev)
{
	$standardDev = [Math]::Sqrt($variance);
}

(1 / ($standardDev * [Math]::Sqrt(2 * [Math]::Pi))) * [Math]::Exp(-0.5 * [Math]::Pow(($x - $mean)/$standardDev, 2));
