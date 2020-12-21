
/* ----------------------------------------------------------------------------
Function: btc_fnc_delay_createAgent

Description:
    Create agent when all previous agents have been created. btc_delay_createagent define the time (in second) when the agent will be created. Since https://feedback.bistudio.com/T155634 this function use units and not agents.

Parameters:
    _agentType - Type of agents to create. [Array]
    _pos - Position of creation. [Array]
    _special - Agent placement special. [String]
    _city - City where the animal is created. [Object]

Returns:

Examples:
    (begin example)
        ["Sheep_random_F", getPosATL player] call btc_fnc_delay_createAgent;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

btc_delay_createUnit = btc_delay_createUnit + 0.1;

[{
    params [
        ["_agentType", "", [""]],
        ["_pos", [0, 0, 0], [[]]],
        ["_special", "CAN_COLLIDE", [""]],
        ["_city", objNull, [objNull]]
    ];

    private _group = createGroup [civilian, true];
    _group setVariable ["btc_city", _city];
    private _agent = _group createUnit [_agentType, _pos, [], 0, _special];
    _agent setVariable ["BIS_fnc_animalBehaviour_disable", true];
    _agent disableAI "RADIOPROTOCOL";
    _agent disableAI "FSM";
    _agent disableAI "AIMINGERROR";
    _agent disableAI "SUPPRESSION";
    _agent disableAI "AUTOTARGET";
    _agent disableAI "TARGET";

    if !(isNull _city) then {
        _pos = getPos _city;
    };
    [_agent, _pos, (_city getVariable ["radius", 100])/2, 4] call CBA_fnc_taskPatrol;

    btc_delay_createUnit = btc_delay_createUnit - 0.1;
}, _this, btc_delay_createUnit - 0.01] call CBA_fnc_waitAndExecute;
