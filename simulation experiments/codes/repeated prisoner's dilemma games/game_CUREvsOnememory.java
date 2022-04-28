

import java.io.BufferedReader;
import java.io.*;
import java.nio.charset.Charset;
import java.util.List;
import java.util.ArrayList;

import com.csvreader.CsvWriter;

public class game_CUREvsOnememory {

	public static void main(String[] args) throws IOException {

		// TODO Auto-generated method stub
		int round =1000000,times =1000;
		double[] p = {0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99};
		boolean decision_1, decision_2, decision_3, decision_4;
		double score_1, score_2,score_3,score_4;
		int length = p.length;
		int size = (int)Math.pow(length, 4);
		double[] score_CURE= new double[size],score_onememory= new double[size];
		int num=0;
		int retime=1;
		double[][] repeatscore_CURE = new double[size][retime],repeatscore_onememory= new double[size][retime];
		String[] colNamestest = {"CURE","allOneMemory"};
		File filetest = createFileAndColName("C:\\payoff\\", "CURE-MemOne_01_R=3_delta=1.csv", colNamestest);

		double[][] strategy = new double[size][4];

		int l=0;
		for(int i=0;i<length;i++)
			for(int j=0;j<length;j++)
				for(int h=0;h<length;h++)
					for(int k=0;k<length;k++)
						{
						strategy[l][0] = p[i];
						strategy[l][1] = p[j];
						strategy[l][2] = p[h];
						strategy[l][3] = p[k];
						l++;
						}

		for(int repeat=0;repeat<retime;repeat++){
			score_CURE= new double[size];
			score_onememory= new double[size];

		for(int i=0;i<size;i++)
		{
			List<String> listtest = new ArrayList<String>();
			List<String> listtest1 = new ArrayList<String>();
			List<List<String>> listtest2 = new ArrayList<>();
			score_3=0;
			score_4=0;
			for(int j=0;j<times;j++)
			{
				CURE player1 = new CURE();
				onememorystrategy player2 = new onememorystrategy();
				score_1 =0;
				score_2 =0;

				player1.decision = true;
				if(Math.random()<0.5)
					player2.decision=true;
				else
					player2.decision=false;

				for(int k=0;k<round;k++)
				{
					decision_3 = player1.decision;
					decision_4 = player2.decision;

					score_1 += player1.CURE_score(decision_3, decision_4);
					score_2 += player2.onememorystrategy_score(decision_4, decision_3);


					decision_1 = player1.CURE_decision(decision_3, decision_4);
					decision_2 = player2.onememorystrategy_decision(decision_4,decision_3,strategy[i]);

					player1.decision = decision_1;
					player2.decision = decision_2;


				}
				System.out.println(num);
				num++;
				score_1 = score_1/(double)round;
				score_2 = score_2/(double)round;
				score_3 +=score_1;
				score_4 += score_2;

			}
			score_CURE[i] = score_3/times;
			score_onememory[i] = score_4/times;

			listtest1.add(""+score_CURE[i]);
			listtest1.add(""+score_onememory[i]);

			appendDate(filetest, listtest1);
			System.out.println(listtest1+" "+score_CURE[i]+" "+score_onememory[i]);
		}

			for(int j=0;j<size;j++)
			{
			repeatscore_CURE[j][repeat] = score_CURE[j];
			repeatscore_onememory[j][repeat] = score_onememory[j];
			}
		}

	}


    public static File createFileAndColName(String filePath, String fileName,  String[] colNames){
        File csvFile = new File(filePath, fileName);
        PrintWriter pw = null;
        try {
            pw = new PrintWriter(csvFile, "GBK");
            StringBuffer sb = new StringBuffer();
            for(int i=0; i<colNames.length; i++){
                if( i<colNames.length-1 )
                    sb.append(colNames[i]+",");
                else
                    sb.append(colNames[i]+"\r\n");

            }
            pw.print(sb.toString());
            pw.flush();
            pw.close();
            return csvFile;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public static boolean appendDate(File csvFile, List<String> data){
        try {

            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(csvFile, true), "GBK"), 1024);
            StringBuffer sb = new StringBuffer();
                for(int j=0; j<data.size(); j++){
                    if(j<data.size()-1)
                        sb.append(data.get(j)+",");
                    else
                    { sb.append(data.get(j)+"\r\n");

                    }


                if(j%1000==0)
                    bw.flush();
            } bw.write(sb.toString());
            bw.flush();
            bw.close();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
