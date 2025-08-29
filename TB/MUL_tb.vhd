library IEEE;
LIBRARY std;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
USE std.textio.ALL;
use IEEE.std_logic_textio.all;  

ENTITY MUL_tb IS
END ENTITY MUL_tb;





ARCHITECTURE with_files OF MUL_tb IS

 COMPONENT MUL IS
	GENERIC( N: integer := 4);
PORT( A: IN signed(N-1 DOWNTO 0);
		  B: IN signed(N-1 DOWNTO 0);
		  mode,CLK,RST: IN std_logic;
		  m : OUT signed(N-1 DOWNTO 0);
		  r : OUT signed(N-1 DOWNTO 0);
		  VALID:  OUT std_logic;
		  BUSY:   OUT  std_logic);
END COMPONENT MUL;
  FOR dut: MUL USE ENTITY WORK.MUL (MUL);  
	
	SIGNAL	  A_tb:  signed(3 DOWNTO 0);
	SIGNAL	  B_tb:  signed(3 DOWNTO 0);
	SIGNAL	  mode_tb,CLK_tb,RST_tb: std_logic;
	SIGNAL   VALID_tb,BUSY_tb : std_logic;
	SIGNAL   m_tb,r_tb: signed(3 DOWNTO 0);
	
	
  BEGIN
	dut: MUL PORT MAP (A_tb,B_tb,mode_tb,CLK_tb,RST_tb,m_tb,r_tb,VALID_tb,BUSY_tb);
	  
	
	clock_p: PROCESS IS
		BEGIN
			CLK_tb <= '0', '1' AFTER 5 ns;
			WAIT FOR 10 ns;
	END PROCESS clock_p; 
		
	pd: PROCESS IS
		FILE vectors_f: text OPEN READ_MODE IS "C:\Users\asus\OneDrive\Desktop\ITI - Digital IC Design\VHDL _ Dr.Watheq\Project\RTL\TEST_CASES.txt";
		FILE results_f: text OPEN WRITE_MODE IS "C:\Users\asus\OneDrive\Desktop\ITI - Digital IC Design\VHDL _ Dr.Watheq\Project\RTL\Results_TEST_CASES.txt";
		
		VARIABLE L, res_l: line;
		VARIABLE RST_v : std_logic;
		VARIABLE A_v: std_logic_vector (4-1 DOWNTO 0);
		VARIABLE B_v: std_logic_vector (4-1 DOWNTO 0);
		VARIABLE mode_v: std_logic;
		VARIABLE pause_1: time;
		VARIABLE pause_2 : time;
		VARIABLE pause_3 : time;
		VARIABLE busy_1 : std_logic;
		VARIABLE busy_2 : std_logic;
		VARIABLE valid_1 : std_logic;
		VARIABLE valid_2 : std_logic;
		VARIABLE m_v: std_logic_vector (3 DOWNTO 0);
		VARIABLE r_v: std_logic_vector (3 DOWNTO 0);
		VARIABLE flag_1: std_logic;
		VARIABLE flag_2: std_logic;
		VARIABLE m_logic_std: std_logic_vector (3 DOWNTO 0);
		VARIABLE r_logic_std: std_logic_vector (3 DOWNTO 0);
		
		BEGIN
		RST_tb <= '0';    
		A_tb <= "0000";
		B_tb <= "0000";
		mode_tb <= '0';
		WAIT FOR 3 ns;
		
		

			--test cases for MUL
			WHILE NOT endfile (vectors_f) LOOP
				READLINE (vectors_f, L);
				READ (L, RST_v);
				READ (L, A_v);
				READ (L, B_v);
				READ (L, mode_v);
				READ (L, pause_1);
				READ (L, busy_1);
				READ (L, valid_1);
				READ (L, pause_2);
				READ (L, m_v);
				READ (L, r_v);
				READ (L, busy_2);
				READ (L, valid_2);
				READ (L, pause_3);
				------------------- assign values to signals ----------- 
				RST_tb <= RST_v;    
				A_tb <= signed(A_v);
				B_tb <= signed(B_v);
				mode_tb <= mode_v;
				WAIT FOR pause_1;
				
					IF (BUSY_tb = busy_1) AND (VALID_tb = valid_1)  THEN
						flag_1 := '1';
					ELSE
						flag_1 := '0';
					END IF;
				WAIT FOR pause_2;
			
			
			IF (m_tb = signed(m_v)) AND (r_tb = signed(r_v)) AND (busy_2 = BUSY_tb) AND (valid_2= VALID_tb) THEN
					 	flag_2 := '1';
					 	m_logic_std := std_logic_vector(m_tb);
					 	r_logic_std := std_logic_vector(r_tb);
					ELSE
						flag_2 := '0';
						m_logic_std := std_logic_vector(m_tb);
					 	r_logic_std := std_logic_vector(r_tb);
					END IF;
				WAIT FOR pause_3;
				
				WRITE (res_l, string'("Time is now : "));
				WRITE (res_l, NOW);
				WRITE (res_l, string'(" RST = "));
				WRITE (res_l, RST_tb);
				WRITE (res_l, string'(".,A = "));
				WRITE (res_l, A_v);
				WRITE (res_l, string'(".,B = "));
				WRITE (res_l, B_v);
				WRITE (res_l, string'(".,mode = "));
				WRITE (res_l, mode_v);
				WRITE (res_l, string'(", Expected m in binary = "));
				WRITE (res_l, m_v);
				WRITE (res_l, string'(", Expected r in binary = "));
				WRITE (res_l, r_v);
				WRITE (res_l, string'(", Actual m in binary = "));
	    		WRITE (res_l, m_logic_std);
				WRITE (res_l, string'(", Actual r in binary = "));
	     	WRITE (res_l, r_logic_std);
				
			
			IF flag_1 = '1' AND flag_2 = '1'      THEN	
				WRITE (res_l, string'(". Test Passed !"));
			ELSE
				WRITE (res_l, string'(". Test Failed !"));
			END IF;
			WRITELINE (results_f,res_l);
			
		END LOOP;

		WAIT;	
		END PROCESS pd;
END ARCHITECTURE with_files;


