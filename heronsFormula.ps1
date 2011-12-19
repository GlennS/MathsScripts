param(
	[float] $a, 
	[float] $b, 
	[float] $c)

$s = ($a + $b + $c)/2
$sa = $s - $a;
$sb = $s - $b;
$sc = $s - $c;

[Math]::Round([Math]::Sqrt($s * $sa * $sb * $sc), 2);
