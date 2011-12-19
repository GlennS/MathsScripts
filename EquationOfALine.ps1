param($ax, $ay, $bx, $by)

$yChange = $by - $ay;
"y change $yChange";
$xChange = $bx - $ax;
"x change $xChange";

if($xChange -eq 0)
{
	return "x = $ax";
}

$grad = $yChange / $xChange;
"Gradient $grad";

$yIntercept = $ay - ($grad * $ax);
"y intercept $yIntercept";

"y = ${grad}x + $yIntercept";
