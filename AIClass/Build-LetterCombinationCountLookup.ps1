param($sourceFile,
	[int] $k = 4,
	[hashtable] $counts)

function Increment-Counts([string] $text, $k, [hashtable] $counts)
{
	$sequences = $text.Length - $k;
	if($sequences -gt 0)
	{
		0 .. $sequences |% {
			$sequence = $text.SubString($_, $k);
			if($sequence.ToLower() -ne 'keys') # Hacky bug fix so that it doesn't overwrite the inbuilt .Keys property.
			{
				$counts[$sequence]++;
			}
		}
	}
}

if($counts -eq $null)
{
	$counts = @{};
}

Get-Content $sourceFile | %{
	Increment-Counts $_ $k $counts;
}

$counts;
