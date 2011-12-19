param($data)

if(-not $data)
{
	throw 'Takes data in the form @(@(x1, y1), @(x2, y2), @(x3, y3))';
}

$data |% {
	if(-not ($_ -is [array]))
	{
		throw "$_ was not a valid item of data: expected an array with X & Y coordinates, got a $($_.GetType())";
	}
	if(-not ($_.Count -eq 2))
	{
		throw "$_ was not a valid item of data: expected an array with X & Y coordinates, got an array of size $($_.Count)";
	}
}

filter Sum([scriptblock] $sequence)
{
	Begin {
		$accumulator = 0;
		
		if(-not $sequence)
		{
			$sequence = { $_; }
		}
	}

	Process {
		$accumulator += & $sequence $_;
	}
	
	End {
		$accumulator;
	}
}

filter Test($quotient, $constant)
{
	$x = $_[0];
	$realY = $_[1];
	$guessedY = $quotient * $x + $constant;
	$error = ($guessedY - $realY);
	"(X,Y) of ($x,$realY) guessed ($x, $guessedY) with error $error";
}

$count = $data.Count;
$sumX = $data | Sum { $_[0] };
$sumY = $data | Sum { $_[1] };
$sumXY = $data | Sum { $_[0] * $_[1] };
$sumXSquared = $data | Sum { $_[0] * $_[0] };

$quotient = (($count * $sumXY)- ($sumX * $sumY))/(($count * $sumXSquared)-($sumX * $sumX));
$constant = ($sumY / $count) - ($sumX * $quotient / $count);

"Y = ${quotient}X + $constant";
$data | Test $quotient $constant;
