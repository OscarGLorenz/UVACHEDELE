-- 8-bit PWM generator

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwmGenerator IS
	GENERIC(
		sys_clk		: INTEGER := 12_000_000;
		pwm_freq	: INTEGER := 10_000
	);
	PORT(
		clk         : IN STD_LOGIC;
		reset       : IN STD_LOGIC;
		enable		: IN STD_LOGIC;
		speed    	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dir			: IN STD_LOGIC;
		
		dir1		: OUT STD_LOGIC;
		dir2		: OUT STD_LOGIC;
		pwm			: OUT STD_LOGIC
	);
END pwmGenerator;

ARCHITECTURE Behavioural OF pwmGenerator IS
	CONSTANT sampler_period 	: INTEGER := (sys_clk/pwm_freq)/512;     	--number of clocks in one pwm sampling period
	SIGNAL sampler_count		: INTEGER RANGE 0 to (sampler_period - 1) := 0;
	SIGNAL pwm_increment		: STD_LOGIC := '0';
	SIGNAL pwm_count 			: INTEGER RANGE 0 to 255 := 0;  --pwm counter
	SIGNAL pwm_count_dir		: STD_LOGIC := '0';							--pwm counter direction				
BEGIN

pwmSampler:
PROCESS(clk, reset) BEGIN
    IF(reset = '1') THEN           			--asynchronous reset
		sampler_count <= 0;					--reset sampler counter
		pwm_increment <= '0';				--reset pwm increment
    ELSIF(clk'EVENT AND clk = '1') THEN   	--rising system clock edge
		IF enable = '1' THEN				--pwm module enabled
			IF(sampler_count = sampler_period - 1) THEN --end of sampler period reached
				sampler_count <= 0;                		--clear sampler counter
				pwm_increment <= '1';					--increment pwm counter
			ELSE                                    	--end of sampler period not reached
				sampler_count <= sampler_count + 1;     --increment sampler counter
				pwm_increment <= '0';					--do not increment pwm counter
			END IF;
		END IF;
	END IF;
END PROCESS;

pwmCounter:
PROCESS(clk, reset) BEGIN
    IF(reset = '1') THEN           		--asynchronous reset
		pwm_count <= 0;					--reset counter
		pwm_count_dir <= '0';			--reset counter direction
    ELSIF(clk'EVENT AND clk = '1') THEN	--rising system clock edge
		IF enable = '1' THEN				--pwm module enabled
			IF pwm_increment = '1' THEN  	--end of period reached
				IF pwm_count_dir = '1' THEN --reset counter
					IF pwm_count = 255 THEN
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

pwm <= '1' WHEN enable = '1' AND (pwm_count > speed) ELSE '0';
dir1 <= '1' WHEN enable = '1' AND dir = '0' ELSE '0';
dir2 <= '1' WHEN enable = '1' AND dir = '1' ELSE '0';

END Behavioural;