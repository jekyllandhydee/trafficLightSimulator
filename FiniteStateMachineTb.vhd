library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity FiniteStateMachineTb is
end entity;
 
architecture sim of FiniteStateMachineTb is
 
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
 
    signal clock         : std_logic := '1';
    signal reset        : std_logic := '0';
    signal RedN    : std_logic;
    signal YellowN : std_logic;
    signal GreenN  : std_logic;
    signal RedW     : std_logic;
    signal YellowW  : std_logic;
    signal GreenW   : std_logic;
 
begin
 
    -- The Device Under Test (DUT)
    i_TrafficLights : entity work.TrafficLights(rtl)
    generic map(ClockFrequencyHz => ClockFrequencyHz)
    port map (
        clock         => clock,
        reset        => reset,
        RedN    => RedN,
        YellowN => YellowN,
        GreenN  => GreenN,
        RedW     => RedW,
        YellowW  => YellowW,
        GreenW   => GreenW);
 
    -- Process for generating clock
    clock <= not clock after ClockPeriod / 2;
 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(clock);
        wait until rising_edge(clock);
 
        -- Take the DUT out of reset
        reset <= '1';
 
        wait;
    end process;
 
end architecture;