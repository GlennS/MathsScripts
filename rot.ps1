param([string] $inputString, [int] $shift)

function Shift-Char([int] $character, [int] $shift)
{
	$startChar = [int]'a'[0];
	((($character - $startChar) + $shift) % 26) + $startChar;
}

function Shift([string] $inputString, [int] $shift)
{
	begin {
		$accumulator = '';
		$lowerString = $inputString.ToLower();
	}

	process {
		$length = $inputString.Length;
		for($i = 0; $i -lt $length; $i++)
		{
			if($lowerString[$i] -eq ' '[0])
			{
				$accumulator += $lowerString[$i];
			}
			else
			{
				$accumulator += [char](Shift-Char ([int]($lowerString[$i])) $shift);
			}
		}
	}
	
	end	{
		$accumulator;
	}
}

Shift $inputString $shift;
