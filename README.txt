Andor Budai (2019); 
Eötvös University, Institute of Physics, 1117 Budapest, Hungary; 
email: arandras@caesar.elte.hu


If you want to simulate one light curve -> run lightCurveMove.m

If you want to create a sample -> run simMove.m

If you want to analyse the sample -> run analyse.m


zLinCom.mat -> is used during the calculation of the red shift during the run of the randZ function (see description there).


WHAT WE DID:
We ran the simMove(sz, N, 0) program 499275000 times where sz was 1 (Uniform profile) and created data files called "nameIndex" where Index was a number between 1 and 6657. Repeated the same process with sz=2 (Gaussian profile) and sz=3 (Power-law profile). 

For the data analysis we ran analyse(szTh, 50, 1000, 1000, name) with szTh='j' on the particular "nameIndex" data files, thus getting a datafile containing the statistical data for the Uniform jet profile - known opening angle model. Repeated the same with szTh='d' (Uniform jet profile - known angle difference value), szTh='g' (Gaussian profile - known viewing angle model) and szTh='p' (Power-law profile - known viewing angle model).

FUNCTION TREE:
	1. simMove.m
		a. randZ.m
			*zLinCom.mat [see description in randZ.m] 
		b. lightCurveMove.m
			*brown.m
			*varMeasure.m
				t90.m
	
	2. analyse.m