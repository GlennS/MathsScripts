param([hashtable] $counts,
	[array] $data = (./OptionalNLPProgramming2Data.ps1),
	[int] $smoothing = 1)

function Smoothing-Denominator([hashtable] $counts, [int] $smoothing)
{
	$total = [float] (($counts.Values | Measure-Object -sum).Sum);
	$total += $counts.Count * $smoothing;
	$total;
}
	
function Normalize-Weightings([hashtable] $counts, [int] $smoothing)
{
	$results = @{};
	$denominator = Smoothing-Denominator $counts $smoothing;
	
	$counts.Keys |% {
		$normalized = ([float] $counts[$_] + $smoothing) / $denominator
		$results[$_] = $normalized;
	}
	
	$results;
}

function Get-Column([array] $data, [int] $column)
{
	$data |% {
		, $_[$column]; # Powershell will flatten multi-dimensional arrays unless you include this comma.
	}
}

function Transpose([array] $data)
{
	$upperBound = $data[0].Length - 1;
	@(0 .. $upperBound |% {
		, (Get-Column $data $_); # Worst language feature ever.
	})
}

function Likelihood-Sequence($sequence)
{
	if($weightings.ContainsKey($sequence))
	{
		$weightings[$sequence];
	}
	else
	{
		$noMatchProbability;
	}
}

function Likelihood-ColumnPairing($columnA, $columnB)
{
	if($columnA.Length -ne $columnB.Length)
	{
		throw "Columns must be of equal length.";
	}

	$upperLimit = $columnA.Length - 1;
	$likelihood = 1;
	0 .. $upperLimit |% {
		$sequence = $columnA[$_] + $columnB[$_];
		$likelihood *= (Likelihood-Sequence $sequence);
	}
	$likelihood;
}

function AreColumnsEqual([array] $a, [array] $b)
{
	if($a.Length -ne $b.Length)
	{
		return false;
	}
	
	foreach($i in 0 .. ($a.Length - 1))
	{
		if($a[$i] -ne $b[$i])
		{
			return $false;
		}
	}
	$true;
}

# Recursively finds the best match from the remaining unmatched columns and adds it to the start or end of the ordered column list.
function UnScramble-Columns(
	[array] $results, 
	[array] $remainingColumns)
{
	if($remainingColumns.Count -eq 0)
	{
		return $results;
	}

	$highest = 0.0;
	$highest = 0.0;
	$start = $results[0];
	$end = $results[$results.Length - 1];
	
	$newStart = $null;
	$newEnd = $null;
	
	foreach($column in $remainingColumns)
	{
		$startP = Likelihood-ColumnPairing $column $start;
		if($startP -gt $highest)
		{
			$highest = $startP;
			$newStart = $column;
			$newEnd = $null;
		}
		
		$endP = Likelihood-ColumnPairing $end $column;
		if($endP -gt $highest)
		{
			$highest = $endP;
			$newStart = $null;
			$newEnd = $column;
		}
	}
	
	if($newStart)
	{
		UnScramble-Columns (@(, $newStart) + $results) @($remainingColumns | Where { -not (AreColumnsEqual $_ $newStart) });
	}
	elseif($newEnd)
	{
		UnScramble-Columns ($results + , $newEnd) @($remainingColumns | Where { -not (AreColumnsEqual $_ $newEnd) });
	}
	else
	{
		throw "No best match found.";
	}
}

$noMatchProbability = 1.0 / (Smoothing-Denominator $counts $smoothing);
$weightings = Normalize-Weightings $counts $smoothing;

$dataInColumns = Transpose $data;

$firstColumn, $remainingColumns = $dataInColumns;
$orderedColumns = UnScramble-Columns @(, $firstColumn) $remainingColumns; # Comma prevents array flattening;

$rows = Transpose $orderedColumns;

$rows |% {
	Write-Host ([String]::Join('', $_));
}
