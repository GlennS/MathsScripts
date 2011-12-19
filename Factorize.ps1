param($inputNum)

function Factorize($num)
{
	$limit = [Math]::Sqrt($num);
	for($i = 2; $i -le $limit; $i++)
	{
		if($num % $i -eq 0)
		{
			return @(Factorize ($num/$i)) + $i;
		}
	}
	return @($num);
}

Factorize $inputNum;
