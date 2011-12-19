param($a, $b, $c)

function ReduceSqrt($sqrtOf)
{
	$factors = ./Factorize.ps1 $sqrtOf;
	
	$accumulator = 1;
	$lastFactor = $null;
	$remaining = @();
	
	$factors |% {
		if($_ -eq $lastFactor)
		{
			$accumulator *= $lastFactor;
			$lastFactor = $null;
		}
		else
		{
			if($lastFactor -ne $null)
			{
				$remaining += $lastFactor;
			}
			$lastFactor = $_;
		}
	}
	if($lastFactor -ne $null)
	{
		$remaining += $lastFactor;
	}
	
	@{Whole = $accumulator; Remaining = $remaining;};
}

function BreakDownSqrt($sqrtOf)
{
	$sqrt = [Math]::Sqrt($sqrtOf);
	if($sqrt.GetType() -eq [int])
	{
		return "$sqrt";
	}
	else
	{
		$reduced = ReduceSqrt $sqrtOf;
		$result = "";
		if($reduced.Whole -ne 1)
		{
			$result += $reduced.Whole;
		}
		if($reduced.Remaining.Count -ge 0)
		{
			$reduced.Remaining |% {
				$result += "rt($_)";
			}
		}
		return $result;
	}
}

function Quadratic($a, $b, $c)
{
	$bSquaredMinus4AC = [Math]::Pow($b, 2)-(4*$a*$c);
	
	"$(-$b)+-$(BreakDownSqrt $bSquaredMinus4AC)";
	('-' * 20);
	"`t$(2*$a)";
}

Quadratic $a $b $c;
