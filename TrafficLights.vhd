library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity TrafficLights is
generic(ClockFrequencyHz : integer);
port(
    clock         : in std_logic;
    reset        : in std_logic; -- Negative reset
    RedN    : out std_logic;
    YellowN : out std_logic;
    GreenN  : out std_logic;
    RedW     : out std_logic;
    YellowW  : out std_logic;
    GreenW   : out std_logic);
end entity;
 
architecture rtl of TrafficLights is
 
    -- Enumerated type declaration and state signal declaration
    type t_State is (NorthNext, StartNorth, North, StopNorth,
                        WestNext, StartWest, West, StopWest);
    signal State : t_State;
 
    -- Counter for counting clock periods, 1 minute max
    signal Counter : integer range 0 to ClockFrequencyHz * 60;
 
begin
 
    process(clock) is
    begin
        if rising_edge(clock) then
            if reset = '0' then
                -- Reset values
                State   <= NorthNext;
                Counter <= 0;
                RedN    <= '1';
                YellowN <= '0';
                GreenN  <= '0';
                RedW     <= '1';
                YellowW  <= '0';
                GreenW   <= '0';
 
            else
                -- Default values
                RedN    <= '0';
                YellowN <= '0';
                GreenN  <= '0';
                RedW     <= '0';
                YellowW  <= '0';
                GreenW   <= '0';
 
                Counter <= Counter + 1;
 
                case State is
 
                    -- Red in all directions
                    when NorthNext =>
                        RedN <= '1';
                        RedW  <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= StartNorth;
                        end if;
 
                    -- Red and yellow in north/south direction
                    when StartNorth =>
						RedN		<= '1';
                        YellowN <= '1';
                        RedW     <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= North;
                        end if;
 
                    -- Green in north/south direction
                    when North =>
                        GreenN <= '1';
                        RedW    <= '1';
                        -- If 1 minute has passed
                        if Counter = ClockFrequencyHz * 60 -1 then
                            Counter <= 0;
                            State   <= StopNorth;
                        end if;
 
                    -- Yellow in north/south direction
                    when StopNorth =>
                        YellowN <= '1';
                        RedW     <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= WestNext;
                        end if;
 
                    -- Red in all directions
                    when WestNext =>
                        RedN <= '1';
                        RedW  <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= StartWest;
                        end if;
 
                    -- Red and yellow in west/east direction
                    when StartWest =>
                        RedN   <= '1';
                        RedW    <= '1';
                        YellowW <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= West;
                        end if;
 
                    -- Green in west/east direction
                    when West =>
                        RedN  <= '1';
                        GreenW <= '1';
                        -- If 1 minute has passed
                        if Counter = ClockFrequencyHz * 60 -1 then
                            Counter <= 0;
                            State   <= StopWest;
                        end if;
 
                    -- Yellow in west/east direction
                    when StopWest =>
                        reset   <= '1';
                        YellowW <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= NorthNext;
                        end if;
 
                end case;
 
            end if;
        end if;
    end process;
 
end architecture;