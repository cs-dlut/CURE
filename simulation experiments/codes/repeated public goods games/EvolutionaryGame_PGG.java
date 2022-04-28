
import java.util.List;
import PGG.evolution.DataInter;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;


public class EvolutionaryGame_PGG {	
	public static void main(String args[])
	{
    	long begin = System.currentTimeMillis();//计时器
    	EvolutionaryGame_PGG onegame = new EvolutionaryGame_PGG();//从.db3数据库中读入14642-14642个策略的收益；
		try{
		onegame.playgame();//演化博弈的主体程序--主要算法
		}catch(IOException e)
		{
			e.printStackTrace();
		}
		System.out.println("Game over");//打印“博弈结束”
		System.out.println("GAME total time: " + (System.currentTimeMillis() - begin)/1000);//打印“总用时”
	}

	int iii=DataInter.iii;

	public EvolutionaryGame_PGG() 
	{
	    try {
	    	File csv1 = new File("C:\\IPGGpayoff_001n_05d_1.01r.csv"); // CSV文件路径
			@SuppressWarnings("resource")
			BufferedReader br = new BufferedReader(new FileReader(csv1));
			String line = "";
			int row = 0;
			while ((line = br.readLine()) != null && row < iii) 
			{		
				String[] data = line.split(",");
				for(int j=0;j<iii;j++)
		    	{
					DataInter.payoff[row][j] = Double.parseDouble(data[j]);
		    	}
				row++;
				System.out.println("reading strategy's " + row +"payoff");
			}
	    	
			File csv2 = new File("C:\\IPGGcoopeRate_001n_05d_1.01r.csv"); 
			@SuppressWarnings("resource")
			BufferedReader br2 = new BufferedReader(new FileReader(csv2));
			line = "";
			row = 0;
			while ((line = br2.readLine()) != null && row < iii) 
			{
				String[] data = line.split(",");
				for(int j=0;j<iii;j++)
		    	{
					DataInter.cooperate[row][j] = Double.parseDouble(data[j]);
		    	}
				row++;
				System.out.println("reading strategy's " + row +"cooperation");
			}
	    	
	    } 
	    catch ( Exception e ) {
	      System.err.println( e.getClass().getName() + ": " + e.getMessage() );
	      System.exit(0);
	    }
	}

	void playgame() throws IOException
	{

		File ratioFile = new File("C:\\result", "IPGG-evolution-ratio-1.01r_mu.csv");  
		File payoffFile = new File("C:\\\result", "IPGG-evolution-payoff-1.01r_mu.csv");
		File coopeFile = new File("C:\\result", "IPGG-evolution-CoopeRate-1.01r_mu.csv");
		
		int generation = 1000000;
		int g=0;
		List<String> list_ratio1 = new ArrayList<String>();
		for(int i=0;i<iii;i++)
		{
			list_ratio1.add("stra."+String.valueOf(i+1));
		}
		saveDateToCsv(ratioFile,"name",list_ratio1);

		list_ratio1.clear();
		
		for(int i=0;i<iii;i++)
		{
			
			DataInter.ratio[i] =(1.0/Double.valueOf(iii));
			list_ratio1.add(Double.toString((double)DataInter.ratio[i]));
		}
		saveDateToCsv(ratioFile,"initial",list_ratio1);
		list_ratio1.clear();
		list_ratio1.add("ave_Payoff");
		saveDateToCsv(payoffFile,"generation",list_ratio1);
		list_ratio1.clear();
		list_ratio1.add("ave_CoopeRate");
		saveDateToCsv(coopeFile,"generation",list_ratio1);
		list_ratio1.clear();
		
//evolution
		while(g<=generation)
		{		
			
			double ave_fitness_revised=0;
			double ave_fitness_real=0;
			double ave_cooperate=0;
			double Nmin=1,Nmax=0;
			
			if(g%1000==0)
			{
		    	System.out.println("g= "+g);
			}
			List<String> list_ratio = new ArrayList<String>();
			List<String> list_payoff = new ArrayList<String>();
			List<String> list_cooperate = new ArrayList<String>();

			for (int i = 0; i < iii; ++i) 
			{
					DataInter.fitness[i] = 0;
					DataInter.CoopeRate[i] = 0;
					for (int j = 0; j < DataInter.iii; j++)
					{
						DataInter.fitness[i] += DataInter.ratio[j] * DataInter.payoff[i][j];//i的期望收益
						DataInter.CoopeRate[i] += DataInter.ratio[j] * DataInter.cooperate[i][j];//i的期望合作率
					}
					
					if (Nmin > DataInter.fitness[i])
					{
						Nmin = DataInter.fitness[i];
					}
					 if (Nmax < DataInter.fitness[i])
					 {
						Nmax = DataInter.fitness[i];
					 }
					
					ave_fitness_real += DataInter.ratio[i] * DataInter.fitness[i];	
					ave_cooperate += DataInter.ratio[i] * DataInter.CoopeRate[i];
			}	
	
			for(int i=0;i<iii;i++)
			{
				DataInter.fitness[i]=(DataInter.fitness[i]-Nmin)/(Nmax-Nmin);
				ave_fitness_revised += DataInter.ratio[i] * DataInter.fitness[i];

			}
		
			for(int i=0;i<iii;i++)
			{
				DataInter.ratio[i] = DataInter.ratio[i]*DataInter.fitness[i]/ave_fitness_revised;

				if(g<10000||g%100 == 0)
					list_ratio.add(Double.toString((double)DataInter.ratio[i]));
			}
			if(g<10000||g%100 == 0)
			{
				list_payoff.add(Double.toString(ave_fitness_real));
				list_cooperate.add(Double.toString(ave_cooperate));
				saveDateToCsv(ratioFile,String.valueOf(g),list_ratio);
				saveDateToCsv(payoffFile,String.valueOf(g),list_payoff);
				saveDateToCsv(coopeFile,String.valueOf(g),list_cooperate);

			}
			if(g>=0 && Math.random()<0.1)
				mutation(g);
			g++;
		}
	}
//mutation
	public void mutation(int mut_g) throws IOException
	{
		int num_mut = (int)(Math.random()*(iii));
		float sum_mut=0;
		for(int i=0;i<iii-1;i++)
			{
			DataInter.ratio[i] = (double) (DataInter.ratio[i]*0.999);
			sum_mut += DataInter.ratio[i];
			}
		DataInter.ratio[num_mut] =(double) (DataInter.ratio[num_mut]+0.001);
	}
//output
	  public static boolean saveDateToCsv(File csvFile,String gen,List<String> data){         
		    try {  
		          
		        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(csvFile, true), "GBK"), 1024);  
		        StringBuffer sb = new StringBuffer();  
		        sb.append(gen+",");
		        for(int j=0; j<data.size(); j++){                      
		            if(j<data.size()-1)  
		                sb.append(data.get(j)+",");  
		            else  
		            { 
		                sb.append(data.get(j)+"\r\n");                        
		            }                          
		             
		            if(j%1000==0)  
		                bw.flush();  
		        } 
		        bw.write(sb.toString());             
		        bw.flush();  
		        bw.close();  
		          
		        return true;              
		    } catch (Exception e) {  
		        e.printStackTrace();  
		    }                 
		    return false;  
		}
}
