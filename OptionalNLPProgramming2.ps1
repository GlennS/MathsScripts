param([hashtable] $weightings,
	[array] $data = (./OptionalNLPProgramming2Data.ps1),
	[int] $smoothing = 1)

function Normalize-Weightings([hashtable] $weightings, [int] $smoothing)
{
	$results = @{};
	$total = [float] (($weightings.Values | Measure-Object -sum).Sum);
	$total += $weightings.Count * $smoothing;
	
	$weightings.Keys |% {
		$results[$_] = ([float] $weightings[$_] + $smoothing) / $total;
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
		return $results;;
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

$noMatchProbability = ([float] $smoothing) / $weightings.Count;
$dataInColumns = Transpose $data;

$firstColumn, $remainingColumns = $dataInColumns;
$orderedColumns = UnScramble-Columns @(, $firstColumn) $remainingColumns; # Comma prevents array flattening;

Write-Host "Columns $($orderedColumns.Count)";
$rows = Transpose $orderedColumns;
Write-Host "Rows $($rows.Count)";

$rows |% {
	Write-Host ([String]::Join('', $_));
}
