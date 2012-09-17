from itertools import combinations_with_replacement, product, groupby

def rotate(iterable, shift):
    return iterable[shift:] + iterable[:shift]

# Assume no two dice can have the same number on them. 
    # This lets us ignore draw conditions, which would make the problem messier.
# Assume dice cannot have repeated numbers on them.
    # We can simulate repeated numbers by assigning weightings.
    
def generate_dice(max_side, num_dice):
    assignments = product(range(num_dice + 1), repeat=max_side)
    for assignment in assignments:
        dice = [(die, side) for (die, side) in sorted(zip(assignment, range(1, max_side + 1))) 
            if die > 0] # die number 0 means 'don't allocate this side'
        
        dice = groupby(dice, key=lambda die_with_side: die_with_side[0])
        
        dice = [[side for (die, side) in group] for key, group in dice]
        dice = [sides for sides in dice if len(sides) > 0]
        
        if len(dice) > 2: # 1 die scenario doesn't work, and 2 dice scenario just isn't very interesting.
            yield dice
        
def transitive_victory_possible(dice):
    def victory_possible(first, second):
        return max(first) > min(second)

    for first, second in zip(dice, rotate(dice, 1)):
        if not victory_possible(first, second):
            return False
    return True
    
def transitive_victory_probabilites(dice):
    def equations_for_pair(first, second):
        for side in first:
            smaller_second_sides = ["p" + str(side_b) for side_b in second if side_b < side]
            if smaller_second_sides:
                "p{side}*(second_sides)".format(
                    side=side, 
                    second_sides="+".join(smaller_second_sides))
            # do the same for sides which are bigger, except with a negative sign
        # all the sides should sum to 1
        
    def probabilities_sum_to_one(die):
        return "+".join(["p" + str(side) for side in die]) + "=1"
        
    
    equations = [equations_for_pair(first, second) for (first, second )in zip(dice, rotate(dice, 1))]
    equations += [probabilities_sum_to_one(die) for die in dice]
    # scipy.optimize.fsolve(func, x0)

for dice in generate_dice(6, 4):
    if transitive_victory_possible(dice):
        print(dice)
