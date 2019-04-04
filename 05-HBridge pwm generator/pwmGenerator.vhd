-- 8-bit PWM generator

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwmGenerator IS
	GENERIC(
		pwm_res		: INTEGER := 8;
		prescaler 	: INTEGER := 2
	);
	PORT(
		clk         : IN STD_LOGIC;
		reset       : IN STD_LOGIC;
		enable		  : IN STD_LOGIC;
		speed      	: IN STD_LOGIC_VECTOR(pwm_res - 1 DOWNTO 0);
		dir		    	: IN STD_LOGIC;

		dir1		: OUT STD_LOGIC;
		dir2		: OUT STD_LOGIC;
		pwm			: OUT STD_LOGIC
	);
END pwmGenerator;

ARCHITECTURE Behavioural OF pwmGenerator IS
	SIGNAL prescaler_count		: INTEGER RANGE 0 to (prescaler - 1) := 0;
	SIGNAL prescaler_signal		: STD_LOGIC := '0';
	SIGNAL pwm_count 			: INTEGER RANGE 0 to 255 := 0;  --pwm counter
	SIGNAL pwm_count_dir		: STD_LOGIC := '0';							--pwm counter direction
BEGIN

pwmPrescaler:
PROCESS(clk, reset) BEGIN
    IF reset = '1' THEN           			--asynchronous reset
		prescaler_count <= 0;				--reset sampler counter
		prescaler_signal <= '0';			--reset pwm increment
    ELSIF clk'EVENT AND clk = '1' THEN   	--rising system clock edge
		IF enable = '1' THEN				--pwm module enabled
			IF prescaler_count = (prescaler - 1) THEN 	--end of sampler period reached
				prescaler_count <= 0;                	--clear sampler counter
				prescaler_signal <= '1';				--increment pwm counter
			ELSE                                    	--end of sampler period not reached
				prescaler_count <= prescaler_count + 1; --increment sampler counter
				prescaler_signal <= '0';				--do not increment pwm counter
			END IF;
		END IF;
	END IF;
END PROCESS;

pwmCounter:
PROCESS(clk, reset) BEGIN
    IF reset = '1' THEN           		--asynchronous reset
		pwm_count <= 0;					--reset counter
		pwm_count_dir <= '0';			--reset counter direction
    ELSIF clk'EVENT AND clk = '1' THEN	--rising system clock edge
		IF enable = '1' THEN				--pwm module enabled
			IF prescaler_signal = '1' THEN
				IF pwm_count_dir = '1' THEN
					IF pwm_count = (256 - 2) THEN
						pwm_count_dir <= '0';
						pwm_count <= pwm_count - 1;
					ELSE
						pwm_count <= pwm_count + 1;
					END IF;
				ELSE
					IF pwm_count = 0 THEN
						pwm_count_dir <= '1';
						pwm_count <= pwm_count + 1;
					ELSE
						pwm_count <= pwm_count - 1;
					END IF;
				END IF;
			END IF;
		END IF;
    END IF;
END PROCESS;

pwm <= '1' WHEN enable = '1' AND (pwm_count < speed) ELSE '0';
dir1 <= '1' WHEN enable = '1' AND dir = '0' ELSE '0';
dir2 <= '1' WHEN enable = '1' AND dir = '1' ELSE '0';

END Behavioural;
