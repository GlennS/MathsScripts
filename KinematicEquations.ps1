param(
	$distance,
	$acc,
	$time,
	$vi, # initial velocity
	$vf # final velocity
)

function Round($num)
{
	[Math]::Round($num, 1)
}

function HalfATSquared($acc, $time)
{
	($acc * $time * $time * 0.5);
}

if($distance -eq $null)
{
	if($acc -eq $null)
	{
		$distance = ($vi + $vf) * 0.5 * $time;
	}
	elseif($time -eq $null)
	{
		$distance = (($vf * $vf) - ($vi * $vi)) / (2 * $acc);
	}
	elseif($vi -eq $null)
	{
		$distance = ($vf * $time) - (HalfATSquared $acc $time)
	}
	elseif($vf -eq $null)
	{
		$distance = ($vi * $time) + (HalfATSquared $acc $time)
	}
	else
	{
		$distance = 0.5 * ($vi + $vf) * $time;
	}
}
if($acc -eq $null)
{
	if($time -eq $null)
	{
		$acc = (($vf * $vf) - ($vi * $vi)) / (2 * $distance)
	}
	elseif($vi -eq $null)
	{
		$acc = 2 * ($vf - ($distance / $time)) / $time
	}
	elseif($vf -eq $null)
	{
		$acc = 2 * (($distance / $time) - $vi) / $time
	}
	else
	{
		$acc = ($vf - $vi) / $time;
	}
}
if($time -eq $null)
{
	if($vi -eq $null)
	{
		$time = (./QuadraticFormula.ps1 $acc (-2 * $vf) (2 * $distance))[0];
	}
	elseif($vf -eq $null)
	{
		$time = (./QuadraticFormula.ps1 $acc (-2 * $vi) (-2 * $distance))[0];
	}
	else
	{
		$time = ($vf - $vi) / $acc;
	}
}
if($vi -eq $null)
{
	if($vf -eq $null)
	{
		$vi = ($distance - (HalfATSquared $acc $time)) / $time;
	}
	else
	{
		$vi = $vf - ($acc * $time);
	}
}
if($vf -eq $null)
{
	$vf = $vi + ($acc * $time);
}

"Distance $([Math]::Round($distance, 1)) m";
"Acceleration $([Math]::Round($acc, 1)) m/s/s";
"Time $([Math]::Round($time, 1)) s";
"Initial Velocity $([Math]::Round($vi, 1)) m/s";
"Final Velocity $([Math]::Round($vf, 1)) m/s";
