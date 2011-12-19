param($data)

if(-not $data)
{
	throw 'Takes data in the form @(x1, x2, x3)';
}

$data |% {
	if(-not ($_ -is [int]))
	{
		throw "$_ was not a valid item of data: expected an array of data";
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

$count = $data.Count;
$mu = ($data | Sum) / $count;
$sumXMinusMuSquared = $data | Sum { [Math]::Pow($_ - $mu, 2) };
$sigmaSquared = $sumXMinusMuSquared / $count;

"Mu $mu Sigma squared $sigmaSquared";
