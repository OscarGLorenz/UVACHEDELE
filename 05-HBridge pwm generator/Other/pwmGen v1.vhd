-- Based on Scott Larson PWM generator

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwmGenerator IS
	GENERIC(
		sys_clk		: INTEGER := 12_000_000;
		pwm_freq	: INTEGER := 10_000;
	);
	PORT(
		clk         : IN std_logic;
		reset       : IN std_logic;
		enable		: IN std_logic;
		speed    	: IN unsigned(7 DOWNTO 0);
		
		dir1		: OUT std_logic;
		dir2		: OUT std_logic;
		pwm			: OUT std_logic;
	);
END pwmGenerator;

ARCHITECTURE Behavioural OF pwmGenerator IS
	CONSTANT pwm_period : INTEGER := sys_clk/pwm_freq;     						--number of clocks in one pwm period
	SIGNAL pwm_count 	: INTEGER RANGE 0 to pwm_period - 1 := (OTHERS => 0);   --period counter
	SIGNAL half_duty    : INTEGER RANGE 0 TO pwm_period/2 := (OTHERS => 0); 	--number of clocks in 1/2 duty cycle
BEGIN

PROCESS(clk, reset) BEGIN
    IF(reset = '1') THEN           			--asynchronous reset
		pwm_count <= (OTHERS => 0);      	--clear counter
		pwm <= (OTHERS => '0');             --clear pwm output
    ELSIF(clk'EVENT AND clk = '1') THEN   	--rising system clock edge
		IF enable = '1' THEN
			half_duty <= speed * pwm_period/512;
			
			IF(pwm_count = pwm_period - 1) THEN  	--end of period reached
				pwm_count <= 0;                  	--reset counter
			ELSE                                    --end of period not reached
				count <= count + 1;           		--increment counter
			END IF;
	
			IF(pwm_count = half_duty) THEN          --phase's falling edge reached
				pwm <= '0';                         --deassert the pwm output
			ELSIF(count = period - half_duty) THEN  --phase's rising edge reached
				pwm <= '1';                         --assert the pwm output
			END IF;
		ELSE
			pwm <= '0';
		END IF;
    END IF;
END PROCESS;

dir1 <= '1' WHEN enable = '1' ELSE '0';
dir2 <= '0';

END Behavioural;