param([array] $numbers, [switch]$sampled)

function Reduce([array] $numbers, [scriptblock] $reductor)
{
	begin {
		$accumulator = 0;
	}
	process {
		$numbers |% {$accumulator += & $reductor $_};
	}
	end {
		$accumulator;
	}
}

$count = $numbers.Count;
$mean = (Reduce $numbers {$_;}) / $count;

if($sampled)
{
	$count--;
}

$variance = (Reduce $numbers {[Math]::Pow($_ - $mean, 2)}) / $count;
$standardDeviation = [Math]::Sqrt($variance);

"Mean $([Math]::Round($mean, 1))";
"Variance $([Math]::Round($variance, 1))";
"Standard deviation $([Math]::Round($standardDeviation, 1))";
