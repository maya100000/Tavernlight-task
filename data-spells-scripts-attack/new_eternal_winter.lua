
-- Set the delay for each animation frame
local animationDelay = 180

-- Initialize a table to store combat objects
local combat = {}

-- Define the custom area pattern for the spell
AREA_CUSTOM9 = {
	{
		{0, 1, 1, 0, 0, 0, 0, 0, 0},
		{1, 1, 0, 0, 2, 0, 0, 1, 1},
		{0, 1, 1, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 1, 0, 0, 0, 0}
	},
	{
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 1, 1, 0, 0, 0, 1, 1, 0},
		{1, 1, 0, 0, 2, 0, 0, 1, 1},
		{0, 1, 1, 1, 1, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 0, 0, 0, 0}
	},
	{
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 1, 1, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 0, 0, 0, 1, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
	},
	{
		{0, 0, 0, 0, 1, 0, 0, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 1, 1, 1, 0, 0, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0}
	},
	{
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 1, 1, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 1, 1, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0}
	}
}


-- Loop to create and configure combat objects for each animation frame
for k = 1, 3 do
    for i = 1, #AREA_CUSTOM9 do
        -- Define a function to calculate formula values for damage
        function onGetFormulaValues(player, level, magicLevel)
            local min = (level / 5) + (magicLevel * 5.5) + 25
            local max = (level / 5) + (magicLevel * 11) + 50
            return -min, -max
        end

        -- Calculate the index for the combat object
        local combatIndex = (k - 1) * #AREA_CUSTOM9 + i
        -- Create a new combat object
        combat[combatIndex] = Combat()

        -- Set parameters for the combat object
        combat[combatIndex]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
        combat[combatIndex]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
        combat[combatIndex]:setArea(createCombatArea(AREA_CUSTOM9[i]))
        combat[combatIndex]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
    end
end

-- Function to execute the callback for a specific combat object
function executeCallback(p, i)
    if not p.creature then
        return false
    end
    if not p.creature:isPlayer() then
        return false
    end
    p.combat[i]:execute(p.creature, p.variant)
end

-- Function called when the spell is cast
function onCastSpell(creature, variant)
    local p = {creature = creature, variant = variant, combat = combat}

    for i = 1, #combat do
        if i == 1 then
            -- Execute the combat immediately for the first object
            combat[i]:execute(creature, variant)
        else
            -- Schedule the execution of the callback for subsequent objects
            addEvent(executeCallback, (animationDelay * (i - 1)), p, i)
        end
    end

    return true
end
