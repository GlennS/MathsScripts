param($sourceFile,
	[int] $sequenceLength = 4,
	[hashtable] $counts)

function Increment-Counts([string] $text, $sequenceLength, [hashtable] $counts)
{
	$sequences = $text.Length - $sequenceLength;
	if($sequences -gt 0)
	{
		0 .. $sequences |% {
			$sequence = $text.SubString($_, $sequenceLength);
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
	Increment-Counts $_ $sequenceLength $counts;
}

$counts;
