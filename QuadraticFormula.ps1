param($a, $b, $c)

$bSquaredMinus4AC = [Math]::Pow($b, 2)-(4*$a*$c);

if($bSquaredMinus4AC -lt 0)	
{
	throw "No real solutions";
}
else
{
	$root = [Math]::Sqrt($bSquaredMinus4AC);
	@(
		((-$b - $root) / (2 * $a)),
		((-$b + $root) / (2 * $a))
	);
}
